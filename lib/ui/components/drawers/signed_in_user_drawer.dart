import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/provider/firebase_auth_provider.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/utils/constants.dart';
import 'package:alice_store/ui/components/customed/dialogs.dart';
import 'package:alice_store/utils/navigator_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignedInUserDrawer extends StatelessWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SignedInUserDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Get the current user
    final User? user = firebaseAuth.currentUser;

    // check to see if there is need to ask the user to confirm their password before deleting
    // temporal solution : check if the user has a photoUrl or not, users with photoUrl were authenticated
    // with the google_sign_in, so in that case we only show a confirmation dialog.If the user doesn't have
    // a photoUrl, in this case it means the user signed in with email and password so we prompt the user
    // to enter the password.
    final bool navigateToDeleteAccountPage = user!.photoURL == null;
    return drawerContents(user, context, navigateToDeleteAccountPage);
  }

  /// The drawer that is returned for a user that is signed in
  Widget drawerContents(
      User user, BuildContext context, bool navigateToDeleteAccountPage) {
    return Column(
      children: [
        userData(user, context),
        Expanded(
          child: optionsListWidget(context, navigateToDeleteAccountPage),
        ),
        // display app version
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 15),
          child: FutureBuilder(
              future: getVersion(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Version: ${snapshot.data.toString()}',
                    style: const TextStyle(fontSize: 16, color: Colors.black38),
                  );
                } else {
                  return const Text("");
                }
              }),
        ),
      ],
    );
  }

  Widget optionsListWidget(
      BuildContext context, bool navigateToDeleteAccountPage) {
    return ListView(
      // 0 to remove the random white space that was appearing
      padding: EdgeInsets.only(top: 0),
      children: [
        //Purchases
        ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: Text('Purchases'),
            onTap: () {}),
        //Privacy
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: Text('Privacy'),
          onTap: () {},
        ),
        //Invite friend
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: Text('Invite a friend'),
          onTap: () {
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
                            'Share the app',
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 20),
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
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text('About the app'),
          onTap: () {},
        ),
        //Log out
        ListTile(
            leading: const Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              //clear useless data for now
              Provider.of<CartProvider>(context, listen: false).clearData();
              Provider.of<ProductProvider>(context, listen: false).clearData();
              //crappy log out logic
              Provider.of<FirebaseAuthProvider>(context, listen: false)
                  .logout();
              //Close the current page after logging out
              Navigator.of(context).pop();
            }),
        //Delete user account
        ListTile(
            leading: const Icon(Icons.delete),
            title: Text('Delete Account'),
            onTap: () {
              print(navigateToDeleteAccountPage);
              if (navigateToDeleteAccountPage) {
                //Make the user enter their password
                Navigator.of(context).push(
                    NavigatorUtil.createRouteWithFadeAnimation(
                        newPage: DeleteAccountPage()));
              } else {
                deleteAccount(context);
              }
            })
      ],
    );
  }

  Widget userData(User user, BuildContext context) {
    //Users who sign in with email and password instead of using the
    // google_sign_in method wont have a displayName nor photoUrl

    // if the user has a display name, show the display name, if not, get the
    // name from the email
    String displayName;
    if (user.displayName!.isNotEmpty) {
      displayName = user.displayName!;
    } else {
      displayName = user.email!.split('@').first;
    }
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.all(10),
      height: 210,
      width: double.infinity,
      color: Colors.cyan[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // profile pic
          user.photoURL != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL!),
                  radius: 60,
                )
              : const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.black87,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
          // display name
          Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(displayName,
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 18,
                      fontWeight: FontWeight.bold))),
          // email
          Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(user.email!,
                  style: const TextStyle(fontSize: 18, color: Colors.black54))),
        ],
      ),
    );
  }

  /// List of the [SocialMedia] buttons
  List<Widget> socialMediaButtons(context) {
    //Very shitty work around
    // Todo : Change it later on
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
        socialMedia: 'Copy Link',
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
              content: Text('Link copied !'), duration: Duration(seconds: 2)));
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

  /// Delete the user's account
  Future deleteAccount(BuildContext context) async {
    bool accountDeleted = false;
    // show confirm dialog
    int returnValue = await Dialogs.confirmAction(
        context: context,
        actionTitle: 'Confirm deletion',
        content: 'Are you sure you want to delete your account ?');
    if (returnValue == 1) {
      accountDeleted =
          await Provider.of<FirebaseAuthProvider>(context, listen: false)
              .deleteUserAccount();
      // messages
      if (accountDeleted) {
        Dialogs.showMessage(
            context: context,
            messageIcon:
                const Icon(Icons.check_circle_outline, color: Colors.green),
            title: 'Account deleted !',
            message: 'Your accout has been deleted successfully.');
        // navigate back to the main page
        Navigator.of(context).push(NavigatorUtil.createRouteWithFadeAnimation(
            newPage: const MainPage()));
      } else {
        Dialogs.showMessage(
            context: context,
            messageIcon: const Icon(Icons.cancel, color: Colors.red),
            title: 'Error',
            message: 'Error deleting your account, please try again later');
      }
    }
  }

  /// Method to launch each share option for the [SocialMedia]
  Future share(SocialMedia platform, BuildContext context) async {
    String text = 'Download the AliceStore app';
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

  Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return Future.value(version);
  }
}
