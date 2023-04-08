import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:untitled5/utils/colors_manager.dart';

import '../utils/routes_manager.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<String> _imageUrls = [
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
  ];

  final List<String> _texts = [
    'Accelerometer',
    'Gyroscope',
    'Magnetometer',
    'Card 4',
    'Card 5',
    'Card 6',
  ];


  final List<String> _descr = [
    'describes the velocity of the device, direction.',
    'describes the rotation of the device.',
    'describes the ambient magnetic field for compass.',
    'Card 4',
    'Card 5',
    'Card 6',
  ];

  Widget _buildCard(int index) {
    return InkWell(
      child: Center(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: ColorsManager.secondaryBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: ColorsManager.secondaryBackground,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8)),
                                    image: DecorationImage(
                                      image: NetworkImage(_imageUrls[index]),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                            const EdgeInsetsDirectional.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    _texts[index],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                      color: ColorsManager.primaryText,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    child: Text(
                                      _descr[index],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                        color: ColorsManager.secondaryText,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                // Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            splashColor: ColorsManager.primaryColor,
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: ColorsManager.primaryColor,
                              size: 20,
                            ),
                            onPressed: () {
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
            context, Routes.sensorRoute);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorsManager.primaryBackground,
      appBar: AppBar(
        backgroundColor: ColorsManager.primaryBackground,
        elevation: 0.0,
        centerTitle: true,
        title: const Text('Main Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) =>
                _buildCard(index),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorsManager.primaryBackground,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('About Screen'),
    );
  }
}
