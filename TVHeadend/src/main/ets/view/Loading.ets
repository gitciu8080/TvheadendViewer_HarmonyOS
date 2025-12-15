import { TextSystem, TitleStyle } from "./style"


@Component
export struct Loading{
  @Prop countdown?: number = 0;
  @State remainingTime: number = 0;
  @State showTimeoutMessage: boolean = false;
  
  aboutToAppear(): void {
    if (this.countdown && this.countdown > 0) {
      this.remainingTime = this.countdown;
      this.startCountdown();
    }
  }
  
  startCountdown(): void {
    if (this.remainingTime > 0) {
      setTimeout(() => {
        this.remainingTime--;
        this.startCountdown();
      }, 1000);
    } else {
      // 倒计时结束，显示超时消息
      this.showTimeoutMessage = true;
    }
  }

  build() {
    Column(){
      LoadingProgress().color($r('app.color.primary_main')).size({width:150,height:150})
      TextSystem({text:"...Loading",txtalign:TextAlign.Center})
      

      // 倒计时结束后显示超时消息
      if (this.showTimeoutMessage) {
        TextSystem({
          text:"可能是服务器无响应或者是配置文件错误",
          txtalign: TextAlign.Center
        })
        .margin({ top: 20 })
      }

    }.width('100%').height('100%').justifyContent(FlexAlign.Center)
  }
}