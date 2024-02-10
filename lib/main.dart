import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:login_page/database_helper.dart';
import 'user.dart';

void main() {
  sqfliteFfiInit();
  runApp(MyApp());
  DatabaseHelper.insertUser(
      User(email: 'test@example.com', password: 'password123'));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool isAuthenticated = await DatabaseHelper.authenticateUser(
                  emailController.text,
                  passwordController.text,
                );
                if (isAuthenticated) {
                  // Here, implement what happens upon successful login
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Login Successful'),
                  ));
                } else {
                  // Here, implement what happens upon login failure
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Invalid email or password'),
                  ));
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
