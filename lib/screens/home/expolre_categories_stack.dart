import 'package:flutter/material.dart';
import 'package:zeerah/core/common/app_exports.dart';

class ExpolreCategoriesStack extends StatelessWidget {
  const ExpolreCategoriesStack({super.key});

  static const List<String> images = [
    UserMessages.exploreCategory1,
    UserMessages.exploreCategory2,
    UserMessages.exploreCategory3,
    UserMessages.exploreCategory4,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: EditorPickCarousel(images: images),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class EditorPickCarousel extends StatefulWidget {
  final List<String> images;
  const EditorPickCarousel({super.key, required this.images});

  @override
  State<EditorPickCarousel> createState() => _EditorPickCarouselState();
}

class _EditorPickCarouselState extends State<EditorPickCarousel> {
  late final PageController _controller;
  late final int _baseOffset;

  // Tuning knobs for the stack depth effect.
  static const double _stackScaleStep = 0.07;
  static const double _stackXStep = 44.0;
  static const double _stackOpacityStep = 0.32;
  static const double _leftPeekFraction = 1.08;

  @override
  void initState() {
    super.initState();
    _baseOffset = 1000 * widget.images.length;
    _controller = PageController(
      viewportFraction: 1.0,
      initialPage: _baseOffset,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _page {
    if (!_controller.hasClients) {
      return _controller.initialPage.toDouble();
    }
    final pos = _controller.position;
    if (!pos.hasPixels || !pos.hasContentDimensions) {
      return _controller.initialPage.toDouble();
    }
    return _controller.page ?? _controller.initialPage.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final cardWidth = w * 0.74;
        final cardHeight = (h - 40).clamp(0.0, cardWidth * 1.55);

        return Stack(
          children: [
            // Gesture surface
            Positioned.fill(
              child: PageView.builder(
                controller: _controller,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemBuilder: (_, __) => const SizedBox.expand(),
              ),
            ),

            // Visual layer
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return _buildStackedCards(
                      page: _page,
                      cardWidth: cardWidth,
                      cardHeight: cardHeight,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStackedCards({
    required double page,
    required double cardWidth,
    required double cardHeight,
  }) {
    final entries = <_RenderEntry>[];
    final n = widget.images.length;
    final centerV = page.floor();
    
    for (var offset = -2; offset <= 4; offset++) {
      final vi = centerV + offset;
      final delta = vi - page;
      if (delta < -1.2 || delta > 3.2) continue;
      final realIndex = ((vi % n) + n) % n;
      entries.add(_RenderEntry(index: realIndex, delta: delta));
    }

    entries.sort((a, b) => b.delta.compareTo(a.delta));

    return Stack(
      alignment: Alignment.center,
      children: [
        for (final e in entries)
          _buildPositionedCard(
            imageUrl: widget.images[e.index],
            delta: e.delta,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
          ),
      ],
    );
  }

  Widget _buildPositionedCard({
    required String imageUrl,
    required double delta,
    required double cardWidth,
    required double cardHeight,
  }) {
    late final double scale;
    late final double xOffset;
    late final double opacity;

    if (delta >= 0) {
      final d = delta;
      scale = (1.0 - _stackScaleStep * d).clamp(0.6, 1.0);
      xOffset = _stackXStep * d;
      opacity = (1.0 - _stackOpacityStep * d).clamp(0.0, 1.0);
    } else {
      final t = -delta;
      scale = 1.0;
      xOffset = -cardWidth * _leftPeekFraction * t;
      opacity = (1.0 - 0.25 * t).clamp(0.0, 1.0);
    }

    return Transform.translate(
      offset: Offset(xOffset, 0),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: _ImageView(imageUrl: imageUrl),
          ),
        ),
      ),
    );
  }
}

class _RenderEntry {
  final int index;
  final double delta;
  const _RenderEntry({required this.index, required this.delta});
}

// Fixed ImageView to handle both asset and network images
class _ImageView extends StatelessWidget {
  final String imageUrl;
  const _ImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.55),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    // Check if it's a network URL or asset path
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _buildErrorWidget(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingWidget();
        },
      );
    } else {
      // Asset image
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _buildErrorWidget(),
     
      );
    }
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey.shade900,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 48,
              color: Colors.white24,
            ),
            SizedBox(height: 8),
            Text(
              'Failed to load image',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: Colors.grey.shade800,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.amber,
          strokeWidth: 2,
        ),
      ),
    );
  }
}