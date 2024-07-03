import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remove_bg/remove_bg.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

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
              /*     Center(
                    child: MaterialButton(
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent.withOpacity(0),
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 220,
                                child: bottomMediaSelectionPopUp(context),
                              );
                            });
                      },
                      shape: StadiumBorder(),
                      color: Color.fromARGB(255, 110, 191, 249),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Text("Uplode Image"),
                      ),
                    ),
                  ),
                */
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

  Widget bottomMediaSelectionPopUp(BuildContext context) {
    return Center(
      child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
              padding: EdgeInsets.only(bottom: 30.0, left: 5, right: 5),
              child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      // Navigator.pop(context);
                                      // final XFile? photo =
                                      //     await controller.picker.pickImage(
                                      //         source: ImageSource.camera);

                                      // ImagePicker imagePicker = ImagePicker();
                                      // XFile? compressedImage =
                                      //     await imagePicker.pickImage(
                                      //   source: ImageSource.camera,
                                      // );
                                      // Get.back();
                                      // showDialog(
                                      //     barrierDismissible: false,
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       if (compressedImage != null) {
                                      //         return recordingDonePopUp(context,
                                      //             compressedImage, "image");
                                      //       } else {
                                      //         navigator?.pop();
                                      //       }
                                      //       return Container();
                                      //     });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                            height: 60,
                                            imageUrl:
                                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxRyp9Ddz8Bh6cfLY7_-2JXsr-yFECiWQIE_E-rFc25htKApZjRnvWKtcRQIRgkR7UNVI&usqp=CAU"),
                                        Text(
                                          'Take Photo',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Noto Sans',
                                            color: Color(0xff06184B),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      /*      GestureDetector(
                                        onTap: () async {
                                          //Navigator.of(context).pop();
                                          // final XFile? imagePicker = await controller.picker.pickVideo(source: ImageSource.gallery);
                                          // ImagePicker imagePicker =
                                          //     ImagePicker();
                                          // XFile? compressedImage =  await imagePicker.pickMedia( );

                                          final compressedImage =
                                              await FilePicker.platform
                                                  .pickFiles();
                                          // print(compressedImage.files.single.path.toString());
                                          // print("tttttttttyyyyyyypppppeeee");
                                          // print(compressedImage?.files.runtimeType);

                                          // printing length of file
                                          File imageFile = File(compressedImage!
                                              .files.single.path
                                              .toString());
                                          int fileSizeInBytes =
                                              await imageFile.length();
                                          // print("here is compressedImage22");
                                          // print(imageFile);

                                          // converted FilePickerResult into Xfile
                                          var file =
                                              compressedImage!.files.first;
                                          XFile? ConvertedImage = XFile(
                                              file.path!,
                                              name: file.name,
                                              bytes: file.bytes,
                                              length: file.size);
                                          String ext = ConvertedImage.path
                                              .split('.')
                                              .last
                                              .toLowerCase();
                                          // print("tttttttttyyyyyyypppppeeeewwwwwwww");
                                          // print(ext);

                                          // output of file extension
                                          if (ext == 'mp4' ||
                                              ext == 'avi' ||
                                              ext == 'mov') {
                                            controller.isselectedFileisvideo
                                                .value = true;
                                          } else if (ext == 'jpg' ||
                                              ext == 'jpeg' ||
                                              ext == 'png') {
                                            controller.isselectedFileisvideo
                                                .value = false;
                                          }

//////////////////////////////////////////
                                          navigator?.pop();
//////////////////////////////////////////

                                          if (controller.isselectedFileisvideo
                                                  .value ==
                                              true) {
                                            // selected file is video
                                            if (ConvertedImage != null) {
                                              // File imageFile = File(compressedImage.files.single.path.toString());
                                              // print("here is compressedImage22");
                                              // print(imageFile);
                                              // int fileSizeInBytes = await imageFile.length();
                                              //
                                              // var file = compressedImage.files.first;
                                              //
                                              // XFile? gogoImage = XFile(file.path!, name: file.name, bytes: file.bytes, length: file.size);
                                              // print("compressedImage?.path2");
                                              // print(gogoImage.path);
                                              // print(gogoImage.toString());

                                              controller
                                                  .generateThumbnailFileFromVideoAssets(
                                                      ConvertedImage.path ??
                                                          "");
                                              print("thumb nail done");

                                              // Check if the video size is less than 5 MB (5 * 1024 * 1024 bytes)
                                              if (fileSizeInBytes <=
                                                  15 * 1024 * 1024) {
                                                // ignore: use_build_context_synchronously
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      if (compressedImage !=
                                                          null) {
                                                        return recordingDonePopUp(
                                                            context,
                                                            ConvertedImage,
                                                            "video");
                                                      } else {
                                                        navigator?.pop();
                                                      }
                                                      return Container();
                                                    });
                                              } else {
                                                // Display an error message or take appropriate action for oversized images.
                                                // For example, you can show a toast message.
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Selected video is too large (Max 15 MB)'),
                                                  ),
                                                );

                                                // showDialog(
                                                //     barrierDismissible: true,
                                                //     context: context,
                                                //     builder: (BuildContext context) {
                                                //   return Text("Selected image is too large (Max 5 MB)");
                                                //     });
                                              }
                                            }
                                          } else if (controller
                                                  .isselectedFileisvideo
                                                  .value ==
                                              false) {
                                            // selected file is image
                                            if (ConvertedImage != null) {
                                              //
                                              // // var file = compressedImage.files.first;
                                              // var file = compressedImage.files.first;
                                              //
                                              // XFile? gogoImage = XFile(file.path!, name: file.name, bytes: file.bytes, length: file.size);
                                              // print("compressedImage?.path2");
                                              // print(gogoImage.path);
                                              // print(gogoImage.toString());

                                              // Check if the image size is less than 5 MB (5 * 1024 * 1024 bytes)
                                              print("Sizeeeeeeeeeeee");
                                              // print(compressedImage!.paths.length );
                                              print(fileSizeInBytes);
                                              if (fileSizeInBytes <=
                                                  5 * 1024 * 1024) {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      if (ConvertedImage !=
                                                          null) {
                                                        return recordingDonePopUp(
                                                          context,
                                                          ConvertedImage,
                                                          "image",
                                                        );
                                                      } else {
                                                        navigator?.pop();
                                                      }
                                                      return Container();
                                                    });
                                              } else {
                                                // Display an error message or take appropriate action for oversize images.
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                   SnackBar(
                                                    content: Text(
                                                        'Selected image is too large (Max 15 MB)'),
                                                  ),
                                                );

                                                // showDialog(
                                                //     barrierDismissible: true,
                                                //     context: context,
                                                //     builder: (BuildContext context) {
                                                //   return Text("Selected image is too large (Max 5 MB)");
                                                //     });
                                              }
                                            }
                                          }

                                          // ActivityUploadResponseModel data = await controller.uploadFiles(compressedImage!,'image');
                                          // if(data.isOK ?? false){
                                          //   //CustomViews.showDefaultSnackBar("Hi" , data.message ?? "");
                                          //   controller.getActivityDetails();
                                          // }else{
                                          //   CustomViews.showDefaultSnackBar("Hi" , data.message ?? "");
                                          // }
                                        },
                                        child: CachedNetworkImage(
                                            height: 60,
                                            imageUrl:
                                                "https://cdn-icons-png.freepik.com/512/685/685685.png"),
                                      ), */
                                      Text("Choose from gallery",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff06184B),
                                          )),
                                    ],
                                  ),
                                )
                              ]),
                        )),
                    Positioned(
                      bottom: -17,
                      height: 40,
                      width: 171,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, "ok");
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'noto_sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        //   ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 110, 191, 249),
                          shape: StadiumBorder(),
                        ),
                      ),
                    )
                  ]))),
    );
  }

  Widget recordingDonePopUp(
      BuildContext context, XFile photo, String mediaType) {
    return Center(
        child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 23,
                                    left: 17,
                                  ),
                                  child: Image.asset(
                                    'assets/images/right_mark_green.png',
                                    height: 22,
                                    width: 22,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 23,
                                    left: 5,
                                  ),
                                  child: Text(
                                    // controller.activityDetails.value
                                    //     .recordingText?.reCCOMPLETETITLE ??
                                    "controller.memoryLaneData.value.uploadConsentTitle!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Noto Sans',
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff06184B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 15, left: 17, right: 26, bottom: 35),
                              child: Text(
                                // controller.activityDetails.value.recordingText
                                //         ?.reCCOMPLETEDESC ??
                                "controller.memoryLaneData.value.uploadConsentSubtitle" ??
                                    "",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff999999),
                                ),
                              ),
                            ),
                          ])),
                  Positioned(
                    bottom: -17,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);

                              ProgressDialog pd = ProgressDialog(
                                  context:
                                      "controller.scaffoldKey.currentContext");
                              pd.show(
                                  max: 100,
                                  msg: 'Uploading....',
                                  progressType: ProgressType.valuable,
                                  progressBgColor: Colors.white,
                                  progressValueColor: Colors.purpleAccent,
                                  valueFontWeight: FontWeight.w900);
                              pd.update(
                                  // value: controller.uploadProgress.value,
                                  );

                              pd.close();
                            },
                            child: Text(
                              "controller.memoryLaneData.value.uploadConsentAction1Text!",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),

                            //   ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffA88ADA),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "controller.memoryLaneData.value.uploadConsentAction2Text!" ??
                                  "",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            //   ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffA88ADA),
                              shape: StadiumBorder(),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ])));
  }
}
