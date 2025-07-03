import { bufferToString } from "../../util/BufferUtil";
import { DynamicsDetail } from "../../view/DynamicsDetail";

@Component
export struct DynamicMap {
  @Consume("DynamicsPageStack") private dynamicPageStack!: NavPathStack;

  @Builder
  PageMap(name:string) {
    if (name === "DynamicsDetail") {
      DynamicsDetail()
    }
  }

  build() {
    Navigation(this.dynamicPageStack) {
      Column() {
        // Main content would go here
      }
      .width("100%")
      .height("100%")
      .backgroundColor("#f5f7fa");
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.PageMap);
  }
}