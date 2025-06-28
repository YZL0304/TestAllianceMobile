import { AppState } from "../../model/AppState";
import Course, { CourseData } from "../../model/Course";
import { bufferToString } from "../../util/BufferUtil";
import { ConferenceItem } from "../../view/ConferenceItem";


@Component
export struct ConferencePage {
  @Consume("ConferencePageStack") private pageStack!: NavPathStack;
  @State message: string = "会议通知";
  @State courses: Course[] = [];

  private handleCourseClick = (course: Course) => {
    console.log("会议点击:", course.name);
    // 保存到全局状态
    AppState.getInstance().selectedCourse = course;
    // 导航到详情页
    this.pageStack.pushPath({ name: "ConferenceDetail" });
  };

  aboutToAppear(): void {
    this.loadCourses();
  }

  loadCourses() {
    getContext(this)
      .resourceManager.getRawFileContent("Course.json")
      .then((value) => {
        const jsonData: CourseData[] = JSON.parse(bufferToString(value));
        this.courses = jsonData.map(
          (item) => new Course(
            item.id, item.name, item.location, item.startTime, item.endTime,
            item.creator_name, item.content, item.category, item.cover_url,
            item.sponsor, item.agenda, item.guests, item.create_time, item.status
          )
        );
      });
  }

  build() {
    NavDestination() {
      Column() {
        Text(this.message)
          .fontSize(18)
          .fontWeight(700)
          .width('100%')
          .textAlign(TextAlign.Start)
          .padding({ left: 16 })
          .fontFamily('HarmonyHeiTi-Bold')
          .lineHeight(33)

        List() {
          ForEach(this.courses.filter(course => course.status.length === 0), (course: Course) => {
            ListItem() {
              ConferenceItem({
                course: course,
                // 传递回调函数
                onItemClick: this.handleCourseClick
              })
            }
          }, (course: Course) => course.id)
        }
        .width('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 0.5, color: 0xEEEEEE })
        .edgeEffect(EdgeEffect.Spring)
        .backgroundColor('#F1F3F5')
      }
    }
    .hideTitleBar(true);
  }
}