import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

const int WebPort = 13579;
// const String ip = "127.0.0.1";

const String ip = "192.168.111.40";
class Header {
  static const String Split = "-||-";
  static const String Success = "Success";
  static const String Failed = "Failed";
}

class Request {
  static const String All = "All";
  static const String SetType = "SetType";
  static const String Analytics = "Model1";
  static const String Intruder = "Model2";
}

String packet(String ReqType, String Other) {
  var Data = {"Type": ReqType, "Other": Other};
  return jsonEncode(Data);
}

String parser(String data) {
  return data.length.toString() + Header.Split + data;
}

Uri webSocket() {
  return Uri.parse("ws:" + ip + ":" + WebPort.toString());
}

void communicate(String packet, Function process) {
  final channel = WebSocketChannel.connect(webSocket());
  channel.sink.add(parser(packet));
  channel.stream.listen((event) async {
    event = event.split(Header.Split)[1];
    var out = jsonDecode(event);
    await process(out);
    channel.sink.close();
  });
}
