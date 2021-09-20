import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_app_task/EditInfo.dart';
import 'package:login_app_task/SignUp.dart';
import 'package:login_app_task/splashScreen.dart';
import 'HomePage.dart';

// Code isn't optimized, didn't have time to customize widgets and prevent repetitions
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(),
        LoginPage.routeName: (context) => LoginPage(),
        SignUpForm.routeName: (context) => SignUpForm(),
        HomePage.routeName: (context) => HomePage(),
        EditInfo.routeName: (context) => EditInfo()
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  final _auth = FirebaseAuth.instance;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: width * 0.3,
                      height: height * 0.3,
                      child: CircleAvatar(
                        backgroundColor: Colors.orange,
                          radius: 100,
                          backgroundImage: NetworkImage(
                              'https://cdn.dribbble.com/users/915711/screenshots/5827243/weather_icon3.png'))),
                  SizedBox(height: 25),
                  Text(
                    'Welcome back!',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                      autofocus: false,
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Email");
                        }
                        // reg expression for email validation
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please Enter a valid email");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        usernameController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Email username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 25),
                  TextFormField(
                      autofocus: false,
                      controller: passwordController,
                      obscureText: _obscureText,
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Password is required for login");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }
                      },
                      onSaved: (value) {
                        passwordController.text = value!;
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        suffixIcon:  IconButton(
                          onPressed: _toggle,
                          icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off),
                        ),
                        prefixIcon: Icon(Icons.vpn_key),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 25),
                  MaterialButton(
                      color: Colors.red,
                      height: 50,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        signIn(
                            usernameController.text, passwordController.text);
                      },
                      child: Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, SignUpForm.routeName),
                          child: Text('Sign up.'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage())),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: 'Incorrect email or password');
      });
    }
  }
}
