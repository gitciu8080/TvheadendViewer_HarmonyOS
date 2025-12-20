import {EpgEvent} from  "../tools/get_epg"
export interface Channels {
  key: string;   // 频道 UUID
  val: string;   // 频道名称
}


export interface EpgGroup {
  date: string
  EpgEvent: EpgEvent[]
}
export interface Title {
  chi: string;
  eng: string;
}
export interface Subtitle {
  chi: string;
  eng?: string;
}
export interface Credits {
  // 根据JSON数据，credits是一个空对象，可以根据实际需要扩展
}
export interface DvrListItem {
  uuid: string;
  enabled: boolean;
  create: number;
  watched: number;
  start: number;
  start_extra: number;
  start_real: number;
  stop: number;
  stop_extra: number;
  stop_real: number;
  duration: number;
  channel: string;
  channelname: string;
  image: string;
  fanart_image: string;
  title: Title;
  disp_title: string;
  subtitle: Subtitle;
  disp_subtitle: string;
  disp_summary: string;
  disp_description: string;
  disp_extratext: string;
  pri: number;
  retention: number;
  removal: number;
  playposition: number;
  playcount: number;
  config_name: string;
  owner: string;
  creator: string;
  filename: string;
  errorcode: number;
  errors: number;
  data_errors: number;
  dvb_eid: number;
  noresched: boolean;
  norerecord: boolean;
  fileremoved: number;
  autorec: string;
  autorec_caption: string;
  timerec: string;
  timerec_caption: string;
  parent: string;
  child: string;
  content_type: number;
  copyright_year: number;
  broadcast: number;
  episode_disp: string;
  url: string;
  filesize: number;
  status: string;
  sched_status: string;
  duplicate: number;
  first_aired: number;
  category: []; // 空数组，可能是字符串数组
  credits: Credits;
  keyword: []; // 空数组，可能是字符串数组
  genre: []; // 空数组，可能是字符串数组
  age_rating: number;
  rating_label_uuid: string;
  rating_icon: string;
  rating_authority: string;
  rating_country: string;
  rating_label: string;
}
export class Settings {
  name: string;
  icon: Resource;
  page: string;

  constructor(name: string, icon: Resource, page: string) {
    this.name = name;
    this.icon = icon;
    this.page = page;
  }
}
export class EPGSearch {
  name: string;
  icon: Resource;
  link: string;

  constructor(name: string, icon: Resource, link: string) {
    this.name = name;
    this.icon = icon;
    this.link = link;
  }
}

export class DVRtab{
  title:string;
  state:string;

  constructor(title:string,state:string){
    this.title = title;
    this.state = state;
  }
}
export interface DvrAutoRecItem {
  uuid: string
  enabled: boolean
  name: string
  title: string
  channel: string
  config_name: string
  comment?: string
}

export interface DvrAutoRecResponse {
  entries: DvrAutoRecItem[]
  total: number
}