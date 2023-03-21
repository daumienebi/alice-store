import 'package:alice_store/models/project_feed.dart';
import 'package:alice_store/services/project_feed_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'dart:developer' as dev;

import 'package:lottie/lottie.dart';

class AboutProjectPage extends StatefulWidget {
  const AboutProjectPage({Key? key}) : super(key: key);

  @override
  State<AboutProjectPage> createState() => _AboutProjectPageState();
}

class _AboutProjectPageState extends State<AboutProjectPage> {
  final ProjectFeedService projectFeedService = ProjectFeedService();
  late Future<List<ProjectFeed>> projectFeedsFuture;

  Future<List<ProjectFeed>> fetchProducts() async {
    List<ProjectFeed> projectFeeds =
        await projectFeedService.fetchProjectFeeds();
    return Future.delayed(const Duration(seconds: 1), () => projectFeeds);
  }

  @override
  void initState() {
    super.initState();
    projectFeedsFuture = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: projectFeedsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<ProjectFeed>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:const [
                SizedBox(
                  height: 50,
                  width: 100,
                  child: LoadingIndicator(
                      indicatorType: Indicator.ballPulseRise,
                    strokeWidth: 5,
                  ),
                ),
                //LinearProgressIndicator(color: Colors.cyan),
                SizedBox(height: 5),
                Text('Cargando...')
              ],
            );
          }
          // On error
          if (snapshot.hasError) {
            return Column(
              children: [Text(snapshot.error.toString())],
            );
          }
          //If data exists
          if (snapshot.hasData) {
            return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Detalles sobre el proyecto',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: GridView.builder(
                          itemCount: snapshot.data!.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.9,
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(left: 2, right: 2, top: 4),
                                child: InkWell(
                                  onTap: () => imageViewer(
                                      snapshot.data![index], context),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                        placeholder:((context, url) => Image.asset(
                                            'assets/gifs/loading.gif'
                                        )),
                                        imageUrl: snapshot.data![index].image,
                                      height: 300,
                                      width: 300,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              )),
                    )
                  ],
                ));
          }
          //Default
          return Column(
            children: [
              Lottie.asset(
                'assets/lottie_animations/error.json',
              ),
              const Text('Erorr cargando los productos desde el servidor!')
            ],
          );
        },
      ),
    );
  }

  Future imageViewer(ProjectFeed projectFeed, BuildContext context) {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text('Detalle'),
            content: SizedBox(
              height: 350,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/gifs/loading.gif',
                          image: projectFeed.image,
                          height: 300,
                          width: 300,
                          fit: BoxFit.cover,
                        )),
                    const SizedBox(height: 7),
                    Text(projectFeed.description)
                  ],
                ),
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              TextButton(
                  onPressed: () => _downloadImage(),
                  child: const Text('Descargar imagen',
                      style: TextStyle(color: Colors.green))),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child:
                      const Text('Cerrar', style: TextStyle(color: Colors.red)))
            ],
          );
        });
  }

  _downloadImage() {
    //TODO: Implement downloading to local storage
    dev.log('Downloading image to local storage');
  }
}
