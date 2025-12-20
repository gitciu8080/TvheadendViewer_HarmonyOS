import router from '@ohos.router';
import { CustomDialogUser } from '../../view/AutoRecDialogExport';
import { TextSystem } from '../../view/style';
import {Rec_TV}from "../../tools/buttom_Action"
import { EPGSearch } from '../../model/InterFace';
import common from '@ohos.app.ability.common';
import { Want } from '@kit.AbilityKit';
import { Popup, PopupTextOptions } from '@ohos.arkui.advanced.Popup';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct EPGD {
  title:string='';
  start:number=0;
  stop:number=10;
  event_id:number=0;
  summary:string='';
  private linktollq:Array<object>=[
    new EPGSearch('IMDB',$r('app.media.IMDB'),'https://www.imdb.com/find?q='),
    new EPGSearch('TVDB',$r('app.media.TVDB'),'https://thetvdb.com/search?query=')
    ,new EPGSearch("Bing",$r('app.media.Bing'),'https://www.bing.com/search?q=')
  ]
  aboutToAppear(): void {
        const params =router.getParams() as Record<string, Object>;
        this.title=params?.['title'] as string || ''
        this.start=params?.['start'] as number || 0
        this.stop=params?.['stop'] as number || 10
        this.event_id=params?.['event_id'] as number || 0
        this.summary=params?.['summary'] as string || ''
      }
  private formatTime(ts: number): string {
    let date = new Date(ts * 1000);
    return `${date.getFullYear()}-${date.getMonth()}-${date.getDay()}  ${date.getHours()}:${date.getMinutes().toString().padStart(2, '0')}`;
  }
  
  // 打开浏览器访问链接
  private openUrl(url: string, searchTerm: string) {
    try {
      // 构造完整的搜索URL
      const fullUrl = url + encodeURIComponent(searchTerm);
      
      // 创建Want对象以启动浏览器
      let want: Want = {
        action: 'ohos.want.action.viewData',
        bundleName: 'com.huawei.hmos.browser',
        abilityName: 'MainAbility',
        uri: fullUrl
      };
      
      // 获取当前上下文并启动Ability
      let context = getContext(this) as common.UIAbilityContext;
      context.startAbility(want).then(() => {
        console.info('Successfully opened URL in browser: ' + fullUrl);
      }).catch((err:BusinessError)=>{
        console.error('Failed to open URL in browser: ' + err.message);
      });
    } catch (error) {
      console.error('Exception occurred while opening URL: ' + error);
    }
  }
  
  @Builder
  DBbuttom(item: EPGSearch) {
    Column() {
      Image(item.icon)
        .margin(10)
        .width(50)
        .borderRadius(10)
      TextSystem({text: item.name, level: 2, bold: FontWeight.Bold, txtalign: TextAlign.Center})
        .margin(10)
    }
    .padding(10)
    .width(100)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      // 点击按钮时打开对应网站并搜索节目标题
      this.openUrl(item.link, this.title);
    })
  }
  
  build() {
    Column(){
      Row(){
        TextSystem({text:"节目信息",level:1,bold:FontWeight.Bold,txtalign:TextAlign.Center}).margin({top:5,bottom:5}).width('100%')
      }.backgroundColor($r('app.color.white'))
      Column(){
        Row(){
          Column(){
            TextSystem({text:`标题:   ${this.title}`,level:2,bold:FontWeight.Bold}).margin(10).layoutWeight(0)
            TextSystem({text:`开始时间:   ${this.formatTime(this.start)}`,level:2,bold:FontWeight.Bold}).margin(10).layoutWeight(0)
            TextSystem({text:`结束时间:   ${this.formatTime(this.stop)}`,level:2,bold:FontWeight.Bold}).margin(10).layoutWeight(0)
          }.padding(10)
        }.backgroundColor($r('app.color.white')).margin(10).borderRadius(15)
        Row(){
          Column(){
            TextSystem({text:"详细",level:1,bold:FontWeight.Bold}).margin(10)
            TextSystem({text:this.summary,level:2,bold:FontWeight.Bold}).margin(10).layoutWeight(0)
          }.padding(10)
        }.backgroundColor($r('app.color.white')).margin(10).borderRadius(15)
        Row(){
          Column(){
            TextSystem({text:"网络快捷搜索",level:1,bold:FontWeight.Bold}).margin(10)
            Row(){ForEach(this.linktollq, (item: EPGSearch) => {
              Button() {
                this.DBbuttom(item)
              }
              .type(ButtonType.Normal)
              .backgroundColor($r('app.color.white'))
              .borderRadius(15)
              .margin({left: 5, right: 5})
            })}
          }.backgroundColor($r('app.color.white')).margin(10).borderRadius(15).width('95%').justifyContent(FlexAlign.SpaceBetween)
          }
      }.layoutWeight(1).backgroundColor($r('app.color.background_sec'))

      CustomDialogUser({eventId:this.event_id,Auto_Rec_Back:true,title:this.title,Manual_Rec:async () => {Rec_TV(this.event_id,this.title);router.back()}}).width("95%")
    }.height('100%')
  }
}