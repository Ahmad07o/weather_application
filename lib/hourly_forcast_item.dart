import "package:flutter/material.dart";

class HourlyForcastItem extends StatelessWidget {
  const HourlyForcastItem({super.key});

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
                "9:00",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Icon(Icons.cloud, size: 32),
              SizedBox(height: 8),
              Text("320.12"),
            ],
          ),
        ),
      ),
    );
  }
}
