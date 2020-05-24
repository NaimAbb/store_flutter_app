import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/client/cart_screen.dart';
import 'package:store_flutter_app/screens/client/details_product_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  static const String routeName = '/client-home-screen';

  @override
  State<StatefulWidget> createState() {
    return _ClientHomeScreenState();
  }
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  Widget _buildTest(MediaQueryData mediaQuery) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              actions: <Widget>[
                Stack(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.of(context).pushNamed(CartScreen.routeName);
                        }),
                    Positioned(
                      top: 2,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                          radius: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FittedBox(
                              child: Text(
                                '10',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          )),
                    )
                  ],
                )
              ],
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
              backgroundColor: Colors.white,
              expandedHeight: 330,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: <Widget>[
                    Container(
                      height: mediaQuery.padding.top + 50,
                    ),
                    Card(
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText:
                                getTranslated(context, 'SearchYourProduct'),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              getTranslated(context, 'Categories'),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 22),
                            )),
                        FlatButton(
                            onPressed: () {},
                            child: Text(getTranslated(context, 'SeeAll')))
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 130,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                            10,
                            (index) => Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  elevation: 5,
                                  child: Container(
                                    height: 130,
                                    width: 130,
                                    child: Center(
                                        child: Text(
                                      'ahmed',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSQXE_7Go4FovH9bstguTZSXGwPapB5CwcraJtmLQICkJe9weEk&usqp=CAU'))),
                                  ),
                                )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ];
        },
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Featured',
                      style: const TextStyle(color: Colors.black, fontSize: 22),
                    )),
                FlatButton(
                    onPressed: () {},
                    child: Text(getTranslated(context, 'SeeAll'))),
              ],
            ),
            Expanded(
                child: GridView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: <Widget>[
                      InkWell(
                        onTap:(){
                          Navigator.of(context).pushNamed(DetailsProductScreen.routeName);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSQXE_7Go4FovH9bstguTZSXGwPapB5CwcraJtmLQICkJe9weEk&usqp=CAU ',
                              fit: BoxFit.cover,
                              height: 300,
                            ),
                            Text('550\$'),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Man T-Shirt'),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSQXE_7Go4FovH9bstguTZSXGwPapB5CwcraJtmLQICkJe9weEk&usqp=CAU ',
                            fit: BoxFit.cover,
                            height: 300,
                          ),
                          Text('550\$'),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Man T-Shirt'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSQXE_7Go4FovH9bstguTZSXGwPapB5CwcraJtmLQICkJe9weEk&usqp=CAU ',
                            fit: BoxFit.cover,
                            height: 300,
                          ),
                          Text('550\$'),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Man T-Shirt'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSQXE_7Go4FovH9bstguTZSXGwPapB5CwcraJtmLQICkJe9weEk&usqp=CAU ',
                            fit: BoxFit.cover,
                            height: 300,
                          ),
                          Text('550\$'),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Man T-Shirt'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSQXE_7Go4FovH9bstguTZSXGwPapB5CwcraJtmLQICkJe9weEk&usqp=CAU ',
                            fit: BoxFit.cover,
                            height: 300,
                          ),
                          Text('550\$'),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Man T-Shirt'),
                        ],
                      ),
                    ],
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.55,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10)))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        body: _buildTest(mediaQuery),
//        body: SingleChildScrollView(
//          child: ,
//          child: Column(
//            children: <Widget>[
//              Container(
//                height: mediaQuery.padding.top,
//              ),
//              Card(
//                child: TextFormField(
//                  decoration: InputDecoration(
//                      hintText: getTranslated(context, 'SearchYourProduct'),
//                      border: InputBorder.none,
//                      prefixIcon: Icon(
//                        Icons.search,
//                        color: Colors.black,
//                      )),
//                ),
//              ),
//              SizedBox(
//                height: 20,
//              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Padding(
//                      padding: const EdgeInsets.symmetric(horizontal: 10),
//                      child: Text(
//                        getTranslated(context, 'Categories'),
//                        style:
//                            const TextStyle(color: Colors.black, fontSize: 22),
//                      )),
//                  FlatButton(
//                      onPressed: () {},
//                      child: Text(getTranslated(context, 'SeeAll')))
//                ],
//              ),
//              Container(
//                width: double.infinity,
//                height: 130,
//                child: ListView(
//                  scrollDirection: Axis.horizontal,
//                  children: List.generate(
//                      10,
//                      (index) => Card(
//                            shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(7)),
//                            elevation: 5,
//                            child: Container(
//                              height: 130,
//                              width: 130,
//                              child: Center(
//                                  child: Text(
//                                'ahmed',
//                                style: TextStyle(color: Colors.white),
//                              )),
//                              decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(7),
//                                  image: DecorationImage(
//                                      fit: BoxFit.cover,
//                                      image: NetworkImage(
//                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSQXE_7Go4FovH9bstguTZSXGwPapB5CwcraJtmLQICkJe9weEk&usqp=CAU'))),
//                            ),
//                          )),
//                ),
//              ),
//              SizedBox(
//                height: 20,
//              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Padding(
//                      padding: const EdgeInsets.symmetric(horizontal: 10),
//                      child: Text(
//                        'Featured',
//                        style:
//                            const TextStyle(color: Colors.black, fontSize: 22),
//                      )),
//                  FlatButton(
//                      onPressed: () {},
//                      child: Text(getTranslated(context, 'SeeAll'))),
//                  Expanded(
//                      child: GridView(
//                          gridDelegate:
//                              SliverGridDelegateWithFixedCrossAxisCount(
//                                  crossAxisCount: 2)))
//                ],
//              ),
//            ],
//          ),
        //    ),
      ),
    );
  }
}
