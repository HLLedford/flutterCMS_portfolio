import 'package:flutter/material.dart';
import '../helpers/html_text_helper.dart';
import 'git_hub_responses.dart';

class PortfolioProjects extends StatefulWidget {
  final List<Project> projects;
  const PortfolioProjects({Key? key, required this.projects}) : super(key: key);

  @override
  _Projects createState() => _Projects();
}

class _Projects extends State<PortfolioProjects> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.projects.length + 1,
      itemBuilder: (context, index) {
        Project? project;

        if (index != widget.projects.length) {
          project = widget.projects[index];

          return ListTile(
            title: Text(
              project.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onPressed: () {
                  deleteAlertDialog(context, project!, false);
                }),
            onTap: () {
              setState(() {
                viewProject(context, project!);
              });
            },
          );
        } else {
          return ListTile(
            title: const Center(
                child: Text(
              "Add new Project +",
              style: TextStyle(color: Colors.white),
            )),
            onTap: () {
              setState(() {
                newProject(context);
              });
            },
          );
        }
      },
    );
  }

  void deleteAlertDialog(
      BuildContext context, Project projectToDelete, bool viewingProject) {
    var alert = AlertDialog(
      title: const Text("Delete Portfolio Project"),
      content: const Text("Are you sure?"),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => {
            Navigator.pop(context),
            _deleteProject(projectToDelete, viewingProject)
          },
          child: const Text('OK'),
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void viewProject(BuildContext context, Project projectToView) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(projectToView.title),
              content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return Container(
                      height: height - 250,
                      width: width - 250,
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: null,
                                  children: <TextSpan>[
                                    TextSpan(
                                        children:
                                            HtmlTextHelper.returnCleanHtml(
                                                projectToView.body))
                                  ],
                                ),
                              )
                            ]),
                      ));
                },
              ),
              actions: <Widget>[
                IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      deleteAlertDialog(context, projectToView, true);
                    }),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ));
  }

  final newProjectNameController = TextEditingController();
  final newProjectDescriptionController = TextEditingController();

  void newProject(BuildContext context) {
    newProjectNameController.text = "";
    newProjectDescriptionController.text = "";

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: TextField(
                controller: newProjectNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a project title',
                ),
              ),
              content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return Container(
                      height: height - 250,
                      width: width - 250,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        controller: newProjectDescriptionController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter a project description'),
                      ));
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back'),
                ),
                IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      addNewProject(newProjectNameController.text,
                          newProjectDescriptionController.text);
                    }),
              ],
            ));
  }

  void _deleteProject(Project projectToDelete, bool viewingProject) {
    setState(() {
      if (viewingProject) {
        Navigator.of(context).pop();
      }

      widget.projects.remove(projectToDelete);
    });
  }

  void addNewProject(String projectTitle, String projectDescription) {
    if (projectTitle.isNotEmpty && projectDescription.isNotEmpty) {
      widget.projects.add(Project(
          title: projectTitle,
          body: "&nbsp;&nbsp;&nbsp;&nbsp;" +
              projectDescription.replaceAll(
                  "\n\n", "<br><br>&nbsp;&nbsp;&nbsp;&nbsp;")));
    }

    setState(() {
      Navigator.pop(context);

      _Projects();
    });
  }
}
