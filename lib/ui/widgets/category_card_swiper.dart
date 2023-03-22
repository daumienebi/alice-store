import 'package:alice_store/models/category.dart';
import 'package:alice_store/models/product.dart';
import 'package:alice_store/ui/pages/wishlist_page.dart';
import 'package:alice_store/utils/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCardSwiper extends StatelessWidget {
  final List<Category> categories;

  const CategoryCardSwiper({Key? key, required this.categories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final SwiperController _swiperController = SwiperController();
    final size = MediaQuery.of(context).size;
    return Column(children: [
      SizedBox(
        width: double.infinity,
        height: size.height * 0.40,
        child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
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
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: CachedNetworkImage(
                            placeholder:((context, url) => Image.asset(
                                'assets/gifs/loading.gif'
                            )),
                            imageUrl: categories[index].image
                        )
                    ) ,
                  ));
            },
            autoplay: true,
            autoplayDelay: 2600,
            autoplayDisableOnInteraction: true,
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            itemHeight: size.height * 0.50,
            itemWidth: size.width * 0.75,
            duration: 1000,
            //controller: _swiperController,
            curve: Curves.easeInOut,
            /*
            customLayoutOption: getCustomLayoutOption(
              startIndex: _swiperController.index,
              stateCount: categories.length
            ),
            */
            //layout: SwiperLayout.CUSTOM//strange behaviour sometimes on start
            layout: SwiperLayout.DEFAULT//strange behaviour sometimes on start
          //layout: SwiperLayout.TINDER,//strange behaviour sometimes on start
        ),
      ),
    ]);
  }

  Route _createRoute({required Object? arguments}) {
    return PageRouteBuilder(
      settings: RouteSettings(
          name: AppRoutes.routeStrings.wishListPage,
          arguments: arguments
      ),
      pageBuilder: (context, animation, secondaryAnimation) =>
      const WishListPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Shit method for now
  CustomLayoutOption getCustomLayoutOption({required int startIndex,required int stateCount}){
    //Look into the method to build something useful
    CustomLayoutOption customLayoutOption = CustomLayoutOption(
      startIndex: startIndex,
      stateCount: stateCount
    );
    customLayoutOption.addTranslate(
      const [
        Offset(6, 9),
        Offset(7, 2),
        Offset(6, 10),
      ]
    );

    return customLayoutOption;
    //customLayoutOption.builders.add(value)
  }
}