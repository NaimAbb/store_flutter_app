import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/client/cart_screen.dart';
import 'package:store_flutter_app/screens/client/details_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/providers/client.dart';
import 'dart:convert';
import 'package:store_flutter_app/widgets/drawer_layout.dart';

class ClientHomeScreen extends StatefulWidget {
  static const String routeName = '/client-home-screen';

  @override
  State<StatefulWidget> createState() {
    return _ClientHomeScreenState();
  }
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  bool _isLoading = true;
  bool _isFirst = true;
  bool _isClickCategory = false;
  bool _isWrite = false;
  Client _client;

  TextEditingController _searchController = TextEditingController();

  Widget _buildPage(MediaQueryData mediaQuery) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              actions: <Widget>[
                Selector<Client, int>(
                    builder: (_, total, ___) {
                      return Stack(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.shopping_cart),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(CartScreen.routeName);
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
                                      total.toString(),
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      );
                    },
                    selector: (_, value) => value.totalItemInCart)
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
                        controller: _searchController,
                        onChanged: (val) async {
                          if (val == null || val.isEmpty) {
                            _isWrite = false;
                            _client.productSearch.clear();
                          }
                          _isWrite = true;
                          await _client.searchAboutProduct(val);
                        },
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
                        FlatButton(onPressed: () {}, child: Text(''))
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 130,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                            _client.categories.length + 1,
                            (index) {
                              if (index == _client.categories.length){
                                return InkWell(
                                  onTap: () async {
                                    _isClickCategory = false;
                                    _isWrite = false;
                                    _client.allProduct();
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7)),
                                    elevation: 5,
                                    child: Container(
                                      height: 130,
                                      width: 130,
                                      child: Center(
                                          child: Text(
                                           'All Product',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                          borderRadius:
                                          BorderRadius.circular(7),
                                          ),
                                    ),
                                  ),
                                );
                              }
                              return InkWell(
                                onTap: () async {
                                  _isClickCategory = true;
                                  _isLoading = true;
                                  await _client.productByCategory(int.parse(
                                      _client.categories[index].id));
                                  _isLoading = false;
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  elevation: 5,
                                  child: Container(
                                    height: 130,
                                    width: 130,
                                    child: Center(
                                        child: Text(
                                          _client.categories[index].name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(7),
                                        image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: NetworkImage(_client
                                                .categories[index]
                                                .imageUrl))),
                                  ),
                                ),
                              );
                            }),
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
                      getTranslated(context, 'Featured'),
                      style: const TextStyle(color: Colors.black, fontSize: 22),
                    )),
                FlatButton(onPressed: () {}, child: Text('')),
              ],
            ),
            if (_client.productSearch.isNotEmpty && _isWrite)
              Expanded(
                  child: GridView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children:
                          List.generate(_client.productSearch.length, (index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                DetailsProductScreen.routeName,
                                arguments: _client.getFeatured[index]);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.memory(
                                base64Decode(
                                    _client.productSearch[index].image),
                                fit: BoxFit.cover,
                                height: 300,
                              ),
                              Text('${_client.productSearch[index].price}\$'),
                              SizedBox(
                                height: 5,
                              ),
                              Text(_client.productSearch[index].name),
                            ],
                          ),
                        );
                      }),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10))),
            if (_client.productCategory.isEmpty &&
                !_isClickCategory &&
                !_isWrite)
              Expanded(
                  child: GridView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children:
                          List.generate(_client.getFeatured.length, (index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                DetailsProductScreen.routeName,
                                arguments: _client.getFeatured[index]);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.memory(
                                base64Decode(_client.getFeatured[index].image),
                                fit: BoxFit.cover,
                                height: 300,
                              ),
                              Text('${_client.getFeatured[index].price}\$'),
                              SizedBox(
                                height: 5,
                              ),
                              Text(_client.getFeatured[index].name),
                            ],
                          ),
                        );
                      }),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10))),
            if (_client.productCategory.isNotEmpty && !_isWrite)
              Expanded(
                  child: GridView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: List.generate(_client.productCategory.length,
                          (index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                DetailsProductScreen.routeName,
                                arguments: _client.getFeatured[index]);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.memory(
                                base64Decode(
                                    _client.productCategory[index].image),
                                fit: BoxFit.cover,
                                height: 300,
                              ),
                              Text('${_client.productCategory[index].price}\$'),
                              SizedBox(
                                height: 5,
                              ),
                              Text(_client.productCategory[index].name),
                            ],
                          ),
                        );
                      }),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10))),
            if (_client.productCategory.isEmpty && _isClickCategory)
              Expanded(
                  child: Center(
                child: Text('No Product'),
              )),
            if (_client.productSearch.isEmpty && _isWrite)
              Expanded(
                  child: Center(
                child: Text('No Product'),
              ))
          ],
        ));
  }

  Future<void> _getCategories() async {
    try {
      await _client.getCategories();
      _isLoading = false;
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _getProductFeatured() async {
    try {
      await _client.getProductFeatured();
    } catch (error) {}
  }

  Future<void> _getAll() async {
    try {
      await _getProductFeatured();
      await _getCategories();
      await _client.getCount();
      _isFirst = false;
    } catch (error) {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isFirst) {
      _client = Provider.of<Client>(context);
      _getAll();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    if (_searchController.text.isEmpty) {
      _isWrite = false;
      _client.productSearch.clear();
    }
    if (_searchController.text.isNotEmpty && _isClickCategory){
      _isWrite = false;
      _client.productSearch.clear();
    }
    return SafeArea(
      top: false,
      child: Scaffold(
        drawer: DrawerLayout(),
        backgroundColor: Colors.white,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _buildPage(mediaQuery),
      ),
    );
  }
}
