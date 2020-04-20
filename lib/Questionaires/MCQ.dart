import 'dart:async';

import 'package:elearnapp/Components/AllQuestionsDisplayItem.dart';
import 'package:elearnapp/Components/MCQAnswerItem.dart';
import 'package:elearnapp/Components/Seperator.dart';
import 'package:flutter/material.dart';

class MCQScreen extends StatefulWidget {
  MCQScreen({Key key}) : super(key: key);

  @override
  _MCQScreenState createState() => _MCQScreenState();
}

class Question
{
  String question = "";
  List<String> answers = [];
  
  Question({String question, List<String> answers})
  {
    this.question = question;
    this.answers = answers;
  }
}

class _MCQScreenState extends State<MCQScreen> {

  int questionsCount = 50;
  int currentQuestionIndex = 0;
  bool showOverview = false;
  bool uploadingAnswers = false;
  bool changingQuestion = false;
  Duration examDuration = Duration(minutes: 30);
  int currentSelection = -1;
  List<int> myAnswers = [];

   List<Question> questions = [
      Question(question: "තාප සන්නායකතාවයේ ඒකකය වන්නේ?", answers: [
        "Something wrong", "Jm-1K-1", "J m-1K-1", "J m-1K-1", "J m-1K-1"
      ]),
      Question(question: "තාප සන්නායකතාවයේ ඒකකය වන්නේ?", answers: [
        "Something wrong", "Jm-1K-1", "J m-1K-1", "J m-1K-1", "J m-1K-1"
      ]),
      Question(question: "තාප සන්නායකතාවයේ ඒකකය වන්නේ?", answers: [
        "Something wrong", "Jm-1K-1", "J m-1K-1", "J m-1K-1", "J m-1K-1"
      ]),
      Question(question: "තාප සන්නායකතාවයේ ඒකකය වන්නේ?", answers: [
        "Something wrong", "Jm-1K-1", "J m-1K-1", "J m-1K-1", "J m-1K-1"
      ]),
      Question(question: "තාප සන්නායකතාවයේ ඒකකය වන්නේ?", answers: [
        "Something wrong", "Jm-1K-1", "J m-1K-1", "J m-1K-1", "J m-1K-1"
      ]),
    ];

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        if (examDuration.inSeconds == 0)
        {
          showOverview = true;
          t.cancel();
        } else {
          examDuration = Duration(seconds: examDuration.inSeconds - 1);
        }
      });
    });

    questionsCount = questions.length;
    myAnswers = new List<int>(questions.length);

    super.initState();
  }

  formatDuration(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  void changeQuestion(Function func)
  {
    changingQuestion = true;

    Future.delayed(Duration(milliseconds: 500), () 
    {
      if (func())
      {
        myAnswers[currentQuestionIndex - 1] = currentSelection; // save the answers
        print(myAnswers);
        currentSelection = -1; // deselect any selected answers
      }

      setState(() {
        changingQuestion = false;
      });
    });
  }

  void nextQuestion()
  {
    changeQuestion(() 
    {
      if (currentQuestionIndex < questionsCount - 1)
      {
        currentQuestionIndex++;
        return true;
      } else {
        return false;
      }
    });
  }

  void previousQuestion()
  {
    changeQuestion(()
    {
      if(currentQuestionIndex > 0)
      {
        currentQuestionIndex--;
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
      
        IgnorePointer(ignoring: showOverview, child: 
          AnimatedOpacity(child: 
            Container(child: Center(child: ListView(shrinkWrap: true, children: <Widget>[
              
              Padding(padding:EdgeInsets.all(35), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[

                AnimatedOpacity(child: Column(children: <Widget>[

                  Text("Question " + (currentQuestionIndex + 1).toString() + " / $questionsCount", style: TextStyle(fontSize:16, color: Colors.grey, fontWeight: FontWeight.bold),),
                  Divider(height: 10),
                  Divider(height: 5, color:Colors.transparent),
                  Text(questions[currentQuestionIndex].question, style: TextStyle(fontSize:23, fontWeight: FontWeight.bold),),
                  Divider(height: 25, color:Colors.transparent),

                  for (var i = 0; i < questions[currentQuestionIndex].answers.length; i ++) 
                    MCQAnswerItem(answer: questions[currentQuestionIndex].answers[i], selected: (i == currentSelection), onPressed: () { setState(() {
                      currentSelection = i;
                    });},),

                ],), opacity: (changingQuestion) ? 0 : 1, duration: Duration(milliseconds: 200)),

                Divider(height: 25, color:Colors.transparent),

                Row(children: <Widget>[
                  Expanded(child: RaisedButton(child: Row(children: <Widget>[
                    Icon(Icons.arrow_back, size:15),
                    VerticalDivider(width:10, color: Colors.transparent),
                    Expanded(child: Text("Previous", textAlign: TextAlign.center,))
                  ],), onPressed: () { previousQuestion(); },), flex: 1),
                  VerticalDivider(width: 10),
                  Expanded(child: RaisedButton(child: Row(children: <Widget>[
                    Expanded(child: Text("Next", textAlign: TextAlign.center,)),
                    VerticalDivider(width:10, color: Colors.transparent),
                    Icon(Icons.arrow_forward, size:15),
                  ],), onPressed: () { nextQuestion(); },), flex: 1),
                ],),

                Row(children: <Widget>[
                  Expanded(child: RaisedButton(child: Row(children: <Widget>[
                    Icon(Icons.question_answer, size:15),
                    Expanded(child: Text("Questionaire Overview", textAlign: TextAlign.center,))
                  ],), color:Theme.of(context).secondaryHeaderColor, onPressed: () { setState(() {
                    showOverview = true;
                  }); },), flex: 1),
                ],)

              ],))

            ],),),),
            opacity:showOverview ? 0 : 1, duration: Duration(milliseconds: 250),
          ),
        ),

        IgnorePointer(ignoring: !showOverview, child:
          AnimatedOpacity(
            child: Container(child: Center(child: ListView(shrinkWrap: true, children: <Widget>[
              Padding(padding:EdgeInsets.all(35), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                
                // Row(children: <Widget>[ Expanded(child: Text("All Questions", textAlign: TextAlign.center, style: TextStyle(fontSize:18, fontWeight: FontWeight.bold, color: Colors.grey)))]),
                Seperator(title: "All Questions"),
                Divider(height: 15, color:Colors.transparent),

                IgnorePointer(ignoring: false, child: 
                  SizedBox(height: 160, child: 
                    GridView.count(
                      crossAxisCount: 10,
                      children: List.generate(50, (index) {
                        return AllQuestionsDisplayItem(index: index, answered: ([2,5,33,22,41,20].contains(index + 1)));
                      }),
                    )
                  ),
                ),

                Divider(height: 15, color:Colors.transparent),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  SizedBox(child: Container(decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),), width:15, height:15),
                  VerticalDivider(color: Colors.transparent, width: 10),
                  Text("Unanswered"),
                  VerticalDivider(color: Colors.transparent, width: 25),

                  SizedBox(child: Container(decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(5)),), width:15, height:15),
                  VerticalDivider(color: Colors.transparent, width: 10),
                  Text("Already Answered")
                ],),

                Divider(height: 35, color:Colors.transparent),

                if (examDuration.inSeconds > 0)
                  Row(children: <Widget>[ Expanded(child: Text("Select questions to answer, tap outwards go back", textAlign: TextAlign.center, style: TextStyle(fontSize:15, color: Colors.grey[600])))]),

                Column(children: <Widget>[
                  Divider(),

                  Divider(height: 20, color:Colors.transparent),

                  if (examDuration.inSeconds == 0)
                    Text("Your time has ran out. Would you like to submit the given answers to your questions, or you can try again later?", style: TextStyle(fontSize: 17), textAlign: TextAlign.center,),
                  if (examDuration.inSeconds != 0)
                    Text("Would you like to submit the given answers to your questions, or you can try again later?", style: TextStyle(fontSize: 17), textAlign: TextAlign.center,),

                  Divider(height: 12, color:Colors.transparent),

                  if (examDuration.inSeconds > 0)
                    Row(children: <Widget>[
                      Expanded(child: RaisedButton(child: Row(children: <Widget>[
                        Icon(Icons.arrow_back, size:15),
                        VerticalDivider(width:10, color: Colors.transparent),
                        Expanded(child: Text("Back to Question", textAlign: TextAlign.center,))
                      ],), onPressed: () { 
                        setState(() {
                          showOverview = false;
                        });
                       },), flex: 1),
                      VerticalDivider(width: 10),
                      Expanded(child: RaisedButton(child: Row(children: <Widget>[
                        Expanded(child: Text("Submit Now", textAlign: TextAlign.center,)),
                        VerticalDivider(width:10, color: Colors.transparent),
                        Icon(Icons.file_upload, size:15),
                      ],), onPressed: () { setState(() {
                        uploadingAnswers = true;
                      }); },), flex: 1),
                    ],),
                  if (examDuration.inSeconds == 0)
                    Row(children: <Widget>[
                      Expanded(child: RaisedButton(child: Row(children: <Widget>[
                        Icon(Icons.home, size:15),
                        VerticalDivider(width:10, color: Colors.transparent),
                        Expanded(child: Text("Go to Home", textAlign: TextAlign.center,))
                      ],), onPressed: () { },), flex: 1),
                      VerticalDivider(width: 10),
                      Expanded(child: RaisedButton(child: Row(children: <Widget>[
                        Expanded(child: Text("Submit Now", textAlign: TextAlign.center,)),
                        VerticalDivider(width:10, color: Colors.transparent),
                        Icon(Icons.file_upload, size:15),
                      ],), onPressed: () { setState(() {
                        uploadingAnswers = true;
                      }); },), flex: 1),
                    ],),

                ],)
              ],))
            ],))),
          duration: Duration(milliseconds: 250), opacity: (!showOverview) ? 0 : 1,)
        ),

        Container(child: Align(alignment: Alignment.topCenter, child: 
          
          Padding(child: Column(children: <Widget>[
            Text("Time Remaining : ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            Divider(color: Colors.transparent, height: 10),
            Container(decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5), color: (examDuration.inSeconds < 60) ? Colors.red : Colors.grey), 
              child: Text(formatDuration(examDuration), style: TextStyle(fontSize: 25, fontFamily: "Number", fontWeight: FontWeight.bold)), padding: EdgeInsets.fromLTRB(10, 5, 10, 4)
            )
          ],)
          ,padding: EdgeInsets.fromLTRB(0, 75, 0, 0))
        )),

        IgnorePointer(ignoring: (!uploadingAnswers), child: AnimatedOpacity(child: 
            Container(color:Theme.of(context).backgroundColor, child: Center(child: Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
              CircularProgressIndicator(),
              Divider(color:Colors.transparent, height:30),
              Text("SUBMITTING ANSWERS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize:17)),
              Divider(color:Colors.transparent, height: 5),
              Text("Please do not exit the application", style: TextStyle(fontSize: 16)),
            ],)))
          , duration: Duration(milliseconds: 250), opacity: (uploadingAnswers) ? 1 : 0),
        ),

      ],)
    );
  }
}