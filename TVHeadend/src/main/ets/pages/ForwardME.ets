import {TextSystem} from "../view/style"
@Entry
@Component
export struct ForwardME {
  build() {
    Column(){
        Image($r("app.media.touxiang")).borderRadius(9999).height(150).width(150).margin({top:10,bottom:10})
      TextSystem({text: $r("app.string.forwardME"),level:1,txtalign:TextAlign.Center}).margin({top:10,bottom:10})
      TextSystem({text: "我是一位大学生，我在家里自己搭建了一个TVHeadend的服务器来接收来自香港的无线电视频道节目，我在2023年换了HUAWEI MATE 60 Pro更新到鸿蒙系统后我发现登录到后台是真的很麻烦，所以我自己学习了ArkTS制作了这个软件，我是个门外汉我对ArkTS开发也是半斤八两，希望能获得大家的喜欢。",level:2,txtalign:TextAlign.Start}).width('95%')
    }.width('100%')
  }
}