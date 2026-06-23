import 'package:flutter/material.dart';

class BacroundWidget extends StatelessWidget {
  final Widget child;
  const BacroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Image.asset('assets/image/bacround4.png',height: MediaQuery.of(context).size.height,fit: BoxFit.cover,),
        Image.asset('assets/image/bacround1.png',height: MediaQuery.of(context).size.height,fit: BoxFit.cover,),
        child,
      ],
    );
  }
}
