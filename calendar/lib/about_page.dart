import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('About'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'About App'),
              Tab(text: 'About Me'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AboutAppTab(),
            AboutMeTab(),
          ],
        ),
      ),
    );
  }
}

class AboutAppTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PiggyBankM - a piggy bank right in your pocket. Usage: tap on Add Distribution by day, enter the period and the desired amount. After that, the calendar will display markers with the required amount for the day. '
                'The untranslated amount is marked in red color:',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              color: Colors.red,
              width: double.infinity,
              height: 50.0,
              child: Center(
                child: Text(
                  '500 RUB',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'When you click "Done", it will look like this:',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              color: Colors.green,
              width: double.infinity,
              height: 50.0,
              child: Center(
                child: Text(
                  '500 RUB',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutMeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'I - Dmitry Konyushenko. Student of KUBSAU. Actually love Python, but this app just for studying.',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
          Image.asset(
            './assets/images/cat.jpg',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
