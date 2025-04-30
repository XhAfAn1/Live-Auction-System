import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 6,
        child: Scaffold(
            backgroundColor: Colors.white,

            appBar: AppBar(
              toolbarHeight: 50,
              backgroundColor: Colors.white ,
              title: Text("facebook",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.blue[700]),),
              actions: [
                IconButton(onPressed: (){}, icon: Icon(Icons.add_circle)),
                IconButton(onPressed: (){}, icon: Icon(Icons.search)),
                IconButton(onPressed: (){}, icon: Icon(Icons.mode_comment)),

              ],
              bottom: TabBar(
                //  isScrollable: true,
                  indicatorColor:Colors.blue[700],
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.blue[700],
                  unselectedLabelColor: Colors.black87,
                  tabs: [
                    Tab(
                        icon: Icon(Icons.home_filled,size: 28,)
                    ),
                    Tab(
                        icon: Icon(Icons.ondemand_video_outlined,size:28)
                    ),
                    Tab(
                        icon: Icon(Icons.storefront,size:28)
                    ),
                    Tab(
                        icon: Icon(Icons.videogame_asset_outlined,size:28)
                    ),

                    Tab(
                        icon: Icon(Icons.notifications_none,size:28)
                    ),
                    Tab(
                        icon: Icon(Icons.menu,size:28)
                    ),
                  ]),
            ),

            body:

            TabBarView(
                children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(color: Colors.white,
                  child: Column(
                    children: [

                      //status part

                      Container(

                          height: 60,
                          child:
                          Row(children: [

                            Container(width:8,),
                            CircleAvatar(
                              backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRXxfn1j1vKFy8yJeBGl2AS6Dcah-lKgHofg&s"),
                              child: Icon(Icons.person),
                              radius:25,
                            ),
                            Container(width: 12,),
                            Container(
                              margin: EdgeInsets.only(top: 10,bottom: 10),
                              width: 280,
                              //color: Colors.green,
                              child: TextField(

                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 10,bottom: 10,left: 23),
                                  hintText: "What's on your mind?",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(60),borderSide: BorderSide(color: Colors.grey,width: 0.8) ),


                                ),



                              ),

                            ),
                            Container(width: 17,),
                            Container(
                              child:
                              Icon(Icons.photo_rounded,color: Colors.green[600]),

                            )

                          ],)
                      ),
                      Container(
                        color: Colors.grey[350],
                        height: 4,
                      ),


                      // story section


                      Container(

                        color: Colors.white,
                        height: 220,
                        child:
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                height: 200, width: 120,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.white10),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 140, width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topLeft:Radius.circular(15),topRight: Radius.circular(15) ),
                                          image: DecorationImage(fit: BoxFit.cover,image: NetworkImage( "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRXxfn1j1vKFy8yJeBGl2AS6Dcah-lKgHofg&s",),)),
                                    ),

                                    Container(
                                      height: 60, width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft:Radius.circular(15),topRight: Radius.circular(15) ),

                                      ),
                                      child:

                                      Center(child: Text("Create \n stroy")),

                                    )
                                  ],
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(left: 8),
                                height: 200, width: 120,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.red),

                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                height: 200, width: 120,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.blue),

                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                height: 200, width: 120,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.grey),

                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                height: 200, width: 120,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.pink),

                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                height: 200, width: 120,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.blueGrey),

                              ),




                            ],),
                        ),
                      ),
                      Container(
                        color: Colors.grey[350],
                        height: 4,
                      ),



                      //1st post


                      Container(
                          height: 400,
                          width: double.infinity,



                          color: Colors.green,
                          child:
                          Column(
                            children: [
                              Container(
                                  height: 60,
                                  width: double.infinity,
                                  //decoration: BoxDecoration(
                                  child:
                                  Row(

                                      children: [
                                        Container(
                                          width:8,),

                                        CircleAvatar(
                                          backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRXxfn1j1vKFy8yJeBGl2AS6Dcah-lKgHofg&s"),
                                          child: Icon(Icons.person),
                                          radius:25,
                                        ),

                                        //Container(width: 12,),
                                        Container(
                                          margin: EdgeInsets.only(top: 10,bottom: 10,left: 10),
                                          width: 120,
                                          child:
                                          Text("Sanrio",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),),
                                        ),

                                      ]


                                  )

                              ),
                              Container(
                                height: 20,
                                width: double.infinity,
                              ),

                              Container(
                                height: 320,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    image: DecorationImage(fit: BoxFit.cover,image: NetworkImage( "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRXxfn1j1vKFy8yJeBGl2AS6Dcah-lKgHofg&s",),)),
                              )
                            ],
                          )


                      ),

                      Container(
                        color: Colors.grey[350],
                        height: 4,
                      ),



                      //2nd story



                      Container(
                          height: 400,
                          width: double.infinity,



                          color: Colors.green,
                          child:
                          Column(
                            children: [
                              Container(
                                  height: 60,
                                  width: double.infinity,
                                  //decoration: BoxDecoration(
                                  child:
                                  Row(

                                      children: [
                                        Container(
                                          width:8,),

                                        CircleAvatar(
                                          backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRXxfn1j1vKFy8yJeBGl2AS6Dcah-lKgHofg&s"),
                                          child: Icon(Icons.person),
                                          radius:25,
                                        ),

                                        //Container(width: 12,),
                                        Container(
                                          margin: EdgeInsets.only(top: 10,bottom: 10,left: 10),
                                          width: 120,
                                          child:
                                          Text("Sanrio",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),),
                                        ),

                                      ]


                                  )

                              ),
                              Container(
                                height: 20,
                                width: double.infinity,
                              ),

                              Container(
                                height: 320,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    image: DecorationImage(fit: BoxFit.cover,image: NetworkImage( "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRXxfn1j1vKFy8yJeBGl2AS6Dcah-lKgHofg&s",),)),
                              )
                            ],
                          )


                      ),

                    ],
                  ),

                ),
              ),
              Container(color: Colors.black),
              Container(color: Colors.white),
              Container(color: Colors.white),
              Container(color: Colors.white),
              Container(color: Colors.white),

            ]
            )
        )
    );

  }
}