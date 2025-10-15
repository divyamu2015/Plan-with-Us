import 'dart:convert';
import 'dart:ui';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:house_construction_pro/constant_page.dart';
import 'package:house_construction_pro/screen/user_screen/home_page/home_page_model.dart';
import 'package:house_construction_pro/screen/user_screen/home_page/home_page_service.dart';
import 'package:house_construction_pro/screen/user_screen/suggestion.dart';
import 'package:house_construction_pro/screen/user_screen/view_engineers/view_engineers.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  final int? userId;
  final int? catId;
  final double? cent;
  final double? sqft;
  final double? expectedAmount;
  final int? engineerId;

  const MyHomePage({
    super.key,
    this.userId,
    this.catId,
    this.cent,
    this.sqft,
    this.expectedAmount,
    this.engineerId,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<HouseSearchModel> houseSearchFuture;
  bool isPredicting = false;
  int _bottomNavIndex = 0; // Default index of the first screen
  int? engineerId;

  Future<void> predictHouse() async {
    setState(() => isPredicting = true);

    try {
      final response = await http.post(
        Uri.parse(Urlss.getSuggestion),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "sqft": widget.sqft,
          "cent": widget.cent,
          "budget": widget.expectedAmount,
          "category_id": widget.catId,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MaterialBudgetSuggestionPage(prediction: data);
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${response.body}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: $e")));
    } finally {
      setState(() => isPredicting = false);
    }
  }

  final List<IconData> iconList = [
    Icons.home,
    Icons.search,
    Icons.favorite,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
    engineerId = widget.engineerId;
    houseSearchFuture = fetchHouseSearch(
      userId: widget.userId!,
      category: widget.catId!,
      cent: widget.cent!,
      sqft: widget.sqft!,
      expectedAmount: widget.expectedAmount!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---- Beautiful pastel gradient background ----
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Colors.white,
              Color.fromARGB(255, 252, 230, 235),
              Color.fromARGB(255, 252, 230, 235),
              Color.fromARGB(255, 252, 230, 235),
              Color.fromARGB(255, 252, 230, 235),
              Color.fromARGB(255, 252, 230, 235),
              // Color.fromARGB(255, 241, 181, 196),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Matched Houses",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          Color(0xFF5B4FE9),
                          Color(0xFFF178B6),
                          Color(0xFF3FE0C5),
                        ],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 80.0)),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<HouseSearchModel>(
                  future: houseSearchFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.matchedWorks.isEmpty) {
                      return const Center(
                        child: Text(
                          "No matching houses found",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }
                    final works = snapshot.data!.matchedWorks;
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: works.length,
                      itemBuilder: (context, index) {
                        final work = works[index];
                        return GestureDetector(
                          onTap: () {
                            //  print(2222222);
                            // TODO: Add navigation to detail screen
                          },
                          child: Card(
                            elevation: 9,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            shadowColor: Colors.purple.withOpacity(0.13),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 230, 215, 203),
                                    Color(0xFFF2F6FF),
                                    Color.fromARGB(255, 197, 223, 233),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // ---- Card Image ----
                                  AspectRatio(
                                    aspectRatio: 1.40,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // print(123333);
                                              predictHouse();
                                            },
                                            child: Hero(
                                              tag:
                                                  "house_image_${work.propertyImage}_$index",
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    "assets/images/placeholder_house.png",
                                                image:
                                                    "$imageUrl${work.propertyImage}",
                                                fit: BoxFit.cover,
                                                imageErrorBuilder:
                                                    (ctx, o, s) => const Icon(
                                                      Icons.image_not_supported,
                                                      size: 56,
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 7,
                                            sigmaY: 7,
                                          ),
                                          child: Container(
                                            color: Colors.white.withOpacity(
                                              0.20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  work.projectName
                                                      .toUpperCase(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 17,
                                                    color: Color.fromARGB(
                                                      255,
                                                      77,
                                                      10,
                                                      88,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  work.engineer.toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                      255,
                                                      77,
                                                      10,
                                                      88,
                                                    ),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 10),
                                                Center(
                                                  child: SizedBox(
                                                    // width: double.infinity,
                                                    height: 40,
                                                    child: ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.of(
                                                            context,
                                                          ).push(
                                                            MaterialPageRoute(
                                                              builder: (context) {
                                                                return ViewEngineersProfile(
                                                                  engineerId: work
                                                                      .engineerId,
                                                                  cent:
                                                                      work.cent,
                                                                  workId:
                                                                      work.id,
                                                                );
                                                              },
                                                            ),
                                                          ), // call API
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color.fromARGB(
                                                              255,
                                                              162,
                                                              182,
                                                              235,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        "View",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                            255,
                                                            77,
                                                            13,
                                                            88,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: SizedBox(
              //     width: double.infinity,
              //     height: 50,
              //     child: ElevatedButton(
              //       onPressed: isPredicting ? null : predictHouse,
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.deepPurpleAccent,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(16),
              //         ),
              //       ),
              //       child: isPredicting
              //           ? const CircularProgressIndicator(
              //               color: Colors.white,
              //               strokeWidth: 2,
              //             )
              //           : const Text(
              //               "View Suggestions",
              //               style: TextStyle(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        //  items: iconList.map((icon) => BottomNavigationBarItem(icon: Icon(icon), label: '')).toList(),
        activeIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        backgroundColor: Colors.white,
        activeColor: Colors.blue,
        inactiveColor: Colors.grey,
      ),
    );
  }

  Widget _infoChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.65),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
