import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  String username;
  String email;
  Profile(this.username,this.email);

  @override
  State<Profile> createState() => _ProfileState(username, email);
}

class _ProfileState extends State<Profile> {
  String username;
  String email;
  _ProfileState(this.username,this.email);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('profile'),backgroundColor: Colors.lightBlue,),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Icon(Icons.account_circle,size: 100,),
            SizedBox(height: 20,),
            Text(username,style: TextStyle(
                fontSize: 20,fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 40,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username : '+username,style: TextStyle(
                    fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 20,),
                Text('E-mail : '+email,style: TextStyle(
                    fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 20,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
