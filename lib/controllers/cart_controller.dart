import 'package:flutter/foundation.dart';
import 'package:food_app/config/app_colors.dart';
import 'package:food_app/models/menu_model.dart';
import 'package:food_app/utils/services/helpers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartController extends GetxController {
  bool isLoading = false;
  bool isScreenLoading = false;
  final box = GetStorage();
  List<CartItem> cartItems = [];

  MenuVariant? selectedVariant;
  double selectedVariantPrice = 0.00;
  var selectedAddons = <MenuAddon>[];
  List<int> selectedAddonsId = [];

  @override
  void onInit() {
    super.onInit();
    List? storedItems = box.read<List>('cartItems');
    if (storedItems != null) {
      cartItems = storedItems.map((item) => CartItem.fromJson(item)).toList();
    }
    update(); // Ensure the UI is updated after initialization
  }

  void toggleAddonSelection(MenuAddon addon) {
    addon.isSelected = !addon.isSelected;
    if (addon.isSelected) {
      selectedAddons.add(addon);
      selectedAddonsId.add(addon.id);
      selectedVariantPrice += addon.price;
    } else {
      selectedAddons.remove(addon);
      selectedAddonsId.remove(addon.id);
      selectedVariantPrice -= addon.price;
    }
    update();
  }

  // void addItem(CartItem item) {
  //   int index = cartItems.indexWhere((element) => element.id == item.id && element.variant == item.variant);
  //   if (index == -1) {
  //     cartItems.add(item);
  //   } else {
  //     cartItems[index].quantity += item.quantity;
  //   }
  //   updateCart();
  //   _showAddToCartSnackbar(item);
  //   update();
  // }

  void addItem(CartItem item) {
    // Make sure each item gets its own copy of the selected addons
    List<int> addonsCopy = List<int>.from(selectedAddonsId);

    // Create a new CartItem with the selected addons for this specific item
    CartItem newItem = CartItem(
      id: item.id,
      name: item.name,
      image: item.image,
      variant: item.variant,
      quantity: item.quantity,
      price: item.price,
      currency: item.currency,
      addons: addonsCopy, // Pass the addons copy
    );

    int index = cartItems.indexWhere((element) => element.id == item.id && element.variant == item.variant);
    if (index == -1) {
      cartItems.add(newItem);
    } else {
      cartItems[index].quantity += newItem.quantity;
    }

    updateCart();
    _showAddToCartSnackbar(newItem);

    // Reset selectedAddons after adding an item
    selectedAddons.clear();
    selectedAddonsId.clear();
    // selectedVariantPrice = 0.00;

    update();
  }

  void removeItem(int id, dynamic variant) {
    cartItems.removeWhere((item) => item.id == id); // && item.variant == variant
    updateCart();
    update();
  }

  void updateCart() {
    box.write('cartItems', cartItems.map((item) => item.toJson()).toList());
    update(); // Ensure the UI is updated after updating the cart
  }

  void clearCart() {
    cartItems = []; // Clear the list
    box.write('cartItems', []); // Write an empty list to storage
    update(); // Ensure the UI is updated after clearing the cart
    if (kDebugMode) {
      print('Cart has been cleared.');
    }
  }

  bool isItemInCart(int id) {
    return cartItems.any((item) => item.id == id);
  }

  void increaseQuantity(int id, dynamic variant) {
    var item = cartItems.firstWhere((item) => item.id == id); // && item.variant == variant.id
    item.quantity++;
    updateCart();
  }

  void decreaseQuantity(int id, dynamic variant) {
    var item = cartItems.firstWhere((item) => item.id == id); // && item.variant == variant.id
    if (item.quantity > 1) {
      item.quantity--;
    }
    updateCart();
  }

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void _showAddToCartSnackbar(CartItem item) {
    Helpers.showToast(msg: "Added to the cart", bgColor: AppColors.mainColor, textColor: AppColors.whiteColor);
    // Get.snackbar(
    //   'Added to Cart',
    //   '${item.name} has been added to your cart.',
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: AppThemes.getFillColor(),
    //   // colorText: AppThemes.(),
    //   borderRadius: 15,
    //   margin: EdgeInsets.all(10.r),
    //   duration: const Duration(seconds: 1),
    //   animationDuration: const Duration(milliseconds: 300),
    // );
  }
}

class CartItem {
  final int id;
  final String name;
  final String image;
  final dynamic variant;
  int quantity;
  final double price;
  final String currency;
  final List<int> addons;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.variant,
    required this.quantity,
    required this.price,
    required this.currency,
    required this.addons,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'variant': variant,
        'quantity': quantity,
        'price': price,
        'currency': currency,
        'addons': addons,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      variant: json['variant'],
      quantity: json['quantity'],
      price: json['price'],
      currency: json['currency'],
      addons: List<int>.from(json['addons']),
    );
  }
}
