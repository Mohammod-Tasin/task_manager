import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/module%2011/dispose.dart';

class Class1CounterApp extends StatefulWidget {
   Class1CounterApp({super.key}){
     print('1 constructor');
   }

  @override
  State<Class1CounterApp> createState() => _Class1CounterAppState();

}

class _Class1CounterAppState extends State<Class1CounterApp> {

  int num=0;

  @override
  void initState() {
    // TODO: implement initState
    print('3 init state');
    super.initState();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print('4 deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('5 dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Counter App"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(num.toString(), style: TextStyle(
                fontSize: 50,
                color: Colors.deepPurple
              ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: (){
                      setState(() {
                        num++;
                      });
                  }, child: Icon(Icons.plus_one_rounded)),
                  ElevatedButton(onPressed: (){
                      setState(() {
                        num--;
                      });
                  }, child: Icon(Icons.exposure_minus_1_rounded)),
                ],
              ),
              SizedBox(height: 40,),
              ElevatedButton(onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Dispose()));
              }, child: Text('jump to dispose'))
            ],
          ),
        ),
      ),
    );
  }
}
