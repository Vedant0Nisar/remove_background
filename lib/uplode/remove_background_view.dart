import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remove_bg/remove_bg.dart';

class RemoveBackgroundView extends StatefulWidget {
  @override
  State<RemoveBackgroundView> createState() => _RemoveBackgroundViewState();
}

class _RemoveBackgroundViewState extends State<RemoveBackgroundView> {
  // final controller = Get.put(UplodeController());

  bool imgPicked = false;
  double linearProgress = 0;
  File? file;
  String? fileName;
  Future pickImage() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return;
      // final Uint8List imageTemp = result.files.first.bytes!;
      setState(() {
        fileName = result.files.first.name;
        file = File(result.files.single.path!);
        imgPicked = true;
      });
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Uint8List? bytes;

  Future<String> getFilePath(String uniqueFileName) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();

    String appDocumentsPath = appDocumentsDirectory.path;

    String filePath = '$appDocumentsPath/$uniqueFileName';

    return filePath;
  }

  Future<void> saveFile(Uint8List bytes, String fileName) async {
    String filePath = await getFilePath(fileName);

    File file = File(filePath);

    await file.writeAsBytes(bytes);

    print('File saved to $filePath');
  }

  saveImageToGallery(Uint8List bytes, fileName) async {
    final result = await ImageGallerySaver.saveImage(bytes, name: fileName);
    print('Image saved to gallery: $result');
  }

  bool showSaveButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remove BG"),
        backgroundColor: Color.fromARGB(255, 110, 191, 249),
        leading: Icon(Icons.menu),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: imgPicked
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            if (bytes != null) Image.memory(bytes!),
                            SizedBox(
                              height: 20,
                            ),
                            if (file != null)
                              LinearProgressIndicator(value: linearProgress),
                            SizedBox(
                              height: 50,
                            ),
                            SizedBox(
                              height: 240,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Image.file(
                                          file!,
                                          height: 100,
                                          width: double.infinity,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("FileName: $fileName"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            showSaveButton
                                ? Container(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            saveImageToGallery(
                                                bytes!, fileName);

                                            print(
                                                "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
                                            print(bytes!);
                                            print(file);
                                            print(
                                                "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: Text(
                                              "Save to Gallary",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Noto Sans',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                                255, 251, 252, 253),
                                            shape: StadiumBorder(
                                                side: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 110, 191, 249))),
                                          )

                                          //
                                          ),
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Remove().bg(
                                                file!,
                                                privateKey:
                                                    "U99CHgN7TFJ4KVLfrYeLadz6", // (Keep Confidential)
                                                onUploadProgressCallback:
                                                    (progressValue) {
                                                  if (kDebugMode) {
                                                    print(progressValue);
                                                  }
                                                  setState(() {
                                                    linearProgress =
                                                        progressValue;
                                                  });
                                                },
                                              ).then((data) async {
                                                if (kDebugMode) {
                                                  print(data);
                                                }
                                                bytes = data;
                                                showSaveButton = true;
                                                // bytes = (await File("filename.png")
                                                //         .writeAsString(
                                                //             data as String))
                                                //     as Uint8List?;
                                                // Directory appDocumentsDirectory =
                                                //     await getApplicationDocumentsDirectory(); // 1
                                                // String appDocumentsPath =
                                                //     appDocumentsDirectory.path; // 2
                                                // String filePath =
                                                //     '$appDocumentsPath/demoTextFile.png'; // 3
                                                // File file = File(filePath); // 1
                                                // file.writeAsString(
                                                //     data as String); // 2
                                                // String fileContent =
                                                //     await file.readAsString(); // 2

                                                // print('File Content: $fileContent');
                                                // await saveFile(bytes!, fileName!);

                                                setState(() {});
                                              });
                                            },
                                            child: Text(
                                              "Remove Background",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Noto Sans',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 110, 191, 249),
                                              shape: StadiumBorder(),
                                            )

                                            //
                                            ),
                                      ),
                                    ),
                                  ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 100),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          imgPicked = false;
                                          file = null;
                                          bytes = null;
                                          linearProgress = 0.0;
                                          showSaveButton = false;
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: Text(
                                          "Back",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Noto Sans',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 251, 252, 253),
                                        shape: StadiumBorder(
                                            side: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 110, 191, 249))),
                                      )

                                      //
                                      ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: DottedDecoration(
                            strokeWidth: 2,
                            shape: Shape.box,
                            color: Colors.green,

                            borderRadius: BorderRadius.circular(
                                10), //remove this to get plane rectange
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 40),
                            child: ElevatedButton(
                                onPressed: () {
                                  pickImage();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 110, 191, 249),
                                  shape: StadiumBorder(),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text(
                                    " Uplode the PNG ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Noto Sans',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                )

                                //
                                ),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
