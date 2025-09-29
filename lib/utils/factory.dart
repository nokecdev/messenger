
import 'package:flutter/material.dart';

Container createCircleButton(double size, Icon icon) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.black38,
      border: Border.all(
        color: Colors.grey.shade400,
        width: 1,
      ),
      gradient: const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [0.1, 0.3],
        colors: [Colors.white, Colors.black]
      ),
    ),
    child: Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        splashColor: Colors.white,
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            width: size,
            height: size,
            child: icon,
          ),
        ),
      ),
    ),
  );
}

//Widget to display user's avatar
class UserAvatar extends StatelessWidget {
  final String userAvatar;

  const UserAvatar({super.key, required this.userAvatar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        image: DecorationImage(
          image: userAvatar.isNotEmpty
              ? NetworkImage(
                  "https://storage.googleapis.com/socialstream/$userAvatar")
              : const AssetImage('assets/blank_profile_pic.png')
                  as ImageProvider,
          fit: BoxFit.contain,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        border: Border.all(
          color: const Color(0xff7c94b6),
          width: 1.0,
        ),
      ),
    );
  }
}
