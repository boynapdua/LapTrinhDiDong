import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laptrinhuddd/widgets/login.dart';
import 'package:laptrinhuddd/widgets/video.dart';
import 'CameraScreen.dart';
import 'ImageAnalyzer.dart';
import 'favourite.dart';
import 'home_page.dart';
import 'package:image_picker/image_picker.dart';

class HomeNavBar extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final Size size = MediaQuery.of(context).size;
    double fullWidth = MediaQuery.of(context).size.width;
    final ImagePicker _imagePicker = ImagePicker();
    Future<void> _pickImage() async {
      final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ImageAnalyzer(imagePath: pickedFile.path);
          },
        );
      }
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage())
              );
            },
            child: Icon(
              Icons.home,
              color: Colors.white,
              size: 35,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => favouriteList())
              );
            },
            child: Icon(
              Icons.favorite_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 100,
                      width: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CameraScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(fullWidth, 50),
                                elevation: 0, // Remove shadow
                              ),
                              child: Text("Chụp ảnh")
                          ),
                          ElevatedButton(
                              onPressed: _pickImage,
                              style: ElevatedButton.styleFrom(
                                elevation: 0, // Remove shadow
                                minimumSize: Size(fullWidth, 50),
                              ),
                              child: Text("Chọn ảnh từ thư viện")
                          ),
                        ],
                      ),
                    );
                  }
              );
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Color(0xFFEFB322),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 8,
                    )
                  ]
              ),
              child: Icon(
                CupertinoIcons.camera,
                color: Colors.white,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => videoCocktail())
              );
            },
            child: Icon(
              Icons.video_camera_back_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 370,
                        maxWidth: 450,
                      ),
                      child: AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Tài khoản",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        content: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 5),
                              leading: SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.account_circle,
                                  size: 30,
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nhóm 10",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    "LTUD&DD",
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 5),
                              leading: Icon(Icons.logout),
                              title: Text("Đăng xuất"),
                              onTap: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => MyLogin()));
                              },
                            ),
                          ],
                        ),
                      ),

                    ),
                  );
                },
              );
            },
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
