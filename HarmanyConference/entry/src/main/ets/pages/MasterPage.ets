import { HomePage } from './home'
import { ConferencePage } from './cooperate/conferenceIndex'
import { cooperateIndex } from './cooperate/CooperateIndex'
import { User } from '../model/User';


@Entry
@Component
struct MasterPage {
  @StorageLink('currentUser') currentUser: User | null = null;
  @Provide('ConferencePageStack') conferencePageStack: NavPathStack = new NavPathStack();
  @State currentIndex: number = 0
  private tabsController: TabsController = new TabsController()

  @Builder
  tabBarBuilder(title: string, targetIndex: number, selectedIcon: Resource, unselectIcon: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedIcon : unselectIcon)
        .width(24)
        .height(24)
      Text(title)
        .fontSize(10)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.currentIndex === targetIndex ? '#007dff' : 'rgba(0, 0, 0, 0.6)')
        .textAlign(TextAlign.Center)
        .lineHeight(14)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
      this.tabsController.changeIndex(targetIndex)
    })
  }

  build() {
    Column() {
      this.renderHeader()

      Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
        TabContent() {
          HomePage()
        }
        .tabBar(this.tabBarBuilder('首页', 0, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))

        TabContent() {
          cooperateIndex()
        }
        .tabBar(this.tabBarBuilder('合作', 1, $r('app.media.ic_02_on'), $r('app.media.ic_02_off')))

      }
      .vertical(false)
      .scrollable(false)
      .divider({ strokeWidth: 0.5, color: '#0D182431' })
      .backgroundColor('#ffffff')
      .padding({ top: 8, bottom: 28 })
    }
    .height('100%')
    .backgroundColor('#ffffff')
  }

  @Builder
  renderHeader() {
    Row() {
      Text(this.getTitle())
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)
        .padding({left:20})
    }
    .width('100%')
    .height(30)
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
  }

  getTitle(): string {
    const titles = ['课表', '合作']
    return titles[this.currentIndex]
  }
}
