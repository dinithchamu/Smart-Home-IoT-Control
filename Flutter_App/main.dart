import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IoT Smart Home',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const ControlScreen(),
    );
  }
}

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  bool light1 = false;
  bool light2 = false;
  bool fridge = false;
  bool fan = false;

  @override
  void initState() {
    super.initState();
    // listen for changes in the device statuses from Firebase Realtime Database
    _database.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          light1 = data['light1_status'] == 1;
          light2 = data['light2_status'] == 1;
          fridge = data['fridge_status'] == 1;
          fan = data['fan_status'] == 1;
        });
      }
    });
  }

  Widget controlCard(String name, bool status, IconData icon, String firebasePath) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: status ? Colors.lightGreen.shade50 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              size: 35,
              color: status ? Colors.green : Colors.grey,
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: status,
                activeColor: Colors.red,
                onChanged: (value) {
                  // send the new status to Firebase Realtime Database
                  _database.child(firebasePath).set(value ? 1 : 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent.shade100,
      appBar: AppBar(
        title: const Text("My Smart Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Devices Control",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 30,
                children: [
                  controlCard("Light 1", light1, Icons.lightbulb_outline, "light1_status"),
                  controlCard("Light 2", light2, Icons.lightbulb_outline, "light2_status"),
                  controlCard("Fridge", fridge, Icons.kitchen, "fridge_status"),
                  controlCard("Fan", fan, Icons.air, "fan_status"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}