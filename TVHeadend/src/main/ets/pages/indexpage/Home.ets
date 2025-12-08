

import { router } from '@kit.ArkUI';
import { EPG } from "./EPG";
import { DVR } from "./DVR";

class swiperItem{
  title:string;
  image:Resource;
  click:() => void;
  constructor(title:string,image:Resource,click:() => void){
    this.title = title;
    this.image = image;
    this.click = click;
  }
}
class buttomItem{
  title:string;
  image:Resource;
  click:() => void;
  constructor(title:string,image:Resource,click:() => void){
    this.title = title;
    this.image = image;
    this.click = click;
  }
}
@Component
export struct Home {
  @State isRefreshing: boolean = false;
  @Consume @Watch('onTabChanged') currentTabIndex: number;

  private swiperList:Array<object>=[
      new swiperItem('',$r('app.media.Swiper1'),()=>{router.pushUrl({url:`pages/One_USE`})}),
      new swiperItem('',$r('app.media.Swiper1'),()=>{router.pushUrl({url:`pages/One_USE`})})
  ]
  private buttomList:Array<object>=[
      new buttomItem('EPG',$r('app.media.Swiper1'),()=>{EPG()}),
      new buttomItem('DVR',$r('app.media.Swiper1'),()=>{DVR()}),
  ]
  onTabChanged() {
    if (this.currentTabIndex === 2) {   // 0 对应 EPG 页签
      ;              // 相当于 onPageShow
    }
  }
  build() {
    Column() {
      Refresh({refreshing:this.isRefreshing}){
        Column(){
          Row(){
            Swiper(){
              ForEach(this.swiperList,(item:swiperItem) => {
                Image(item.image).onClick(item.click)
              })
            }.loop( true).duration(5000).borderRadius(10).autoPlay( true).interval(30*1000).width('100%')

          }.margin({top: 10})
          Row(){

          }

        }.width("95%")


      }.onRefreshing(() => {})
    }.width("100%").justifyContent(FlexAlign.Start).height('100%')
  }
}