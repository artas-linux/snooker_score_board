import 'package:flutter/material.dart';

class NotificationUtils {
  static OverlayEntry? _overlayEntry;

  static void showCenterNotification(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
  }) {
    // Remove any existing overlay entry
    _removeOverlay();

    // Create a new overlay entry
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildNotification(
        context,
        message,
        backgroundColor,
        textColor,
      ),
    );

    // Add the overlay entry to the overlay
    Overlay.of(context).insert(_overlayEntry!);

    // Remove the overlay after the specified duration
    Future.delayed(duration, _removeOverlay);
  }

  static Widget _buildNotification(
    BuildContext context,
    String message,
    Color backgroundColor,
    Color textColor,
  ) {
    final Size screenSize = MediaQuery.of(context).size;

    return Positioned(
      top: 50, // Position it at the top, but you can change to 'top: null, bottom: null' for center
      left: (screenSize.width - 300) / 2, // Center horizontally with a max width of 300
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  // Alternative: Popup notification that appears in the center of the screen
  static void showPopupNotification(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
  }) {
    // Remove any existing overlay entry
    _removeOverlay();

    // Create a new overlay entry
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildPopupNotification(
        context,
        message,
        backgroundColor,
        textColor,
      ),
    );

    // Add the overlay entry to the overlay
    Overlay.of(context).insert(_overlayEntry!);

    // Remove the overlay after the specified duration
    Future.delayed(duration, _removeOverlay);
  }

  static Widget _buildPopupNotification(
    BuildContext context,
    String message,
    Color backgroundColor,
    Color textColor,
  ) {
    final Size screenSize = MediaQuery.of(context).size;

    return Positioned(
      top: screenSize.height / 3, // Position it in the upper third of the screen
      left: (screenSize.width - 280) / 2,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications,
                  color: textColor,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}