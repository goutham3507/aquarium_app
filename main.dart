import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(VirtualAquariumApp());

class VirtualAquariumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Aquarium',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AquariumScreen(),
    );
  }
}

class AquariumScreen extends StatefulWidget {
  @override
  _AquariumScreenState createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen>
    with SingleTickerProviderStateMixin {
  List<Fish> fishList = [];
  Color selectedColor = Colors.blue;
  double selectedSpeed = 2.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  void _addFish() {
    if (fishList.length < 10) {
      setState(() {
        fishList.add(Fish(color: selectedColor, speed: selectedSpeed));
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Aquarium'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: 300,
                  height: 300,
                  color: Colors.lightBlueAccent,
                  child: Stack(
                    children: fishList.map((fish) {
                      return AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          fish.move();
                          return Positioned(
                            left: fish.position.dx,
                            top: fish.position.dy,
                            child: fish.buildFish(),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _addFish,
                child: Text('Add Fish'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save settings using local storage (e.g., shared_preferences)
                },
                child: Text('Save Settings'),
              ),
            ],
          ),
          Row(
            children: [
              Text('Speed:'),
              Slider(
                value: selectedSpeed,
                min: 1.0,
                max: 5.0,
                onChanged: (value) {
                  setState(() {
                    selectedSpeed = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              Text('Color:'),
              DropdownButton<Color>(
                value: selectedColor,
                items: [
                  DropdownMenuItem(
                    child: Text('Blue'),
                    value: Colors.blue,
                  ),
                  DropdownMenuItem(
                    child: Text('Red'),
                    value: Colors.red,
                  ),
                  DropdownMenuItem(
                    child: Text('Green'),
                    value: Colors.green,
                  ),
                ],
                onChanged: (Color? color) {
                  setState(() {
                    selectedColor = color ?? Colors.blue;  // Handle null with a fallback default
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Fish {
  Color color;
  double speed;
  Offset position;
  Random random = Random();

  Fish({this.color = Colors.blue, this.speed = 2.0}) 
      : position = Offset(Random().nextDouble() * 300, Random().nextDouble() * 300);

  void move() {
    double dx = (random.nextDouble() * 2 - 1) * speed;
    double dy = (random.nextDouble() * 2 - 1) * speed;
    position = Offset(position.dx + dx, position.dy + dy);

    // Bounce off the walls
    if (position.dx < 0 || position.dx > 300) {
      dx = -dx;
    }
    if (position.dy < 0 || position.dy > 300) {
      dy = -dy;
    }
  }

  Widget buildFish() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
