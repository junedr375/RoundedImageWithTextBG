import 'package:example/home/home_model.dart';
import 'package:flutter/material.dart';
import 'package:rounded_image_with_textbg/rounded_image_with_textbg.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rounded Image with Text Background'),
      ),
      body: ListView.builder(
        itemCount: textModel.length,
        itemBuilder: (BuildContext context, index) =>
            SizedBox(height: 60, child: ListItems(index: index)),
      ),
    );
  }
}

class ListItems extends StatefulWidget {
  final int index;
  const ListItems({Key? key, required this.index}) : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      title: Text(textModel[widget.index]['name']),
      leading: RoundedImageWithTextAndBG(
        radius: 20,
        isSelected: isSelected,
        uniqueId: textModel[widget.index]['uniqueId'],
        image: (widget.index % 3 == 0)
            ? 'https://picsum.photos/id/${widget.index}/800/800'
            : '',
        text: textModel[widget.index]['name'],
      ),
    );
  }
}
