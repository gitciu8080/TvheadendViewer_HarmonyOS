import { DVRBtnBuilder } from "../../tools/ButtomBuilder";
import { getChannel, readPreferences } from "../../tools/get_epg";
import { TitleStyle } from "../../view/style";
import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';

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
  private async  copyLink(url:string,title:string): Promise<void>{
    try {
      const link=await readPreferences('tvheadend_config',`play/ticket/stream/channel/${url}?title=${title}`)
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
                  DVRBtnBuilder({copy_click:()=>this.copyLink(item.key,item.val)})
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
      this.ChannelListItem()
    }
  }
}