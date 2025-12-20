import {Channels,EpgGroup} from '../../model/InterFace'
import { getChannel, getEPG,EpgEvent} from '../../tools/get_epg';
import {CustomDialogUser}from "../../view/AutoRecDialogExport"
import { TextSystem, TitleStyle} from "../../view/style"
import {Rec_TV}from "../../tools/buttom_Action"
import { Loading } from '../../view/Loading';
import router from '@ohos.router';

const EMPTY_EPG: EpgGroup[] = [
  {
    // 当天日期，格式保持与你接口一致：yyyy-MM-dd
    date: new Date().toISOString().slice(0, 10),
    EpgEvent: [
      {
        event_id: 0,
        id: 'empty',
        title: '暂无节目信息',
        start: Math.floor(Date.now() / 1000),
        stop:  Math.floor(Date.now() / 1000) + 3600,
        summary: '服务器未返回任何节目数据',
        progress: 0,
        PG: false,
        Multi_language: false
      }
    ]
  }
];
@Component
export struct EPG{
  @State channels: Array<Channels> = [];
  @State epgMap: Map<string, Array<EpgGroup>> = new Map();
  @State selectedChannelKey: string = '';
  @State currentIndex: number = 0;
  @State isRefreshing: boolean = false;
  @State AutoRefreshing:boolean=false;
  @State tvindex:number=0;
  @State private lastTab: number = -1;
  private async loadChannels(): Promise<void> {
    try {
      const channelList = await getChannel('tvheadend_config');
      this.channels = channelList;

      // 初始化时加载第一个频道的 EPG 数据
      if (channelList.length > 0) {
        this.selectedChannelKey = channelList[0].key;
        this.loadEPGForChannel(channelList[0].key);
      }
    } catch (error) {
      console.error('获取频道列表失败:', error);
    }
  }

  private async loadEPGForChannel(channelKey: string): Promise<void> {
    // 如果该频道的 EPG 数据已经加载过，则不再重复加载
    if (this.epgMap.has(channelKey)) {
      return;
    }

    try {
      const epgList:EpgGroup[] = await getEPG('tvheadend_config', channelKey);
      this.epgMap.set(channelKey, epgList.length ? epgList : EMPTY_EPG);
    } catch (error) {
      console.error(`获取频道 ${channelKey} 的 EPG 数据失败:`, error);
    }
  }

  async onRefresh(channelkey:string){
    this.isRefreshing=true;
    this.epgMap.clear()
    this.loadEPGForChannel(channelkey);
    console.info('刷新成功')
    this.isRefreshing=false;
  }

  async RefreshEPG(){
    const channelKey = await getChannel('tvheadend_config');
    this.isRefreshing=true;
    this.epgMap.clear()
    const epgList:EpgGroup[] = await getEPG('tvheadend_config', channelKey[0].key);
    this.epgMap.set(channelKey[0].key, epgList);
    console.info('刷新成功')
    this.isRefreshing=false;
  }

  async  qidai(){
    this.getUIContext().showAlertDialog({
      title:'正在开发，敬请期待',
      message: '正在开发，敬请期待'
    })
  }

  aboutToAppear() {
    this.loadChannels();
  }

  private formatTime(ts: number): string {
    let date = new Date(ts * 1000);
    return `${date.getHours()}:${date.getMinutes().toString().padStart(2, '0')}`;
  }

  @Builder channel_bar(text:string,index:number){
    Column(){
      Text(text).fontSize(19).fontColor(this.currentIndex===index ? $r('app.color.grayact') : $r('app.color.gray')).margin({left:10,right:10,top:5,bottom:5})
    }.backgroundColor(this.currentIndex===index ? $r('app.color.primary_main') : Color.Transparent).borderRadius(99).animation({ duration: 200})
  }
  @Builder itemHead(text:string){
    Column(){
      Text(text).fontWeight(FontWeight.Bold).fontColor(Color.White).width('95%').textAlign(TextAlign.Center).backgroundColor($r('app.color.primary_main')).borderRadius(5).padding({top:5,bottom:5})
    }.width('100%').justifyContent(FlexAlign.Center).margin({bottom:5})
  }
  @Consume @Watch('onTabChanged') currentTabIndex: number;

  // 2. 真正的回调，名字任意，只要和 @Watch 里写的一样
  onTabChanged() {
    if (this.currentTabIndex === 0) {   // 0 对应 EPG 页签
      this.loadChannels();              // 相当于 onPageShow
    }
  }

