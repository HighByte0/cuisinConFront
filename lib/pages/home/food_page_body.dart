import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/controllers/popular_product_controller.dart';
import 'package:food_delivery_flutter/controllers/recommended_product_controller.dart';
import 'package:food_delivery_flutter/models/product_model.dart';
import 'package:food_delivery_flutter/pages/food/popular_food_detail.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/widgets/app_column.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:food_delivery_flutter/widgets/icon_and_text.dart';
import 'package:food_delivery_flutter/widgets/small_text.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';

import 'package:data_filters/data_filters.dart'; 

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({Key? key}) : super(key: key);

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  List<List> data = [
    ['Maarif',  '100', ],
    ['Anfa',  '200' , ],
    ['Gauthier', '300' , ],
    ['Derb Ghallef', '300 - 400 MAD', ],
    ['Mediouna', 'Above 400 MAD', ],

  ];
  List<String> titles = ['local', 'price',];
  List<int>? filterIndex;

  PageController pageController =
      PageController(viewportFraction: 0.85); // space between slide
  var _currPageValue = 0.0;

  double _scaleFactor = 0.8;

  double _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();

    // Add listener if user sliding the item
    pageController.addListener(() {
      setState(() {
        // every time sliding, the application will update _currPageValue
        _currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    // Remove data that are not needed if leaving this page
    // Prevent memory leaks
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        GetBuilder<PopularProductController>(builder: (popularProducts) {
          return popularProducts.isLoaded
              ? Container(
                
                  color: const Color.fromARGB(255, 255, 255, 255),
                  height: Dimensions.pageView,

                  child: PageView.builder(
                    controller: pageController,
                    itemCount: popularProducts.popularProductList.length,
                    itemBuilder: (context, position) {
                      return _buildPageItem(position,
                          popularProducts.popularProductList[position]);
                    },
                  ),
                )
              : CircularProgressIndicator(color: AppColors.mainColor);
        }),
        
        GetBuilder<PopularProductController>(builder: (popularProducts) {
          return  DotsIndicator(
            dotsCount: popularProducts.popularProductList.isEmpty
                ? 1
                : popularProducts.popularProductList.length,
            position: _currPageValue,
            decorator: DotsDecorator(
              activeColor: AppColors.mainColor,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius5)),
            ),
          );
        }),
       
        // Popular Section Title
       Container(
  padding: EdgeInsets.symmetric(horizontal: Dimensions.width30),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DataFilters(
        data: data,
        filterTitle: titles,
        showAnimation: true,
        recent_selected_data_index: (List<int>? index) {
          setState(() {
            filterIndex = index;
          });
        },
        style: FilterStyle(
          buttonColor: Colors.green,
          buttonColorText: Colors.white,
          filterBorderColor: Colors.grey,
        ),
      ),
      SizedBox(height: Dimensions.height10),
      Container(
        margin: EdgeInsets.only(left: Dimensions.width30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BigText(text: "Particulier", color: AppColors.mainBlackColor),
            SizedBox(width: Dimensions.width10),
            Container(
              margin: EdgeInsets.only(bottom: Dimensions.height3),
              child: BigText(text: ".", color: Colors.black26),
            ),
            SizedBox(width: Dimensions.width10),
            Container(
              margin: EdgeInsets.only(bottom: Dimensions.height2),
              child: SmallText(text: "Food Pairing"),
            ),
          ],
        ),
      ),
      // Additional container or widgets here
    ],
  ),
),

        // List of informations and images of Popular Food
        GetBuilder<RecommendedProductController>(builder: (recommendedProduct) {
          return recommendedProduct.isLoaded
              ? ListView.builder(
  physics: NeverScrollableScrollPhysics(), // make scrollable limited
  shrinkWrap: true,
  itemCount: recommendedProduct.recommendedProductList.length,
  itemBuilder: (context, index) {
    // Ensure that filterIndex is not null and contains the current index
    bool isFiltered = filterIndex == null || filterIndex!.contains(index);

    if (isFiltered) {
      return GestureDetector(
        onTap: () {
          Get.toNamed(RouteHelper.getRecommendedFoodDetail(index, "initial"));
        },
        child: Container(
          margin: EdgeInsets.only(
            left: Dimensions.width20,
            right: Dimensions.width20,
            top: Dimensions.height10,
          ),
          child: Row(
            children: [
              // Rounded Picture in the left
              Container(
                height: Dimensions.listViewImgSize,
                width: Dimensions.listViewImgSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white38,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      AppConstants.IMAGE_UPLOADS_URL +
                          recommendedProduct.recommendedProductList[index].img!,
                    ),
                  ),
                ),
              ),
              // Information Container
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      top: Dimensions.height10, bottom: Dimensions.height10),
                  height: Dimensions.listViewTextContSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Dimensions.radius20),
                      bottomRight: Radius.circular(Dimensions.radius20),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: Dimensions.width10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BigText(
                            text: recommendedProduct
                                .recommendedProductList[index].name!),
                        Expanded(
                          child: SmallText(
                              text: recommendedProduct
                                  .recommendedProductList[index].description!),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconAndTextWidget(
                              icon: Icons.circle_sharp,
                              text: "Normal",
                              iconColor: AppColors.iconColor1,
                            ),
                            IconAndTextWidget(
                              icon: Icons.location_on,
                              text: "22 Km",
                              iconColor: AppColors.mainColor,
                            ),
                            IconAndTextWidget(
                              icon: Icons.access_time_rounded,
                              text: "33 mins",
                              iconColor: AppColors.iconColor2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox.shrink(); // Return an empty widget if not filtered
    }
  },
)

              : CircularProgressIndicator(color: AppColors.mainColor);
        }),
      ],
    );
  }

  Widget _buildPageItem(int index, ProductModel popularProduct) {
    Matrix4 matrix = new Matrix4.identity();

    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == (_currPageValue.floor() + 1)) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == (_currPageValue.floor() - 1)) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 1);
    }

    // build element of carousel
    return Transform(
      
      transform: matrix,
      child: Stack(
        
        children: [
          GestureDetector(
            
            onTap: () {
              Get.toNamed(RouteHelper.getPopularFoodDetail(index, "initial"));
            },
            child: Container(
              
              height: Dimensions.pageViewContainer,
              // color: const Color.fromARGB(66, 141, 1, 1),
              margin: EdgeInsets.only(
                  left: Dimensions.width10, right: Dimensions.width10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                color: index.isEven
                    ? const Color(0xFF69c5df)
                    : const Color(0xFF9294cc),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      AppConstants.IMAGE_UPLOADS_URL + popularProduct.img!),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(
                  left: Dimensions.width30,
                  right: Dimensions.width30,
                  bottom: Dimensions.height30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFe8e8e8),
                    blurRadius: 5.0,
                    offset: Offset(0, 5),
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-5, 0),
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(5, 0),
                  ),
                ],
              ),
              child: Container(
                
                padding: EdgeInsets.only(
                    top: Dimensions.height15,
                    right: Dimensions.width15,
                    left: Dimensions.width15,
             
                    
                                        ),
                child: AppColumn(
                  foodTitle: popularProduct.name!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
