import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    title: 'Scattgories',
    home: MyApp(),
  ));
}

String mostrar = "UNO";

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyApp createState() => _MyApp();
}




class _MyApp extends State<MyApp> {
  @override
  CollectionReference pinesColection = null;
  final firestoreInstance = FirebaseFirestore.instance;
  final Sala = FirebaseFirestore.instance;


  void createSala() async {
    Sala.collection("Sala").add({

      "Jugadores":{
        "0":"Juan",
        "1":"Sara",
        "2":"Andres",
      }

    }).then((value){
      print(value.id);
      firestoreInstance
          .collection("Sala")
          .doc(value.id)
          .set({ "Categorias":{"0":"Nombres",
        "1":"Cosas que hay en la Playa",
        "2":"Provincias",
        "3":"Pueblos",
        "4":"Elementos Quimicos"}});
    });
    //getJugadores(id);
  }

  void getJugadores(id) async{
    Sala.collection("Sala").document(id).set({
      "Categorias":{
        "0":"Nombres",
        "1":"Cosas que hay en la Playa",
        "2":"Provincias",
        "3":"Pueblos",
        "4":"Elementos Quimicos",
      }
    }).then((_){
      print("succes");
    });


  }


  void initState() {
    print("Init firebase");
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      pinesColection = FirebaseFirestore.instance.collection('Sala');
      print("completed");
      getDbData();
      signInWithGoogle();
    });
  }


  /*final firestoreInstance = FirebaseFirestore.instance;

  void _onPressed() {
    firestoreInstance.collection("sala").add(
        {
          "name" : "john",
          "age" : 50,
          "email" : "example@example.com",
          "address" : {
            "street" : "street 24",
            "city" : "new york"
          }
        }).then((value){
      print(value.id);
    });
  }*/

  /****************************************************/

  void getDbData() async{
    print("get data");
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    setState(() {
      pinesColection.get()
          .then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) {
          print("==========> "+doc.toString());
          var d = doc.data();
          print(d.toString());
        })
      });
    });
  }



  Future<User> signInWithGoogle() async {
    //login
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print("?");
    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;
    print("?");
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var user = await _auth.signInWithCredential(credential);
    print("signed in " + user.toString());
    return null;
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Scattegories',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Scattegories'),
        ),
        drawer: Drawer(
            child: ListView(
              children: [
                //1 -------------------------
                DrawerHeader(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey
                  ),
                  child: Text(
                      "HEADER"
                  ),
                ),
                // 2 ------------------------
                FlatButton(
                  onPressed: ()=> print("UNO !"),
                  child: Text("Ventana 1"),
                ),
                // 3 -----------------------
                FlatButton(
                  onPressed: ()=> mostrar = "DOS",
                  child: Text("Ventana 2"),
                )

              ],
            )

        ),

        body: Center(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //if(mostrar == "UNO")Text('Estufa App'),
                Text('Sala', style:
                TextStyle(color: Colors.red,
                  fontSize: 40,)
                ),
                TextField (
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Sala',

                  ),
                ),
                RaisedButton(
                  //minWidth: 500.0,
                  //height: 100.0,
                  child: new Text('Entrar a la Sala', style:
                  TextStyle(color: Colors.white,
                    fontSize: 20,)
                  ),
                  color: Colors.black26,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Invitado()),
                    );
                  },
                ),
                RaisedButton(
                  //minWidth: 500.0,
                  //height: 100.0,
                  child: new Text('Crear la Sala', style:
                  TextStyle(color: Colors.white,
                    fontSize: 20,)
                  ),
                  color: Colors.black26,
                  onPressed: () {
                    createSala();


                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Administrador()),
                    );
                  },
                ),
              ],


            )
        ),
      ),
    );
  }

}

class Administrador extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scattegories',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Codigo Sala'),
        ),
        body: Center(
            child: Column(
              children: [
                Text('Codigo de la Sala'),
                Text('Poner todos los Juagadores'),
                RaisedButton(
                  //minWidth: 500.0,
                  //height: 100.0,
                  child: new Text('Comenzar partida', style:
                  TextStyle(color: Colors.white,
                    fontSize: 30,)
                  ),
                  color: Colors.black26,
                  onPressed: () {

                  },
                ),
                RaisedButton(
                  //minWidth: 500.0,
                  //height: 100.0,
                  child: new Text('Volver Atras', style:
                  TextStyle(color: Colors.white,
                    fontSize: 30,)
                  ),
                  color: Colors.black26,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )

              ],
            )
        ),
      ),
    );
  }

}

class Invitado extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scattegories',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Codigo Sala'),
        ),
        body: Center(
            child: Column(
              children: [
                Text('Codigo de la Sala'),
                Text('Poner todos los Juagadores'),
                RaisedButton(
                  //minWidth: 500.0,
                  //height: 100.0,
                  child: new Text('Volver Atras', style:
                  TextStyle(color: Colors.white,
                    fontSize: 30,)
                  ),
                  color: Colors.black26,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )
        ),
      ),
    );
  }

}






















































//Vale para poder registrar una cuenta de google

/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    print("Init firebase");
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      signInWithGoogle();
    });
  }

  /****************************************************/




  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future<User> signInWithGoogle() async {
    //login
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print("?");
    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;
    print("?");
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var user = await _auth.signInWithCredential(credential);
    print("signed in " + user.toString());
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/
