// 전체식당
// backup
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'rest_detail.dart';

class RestAllPage extends StatefulWidget {
  @override
  final FirebaseUser user;
  RestAllPage({Key key, this.user});
  _RestAllPageState createState() => _RestAllPageState(user: user);
}

class _RestAllPageState extends State<RestAllPage>
    with SingleTickerProviderStateMixin {
  final FirebaseUser user;
  _RestAllPageState({Key key, this.user});
  List<Restaurant> korean = new List<Restaurant>();
  List<Restaurant> chinese = new List<Restaurant>();
  List<Restaurant> japanese = new List<Restaurant>();
  List<Restaurant> boonSick = new List<Restaurant>();
  List<Restaurant> fastFood = new List<Restaurant>();
  List<Restaurant> allRests = new List<Restaurant>();
  List<String> allnames = new List<String>();

  TabController _controller;

  Future _buildList() async {
    print("buildlist in");
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("restaurant").getDocuments();
    var list = querySnapshot.documents;
    // build init 할 때 user collection -> uid document -> search_history collection -> index 돌면서 추가!
    for (var i = 0; i < list.length; i++) {
      final Restaurant restaurant = Restaurant.fromSnapshot(list[i]);
      print(restaurant.name);
      setState(() {
        allRests.add(restaurant);
        allnames.add(restaurant.name);
        if (restaurant.type == 'korean')
          korean.add(restaurant);
        else if (restaurant.type == 'chinese')
          chinese.add(restaurant);
        else if (restaurant.type == 'japanese')
          japanese.add(restaurant);
        else if (restaurant.type == 'boonsick')
          boonSick.add(restaurant);
        else if (restaurant.type == 'fastfood')
          fastFood.add(restaurant);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("init state yes");
    _buildList();
    _controller = new TabController(length: 5, vsync: this);
    print("init state over");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Navigator.pop(context); // detail 에서 돌아올 때 pop을 안해주기 떄문에 stack에 detail page가 남아있음. 그래서 여기서 pop하면 login page가 아니라 detail로 감..
            Navigator.pushNamed(context, '/login'); //그래서 일단은 푸시네임으로!
          },
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
              showSearch(context: context, delegate: DataSearch(allnames: allnames, recentnames: allnames, allRests: allRests, user: user));
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          new Container(
            child: new TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: theme.primaryColor),
              ),
              controller: _controller,
              tabs: <Widget>[
                new Tab(
                  child: Text('패스트푸드',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
                new Tab(
                  child: Text('한식',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
                new Tab(
                  child: Text('중식',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
                new Tab(
                  child: Text('일식',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
                new Tab(
                  child: Text('분식',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ],
            ),
          ),
          new Container(
            height: 300.0,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                // fastfood
                ListView.builder(
                    itemCount: fastFood.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: Image.network('${fastFood[index].logo}').image,
                        ),
                          title: Text(fastFood[index].name),
                          subtitle: Text("영업시간: " + fastFood[index].time),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailPage(
                                            user: user,
                                            restaurant: fastFood[index])))
                                .catchError((e) => print(e));
                          });
                    }),
                // korean
                ListView.builder(
                    itemCount: korean.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: Image.network('${korean[index].logo}').image,
                        ),
                          title: Text(korean[index].name),
                          subtitle: Text("영업시간: " + korean[index].time),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailPage(
                                            user: user,
                                            restaurant: korean[index])))
                                .catchError((e) => print(e));
                          });
                    }),
                // chinese
                ListView.builder(
                    itemCount: chinese.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: Image.network('${chinese[index].logo}').image,
                        ),
                          title: Text(chinese[index].name),
                          subtitle: Text("영업시간: " + chinese[index].time),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailPage(
                                            user: user,
                                            restaurant: chinese[index])))
                                .catchError((e) => print(e));
                          });
                    }),
                // japanese
                ListView.builder(
                    itemCount: japanese.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: Image.network('${japanese[index].logo}').image,
                        ),
                          title: Text(japanese[index].name),
                          subtitle: Text("영업시간: " + japanese[index].time),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailPage(
                                            user: user,
                                            restaurant: japanese[index])))
                                .catchError((e) => print(e));
                          });
                    }),
                // boonsick
                ListView.builder(
                    itemCount: boonSick.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: Image.network('${boonSick[index].logo}').image,
                        ),
                          title: Text(boonSick[index].name),
                          subtitle: Text("영업시간: " + boonSick[index].time),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailPage(
                                            user: user,
                                            restaurant: boonSick[index])))
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
                                            // user: user,
                                            restaurant: searchedRest)))
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
  final String rate;
  final String time;
  final String type;
  final String logo;
  Restaurant(this.closed, this.deliveryFee, this.minimumOrder, this.name,
      this.reference, this.phone, this.rate, this.time, this.type, this.logo);

  Restaurant.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['closed'] != null),
        assert(map['delivery fee'] != null),
        assert(map['minimum order'] != null),
        assert(map['name'] != null),
        assert(map['phone'] != null),
        assert(map['rate'] != null),
        assert(map['time'] != null),
        assert(map['type'] != null),
        closed = map['closed'],
        deliveryFee = map['delivery fee'],
        minimumOrder = map['minimum order'],
        name = map['name'],
        phone = map['phone'],
        rate = map['rate'],
        time = map['time'],
        type = map['type'],
        logo = map['logo'];

  Restaurant.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
