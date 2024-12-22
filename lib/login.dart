import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_shopping/adminpage.dart';
import 'package:online_shopping/signup.dart';
import 'package:online_shopping/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forget_password.dart';
import 'home.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailTextEdit = new TextEditingController();
  TextEditingController passwordTextEdit = new TextEditingController();

  bool obserText = true;
  bool found = false;
  late String name;
  late String email;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _check = preferences.getBool('check');
    String _name = (preferences.getString('name')).toString();
    String _email = preferences.getString('email').toString();

    if (_check == true && _email == "admin22@gmail.com") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AdminPage()));
    }
    else if(_check == true)
      {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Home(_name, _email)));
      }
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Center(
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: emailTextEdit,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              obscureText: obserText,
              controller: passwordTextEdit,
              decoration: InputDecoration(
                labelText: 'password',
                border: const OutlineInputBorder(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obserText = !obserText;
                    });
                    FocusScope.of(context).unfocus();
                  },
                  child: Icon(
                    obserText == true ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              child: const FittedBox(
                  child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 18,
                ),
              )),
              //color: Colors.lightBlue,
              onPressed: () {
                final userRef = FirebaseFirestore.instance.collection('users');
                userRef.get().then((QuerySnapshot snapshot) {
                  for (int index = 0; index < snapshot.size; index++) {
                    if (snapshot.docs[index]['email'] == emailTextEdit.text) {
                      if (snapshot.docs[index]['password'] ==
                          passwordTextEdit.text) {
                        name = snapshot.docs[index]['username'];
                        email = snapshot.docs[index]['email'];
                        found = true;
                        check = true;
                        savePref(check, name, email);
                        break;
                      }
                    }
                  }
                    if (found == true && emailTextEdit.text == "admin22@gmail.com") {
                      found = false;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPage()));}
                    else if(found == true) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Home(name, email)));
                    }
                   else if (found == false){
                      found = false;
                    const snackBar = SnackBar(
                      content: Text(
                          'Incorrect Account !! Try Again or Create New Account'),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text('If You Dont Have Account ?'),
                const SizedBox(
                  width: 7,
                ),
                TextButton(
                  child: const Text(
                    'Signup',
                    style: TextStyle(color: Colors.lightBlue, fontSize: 15),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              child: const Text(
                'Forget Your Password',
                style: TextStyle(color: Colors.lightBlue, fontSize: 15),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ForgetPassword()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
