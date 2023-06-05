import 'dart:io';

import 'package:flutter/material.dart';
import 'color_config.dart';



class ArtGallery extends StatefulWidget {
  const ArtGallery({Key? key}) : super(key: key);

  @override
  State<ArtGallery> createState() => _ArtGalleryState();
}

class _ArtGalleryState extends State<ArtGallery> {

  List imgList=[];
  getImages()async{
    final directory=Directory("storage/emulated/0/AI Image");
    if(await directory.exists()){
      imgList=directory.listSync();
      print(imgList);
    }else {
      await directory.create(recursive: true);
    }
  }


  popUpImage(filepath){
    showDialog(context: context,
        builder: (context)=>Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          child: Container(
            height: 300,width: 300,
            decoration: BoxDecoration(
              color: wColor,borderRadius: BorderRadius.circular(12),
            ),
            child: Image.file(filepath,fit: BoxFit.cover,),
          ),
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Art Gallery'),
        centerTitle: true,
        backgroundColor: bgColor,
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,crossAxisSpacing: 8,mainAxisSpacing: 8
          ),
          itemCount: imgList.length,
          itemBuilder: (BuildContext context,int index){
            return GestureDetector(
              onTap: (){
                popUpImage(imgList[index]);
              },
              child: Container(
                clipBehavior:Clip.antiAlias ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Image.file(imgList[index]),
              ),
            );
          }
      )
    );
  }
}
