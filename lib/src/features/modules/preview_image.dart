import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PreviewImage extends StatefulWidget {
  final String? image;
  const PreviewImage({super.key, this.image});

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Preview Image'),
        ),
        body: Container(
          child: PhotoView(
              imageProvider:
                  AssetImage(widget.image ?? 'assets/images/placeholder.png')),
        ));
  }
}
