import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/module%2011/Class2/cButton.dart';


class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = '0';
  String _input = '0';
  String _ope = '0';
  double num1 = 0;
  double num2 = 0;

  void buttonPress(String value) {
    print('int val= $value');
    setState(() {
      if (value == 'C') {
        _output = '0';
        _input = '0';
        _ope = '';
        num1 = 0;
        num2 = 0;
      } else if (value == '=') {
        num2 = double.parse(_input);
        if (_ope == '+') {
          _output = (num1 + num2).toString();
        } else if (_ope == '-') {
          _output = (num1 - num2).toString();
        } else if (_ope == '*') {
          _output = (num1 * num2).toString();
        } else if (_ope == '÷') {
          _output = num2 != 0 ? (num1 / num2).toString() : 'Error';
        }
      } else if (['+', '-', '*', '÷'].contains(value)) {
        num1 = double.parse(_input);
        _ope = value;
        _input = '';
      } else {
        if (_input == '0') {
          _input = value;
        } else {
          _input += value;
        }
        _output = _input;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  (_ope.isNotEmpty && _input.isNotEmpty)
                      ? Text(
                          '$num1 $_ope $num2',
                          style: TextStyle(fontSize: 24, color: Colors.white24),
                        )
                      : SizedBox(),
                  Text(
                    _output,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cButton(onTap: () => buttonPress('7'), text: '7'),
              cButton(onTap: () => buttonPress('8'), text: '8'),
              cButton(onTap: () => buttonPress('9'), text: '9'),
              cButton(
                onTap: () => buttonPress('÷'),
                text: '÷',
                color: Colors.orange,
              ),
            ],
          ),

          Row(
            children: [
              cButton(onTap: () => buttonPress('4'), text: '4'),
              cButton(onTap: () => buttonPress('5'), text: '5'),
              cButton(onTap: () => buttonPress('6'), text: '6'),
              cButton(
                onTap: () => buttonPress('*'),
                text: '*',
                color: Colors.orange,
              ),
            ],
          ),
          Row(
            children: [
              cButton(onTap: () => buttonPress('1'), text: '1'),
              cButton(onTap: () => buttonPress('2'), text: '2'),
              cButton(onTap: () => buttonPress('3'), text: '3'),
              cButton(
                onTap: () => buttonPress('-'),
                text: '-',
                color: Colors.orange,
              ),
            ],
          ),
          Row(
            children: [
              cButton(onTap: () => buttonPress('C'), text: 'C'),
              cButton(onTap: () => buttonPress('0'), text: '0'),
              cButton(onTap: () => buttonPress('='), text: '='),
              cButton(
                onTap: () => buttonPress('+'),
                text: '+',
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
