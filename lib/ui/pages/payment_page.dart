import 'package:alice_store/ui/widgets/customed/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late DateTime _expirationDate;

  @override
  void initState() {
    _expirationDate = DateTime.now();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //double price = ModalRoute.of(context)!.settings.arguments as double;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete payment'),
        elevation: 0,
        backgroundColor: Colors.cyan[100],
        foregroundColor: Colors.black54,
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: CustomButton(
                  iconData: Icons.arrow_back,
                  onPressed: (){
                    Navigator.of(context).pop();
                  }
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Introduce payment information',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Card name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Card number',
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _selectExpirationDate(context);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date',
                        errorText: null,
                      ),
                      child: Text(
                        '${_expirationDate.month}/${_expirationDate.year}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  payNowButton(),
                  const SizedBox(height: 10),
                  sendEmailButton()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget payNowButton(){
    //Make the button width 50% of the screen size
    double buttonWidth = MediaQuery.of(context).size.width * 0.60;
    return TextButton(
      onPressed: () {
        // Fake payment process
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Payment Successful'),
              content: const Text('Thank you for your payment.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        fixedSize: Size(buttonWidth,50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12))
      ),
      child: const Text('Pay now',style: TextStyle(color: Colors.black87,fontSize: 17)),
    );
  }

  Widget sendEmailButton(){
    //Make the button width 50% of the screen size
    double buttonWidth = MediaQuery.of(context).size.width * 0.60;
    return TextButton(
      onPressed: () async{
        // Send an email to alicestore
        String subject = 'Store order';
        String orders = '';
        String mailUrl = 'mailto:orders.alicestore@gmail.com?subject=$subject';
        await _launchUrl(Uri.parse(mailUrl));
      },
      style: TextButton.styleFrom(
          backgroundColor: Colors.black87,
          fixedSize: Size(buttonWidth,50),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12))
      ),
      child: const Text('Email order',style: TextStyle(color: Colors.white),),
    );
  }

  Future<void> _selectExpirationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null && picked != _expirationDate) {
      setState(() {
        _expirationDate = picked;
      });
    }
  }

  _launchUrl(Uri url) async{
    await launchUrl(url,mode:LaunchMode.externalApplication);
  }
}
