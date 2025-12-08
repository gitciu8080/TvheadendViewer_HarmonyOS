import {EPG} from "./indexpage/EPG"
import {DVR} from "./indexpage/DVR"
import {Home} from "./indexpage/Home"
import {TV} from "./indexpage/WatchTV"
import {setting} from "./indexpage/Setting"
import { TextSystem } from "../view/style";

@Entry
@Component
struct MainPage {
  @Provide currentTabIndex: number = 0;
  @Builder tabbar_text(text: string, isActive: boolean) {
    Text(text)
      .fontWeight(isActive ? FontWeight.Bold : FontWeight.Normal)
      .fontColor(isActive ? $r('app.color.text_hint') : $r('app.color.text_hint'))
      .textAlign(TextAlign.Center)
      .backgroundColor(isActive ? $r('app.color.primary_light') : Color.Transparent)
      .borderRadius(5)
      .padding({ left: 10, right: 10, top: 5, bottom: 5 })
  }

  build() {
      Column(){
        Row(){TextSystem({level:1,text:'Tvheadend',txtalign:TextAlign.Center,bold:FontWeight.Bold})} // 标题
        Tabs({barPosition:BarPosition.End,index:2}){
          TabContent(){
            EPG().backgroundColor($r('app.color.background_sec')).width("100%")
          }.tabBar('EPG')
          TabContent(){
            DVR().backgroundColor($r('app.color.background_sec')).width("100%")
          }.tabBar('DVR')
          TabContent(){
            Home().backgroundColor($r('app.color.background_sec')).width("100%")
          }.tabBar('首页')
          TabContent(){
              TV().backgroundColor($r('app.color.background_sec')).width("100%")
          }.tabBar('看电视')
          TabContent(){
            setting().backgroundColor($r('app.color.background_sec')).width("100%")
          }.tabBar('设置').backgroundColor($r('app.color.background_sec')).width("100%")
        }.animationDuration(300).height('100%').onChange((idx: number) => this.currentTabIndex = idx)
      }.height('100%')
    }

}
