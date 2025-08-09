import 'dart:ui';
import 'package:flutter/material.dart';

const Color _darkPurpleBlue = Color(0xFF26147A);
const Color _lightPurplePink = Color(0xFF8C057C);
const Color _whiteWithOpacity = Color.fromRGBO(255, 255, 255, 0.7);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  int currentStartIndex = 0;

  final List<Map<String, String>> forecastData = [
    {"day": "Mon", "temp": "19°C", "icon": "cloudy_snowing"},
    {"day": "Tue", "temp": "18°C", "icon": "wb_cloudy_outlined"},
    {"day": "Wed", "temp": "18°C", "icon": "thunderstorm_outlined"},
    {"day": "Thu", "temp": "19°C", "icon": "sunny"},
    {"day": "Fri", "temp": "20°C", "icon": "partly_cloudy"},
    {"day": "Sat", "temp": "22°C", "icon": "cloud"},
    {"day": "Sun", "temp": "21°C", "icon": "sunny"},
  ];

  @override
  Widget build(BuildContext context) {
    // Create the list of 4 days to display based on currentStartIndex
    List<Map<String, String>> daysToShow = forecastData
        .sublist(currentStartIndex, (currentStartIndex + 4) > forecastData.length ? forecastData.length : currentStartIndex + 4);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _darkPurpleBlue,
              _lightPurplePink,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 50),
              _buildLocationAndTemperature(),
              SizedBox(height: 40),
              _buildWeatherNavigation(daysToShow),
              SizedBox(height: 30),
              _buildAirQuality(),
              SizedBox(height: 20),
              _buildSunAndUVInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationAndTemperature() {
    return Center(
      child: Column(
        children: [
          Text(
            'North America',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Max: 24°   Min: 18°',
            style: TextStyle(
              color: _whiteWithOpacity,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherNavigation(List<Map<String, String>> daysToShow) {
    return Column(
      children: [
        Text(
          'Weather Forecast',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20),
        // Displaying 4 days with arrows beside
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: _whiteWithOpacity, size: 30),
              onPressed: _showPreviousForecast,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: daysToShow.map((dayData) {
                  return WeatherCard(
                    day: dayData["day"]!,
                    temperature: dayData["temp"]!,
                    icon: _getIconForWeather(dayData["icon"]!),
                  );
                }).toList(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: _whiteWithOpacity, size: 30),
              onPressed: _showNextForecast,
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  void _showNextForecast() {
    setState(() {
      if (currentStartIndex + 4 < forecastData.length) {
        currentStartIndex += 1;
      }
    });
  }

  void _showPreviousForecast() {
    setState(() {
      if (currentStartIndex > 0) {
        currentStartIndex -= 1;
      }
    });
  }

  Widget _buildAirQuality() {
    return FrostedGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.my_location, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'AIR QUALITY',
                  style: TextStyle(
                    color: _whiteWithOpacity,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '3-Low Health Risk',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'See more',
                  style: TextStyle(
                    color: _whiteWithOpacity,
                    fontSize: 16,
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: _whiteWithOpacity, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSunAndUVInfo() {
    return Row(
      children: [
        Expanded(
          child: WeatherInfoCard(
            icon: Icons.wb_sunny_sharp,
            title: 'SUNRISE',
            value: '5:28 AM',
            subtitle: 'Sunset: 7:25PM',
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: WeatherInfoCard(
            icon: Icons.wb_sunny_outlined,
            title: 'UV INDEX',
            value: '4',
            subtitle: 'Moderate',
          ),
        ),
      ],
    );
  }

  IconData _getIconForWeather(String iconName) {
    switch (iconName) {
      case "cloudy_snowing":
        return Icons.cloudy_snowing;
      case "wb_cloudy_outlined":
        return Icons.wb_cloudy_outlined;
      case "thunderstorm_outlined":
        return Icons.thunderstorm_outlined;
      case "sunny":
        return Icons.sunny;
      case "partly_cloudy":
        return Icons.cloud;
      default:
        return Icons.cloud;
    }
  }
}

class WeatherCard extends StatelessWidget {
  final String day;
  final String temperature;
  final IconData icon;

  WeatherCard({
    required this.day,
    required this.temperature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedGlassCard(
      borderRadius: 25,
      child: Container(
        width: 70,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              temperature,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 10),
            Text(
              day,
              style: TextStyle(
                color: _whiteWithOpacity,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  WeatherInfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedGlassCard(
      borderRadius: 20,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: _whiteWithOpacity,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: _whiteWithOpacity,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FrostedGlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  FrostedGlassCard({required this.child, this.borderRadius = 20.0});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
