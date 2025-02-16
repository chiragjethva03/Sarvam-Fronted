import 'package:flutter/material.dart';

class VerifyBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show bottom sheet for verification
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Enter Verification Code'),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Verification Code'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Verify the code
                          // If successful, navigate to login screen
                          Navigator.pop(context); // Close bottom sheet
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text('Verify'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Text('Open Verification'),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Proceed with login verification
            // You can add the logic for verifying the login credentials here
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: VerifyBottomSheet(),
  ));
}
