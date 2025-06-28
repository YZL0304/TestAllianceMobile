import Association, { AssociationData } from "../../model/Association";
import { bufferToString } from "../../util/BufferUtil";
import { ConferenceDetail } from "../../view/ConferenceDetail";
import { RegisterView } from "../../view/RegisterView";
import { Activity } from "./Activity";
import { ConferencePage } from "./conferenceIndex";
import { StandardSetting } from "./StandardSetting";
import { TechTraining } from "./TechTraining";
import { ToolMaking } from "./ToolMaking";

@Component
export struct cooperateIndex {
  @Consume("ConferencePageStack") private conferencePageStack!: NavPathStack;
  @State association: Association[] = [];

  // 页面映射
  @Builder
  PageMap(name: string) {
    if (name === "ConferencePage") {
      ConferencePage();
    } else if (name === "ConferenceDetail") {
      ConferenceDetail();
    } else if(name === "RegisterView"){
      RegisterView();
    }else if(name === "TechTraining"){
      TechTraining();
    }else if(name === "StandardSetting"){
      StandardSetting();
    }else if(name === "Activity"){
      Activity();
    }else if(name === "ToolMaking"){
      ToolMaking();
    }
  }

  // 卡片颜色
  private cardColors: string[] = [
    "#ff2c83e2", // 会议研讨
    "#fff39a62", // 标准制定
    "#ff5bbc5b", // 技术培训
    "#ffe9cb4d", // 工具研发
    "#fffa7fa6", // 公益行动
  ];

  aboutToAppear(): void {
    this.loadAssociation();
  }

  loadAssociation() {
    getContext(this)
      .resourceManager.getRawFileContent("association.json")
      .then((value) => {
        const jsonData: AssociationData[] = JSON.parse(bufferToString(value));
        this.association = jsonData.map(
          (item) => new Association(item.title, item.content, item.footer)
        );
      });
  }

  build() {
    Navigation(this.conferencePageStack) {
      Column() {
        Scroll() {
          Grid() {
            ForEach(this.association, (item: Association, index: number) => {
              GridItem() {
                cardInfo({
                  title: item.title,
                  content: item.content,
                  footer: item.footer,
                  bgcolor: this.cardColors[index % this.cardColors.length],
                });
              }
              .aspectRatio(1)
              .margin(4);
            });
          }
          .columnsTemplate("1fr 1fr")
          .columnsGap(8)
          .rowsGap(8)
          .padding(12)
          .width("100%");
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .layoutWeight(1);
      }
      .width("100%")
      .height("100%")
      .backgroundColor("#f5f7fa");
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.PageMap);
  }
}

// 卡片组件
@Component
struct cardInfo {
  @Consume("ConferencePageStack") private pageStack!: NavPathStack;
  private title: string = "";
  private content: string = "";
  private footer: string = "";
  private bgcolor: ResourceColor | string = "#ffffff";

  build() {
    Column() {
      // 上半部分：标题区域
      Stack() {
        Text(this.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor("#ffffffff")
          .textAlign(TextAlign.Center)
          .width("100%")
          .padding({ left: 8, right: 8 });
      }
      .height("50%")
      .backgroundColor(this.bgcolor)
      .borderRadius({ topLeft: 16, topRight: 16 });

      // 下半部分：内容区域
      Column() {
        Scroll() {
          Text(this.content)
            .fontSize(14)
            .fontColor("#4d4d4d")
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .lineHeight(20)
            .padding({ top: 8, bottom: 8, left: 16, right: 16 });
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1);

        if (this.footer) {
          Text(this.footer)
            .fontSize(12)
            .fontColor("#999999")
            .textAlign(TextAlign.Start)
            .width("100%")
            .padding({ bottom: 12, right: 16 })
            .margin({ top: 8 })
            .maxLines(1);
        }
      }
      .backgroundColor("#ffffff")
      .height("50%")
      .borderRadius({ bottomLeft: 16, bottomRight: 16 });
    }
    .onClick(() => this.handleClick());
  }

  private handleClick() {
    if (this.title === "会议研讨") {
      this.pageStack.pushPath({ name: "ConferencePage" });
    }else if(this.title === "技术培训"){
      this.pageStack.pushPath({name:"TechTraining"})
    }else if(this.title === "标准制定"){
      this.pageStack.pushPath({name:"StandardSetting"})
    }else if(this.title === "公益行动"){
      this.pageStack.pushPath({name:"Activity"})
    }else if(this.title === "工具研发"){
      this.pageStack.pushPath({name:"ToolMaking"})
    }
  }
}