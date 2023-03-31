import 'package:flutter/material.dart';
import 'package:flutter_expandable_text/flutter_expandable_text.dart';
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
    String text = lorem(words: 300);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        elevation: 0.0,
        title: Text(
          'Event Details',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: FlexibleSpaceBar(collapseMode: CollapseMode.pin),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.bookmark),
            color: Colors.white,
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: mainLoader
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              controller: ScrollController(),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 36),
                    child: Image.network("${result[widget.index].bannerImage}"),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10, left: 20),
                      child: Row(
                        children: [
                          Text(
                            "${result[widget.index].title}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 20),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/Organiser.png',
                            scale: .8,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${result[widget.index].organiserName}",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              Text(
                                "Organizer",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 128, 127, 127)),
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
                          child: Image.asset(
                            'assets/Date.png',
                            scale: .8,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${DateFormat("d MMM, y").format(DateTime.parse("${result[widget.index].dateTime}"))}",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              Text(
                                "${DateFormat("EEEE ,h:mm a -").format(DateTime.parse("${result[widget.index].dateTime}"))} 12:00 PM",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 128, 127, 127)),
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
                          child: Image.asset(
                            'assets/Location.png',
                            scale: .8,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${result[widget.index].venueName}",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              Text(
                                "36 ${result[widget.index].venueCity}, ${result[widget.index].venueCountry}",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 128, 127, 127)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About Event",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ExpandableText(
                          "${result[widget.index].description}" + text,
                          trimType: TrimType.characters,
                          trim: 250,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors
                                  .black), // trims if text exceeds more than 2 lines
                          onLinkPressed: (expanded) {},
                          linkTextStyle:
                              TextStyle(fontSize: 18, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 70.0,
        width: 300,
        child: FittedBox(
          child: FloatingActionButton.extended(
            elevation: 8,
            onPressed: () {},
            label: Text(
              'Book Now',
            ),
            icon: Icon(Icons.arrow_circle_right),
            mouseCursor: MouseCursor.defer,
          ),
        ),
      ),
    );
  }
}
