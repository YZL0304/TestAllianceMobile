import { AppState } from "../../model/AppState";
import Course, { CourseData } from "../../model/Course";
import { User } from "../../model/User";
import { bufferToString } from "../../util/BufferUtil";
import { CalendarView } from "../../view/CalendarView";
import { ConferenceDetail } from "../../view/ConferenceDetail";
import { CourseView } from "../../view/CourseView";

@Component
export struct HomePage {
  @Consume("ConferencePageStack") private pageStack!: NavPathStack;
  @State message: string = '今日日程';
  @State selectedDate: Date = new Date();
  @State courses: Course[] = [];
  @StorageLink('currentUser') currentUser: User | null = null;
  @State errorMessage: string = '';


  aboutToAppear(): void {

    this.loadCourses();
  }

  loadCourses() {
    getContext(this).resourceManager.getRawFileContent('Course.json')
      .then(value => {
        const jsonData: CourseData[] = JSON.parse(bufferToString(value));
        if (!this.currentUser) {
          console.error('当前用户不存在');
          this.courses = [];
          return;
        }
        const userId = this.currentUser.user_id;
        const filtered = jsonData.filter(item => {
          // 确保 status 是数组
          return Array.isArray(item.status) && item.status.includes(userId);
        });

        this.courses = filtered.map(item => new Course(
          item.id,//
          item.name,//
          item.location,//
          item.startTime,//
          item.endTime,//
          item.creator_name,//
          item.content,//是content
          item.category,//category
          item.cover_url,//cover
          item.sponsor,//sponsor
          item.agenda,//agenda
          item.guests,
          item.create_time,//
          item.status
        ));
      })
  }

  // 日期选择回调
  handleDateSelected = (date: Date) => {
    this.selectedDate = date;
  }

  // 处理课程点击事件
  private handleCourseClick = (course: Course) => {
    console.log("参加会议点击", course.name);
    AppState.getInstance().selectedCourse = course;
    this.pageStack.pushPath({ name: "ConferenceDetail" });
  }

  // 获取当前选中日期的课程
  getFilteredCourses(): Course[] {
    if (this.courses.length === 0) return [];

    // 格式化为YYYY-MM-DD
    const formatDate = (d: Date) =>
    `${d.getFullYear()}-${(d.getMonth()+1).toString().padStart(2, '0')}-${d.getDate().toString().padStart(2, '0')}`;

    const targetDate = formatDate(this.selectedDate);

    return this.courses.filter(course => {
      const startDate = new Date(course.startTime);
      const courseDate = formatDate(startDate);
      return courseDate === targetDate;
    });
  }
  // 页面跳转
  @Builder
  PageMap(name: string) {
    if (name === "ConferenceDetail") {
      ConferenceDetail()
    }
  }

  build() {
    Navigation(this.pageStack) {
      Column() {
        Text(this.message)
          .fontSize(18)
          .fontWeight(700)
          .width('100%')
          .textAlign(TextAlign.Start)
          .padding({ left: 16 })
          .fontFamily('HarmonyHeiTi-Bold')
          .lineHeight(33)

        CalendarView({
          selectedDate: this.selectedDate,
          onDateSelected: this.handleDateSelected
        })



          // 错误消息
          if (this.errorMessage) {
            Column() {
              Text(this.errorMessage)
                .fontSize(16)
                .fontColor(Color.Red)
            }
            .layoutWeight(1)
          }
          // 无会议消息
          else if (this.courses.length === 0) {
            Column() {
              Text('您尚未参加任何会议')
                .fontSize(18)
                .fontColor('#999')
            }
            .width('100%')
            .height(200)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .margin({ top: 30 })
            .layoutWeight(1)
          }



        if (this.getFilteredCourses().length > 0 && !this.errorMessage) {
          CourseView({
            courses: this.getFilteredCourses(),
            onCourseClick: this.handleCourseClick
          })
            .layoutWeight(1) // 占据剩余空间
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.PageMap);
  }
}