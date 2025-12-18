import { DVRBtnBuilder, TVBtnBuilder } from "../../tools/ButtomBuilder";
import { getChannel, getProfile, readPreferences } from "../../tools/get_epg";
import { TextSystem, TitleStyle } from "../../view/style";
import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';
import { Loading } from "../../view/Loading";
import { preferences } from "@kit.ArkData";
import { router } from "@kit.ArkUI";
import { common, Want } from "@kit.AbilityKit";
import { BusinessError } from "@kit.BasicServicesKit";

interface ChannelListResponse {
  entries: Channel[];
}
interface Channel {
  key: string;   // 频道 UUID
  val: string;   // 频道名称
}
@Entry
@Component

export struct TV{
  @State isRefreshing: boolean = false;
  @Consume @Watch('onTabChanged') currentTabIndex: number;
  @State channelList: Channel[]= [];
  async channel(){
    this.channelList=await getChannel('tvheadend_config')

  }
  jumpToApp(bundleName: string) {
    try {
      // 创建Want对象，指定目标应用的BundleName
      const context=getContext(this) as common.UIAbilityContext
      const store:Want={
        uri:"store://appgallery.huawei.com/app/detail?id=com.aloereed.aloeplayer"
      }
      let want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };

      // 启动目标应用
      context.startAbility(want).then(() => {
        console.log('Successfully jumped to app: ' + bundleName);
      }).catch((err: BusinessError) => {
        context.startAbility(store)
        console.error('Failed to jump to app: ' + bundleName + ', error: ' + err);
      });
    } catch (error) {
      console.error('Exception occurred while jumping to app: ' + bundleName + ', error: ' + error);
    }
  }
  async Link(url:string){
    const profile= await getProfile()
    const link=await readPreferences('tvheadend_config',`play/ticket/stream/channel/${url}?profile=${profile}`)
    return link
  }
  private async  copyLink(url:string,title:string): Promise<void>{

    try {
      const link=await this.Link(url)
      const pb = pasteboard.getSystemPasteboard();
      const data = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, link);
      await pb.setData(data);
      promptAction.showToast({ message: '已复制到剪贴板', duration: 1500 });
    }catch (e){
      promptAction.showToast({ message: '失败', duration: 1500 });
    }
  }
  aboutToAppear(): void {
      this.channel()
  }
  onTabChanged() {
    if (this.currentTabIndex === 3) {   // 0 对应 EPG 页签
      this.channel ()            // 相当于 onPageShow
    }
  }
  @Builder ChannelListItem(){
    Refresh({refreshing:this.isRefreshing}){
      List(){
        ForEach(this.channelList, (item:Channel)=>{
          ListItem() {
            Column() {
              Column(){
                Row(){}
                Row(){TitleStyle({text:item.val,level:5})}.width('100%')
                Row(){
                  TVBtnBuilder({copy_click:()=>this.copyLink(item.key,item.val),play_click: ()=>{this.copyLink(item.key,item.val);this.jumpToApp('com.aloereed.aloeplayer')},del:()=>{}})
                }.width('100%').margin({top:5}).justifyContent(FlexAlign.SpaceBetween)
              }.width('95%').padding(10)
            }.width('100%').justifyContent(FlexAlign.Center).padding({top:5}).backgroundColor($r('app.color.white')).borderRadius(10)

          }.margin({top:5,bottom:5}).width('100%').padding({left:12,right:12})
        })
      }
    }.onRefreshing(()=>{
      this.isRefreshing=true
      this.channel()
      this.isRefreshing=false})
}
  build() {
    Column(){
      Row(){

        TextSystem({text:$r('app.string.EPG'),level:1,bold:FontWeight.Bold,txtalign:TextAlign.Center}).margin({top:5,bottom:5}).width('100%')
      }.backgroundColor($r('app.color.white'))
      if (this.channelList.length>0){
        this.ChannelListItem()
      }else {
        Loading({countdown:5})
      }

    }.height('100%')
  }
}