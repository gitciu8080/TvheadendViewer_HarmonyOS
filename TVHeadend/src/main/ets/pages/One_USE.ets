// import { web, } from '@kit.ArkWeb';
import { Markdown } from '@luvi/lv-markdown-in';

@Entry
@Component
struct OneUseMD{

  build() {
    Column(){
        Markdown({mode:"rawfile",context:getContext(),rawfilePath:"OneUse.md",
          callback: {                 // callback 可省略
            complete: () => {
              console.log("Markdown component load success.")
            },
            fail: (code: number, message: string) => {
              console.error("Markdown component load error. code: " + code + ", message: " + message)
            }
          }
        })
    }.padding({left:10,right:10})
  }
}