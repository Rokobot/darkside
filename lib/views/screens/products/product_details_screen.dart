import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/controllers/menu_controller.dart';
import 'package:food_app/controllers/review_controller.dart';
import 'package:food_app/controllers/wishlist_controller.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/utils/services/helpers.dart';
import 'package:food_app/views/widgets/app_button.dart';
import 'package:food_app/views/widgets/mediaquery_extension.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:food_app/views/widgets/spacing.dart';
import 'package:food_app/views/widgets/text_theme_extension.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int productQuantity = 1;

  final menuController = Get.put(MenusController());
  final cartController = Get.put(CartController());
  final wishlistController = Get.put(WishlistController());
  final reviewController = Get.put(ReviewController());
  dynamic menuId = Get.arguments;

  void fetchData() async {
    await menuController.fetchMenuDetails(menuId);
    cartController.selectedVariant = null;
    if (menuController.menuDetails!.variants.isNotEmpty) {
      cartController.selectedVariant = menuController.menuDetails!.variants[0];
      cartController.selectedVariantPrice = menuController.menuDetails!.variants[0].price;
    } else {
      cartController.selectedVariantPrice = menuController.menuDetails!.price.toDouble();
    }
  }

  @override
  void initState() {
    super.initState();
    // cartController.selectedAddons.clear();
    // cartController.selectedAddonsId.clear();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return GetBuilder<WishlistController>(builder: (wishlistController) {
        return GetBuilder<ReviewController>(builder: (reviewController) {
          return Scaffold(
              body: GetBuilder<MenusController>(builder: (menuController) {
                if (menuController.isLoading) {
                  return Center(child: Helpers.appLoader());
                }
                if (menuController.menuDetails == null) {
                  return const NotFound(message: "No menu found!");
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: context.mQuery.height * .4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.filledColor,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60.r)),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: context.mQuery.height * .3,
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  top: 40.h,
                                  left: 15.w,
                                  right: 15.w,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100.r)),
                                    image: DecorationImage(
                                      image: NetworkImage(menuController.menuDetails!.images[0].image),
                                      fit: BoxFit.fill,
                                    )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: Container(
                                          width: 34.h,
                                          height: 34.h,
                                          padding: EdgeInsets.all(10.5.h),
                                          decoration: BoxDecoration(
                                            color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.whiteColor,
                                            borderRadius: BorderRadius.circular(12.r),
                                            border:
                                                Border.all(color: AppColors.mainColor, width: Dimensions.appThinBorder),
                                          ),
                                          child: Image.asset(
                                            "$rootImageDir/back.png",
                                            height: 32.h,
                                            width: 32.h,
                                            color: AppThemes.getIconBlackColor(),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        )),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            wishlistController.addToWishlist(menuController.menuDetails!.id);
                                          },
                                          icon: Container(
                                            height: 32.r,
                                            width: 32.r,
                                            padding: EdgeInsets.all(7.r),
                                            decoration: BoxDecoration(
                                              color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.whiteColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: AppColors.mainColor, width: .2),
                                            ),
                                            child: wishlistController.isItemInWishlist(menuController.menuDetails!.id)
                                                ? Image.asset(
                                                    "$rootImageDir/love1.png",
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    "$rootImageDir/love.png",
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        Stack(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Get.toNamed(RoutesName.myCartScreen);
                                              },
                                              icon: Container(
                                                  height: 32.r,
                                                  width: 32.r,
                                                  padding: EdgeInsets.all(5.h),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Get.isDarkMode ? AppColors.darkCardColor : AppColors.whiteColor,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: AppColors.mainColor, width: .2),
                                                  ),
                                                  child: Image.asset(
                                                    "$rootImageDir/cart.png",
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                            Positioned(
                                              top: 5.h,
                                              right: 2.w,
                                              child: Container(
                                                width: 20.r,
                                                height: 20.r,
                                                decoration: BoxDecoration(
                                                    color: AppColors.mainColor,
                                                    borderRadius: BorderRadius.circular(10.r)),
                                                child: Center(
                                                  child: Text(
                                                    cartController.cartItems.length.toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(color: AppColors.whiteColor, fontSize: 12.sp),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                          Positioned(
                            bottom: 15.h,
                            left: 24.w,
                            right: 24.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menuController.menuDetails!.details.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Get.isDarkMode ? AppColors.black30 : AppColors.paragraphColor,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${AppConstants.baseCurrency}${cartController.selectedVariantPrice.toString()}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.t.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 19.h,
                                          color: AppColors.pendingColor,
                                        ),
                                        HSpace(3.w),
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text: menuController.menuDetails!.rating.length.toString(),
                                              style: context.t.displayMedium),
                                        ])),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: Dimensions.kDefaultPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VSpace(36.h),
                              menuController.menuDetails!.variants.isNotEmpty
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Variants", style: context.t.bodyLarge),
                                        VSpace(16.h),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 20.h),
                                          height: 40.h,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: menuController.menuDetails!.variants.length,
                                              itemBuilder: ((context, index) {
                                                var item = menuController.menuDetails!.variants[index];
                                                return InkWell(
                                                  onTap: () {
                                                    cartController.selectedVariant = item;
                                                    cartController.selectedVariantPrice = item.price;
                                                    cartController.selectedAddons.clear();
                                                    cartController.selectedAddonsId.clear();
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                      height: 40.h,
                                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                                      margin: EdgeInsets.only(right: 10.w),
                                                      decoration: BoxDecoration(
                                                        color: Get.isDarkMode
                                                            ? AppColors.darkCardColor
                                                            : AppColors.filledColor,
                                                        borderRadius: BorderRadius.circular(8.r),
                                                        border: Border.all(
                                                          color: cartController.selectedVariant == item
                                                              ? AppColors.mainColor
                                                              : AppThemes.borderColor(),
                                                          width: 1.w,
                                                        ),
                                                      ),
                                                      child: Text(item.variantName)),
                                                );
                                              })),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              menuController.menuDetails!.addons.isNotEmpty
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Addon", style: context.t.bodyLarge),
                                        VSpace(16.h),
                                        SizedBox(
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: menuController.menuDetails!.addons.length,
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              final addon = menuController.menuDetails!.addons[index];
                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: Image.network(addon.image, width: 40.r),
                                                title: Text(addon.name, style: context.t.bodyMedium),
                                                subtitle: Text("+ ${addon.showPrice}"),
                                                trailing: Checkbox(
                                                  value: addon.isSelected,
                                                  onChanged: (value) {
                                                    cartController.toggleAddonSelection(addon);
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        VSpace(40.h),
                                      ],
                                    )
                                  : const SizedBox(),
                              Text("Description", style: context.t.bodyLarge),
                              VSpace(12.h),
                              ReadMoreText(
                                menuController.menuDetails!.details.details,
                                trimLines: 5,
                                colorClickableText: AppColors.mainColor,
                                trimMode: TrimMode.Length,
                                trimCollapsedText: 'Show more',
                                trimExpandedText: ' Show less',
                                lessStyle: context.t.displayMedium?.copyWith(height: 1.5, color: AppColors.mainColor),
                                moreStyle: context.t.displayMedium?.copyWith(height: 1.5, color: AppColors.mainColor),
                                style: context.t.displayMedium?.copyWith(
                                    height: 1.5, color: Get.isDarkMode ? AppColors.black30 : AppColors.black50),
                              ),
                              VSpace(24.h),
                              SizedBox(height: 20.h),
                              menuController.menuDetails!.rating.isNotEmpty
                                  ? Text("Reviews", style: context.t.bodyLarge)
                                  : const SizedBox(),
                              SizedBox(height: 20.h),
                              ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: menuController.menuDetails!.rating.length,
                                itemBuilder: (context, index) {
                                  final review = menuController.menuDetails!.rating[index];
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.mainColor.withOpacity(.1),
                                          borderRadius: BorderRadius.circular(30.r),
                                        ),
                                        width: 45.w,
                                        height: 45.h,
                                        child: Icon(
                                          CupertinoIcons.person_alt_circle_fill,
                                          color: AppColors.mainColor,
                                          size: 18.sp,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RatingBar.builder(
                                              initialRating: double.parse(review.rating),
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 18,
                                              itemPadding: EdgeInsets.zero,
                                              ignoreGestures: true,
                                              unratedColor: AppColors.blackColor.withOpacity(.2),
                                              itemBuilder: (context, _) => const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                reviewController.ratingCount = rating;
                                              },
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              review.comment,
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 30.h),
                                    Text("Rate this product", style: context.t.bodyMedium),
                                    SizedBox(height: 10.h),
                                    RatingBar.builder(
                                      initialRating: 5,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemSize: 30,
                                      itemPadding: EdgeInsets.zero,
                                      ignoreGestures: false,
                                      unratedColor: AppColors.blackColor.withOpacity(.2),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        reviewController.ratingCount = rating;
                                      },
                                    ),
                                    SizedBox(height: 30.h),
                                    Text("Share your thought", style: context.t.bodyMedium),
                                    SizedBox(height: 10.h),
                                    TextFormField(
                                      controller: reviewController.commentController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field can not be empty';
                                        }
                                        return null;
                                      },
                                      maxLines: 4,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(14.w),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.w),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.w),
                                          borderSide: BorderSide(
                                            color: AppColors.mainColor,
                                            width: 1.w,
                                          ),
                                        ),
                                        errorStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: AppColors.redColor, fontSize: 12.sp),
                                        filled: true,
                                        fillColor: AppThemes.getFillColor(),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    SizedBox(
                                      width: 180.w,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: AppButton(
                                          isLoading: reviewController.isLoading,
                                          onTap: () {
                                            if (_formKey.currentState!.validate()) {
                                              reviewController.makeReview(menuId);
                                            }
                                          },
                                          text: 'Make Review',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              VSpace(30.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 38.h,
                        width: 100.w,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Get.isDarkMode ? AppColors.darkCardColor : const Color(0xffE6E7E6),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (productQuantity > 1) {
                                    productQuantity -= 1;
                                  }
                                });
                              },
                              child: Container(
                                height: 23.h,
                                width: 23.h,
                                padding: EdgeInsets.all(4.h),
                                decoration: BoxDecoration(
                                  color: Get.isDarkMode ? AppColors.darkBgColor : Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  size: 16.h,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                            Text("$productQuantity", style: context.t.bodyMedium),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  productQuantity += 1;
                                });
                              },
                              child: Container(
                                height: 23.h,
                                width: 23.h,
                                padding: EdgeInsets.all(4.h),
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Center(
                                    child: Icon(
                                  Icons.add,
                                  size: 16.h,
                                  color: AppColors.whiteColor,
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(8.r),
                        onTap: () async {
                          cartController.addItem(
                            CartItem(
                              id: menuController.menuDetails!.id,
                              name: menuController.menuDetails!.details.title,
                              quantity: productQuantity,
                              price: cartController.selectedVariantPrice,
                              image: menuController.menuDetails!.images[0].image,
                              variant: cartController.selectedVariant,
                              currency: "",
                              addons: cartController.selectedAddonsId,
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "$rootImageDir/addCart.png",
                                fit: BoxFit.cover,
                                width: 19.h,
                                height: 19.h,
                                color: AppColors.whiteColor,
                              ),
                              HSpace(10.w),
                              Text("Add To Cart", style: context.t.bodyMedium?.copyWith(color: AppColors.whiteColor)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
      });
    });
  }
}
