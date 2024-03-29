import 'package:elearnapp/Core/User.dart';
import 'package:elearnapp/Data/Organization.dart';
import 'package:elearnapp/Model/Draft.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'Register/register2.dart';
import 'Register/register3.dart';
import 'Represents/JoinClass.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    // load current organization details
    Organization.loadCurrentOrganizationDetails().then((val) 
    {
      if (val)
      {
        Future.delayed(const Duration(seconds: 1), () {
          FirebaseAuth.instance
              .currentUser()
              .then((currentUser) 
              {
                if (currentUser == null)
                  Navigator.pushReplacementNamed(context, "/login");
                else 
                {
                  Draft.initialize().then((v) {
                    User.retrieveUserData().then((res) {
                      if (res.teacher && res.subjects.length == 0)
                      {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => Register2Screen()),
                        );
                      } 
                      else if (!res.teacher && res.grade == -1)
                      {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => Register3Screen()),
                        );  
                      } else {
                        getInitialLink().then((link) {
                          print(link);

                          if (link != null)
                          {
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => JoinClassScreen(invite: link)
                              )
                            );
                          } else {
                            Navigator.pushReplacementNamed(context, "/dashboard");
                          }
                        });

                        getLinksStream().listen((link) {
                          try {
                            
                            if (link != null) 
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => JoinClassScreen(invite: link)
                                )
                              );

                          } on FormatException {
                            print("--- A link got here but was invalid");
                          }
                        });
                      }
                    });
                  });
                }
              });    
        });
      } else {
        // exit the program
        SystemNavigator.pop();
      }

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child:  SizedBox(width: 150, child: Image.asset("assets/images/sample_school_logo_white.png"))
        ),
      ),
    );
  }
}