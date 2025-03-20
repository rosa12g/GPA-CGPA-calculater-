import 'package:flutter/material.dart';
import 'HomeScreen.dart';
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Icon(
              Icons.calculate,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 20),

            Text(
              'Welcome to the GPA/CGPA Calculator!',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),

            Text(
              'Track and calculate your academic performance with ease.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                 Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()), 
                  );

                              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text(
                'Get Started',
              
              )
              ),
            
          ],
        ),
      ),
    );
  }
}