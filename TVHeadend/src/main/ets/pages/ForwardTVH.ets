// xxx.ets
import { webview } from '@kit.ArkWeb';
import { readPreferences } from '../tools/get_epg';

@Entry
@Component
struct WebComponent {
  @State src: string = '';
  controller: webview.WebviewController = new webview.WebviewController();
  async onLoad() {
    let prefs = await readPreferences('tvheadend_config','about.html');
    console.debug(prefs)
    this.src = prefs;
  }
  aboutToAppear(): void {
    this.onLoad();
  }
  build() {
    Column() {
      Web({ src:this.src, controller: this.controller,renderMode:RenderMode.SYNC_RENDER})
    }
  }
}