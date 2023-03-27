class ProjectFeedModel{

  final int id;
  final String image;
  final String description;

  /// Create the constructor
  ProjectFeedModel({
    required this.id,
    required this.image,
    required this.description,
  });

  factory ProjectFeedModel.fromJson(dynamic json){
    return
      ProjectFeedModel(
          id: json['id'],
          image: json['image'],
          description: json['description']
      );
  }

  /// Returns a list of ProjectFeeds from each string of the decoded json
  static List<ProjectFeedModel> projectFeedModelFromJson(var jsonResponse){
    List<ProjectFeedModel> projectFeeds = [];
    for (var projectFeed in jsonResponse) {
      projectFeeds.add(ProjectFeedModel.fromJson(projectFeed));
    }
    return projectFeeds;
  }

  @override
  String toString() {
    return 'Category{id: $id,image: $image, description: $description}';
  }
}