import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:zeerah/core/common/app_exports.dart';

class ExpolreCategoriesStack extends StatelessWidget {
  final List<CategoryItem> items;
  final String categoryName;
  const ExpolreCategoriesStack({
    super.key,
    required this.items,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: EditorPickCarousel(items: items, categoryName: categoryName),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class EditorPickCarousel extends StatefulWidget {
  final List<CategoryItem> items;
  final String categoryName;
  const EditorPickCarousel({
    super.key,
    required this.items,
    required this.categoryName,
  });

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
    _baseOffset = (1000 * widget.items.length).toInt();
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
    final n = widget.items.length;
    final centerV = page.floor();
    
    for (var offset = -2; offset <= 4; offset++) {
      final vi = centerV + offset;
      final delta = vi - page;
      if (delta < -1.2 || delta > 3.2) continue;
      final realIndex = (((vi % n) + n) % n).toInt();
      entries.add(_RenderEntry(index: realIndex, delta: delta));
    }

    entries.sort((a, b) => b.delta.compareTo(a.delta));

    return Stack(
      alignment: Alignment.center,
      children: [
        for (final e in entries)
          _buildPositionedCard(
            item: widget.items[e.index],
            delta: e.delta,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
          ),
      ],
    );
  }

  Widget _buildPositionedCard({
    required CategoryItem item,
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
            child: _ImageView(item: item, categoryName: widget.categoryName),
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
  final CategoryItem item;
  final String categoryName;
  const _ImageView({required this.item, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Wrap EVERYTHING that shouldn't block swipes in IgnorePointer
        // Including the shadows and decoration!
        IgnorePointer(
          ignoring: true,
          child: Container(
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
            child: Stack(
              children: [
                Positioned.fill(child: _buildImage()),
              ],
            ),
          ),
        ),

        // Keep the button OUTSIDE the IgnorePointer and OUTSIDE the decorated container
        // to ensure it receives hits and isn't clipped by the parent's anti-alias
        Positioned(
          left: 10,
          right: 10,
          bottom: 12,
          child: _BookNowButton(categoryName: categoryName),
        ),
      ],
    );
  }

  Widget _buildImage() {
    final imageUrl = item.image;
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

class _BookNowButton extends StatefulWidget {
  final String categoryName;
  const _BookNowButton({required this.categoryName});

  @override
  State<_BookNowButton> createState() => _BookNowButtonState();
}

class _BookNowButtonState extends State<_BookNowButton> {
  double _dragOffset = 0;
  final double _swipeCompleteThreshold = 200.0;

  void _onDragUpdate(DragUpdateDetails details, double maxWidth) {
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dx).clamp(0, maxWidth - 60);
    });
  }

  void _onDragEnd(DragEndDetails details, double maxWidth) {
    if (_dragOffset >= maxWidth - 100) {
      // Complete swipe
      HapticFeedback.heavyImpact();
      
      // Navigate to the dynamic details screen, passing the category name as the argument
      Navigator.pushNamed(
        context, 
        AppRoutes.cleaningServices, 
        arguments: widget.categoryName,
      );
      
      // Reset after a delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _dragOffset = 0);
      });
    } else {
      // Snap back
      setState(() => _dragOffset = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        
        return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFFC0A040).withOpacity(0.3), // Goldish tint
                    const Color(0xFF408080).withOpacity(0.3), // Tealish tint
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Center Text
                  Center(
                    child: Opacity(
                      opacity: (1 - (_dragOffset / (totalWidth - 60))).clamp(0.2, 1.0),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  
                  // Left Static Icon (optional, per design you showed, it's stationary)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.15),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  // Swipable Arrow Button
                  Positioned(
                    left: _dragOffset,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (d) => _onDragUpdate(d, totalWidth),
                      onHorizontalDragEnd: (d) => _onDragEnd(d, totalWidth),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF131B1B), // Dark circular background for arrow
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}