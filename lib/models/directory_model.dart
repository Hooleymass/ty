import 'package:flutter/material.dart';
import 'package:flutter_code_editor/editor/file_explorer/file_explorer.dart';
import 'package:flutter_code_editor/models/file_dir_creation_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DirectoryIDE extends StatefulWidget {
  DirectoryIDE(
      {Key? key,
      required this.fileExplorer,
      required this.directoryName,
      required this.directoryPath,
      required this.directoryContent,
      this.recentlyOpenedFiles = const [],
      this.directoryOpen = false,
      this.isCreatingContent = false})
      : super(key: key);

  String directoryName;

  final String directoryPath;
  final List directoryContent;
  final FileExplorer fileExplorer;

  final List<String> recentlyOpenedFiles;

  bool directoryOpen;

  bool isCreatingContent;

  @override
  State<StatefulWidget> createState() => DirectoryIDEState();
}

class DirectoryIDEState extends State<DirectoryIDE> {
  Future<void> getDirectoryOpenClosedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(widget.directoryPath) == null) {
      prefs.setString(widget.directoryPath, widget.directoryOpen.toString());
    }

    if (prefs.getString(widget.directoryPath) == 'true') {
      setState(() {
        widget.directoryOpen = true;
      });
    }
  }

  Future<void> setNewDirectoryState(bool newState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(widget.directoryPath, newState.toString());

    setState(() {
      widget.directoryOpen = newState;
    });
  }

  @override
  void initState() {
    super.initState();
    getDirectoryOpenClosedState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(left: BorderSide(width: 1, color: Colors.grey))),
        child: !widget.isCreatingContent
            ? ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: const Icon(Icons.folder),
                    title: Text(widget.directoryName),
                    trailing: widget.directoryOpen
                        ? const Icon(Icons.arrow_drop_down)
                        : const Icon(Icons.arrow_right),
                    onTap: () {
                      setNewDirectoryState(!widget.directoryOpen);
                    },
                    onLongPress: () {
                      setState(() {
                        widget.isCreatingContent = true;
                      });
                    },
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.directoryOpen
                          ? widget.directoryContent.length
                          : 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: widget.directoryContent[index],
                        );
                      })
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: FileDirCreationWidget(
                        dir: widget,
                        fileExplorer: widget.fileExplorer,
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('Cancel'),
                          tileColor: Colors.green,
                          onTap: () {
                            setState(() {
                              widget.isCreatingContent = false;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Delete'),
                          tileColor: Colors.red,
                          onTap: () {},
                        ),
                      )
                    ],
                  )
                ],
              ));
  }
}
