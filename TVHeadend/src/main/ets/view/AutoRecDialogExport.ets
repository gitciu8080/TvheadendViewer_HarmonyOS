import {SimpleDialog,AdvancedDialog} from "./AutoRecDialog"
import { LengthMetrics, LengthUnit, promptAction } from '@kit.ArkUI';
import { BtnBuilderCancel, BtnBuilderNormal,EPGBtnBuilder } from '../tools/ButtomBuilder';

@Component
export struct CustomDialogUser {
  @State inputValue: string = 'Click Me';
  @State DiaTwoValue:boolean = false;
  @State AdvRecMode:boolean=true;
  eventId:number=0;
  title:string='';
  Auto_Rec:() => void = () => {};
  Manual_Rec:() => void = () => {};
  Book:() => void = () => {};
  /**
   * 第一个对话框控制器
   * 配置并管理AutoRecDialog对话框的行为和显示
   */
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: SimpleDialog({
      openSecondBox: () => {
        if (this.dialogControllerTwo != null) {
          this.dialogControllerTwo.open()
        }
      },title:this.title,eventId:this.eventId
    }),
    cancel: this.exitApp,
    autoCancel: false,
    alignment:DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    keyboardAvoidMode: KeyboardAvoidMode.DEFAULT,
    keyboardAvoidDistance:LengthMetrics.vp(10),
    customStyle: false
  });

  /**
   * 第二个对话框控制器
   * 配置并管理AutoRecDialogTeo对话框的行为和显示
   */
  dialogControllerTwo: CustomDialogController | null = new CustomDialogController({
    builder: AdvancedDialog({onCloseAll:()=>{this.dialogController?.close();this.dialogControllerTwo?.close()},title:this.title,eventId:this.eventId}),
    alignment:DialogAlignment.Center,
    keyboardAvoidMode: KeyboardAvoidMode.DEFAULT,
    keyboardAvoidDistance: LengthMetrics.vp(10),
    offset: { dx: 0, dy: -25 }
  });

  /**
   * 组件销毁时的回调函数
   * 释放对话框控制器资源
   */
  aboutToDisappear() {
    this.dialogController = null;
    this.dialogControllerTwo = null;
  }

  /**
   * 取消按钮点击回调函数
   * 记录第一个按钮被点击的信息
   */
  onCancel() {
    console.info('Callback when the first button is clicked');
  }

  /**
   * 确认按钮点击回调函数
   * 记录第二个按钮被点击的信息
   */
  onAccept() {
    console.info('Callback when the second button is clicked');
  }

  /**
   * 空白区域点击回调函数
   * 记录用户点击对话框外部空白区域的信息
   */
  exitApp() {
    console.info('Click the callback in the blank area');
  }

  build() {
    Row() {
      EPGBtnBuilder({Auto_Rec:async ()=>{this.dialogController?.open()},Manual_Rec:this.Manual_Rec,Book:this.Book})
    }
      // BtnBuilderNormal({text:$r('app.string.AutoRec'), click: () => {this.dialogController?.open() }})}
  }
}