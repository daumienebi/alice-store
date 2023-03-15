import 'package:alice_store/models/category.dart';
import 'package:alice_store/models/product.dart';
import 'package:alice_store/ui/pages/favourites_page.dart';
import 'package:alice_store/utils/app_routes.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class CategoryCardSwiper extends StatelessWidget {
  final List<Category> categories;
  const CategoryCardSwiper({Key? key, required this.categories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(children: [
      SizedBox(
        width: double.infinity,
        height: size.height * 0.45,
        child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                //onTap: () => Navigator.of(context).pushNamed(
                //Constants.routes.questionsPage, arguments: categories[index]),
                  onTap: () async {
                    Navigator.of(context)
                        .push(_createRoute(arguments: categories[index]));
                  },
                  child: Hero(
                    tag : UniqueKey(),//or find another way to use a unique tag
                    child: Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        padding: const EdgeInsets.all(5),
                        decoration:BoxDecoration(
                          image: DecorationImage(
                          image: AssetImage(categories[index].image),
                              fit: BoxFit.scaleDown,
                            ),
                          color: Color(categories[index].bgColor!),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              categories[index].name,
                              style: const TextStyle(
                                fontSize: 35,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            //Text(
                            //  categories[index].description,
                            //  textAlign: TextAlign.center,
                            //)
                          ],
                        )
                    ) ,
                  ));
            },
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            itemHeight: size.height * 0.50,
            itemWidth: size.width * 0.80,
            layout: SwiperLayout.STACK//strange behaviour sometimes on start
          //layout: SwiperLayout.TINDER,//strange behaviour sometimes on start
        ),
      ),
    ]);
  }

  Route _createRoute({required Object? arguments}) {
    return PageRouteBuilder(
      settings: RouteSettings(
          name: AppRoutes.routeStrings.favouritesPage,
          arguments: arguments
      ),
      pageBuilder: (context, animation, secondaryAnimation) =>
      const FavouritesPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}