import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearnapp/Data/Organization.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User
{
  String firstName;
  String lastName;
  String email;
  String phone;
  bool teacher;
  String uid;

  static User me = new User();

  static Future retrieveUserData() async
  {
    var user  = await FirebaseAuth.instance.currentUser();
    var ds = await Firestore.instance.collection("users").document(user.uid).get();
    
    me.firstName =  ds.data["fisrt_name"];
    me.lastName =  ds.data["last_name"];
    me.email =  ds.data["email"];
    me.phone =  ds.data["phone"];
    me.teacher =  ds.data["teacher"];
    me.uid =  ds.data["uid"];

    return me;
  }

  static Future getUserData(uid) async
  {
    var result = await Firestore.instance.collection("users").document(uid).get();
    return result;
  }

  static DocumentReference getMyOrg()
  {
    return Firestore.instance.collection("organizations").document(Organization.currentOrganizationId);
  }

  static Future getMyClasses() async
  {
    if (me.uid == null)
      await retrieveUserData();

    var result = await Firestore.instance.collection("users").document(me.uid).get();
    var returnClasses = [];

    var classes = result.data["classes"];
    var org = getMyOrg();

    for (var i = 0; i < classes.length; i ++)
    {        
      var classResult = await org.collection("classes").document(classes[i]).get();
      var host = await getUserData(classResult["host"]);

      returnClasses.add({
        "id" : classes[i],
        "host": host["first_name"] + " " + host["last_name"], 
        "subject" : classResult["subject"],
        "grade" : classResult["grade"]
      });
    }

    return returnClasses;
  }

  static Future<String> getMyAssignmentsCount() async
  {
    if (me.uid == null)
      await retrieveUserData();
    
    var result = await Firestore.instance.collection("users").document(me.uid).get();
    var classes = result.data["classes"];

    var org = getMyOrg();
    var submissions = org.collection("submissions");

    var count = 0;

    for (var i = 0; i < classes.length; i++)
    {
      var query = await org.collection("assignments").where("class", isEqualTo: classes[i]).where("duedate", isGreaterThan: Timestamp.now()).getDocuments();
      
      // check if already submitted or not
      for (var j = 0; j < query.documents.length; j ++)
      {
         var mySub = await submissions.where("assignment", isEqualTo: query.documents[j].documentID).where("user", isEqualTo: me.uid).getDocuments();

         if (mySub.documents.length == 0)
         {
           count++;
         }
      }
    }

    return count.toString();
  }

  static Future<String> getMyTodoCount() async
  {
    if (me.uid == null)
      await retrieveUserData();

    var result = await Firestore.instance.collection("users").document(me.uid).collection("todo").where("completed", isEqualTo: false).getDocuments();

    return (result.documents.length.toString());
  }

  static Future loadNoticeboard() async
  {
    var org = getMyOrg();
    var results  = await org.collection("noticeboard").where("created", isGreaterThan: Timestamp.fromDate(DateTime.now().subtract(new Duration(days: 30)))).orderBy("created", descending: true).getDocuments();

    return results.documents;
  }
}