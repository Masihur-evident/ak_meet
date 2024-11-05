import 'package:flutter/material.dart';

import 'package:wave/config.dart';
import 'package:wave/wave.dart';



class WaveDemoHomePage extends StatefulWidget {
  WaveDemoHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _WaveDemoHomePageState createState() => _WaveDemoHomePageState();
}

class _WaveDemoHomePageState extends State<WaveDemoHomePage>  with TickerProviderStateMixin {

  late AnimationController _dropletController;

  @override
  void initState() {
    super.initState();

    // Droplet animation controller for the falling motion
    _dropletController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // // Trigger wave animation when the droplet hits the water
        // setState(() {
        //   _progress += 0.05; // Increment water level with each drop
        //   if (_progress > 1.0) _progress = 0.2; // Reset or limit water level
        // });
      }
    });


  }


  @override
  void dispose() {
    _dropletController.dispose();

    super.dispose();
  }

  _buildCard({
    required Config config,
    Color? backgroundColor = Colors.transparent,
    DecorationImage? backgroundImage,
    double height = 152.0,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      child: Card(
        elevation: 12.0,
        margin: EdgeInsets.only(
            right: marginHorizontal, left: marginHorizontal, bottom: 16.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0),),),
        child: WaveWidget(
          config: config,
          backgroundColor: backgroundColor,
          backgroundImage: backgroundImage,
          size: Size(double.infinity, double.infinity),
          waveAmplitude: 0,
        ),
      ),
    );
  }

  double marginHorizontal = 16.0;



  @override
  Widget build(BuildContext context) {
    marginHorizontal = 16.0 +
        (MediaQuery.of(context).size.width > 512
            ? (MediaQuery.of(context).size.width - 512) / 2
            : 0);
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Restart droplet animation on button press
          _dropletController.forward(from: 0);
        },
        child: Icon(Icons.water_drop),
      ),

      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: <Widget>[

                _buildCard(
                  height: 500.0,
                  backgroundImage: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1554779147-a2a22d816042?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=3540',
                    ),
                    fit: BoxFit.cover,
                    colorFilter:
                    ColorFilter.mode(Colors.white, BlendMode.softLight),
                  ),
                  config: CustomConfig(
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      // Colors.pink[100]!
                    ],
                    durations: [180000, 8000, 5000],
                    heightPercentages: [0.4, 0.5, 0.6],
                  ),
                ),

                AnimatedBuilder(
                  animation: _dropletController,
                  builder: (context, child) {
                    double dropPosition = _dropletController.value * 500;
                    return Positioned(
                      top: dropPosition,
                      child: Opacity(
                        opacity: _dropletController.value < 1.0 ? 1 : 0,
                        child: Icon(Icons.circle, size: 50, color: Colors.blueAccent),
                      ),
                    );
                  },
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }
}