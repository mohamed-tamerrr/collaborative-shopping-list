import 'package:flutter/material.dart';

class GroupAvatars extends StatelessWidget {
  const GroupAvatars({
    super.key,
    required this.imageUrls,
    this.size = 35,
  });
  final List<String> imageUrls;
  final double size;

  @override
  Widget build(BuildContext context) {
    const overlap = 15.0;
    final remaining = imageUrls.length > 2
        ? imageUrls.length - 2
        : 0;

    return SizedBox(
      height: size,
      width: size + (size - overlap) * 2,
      child: Stack(
        children: [
          if (imageUrls.isNotEmpty)
            Positioned(
              left: 0,
              child: CircleAvatar(
                radius: size / 2,
                backgroundImage: AssetImage(imageUrls[0]),
              ),
            ),

          if (imageUrls.length > 1)
            Positioned(
              left: size - overlap,
              child: CircleAvatar(
                radius: size / 2,
                backgroundImage: AssetImage(imageUrls[1]),
              ),
            ),

          if (remaining > 0)
            Positioned(
              left: 2 * (size - overlap),
              child: CircleAvatar(
                radius: size / 2,
                backgroundColor: const Color(0xFFF3EFFF),
                child: Text(
                  '+$remaining',
                  style: TextStyle(
                    color: Colors.purple[600],
                    fontWeight: FontWeight.w600,
                    fontSize: size / 2.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
