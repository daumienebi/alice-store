import 'package:alice_store/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
        fontSize: 18,
        color: Colors.black87
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About the app",
          style: GoogleFonts.albertSans(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        //systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: CustomButton(
              iconData: Icons.arrow_back, onPressed: Navigator.of(context).pop),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Welcome to our store! We are a small, independent retailer specializing in unique and high-quality screenprinted products.',
                  textAlign: TextAlign.justify,
                  style: style,
                ),
                SizedBox(height: 10),
                Text(
                  'Our team is passionate about creating beautiful and eye-catching designs that are sure to make a statement. We believe that art should be accessible to everyone, and we strive to keep our prices affordable without sacrificing quality.',
                  textAlign: TextAlign.justify,
                  style: style,
                ),
                SizedBox(height: 10),
                Text(
                  'At our store, we believe that customer service is just as important as the products we sell. We are always here to answer your questions, offer advice, and help you find the perfect item to suit your needs.',
                  textAlign: TextAlign.justify,
                  style: style,
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome to our store! We are a small, independent retailer specializing in unique and high-quality screenprinted products. From clothing to home decor, we\'ve got something for everyone.',
                  textAlign: TextAlign.justify,
                  style: style,
                ),
                SizedBox(height: 10),
                Text(
                  'Thank you for choosing our store for your screenprinting needs. We look forward to helping you express your unique style and personality with our one-of-a-kind designs.',
                  textAlign: TextAlign.justify,
                  style: style,
                ),
                SizedBox(height: 10),
                RichText(text: TextSpan(
                  children: [
                    TextSpan(text:'Disclaimer : ',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        )
                    ),
                    TextSpan(
                        text: 'This app is not designed to be a real world app, it\'s built for educational purposes. The current data is just used as a placeholder.',
                      style: TextStyle(color: Colors.black54,fontStyle: FontStyle.italic,fontSize: 18)
                    )
                  ]
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
