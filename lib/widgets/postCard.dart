import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final snap;
  PostCard({required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String date =
        DateFormat('MMMM').format(widget.snap['datePublished'].toDate()) +
            ' ' +
            widget.snap['datePublished'].toDate().day.toString() +
            ', ' +
            widget.snap['datePublished'].toDate().year.toString();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        elevation: 4,
        color: Colors.deepPurple[100],
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://randomuser.me/api/portraits/lego/5.jpg'),
                        // image: NetworkImage(widget.snap['postUrl']),
                        fit: BoxFit.fitWidth)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        'Description: ' + widget.snap['description'],
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: Text(
                  'Date Published: ' + date,
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
