import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'api_services.dart';
import 'art_galllery.dart';
import 'color_config.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var sizes = ['small', 'Medium', 'Large'];
  var values = ['256x256', '512x512', '1024x1024'];
  String? dropValue;
  var textContoller = TextEditingController();
  String image = '';
  var isLoaded = false;

  ScreenshotController screenshotController = ScreenshotController();



  downloadImage() async {
    var result = await Permission.storage.request();
    if (result.isGranted) {
      final folderName = "AI Image";
      //final directory = await getApplicationDocumentsDirectory();
      // final path =
      // Directory("storage/emulated/0/${directory.path}/$folderName");
      final path=Directory("storage/emulated/0/$folderName");
      final fileName = "${DateTime.now().millisecondsSinceEpoch}.png";
      if (await path.exists()) {
        await screenshotController.captureAndSave(path.path,
            delay: Duration(milliseconds: 100),
            fileName: fileName,
            pixelRatio: 1.0);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloaded to ${path.path}')));
      } else {
        await path.create();
        await screenshotController.captureAndSave(path.path,
            delay: Duration(milliseconds: 100),
            fileName: fileName,
            pixelRatio: 1.0);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloaded to ${path.path}')));
      }
    }
  }



  shareImage() async {
    await screenshotController
        .capture(delay: Duration(milliseconds: 100), pixelRatio: 1.0)
        .then((Uint8List? img) async {
      if (img != null) {
        final directory = (await getApplicationDocumentsDirectory()).path;
        final fileName = "Share.png";
        final imgPath = await File("${directory}/${fileName}").create();
        await imgPath.writeAsBytes(img);

        Share.shareFiles([imgPath.path], text: 'Generated by AI - Shah g!');
      } else {
        print('Failed to Take a ScreenShot');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor,
                  padding: EdgeInsets.all(8),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ArtGallery()));
                  //print('tap');
                },
                child: Row(
                  children: [
                    Text('My Arts'),
                    Icon(
                      Icons.download_for_offline_rounded,
                      size: 16,
                    )
                  ],
                )),
          ),
        ],
        centerTitle: true,
        title: const Text(
          'Ai Image Generator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: wColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: wColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: TextFormField(
                          controller: textContoller,
                          decoration: const InputDecoration(
                            hintText:
                                "eg 'A monkey on moon'", // Shown when the form field is empty
                            border: InputBorder
                                .none, // Border around the form field
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Container(
                    height: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                        color: wColor, borderRadius: BorderRadius.circular(12)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                      icon: Icon(
                        Icons.expand_more,
                        color: btnColor,
                      ),
                      value: dropValue,
                      hint: const Text('selectSize'),
                      items: List.generate(
                          sizes.length,
                          (index) => DropdownMenuItem(
                              value: values[index], child: Text(sizes[index]))),
                      onChanged: (value) {
                        setState(() {
                          dropValue =
                              value as String?; // Cast the value to a String
                        });
                      },
                    )))
              ],
            ),
            SizedBox(
              height: 40,
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor, shape: const StadiumBorder()),
                child: const Text('Generate'),
                onPressed: () async {
                  if (textContoller.text.isNotEmpty && dropValue!.isNotEmpty) {
                    setState(() {
                      isLoaded = false;
                    });
                    image =
                        await Api.generateImage(textContoller.text, dropValue!);
                    setState(() {
                      isLoaded = true;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please enter query and select size')));
                  }
                },
              ),
            ),
            SizedBox(
              height: 19,
            ),
            Expanded(
                flex: 4,
                child: isLoaded
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Screenshot(
                                controller: screenshotController,
                                child: Image.network(
                                  image,
                                  fit: BoxFit.contain,
                                ),
                              )),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton.icon(
                                onPressed: () {
                                  downloadImage();
                                },
                                icon: Icon(Icons.download_for_offline_rounded),
                                label: Text('Download'),
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8),
                                    backgroundColor: btnColor),
                              )),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: ElevatedButton.icon(
                                onPressed: () async {
                                  await shareImage();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Image Shared')));
                                },
                                icon: Icon(Icons.share),
                                label: Text('Share'),
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8),
                                    backgroundColor: btnColor),
                              )),
                            ],
                          )
                        ],
                      )
                    : Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: bgColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/loading.gif',
                              width: 230,
                            ),
                            Text(
                              'waiting for image to be generated....',
                              style: TextStyle(fontSize: 16, color: wColor),
                            )
                          ],
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}






// downloadImage() async {
//   var status = await Permission.storage.status;
//   if (status.isGranted) {
//     final folderName = "AI Image";
//     final path = Directory("storage/emulated/0/$folderName");
//     final fileName = "${DateTime.now().millisecondsSinceEpoch}.png";
//     if (await path.exists()) {
//       await screenshotController.captureAndSave(path.path,
//           delay: Duration(milliseconds: 100),
//           fileName: fileName,
//           pixelRatio: 1.0);
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Downloaded to ${path.path}')));
//     } else {
//       await path.create();
//       await screenshotController.captureAndSave(path.path,
//           delay: Duration(milliseconds: 100),
//           fileName: fileName,
//           pixelRatio: 1.0);
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Downloaded to ${path.path}')));
//     }
//   } else if (status.isDenied || status.isPermanentlyDenied) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: Text('Permission Required'),
//         content: Text(
//           'Please grant storage permission to download images.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               Navigator.of(context).pop();
//               status = await Permission.storage.request();
//               if (status.isGranted) {
//                 downloadImage();
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text('Permission not granted. Unable to download image.')));
//               }
//             },
//             child: Text('Grant Permission'),
//           ),
//         ],
//       ),
//     );
//   }
// }