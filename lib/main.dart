import 'dart:async';

import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  Color pauseColor = Colors.white12;

  StreamController<int> _controller = StreamController<int>.broadcast();
  Timer? _timer;

  bool isRun = false;
  bool playButtonVisibility = true;

  int centiSecond = 0;
  int minute = 0;
  int second = 0;

  String get minutes => minute.toString().padLeft(2,'0');
  String get seconds => second.toString().padLeft(2,'0');
  String get centiSeconds => centiSecond.toString().padLeft(2,'0');

  void startStopWatch(){
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer){
      setState(() {
        centiSecond++;
        if(centiSecond == 100){
          centiSecond = 0;
          second++;
        }
        if(second == 60){
          second = 0;
          minute++;
        }
        if(minute == 60){
          minute = 0;
        }
      });
      _controller.add(1);
    });
  }

  void stopStopWatch(){
    _timer?.cancel();
  }

  @override
  void dispose(){
    _timer?.cancel();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'StopWatch',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          leading: Icon(Icons.timer,color: Colors.blue,),
          title: Text('StopWatch',style: TextStyle(
            fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white,
          ),),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 80,),
              StreamBuilder(
                stream: _controller.stream,
                builder:(context,snapshot) {
                  return Container(
                    height: 100,
                    width: 300,
                    child: Center(
                      child: Text(
                        '$minutes : $seconds : $centiSeconds',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 50,),
              Visibility(
                visible: playButtonVisibility,
                replacement: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          stopStopWatch();
                          setState(() {
                            minute = 0;
                            centiSecond = 0;
                            second = 0;
                            playButtonVisibility = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white12,
                          shape: CircleBorder(),
                        ),
                        child: Container(
                          height: 80,
                          width: 80,
                          child: Icon(Icons.stop,size: 40,color: Colors.blue,),
                        ),
                      ),
                      SizedBox(width: 20,),
                      ElevatedButton(
                        onPressed: (){
                          if(_timer != null && _timer!.isActive){
                            stopStopWatch();
                            pauseColor = Colors.white24;
                          }
                          else{
                            startStopWatch();
                            pauseColor = Colors.white12;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pauseColor,
                          shape: CircleBorder(),
                        ),
                        child: Container(
                          height: 80,
                          width: 80,
                          child: Icon(Icons.pause,size: 40,color: Colors.blue,),
                        ),
                      ),
                    ],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: (){
                    startStopWatch();
                    playButtonVisibility = false;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white12,
                    shape: CircleBorder(),
                  ),
                  child: Container(
                    height: 80,
                    width: 80,
                    child: Icon(Icons.play_arrow,size: 40,color: Colors.blue,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}