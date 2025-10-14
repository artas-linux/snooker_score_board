### 🔄 **Undo and Selection Features**
- **Undo Button**: Orange undo button (Icons.undo) for each player to undo their last score
- **Player Selection**: Tap on any player's card to highlight them with a dark grey background (no toggle button)
- **Visual Selection Effect**: When a player is selected, their card gets a dark grey background and higher elevation, with white text for contrast
- **Score History**: Implemented proper tracking of score history for undo functionality
- **User Feedback**: Snackbar notifications for all actions (undo, selection)
- **Data Integrity**: Proper handling of score history and break tracking in the Player model

### 🎨 **Compact Popup Design**
- **Add Score Button**: Kept the preferred bright green color for better visibility
- **Foul Button**: Maintained as dark red (Colors.red.shade700) for contrast
- **Emoji Popup**: Compact dark popup (Colors.grey.shade900) with fixed width (300px)
- **Larger Emojis**: Enlarged emoji size to 28px for better visibility
- **Larger Containers**: Increased emoji containers to 52x52 with more rounded corners
- **Improved Spacing**: Better spacing between elements for cleaner look