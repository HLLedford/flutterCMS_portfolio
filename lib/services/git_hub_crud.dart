import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/git_hub_responses.dart';

class GitHubCrudService {
  static const gitHubAccessToken = "";
  //I have removed this in order to make this Repo public.
  //I am use to just adding stuff like this to the Azure Key Valut and accessing/storing that way.

  static Future<List<Project>> fetchProjects() async {
    final response = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/HLLedford/portfolio/master/CMS/projects.json"));

    if (response.statusCode == 200) {
      final retVal = (json.decode(response.body) as List)
          .map((i) => Project.fromJson(i))
          .toList();

      return retVal;
    } else {
      throw Exception('Failure grabbing Portfolio projects.');
    }
  }

  static saveProjects(List<Project> projects) async {
    int projectIdCnt = 1;

    for (var element in projects) {
      element.id = projectIdCnt;

      projectIdCnt++;
    }

    var jsonString = json.encode(projects);

    var jsonStringBytes = utf8.encode(jsonString);

    final response = await http.get(
      Uri.parse(
          "https://api.github.com/repos/HLLedford/portfolio/contents/CMS/projects.json"),
      headers: <String, String>{
        "Authorization": "token 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"
      },
    );

    ProjectsJsonFileInfo fileSha =
        ProjectsJsonFileInfo.fromJson(jsonDecode(response.body));

    http.put(
      Uri.parse(
          "https://api.github.com/repos/HLLedford/portfolio/contents/CMS/projects.json"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "token $gitHubAccessToken"
      },
      body: jsonEncode(<String, String>{
        "message": "Updating Portfolio Projects via Flutter.",
        "content": base64.encode(jsonStringBytes),
        "sha": fileSha.sha
      }),
    );
  }
}
