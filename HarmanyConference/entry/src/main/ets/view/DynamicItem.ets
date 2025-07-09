import Dynamics from "../model/Dynamics";
import { NetworkImage } from "../util/NetworkImage";

@Component
export struct DynamicItem {
  @Prop dynamic: Dynamics;
  private  onItemClick1: (dynamic: Dynamics) => void = () => {};
  @State imageLoadFailed: boolean = false;

  build() {
    Row() {
      // 左侧文本区域 (占70%宽度)
      Column() {
        // 会议标题 - 粗体大字号
        Text(this.dynamic.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor("#000000")
          .margin({ top: 12, bottom: 4 })
          .width('100%')
          .textAlign(TextAlign.Start)

        // 会议简介 - 中等字号灰色
        Text(this.dynamic.content)
          .fontSize(14)
          .fontColor("#666666")
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
          .lineHeight(18)
          .width('100%')
          .margin({ bottom: 8 })

        // 使用Flex布局将主办单位推到底部
        Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.End }) {
          // 主办单位 - 小字号浅灰色
          Text(this.dynamic.author)
            .fontSize(12)
            .fontColor("#888888")
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .width('100%')
        }
        .margin({ bottom: 12 })
        .width('100%')
        .layoutWeight(1)  // 占据剩余空间
      }
      .layoutWeight(7)  // 文本区域占70%宽度
      .padding({ left: 16, right: 8 })
      .height('100%')
      .justifyContent(FlexAlign.Start)

      // 右侧图片区域 (占30%宽度) - 移到文本区域外部
      Column() {
        // 如果图片加载失败，显示提示文字
        if (this.imageLoadFailed) {
          Text('封面内容')
            .fontSize(12)
            .fontColor("#999999")
            .textAlign(TextAlign.Center)
            .width(100)
            .height(100)
            .backgroundColor('#F0F0F0')
            .borderRadius(8)
        } else {
          NetworkImage({ url: this.dynamic.image_url })
            .width(100)
            .height(100)
            .borderRadius(8)
        }
      }
      .layoutWeight(3)  // 图片区域占30%宽度
      .margin({ right: 16 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(140)
    .borderRadius(16)
    .backgroundColor(Color.White)
    .margin({ top: 8, bottom: 8 })
    .padding({ top: 8, bottom: 8 })
    .onClick(() => {
      console.log("点击动态：",this.dynamic.title)
      this.onItemClick1(this.dynamic);
    })

  }
}
