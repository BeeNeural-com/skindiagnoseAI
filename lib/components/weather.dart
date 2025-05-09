import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dtreatyflutter/weather_services/weather_services.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  WeatherData? globalWeatherData;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final data = await WeatherService().fetchWeatherData(35.92, 74.30);
      setState(() {
        globalWeatherData = data;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'SkinDiagnose',
          style: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 236, 116, 12), // Main theme color
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Tagline
        Text(
          'Scan. Detect. Stay Healthy',
          style: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: globalWeatherData == null
              ? SpinKitWaveSpinner(
                  color: const Color(0xFF2A9D2E),
                  waveColor: Colors.green,
                  trackColor: Colors.green.shade200,
                  size: 70,
                )
              : _buildWeatherInfo(globalWeatherData!),
        ),
      ],
    );
  }

  Widget _buildWeatherInfo(WeatherData weather) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildUvIndexCard(weather),
          const SizedBox(width: 20),
          _buildSkinTypeCard(weather.uvIndex.toDouble()),
        ],
      ),
    );
  }

  Widget _buildUvIndexCard(WeatherData weather) {
    double uv = weather.uvIndex.toDouble();

    // Calculate slider thumb position (based on UV range: 0 - 11+)
    double sliderValue = uv.clamp(0, 11);

    return Container(
      width: 150,
      height: 126,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // UV Index Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wb_sunny_outlined,
                  size: 20, color: Colors.black54),
              const SizedBox(width: 5),
              Text(
                'UV INDEX',
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // UV Level Number
          Text(
            '${uv.toStringAsFixed(0)} level',
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // UV Slider (colored bar)
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [
                      Colors.green,
                      Colors.yellow,
                      Colors.orange,
                      Colors.red,
                      Colors.purple,
                    ],
                  ),
                ),
              ),
              Positioned(
                left: (sliderValue / 11) *
                    230, // 230 is width - thumb width offset
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSkinTypeCard(double uvIndex) {
    String skinType = '';
    List<Color> skinColors = [];

    // Decide skin type and colors based on UV index
    if (uvIndex <= 2) {
      skinType = 'Fair';
      skinColors = [Colors.brown.shade200, Colors.brown.shade300];
    } else if (uvIndex <= 5) {
      skinType = 'Olive';
      skinColors = [Colors.brown.shade400, Colors.brown.shade500];
    } else if (uvIndex <= 7) {
      skinType = 'Tan';
      skinColors = [Colors.brown.shade600, Colors.brown.shade700];
    } else {
      skinType = 'Dark';
      skinColors = [Colors.brown.shade800, Colors.brown.shade900];
    }

    return Container(
      width: 150,
      height: 126,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Skin Type Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wb_sunny_outlined,
                  size: 18, color: Colors.black54),
              const SizedBox(width: 4),
              Text(
                'SKIN TYPE',
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Circles + Skin Type Name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: skinColors[0],
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned(
                    left: 14,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: skinColors[1],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Text(
                skinType,
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Skin Type Description
          Text(
            'These Skin Types Need Care',
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
