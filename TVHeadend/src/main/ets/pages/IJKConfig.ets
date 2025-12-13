import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { http } from '@kit.NetworkKit';
import { promptAction } from '@kit.ArkUI';
import {DvrProfile,get_DVR_profile} from '../tools/get_DVR'
import { TextSystem } from '../view/style';

export const appContext=getContext(this);
interface ConfigurationPage {
  title:string;
  LeiXin:number;
  placeholder:string;
  id:string
}
interface SelectListItem {
  value: string;
}
@Entry
@Component
struct Configuration {
  private prefName = 'tvheadend_config';
  private context = getContext(this);
  @State listData:ConfigurationPage[]=[
    {title:'服务器地址/域名',LeiXin:0,placeholder:'192.168.0.1',id:'server'},
    {title:'用户名',LeiXin:0,placeholder:'admin',id:'username'},
    {title:'密码',LeiXin:0,placeholder:'admin',id:'password'},
    {title:'端口号',LeiXin:0,placeholder:'9981',id:'port'},
    {title:'地址',LeiXin:0,placeholder:'/',id:'path'},
    {title:'HTTPS',LeiXin:1,placeholder:'false',id:'https'}
    // , {title:'DVR配置',LeiXin:2,placeholder:'DVR配置',id:'DvrConfig'}]//
  ]
  @State DVRConfig:DvrProfile[]=[{name:'默认DVR配置',uuid:'default'}];
  get DVRSelectList(): Array<SelectListItem> {
    return this.DVRConfig.map(p => ({ value: `${p.name}|${p.uuid}` } as SelectListItem));
  }
  @State values: Record<string, string | boolean> = {};
  // 初始化：读取已保存配置
  async aboutToAppear() {
    try {
      const pref = await preferences.getPreferences(this.context, this.prefName);
      for (const item of this.listData) {
        if (item.LeiXin === 1) {
          this.values[item.id] = await pref.get(item.id, false) as boolean;
        } else {
          this.values[item.id] = await pref.get(item.id, item.placeholder) as string;
        }
      }
    } catch (e) {
      console.error('读取配置失败', e);
    }
  }
  @State testResult : string='';
  async test_server() {
    try {
      const pref = await preferences.getPreferences(this.context, this.prefName);

      // 1. 取配置
      const server   = await pref.get('server', '') as string;
      const username = await pref.get('username', '') as string;
      const password = await pref.get('password', '') as string;
      const port     = await pref.get('port', '') as string;
      const path     = await pref.get('path', '') as string;
      const https    = await pref.get('https', false) as boolean;


      // 2. 拼 URL
      const protocol = https ? 'https' : 'http';
      const url = `${protocol}://${username}:${password}@${server}:${port}/api/serverinfo`;

      // 3. 发 HEAD 请求（只拿头，最快）
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        readTimeout: 5000,
        header: { 'User-Agent': 'Mozilla/5.0 (Phone; OpenHarmony 5.0)AppleWebKit/537.36 (KHTML, like Gecko)Chrome/114.0.0.0 Safari/537.36 ArkWeb/4.1.6.1 Mobile HuaweiBrowser/5.0.3.351' }
      });

      // 4. 判断结果
      const ok = response.responseCode >= 200 && response.responseCode < 300;
      this.testResult = ok ? '服务器正常' : `连接失败(${response.responseCode})`;
      promptAction.showToast({ message: this.testResult });
      if (ok) {
        console.info('测试成功')
        this.DVRConfig = await get_DVR_profile();
        console.info('测试成功111')
      }
    } catch (e) {
      console.error('test_server', e);
      this.testResult = '连接异常'+ (e as Error).message;
      promptAction.showToast({ message: this.testResult });
    }
  };

  // 实时写入
  private async writePref(key: string, value: string | boolean) {
    try {
      const pref = await preferences.getPreferences(this.context, this.prefName);
      await pref.put(key, value);
      await pref.flush();          // 立即落盘
    } catch (e) {
      console.error('写入配置失败', e);
    }
  }
  build() {
    Column() {
      /* 标题栏保持你原来的 */
      Stack() {
        Row() {
          Text('配置服务器')
            .fontSize(FontWeight.Medium)
            .fontColor($r('app.color.black'));
        }
        .padding({ left: 12 })
        .width('100%');
        Divider()
          .height(1)
          .color($r('app.color.text_hint'))
          .position({ bottom: 0 })
          .width('100%');
      }
      .height(56)
      .width('100%');

      /* 配置列表 */
      List() {
        ForEach(this.listData, (item: ConfigurationPage) => {
          ListItem() {
            if (item.LeiXin === 1) {
              Row() {
                Text(item.title).padding({ top: 12, bottom: 12 });
                Blank();
                Toggle({
                  type: ToggleType.Switch,
                  isOn: this.values[item.id] as boolean
                })
                  .selectedColor($r('app.color.primary_main'))
                  .onChange((isOn: boolean) => {
                    this.values[item.id] = isOn;
                    this.writePref(item.id, isOn);
                  });
              }
              .margin({ top: 12 })
              .padding({ left: 12, right: 12 })
              .width('100%');
            }else if (item.LeiXin===2) {
              Column(){
                TextSystem({text:item.title})
                Select(this.DVRSelectList).selected(0)
                  .value(item.title)
                  .fontColor('#182431')
                  .selectedOptionFont({ size: 16, weight: 400 })
                  .optionFont({ size: 16, weight: 400 })
                  .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
              }.width(`100%`)
            } else {
              Column() {
                Text(item.title)
                  .padding({ top: 12, bottom: 4 });
                TextInput({
                  placeholder: item.placeholder,
                  text: this.values[item.id] as string
                })
                  .borderRadius(5)
                  .onChange((v: string) => {
                    this.values[item.id] = v;
                    this.writePref(item.id, v);
                  });
              }
              .padding({ left: 12, right: 12 })
              .width('100%');
            }
          };
        }, (item: ConfigurationPage) => item.id);
        ListItem(){

        }
      }
      .layoutWeight(1);



      Button({ type: ButtonType.Capsule, stateEffect: false}){
        Text('测试连接')
          .fontSize(20)
          // .fontColor(Color.White);
      }
      .buttonStyle(ButtonStyleMode.NORMAL)
      .width('90%')
      .height(48)
      .margin({ bottom: 20 })
      .onClick(()=>this.test_server())
      /* 保存按钮 */
      Button({ type: ButtonType.Capsule, stateEffect: false }) {
        Text('保存并退出')
          .fontSize(20)
          .fontColor(Color.White);
      }
      .width('90%')
      .height(48)
      .margin({ bottom: 20 })
      .onClick(() => router.back());
    }
    .width('100%')
    .height('100%');
  }

}
