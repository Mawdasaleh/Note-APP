import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  final note;
  const ViewNote({super.key, this.note});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("viewnote"),
      ),
      body: Expanded(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                    child: Image.network(
                  "${widget.note['imageurl']}",
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.fill,
                )),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "${widget.note['title']}",
                    style: Theme.of(context).textTheme.headlineSmall,
                  )),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "${widget.note['note']}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
