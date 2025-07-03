import { DynamicsData } from '../../model/Dynamics';
import Dynamics from '../../model/Dynamics';
import { bufferToString } from '../../util/BufferUtil';
import { AppState } from '../../model/AppState';
import { DynamicsDetail } from '../../view/DynamicsDetail';
import { DynamicItem } from '../../view/DynamicItem';
import { BusinessError } from '@kit.BasicServicesKit';

// 每页加载的数量
const PAGE_SIZE = 10;

@Component
export struct dynamicIndex {
  // 消费路由栈（需父组件通过 @Provide 提供）
  @Consume("DynamicsPageStack") private dynamicPageStack!: NavPathStack;

  @State dynamicList: Dynamics[] = [];   // 原始动态数据列表
  @State filteredList: Dynamics[] = [];  // 搜索过滤后的列表
  @State isLoading: boolean = true;      // 加载状态
  @State errorMessage: string = '';      // 错误信息
  @State searchKeyword: string = '';     // 搜索关键词
  @State refreshing: boolean = false;    // 下拉刷新状态（响应式）
  @State loadingMore: boolean = false;   // 上拉加载状态
  @State hasMoreData: boolean = true;    // 是否还有更多数据
  @State currentPage: number = 1;        // 当前页码

  @Builder
  PageMap(name:string) {
    if (name === "DynamicsDetail") {
      DynamicsDetail()
    }
  }
  // 动态点击事件处理
  private handleDynamicClick = (dynamic: Dynamics) => {
    console.log("动态点击:", dynamic.title);
    AppState.getInstance().selectedDynamics = dynamic;
    console.log("保存的动态:", AppState.getInstance().selectedDynamics);
    // 跳转时传递动态数据到详情页
    this.dynamicPageStack.pushPath({ name:"DynamicsDetail" });
  };

  aboutToAppear(): void {
    this.loadDynamic(true);
  }

  // 加载动态数据
  loadDynamic(isRefresh: boolean = false) {
    if (isRefresh) {
      this.currentPage = 1;
      this.hasMoreData = true;
    }

    if (!isRefresh &&!this.hasMoreData) {
      return;
    }

    // 设置加载状态
    if (isRefresh) {
      this.refreshing = true;
    } else {
      this.loadingMore = true;
    }

    getContext(this)
      .resourceManager.getRawFileContent("dynamics.json")
      .then((value) => {
        const jsonData: DynamicsData[] = JSON.parse(bufferToString(value));
        const startIndex = (this.currentPage - 1) * PAGE_SIZE;
        const endIndex = this.currentPage * PAGE_SIZE;
        const pageData = jsonData.slice(startIndex, endIndex);

        const newDynamics = pageData.map(
          (item) => new Dynamics(
            item.dynamic_id, item.publisher_id, item.title, item.content,
            item.summary, item.author, item.image_url, item.create_time, item.audit_status
          )
        );

        if (isRefresh) {
          this.dynamicList = newDynamics;
        } else {
          this.dynamicList = [...this.dynamicList, ...newDynamics];
        }

        if (newDynamics.length > 0) {
          this.currentPage++;
        }

        this.hasMoreData = endIndex < jsonData.length;
        this.filteredList = this.dynamicList.filter(d => d.audit_status!== 0);

        // 重置状态
        this.isLoading = false;
        this.refreshing = false;
        this.loadingMore = false;
      })
      .catch((error: BusinessError) => {
        this.errorMessage = "数据加载失败";
        this.isLoading = false;
        this.refreshing = false;
        this.loadingMore = false;
      });
  }

  // 搜索逻辑：实时过滤
  private onSearchChange(keyword: string) {
    this.searchKeyword = keyword;
    this.filteredList = this.dynamicList
      .filter(d => d.audit_status!== 0)
      .filter(d => d.title.includes(keyword) || d.summary.includes(keyword));
  }

  build() {
    Navigation(this.dynamicPageStack)  {
      Column() {
        // 搜索栏
        Row() {
          TextInput({ placeholder: "搜索动态名称" })
            .fontSize(14)
            .width('100%')
            .padding({ left: 12, right: 12 })
            .backgroundColor('#F5F5F5')
            .borderRadius(8)
            .onChange((value: string) => this.onSearchChange(value));

        }
        .width('100%')
        .padding({ top: 12, bottom: 12, left: 16, right: 16 })
        .backgroundColor('#FFFFFF');

        // 动态列表 + 下拉刷新（使用 Refresh 组件）
        Refresh({ refreshing: $$this.refreshing }) {
          List() {
            ForEach(this.filteredList, (dynamic: Dynamics) => {
              ListItem() {
                DynamicItem({
                  dynamic: dynamic,
                  onItemClick1: this.handleDynamicClick
                })
              }
            }, (dynamic: Dynamics) => dynamic.title)

            // 加载更多指示器
            if (this.loadingMore) {
              ListItem() {
                Row() {
                  Text("加载中...")
                    .fontSize(14)
                    .fontColor('#999999')
                }
                .width('100%')
                .height(48)
                .justifyContent(FlexAlign.Center)
              }
            }

            // 没有更多数据提示
            if (!this.loadingMore &&!this.hasMoreData && this.filteredList.length > 0) {
              ListItem() {
                Row() {
                  Text("已经到底了")
                    .fontSize(14)
                    .fontColor('#999999')
                }
                .width('100%')
                .height(48)
                .justifyContent(FlexAlign.Center)
              }
            }
          }
          .width('100%')
          .layoutWeight(1)
          .divider({ strokeWidth: 0.5, color: 0xEEEEEE })
          .edgeEffect(EdgeEffect.Spring)
          .backgroundColor('#F1F3F5')
          .visibility(this.isLoading? Visibility.Hidden : Visibility.Visible)
          .onReachEnd(() => { // 上拉加载逻辑
            if (!this.loadingMore && this.hasMoreData) {
              this.loadDynamic(false);
            }
          })
        }
        .onRefreshing(() => {
          this.loadDynamic(true);
          console.log('开始刷新数据');
        })
        .backgroundColor(0xF1F3F5)
        .refreshOffset(64)
        .pullToRefresh(true)

        // 加载状态提示
        if (this.isLoading &&!this.refreshing) {
          Text("加载中...")
            .fontSize(16)
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 50 });
        }

        // 错误提示
        if (this.errorMessage &&!this.refreshing &&!this.loadingMore) {
          Text(this.errorMessage)
            .fontSize(16)
            .fontColor('#FF0000')
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 50 });
        }
      }
    }
    .hideTitleBar(true)
    .navDestination(this.PageMap)
  }
}

