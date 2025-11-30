import 'package:flutter/material.dart';

class Moneymanagement2 extends StatefulWidget {
  const Moneymanagement2({super.key});

  @override
  State<Moneymanagement2> createState() => _Moneymanagement2State();
}

class _Moneymanagement2State extends State<Moneymanagement2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _earning = [];
  final List<Map<String, dynamic>> _expense = [];

  double get totalEarning => _earning.fold(0, (sum, item)=>sum+item["amount"]);
  double get totalExpense => _expense.fold(0, (sum, item)=>sum+item["amount"]);
  double get balance=> totalEarning-totalExpense;

  void _addEarningOrExpense({
    required String title,
    required double amount,
    required DateTime datetime,
    required bool isEarning,}
  ) {
    setState(() {
      if(isEarning){
        _earning.add({
          "title": title,
          "amount": amount,
          "date": datetime,
        });
      }else{
        _expense.add({
          "title": title,
          "amount": amount,
          "date": datetime,
        });
      }
    });
  }

  void _showFABOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 30),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.lightGreenAccent,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showForm(isEarning: true);
                },
                child: Text(
                  "Add Earning",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 30),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showForm(isEarning: false);
                },
                child: Text(
                  "Add Expense",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showForm({required bool isEarning}) {
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    DateTime dateTime = DateTime.now();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                isEarning ? "Add Earning" : "Add Expense",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.lightGreenAccent,
                    ),
                  ),
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        amountController.text.toString().isNotEmpty) {
                        _addEarningOrExpense(
                        title: titleController.text,
                        amount: double.parse(amountController.text),
                        datetime: dateTime,
                        isEarning: isEarning,
                      );
                        Navigator.pop(context);
                    }

                  },
                  child: Text(
                    isEarning ? "Add Earning" : "Add Expense",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Money Management 2",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(
              text: "Earning",
              icon: Icon(Icons.arrow_upward, color: Colors.lightGreenAccent),
            ),
            Tab(
              text: "Expense",
              icon: Icon(Icons.arrow_downward, color: Colors.redAccent),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryCard(
                title: "Earning",
                amount: totalEarning,
                color: Colors.lightGreenAccent,
              ),
              _buildSummaryCard(
                title: "Expense",
                amount: totalExpense,
                color: Colors.redAccent,
              ),
              _buildSummaryCard(
                title: "Balance",
                amount: balance,
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: [
                  _buildList(_earning, Colors.green, true),
                  _buildList(_expense, Colors.red, false)
                ]),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => _showFABOptions(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget _buildSummaryCard({
  required String title,
  required double amount,
  required Color color,
}) {
  return Card(
    color: color,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.black)),
          Text(
            amount.toString(),
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

Widget _buildList(List<Map<String, dynamic>> items, Color color, bool isEarning){
  return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index){
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(isEarning? Icons.arrow_upward: Icons.arrow_downward),
            ),
            title: Text(items[index]['title']),
            subtitle: Text(items[index]['date'].toString()),
            trailing: Text(
              "BDT ${items[index]['amount']}",
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        );
      });
}