import {get_dvr,get_DVR_profile,DvrConfigGridResponse,DvrProfile} from '../../tools/get_DVR'
import {DvrListItem,DVRtab} from '../../model/InterFace'
import {TitleStyle} from "../../view/style"
import {DVRBtnBuilder} from "../../tools/ButtomBuilder"
import { readPreferences } from '../../tools/get_epg';
import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';

@Entry
@Component

export struct DVR{

  @State isRefreshing: boolean = false;
  @State DVR:Array<object>=[];
  @State DVR_upcoming:Array<object>=[];
  @State DVR_failed:Array<object>=[];
  @State DVR_removed:Array<object>=[];
  @State currentIndex:number=0;
  @State currentDVRTabIndex:number=0;
  @State DvrProfile:DvrProfile[]=[];
  @Consume @Watch('onTabChanged') currentTabIndex: number;
  private async  copyLink(url:string,title:string): Promise<void>{
    try {
      const link=await readPreferences('tvheadend_config',`play/ticket/${url}?title=${title}`)
      const pb = pasteboard.getSystemPasteboard();
      const data = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, link);
      await pb.setData(data);
      promptAction.showToast({ message: '已复制到剪贴板', duration: 1500 });
    }catch (e){
      promptAction.showToast({ message: '失败', duration: 1500 });
    }
  }
  // 2. 真正的回调，名字任意，只要和 @Watch 里写的一样
  onTabChanged() {
    if (this.currentTabIndex === 1) {   // 0 对应 EPG 页签
      this.loadDVR();              // 相当于 onPageShow
    }
  }
  private async loadDVR(){
    try {
      const dvrList_finished = await get_dvr('_finished');
      this.DVR=dvrList_finished;
      const dvrList_upcoming = await get_dvr('_upcoming');
      this.DVR_upcoming=dvrList_upcoming;
      const dvrList_failed = await get_dvr('_failed');
      this.DVR_failed=dvrList_failed;
      const dvrList_removed = await get_dvr('_removed');
      this.DVR_removed=dvrList_removed;
      const dvrProfile=await get_DVR_profile()
      this.DvrProfile=dvrProfile
    }catch ( error){
      console.error('获取DVR列表失败:', error);
    }
  }

  async  qidai(){
    this.getUIContext().showAlertDialog({
      title:'正在开发，敬请期待',
      message: '正在开发，敬请期待'
    })
  }

  async RefreshDVR(mode:number){
    this.isRefreshing=true;
    this.loadDVR();
    console.info(`刷新成功${mode}`)
    this.isRefreshing=false;
  }
  @Builder channel_bar(text:string,index:number){
    Column(){
      Row(){Text(text).fontSize(19).fontColor(this.currentDVRTabIndex===index ? $r('app.color.grayact') : $r('app.color.gray')).margin({left:10,right:10,top:5,bottom:5}).align(Alignment.Center)}.width('100%').justifyContent(FlexAlign.Center)

    }.backgroundColor(this.currentDVRTabIndex===index ? $r('app.color.primary_main') : Color.Transparent).borderRadius(99).animation({ duration: 200})
  }
  @Builder DVRBuilder(copy:boolean,mode:number){
    Refresh({refreshing:this.isRefreshing}){
      List(){
        if (mode===0){
          ForEach(this.DVR, (item:DvrListItem)=>{
            ListItem() {
              Column() {
                Column(){
                  Row(){}
                  Row(){if (item.title.chi===''){TitleStyle({text:'',level:5})}else {TitleStyle({text:item.title.chi,level:5})}}.width('100%')
                  Row(){if (item.title.eng===''){TitleStyle({text:'',level:5})}else {TitleStyle({text:item.title.eng,level:5})}}.width('100%')
                  // Row(){if (item.subtitle.eng===''){TitleStyle({text:'',level:5})}else {TitleStyle({text:item.subtitle.eng,level:5})}}.width('100%')
                  Row(){TitleStyle({text:item.disp_extratext,level:3})}.width('100%')
                  Row(){
                    if (copy===true) {
                      DVRBtnBuilder({copy_click:()=>this.copyLink(item.url,item.title.chi)})
                    }else {}
                  }.width('100%').margin({top:5}).justifyContent(FlexAlign.SpaceBetween)
                }.width('95%').padding(10)
              }.width('100%').justifyContent(FlexAlign.Center).padding({top:5}).backgroundColor($r('app.color.white')).borderRadius(10)

            }.margin({top:5,bottom:5}).width('100%').padding({left:12,right:12})
          })
        }else if (mode===1){
          ForEach(this.DVR_upcoming, (item:DvrListItem)=>{
            ListItem() {
              Column() {
                Column(){
                  Row(){}
                  Row(){if (item.title.chi===''){TitleStyle({text:'',level:5})}else {TitleStyle({text:item.title.chi,level:5})}}.width('100%')
                  Row(){if (item.title.eng===''){TitleStyle({text:'',level:5})}else {TitleStyle({text:item.title.eng,level:5})}}.width('100%')
                  // Row(){if (item.subtitle.eng===''){TitleStyle({text:'',level:5})}else {TitleStyle({text:item.subtitle.eng,level:5})}}.width('100%')
                  Row(){TitleStyle({text:item.disp_extratext,level:3})}.width('100%')
                  Row(){
                    if (copy===true) {
                      DVRBtnBuilder({copy_click:()=>this.copyLink(item.url,item.title.chi)})
                    }else {}
                  }.width('100%').margin({top:5}).justifyContent(FlexAlign.SpaceBetween)
                }.width('95%').padding(10)
              }.width('100%').justifyContent(FlexAlign.Center).padding({top:5}).backgroundColor($r('app.color.white')).borderRadius(10)

            }.margin({top:5,bottom:5}).width('100%').padding({left:12,right:12})
          })
        }else if (mode===2){
          ForEach(this.DVR_failed, (item:DvrListItem)=>{
            ListItem() {
              Column() {
                Column(){
                  Row(){}
                  Row(){if (item.title.chi===''){TitleStyle({text:'',level:5})}else {TitleStyle({text:item.title.chi,level:5})}}.width('100%')
                  Row(){if (item.title.eng===''){TitleStyle({text:'',level:5})}else {TitleStyle({text:item.title.eng,level:5})}}.width('100%')
                  // Row(){if (item.subtitle.eng===''){TitleStyle({text:'',level:5})}else {TitleStyle({text:item.subtitle.eng,level:5})}}.width('100%')
                  Row(){TitleStyle({text:item.disp_extratext,level:3})}.width('100%')
                  Row(){
                    if (copy===true) {
                      DVRBtnBuilder({copy_click:()=>this.copyLink(item.url,item.title.chi)})
                    }else {}
                  }.width('100%').margin({top:5}).justifyContent(FlexAlign.SpaceBetween)
                }.width('95%').padding(10)
              }.width('100%').justifyContent(FlexAlign.Center).padding({top:5}).backgroundColor($r('app.color.white')).borderRadius(10)

            }.margin({top:5,bottom:5}).width('100%').padding({left:12,right:12})
          })
        }else if (mode===3){
          ForEach(this.DVR_removed, (item:DvrListItem)=>{
            ListItem() {
              Column() {
                Column(){
                  Row(){}
                  Row(){if (item.title.chi===''){TitleStyle({text:'',level:5})}else {TitleStyle({text:item.title.chi,level:5})}}.width('100%')
                  Row(){if (item.title.eng===''){TitleStyle({text:'',level:5})}else {TitleStyle({text:item.title.eng,level:5})}}.width('100%')
                  // Row(){if (item.subtitle.eng===''){TitleStyle({text:'',level:5})}else {TitleStyle({text:item.subtitle.eng,level:5})}}.width('100%')
                  Row(){TitleStyle({text:item.disp_extratext,level:3})}.width('100%')
                  Row(){
                    if (copy===true) {
                      DVRBtnBuilder({copy_click:()=>this.copyLink(item.url,item.title.chi)})
                    }else {}
                  }.width('100%').margin({top:5}).justifyContent(FlexAlign.SpaceBetween)
                }.width('95%').padding(10)
              }.width('100%').justifyContent(FlexAlign.Center).padding({top:5}).backgroundColor($r('app.color.white')).borderRadius(10)

            }.margin({top:5,bottom:5}).width('100%').padding({left:12,right:12})
          })
        }
      }.sticky(StickyStyle.Header)
    }.onRefreshing(()=>{this.RefreshDVR(mode)})
  }
  build() {
    Column(){
      Tabs({ barPosition: BarPosition.Start }){
        TabContent(){
          this.DVRBuilder(true,0)
        }.tabBar(this.channel_bar('完成',0))
        TabContent(){
          this.DVRBuilder(false,1)
        }.tabBar(this.channel_bar('预约',1))
        TabContent(){
          this.DVRBuilder(false,2)
        }.tabBar(this.channel_bar('错误',2))
        TabContent(){
          this.DVRBuilder(false,3)
        }.tabBar(this.channel_bar('已删除',3))
      }.onChange((idx: number) => this.currentDVRTabIndex = idx)

    }.justifyContent(FlexAlign.Center)
  }
}