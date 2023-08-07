import 'package:flutter/material.dart';

class CustLoading extends StatelessWidget {
  final double size;
  const CustLoading({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}
