import 'package:flutter/material.dart';
class InfoPage extends StatefulWidget {
  final String type;
  const InfoPage({super.key, required this.type});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return farmerSupport(context);
  }

  Scaffold farmerSupport(BuildContext context) {
    if(widget.type == "farmer"){
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(context),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
          child: ListView(
            children: const [
              Text(
                'Welcome to Yield Mate!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '1. Viewing Plots:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'On the "Plots" tab, you will see a list of all your existing plots. Each plot card displays the plot name, size in acres, crop type, and a calculated score. Use this to track the progress and health of your plots.',
              ),
              SizedBox(height: 16),
              Text(
                '2. Adding a New Plot:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'To add a new plot, tap the "Add Plots" card at the top of the list. You will be prompted to enter details such as plot name, size, crop type, and other relevant information.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Managing Plot Status:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'You can filter your plots using the navigation bar at the bottom of the screen. Choose "All Plots" to view everything, "Ongoing" to see plots currently under cultivation, or "Completed" for plots where cultivation has concluded.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Navigating Reports:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Switch to the "Reports" tab at the top of the screen to view insights and detailed analyses of your plots. This is useful for tracking productivity and making informed decisions.',
              ),
              SizedBox(height: 16),
              Text(
                '5. Settings and Additional Options:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Use the settings icon in the top-right corner to manage your account preferences or app configurations. You can customize options based on your needs.',
              ),
              SizedBox(height: 16),
              Text(
                '6. Help & Support:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'If you encounter any issues or need assistance, contact us at yieldmatesupport@emailcom. Our team is available to help you with any queries or concerns.',
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(context),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
          child: ListView(
            children: const [
              Text(
                'Welcome to the Admin Panel!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '1. Managing Users:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Navigate to the "Users" tab to view and manage user accounts. You can add, edit, update, or delete user information as needed. This helps you keep user data up to date.',
              ),
              SizedBox(height: 16),
              Text(
                '2. Managing Seeds:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'In the "Model" tab under the "Seeds" category, you can add new seed varieties, update existing seed data, or remove outdated entries. This ensures farmers have access to accurate seed information.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Managing Models:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Under the "Model" category, manage prediction models by adding, editing, or updating them. This allows you to enhance the app\'s data accuracy and support better predictions.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Managing Locations:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Use the "Locations" category in the "Model" tab to manage location-based data. Add new locations, edit information, or delete unnecessary entries to maintain organized records.',
              ),
              SizedBox(height: 16),
              Text(
                '5. Managing Crops:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Under the appropriate category, you can add, update, or delete crop data. Keeping this information accurate is essential for farmers and reports.',
              ),
              SizedBox(height: 16),
              Text(
                '6. Viewing Reports:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Switch to the "Reports" tab to view detailed insights and summaries of system activities. Use this information for analysis and decision-making.',
              ),
              SizedBox(height: 16),
              Text(
                '7. Help and Support:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'For any additional queries, documentation can be found at yieldmate.com/docs.'
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      );
    }
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.grey,),
          )
        ),
      );
  }
}