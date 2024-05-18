import 'package:english_flashcard/models/topic_model.dart';
import 'package:english_flashcard/repository/topic_repo.dart';
import 'package:english_flashcard/topic_handle/topic_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchHomepage extends StatefulWidget {
  const SearchHomepage({super.key});

  @override
  State<SearchHomepage> createState() => _SearchHomepageState();
}

class _SearchHomepageState extends State<SearchHomepage> {

  final TopicRepository topicRepository = TopicRepository();

  String query = "Third";

  Widget listItems(
      BuildContext context, int index, TopicModel topicModel, String topicId) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(CupertinoIcons.book),
        ),
        title: Text(topicModel.topicName),
        subtitle: Text("Words: ${topicModel.numberOfWord}"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicDetailsPage(
                topicModel: topicModel,
                topicId: topicId,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topicBox(String query) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: topicRepository.getPublicTopicByTopicName(query),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          List topicList = snapshots.data?.docs ?? [];
          if (topicList.isEmpty) {
            return const Center(
              child: Text("No topics"),
            );
          }

          return ListView.builder(
            itemCount: topicList.length,
            itemBuilder: (context, index) {
              TopicModel topicModel = topicList[index].data();
              String docId = topicList[index].id;
              return listItems(context, index, topicModel, docId);
            },
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Search"),
        ),
      ),
      body: SingleChildScrollView(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

            query != "" ?_topicBox(query) : Container(),

        ],
      ),),
    );
  }
}
