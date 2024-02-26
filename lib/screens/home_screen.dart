import 'package:flutter/material.dart';
import 'package:needle_in_haystack_flutter/screens/result_screen.dart';
import 'package:needle_in_haystack_flutter/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController textController = TextEditingController();
  late Future<List<String>> _autoCompletions;

  @override
  void initState() {
    super.initState();
    _autoCompletions = Future.value([]);
  }

  void searchVideo(String userInput) async {
    var response = ApiService().getVideos(userInput, true, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 150,
                    height: 150,
                  ),
                ),
                const Text(
                  "Needle in haystack",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ],
              ),
              child: SizedBox(
                width: 330,
                height: 50,
                child: TextField(
                  controller: textController,
                  onChanged: handleTextFieldChanged,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: "Search Needle",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(45),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 35,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _autoCompletions,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final List<String>? searchHistories = snapshot.data;
                    if (searchHistories != null) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: searchHistories.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                    keyword: searchHistories[index],
                                  ),
                                ),
                              );
                              searchVideo(searchHistories[index]);
                            },
                            child: ListTile(
                              leading: const Icon(Icons.search),
                              title: Text(
                                searchHistories[index],
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      throw Container();
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleTextFieldChanged(String userInput) {
    setState(() {
      _autoCompletions = ApiService().getAutoCompletions(userInput);
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
