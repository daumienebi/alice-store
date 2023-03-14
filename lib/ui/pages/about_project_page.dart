import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AboutProjectPage extends StatelessWidget {
  const AboutProjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: SizedBox(
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
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/project/image${index+1}.jpg'
                    ),
                  ),
                ),
              )
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
            content: Image.asset(imageRoute),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
            actions: [
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
}
