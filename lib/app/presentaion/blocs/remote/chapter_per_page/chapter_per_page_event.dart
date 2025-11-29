abstract class ChapterPerPageEvent {}

class GetChapterPerPageEvent extends ChapterPerPageEvent {
  String slug;
  int page;
  GetChapterPerPageEvent(this.slug, this.page);
}
