import 'dart:convert';
import 'dart:html';
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:iot_dashboard/youtube_player.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:iot_dashboard/constants.dart';
import 'dart:async';
import 'constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:iot_dashboard/Networks.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MainApp extends StatefulWidget {
  MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _controller = SidebarXController(selectedIndex: 0);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IOT Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(
          headline5: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: Scaffold(
        body: Row(
          children: [
            SidebarX(
              controller: _controller,
              theme: SidebarXTheme(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: canvasColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: const TextStyle(color: Colors.white),
                selectedTextStyle: const TextStyle(color: Colors.white),
                itemTextPadding: const EdgeInsets.only(left: 30),
                selectedItemTextPadding: const EdgeInsets.only(left: 30),
                itemDecoration: BoxDecoration(
                  border: Border.all(color: canvasColor),
                ),
                selectedItemDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: actionColor.withOpacity(0.37),
                  ),
                  gradient: const LinearGradient(
                    colors: [accentCanvasColor, canvasColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.28),
                      blurRadius: 30,
                    )
                  ],
                ),
                iconTheme: const IconThemeData(
                  color: Colors.white,
                  size: 20,
                ),
              ),
              extendedTheme: const SidebarXTheme(
                width: 200,
                decoration: BoxDecoration(
                  color: canvasColor,
                ),
                margin: EdgeInsets.only(right: 10),
              ),
              footerDivider: divider,
              headerBuilder: (context, extended) {
                return SizedBox(
                  height: 100,
                  child: Image.asset('assets/logo.png'),
                );
              },
              items: [
                SidebarXItem(
                  icon: Icons.home,
                  label: 'Home',
                  onTap: () {
                    debugPrint('Hello');
                  },
                ),
                const SidebarXItem(
                  icon: Icons.analytics,
                  label: 'Analytics',
                ),
                const SidebarXItem(
                  icon: Icons.toggle_off,
                  label: 'Toggle model',
                ),
                SidebarXItem(
                  icon: Icons.live_tv,
                  label: 'Live',
                  onTap: (){
                    js.context.callMethod('open', ['http://youtube.com/channel/UCe9z1mihw-RBSV3RuXxO0lg/live']);
                  }
                ),

              ],
            ),
            Expanded(
              child: Center(
                child: sideBarNavigator(controller: _controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class sideBarNavigator extends StatefulWidget {
  const sideBarNavigator({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  State<sideBarNavigator> createState() => _sideBarNavigatorState();
}

class _sideBarNavigatorState extends State<sideBarNavigator> {

 int _toggleIndex = 0;



  late String _timeString;
  List<_TodayInCustomerData> todaydata = [
    _TodayInCustomerData('00:00', 35),
    _TodayInCustomerData('1:00', 28),
    _TodayInCustomerData('2:00', 34),
    _TodayInCustomerData('3:00', 32),
    _TodayInCustomerData('4:00', 40)
  ];
 List<_DayWiseCustomerData> dailydata = [];
 List<_MonthlyCustomerData> monthlydata =[];
 List<_YearlyCustomerData> yearlydata =[];
 List<_WeeklyCustomerData> weeklydata =[];
 List<_HourlyCustomerData> hourlydata =[];
  @override
  void initState() {
    communicate(packet(Request.All, ""), Fun);
    _timeString =
        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    Timer.periodic(Duration(minutes: 30), (Timer t) => communicate(packet(Request.All, ""), Fun));
    // getVidId();
    super.initState();
  }
  late String videoID;
  String url = 'http://youtube.com/channel/UCe9z1mihw-RBSV3RuXxO0lg/live';
 void Fun(param){
   // var decoded = jsonDecode(param);
   var data = param['Type'];
   print(data);
   dailydata =[];
   monthlydata = [];
   yearlydata = [];
   weeklydata = [];
   hourlydata = [];
   setState(() {
     for(var i in data['Daily']){
       dailydata.add(_DayWiseCustomerData(i[0].toString(), i[1]));
     }
     for(var i in data['Monthly']){
       monthlydata.add(_MonthlyCustomerData(i[0].toString(), i[1]));
     }
     for(var i in data['Yearly']){
       yearlydata.add(_YearlyCustomerData(i[0].toString(), i[1]));
     }
     for(var i in data['Weekly']){
       weeklydata.add(_WeeklyCustomerData(i[0].toString(), i[1]));
     }
     for(var i in data['Hourly']){
       hourlydata.add(_HourlyCustomerData(i[0].toString(), i[1]));
     }

   });
 }


  void _getCurrentTime() {
    setState(() {
      if (DateTime.now().minute == 0) {
        communicate(packet(Request.All, ""), Fun);
        todaydata.add(_TodayInCustomerData(
            "${DateTime.now().hour} : ${DateTime.now().minute}", 35));
      }
      _timeString =
          "${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}";
    });
  }
  // String? videoId = YoutubePlayer.convertUrlToId("http://youtube.com/channel/UCe9z1mihw-RBSV3RuXxO0lg/live");
  //  YoutubePlayerController _ytcontroller = YoutubePlayerController(
  //   initialVideoId: 'zn2GwbPG-tc',
  //   flags: const YoutubePlayerFlags(
  //     // isLive: true,
  //     autoPlay: true,
  //
  //   ),
  // );


  // YoutubePlayerController _ytcontroller = YoutubePlayerController(
  //   initialVideoId: 'UCe9z1mihw-RBSV3RuXxO0lg',
  //   params: YoutubePlayerParams(// Defining custom playlist
  //     showControls: true,
  //     showFullscreenButton: true,
  //     mute: true,
  //
  //   ),
  // );

  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        switch (widget.controller.selectedIndex) {
          // case 0:
          //   return Text(
          //     'Home',
          //     style: theme.textTheme.headline5,
          //   );
          case 0:
            return Scaffold(
              body: Container(
                color: scaffoldBackgroundColor,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Card(
                        color: canvasColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(
                              //   '  Date : ${datetime.day}/${datetime.month}/${datetime.year}',
                              //   style: TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 20
                              //   ),
                              // ),

                              Text(
                                '   Home',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                              Text(
                                '   ${_timeString}   ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Card(
                                color: canvasColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  height: 250,
                                  width: 400,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'People In : ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '80',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 50,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                elevation: 5,
                              ),
                              Card(
                                color: canvasColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  height: 250,
                                  width: 400,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Total Visited : ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '80',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 50,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                elevation: 5,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Today's visitors : ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  // Chart title
                                  // Enable legend
                                  legend: Legend(isVisible: true),
                                  // Enable tooltip
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <
                                      ChartSeries<_HourlyCustomerData, String>>[
                                    LineSeries<_HourlyCustomerData, String>(
                                        color: canvasColor,
                                        dataSource: hourlydata,
                                        xValueMapper:
                                            (_HourlyCustomerData data, _) =>
                                        data.Time,
                                        yValueMapper:
                                            (_HourlyCustomerData data, _) =>
                                        data.count,
                                        name: 'Count',
                                        // Enable data label
                                        dataLabelSettings:
                                        DataLabelSettings(isVisible: true))
                                  ]),
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          case 1:
            return Scaffold(
              body: Container(
                color: scaffoldBackgroundColor,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Card(
                        color: canvasColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text(
                                '   Analytics',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                              IconButton(onPressed: (){
                                communicate(packet(Request.All, ""), Fun);
                              }, icon: Icon(Icons.refresh,color: Colors.white,)),
                              Text(
                                '   ${_timeString}   ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: DefaultTabController(
                        length: 4,
                        child: Scaffold(
                            body: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(25.0)
                                    ),
                                    child:  TabBar(
                                      indicator: BoxDecoration(
                                          color: canvasColor,
                                          borderRadius:  BorderRadius.circular(25.0)
                                      ) ,
                                      labelColor: Colors.white,
                                      unselectedLabelColor: Colors.black,
                                      tabs: const  [
                                        Tab(text: 'Day Wise',),
                                        Tab(text: 'Weekly',),
                                        Tab(text: 'Monthly',),
                                        Tab(text: 'Yearly',)
                                      ],
                                    ),
                                  ),
                                   Expanded(
                                      child: TabBarView(
                                        children:  [
                                          Center(child: Column(
                                            children: [
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Card(
                                                color: Colors.white,
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SfCartesianChart(
                                                      primaryXAxis: CategoryAxis(),
                                                      // Chart title
                                                      // Enable legend
                                                      legend: Legend(isVisible: true),
                                                      // Enable tooltip
                                                      tooltipBehavior: TooltipBehavior(enable: true),
                                                      series: <
                                                          ChartSeries<_DayWiseCustomerData, String>>[
                                                        LineSeries<_DayWiseCustomerData, String>(
                                                            color: canvasColor,
                                                            dataSource: dailydata,
                                                            xValueMapper:
                                                                (_DayWiseCustomerData data, _) =>
                                                            data.Date,
                                                            yValueMapper:
                                                                (_DayWiseCustomerData data, _) =>
                                                            data.count,
                                                            name: 'Count',
                                                            // Enable data label
                                                            dataLabelSettings:
                                                            DataLabelSettings(isVisible: true))
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          ),),
                                          Center(child: Column(
                                            children: [
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Card(
                                                color: Colors.white,
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SfCartesianChart(
                                                      primaryXAxis: CategoryAxis(),
                                                      // Chart title
                                                      // Enable legend
                                                      legend: Legend(isVisible: true),
                                                      // Enable tooltip
                                                      tooltipBehavior: TooltipBehavior(enable: true),
                                                      series: <
                                                          ChartSeries<_WeeklyCustomerData, String>>[
                                                        LineSeries<_WeeklyCustomerData, String>(
                                                            color: canvasColor,
                                                            dataSource: weeklydata,
                                                            xValueMapper:
                                                                (_WeeklyCustomerData data, _) =>
                                                            data.Day,
                                                            yValueMapper:
                                                                (_WeeklyCustomerData data, _) =>
                                                            data.count,
                                                            name: 'Count',
                                                            // Enable data label
                                                            dataLabelSettings:
                                                            DataLabelSettings(isVisible: true))
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          ),),
                                          Center(child: Column(
                                            children: [
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Card(
                                                color: Colors.white,
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SfCartesianChart(
                                                      primaryXAxis: CategoryAxis(),
                                                      // Chart title
                                                      // Enable legend
                                                      legend: Legend(isVisible: true),
                                                      // Enable tooltip
                                                      tooltipBehavior: TooltipBehavior(enable: true),
                                                      series: <
                                                          ChartSeries<_MonthlyCustomerData, String>>[
                                                        LineSeries<_MonthlyCustomerData, String>(
                                                            color: canvasColor,
                                                            dataSource: monthlydata,
                                                            xValueMapper:
                                                                (_MonthlyCustomerData data, _) =>
                                                            data.month,
                                                            yValueMapper:
                                                                (_MonthlyCustomerData data, _) =>
                                                            data.count,
                                                            name: 'Count',
                                                            // Enable data label
                                                            dataLabelSettings:
                                                            DataLabelSettings(isVisible: true))
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          ),),
                                          Center(child: Column(
                                            children: [
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Card(
                                                color: Colors.white,
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SfCartesianChart(
                                                      primaryXAxis: CategoryAxis(),
                                                      // Chart title
                                                      // Enable legend
                                                      legend: Legend(isVisible: true),
                                                      // Enable tooltip
                                                      tooltipBehavior: TooltipBehavior(enable: true),
                                                      series: <
                                                          ChartSeries<_YearlyCustomerData, String>>[
                                                        LineSeries<_YearlyCustomerData, String>(
                                                            color: canvasColor,
                                                            dataSource: yearlydata,
                                                            xValueMapper:
                                                                (_YearlyCustomerData data, _) =>
                                                            data.year,
                                                            yValueMapper:
                                                                (_YearlyCustomerData data, _) =>
                                                            data.count,
                                                            name: 'Count',
                                                            // Enable data label
                                                            dataLabelSettings:
                                                            DataLabelSettings(isVisible: true))
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          ),),
                                        ],
                                      )
                                  )
                                ],
                              ),
                            )
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          case 2:
            return Scaffold(
              body: Container(
                color: scaffoldBackgroundColor,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Card(
                        color: canvasColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(
                              //   '  Date : ${datetime.day}/${datetime.month}/${datetime.year}',
                              //   style: TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 20
                              //   ),
                              // ),

                              Text(
                                '   Toggle model',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                              Text(
                                '   ${_timeString}   ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ToggleSwitch(
                            minWidth: 90.0,
                            initialLabelIndex: _toggleIndex,
                            cornerRadius: 20.0,
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Colors.white,
                            totalSwitches: 2,
                            labels: ['Day', 'Night'],
                            icons: [Icons.wb_sunny, Icons.nightlight_round],
                            activeBgColors: [[accentCanvasColor, canvasColor],[accentCanvasColor, canvasColor]],
                            onToggle: (index) {
                              print('switched to: $index');
                              setState(() {
                                _toggleIndex = index!;
                                if (_toggleIndex == 1){
                                  communicate(packet(Request.SetType, Request.Intruder), (out){});
                                }
                                else{
                                  communicate(packet(Request.SetType, Request.Analytics), (out){});
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          case 3:
            return Text(
              'Redirected to Youtube!',
              style: theme.textTheme.headline5,
            );
          default:
            return Text(
              'Not found page',
              style: theme.textTheme.headline5,
            );
        }
      },
    );
  }
}

class _TodayInCustomerData {
  _TodayInCustomerData(this.time, this.count);
  final String time;
  final double count;
}
class _DayWiseCustomerData {
  _DayWiseCustomerData(this.Date, this.count);
  final String Date;
  final double count;
}
class _MonthlyCustomerData {
  _MonthlyCustomerData(this.month, this.count);
  final String month;
  final double count;
}

class _YearlyCustomerData {
  _YearlyCustomerData(this.year, this.count);
  final String year;
  final double count;
}
class _WeeklyCustomerData {
  _WeeklyCustomerData(this.Day, this.count);
  final String Day;
  final double count;
}
class _HourlyCustomerData {
  _HourlyCustomerData(this.Time, this.count);
  final String Time;
  final double count;
}


// Scaffold yt = Scaffold(
//   body: Container(
//     color: scaffoldBackgroundColor,
//     child: Column(
//       children: [
//         Expanded(
//           flex: 1,
//           child: Card(
//             color: canvasColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Container(
//               width: double.infinity,
//               height: 50,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Text(
//                   //   '  Date : ${datetime.day}/${datetime.month}/${datetime.year}',
//                   //   style: TextStyle(
//                   //       color: Colors.white,
//                   //       fontSize: 20
//                   //   ),
//                   // ),
//
//                   Text(
//                     '   Live',
//                     style: TextStyle(
//                         color: Colors.white, fontSize: 30),
//                   ),
//                   Text(
//                     '   ${_timeString}   ',
//                     style: TextStyle(
//                         color: Colors.white, fontSize: 20),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           flex: 9,
//           child: Card(
//             color: Colors.white,
//             elevation: 3,
//             child: PlayVideoFromYoutube(),
//           ),
//         )
//       ],
//     ),
//   ),
// );