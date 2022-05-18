class Project {
  final String title;
  final String body;

  Project({required this.title, required this.body});

  int? id;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body
            .replaceAll("\n\n", "<br>")
            .replaceAll(String.fromCharCode(0x00A0), "&nbsp;"),
      };

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(title: json['title'], body: json['body']);
  }
}

class ProjectsJsonFileInfo {
  final String sha;

  const ProjectsJsonFileInfo({
    required this.sha,
  });

  factory ProjectsJsonFileInfo.fromJson(Map<String, dynamic> json) {
    return ProjectsJsonFileInfo(
      sha: json['sha'],
    );
  }
}
