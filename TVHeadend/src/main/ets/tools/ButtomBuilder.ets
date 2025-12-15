import "../view/style"
import { TitleStyle,BtnTitleStyle } from "../view/style";
import {CustomDialogUser} from "../view/AutoRecDialogExport"
@Component
export struct BtnBuilderNormal {
  text = '';
  widthwei:number=50;
  layoutweight:boolean=true;
  click: () => void = () => {};
  build() {
    Button(){BtnTitleStyle({text:this.text,level:3})
      .padding(10)
      // .fontColor($r('app.color.white'))
      }
    .layoutWeight(this.layoutweight ? 1 : 0)


    .buttonStyle(ButtonStyleMode.EMPHASIZED)
    .backgroundColor($r("app.color.primary_main"))
    .onClick(() => {this.click ()})
  }
}
@Component
export struct BtnBuilderCancel {
  text = '';
  widthwei:number=50;
  layoutweight:boolean=true;
  click: () => void = () => {};
  build() {
    Button(){BtnTitleStyle({text:this.text,level:4})
      .padding(10)
      // .fontColor($r('app.color.white'))
    }
    .layoutWeight(this.layoutweight ? 1 : 0)


    .buttonStyle(ButtonStyleMode.NORMAL)
    // .backgroundColor($r("app.color.primary_main"))
    .onClick(() => {this.click ()})
  }
}
@Component
struct DelBtnBuilder{
  // text = '';
  widthwei:number=50;
  layoutweight:boolean=true;
  click: () => void = () => {};

  build() {

    Button(){Text(){SymbolSpan($r('sys.symbol.trash')).fontColor([Color.White]).fontSize(20)}
      .padding(10)
      // .fontColor($r('app.color.white'))
    }
    // .layoutWeight(this.layoutweight ? 1 : 0)
    .width('40vp')


    .buttonStyle(ButtonStyleMode.EMPHASIZED)
    .backgroundColor(Color.Red)
    .onClick(() => {this.click ()})
  }
}
@Component
export struct DVRBtnBuilder {
  copy_click:() => void = () => {};
  play_click:() => void = () => {};
  del:() => void = () => {};
  build() {
    Row(){
      BtnBuilderNormal({text:$r("app.string.CopyLink"),click:this.copy_click})
      if (this.play_click===null){
        Text('|').fontColor($r('app.color.gray')).margin(10)
        BtnBuilderNormal({text:$r("app.string.Play"),click:this.play_click})
      }else {}
      if (this.del===null){
        Text('|').fontColor($r('app.color.gray')).margin(10)
        DelBtnBuilder({click:this.del})
      }else {}

    }
  }
}
@Component
export struct EPGBtnBuilder{
  // eventId:number=0;
  // title:string='';
  Auto_Rec:() => void = () => {};
  Manual_Rec:() => void = () => {};
  Book:() => void = () => {};
  build() {
    Row(){
      BtnBuilderNormal({text:$r("app.string.AutoRec"),click:this.Auto_Rec})
      Text('|').fontColor($r('app.color.gray')).margin(10)
      BtnBuilderNormal({text:$r("app.string.Rec"),click:this.Manual_Rec})
      Text('|').fontColor($r('app.color.gray')).margin(10)
      BtnBuilderNormal({text:$r("app.string.Book"),click:this.Book})
    }.margin({top:12}).width('100%').justifyContent(FlexAlign.End)
  }
}