import 'package:flutter/material.dart';
import 'package:iGerencial/custom_drawer/drawer_user_controller.dart';
import 'package:iGerencial/custom_drawer/home_drawer.dart';
import 'package:iGerencial/screen/boletos/listaBoletos.dart';
import 'package:iGerencial/screen/chamados/chamadosES.dart';
import 'package:iGerencial/screen/chamados/chamadosMG.dart';
import 'package:iGerencial/screen/home/home.dart';

import 'app_theme.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const MyHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = const MyHomePage();
        });
      }
      else if (drawerIndex == DrawerIndex.ChamadosMG) {
        setState(() {
          screenView = ChamadosMG();
        });
      } else if (drawerIndex == DrawerIndex.ChamadosES) {
        setState(() {
          screenView = ChamadosES();
        });
      } else if (drawerIndex == DrawerIndex.ListaBoletos) {
        setState(() {
          screenView = ListaBoletos();
        });
      }
      else {
        //do in your way......
      }
    }
  }
}
