import 'package:basic_todo/components/pallete.dart';
import 'package:flutter/material.dart';

class CommonBtn extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback callback;
  final bool isLoading;
  final String text;

  const CommonBtn(
      {super.key,
        this.width = double.maxFinite,
        this.height = 80,
        required this.callback,
        required this.isLoading, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10)
        ),
        child:  Center(
          child:isLoading
              ? const CircularProgressIndicator()
              : Text(
            text,
            style: const TextStyle(fontSize: 20,color: Colors.white),
          ),
        ),
      ),
    );
  }
}


class CommonField extends StatelessWidget {
  final TextEditingController controller;
  final bool isMulti;
  final String hintText;
  final TextInputType type;

  const CommonField(
      {super.key,
        required this.controller,
        this.isMulti = false,
        required this.hintText,
        this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
     maxLines: isMulti ?10 : null,
      minLines: 1,
      style: const TextStyle(color: Colors.white),
      keyboardType: type,
      decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          hintStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }
}


class TodoCard extends StatelessWidget {
  const TodoCard({
    super.key,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.urgencyColor,
  });

  final String title;
  final String description;
  final String createdAt;
  final Color urgencyColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white54, width: 0.5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 15,
            width: 15,
            margin: const EdgeInsets.only(right: 8, top: 5),
            decoration:
            BoxDecoration(color: urgencyColor, shape: BoxShape.circle),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 150,
                      child: Text(
                        title,
                        style: titleText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      createdAt,
                      style: headText.copyWith(color: dateColor, fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 66,
                child: Text(
                  description,
                  style: descText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ShadowContainer extends StatelessWidget {
  ShadowContainer({super.key, required this.child, this.radius = 15.0,required this.color});
  Widget child;
  double radius;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, right: 13, left: 13, top: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow:  [
          BoxShadow(
              color: color, offset: const Offset(-5, 5), blurRadius: 5),
          BoxShadow(
              color: color, offset: const Offset(5, -5), blurRadius: 5),
          BoxShadow(
              color: color, offset: const Offset(-5, -5), blurRadius: 5),
          BoxShadow(
              color: color, offset: const Offset(5, 5), blurRadius: 5),
        ],
      ),
      child: child,
    );
  }
}