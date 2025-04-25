import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_plus/Models/grocery_model.dart';
import 'package:grocery_plus/constants/groccery_item.dart';
import 'package:grocery_plus/screens/upload_items.dart';
import 'package:grocery_plus/widgets/custom_text_field.dart';
import 'package:grocery_plus/widgets/home_card_widget.dart';
import 'package:grocery_plus/widgets/location_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var searchController = TextEditingController();
  var firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  List<Items> itemsList = [];
  GrocceryItem item = GrocceryItem();
  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snapshot = await firestore.collection("products").get();
      itemsList =
          snapshot.docs.map((doc) => Items.fromMap(doc.data())).toList();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => UploadItems()));
              },
              child: Icon(Icons.add),
            ),
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Grocery Plus",
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.notifications_outlined)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LocationWidget(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  CustomTextField(
                      hintText: "Search here",
                      prefixIcon: Icon(Icons.search),
                      controller: searchController),
                  SizedBox(
                    height: 12,
                  ),
                  itemsList.isEmpty
                      ? Text("There are no products to show")
                      : Expanded(
                          child: GridView.builder(
                              itemCount: itemsList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 8,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 20),
                              itemBuilder: (context, index) {
                                return HomeCardWidget(
                                  imageUrl: item.vegtable[index]['image'],
                                  title: item.vegtable[index]['title'],
                                  rating: item.vegtable[index]['rating'],
                                );
                              }),
                        )
                ]),
              ),
            ));
  }
}
