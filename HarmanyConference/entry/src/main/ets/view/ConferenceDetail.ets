import { AppState } from "../model/AppState";
import Course from "../model/Course";
import { NetworkImage } from "../util/NetworkImage";


@Component
export struct ConferenceDetail {
  @State course: Course | null = null;
  @Consume("ConferencePageStack") private pageStack!: NavPathStack;

  aboutToAppear() {
    this.course = AppState.getInstance().selectedCourse;
    console.log("加载的课程:", this.course);
  }

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column }) {
        // 导航标题
        Row() {
          Text("会议详情")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 16 });
        }
        .width("100%")
        .padding(10)
        .backgroundColor("#F1F3F5");

        Scroll() {
          Column({ space: 10 }) {
            if (this.course) {
              // 封面图
              NetworkImage({ url: this.course.cover_url })
                .width("100%")
                .height(200)
                .borderRadius(12)
                .margin({ bottom: 12 });

              // 会议标题与主办单位
              Text(this.course.name)
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 4 });

              Text(`主办单位：${this.course.sponsor}`)
                .fontSize(16)
                .fontColor(Color.Gray);

              // 创建者和会议类别
              Text(`创建者：${this.course.creator_name}`)
                .fontSize(16)
                .fontColor(Color.Gray);

              Text(`类别：${this.course.category}`)
                .fontSize(16)
                .fontColor(Color.Gray);

              // 会议时间和地点
              Text(`时间：${this.course.date} ${this.course.duration} `)
                .fontSize(16)
                .fontColor(Color.Gray);

              Text(`地点：${this.course.location}`)
                .fontSize(16)
                .fontColor(Color.Gray);

              // 议程
              Text("会议议程")
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 10, bottom: 4 });

              Text(this.course.agenda)
                .fontSize(15)
                .lineHeight(22);

              // 嘉宾介绍
              Text("嘉宾介绍")
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 10, bottom: 4 });

              Text(this.course.guests)
                .fontSize(15)
                .lineHeight(22);

              // 会议内容
              Text("会议内容")
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 10, bottom: 4 });

              Text(this.course.content)
                .fontSize(15)
                .lineHeight(22);

              // 创建时间
              Text(`创建时间：${this.course.create_time}`)
                .fontSize(14)
                .fontColor(Color.Gray)
                .margin({ top: 12 });

              // 参与状态按钮
              if (this.course.status.length === 0) {
                Button("立即参加")
                  .type(ButtonType.Capsule)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .width("90%")
                  .margin({ top: 20 })
                  .backgroundColor("#4CAF50")
                  .onClick(() => {
                    // 参加会议的逻辑，跳到报名列
                    this.pageStack.pushPath({name:"RegisterView"})
                  });
              } else {
                Text("您已报名参加")
                  .fontSize(16)
                  .fontColor(Color.Red)
                  .margin({ top: 20 });
              }
            } else {
              // 加载状态
              Column() {
                Progress({
                  value: 0,
                  total: 100,
                  type: ProgressType.Linear,
                })
                  .width(200)
                  .height(4)
                  .color(Color.Blue);
                Text("加载中...").margin({ top: 8 });
              }
              .width("100%")
              .height(200)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center);
            }
          }
          .padding(16)
          .width("100%");
        }
        .layoutWeight(1)
        .width("100%");
      }
      .width("100%")
      .height("100%");
    }
    .hideTitleBar(true)
  }
}