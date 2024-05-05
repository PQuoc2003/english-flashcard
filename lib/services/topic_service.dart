import '../models/topic.dart';
import 'firestore_service.dart';

class TopicService {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> createTopic(Topic topic) async {
    await _firestoreService.createTopic(topic);
  }

  Future<void> updateTopic(Topic topic) async {
    await _firestoreService.updateTopic(topic);
  }

  Future<void> deleteTopic(String topicId) async {
    await _firestoreService.deleteTopic(topicId);
  }
}

// folder_service.dart
class FolderService {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> createFolder(Folder folder) async {
    await _firestoreService.createFolder(folder);
  }

  Future<void> updateFolder(Folder folder) async {
    await _firestoreService.updateFolder(folder);
  }

  Future<void> deleteFolder(String folderId) async {
    await _firestoreService.deleteFolder(folderId);
  }
}
