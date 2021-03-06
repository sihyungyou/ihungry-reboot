// 전체식당
import 'package:Shrine/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Shrine/rest_detail.dart';
// import 'favorite.dart';
// import 'history.dart';

class RestAllPage extends StatefulWidget {
  @override
  final FirebaseUser user;
  final List<Restaurant> korean;
  final List<Restaurant> chinese;
  final List<Restaurant> japanese;
  final List<Restaurant> boonSick;
  final List<Restaurant> fastFood;
  final List<Restaurant> allRests;
  final List<String> allNames; 
  RestAllPage({Key key, this.user, this.korean, this.chinese, this.japanese, this.boonSick, this.fastFood, this.allRests, this.allNames});
  _RestAllPageState createState() => _RestAllPageState(korean, chinese, japanese, boonSick, fastFood, allRests, allNames, user);
}

class _RestAllPageState extends State<RestAllPage>
    with SingleTickerProviderStateMixin {
  final FirebaseUser user;
  final List<Restaurant> korean;
  final List<Restaurant> chinese;
  final List<Restaurant> japanese;
  final List<Restaurant> boonSick;
  final List<Restaurant> fastFood;
  final List<Restaurant> allRests;
  final List<String> allNames;
  _RestAllPageState(this.korean, this.chinese, this.japanese, this.boonSick, this.fastFood, this.allRests, this.allNames, this.user);

  TabController _controller;



  @override
  void initState() {
    super.initState();
    print("rest_all initstate");
    _controller = new TabController(length: 5, vsync: this);
    // print("init state over");
  }

  Widget DeliveryIcon (String deliveryfee) {
    // print(deliveryfee);
    if (deliveryfee == '없음') 
      return Row(
        children: <Widget>[
        Image.network('https://firebasestorage.googleapis.com/v0/b/onebite-cdaee.appspot.com/o/restallPage%2F%E1%84%87%E1%85%A2%E1%84%83%E1%85%A1%E1%86%AF%E1%84%87%E1%85%B5%E1%84%8B%E1%85%A5%E1%86%B9%E1%84%8B%E1%85%B3%E1%86%B7.png?alt=media&token=f0c7027a-5e48-4617-bc12-af894e532089',
        height: 15.0,
        width: 30.0,),
        SizedBox(width: 10.0),
        Text('배달비 없음'),
      ],
      );
    else 
      return Row(
        children: <Widget>[
        Image.network('https://firebasestorage.googleapis.com/v0/b/onebite-cdaee.appspot.com/o/restallPage%2F%E1%84%87%E1%85%A2%E1%84%83%E1%85%A1%E1%86%AF%E1%84%87%E1%85%B5%E1%84%8B%E1%85%B5%E1%86%BB%E1%84%8B%E1%85%B3%E1%86%B7.png?alt=media&token=96d82728-25b5-47c6-8106-561a4788a453',
        height: 15.0,
        width: 30.0,),
        SizedBox(width: 10.0),
        Text('배달비 있음'),
      ],
      );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    print(height);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    HomePage(
                      user: user,
                    )))
                .catchError((e) => print(e));
          }// detail 에서 돌아올 때 pop을 안해주기 떄문에 stack에 detail page가 남아있음. 그래서 여기서 pop하면 login page가 아니라 detail로 감..
        ),
        title: Text('전체 식당'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(allnames: allNames, recentnames: allNames, allRests: allRests, user: user));
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          new Container(
            child: new TabBar(
              isScrollable: true,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: theme.primaryColor),
              ),
              controller: _controller,
              tabs: <Widget>[
                SizedBox(
                  width: 70.0,
                  child: new Tab(
                    child: Text('패스트푸드',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                  ),
                ),
                SizedBox(
                  width: 30.0,
                    child: new Tab(
                    child: Text('한식',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                  ),
                ),
                SizedBox(
                  width: 30.0,
                    child: new Tab(
                    child: Text('중식',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                  ),
                ),
                SizedBox(
                  width: 30.0,
                    child: new Tab(
                    child: Text('일식',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                  ),
                ),
                SizedBox(
                  width: 30.0,
                    child: new Tab(
                    child: Text('분식',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                  ),
                ),
              ],
            ),
          ),
          new Expanded(
            flex: 1,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                // fastfood
                ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: fastFood.length,
                    itemBuilder: (context, index) {
                      return ListTile(

                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        leading: CircleAvatar(
                          radius: 35.0,
                          backgroundImage: Image.network('${fastFood[index].logo}').image,
                        ),
                          title: Text(fastFood[index].name, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w800, fontSize: 18.0)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5.0),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.access_time, size: 20.0, color: Colors.grey),
                                  SizedBox(width: 5.0),
                                  Text("영업시간: " + fastFood[index].time, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black)),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                children: <Widget>[
                                  DeliveryIcon(fastFood[index].deliveryFee),

                                ],
                              ),

                            ],
                          ),

                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailPage(
                                            user: user,
                                            restaurant: fastFood[index],
                                            previous: 'restall')))
                                .catchError((e) => print(e));
                          });
                    }),
                // korean
                ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: korean.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          leading: CircleAvatar(
                            radius: 35.0,
                            backgroundImage: Image.network('${korean[index].logo}').image,
                          ),
                          title: Text(korean[index].name, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w800, fontSize: 18.0)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5.0),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.access_time, size: 20.0, color: Colors.grey),
                                  SizedBox(width: 5.0),
                                  Text("영업시간: " + korean[index].time, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black)),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                children: <Widget>[
                                  DeliveryIcon(korean[index].deliveryFee),

                                ],
                              ),

                            ],
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailPage(
                                            user: user,
                                            restaurant: korean[index],
                                            previous: 'restall')))
                                .catchError((e) => print(e));
                          });
                    }),
                // chinese
                ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: chinese.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          leading: CircleAvatar(
                            radius: 35.0,
                            backgroundImage: Image.network('${chinese[index].logo}').image,
                          ),
                          title: Text(chinese[index].name, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w800, fontSize: 18.0)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5.0),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.access_time, size: 20.0, color: Colors.grey),
                                  SizedBox(width: 5.0),
                                  Text("영업시간: " + chinese[index].time, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black)),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                children: <Widget>[
                                  DeliveryIcon(chinese[index].deliveryFee),

                                ],
                              ),

                            ],
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailPage(
                                            user: user,
                                            restaurant: chinese[index],
                                            previous: 'restall')))
                                .catchError((e) => print(e));
                          });
                    }),
                // japanese
                ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: japanese.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          leading: CircleAvatar(
                            radius: 35.0,
                            backgroundImage: Image.network('${japanese[index].logo}').image,
                          ),
                          title: Text(japanese[index].name, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w800, fontSize: 18.0)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5.0),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.access_time, size: 20.0, color: Colors.grey),
                                  SizedBox(width: 5.0),
                                  Text("영업시간: " + japanese[index].time, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black)),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                children: <Widget>[
                                  DeliveryIcon(japanese[index].deliveryFee),

                                ],
                              ),

                            ],
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailPage(
                                            user: user,
                                            restaurant: japanese[index],
                                            previous: 'restall')))
                                .catchError((e) => print(e));
                          });
                    }),
                // boonsick
                ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: boonSick.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          leading: CircleAvatar(
                            radius: 35.0,
                            backgroundImage: Image.network('${boonSick[index].logo}').image,
                          ),
                          title: Text(boonSick[index].name, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w800, fontSize: 18.0)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5.0),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.access_time, size: 20.0, color: Colors.grey),
                                  SizedBox(width: 5.0),
                                  Text("영업시간: " + boonSick[index].time, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black)),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                children: <Widget>[
                                  DeliveryIcon(fastFood[index].deliveryFee),

                                ],
                              ),

                            ],
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailPage(
                                            user: user,
                                            restaurant: boonSick[index],
                                            previous: 'restall')))
                                .catchError((e) => print(e));
                          });
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final FirebaseUser user;
  final List<Restaurant> allRests;
  final List<String> allnames;
  final List<String> recentnames;
  DataSearch({Key key, this.allnames, this.recentnames, this.allRests, this.user});
  
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentnames
        : allnames.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            onTap: () {
              showResults(context);
            },
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.grey),
                    )
                  ]),
            ),
          ),
      itemCount: suggestionList.length,
    );
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    String temp;
    Restaurant searchedRest;
    // print('build results console');
    // allnames의 리스트에서 query로 시작하는 완전한 풀 네임을 찾아서 temp 에 넣음
    for(var i = 0; i < allnames.length; i++){
      if (allnames[i].startsWith(query)) {
        // print('allnames[i]: ');
        // print(allnames[i]);
        temp = allnames[i];
        break;
      }
    }
    // 그리고 그 temp와 allrest[i].name과 하나하나 비교해가면서 rest자체를 찾고 그걸 searched_rest에 넣음
    for(var i = 0; i < allRests.length; i++){
      // print('name!');
      // print(allRests[i]);
      // print(allRests[i].name);
      if (allRests[i].name == temp) {
        searchedRest = allRests[i];
        // print('found!');
        // print(searched_rest.name);
        break;
      }
    }

    return ListView(
            children: <Widget>[
              ListTile(
                title: Text(searchedRest.name),
                subtitle: Text(searchedRest.time),
                onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailPage(
                                            user: user,
                                            restaurant: searchedRest,
                                            previous: 'restall',
                                        )))
                                .catchError((e) => print(e));
                          }),
            ],
    );
  }
}

