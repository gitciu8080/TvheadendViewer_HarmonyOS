import {Settings} from '../../model/InterFace'
import { router } from '@kit.ArkUI';
import { TextSystem } from '../../view/style';

@Entry
@Component
export struct setting{
  @Consume @Watch('onTabChanged') currentTabIndex: number;

  // 2. 真正的回调，名字任意，只要和 @Watch 里写的一样
  onTabChanged() {
    if (this.currentTabIndex === 4) {   // 0 对应 EPG 页签
                   // 相当于 onPageShow
    }
  }
  private settinglist:Array<object>=[
    new Settings('TVH设置', $r('app.media.ic_public_settings'), 'TVHSConfig'),
    new Settings('关于我', $r('app.media.ic_public_detail'), 'ForwardME'),
    // new Settings('未来更新计划', $r('app.media.ic_public_detail'), 'UpdateInFuture'),
    // ,
    // new Settings("播放器设置", $r('app.media.ic_public_settings'), 'IJKConfig')

  ]
  build() {
    Column(){
      Row(){
        TextSystem({text:$r('app.string.EPG'),level:1,bold:FontWeight.Bold,txtalign:TextAlign.Center}).margin({top:5,bottom:5}).width('100%')
      }.backgroundColor($r('app.color.white'))
      Row(){
        Image($r('app.media.tvh')).width('20%')
        Text('TvHeadEnd').fontSize(30).fontWeight(FontWeight.Bold).fontColor($r('app.color.black')).textAlign(TextAlign.End).width('80%')

      }.backgroundColor($r('app.color.white')).padding({left:12,right:12,top:12,bottom:12}).margin({top:12,bottom:24}).borderRadius(15).width("95%")
      List(){
        ForEach(this.settinglist, (item:Settings)=>{
          ListItem() {
            Column() {
              Row(){
                Image(item.icon).height('80px').fillColor($r('app.color.black')).margin({top:12,bottom:12})
                Text(item.name).fontSize(16).fontWeight(FontWeight.Medium).fontColor($r('app.color.black')).textAlign(TextAlign.End)
              }.backgroundColor($r('app.color.white')).justifyContent(FlexAlign.SpaceBetween).borderRadius(15).width("100%").padding({left:12,right:12}).onClick(()=>{
                router.pushUrl({url:`pages/${item.page}`})
              })
            }.width("100%").justifyContent(FlexAlign.Center)
          }.margin({bottom:5})
        })
      }.width("95%")
      // CustomDialogUser({eventId:1234,title:'epgItem.title',Manual_Rec:this.qidai,Book:this.qidai})
    }.height('100%').width('100%')
  }
}