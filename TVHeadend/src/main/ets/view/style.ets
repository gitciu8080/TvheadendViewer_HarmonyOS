@Component
export struct itemHead {
  text: string = '';

  build() {
    Column() {
      Text(this.text)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .width('95%')
        .textAlign(TextAlign.Center)
        .backgroundColor($r('app.color.primary_main'))
        .borderRadius(5)
        .padding({ top: 5, bottom: 5 })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .margin({ bottom: 5 })
  }
}

@Component
export struct TitleStyle {
  text = '';
  level: number = 1;

  build() {
    if (this.level === 1) {
      Text(this.text)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .textAlign(TextAlign.Start)
        .width('70%')
    }
    else if (this.level === 2) {
      Text(this.text)
        .width('100%')
        .fontSize(12)
        .textAlign(TextAlign.End)
    }
    else if (this.level === 3) {
      Text(this.text)
        .fontSize(14)
        .width('100%')
        .fontColor($r('app.color.gray'))
    }
    else if (this.level === 4) {
      // 节目属性
      Text(this.text)
        .width('30%')
        .textAlign(TextAlign.End)
        .fontStyle(FontStyle.Italic)
        .fontWeight(FontWeight.Bold)
    }
    else if (this.level === 5) {
      //并排元素专属
      Text(this.text)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .textAlign(TextAlign.Start)
    }
    else {
      Text(this.text) // 默认情况
    }
  }
}

@Component
export struct TextSystem {
  text = '';
  txtalign:TextAlign=TextAlign.Start;
  bold:FontWeight=FontWeight.Normal;
  level: number = 1;
  color='';
  fontwidth='100%';

  build() {
    if (this.level === 0){
      Text(this.text)
        .fontSize(25)
        .fontWeight(this.bold)
        .fontColor(this.color)
        .textAlign(this.txtalign)
        .width(this.fontwidth)
        .margin({ top: 15, bottom: 15 })
    }
    else if (this.level === 1) {
      Text(this.text)
        .fontSize(20)
        .fontWeight(this.bold)
        .fontColor(this.color)
        .textAlign(this.txtalign)
        .width(this.fontwidth)
    }
    else if (this.level === 2) {
      Text(this.text)
        .fontSize(18)
        .fontWeight(this.bold)
        .fontColor(this.color)
        .textAlign(this.txtalign)
        .width(this.fontwidth)
    }
    else if (this.level === 3) {
      Text(this.text)
        .fontSize(16)
        .fontWeight(this.bold)
        .fontColor(this.color)
        .textAlign(this.txtalign)
        .width(this.fontwidth)
    }
    else if (this.level === 4) {
      Text(this.text)
        .fontSize(14)
        .fontWeight(this.bold)
        .fontColor(this.color)
        .textAlign(this.txtalign)
        .width(this.fontwidth)
    }
    else if (this.level === 5) {
      //并排元素专属
      Text(this.text)
        .fontSize(12)
        .fontWeight(this.bold)
        .fontColor(this.color)
        .textAlign(this.txtalign)
        .width(this.fontwidth)

    }
    else {
      Text(this.text) // 默认情况
    }
  }
}
@Component
export struct BtnTitleStyle {
  text = '';
  level: number = 1;

  build() {
    if (this.level === 1) {
      Text(this.text)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .textAlign(TextAlign.Start)
    }
    else if (this.level === 2) {
      Text(this.text)
        .fontSize(12)
        .textAlign(TextAlign.End)
    }
    else if (this.level === 3) {
      Text(this.text)
        .fontSize(17)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
    }
    else if (this.level === 4) {
      Text(this.text)
        .fontSize(19)
        .fontColor($r('app.color.primary_main'))
        .fontWeight(FontWeight.Bold)
    }
    else if (this.level === 5) {
      //并排元素专属
      Text(this.text)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .textAlign(TextAlign.Start)
    }
    else {
      Text(this.text) // 默认情况
    }
  }
}