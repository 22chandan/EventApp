import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

// ignore: depend_on_referenced_packages

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:news/Detail.dart';
import 'package:news/Newapi.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late List<Data> result;
  bool mainLoader = true;
  bool loading = true;
  int page = 1;
  @override
  void initState() {
    super.initState();
    result = [];
    _getNews();
  }

  void _getNews() async {
    var response = await http.get(Uri.parse(
        "https://sde-007.api.assignment.theinternetfolks.works/v1/event"));
    print(response.body);
    NewsApi newsmodel = NewsApi.fromJson(json.decode(response.body));
    result = newsmodel.content?.data ?? [];
    setState(() {
      result;
      loading = false;
      mainLoader = false;
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double currH = MediaQuery.of(context).size.height;
    double currW = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Event',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0.00,
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SearchPage())),
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ))
          ],
        ),
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        body: mainLoader
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: Center(child: CircularProgressIndicator()))
            : ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                itemCount: result.length,
                itemBuilder: ((context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                      index: index,
                                    )));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            border: Border(
                                top: BorderSide.none,
                                bottom: BorderSide.none,
                                left: BorderSide.none,
                                right: BorderSide.none),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          children: [
                            // Padding(padding: EdgeInsets.only(left: 5)),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(20), // Image border
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(58), // Image radius
                                child: Image.network(
                                    "${result[index].bannerImage}",
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.,
                                children: [
                                  // Text(DateFormat.yMMMEd().format()),
                                  Text(
                                    "${DateFormat("EEE, MMM d").format(DateTime.parse("${result[index].dateTime}")) + ' \u2981 ' + DateFormat('h:mm a').format(DateTime.parse("${result[index].dateTime}"))}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 10)),
                                  Text(
                                    "${result[index].description}"
                                            .substring(0, 19) +
                                        "...",
                                    softWrap: false,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        children: [
                                          // const String s1=;
                                          Container(
                                            margin:
                                                const EdgeInsets.only(right: 2),
                                            child: Image.asset(
                                                'assets/map-pin.png'),
                                          ),
                                          Container(
                                            child: Text(
                                              "${result[index].venueName}"
                                                      .substring(0, 10) +
                                                  " \u2981 ",
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          Text(
                                              "${result[index].venueCity} "
                                                      .substring(0, 5) +
                                                  " \u2981 ",
                                              style: const TextStyle(
                                                  fontSize: 14)),

                                          Text(
                                              '''${result[index].venueCountry}'''
                                                  .substring(0, 5),
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ))
                                        ],
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )))));
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class _SearchPageState extends State<SearchPage> {
  final _debouncer = Debouncer();
  late List<Data> result;
  late List<Data> result2;
  bool mainLoader = true;
  bool loading = true;
  int page = 1;
  @override
  void initState() {
    super.initState();
    result = [];
    _getNews();
  }

  void _getNews() async {
    var response = await http.get(Uri.parse(
        "https://sde-007.api.assignment.theinternetfolks.works/v1/event"));
    print(response.body);
    NewsApi newsmodel = NewsApi.fromJson(json.decode(response.body));
    result = newsmodel.content?.data ?? [];
    setState(() {
      result;
      result2 = result;
      loading = false;
      mainLoader = false;
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double currH = MediaQuery.of(context).size.height;
    double currW = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: const Text(
            'Search',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0.00,
        ),
        backgroundColor: const Color(0xFFEFF3F5),
        body: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Type Event Name',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none)),
                      onChanged: (string) => {
                        _debouncer.run(() {
                          setState(() {
                            result = result2
                                .where(
                                  (u) => (u.description!.toLowerCase().contains(
                                        string.toLowerCase(),
                                      )),
                                )
                                .toList();
                          });
                        })
                      },
                    ),
                    decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.black))),
                  ),
                  Expanded(
                      child: mainLoader
                          ? const Padding(
                              padding: EdgeInsets.all(10),
                              child: Center(child: CircularProgressIndicator()))
                          : ListView.builder(
                              shrinkWrap: true,
                              controller: scrollController,
                              itemCount: result.length,
                              itemBuilder: ((context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                    index: index,
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(225, 225, 225, 1),
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.white),
                                              bottom: BorderSide(
                                                  color: Colors.white),
                                              left: BorderSide(
                                                  color: Colors.white),
                                              right: BorderSide(
                                                  color: Colors.white)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Row(
                                        children: [
                                          // Padding(padding: EdgeInsets.only(left: 5)),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                20), // Image border
                                            child: SizedBox.fromSize(
                                              size: const Size.fromRadius(
                                                  58), // Image radius
                                              child: Image.network(
                                                  "${result[index].bannerImage}",
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // mainAxisAlignment: MainAxisAlignment.,
                                              children: [
                                                // Text(DateFormat.yMMMEd().format()),
                                                Text(
                                                  "${DateFormat("EEE, MMM d").format(DateTime.parse("${result[index].dateTime}")) + ' \u2981 ' + DateFormat('h:mm a').format(DateTime.parse("${result[index].dateTime}"))}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10)),
                                                Text(
                                                  "${result[index].description}"
                                                      .substring(0, 22),
                                                  softWrap: false,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                    child: Row(
                                                      children: [
                                                        // const String s1=;
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 2),
                                                          child: Image.asset(
                                                              'assets/map-pin.png'),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            "${result[index].venueName}"
                                                                    .substring(
                                                                        0, 10) +
                                                                " \u2981 ",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${result[index].venueCity} "
                                                                    .substring(
                                                                        0, 5) +
                                                                " \u2981 ",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14)),

                                                        Text(
                                                            '''${result[index].venueCountry}'''
                                                                .substring(
                                                                    0, 5),
                                                            maxLines: 2,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                            ))
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )))))
                ])));
  }
}
