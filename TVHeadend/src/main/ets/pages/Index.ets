import {EPG} from "./indexpage/EPG"
import {DVR} from "./indexpage/DVR"
import {Home} from "./indexpage/Home"
// import {Doc} from "./indexpage/Doc"
import {setting} from "./indexpage/Setting"

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
        Tabs({barPosition:BarPosition.End,index:2}){
          TabContent(){
            EPG()
          }.tabBar('EPG')
          TabContent(){
            DVR()
          }.tabBar('DVR')
          TabContent(){
            Home()
          }.tabBar('首页')
          TabContent(){
          }.tabBar('看电视')
          TabContent(){
            setting()
          }.tabBar('设置')
        }.animationDuration(300).height('100%').onChange((idx: number) => this.currentTabIndex = idx)
      }.height('100%')
    }

}
