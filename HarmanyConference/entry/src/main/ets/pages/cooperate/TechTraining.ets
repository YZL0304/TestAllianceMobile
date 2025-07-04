import { webview } from "@kit.ArkWeb";

@Component
export struct TechTraining{
  private webviewController: webview.WebviewController = new webview.WebviewController();

  build() {
    NavDestination() {
      Column() {
        Web({ src: $rawfile('training.html'), controller: this.webviewController })
          .domStorageAccess(true)
      }
    }
    .hideTitleBar(true)
  }
}