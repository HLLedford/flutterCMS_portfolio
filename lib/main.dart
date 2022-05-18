import 'package:flutter/material.dart';
import 'package:portfolio_cms/services/git_hub_crud.dart';
import 'models/git_hub_responses.dart';
import 'models/portfolio_projects.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Project> finalProjects = <Project>[];

    return FutureBuilder(
        future: GitHubCrudService.fetchProjects(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            finalProjects = snapshot.data;

            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Portfolio CMS',
                home: Scaffold(
                  appBar: AppBar(
                      leading: GestureDetector(
                        onTap: () {
                          GitHubCrudService.saveProjects(finalProjects);
                        },
                        child: const Icon(
                          Icons.save,
                        ),
                      ),
                      title: const Center(
                          child: Text("Portfolio CMS",
                              textAlign: TextAlign.center))),
                  body: Center(
                    child: PortfolioProjects(projects: finalProjects),
                  ),
                ),
                theme: ThemeData(
                  primarySwatch: Colors.teal,
                  scaffoldBackgroundColor:
                      const Color.fromARGB(1000, 97, 97, 97),
                ));
          }
        });
  }
}
