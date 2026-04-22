import "package:flutter/material.dart";

class HourlyForcastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temprature;
  const HourlyForcastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temprature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: SizedBox(
        width: 100,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Icon(icon, size: 32),
              SizedBox(height: 8),
              Text(temprature),
            ],
          ),
        ),
      ),
    );
  }
}
