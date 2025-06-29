
export interface CourseData {
  id: string; //会议id meeting
  name: string; //会议名称meeting
  creatorName: string; //创建者名称meeting
  sponsor: string; //主办单位meeting_detail
  agenda: string; //议程meeting_detail
  guests: string; //嘉宾介绍meeting_detail
  location: string; //会议地点meeting_detail
  content: string; //会议内容meeting
  category: string; //会议类别meeting_category
  startTime: string; //会议时间meeting
  endTime: string;//meeting
  coverUrl: string; //会议封面meeting
  createTime: string; //会议创建时间meeting
}

export default class Course {
  id: string = "";
  name: string = "";
  location: string = "";
  startTime: string = "";
  endTime: string = "";
  creatorName: string = ""; //创建者名称
  sponsor: string = ""; //主办单位
  agenda: string = ""; //议程
  guests: string = ""; //嘉宾介绍
  content: string = ""; //会议内容
  category: string = ""; //会议类别
  coverUrl: string = ""; //会议封面
  createTime: string = ""; //会议创建时间

  // 完整的持续时间字符串 (格式: "2025-06-28 19:37 - 2025-06-28 21:30")
  get duration(): string {
    return `${this.formatDateTime(this.startTime)} - ${this.formatDateTime(this.endTime)}`;
  }

  get date(): string {
    return this.startTime.split(' ')[0] || "";
  }

  // 格式化日期时间 (移除秒部分)
  private formatDateTime(datetime: string): string {
    if (!datetime) return "";

    if (datetime.includes('T')) {
      return datetime.replace('T', ' ').substring(0, 16);
    } else {
      return datetime.substring(0, 16);
    }
  }

  constructor(
    id: string,
    name: string,
    location: string,
    startTime: string,
    endTime: string,
    creator_name: string,
    content: string,
    category: string,
    cover_url: string,
    sponsor: string,
    agenda: string,
    guests: string,
    create_time: string,
  ) {
    this.id = id;
    this.name = name;
    this.location = location;
    this.startTime = startTime;
    this.endTime = endTime;
    this.creatorName = creator_name;
    this.sponsor = sponsor;
    this.agenda = agenda;
    this.guests = guests;
    this.content = content;
    this.category = category;
    this.coverUrl = cover_url;
    this.createTime = create_time;
  }
}