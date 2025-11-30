import 'dart:async';

import 'package:flutter/material.dart';

import 'addWater.dart';

class Watertracker extends StatefulWidget {
  const Watertracker({super.key});

  @override
  State<Watertracker> createState() => _WatertrackerState();
}

class _WatertrackerState extends State<Watertracker> {

  int currentInTank= 0;
  final int goal= 5000;
  Timer ? _time1;
  Timer ? _timerToAddWater;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _time1= Timer.periodic(Duration(seconds: 1), (timer){
  //     if(currentInTank>0){
  //       setState(() {
  //         (currentInTank-=1).clamp(0, goal);
  //       });
  //     }
  //   });
  // }

  void addWaterByseconds(int amount){
    _timerToAddWater=Timer.periodic(Duration(seconds: 1), (timer){
      if(currentInTank<(currentInTank+amount)){
        setState(() {
          (currentInTank+=3).clamp(0, goal);
        });
      }
    });
  }

  void addWater(int amount){
    setState(() {
      currentInTank=(currentInTank+amount).clamp(0, goal);
    });
  }

  void releaseWater(int amount){
    setState(() {
      currentInTank=(currentInTank-amount).clamp(0, goal);
    });
  }

  void emptyTank(){
    setState(() {
      currentInTank=0;
    });
  }

  @override
  Widget build(BuildContext context) {

    double progress= (currentInTank/goal)*100;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          'Water Tracker',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),

              child: Column(
                children: [
                  Text(
                    "Today's in Tank: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$currentInTank LTR',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Colors.blue,
                    strokeWidth: 17,
                    value: progress/100,
                    // valueColor:
                  ),
                ),
                Text(
                  '${progress.toInt()} %',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 30),
            Wrap(
              // spacing: ,
              // runSpacing: ,
              children: [
                AddWaterBtn(amount: 20, onclick: () => addWaterByseconds(20), plusOrMinus: '+',),
                AddWaterBtn(amount: 300, onclick: () => addWater(300), plusOrMinus: '+',),
                AddWaterBtn(amount: 120, onclick: () => releaseWater(120), plusOrMinus: '-',icon: Icons.local_drink,),
                AddWaterBtn(amount: 300, onclick: () => releaseWater(300), plusOrMinus: '-',icon: Icons.propane_tank_sharp,),
              ],
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
                    onPressed: ()=>emptyTank(), child: Text('Empty tank', style: TextStyle(color: Colors.blue),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}