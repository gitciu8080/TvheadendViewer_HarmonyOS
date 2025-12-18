import { Content, LengthMetrics, LengthUnit, promptAction } from '@kit.ArkUI';
import "../view/style"
import "../tools/ButtomBuilder"
import { BtnBuilderCancel, BtnBuilderNormal } from '../tools/ButtomBuilder';
import { TitleStyle,TextSystem } from '../view/style';
import { Auto_Rec } from '../tools/buttom_Action';

@CustomDialog
export struct AdvancedDialog {
  controllerTwo?: CustomDialogController;
  onCloseAll?: () => void;
  @State message: string = "I'm the second dialog box.";
  @State showIf: boolean = false;
  @State isTitleOn:boolean = false;
  eventId:number=0;
  @State title:string='';


  build() {

    Column(){
      Row(){TextSystem({text:$r('app.string.AdvancedRec'),txtalign:TextAlign.Center,level:1,bold:FontWeight.Bold})}
      Row(){
        TextSystem({text:$r('app.string.title'),level:2,txtalign:TextAlign.Start,fontwidth:Content})
        Row(){TextSystem({text:$r('app.string.FuzzySearch'),level:3,txtalign:TextAlign.End,fontwidth:Content})
          Toggle({
            type: ToggleType.Switch,
            isOn: this.isTitleOn
          })
            .selectedColor($r('app.color.primary_main'))
            .onChange((isOn: boolean) => {
              console.info('isOn: ' + isOn)
            });}
      }.justifyContent(FlexAlign.SpaceBetween).width('100%')
      Row(){
        TextInput({
          placeholder: this.title,
          text: this.title
        })
          .borderRadius(999)
          .onChange((v: string) => {
            this.title=v;
          });
      }

    }.width('95%')
  }
}

@CustomDialog
export struct SimpleDialog {
  @State selectedOption: boolean= false;
  openSecondBox?: () => void
  controller?: CustomDialogController
  eventId:number=0;
  title:string='';
  async AutoRec(){
    Auto_Rec(this.eventId,this.title)
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



        // ListItem(){
        //   Row(){
        //     Radio({ value: 'AdvancedRec', group: 'radioGroup'}).checked(this.selectedOption===true).onChange(()=>{this.selectedOption=true})
        //       .radioStyle({
        //         checkedBackgroundColor:$r('app.color.primary_main')
        //       }).height('30vp').margin({right:10})
        //
        //     Column(){
        //       TextSystem({text:$r('app.string.AdvancedRec'),level:2})
        //       TextSystem({text:$r('app.string.AdvancedRecDetailed'),level:3})
        //     }.justifyContent(FlexAlign.Start)
        //   }.width('100%')
        //   // Button({type: ButtonType.Capsule}){}.buttonStyle(ButtonStyleMode.NORMAL)
        // }.selected(this.selectedOption=== true).margin(5).border({radius:30}).padding(10)




        // .onSelect(() => {this.selectedOption='AdvancedRec'})
      }.width('95%').alignListItem(ListItemAlign.Center).margin({bottom: 10})
      if (this.selectedOption){
        this.diaSelectBuilder(this.openSecondBox!)
      }else {
        this.diaSelectBuilder(()=>{this.AutoRec()})
      }
    }.borderRadius(10)
  }
}



/**
 * 自定义对话框用户界面组件
 * 管理两个自定义对话框的显示和交互
 */
