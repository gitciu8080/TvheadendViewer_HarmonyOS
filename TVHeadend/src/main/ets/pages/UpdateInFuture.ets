import { Markdown } from '@luvi/lv-markdown-in';

@Entry
@Component
struct UpdateInFuture {
  @State message: string = 'Hello World';

  build() {
    Column(){
      Markdown({
        mode: "rawfile",
        context: getContext(),      // 资源文件模式必填参数
        rawfilePath: "UpdateFuture.md",   // 资源文件地址
        callback: {                 // callback 可省略
          complete: () => {
            console.log("Markdown component load success.")
          },
          fail: (code: number, message: string) => {
            console.error("Markdown component load error. code: " + code + ", message: " + message)
          }
        }
      })
    }.width('100%').height('100%')
  }
}