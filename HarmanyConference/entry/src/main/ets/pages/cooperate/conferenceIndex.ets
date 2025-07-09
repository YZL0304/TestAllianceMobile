import { AppState } from "../../model/AppState";
import Course, { CourseData } from "../../model/Course";
import { bufferToString } from "../../util/BufferUtil";
import { ConferenceItem } from "../../view/ConferenceItem";

import { http } from "@kit.NetworkKit";



@Component
export struct ConferencePage {
  @Consume("ConferencePageStack") private pageStack!: NavPathStack;
  @State message: string = "会议通知";
  @State courses: Course[] = [];
  @State isLoading: boolean = true;
  @State errorMessage: string = '';


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


  async loadCourses() {
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'http://172.22.123.162:8080/getmeetingMobile',
        { method: http.RequestMethod.GET }
      );

      if (response.responseCode === 200) {
        const rawData = response.result.toString();
        console.log("原始响应数据:", rawData);
        const data: Array<Course> = JSON.parse(response.result.toString());
        this.courses = data.map((item: Course) =>
        new Course(
          item.id,
          item.name,
          item.location,
          item.startTime,
          item.endTime,
          item.creatorName,
          item.content,
          item.category,
          item.coverUrl,
          item.sponsor,
          item.agenda,
          item.guests,
          item.createTime
        )
        );

      } else {
        this.errorMessage = `获取数据失败: ${response.responseCode}`;
      }

      httpRequest.destroy();
    } catch (error) {
      console.error('加载会议失败:', JSON.stringify(error));
      this.errorMessage = '网络错误，无法加载会议';
    } finally {
      this.isLoading = false;
    }

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

        if (this.isLoading) {
          LoadingProgress()
            .width(50)
            .height(50)
            .margin({ top: 100 })
        } else if (this.errorMessage) {
          Text(this.errorMessage)
            .fontSize(16)
            .fontColor(Color.Red)
            .margin({ top: 50 })
        } else {
          List() {
            ForEach(this.courses, (course: Course) => {
              ListItem() {
                ConferenceItem({
                  course: course,
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
    }
    .hideTitleBar(true);
  }
}