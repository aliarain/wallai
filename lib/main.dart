import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'fullscreen_image.dart';



class WallScreen extends StatefulWidget {
  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpaperList;

  final CollectionReference collectionReference = Firestore.instance.collection("wallpapers");


  @override
  void initState() {
    super.initState();

subscription = collectionReference.snapshots().listen((datasnapshots){
  setState(() {
    wallpaperList = datasnapshots.documents;
  });
});
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wallai"),), //App Bar
      body: wallpaperList != null?
      new StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 4,
        itemCount: wallpaperList.length,
        itemBuilder: (context,i){
          String imgPath = wallpaperList[i].data['url'];
          return new Material(
            elevation: 8.0,
            borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
            child: new InkWell(
              onTap: ()=> Navigator.push(context, new MaterialPageRoute(
                  builder: (context)=>new FullScreenImagePage(imgPath)
              )),
              child: new Hero(tag:
              imgPath,
                  child: FadeInImage(image:
                  NetworkImage(imgPath),
                  fit: BoxFit.cover,
                    placeholder: new AssetImage("assets/wally.png"),
                  )),
            ),
          );
        },
        staggeredTileBuilder: (i) => new StaggeredTile.count(2, i.isEven?2:3),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ):new Center(child: new CircularProgressIndicator(),)
    );
  }
}
