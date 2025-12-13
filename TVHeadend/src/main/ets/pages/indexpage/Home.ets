import { router } from '@kit.ArkUI';
import { EPG } from "./EPG";
import { DVR } from "./DVR";
import { TextSystem, TitleStyle } from '../../view/style';
import {get_dvr,get_DVR_profile,DvrConfigGridResponse,DvrProfile} from '../../tools/get_DVR'
import {DvrListItem,DVRtab} from '../../model/InterFace'

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

@Component
export struct Home {
  @State isRefreshing: boolean = false;
  @Consume @Watch('onTabChanged') currentTabIndex: number;
  @State DVR:Array<object>=[];
  @State DVR_upcoming:Array<object>=[];
  @State DVR_failed:Array<object>=[];
  @State DVR_removed:Array<object>=[];
  @State DvrProfile:DvrProfile[]=[];
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
  private swiperList:Array<object>=[
      new swiperItem('',$r('app.media.Swiper1'),()=>{router.pushUrl({url:`pages/One_USE`})}),
      new swiperItem('',$r('app.media.Swiper1'),()=>{router.pushUrl({url:`pages/One_USE`})})
  ]

  onTabChanged() {
    if (this.currentTabIndex === 2) {   // 0 对应 EPG 页签
      this.loadDVR();              // 相当于 onPageShow
    }
  }
  aboutToAppear(): void {
    this.loadDVR();
  }
  async RefreshDVR(mode:number){
    this.isRefreshing=true;
    this.loadDVR();
    console.info(`刷新成功${mode}`)
    this.isRefreshing=false;
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

                }.width('95%').padding(10)
              }.width('100%').justifyContent(FlexAlign.Center).padding({top:5}).backgroundColor($r('app.color.white')).borderRadius(10)

            }.margin({top:5,bottom:5}).width('100%').padding({left:12,right:12})
          })
        }
      }.sticky(StickyStyle.Header).padding({top:10}).borderRadius(10)
    }.onRefreshing(()=>{this.RefreshDVR(mode)})
  }
  build() {
    Column() {
      Column() {
        Row() {
          Swiper() {
            ForEach(this.swiperList, (item: swiperItem) => {
              Image(item.image).onClick(item.click)
            })
          }
          .loop(true)
          .duration(5000)
          .borderRadius(10)
          .autoPlay(true)
          .interval(30 * 1000)
          .width('100%')

        }.margin({ top: 0, bottom: 10 })
      }
          Row(){
            Column(){
              TextSystem({text:'已完成的录制列表',level:1,bold:FontWeight.Bold,fontwidth:"90%"}).padding({top:10})
              Row(){
                this.DVRBuilder(true,0)
              }.height(150).margin({top:10,bottom:10})
            }
          }.width("100%").backgroundColor($r('app.color.white')).borderRadius(10)
      Row(){

      }
    }.width("100%").justifyContent(FlexAlign.Start).height('100%')
  }
}