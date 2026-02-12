abstract class ChapterEvent {}

class GetChapterEvent extends ChapterEvent {
  final String storyId;
  GetChapterEvent(this.storyId);
}

class GetContentChapterEvent extends ChapterEvent {
  String chapterId;
  final String storyId;
  GetContentChapterEvent({required this.chapterId, required this.storyId});
}
