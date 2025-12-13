import { http } from "@kit.NetworkKit";
import { readPreferences } from "./get_epg";
import { font, LengthMetrics } from "@kit.ArkUI";

interface Root {
  boxid: string;
  messages: AccessUpdateMessage [];
}
interface AccessUpdateMessage {
  uilevel: string;
  theme: string;
  page_size: number;
  quicktips: number;
  chname_num: number;
  chname_src: number;
  date_mask: string;
  label_formatting: number;
  username: string;
  address: string;
  dvr: number;
  admin: number;
  time: number;
  cookie_expires: number;
  ticket_expires: number;
  info_area: string;
  freediskspace: number;
  useddiskspace: number;
  totaldiskspace: number;
}
interface storage_output{
  Storage_Used:number,Storage_Total:number
}
export async function getStorage(): Promise<storage_output> {
  const url: string = await readPreferences('tvheadend_config', `comet/poll`);
  const httpReq: http.HttpRequest = http.createHttp()
  try {
    const response: http.HttpResponse = await httpReq.request(url, { method: http.RequestMethod.GET })
    if (response.responseCode === 200 && response.result) {
      const data: Root = JSON.parse(response.result as string)
      const mess: AccessUpdateMessage[] = data.messages
      const test: AccessUpdateMessage = mess[0]
      return { Storage_Used: test.useddiskspace, Storage_Total: test.totaldiskspace }
    }
  } catch (error) {
    return { Storage_Used: 0, Storage_Total: 0 }
  }
  return { Storage_Used: 0, Storage_Total: 0 }
}
@Entry
@Component
export struct Storage {
    Storage_Used:number=0;
    Storage_Total:number=0;
  StorageValue:number=0;
  build() {
      Column(){
        Row(){
          if (this.StorageValue>80){
            Progress({value:this.StorageValue,total:100,type:ProgressType.Capsule}).style({
              borderWidth: 2,
              borderColor: $r('app.color.primary_main'),
              fontColor: $r('app.color.black'),
              showDefaultPercentage: true,
              enableSmoothEffect: true,
              borderRadius:LengthMetrics.vp(5)
            }).height(50).color($r('app.color.error_main')).hitTestBehavior(HitTestMode.None)
          }else {
            Progress({value:this.StorageValue,total:100,type:ProgressType.Capsule}).style({
              borderWidth: 2,
              fontColor: $r('app.color.black'),
              showDefaultPercentage: true,
              enableSmoothEffect: true,
              borderRadius:LengthMetrics.vp(5)
            }).height(50).color($r('app.color.primary_main')).hitTestBehavior(HitTestMode.None)
          }
        }.width("95%")
      }
  }
}