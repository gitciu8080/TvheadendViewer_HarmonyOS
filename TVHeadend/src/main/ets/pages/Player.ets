// import { router } from '@kit.ArkUI';
// import { media } from '@kit.MediaKit';
// import { BusinessError } from '@kit.BasicServicesKit';
// import { common, Want } from '@kit.AbilityKit';
// import bundleManager from '@ohos.bundle.bundleManager';
// import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
//
// @Entry
// @Component
// struct Player {
//   @State url:string=''
//   @State isPlaying:boolean=false
//   private avPlayer: media.AVPlayer | null = null;
//   async avSetupURL(){
//     this.avPlayer = await media.createAVPlayer();
//     if (this.avPlayer=== null){
//       return
//     }
//     this.avPlayer.url=this.url
//   }
//
//   aboutToAppear(): void {
//     const params =router.getParams() as Record<string, Object>;
//     this.url=params?.['url'] as string || ''
//
//   }
//   build() {
//
//   }
//
//   // 跳转到指定包名的应用
//   jumpToApp(bundleName: string) {
//     try {
//       // 创建Want对象，指定目标应用的BundleName
//       let want: Want = {
//         bundleName: bundleName,
//       };
//
//       // 启动目标应用
//       common.UIAbility.startAbility(want).then(() => {
//         console.log('Successfully jumped to app: ' + bundleName);
//       }).catch((err: BusinessError) => {
//         console.error('Failed to jump to app: ' + bundleName + ', error: ' + err);
//       });
//     } catch (error) {
//       console.error('Exception occurred while jumping to app: ' + bundleName + ', error: ' + error);
//     }
//   }
//
//   // 跳转到com.aloereed.aloeplayer应用的专门方法
//   jumpToAloePlayer() {
//     this.jumpToApp('com.aloereed.aloeplayer');
//   }
//
// }