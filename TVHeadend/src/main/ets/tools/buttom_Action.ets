import {http}from '@kit.NetworkKit'
import {readPreferences} from "./get_epg"
import {getOneDVRProfile} from "./get_DVR"
import {promptAction} from '@kit.ArkUI'

import { DvrAutoRecResponse,DvrAutoRecItem } from '../model/InterFace';

export async function Rec_TV(event_id:number,title:string){
  // console.info('正在添加1')
  const dvr_profile=await getOneDVRProfile()
  // console.info(dvr_profile)
  const url = await readPreferences('tvheadend_config',`api/dvr/entry/create_by_event?config_uuid=${dvr_profile}&event_id=${event_id}`)
  // console.log(url)
  // console.info('正在添加1')
  const httpReq=http.createHttp()
  const response= await httpReq.request(url,{method:http.RequestMethod.GET})
  if (response.responseCode===200) {
    if (response.result==="{}") {
      promptAction.showToast({ message: '添加过了' })
    }else {
      promptAction.showToast({ message: `添加节目${title}的录制成功` })
    }
  }else {
    promptAction.showToast({ message: `添加失败${response.responseCode}` })
  }
}



export async function Auto_Rec(eventid:number,title:string){
  const dvr_profile=await getOneDVRProfile()
  const url = await readPreferences('tvheadend_config',`api/dvr/autorec/create_by_series?config_uuid=${dvr_profile}&event_id=${eventid}`)
  const isDuplicate= await isDuplicateTitle( title)
  const c=`isd_${isDuplicate}`
  console.info(c)
  if (isDuplicate===false) {
    const httpReq=http.createHttp()
    const response= await httpReq.request(url,{method:http.RequestMethod.GET})
    if (response.responseCode===200) {
      promptAction.showToast({ message: `添加节目${title}的自动录制成功` })
    }else {
      promptAction.showToast({ message: `添加失败${response.responseCode}` })
    }
  }else {
    promptAction.showToast({ message: '添加过了' })
  }

}

/**
 * 检测自动录制规则中是否存在相同标题的项目
 * @param title 要检查的标题
 * @returns 如果存在相同标题返回true，否则返回false
 */
export async function isDuplicateTitle(title: string): Promise<boolean> {
  try {
    // 获取所有自动录制规则
    const dvr_profile = await getOneDVRProfile();
    const url = await readPreferences('tvheadend_config', 'api/dvr/autorec/grid');
    const httpReq = http.createHttp();
    const response = await httpReq.request(url, { method: http.RequestMethod.GET });
    
    if (response.responseCode === 200) {
      const data: DvrAutoRecResponse = JSON.parse(response.result as string);
      const entries: DvrAutoRecItem[] = data.entries;
      
      // 循环匹配标题
      for (let i = 0; i < entries.length; i++) {
        if (entries[i].title === title) {
          return true;
        }
      }
      return false;
    } else {
      console.error(`获取自动录制列表失败: ${response.responseCode}`);
      return false;
    }
  } catch (error) {
    console.error('检查重复标题时出错:', error);
    return false;
  }
}