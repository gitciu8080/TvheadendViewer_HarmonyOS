import {EPG} from "./indexpage/EPG"
import {DVR} from "./indexpage/DVR"
import {Home} from "./indexpage/Home"
import {TV} from "./indexpage/WatchTV"
import {setting} from "./indexpage/Setting"
import { TextSystem } from "../view/style";

@Entry
@Component
struct MainPage {
  @Provide currentTabIndex: number = 2;
  @Builder tabbar_text(text: string, index:number) {
    if (index === this.currentTabIndex) {
      Text(text)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.primary_main'))
        .textAlign(TextAlign.Center)
        .backgroundColor(Color.Transparent)
        .borderRadius(5)
        .padding({ left: 10, right: 10, top: 5, bottom: 5 })
    } else {
      Text(text)
        .fontWeight(FontWeight.Normal)
        .fontColor($r('app.color.black'))
        .textAlign(TextAlign.Center)
        .backgroundColor(Color.Transparent)
        .borderRadius(5)
        .padding({ left: 10, right: 10, top: 5, bottom: 5 })
    }

  }

  build() {
      Column(){
        Tabs({barPosition:BarPosition.End,index:2}){
          TabContent(){
            EPG().backgroundColor($r('app.color.background_sec')).width("100%")
          }.tabBar(this.tabbar_text('节目表', 0))
          TabContent(){
            DVR().backgroundColor($r('app.color.background_sec')).width("100%")
          }.tabBar(this.tabbar_text('录像机', 1))
          TabContent(){
            Home().backgroundColor($r('app.color.background_sec')).width("100%")
          }.tabBar(this.tabbar_text('主页', 2))
          TabContent(){
              TV().backgroundColor($r('app.color.background_sec')).width("100%")
          }.tabBar(this.tabbar_text('电视', 3))
          TabContent(){
            setting().backgroundColor($r('app.color.background_sec')).width("100%")
          }.tabBar(this.tabbar_text('设置', 4))
        }.animationDuration(300).onChange((idx: number) => this.currentTabIndex = idx)
      }.height('100%')
    }

}
