import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Image App',
      home: Scaffold(
        body: BackgroundImage(),
      ),
    );
  }
}

class BackgroundImage extends StatefulWidget {
  @override
  _BackgroundImageState createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<BackgroundImage>
    with SingleTickerProviderStateMixin {
  String buttonText = 'Mở Bát';
  String number = '';

  bool isBowOutside = false;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.0), // Start from center
      end: Offset(1.0, 0.0), // Move to the right
    ).animate(_controller);
  }

  void toggleBowPosition() {
    if (!isBowOutside) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      isBowOutside = !isBowOutside;
    });
  }

  void toggleButtonText() {
    setState(() {
      if (buttonText == 'Mở Bát') {
        buttonText = 'Xóc Dĩa';
      } else {
        buttonText = 'Mở Bát';
        // Generate random number when button is pressed
        number = generateRandomNumber();
      }
    });
    toggleBowPosition();
  }

  String generateRandomNumber() {
    Random random = Random();
    String randomNumber = '';

    for (int i = 0; i < 9; i++) {
      randomNumber += random.nextInt(10).toString();
    }

    randomNumber =
        randomNumber.substring(0, 3) + '-' + randomNumber.substring(3);

    return randomNumber;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background3.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 200,
          left: MediaQuery.of(context).size.width / 2 - 100,
          child: Text(
            '633.BT1.$number',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Positioned(
          bottom: 20,
          left: MediaQuery.of(context).size.width / 2 - 50,
          child: ElevatedButton(
            onPressed: () {
              toggleButtonText();
            },
            child: Text(buttonText),
          ),
        ),
        Center(
          child: Image.asset(
            'assets/images/plate.png',
            width: 250,
            height: 250,
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          bottom: MediaQuery.of(context).size.height / 2 - 150,
          right:
              isBowOutside ? 20 : MediaQuery.of(context).size.width / 2 - 150,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Image.asset(
              'assets/images/bow.png',
              width: 300,
              height: 300,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
