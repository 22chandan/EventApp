import 'package:flutter/material.dart';
import 'package:news/Newapi.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_lorem/flutter_lorem.dart';

class DetailPage extends StatefulWidget {
  final int index;
  const DetailPage({Key? key, required this.index}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late List<Data> result;
  bool mainLoader = true;
  bool loading = true;
  int page = 1;
  String text = lorem(paragraphs: 2, words: 60);
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
    return Scaffold(
        backgroundColor: const Color(0xFFEFF3F5),
        body: mainLoader
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: Center(child: CircularProgressIndicator()))
            : Container(
                color: Color.fromRGBO(245, 245, 245, 1),
                child: ListView(
                  controller: ScrollController(),
                  scrollDirection: Axis.vertical,
                  children: [
                    Column(
                      children: [
                        Container(
                          child: Image.network(
                              "${result[widget.index].bannerImage}"),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            "${result[widget.index].title}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 20),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/Organiser.png'),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${result[widget.index].organiserName}",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    Text(
                                      "Organizer",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 20),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/Date.png'),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${DateFormat("d MMM, y").format(DateTime.parse("${result[widget.index].dateTime}"))}",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    Text(
                                      "${DateFormat("EEEE ,h:mm a -").format(DateTime.parse("${result[widget.index].dateTime}"))} 12:00 PM",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 20),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/Location.png'),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${result[widget.index].venueName}",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    Text(
                                      "36 ${result[widget.index].venueCity}, ${result[widget.index].venueCountry}",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text("About Event"),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text("${result[widget.index].description}" + text)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )));
  }
}
