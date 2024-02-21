import 'package:flutter/material.dart';
import 'package:syrus24/games/firstGame.dart';
import 'package:syrus24/games/secondGame.dart';
import 'package:syrus24/screens/chats/chatScreen.dart';
import 'package:syrus24/screens/community/uploadImagesScreen.dart';
import 'package:syrus24/screens/doctorScreen.dart';
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
    case MyDoctorScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return MyDoctorScreen();
      });
    case AddPostScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return AddPostScreen();
      });
    case ChatScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return ChatScreen();
      });
    case FirstGameScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return FirstGameScreen();
      });
    case LetterClickGameScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return LetterClickGameScreen();
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