  build() {
    Column(){
      Row(){
        TextSystem({text:$r('app.string.EPG'),level:1,bold:FontWeight.Bold,txtalign:TextAlign.Center}).margin({top:5,bottom:5}).width('100%')
      }.backgroundColor($r('app.color.white'))
      if (this.channels.length > 0){
        Column() {
          Tabs({ barPosition: BarPosition.Start, index: this.currentIndex }) {
            ForEach(this.channels, (channel: Channels, index: number) => {
              TabContent() {
                Refresh({refreshing:this.isRefreshing})
                {
                  List() {
                    ForEach(this.epgMap.get(channel.key) || [], (epgGroup: EpgGroup) => {
                      ListItemGroup({ header: this.itemHead(epgGroup.date)}){
                        ForEach(epgGroup.EpgEvent, (epgItem: EpgEvent) => {
                          ListItem() {
                            Column() {
                              Row(){TitleStyle({text:epgItem.title,level:1})
                                if (epgItem.Multi_language===true && epgItem.PG===true) {
                                  TitleStyle({text:$r('app.string.Multilingual_PG'),level:4})
                                }else if (epgItem.Multi_language===true){
                                  TitleStyle({text:$r('app.string.Multilingual'),level:4})
                                }if (epgItem.PG===true){
                                  TitleStyle({text:$r('app.string.PG'),level:4})
                                }
                                else {
                                  Text('')
                                }
                              }.width('100%')
                              TitleStyle({text:(`${this.formatTime(epgItem.start)} - ${this.formatTime(epgItem.stop)}`),level:3})
                              TitleStyle({text:epgItem.summary,level:3})
                              if (epgItem.progress===0) {
                                TitleStyle({text:$r('app.string.Not_started'),level:2})
                              }else {
                                Progress({value: epgItem.progress,total: 100,type:ProgressType.Linear}).margin({top:5}).color($r('app.color.primary_main'))
                              }
                              // EPGBtnBuilder({eventId:epgItem.event_id,title:epgItem.title,Manual_Rec:async () => {Rec_TV(epgItem.event_id,epgItem.title)},Book:this.qidai})
                              if (epgItem.title==='暂无节目信息') {

                              }else {
                                CustomDialogUser({eventId:epgItem.event_id,title:epgItem.title,Manual_Rec:async () => {Rec_TV(epgItem.event_id,epgItem.title)}})
                              }
                            }
                            .padding(12)
                            .justifyContent(FlexAlign.Center)
                            .backgroundColor($r('app.color.text_hint'))
                            .borderRadius(10)
                            .margin({top:5})
                            .width('95%');
                          }.onClick(()=>{
                            if (epgItem.title!=='暂无节目信息') {
                              router.pushUrl({url:"pages/indexpage/EPGD",params:{title:epgItem.title,start:epgItem.start,stop:epgItem.stop,event_id:epgItem.event_id,summary:epgItem.summary}})
                            }else {} }).width('100%').margin({top:5,bottom:5})})
                      }

                    })
                  }.sticky(StickyStyle.Header).width('100%').layoutWeight(1).backgroundColor($r('app.color.background_sec')).borderRadius(10)
                  .onScrollIndex((start: number, end: number) => {
                    // 可以在这里实现滚动加载更多数据的逻辑
                  })
                  .onDidScroll(() => {
                    // 滚动时可以加载更多数据
                  })
                }.onRefreshing(() =>{
                  this.onRefresh(this.channels[index].key);
                })
              }
              // .onClick(()=>{this.IndexClick= index})
              .backgroundColor($r('app.color.background_sec'))
              .tabBar(this.channel_bar(channel.val,index))


            }, (channel: Channels) => channel.key)
          }
          .animationMode(AnimationMode.CONTENT_FIRST_WITH_JUMP)
          .backgroundColor($r("app.color.white"))
          .pageFlipMode(PageFlipMode.SINGLE)
          .width('100%')
          .barMode(BarMode.Scrollable)
          .onChange((index: number) => {
            if (index < this.channels.length) {
              this.currentIndex = index;
              this.tvindex=index
              const channelKey = this.channels[index].key;
              this.selectedChannelKey = channelKey;
              // 当切换标签页时，加载对应频道的 EPG 数据
              this.loadEPGForChannel(channelKey);
            }
          })
        }
        .layoutWeight(1)
      }else {
        Loading({countdown:5})
      }

    }
  }
}