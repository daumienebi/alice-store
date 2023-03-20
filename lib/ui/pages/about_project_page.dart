import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:developer' as dev;

class AboutProjectPage extends StatelessWidget {
  const AboutProjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                  'Detalles sobre el proyecto y'
                      ' algunas reflexiones',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: MasonryGridView.builder(
                  itemCount: 10,
                  gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2
                  ),
                  itemBuilder: (context,index) => Padding(
                    padding: const EdgeInsets.all(3),
                    child: InkWell(
                      onTap: () => imageViewer('assets/images/project/image${index+1}.jpg', context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.asset(
                            'assets/images/project/image${index+1}.jpg'
                        ),
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
      )
    );
  }

  Future imageViewer(String imageRoute,BuildContext context){
    return showDialog(
        context: context,
        builder: (builder){
          return AlertDialog(
            title: const Text('Detalle'),
            content: SizedBox(
              height: 350,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                        child: Image.asset(
                          height: 250,
                          width :250,
                          imageRoute,
                          fit: BoxFit.cover,
                        )
                    ),
                    const SizedBox(height: 7),
                    const Text('Random text to describe the image above, i dont'
                        ' know what to insert here so just leave this shitty '
                        'text here for now i guess :)'
                    )
                  ],
                ),
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              TextButton(
                  onPressed: () => _downloadImage(),
                  child: const Text(
                  'Descargar imagen',
                  style: TextStyle(color: Colors.green)
                  )
              ),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar', style: TextStyle(color: Colors.red)
                  )
              )
            ],
          );
        }
    );
  }

  _downloadImage(){
    //TODO: Implement downloading to local storage
    dev.log('Downloading image to local storage');
  }
}