class Restaurant {
  final String closed;
  final String deliveryFee;
  final String minimumOrder;
  final String name;
  final DocumentReference reference;
  final String phone;
  // final String rate;
  final String time;
  final String type;
  final String logo;
  int calls;
  Restaurant(this.closed, this.deliveryFee, this.minimumOrder, this.name,
      this.reference, this.phone, this.time, this.type, this.logo, this.calls);

  Restaurant.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['closed'] != null),
        assert(map['delivery fee'] != null),
        assert(map['minimum order'] != null),
        assert(map['name'] != null),
        assert(map['phone'] != null),
        // assert(map['rate'] != null),
        assert(map['time'] != null),
        assert(map['type'] != null),
        assert(map['calls'] != null),
        closed = map['closed'],
        deliveryFee = map['delivery fee'],
        minimumOrder = map['minimum order'],
        name = map['name'],
        phone = map['phone'],
        // rate = map['rate'],
        time = map['time'],
        type = map['type'],
        logo = map['logo'],
        calls = map['calls'];

  Restaurant.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}


class Favorite {
  final String name;
  final DocumentReference reference;
  Favorite(this.name, this.reference);

  Favorite.fromMap(Map<String, dynamic> map, {this.reference})
      :
        assert(map['name'] != null),

        name = map['name'];

  Favorite.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

class History {
  final String name;
  final DocumentReference reference;
  History(this.name, this.reference);

  History.fromMap(Map<String, dynamic> map, {this.reference})
      :
        assert(map['name'] != null),

        name = map['name'];

  History.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
