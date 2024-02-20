import 'package:flutter/material.dart';
import 'package:syrus24/screens/essentials/essentialsScreen.dart';
import 'package:syrus24/screens/userinfo/exportUserinfo.dart';

import './screens/Questionnaire/exportQuestionaire.dart';
import './screens/auth/exportAuth.dart';
import './screens/community/exportCommunity.dart';
import './screens/home/exportHomeScreen.dart';

Route getRoutes(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case MyPhone.routeName:
      return MaterialPageRoute(builder: (context) {
        return MyPhone();
      });
    case MyVerify.routeName:
      return MaterialPageRoute(builder: (context) {
        return MyVerify();
      });
    case QuestionnairePage.routeName:
      return MaterialPageRoute(builder: (context) {
        return QuestionnairePage();
      });
    case HomeScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return HomeScreen();
      });
    case CommunityScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return CommunityScreen();
      });
    case UserInfoScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return UserInfoScreen();
      });
    case EssentialScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return EssentialScreen();
      });
    default:
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          body: Center(
            child: Text('Page not found'),
          ),
        );
      });
  }
}
