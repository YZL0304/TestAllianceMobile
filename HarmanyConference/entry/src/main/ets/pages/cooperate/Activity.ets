import { webview } from "@kit.ArkWeb";

@Component
export struct Activity{
  private webviewController: webview.WebviewController = new webview.WebviewController();

  build() {
    NavDestination() {
      Column() {
        Web({ src: $rawfile('activity.html'), controller: this.webviewController })
          .domStorageAccess(true)
      }
    }
    .hideTitleBar(true)
  }
}