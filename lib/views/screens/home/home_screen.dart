import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/bindings/controller_index.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/menu_category_controller.dart';
import 'package:food_app/controllers/menu_controller.dart';
import 'package:food_app/controllers/wishlist_controller.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/utils/services/helpers.dart';
import 'package:food_app/utils/utils.dart';
import 'package:food_app/views/screens/products/product_item.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:food_app/views/widgets/shimmer_preloader.dart';
import 'package:food_app/views/widgets/text_theme_extension.dart';
import 'package:hive/hive.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/user_preference_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';
import '../profile/profile_setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final menuCategoryController = Get.put(MenuCategoryController());
  final menuController = Get.put(MenusController());
  final wishlistController = Get.put(WishlistController());
  final cartController = Get.put(CartController());
  final profileController = Get.put(ProfileController());
  final languageController = Get.put(LanguageController());


  final List<String> _routes = [
    RoutesName.productScreen,
    RoutesName.wishlistScreen,
    RoutesName.myCartScreen,
    RoutesName.myOrdersScreen,
  ];

  int _selectedIndex = 0;

  final List<String> _labels = ["Menus", "Wishlist", "Cart", "My Orders"];
  final List<String> _icons = [
    "products.png",
    "love.png",
    "cart.png",
    "order.png"
  ];



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Get.toNamed(_routes[index]);
  }


  void fetchData() async {
    await profileController.fetchDashboardData();
    checkVerificationStatus();
    menuController.fetchMenu();
    wishlistController.fetchWishlist();
    profileController.fetchUserData();
    languageController.getStoredData();
    menuCategoryController.fetchMenuCategories();
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<LanguageController>(builder: (languageController) {
      return GetBuilder<ProfileController>(builder: (profileController) {
        return GetBuilder<CartController>(builder: (cartController) {
          return Scaffold(
            key: scaffoldKey,
            appBar: buildAppbar(CartController),
            body: RefreshIndicator(
              onRefresh: () async {
                fetchData();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(languageController.getStoredData()['Hello'] ?? "Hello,",
                          style: t.bodyMedium?.copyWith(
                            fontSize: 16.sp,
                          )),
                      profileController.isLoading
                          ? SizedBox(height: 30.h)
                          : profileController.userData == null
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    Text(profileController.userData!.firstname,
                                        maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyLarge),
                                    const SizedBox(width: 5),
                                    Text(profileController.userData!.lastname,
                                        maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyLarge),
                                  ],
                                ),
                      VSpace(23.h),
                      Container(
                        height: 154.h,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            image: DecorationImage(image: AssetImage("$rootImageDir/home_bg.png"), fit: BoxFit.cover)),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  gradient: LinearGradient(
                                    colors: [
                                      Get.isDarkMode ? Colors.transparent : Colors.black12.withOpacity(.5),
                                      Get.isDarkMode ? Colors.transparent : Colors.black12.withOpacity(.5),
                                      Get.isDarkMode ? Colors.transparent : Colors.black12.withOpacity(.5),
                                      Get.isDarkMode ? Colors.transparent : Colors.black12.withOpacity(.5),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    stops: const [0, 0.4, 0.4, 0],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(15.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      languageController.getStoredData()["Place Your \nBest Food Order"] ??
                                          "Place Your \nBest Food Order",
                                      style: t.titleMedium?.copyWith(color: AppColors.whiteColor)),
                                  InkWell(
                                    onTap: () => Get.toNamed(RoutesName.productScreen),
                                    child: Container(
                                      height: 35.h,
                                      width: 139.w,
                                      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor,
                                        borderRadius: BorderRadius.circular(32.r),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 23.h,
                                            width: 23.h,
                                            padding: EdgeInsets.all(3.h),
                                            decoration: const BoxDecoration(
                                              color: AppColors.whiteColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.asset(
                                              "$rootImageDir/cart.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Text(languageController.getStoredData()["Order Now"] ?? "Order Now",
                                              style: t.bodyMedium?.copyWith(color: AppColors.whiteColor)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      VSpace(28.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            languageController.getStoredData()["Find By Category"] ?? "Find By Category",
                            style: t.bodyLarge?.copyWith(fontSize: 18.sp),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(RoutesName.productScreen);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Text(languageController.getStoredData()['See All'] ?? 'See All',
                                  style: t.displayMedium?.copyWith(
                                    fontSize: 16.sp,
                                    color: AppColors.mainColor,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      VSpace(20.h),
                      GetBuilder<MenuCategoryController>(builder: (menuCategoryController) {
                        if (menuCategoryController.isLoading) {
                          return SizedBox(
                            height: 42.h,
                            width: double.infinity,
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: ((context, index) {
                                  return Container(
                                      margin: EdgeInsets.only(right: 20.w),
                                      width: 110,
                                      height: 30,
                                      child: const ShimmerPreloader());
                                })),
                          );
                        }
                        if (menuCategoryController.menuCategories == null) {
                          return Center(
                              child: Text(languageController.getStoredData()['No categories found!'] ??
                                  'No categories found!'));
                        }
                        return SizedBox(
                          height: 42.h,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemCount: menuCategoryController.menuCategories!.length,
                              itemBuilder: ((context, index) {
                                var item = menuCategoryController.menuCategories![index];
                                return InkWell(
                                  onTap: () {
                                    Get.toNamed(RoutesName.productScreen, arguments: item.id);
                                  },
                                  child: Container(
                                    height: 42.h,
                                    padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 16.w),
                                    margin: EdgeInsets.only(right: 10.w),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(width: Dimensions.appThinBorder, color: AppColors.mainColor),
                                      borderRadius: BorderRadius.circular(32.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(30.r),
                                          child: Image.network(
                                            height: 23.h,
                                            width: 23.h,
                                            menuCategoryController.menuCategories![index].image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        HSpace(8.w),
                                        Text(
                                          menuCategoryController.menuCategories![index].name,
                                          style: t.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                        );
                      }),
                      VSpace(32.h),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 116.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  image: DecorationImage(
                                      image: AssetImage("$rootImageDir/discount1.png"), fit: BoxFit.fill)),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        gradient: LinearGradient(
                                          colors: [
                                            Get.isDarkMode ? Colors.transparent : Colors.black12.withOpacity(.5),
                                            Get.isDarkMode ? Colors.transparent : Colors.black12.withOpacity(.5),
                                            Get.isDarkMode ? Colors.transparent : Colors.black12.withOpacity(.5),
                                            Get.isDarkMode ? Colors.transparent : Colors.black12.withOpacity(.5),
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          stops: const [0, 0.4, 0.4, 0],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12.h),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languageController.getStoredData()["Delicious\nFood with us."] ??
                                              "Delicious\nFood with us.",
                                          style: t.bodyMedium?.copyWith(color: AppColors.whiteColor),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () => Get.toNamed(RoutesName.productScreen),
                                              child: Container(
                                                height: 24.h,
                                                width: 79.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4.r),
                                                  color: AppColors.mainColor,
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  languageController.getStoredData()["Order Now"] ?? "Order Now",
                                                  style: t.labelSmall?.copyWith(
                                                      fontWeight: FontWeight.w500, color: AppColors.whiteColor),
                                                )),
                                              ),
                                            ),
                                            Container(
                                              height: 40.h,
                                              width: 40.h,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                image: AssetImage("$rootImageDir/discount_frame.png"),
                                                fit: BoxFit.cover,
                                              )),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 5.w),
                                                  child: Text(
                                                    "32%",
                                                    style: t.labelSmall?.copyWith(
                                                      fontSize: 10.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors.whiteColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          HSpace(20.w),
                          Expanded(
                            child: Container(
                              height: 116.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  image: DecorationImage(
                                      image: AssetImage("$rootImageDir/discount2.png"), fit: BoxFit.fill)),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        gradient: LinearGradient(
                                          colors: [
                                            Get.isDarkMode ? Colors.transparent : Colors.black12.withOpacity(.5),
                                            Get.isDarkMode ? Colors.transparent : Colors.black12.withOpacity(.5),
                                            Get.isDarkMode ? Colors.transparent : Colors.black12.withOpacity(.5),
                                            Get.isDarkMode ? Colors.transparent : Colors.black12.withOpacity(.5),
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          stops: const [0, 0.4, 0.4, 0],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12.h),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languageController.getStoredData()["The greatest Pizza\nplace in town"] ??
                                              "The greatest Pizza\nplace in town",
                                          style: t.bodyMedium?.copyWith(color: AppColors.whiteColor),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () => Get.toNamed(RoutesName.productScreen),
                                              child: Container(
                                                height: 24.h,
                                                width: 79.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4.r),
                                                  color: AppColors.mainColor,
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  languageController.getStoredData()["Order Now"] ?? "Order Now",
                                                  style: t.labelSmall?.copyWith(
                                                      fontWeight: FontWeight.w500, color: AppColors.whiteColor),
                                                )),
                                              ),
                                            ),
                                            Container(
                                              height: 40.h,
                                              width: 40.h,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                image: AssetImage("$rootImageDir/discount_frame.png"),
                                                fit: BoxFit.cover,
                                              )),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 5.w),
                                                  child: Text(
                                                    "50%",
                                                    style: t.labelSmall?.copyWith(
                                                      fontSize: 10.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors.whiteColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      VSpace(32.h),
                      GetBuilder<MenusController>(builder: (menuController) {
                        return GetBuilder<WishlistController>(builder: (wishlistController) {
                          if (menuController.isLoading) {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20.w,
                                mainAxisSpacing: 20.h,
                                childAspectRatio: 3 / 4.3,
                              ),
                              itemBuilder: (context, index) {
                                return const ShimmerPreloader();
                              },
                            );
                          }
                          if (menuController.menus == null || menuController.menus!.isEmpty) {
                            return SizedBox(
                                height: 200.h,
                                child: NotFound(
                                    message: languageController.getStoredData()["No menu found!"] ?? "No menu found!"));
                          }
                          return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: menuController.menus!.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20.w,
                                mainAxisSpacing: 20.h,
                                childAspectRatio: 3 / 4.3,
                              ),
                              itemBuilder: (context, index) {
                                var clampedIndex = index.clamp(0, menuController.menus!.length);
                                var item = menuController.menus![clampedIndex];
                                return ProductItem(
                                  menu: item,
                                  wishlist: wishlistController.wishlist,
                                  addToWishlist: wishlistController.addToWishlist,
                                  isItemInWishlist: wishlistController.isItemInWishlist,
                                );
                              });
                        });
                      }),
                      VSpace(24.h),
                    ],
                  ),
                ),
              ),
            ),
            drawer: buildDrawer(context, languageController.getStoredData()),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              selectedItemColor: AppThemes.getIconBlackColor(),
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
              items: List.generate(_labels.length, (index) {
                return BottomNavigationBarItem(
                  icon: Image.asset(
                    "$rootImageDir/${_icons[index]}",
                    height: index == 3 ? 17.h : 20.h,
                    width: index == 3 ? 17.h : 20.h,
                    color: _selectedIndex == index
                        ? AppThemes.getIconBlackColor()
                        : Colors.grey,
                  ),
                  label: _labels[index],
                );
              }),
            ),
          );
        });
      });
    });
  }

  CustomAppBar buildAppbar(controller) {
    return CustomAppBar(
      toolberHeight: 100.h,
      prefferSized: 100.h,
      isTitleMarginTop: true,
      leading: IconButton(
          padding: EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: Image.asset(
            "$rootImageDir/menu.png",
            height: 26.h,
            width: 26.h,
            color: AppThemes.getIconBlackColor(),
            fit: BoxFit.fitHeight,
          )),
      title: "",
      actions: [
    /*    profileController.isLoading
            ? Container(
                margin: EdgeInsets.only(top: 25.h),
                child: Helpers.appLoader(),
              )
            : profileController.userData == null
                ? const SizedBox()
                : InkResponse(
                    onTap: () {
                      Get.to(() => const ProfileSettingScreen(isFromHomePage: true));
                    },
                    child: Container(
                      height: 38.h,
                      width: 38.h,
                      margin: EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h),
                      decoration: BoxDecoration(
                        color: AppColors.imageBgColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.mainColor, width: .2),
                        image: DecorationImage(
                          image: NetworkImage(
                            profileController.userData!.image,
                            // "$rootImageDir/avatar.webp",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),*/
        HSpace(10.w),
        Container(
          margin: EdgeInsets.only(top: 20.h),
          child: InkWell(
            onTap: () => Get.toNamed(RoutesName.myCartScreen),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(11.r),
                  child: Image.asset(
                    "$rootImageDir/cart.png",
                    height: 28.h,
                    width: 28.h,
                    color: AppThemes.getIconBlackColor(),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Positioned(
                  top: 5.h,
                  right: 2.w,
                  child: Container(
                    width: 20.r,
                    height: 20.r,
                    decoration: BoxDecoration(color: AppColors.mainColor, borderRadius: BorderRadius.circular(10.r)),
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
          ),
        ),
        HSpace(20.w),
      ],
    );
  }

  Drawer buildDrawer(BuildContext context, storedLanguage) {
    TextTheme t = Theme.of(context).textTheme;

    return Drawer(
      child: ListView(
        children: [
          profileController.isLoading
              ? SizedBox(
                  width: double.maxFinite,
                  height: 200.h,
                  child: Helpers.appLoader(),
                )
              : profileController.userData == null
                  ? const SizedBox()
                  : SizedBox(
                      width: double.maxFinite,
                      height: 200.h,
                      child: Column(
                        children: [
                          VSpace(30.h),
                          Container(
                            height: 80.h,
                            width: 80.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: AppColors.imageBgColor,
                              image: DecorationImage(
                                image: NetworkImage(
                                  profileController.userData!.image,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          VSpace(20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(profileController.userData!.firstname,
                                  maxLines: 1, overflow: TextOverflow.ellipsis, style: context.t.bodyLarge),
                              const SizedBox(width: 5),
                              Text(profileController.userData!.lastname,
                                  maxLines: 1, overflow: TextOverflow.ellipsis, style: context.t.bodyLarge),
                            ],
                          ),
                          VSpace(5.h),
                          Text(
                            profileController.userData!.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.t.bodySmall?.copyWith(color: AppThemes.getBlack50Color()),
                          )
                        ],
                      ),
                    ),

          VSpace(20.h),
          Padding(padding: EdgeInsets.all(10.dm),
            child: GetBuilder<AppController>(
              builder: (_){
                return Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
                  decoration: BoxDecoration(
                    color: AppThemes.getFillColor(),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: Get.isDarkMode ? AppColors.mainColor : Colors.transparent,
                      width: Dimensions.appThinBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(languageController.languageData['Theme'] ?? "Theme", style: t.bodyMedium),
                      VSpace(10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 38.h,
                                width: 38.h,
                                padding: EdgeInsets.all(7.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.r),
                                  color: AppColors.mainColor.withOpacity(.1),
                                ),
                                child: Image.asset(
                                  Get.isDarkMode ? "$rootImageDir/light.png" : "$rootImageDir/moon.png",
                                  color: AppColors.mainColor,
                                ),
                              ),
                              HSpace(10.w),
                              Text(
                                languageController.languageData['Dark Mode'] ?? "Dark Mode",
                                style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Transform.scale(
                            scale: .8,
                            child: CupertinoSwitch(
                              value: HiveHelp.read(Keys.isDark) ?? false,
                              activeColor: AppColors.mainColor,
                              onChanged: _.onChanged,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          VSpace(20.h),
          ListTile(
            onTap: () {
              Get.toNamed(RoutesName.reservationScreen);
            },
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(.1),
                  shape: BoxShape.circle
              ),
              child: Padding(
                padding:  EdgeInsets.all(8.dm),
                child: Image.asset(
                  "$rootImageDir/reservation.png",
                  height: 17.h,
                  width: 17.h,
                  fit: BoxFit.cover,
                  color: AppThemes.getIconBlackColor(),
                ),
              ),
            ),
            title: Text(storedLanguage['Transactions'] ?? "Reservation", style: context.t.displayMedium?.copyWith(
              fontSize: 16.sp,
            )),
          ),
          ListTile(
            onTap: () {
              Get.toNamed(RoutesName.reservationHistoryScreen);
            },
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(.1),
                  shape: BoxShape.circle
              ),
              child: Padding(
                padding:  EdgeInsets.all(8.dm),
                child: Image.asset(
                  "$rootImageDir/reservation.png",
                  height: 17.h,
                  width: 17.h,
                  fit: BoxFit.cover,
                  color: AppThemes.getIconBlackColor(),
                ),
              ),
            ),
            title: Text(storedLanguage['Transactions'] ?? "Reservation history", style: context.t.displayMedium?.copyWith(
              fontSize: 16.sp,
            )),
          ),
  Padding(padding: EdgeInsets.only(left:15.dm ), child:         ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, i) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {
            if (i == 0) {
              Get.toNamed(RoutesName.editProfileScreen);
            } else if (i == 1) {
              Get.toNamed(RoutesName.changePasswordScreen);
            } else if (i == 2) {
              Get.toNamed(RoutesName.addressListScreen);
            } else if (i == 3) {
              Get.toNamed(RoutesName.twoFaVerificationScreen);
            } else if (i == 4) {
              buildLogoutDialog(context, t, languageController.languageData);
            } else {
              buildDeleteAccountDialog(context, t, languageController.languageData);
            }
          },
          leading: Container(
            height: i == 2 ? 38.h : 36.h,
            width: i == 2 ? 38.h : 36.h,
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              color: AppColors.mainColor.withOpacity(.1),
            ),
            child: i == 0
                ? Image.asset(
              "$rootImageDir/profile_edit.png",
              color: Get.isDarkMode ? AppColors.black10 : AppColors.blackColor,
            )
                : i == 1
                ? Image.asset(
              "$rootImageDir/lock_main.png",
              color:
              Get.isDarkMode ? AppColors.black10 : AppColors.blackColor,
            )
                : i == 2
                ? Image.asset(
              "$rootImageDir/verification.png",
              color: Get.isDarkMode
                  ? AppColors.black10
                  : AppColors.blackColor,
            )
                : i == 3
                ? Image.asset(
              "$rootImageDir/2fa.png",
              color: Get.isDarkMode
                  ? AppColors.black10
                  : AppColors.blackColor,
            )
                : i == 4
                ? Image.asset(
              "$rootImageDir/log_out.png",
              color: Get.isDarkMode
                  ? AppColors.black30
                  : AppColors.blackColor,
            )
                : Image.asset(
              "$rootImageDir/delete.png",
              color: Get.isDarkMode
                  ? AppColors.black30
                  : AppColors.blackColor,
            ),
          ),
          title: Text(
              i == 0
                  ? languageController.languageData['Edit Profile'] ?? "Edit Profile"
                  : i == 1
                  ? languageController.languageData['Change Password'] ??
                  "Change Password"
                  : i == 2
                  ? languageController.languageData['Addresses'] ??
                  "Addresses"
                  : i == 3
                  ? languageController.languageData['2FA Security'] ??
                  "2FA Security"
                  : i == 4
                  ? languageController.languageData['Log Out'] ??
                  "Log Out"
                  : languageController
                  .languageData['Delete Account'] ??
                  "Delete Account",
              style: t.displayMedium),
          trailing: i == 4 || i == 5
              ? const SizedBox.shrink()
              : Container(
            height: 36.h,
            width: 36.h,
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: AppThemes.getDarkBgColor(),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 16.h,
              color: AppThemes.getGreyColor(),
            ),
          ),
        );
      }),),
          ListTile(
            onTap: () {
              Get.toNamed(RoutesName.transactionScreen);
            },
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(.1),
                shape: BoxShape.circle
              ),
              child: Padding(
                padding:  EdgeInsets.all(8.dm),
                child: Image.asset(
                  "$rootImageDir/transfer.png",
                  height: 17.h,
                  width: 17.h,
                  fit: BoxFit.cover,
                  color: AppThemes.getIconBlackColor(),
                ),
              ),
            ),
            title: Text(storedLanguage['Transactions'] ?? "Transactions", style: context.t.displayMedium?.copyWith(
              fontSize: 16.sp,
            )),
          ),

          ListTile(
            onTap: () {
              Get.toNamed(RoutesName.supportTicketListScreen);
            },
            leading: Container(
              decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(.1),
                  shape: BoxShape.circle
              ),
              child: Padding(
                padding:  EdgeInsets.all(8.dm),
                child: Image.asset(
                  "$rootImageDir/support.png",
                  height: 17.h,
                  width: 17.h,
                  fit: BoxFit.cover,
                  color: AppThemes.getIconBlackColor(),
                ),
              ),
            ),
            title: Text(storedLanguage['Support Ticket'] ?? "Support Ticket",
                style: context.t.displayMedium?.copyWith(
                  fontSize: 16.sp,
                )),
          ),
        ],
      ),
    );
  }
}
Future<dynamic> buildLogoutDialog(BuildContext context, TextTheme t, storedLanguage) {
  TextTheme t = Theme.of(context).textTheme;
  UserPreference userPreference = UserPreference();
  final cartController = Get.put(CartController());

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          storedLanguage['Log Out'] ?? "Log Out",
          style: t.bodyLarge?.copyWith(fontSize: 20.sp),
        ),
        content: Text(
          storedLanguage['Do you want to Log Out?'] ?? "Do you want to Log Out?",
          style: t.bodyMedium,
        ),
        actions: [
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                storedLanguage['No'] ?? "No",
                style: t.bodyLarge,
              )),
          MaterialButton(
              onPressed: () async {
                // HiveHelp.remove(Keys.token);
                userPreference.removeUser().then((value) {
                  cartController.clearCart();
                  Get.offAllNamed(RoutesName.loginScreen);
                });
              },
              child: Text(
                storedLanguage['Yes'] ?? "Yes",
                style: t.bodyLarge,
              )),
        ],
      );
    },
  );
}

Future<dynamic> buildDeleteAccountDialog(BuildContext context, TextTheme t, storedLanguage)
{
  final cartController = Get.put(CartController());
  final profileController = Get.put(ProfileController());

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          storedLanguage['Delete Account'] ?? "Delete Account",
          style: t.bodyLarge?.copyWith(fontSize: 20.sp),
        ),
        content: Text(
          storedLanguage['Do you want to delete your account?'] ?? "Do you want to delete your account?",
          style: t.bodyMedium,
        ),
        actions: [
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                storedLanguage['No'] ?? "No",
                style: t.bodyLarge,
              )),
          MaterialButton(
            onPressed: () async {
              cartController.clearCart();
              profileController.deleteAccount();
            },
            child: Text(
              storedLanguage['Yes'] ?? "Yes",
              style: t.bodyLarge,
            ),
          ),
        ],
      );
    },
  );
}
class Category {
  final String img;
  final String name;
  Category({required this.img, required this.name});
}
