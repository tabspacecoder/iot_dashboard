import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:iot_dashboard/constants.dart';
import 'dart:async';
import 'constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset('assets/logo.png'),
                    // child: AssetImage('assets/logo.png'),
                  ),
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
                  icon: Icons.people,
                  label: 'Regulars',
                ),
                const SidebarXItem(
                  icon: Icons.warning_amber_outlined,
                  label: 'Intruders?',
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
  late String _timeString;
  List<_TodayInCustomerData> data = [
    _TodayInCustomerData('00:00', 35),
    _TodayInCustomerData('1:00', 28),
    _TodayInCustomerData('2:00', 34),
    _TodayInCustomerData('3:00', 32),
    _TodayInCustomerData('4:00', 40)
  ];
  @override
  void initState() {
    _timeString =
        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
  }

  void _getCurrentTime() {
    setState(() {
      if (DateTime.now().minute == 0) {
        data.add(_TodayInCustomerData(
            "${DateTime.now().hour} : ${DateTime.now().minute}", 35));
      }
      _timeString =
          "${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}";
    });
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var datetime = DateTime.now();
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
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              // Chart title
                              // Enable legend
                              legend: Legend(isVisible: true),
                              // Enable tooltip
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <
                                  ChartSeries<_TodayInCustomerData, String>>[
                                // SplineSeries(dataSource: data, xValueMapper: (_SalesData sales, _) => sales.year, yValueMapper: (_SalesData sales, _) => sales.sales,name: 'Sales',
                                //     // Enable data label
                                //     dataLabelSettings: DataLabelSettings(isVisible: true)),
                                LineSeries<_TodayInCustomerData, String>(
                                    color: Colors.white,
                                    dataSource: data,
                                    xValueMapper:
                                        (_TodayInCustomerData data, _) =>
                                            data.time,
                                    yValueMapper:
                                        (_TodayInCustomerData data, _) =>
                                            data.count,
                                    name: 'Count',
                                    // Enable data label
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true))
                              ]),
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
                              // Text(
                              //   '  Date : ${datetime.day}/${datetime.month}/${datetime.year}',
                              //   style: TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 20
                              //   ),
                              // ),

                              Text(
                                '   Analytics',
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
                                        Tab(text: 'Daily',),
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
                                              ListTile(
                                                leading: Text('Pick Date : '),
                                                title: Text('date'),
                                              )
                                            ],
                                          ),),
                                          Center(child: Text("Weekly Pages"),),
                                          Center(child: Text('Monthly Page'),),
                                          Center(child: Text('Yearly Page'),)
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
                                '   Regulars',
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
                      child: Column(),
                    )
                  ],
                ),
              ),
            );
          case 3:
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
                                '   Intruders',
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
                      child: Column(),
                    )
                  ],
                ),
              ),
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

ListView l = ListView.builder(
  padding: const EdgeInsets.only(top: 10),
  itemBuilder: (context, index) => Container(
    height: 100,
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 10, right: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Theme.of(context).canvasColor,
      boxShadow: const [BoxShadow()],
    ),
  ),
);

class _TodayInCustomerData {
  _TodayInCustomerData(this.time, this.count);
  final String time;
  final double count;
}
