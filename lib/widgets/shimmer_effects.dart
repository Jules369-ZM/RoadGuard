import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class PlansShimmerEffect extends StatelessWidget {
  const PlansShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    final titleBuild = Container(
      height: 24,
      width: 75,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
    final listBuild = List.generate(3, (index) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        height: 72,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    });

    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            titleBuild,
            Column(children: listBuild),
            titleBuild,
            Column(children: listBuild),
          ],
        ),
      ),
    );
  }
}
