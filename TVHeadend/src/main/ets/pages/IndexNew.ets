// import { promptAction } from '@kit.ArkUI'
// import {EPGPage} from './EPGPage'
//
// @Entry
// @Component
// struct MainPage{
//   private async click(text:Resource){
//     promptAction.showToast({message:text})
//   }
//   @Provide('pageStack') pageStack:NavPathStack=new NavPathStack()
//   build() {
//     Navigation(this.pageStack){
//       Column(){
//           NavDestination(){EPGPage()}
//       }
//     }.mode(NavigationMode.Stack)
//     .toolbarConfiguration([
//       {value:$r('app.string.EPG'),icon:$r('app.media.epg'),action:()=>{this.click($r('app.string.EPG'))}},
//       {value:$r('app.string.DVR'),icon:$r('app.media.dvr'),action:()=>{this.click($r('app.string.DVR'))}},
//       {value:$r('app.string.setting'),icon:$r('app.media.ic_public_settings'),action:()=>{this.click($r('app.string.setting'))}}
//     ])
//   }
// }