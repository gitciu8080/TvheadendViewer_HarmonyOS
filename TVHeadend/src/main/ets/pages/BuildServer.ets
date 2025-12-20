import { Markdown,MarkdownController } from '@luvi/lv-markdown-in';
import pasteboard from '@ohos.pasteboard';

@Entry
@Component
struct BuildServer {
  // @State message: string = 'Hello World';
  markdownController:MarkdownController=new MarkdownController();
  aboutToAppear(): void {
    this.markdownController.setCodeCopyListener((code:string)=>{
      const clipboard =pasteboard.getSystemPasteboard()
      const data = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, code);
      clipboard.setData(data);
    })
    this.markdownController.setTitleColor($r("app.color.black")).setTextColor($r("app.color.black")).setQuoteBackgroundColor($r("app.color.background_sec"))
  }
  build() {
    Scroll(){
      Column(){
        Markdown({mode:"rawfile",context:getContext(),rawfilePath:"BuildServer.md",controller:this.markdownController,
          callback: {                 // callback 可省略
            complete: () => {
              console.log("Markdown component load success.")
            },
            fail: (code: number, message: string) => {
              console.error("Markdown component load error. code: " + code + ", message: " + message)
            }
          }
        })
      }.padding(10)
    }
  }
}