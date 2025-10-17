import 'package:flutter/material.dart';
import 'package:flippra/screens/widget/requestoptioncard.dart';

class RequestOption extends StatelessWidget {
  const RequestOption({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: const Color(0xFF00B3A7),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(16),
            children:  [
              Container(
                child: Text("Product | Variation ",style: TextStyle(
                  color: Colors.white
                ),),
              ),
              SizedBox(height: 10,),
              RequestOptionCard(),
              SizedBox(height: 12),
              RequestOptionCard(),
              SizedBox(height: 12),
              RequestOptionCard(),
              SizedBox(height: 12),
              RequestOptionCard(),
            ],
          ),
        );
      },
    );
  }
}
