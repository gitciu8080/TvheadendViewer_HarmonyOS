import {http}from '@kit.NetworkKit'
import { preferences } from '@kit.ArkData';
import {appContext} from '../pages/TVHSConfig';
import { promptAction } from '@kit.ArkUI';
export async function readPreferences(prefName: string, api: string) {
  const pref = await preferences.getPreferences(appContext, prefName);

  // 1. 取配置
  const server   = await pref.get('server', '') as string;
  const username = await pref.get('username', '') as string;
  const password = await pref.get('password', '') as string;
  const port     = await pref.get('port', '') as string;
  const https    = await pref.get('https', false) as boolean;

  // 2. 拼 URL
  const protocol = https ? 'https' : 'http';
  const url = `${protocol}://${username}:${password}@${server}:${port}/${api}`;
  return url;
}
async function CheckServer(prefName:string){
  const url = await readPreferences(prefName,'api/serverinfo');
  const httpRequest = http.createHttp();
  const response = await httpRequest.request(url, {
    method: http.RequestMethod.GET,
    readTimeout: 5000,
    header: { 'User-Agent': 'Mozilla/5.0 (Phone; OpenHarmony 5.0)AppleWebKit/537.36 (KHTML, like Gecko)Chrome/114.0.0.0 Safari/537.36 ArkWeb/4.1.6.1 Mobile HuaweiBrowser/5.0.3.351' }
  });
  if (response.responseCode ==200){
    return true;
  }else if (response.responseCode===401){
    return '账号密码错误';
  }else {
    return false;
  }
}
export async function getChannel(prefName:string){
  const servercheck=await CheckServer(prefName);
  interface Channel {
    key: string;   // 频道 UUID
    val: string;   // 频道名称
  }
  if (servercheck===true){
    const channel_list_link =await readPreferences(prefName,'api/channel/list');
    const httpReq=http.createHttp();
    const response= await httpReq.request(channel_list_link,{method:http.RequestMethod.GET})
    if (response.responseCode===200 && response.result) {
      interface ChannelListResponse {
        entries: Channel[];
      }

      const data:ChannelListResponse=JSON.parse(response.result as string);
      return data.entries;
    }else {
      const errorResult: [Channel] =[{ key: 'error', val: '获取频道列表失败' }];
      return errorResult ;
    }
  }else {
    const errorResult: [Channel] =[{ key: '请检查配置文件', val: '获取频道列表失败，请检查配置文件' }];
    return errorResult ;
  }
}


export interface EpgEvent {
  event_id:number
  id: string
  title: string
  start: number // 时间戳 (秒)
  stop: number  // 时间戳 (秒)
  summary: string
  progress: number
  PG:boolean
  Multi_language:boolean
}
export async function getEPG(prefname:string,channelID:string){
  //目标转换数据表

  // 新增接口定义：按日期分组的 EPG 数据
  interface EpgGroup {
    date: string
    EpgEvent: EpgEvent[]
  }
  //josn源数据表
  interface EpgEventData{
    eventId:number;
    channelName:string;
    channelUuid:string;
    channelNumber:number;
    start:number;
    stop:number;
    title:string;
    subtitle:string;
    description?:string;
    nextEventId:number;
  }
  const api_path=`api/epg/events/grid?channel=${channelID}&limit=999`
  const channel_list_link =await readPreferences(prefname,api_path);
  const httpReq=http.createHttp();
  const response= await httpReq.request(channel_list_link,{method:http.RequestMethod.GET})
  if (response.responseCode===200 && response.result){
    interface EpgListResponse {
      entries: EpgEventData [];
    }
    const data: EpgListResponse=JSON.parse(response.result as string);
    const now=Math.floor(Date.now()/1000)
    const convertedData:EpgEvent[]=data.entries.map((item:EpgEventData):EpgEvent =>{
      const hasPG = item.title.includes('[PG]');
      // const hasMultiLang = item.title.includes('[*/*]');
      const hasMultiLang = item.title.includes('[*/*]') || /\[.\/.\]/.test(item.title);

      return{
        event_id:item.eventId,
        id: item.channelUuid,
        title: item.title.replace(/\[PG\]|\[.*\/.*\]/g,'').trim(),
        start: item.start,
        stop: item.stop,
        summary: item.subtitle,
        progress: Math.max(0, Math.min(100, ((now - item.start) / (item.stop - item.start)) * 100)),
        PG: hasPG,
        Multi_language: hasMultiLang
      }
    })
    // 按日期分组
    const groupedData: Record<string, EpgEvent[]> = {};
    convertedData.forEach(item => {
      // 将时间戳转换为日期字符串 (yyyy-mm-dd)
      const date = new Date(item.start * 1000);
      const dateString = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;

      if (!groupedData[dateString]) {
        groupedData[dateString] = [];
      }
      groupedData[dateString].push(item);
    });
    // 转换为所需的格式数组
    const result: EpgGroup[] = Object.keys(groupedData).map((date): EpgGroup => ({
      date: date,
      EpgEvent: groupedData[date]
    }));

    return result;
  }else {
    // 错误情况下返回空数组而不是单个对象
    return [] as EpgGroup[];

  }
}
