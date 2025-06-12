import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Day19Page extends StatefulWidget {
  const Day19Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day19PageState();
}

class _Day19PageState extends State<Day19Page> {
  final imagePicker = ImagePicker();
  final _pageController = PageController();
  List imageList = [];
  int currentIndex = 1;

  void selectImage() async {
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageList.add(pickedImage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imageList.isNotEmpty
            ? "$currentIndex / ${imageList.length}"
            : "사진 갤러리 뷰어"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            imageList.isNotEmpty
                ? Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: imageList.length,
                      itemBuilder: (context, index) {
                        return Image.file(
                          File(imageList[index].path),
                        );
                      },
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index + 1;
                        });
                      },
                    ),
                  )
                : const Text(
                    "사진을 선택해주세요.",
                    textAlign: TextAlign.center,
                  ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: selectImage,
              child: const Text("사진 선택"),
            ),
          ],
        ),
      ),
    );
  }
}
