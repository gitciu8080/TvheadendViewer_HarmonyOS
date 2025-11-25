import { readPreferences } from './get_epg'
import {http} from '@kit.NetworkKit'
export interface DvrProfile{
  uuid: string;
  name: string;
}
export interface DvrConfigGridResponse {
  entries: DvrProfile[];
  total: number;
}
export async function getOneDVRProfile(){
  try {
    const profileList = await get_DVR_profile();
    // 查找 name 为空的配置项
    const emptyNameProfile = profileList.find(profile => profile.name === '');
    if (emptyNameProfile) {
      return emptyNameProfile.uuid;
    } else {
      // 如果没有找到 name 为空的配置，返回第一个配置的 UUID
      console.warn('未找到 name 为空的 DVR 配置，使用第一个配置');
      return profileList.length > 0 ? profileList[0].uuid : '';
    }
  } catch (error) {
    console.error('获取 DVR 配置时出错:', error);
    return '';
  }
}
export async function get_DVR_profile():Promise<DvrProfile[]>{

  const url = await readPreferences('tvheadend_config',"api/dvr/config/grid")
  const httpReq=http.createHttp()
  try {
    const response = await httpReq.request(url, { method: http.RequestMethod.GET });

    if (response.responseCode === 200) {
      // Correctly cast the response result to the full interface
      const data = response.result as DvrConfigGridResponse;
      // Return the 'entries' array which contains the profile objects
      return data.entries;
    } else {
      console.error(`Failed to fetch DVR profiles. Status code: ${response.responseCode}`);
      return [{ uuid: 'ER', name: 'ER' }];
    }
  } catch (error) {
    console.error('An error occurred during the HTTP request:', error);
    return [{ uuid: 'ER', name: 'ER' }];
  }
}
export async function get_dvr(state:string){
  interface LangString {
    chi?: string;
    eng?: string;
    jpn?: string;
    kor?: string;
    extraLangs?: Record<string, string>;
  }

  interface DvrListItem {
    uuid: string;
    channelname: string;
    title: LangString;
    disp_title: string;
    subtitle: LangString;
    disp_subtitle: string;
    url: string;
    watched: number;
    // 其他字段省略 — 保留你需要的主要字段即可
  }

  interface DvrListResponse {
    entries: DvrListItem[];
  }

  const dvr_link = await readPreferences('tvheadend_config',`api/dvr/entry/grid${state}`);
  const httpReq=http.createHttp();
  const response= await httpReq.request(dvr_link,{method:http.RequestMethod.GET})
  if (response.responseCode===200 && response.result) {
    const data:DvrListResponse=JSON.parse(response.result as string);

    return data.entries;
  }else {
    return [] as DvrListItem[];
  }
}

interface DvrListItem {
  uuid: string;
  channelname: string;
  title: string[]; // 已转换为数组
  disp_title: string;
  subtitle: string[];
  disp_subtitle: string;
  url: string;
  watched: number;
}
export async function get_dvr_gp(state: string): Promise<DvrListItem[]> {
  interface LangString {
    chi?: string;
    eng?: string;
    jpn?: string;
    kor?: string;
    extraLangs?: Record<string, string>;
  }



  interface RawDvrListItem {
    uuid: string;
    channelname: string;
    title: LangString;
    disp_title: string;
    subtitle: LangString;
    disp_subtitle: string;
    url: string;
    watched: number;
  }

  interface DvrListResponse {
    entries: RawDvrListItem[];
  }

  const dvr_link: string = await readPreferences('tvheadend_config', `api/dvr/entry/grid${state}`);
  const httpReq: http.HttpRequest = http.createHttp();

  const response: http.HttpResponse = await httpReq.request(dvr_link, {
    method: http.RequestMethod.GET
  });

  if (response.responseCode === 200 && typeof response.result === 'string') {
    const data: DvrListResponse = JSON.parse(response.result);

    const converted: DvrListItem[] = data.entries.map((item: RawDvrListItem): DvrListItem => {
      const titleObj = item.title ?? {};
      const titleArray: string[] = Object.values(titleObj).filter(
        (v: string): boolean => v.trim() !== ''
      );
      const subtitleObj = item.subtitle ?? {};
      const subtitleArray: string[] = Object.values(subtitleObj).filter(
        (v: string): boolean => v.trim() !== ''
      );

      return {
        uuid: item.uuid,
        channelname: item.channelname,
        disp_title: item.disp_title,
        disp_subtitle: item.disp_subtitle,
        url: item.url,
        watched: item.watched,
        title: titleArray,
        subtitle: subtitleArray
      };
    });

    return converted;
  } else {
    return [];
  }
}
