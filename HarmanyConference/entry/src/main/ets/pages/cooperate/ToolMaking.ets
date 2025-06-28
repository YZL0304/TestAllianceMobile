import { webview } from "@kit.ArkWeb";

@Component
export struct ToolMaking{
  private webviewController: webview.WebviewController = new webview.WebviewController();

  build() {
    NavDestination() {
      Column() {
        Web({ src: $rawfile('tools.html'), controller: this.webviewController })
          .domStorageAccess(true)
      }
    }
    .hideTitleBar(true)
  }
}