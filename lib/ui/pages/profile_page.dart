import 'package:alice_store/provider/google_signin_provider.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/ui/widgets/custom_button.dart';
import 'package:alice_store/utils/constants.dart';
import 'package:alice_store/utils/navigator_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    //Get the current user
    final user = firebaseAuth.currentUser!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: CustomButton(
              iconData: Icons.arrow_back,
              onPressed: Navigator.of(context).pop),
        ),
        backgroundColor: Colors.cyan[100],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // profile pic
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL!),
                    radius: 60,
                  ),
                  // name text
                  Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: Text(
                          user.displayName!,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  // email text
                  Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: Text(user.email!,
                          style: const TextStyle(
                              fontSize: 18,color: Colors.black54))),

                  Padding(
                    padding: EdgeInsets.only(top: 10),
                      child: Icon(Icons.verified,color: Colors.cyan,size: 50,)
                  ),

                  //option list
                  const SizedBox(height: 10),
                  optionsListWidget(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget optionsListWidget(BuildContext context){
    return Expanded(
      child: ListView(
        children: [
          //Purchases
          optionListTile(
            context: context,
            leading: const Icon(Icons.shopping_cart),
            title:  'Compras',
            onTap: () {}
          ),
          /*
          //Credits
          optionListTile(
            context: context,
            leading: const Icon(Icons.people_outline),
            title:  'Créditos',
            onTap: () {}
          ),
           */

          //Privacy
          optionListTile(
            context: context,
            leading: const Icon(Icons.privacy_tip_outlined),
            title:  'Privacidad',
            onTap: ()=> Navigator.of(context).push(
                NavigatorUtil.createRouteWithFadeAnimation(
                    newPage: ProfilePage()
                )
            ),
          ),
          //Share app
          optionListTile(
            context: context,
            leading: const Icon(Icons.email_outlined),
            title:  'Invitar un amigo',
            onTap: (){
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
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 20),
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
          ),
          //About the app
          optionListTile(
            context: context,
            leading: const Icon(Icons.info_outline),
            title:  'Sobre la app',
            onTap: () {},
          ),
          //Log out
          optionListTile(
            context: context,
            leading: const Icon(Icons.logout),
            title:  'Cerrar sesión',
            onTap: () {
              //log out logic
              Provider.of<GoogleSignInProvider>(context,listen: false)
                  .googleLogout();
              //Close the current page after logging out
              Navigator.of(context).pop();
            }
          )
        ],
      ),
    );
  }

  Widget optionListTile({required context,required String title,
    required Icon leading,required Function onTap}){
    
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
      ),
      child: ListTile(
        textColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.white54,
        trailing: const Icon(Icons.arrow_forward_ios_sharp,size: 15,),
        leading: leading,
        title: Text(title),
        onTap: ()=> onTap(),
        contentPadding: const EdgeInsets.only(left: 15,right: 15),
      ),
    );
  }

  /// List of the [SocialMedia] buttons
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

  /// [SocialMedia] button
  Widget socialButton({required String socialMedia,required Icon icon,
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

  /// Method to launch each share option for the [SocialMedia]
  Future share(SocialMedia platform, BuildContext context) async {
    String text = 'Descarga esta app de AliceStore';
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
