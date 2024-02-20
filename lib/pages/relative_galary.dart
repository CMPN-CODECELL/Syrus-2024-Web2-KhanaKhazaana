import 'package:flutter/cupertino.dart';
import 'package:syrus24/pages/sliding_cards.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return SlidingCardsView();
  }
}
