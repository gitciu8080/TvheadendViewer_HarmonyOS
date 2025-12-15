import { TextSystem } from "../view/style"

import window from '@ohos.window';

@Entry
@Component
export struct ForwardME {
  @State statusBarHeight: number = 0;

  build() {
    Column(){
      Image($r("app.media.touxiang")).borderRadius(9999).height(150).width(150).margin({top:10,bottom:10}).borderColor($r("app.color.white")).borderWidth(5)
      TextSystem({text: $r("app.string.forwardME"),level:1,txtalign:TextAlign.Center}).margin({top:10,bottom:10})
      Column(){
        TextSystem({text: "我是一位大学生，我在家里自己搭建了一个TVHeadend的服务器来接收来自香港的无线电视频道节目，我在2023年换了HUAWEI MATE 60 Pro更新到鸿蒙系统后我发现登录到后台是真的很麻烦，所以我自己学习了ArkTS制作了这个软件，我是个门外汉我对ArkTS开发也是半斤八两，希望能获得大家的喜欢。",level:2,txtalign:TextAlign.Start}).width('95%').margin(15)
      }.backgroundColor($r("app.color.white")).borderRadius(10).width('95%')

    }
    .width('100%')
    .backgroundColor($r("app.color.background_sec"))
    .height('100%')
    .padding({ top: this.statusBarHeight })
  }
  onPageHide(): void {
    try {
      // 使用异步方式获取当前窗口
      window.getLastWindow(getContext(this)).then((win) => {

        win.setWindowLayoutFullScreen(false).then(() => {
          // 恢复状态栏和导航栏
          win.setWindowSystemBarEnable(['status', 'navigation']).then(() => {
            // 恢复状态栏和导航栏背景
            const systemBarProperties: window.SystemBarProperties = {
              statusBarColor: '#00000000',
              navigationBarColor: '#00000000'
            };
            win.setWindowSystemBarProperties(systemBarProperties).then()
          })
        })
      })
    }
    catch (error){
      console.error('Exception occurred while getting last window: ' + JSON.stringify(error));
    }
  }
  // 页面显示时设置状态栏和导航栏透明，并获取状态栏高度
  onPageShow() {
    try {
      // 使用异步方式获取当前窗口
      window.getLastWindow(getContext(this)).then((win) => {
        // 获取状态栏高度
        const avoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        this.statusBarHeight = avoidArea.topRect.height;
        
        // 设置窗口全屏布局
        win.setWindowLayoutFullScreen(true).then(() => {
          // 启用状态栏和导航栏
          win.setWindowSystemBarEnable(['status', 'navigation']).then(() => {
            // 设置状态栏和导航栏背景为透明
            const systemBarProperties: window.SystemBarProperties = {
              statusBarColor: '#00000000',
              navigationBarColor: '#00000000'
            };
            
            win.setWindowSystemBarProperties(systemBarProperties).then(() => {
              console.info('Successfully set status bar and navigation bar to transparent');
            }).catch((propsErr: Error) => {
              console.error('Failed to set system bar properties, error: ' + JSON.stringify(propsErr));
            });
          }).catch((enableErr: Error) => {
            console.error('Failed to enable system bar, error: ' + JSON.stringify(enableErr));
          });
        }).catch((layoutErr: Error) => {
          console.error('Failed to set window layout full screen, error: ' + JSON.stringify(layoutErr));
        });
      }).catch((err: Error) => {
        console.error('Failed to get last window, error: ' + JSON.stringify(err));
      });
    } catch (error) {
      console.error('Exception occurred while setting system bar properties: ' + JSON.stringify(error));
    }
  }
}