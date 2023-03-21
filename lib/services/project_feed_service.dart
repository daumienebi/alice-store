import 'package:alice_store/models/project_feed.dart';
import 'package:alice_store/services/api_service.dart';
import 'package:alice_store/utils/constants.dart';
import 'dart:developer' as dev;

class ProjectFeedService{
  final ApiService _apiService = ApiService();

  Future<List<ProjectFeed>> fetchProjectFeeds() async{
    List<ProjectFeed> projectFeeds= [];
    dynamic response = await _apiService.getResponse(Constants.api.projectFeedsEndPoint);
    if (response != null) {
      projectFeeds = ProjectFeed.projectFeedModelFromJson(response);
    }
    dev.log('PROJECT FEED :$projectFeeds');
    return projectFeeds;
  }
}