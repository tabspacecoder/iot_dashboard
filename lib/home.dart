import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:iot_dashboard/constants.dart';

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

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
                    child: Image.asset('assets/analytics.png'),
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

class sideBarNavigator extends StatelessWidget {
  const sideBarNavigator({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          // case 0:
          //   return Text(
          //     'Home',
          //     style: theme.textTheme.headline5,
          //   );
          case 0:
            return Scaffold(

              appBar: AppBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text('Home'),
                backgroundColor: canvasColor,
              ),
              body: Container(
                color: scaffoldBackgroundColor,
              ),
            );
          case 1:
            return Text(
              'Search',
              style: theme.textTheme.headline5,
            );
          case 2:
            return Text(
              'People',
              style: theme.textTheme.headline5,
            );
          case 3:
            return Text(
              'Favorites',
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
