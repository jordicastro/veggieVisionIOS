# Veggie Vision IOS

**Author: Jordi Castro**

*[Veggie Vision Organization Repositories](https://github.com/VeggieVision)*

built using SwiftUI and ONNX runtime with UIKit.

## Views

### SplashView
- Displays the app logo and a "Get Started" button

### HomeView
- Contains a brief description of the application
  - Overview
  - Models tested and the selected model for this app
  - Team members
  - Special thanks

### ScanView
- Uses the camera feed to run real-time inference with the ONNX model
- Displays:
  - Inference time
  - Top 5 guesses with confidence
- Includes a "+" button to redirect to AddItemView

### AddItemView
- Shows the top 5 predictions returned from the model
- Allows the user to choose one and add to cart

### CartView
- Displays all items added via a `LazyVStack`.
- Each item is shown in a `HStack` with:
  - Label
  - Emoji
  - Mock-up weight

---

## State

### InferenceState
- Keeps track of top 5 guesses
- Handles freezing / resuming of the model when transitioning between views
- Tracks the current item to add to cart using CartState

### CartState
- Adds current item to cart items list
- Dynamically updates the LazyVStack in CartView