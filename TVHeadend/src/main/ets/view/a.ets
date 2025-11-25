import { LengthMetrics, LengthUnit, promptAction } from '@kit.ArkUI';
import "../view/style"
import "../tools/ButtomBuilder"
import { BtnBuilderCancel, BtnBuilderNormal } from '../tools/ButtomBuilder';
import { TitleStyle,TextSystem } from '../view/style';

@CustomDialog
struct AutoRecDialogTeo {
  controllerTwo?: CustomDialogController;
  @State message: string = "I'm the second dialog box.";
  @State showIf: boolean = false;



  build() {
    Column() {
      if (this.showIf) {
        Text('text')
          .fontSize(30)
          .height(100)
      }
      Text(this.message)
        .fontSize(30)
        .height(100)
      Button("Create Text")
        .onClick(() => {
          this.showIf = true;
        })
      Button('Close Second Dialog Box')
        .onClick(() => {
          if (this.controllerTwo != undefined) {
            this.controllerTwo.close();
          }
        })
        .margin(20)
    }
  }
}

@CustomDialog
struct AutoRecDialog {
  @State selectedOption: boolean= false;
  openSecondBox?: () => void
  controller?: CustomDialogController
  async AutoRec(){

    promptAction.showToast({ message: 'AutoRec' });
    await this.controller!.close()
  }
  @Builder
  diaSelectBuilder(Accept: () => void){
    Row(){
      BtnBuilderCancel({text:$r("app.string.no"), click: () => {this.controller!.close();},layoutweight:true})
      Text('|').fontColor($r('app.color.gray')).margin(10)
      BtnBuilderNormal({text:$r("app.string.yes"), click: () => {Accept()},layoutweight:true})
    }.width('100%').justifyContent(FlexAlign.SpaceBetween).padding({left: 15, right: 15,bottom: 15})
  }

  build() {
    Column() {
      TextSystem({text:$r("app.string.ChooseRecMode"),txtalign:TextAlign.Center,bold:FontWeight.Bold,level:0})
      List(){
        ListItem(){
          Row(){
            Radio({ value: 'AutoRec', group: 'radioGroup' }).checked(this.selectedOption===false).onChange(()=>{this.selectedOption=false})
              .radioStyle({
                checkedBackgroundColor:$r('app.color.primary_main')
              }).height('30vp').margin({right:10})
            Column(){

              TextSystem({text:$r('app.string.AutoRec'),level:2})
              TextSystem({text:$r('app.string.AutoRecDetailed'),level:3})
            }.justifyContent(FlexAlign.Start)
          }.width('100%')
          // Button({type: ButtonType.Capsule}){
          //
          // }.buttonStyle(ButtonStyleMode.NORMAL)
        }.selected(this.selectedOption=== false).margin(5).border({radius:30}).padding(10)
        // .onSelect(() => {this.selectedOption='AutoRec'})
        ListItem(){
          Row(){
            Radio({ value: 'AdvancedRec', group: 'radioGroup'}).checked(this.selectedOption===true).onChange(()=>{this.selectedOption=true})
              .radioStyle({
                checkedBackgroundColor:$r('app.color.primary_main')
              }).height('30vp').margin({right:10})

            Column(){
              TextSystem({text:$r('app.string.AdvancedRec'),level:2})
              TextSystem({text:$r('app.string.AdvancedRecDetailed'),level:3})
            }.justifyContent(FlexAlign.Start)
          }.width('100%')
          // Button({type: ButtonType.Capsule}){}.buttonStyle(ButtonStyleMode.NORMAL)
        }.selected(this.selectedOption=== true).margin(5).border({radius:30}).padding(10)
        // .onSelect(() => {this.selectedOption='AdvancedRec'})
      }.width('95%').alignListItem(ListItemAlign.Center).margin({bottom: 10})
      if (this.selectedOption){
        this.diaSelectBuilder(this.openSecondBox!)
      }else {
        this.diaSelectBuilder(()=>{this.AutoRec ()})
      }
    }.borderRadius(10)
  }
}

/**
 * 自定义对话框用户界面组件
 * 管理两个自定义对话框的显示和交互
 */
@Entry
@Component
struct CustomDialogUser {
  @State inputValue: string = 'Click Me';
  @State DiaTwoValue:boolean = false;
  @State AdvRecMode:boolean=true;
  /**
   * 第一个对话框控制器
   * 配置并管理AutoRecDialog对话框的行为和显示
   */
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: AutoRecDialog({
      openSecondBox: () => {
        if (this.dialogControllerTwo != null) {
          this.dialogControllerTwo.open()
        }
      }
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
    builder: AutoRecDialogTeo(),
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
    Column() {
      BtnBuilderNormal({text:this.inputValue, click: () => {this.dialogController?.open() }})
    }.width('100%').margin({ top: 5 })
  }
}