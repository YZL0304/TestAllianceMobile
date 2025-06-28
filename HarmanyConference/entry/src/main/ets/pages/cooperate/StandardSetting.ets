import { webview } from "@kit.ArkWeb";

@Component
export struct StandardSetting{
  private webviewController: webview.WebviewController = new webview.WebviewController();

  build() {
    NavDestination() {
      Column() {
        Web({ src: $rawfile('standard.html'), controller: this.webviewController })
          .domStorageAccess(true)
      }
    }
    .hideTitleBar(true)
  }
}