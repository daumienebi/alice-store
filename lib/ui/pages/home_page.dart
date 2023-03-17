import 'package:alice_store/models/category.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/ui/widgets/widgets.dart';
import 'package:alice_store/utils/app_routes.dart';
import 'package:alice_store/utils/constants.dart';
import 'package:alice_store/utils/default_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.teal);
  DefaultData defaultData = DefaultData();
  List<Category> categories = [];

  @override
  Widget build(BuildContext context) {
    categories = defaultData.getProductCategories;
    List<Widget> widgetOptions = <Widget>[
      CategoryCardSwiper(categories: categories),
      const ShoppingPage(),
      const CartPage(),
      const AboutProjectPage()
    ];
    return Scaffold(
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
        child: const Icon(Icons.share_sharp,color: Colors.black),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 110,
                  color: Colors.white,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Compartir la app',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black54, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: socialMediaButtons(context),
                          ),
                        ),
                      ]),
                );
              });
        },
      ) : Container(),
      drawer: const Drawer(
        child:  DrawerPage(),
      ),
      appBar: AppBar(
        title: Text(
          "A L I C E S T O R E",
          style: GoogleFonts.albertSans(
              color: Colors.black,
              fontSize: 20,
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context){
            return Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: CustomButton(
                  iconData: Icons.menu,
                  onPressed: Scaffold.of(context).openDrawer
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: CustomButton(
              iconData: Icons.favorite_border,
              onPressed: () => Navigator.of(context)
                  .pushNamed(AppRoutes.routeStrings.wishListPage),
            ),
          )
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedIndex == 0 ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      getGreetingText(),
                      style: const TextStyle(fontSize: 19),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 40,),
                    child: Text(
                      'Desliza para explorar las categorías',
                      style: TextStyle(fontSize: 17,color: Colors.black54),
                    ),
                  ),
                ],
              ) : Container(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                child: Center(
                  child: widgetOptions[_selectedIndex],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      iconSize: 25,
      selectedIconTheme: const IconThemeData(color: Colors.lightBlue, size: 27),
      showSelectedLabels: true,
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
      selectedFontSize: 17,
      backgroundColor: Colors.cyan[200],
      selectedItemColor: Colors.black,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: AppLocalizations.of(context)!.home),
        const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop'),
        BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart_outlined),
            label: AppLocalizations.of(context)!.cart),
        BottomNavigationBarItem(
            icon: const Icon(Icons.work_outline),
            label: AppLocalizations.of(context)!.theProject)
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.shifting,
      //selectedLabelStyle: TextStyle(color: Colors.black),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> socialMediaButtons(context) {
    //Very shitty work around
    // TODO : Change it later on
    List<Widget> items = [];
    items.add(const SizedBox(
      width: 10,
    ));
    items.add(socialButton(
        socialMedia: SocialMedia.Whatsapp.name,
        icon: const Icon(
          FontAwesomeIcons.whatsapp,
          color: Colors.green,
          size: 40,
        ),
        onClicked: () {
          Navigator.pop(context);
          share(SocialMedia.Whatsapp, context);
        }));
    items.add(const SizedBox(
      width: 15,
    ));
    items.add(socialButton(
        socialMedia: SocialMedia.Twitter.name,
        icon: const Icon(
          FontAwesomeIcons.twitter,
          color: Colors.lightBlueAccent,
          size: 40,
        ),
        onClicked: () {
          Navigator.pop(context);
          share(SocialMedia.Twitter, context);
        }));
    items.add(const SizedBox(
      width: 15,
    ));
    items.add(socialButton(
        socialMedia: SocialMedia.Facebook.name,
        icon: const Icon(
          FontAwesomeIcons.facebook,
          color: Colors.indigo,
          size: 40,
        ),
        onClicked: () {
          Navigator.pop(context);
          share(SocialMedia.Facebook, context);
        }));
    items.add(const SizedBox(
      width: 15,
    ));
    items.add(socialButton(
        socialMedia: 'Copiar Enlace',
        icon: const Icon(
          Icons.copy,
          color: Colors.grey,
          size: 40,
        ),
        onClicked: () async {
          String appId = Constants.playStoreId;
          final urlString =
              'https://play.google.com/store/apps/details?id=$appId';
          await Clipboard.setData(ClipboardData(text: urlString));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Enlace copiado !'),
              duration: Duration(seconds: 2)));
        }));
    return items;
  }

  socialButton({required String socialMedia, required Icon icon,
      Function()? onClicked}) {
    const listTextStyle = TextStyle(color: Colors.black54);
    return Column(
      children: [
        InkWell(
          onTap: onClicked,
          child: icon,
        ),
        Text(
          socialMedia,
          style: listTextStyle,
        ),
      ],
    );
  }

  /// Get the greeting text depending on the time of the day
  String getGreetingText (){
    String greetingsText = ' ';
    final DateTime now = DateTime.now();
    final format = DateFormat.jm();
    String formattedString = format.format(now);
    if(formattedString.endsWith('AM')){
      greetingsText = 'Buenos días,';
      //greetingsText = AppLocalizations.of(context)!.goodMorning;

      //Example of a formattedString could be 6:54 PM, so we split the string
      //to get the item at the first index and compare if its past 8 o'clock
    }else if(formattedString.endsWith('PM') &&
        int.parse(formattedString.split(":")[0]) > 8){
      greetingsText = 'Buenas noches,';
      //greetingsText = AppLocalizations.of(context)!.goodNight;
    }else{
      greetingsText = 'Buenas tardes,';
      //greetingsText = AppLocalizations.of(context)!.goodEvening;
    }
    return greetingsText;
  }

  /// Method to launch each share option for the [SocialMedia]
  Future share(SocialMedia platform, BuildContext context) async {
    String text = 'Descarga esta app (Fix the text)';
    String appId = Constants.playStoreId;
    final urlString = 'https://play.google.com/store/apps/details?id=$appId';
    final urlShare = Uri.encodeComponent(urlString);
    final urls = {
      SocialMedia.Facebook:
          'https://www.facebook.com/sharer/sharer.php?u=$urlShare&t=$text',
      SocialMedia.Twitter:
          'https://twitter.com/intent/tweet?url=$urlShare&text=$text',
      SocialMedia.Whatsapp:
          'https://api.whatsapp.com/send?text=$text $urlShare',
    };
    final url = Uri.parse(urls[platform]!);
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
