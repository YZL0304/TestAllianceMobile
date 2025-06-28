import Course from '../model/Course'


@Component
export struct CourseItem {
  // 使用 @Prop 装饰器接收外部传入的数据
  @Prop course: Course;

  // 定义点击事件回调,这个是点击可以跳到会议详情
  private onItemClick: () => void = () => {};

  build() {
    Row() {
      // 时间部分
      Column() {
        Text(this.course.duration)
          .fontSize(16)
          .fontColor(0x007DFF) // 蓝色
          .fontWeight(FontWeight.Medium)
      }
      .width(120)
      .margin({ right: 12 })

      // 课程信息部分
      Column() {
        Text(this.course.name)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 8 })

        Text(this.course.location)
          .fontSize(16)
          .fontColor(0x666666) // 深灰色
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1) // 占据剩余空间
    }
    .width('100%')
    .padding(16)
    .backgroundColor(0xFFFFFF) // 白色背景
    .borderRadius(12)
    .margin({ top: 8, bottom: 8 })
    .onClick(() => {
      this.onItemClick();
    })
  }
}