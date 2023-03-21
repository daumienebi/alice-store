class ProjectFeed{

  final int id;
  final String image;
  final String description;

  /// Create the constructor
  ProjectFeed({
    required this.id,
    required this.image,
    required this.description,
  });

  factory ProjectFeed.fromJson(dynamic json){
    return
      ProjectFeed(
          id: json['id'],
          image: json['image'],
          description: json['description']
      );
  }

  /// Returns a list of ProjectFeeds from each string of the decoded json
  static List<ProjectFeed> projectFeedModelFromJson(var jsonResponse){
    List<ProjectFeed> projectFeeds = [];
    for (var projectFeed in jsonResponse) {
      projectFeeds.add(ProjectFeed.fromJson(projectFeed));
    }
    return projectFeeds;
  }

  @override
  String toString() {
    return 'Category{id: $id,image: $image, description: $description}';
  }
}