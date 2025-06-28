
export interface CourseData {
  id: string; //会议id
  name: string; //会议名称
  creator_name: string; //创建者名称
  sponsor: string; //主办单位
  agenda: string; //议程
  guests: string; //嘉宾介绍
  location: string; //会议地点
  content: string; //会议内容
  category: string; //会议类别
  startTime: string; //会议时间
  endTime: string;
  cover_url: string; //会议封面
  create_time: string; //会议创建时间
  status: string[]; //有哪些用户参加会议，0是没人参加，存的是参加会议的用户的userid
}

export default class Course {
  id: string = "";
  name: string = "";
  location: string = "";
  startTime: string = "";
  endTime: string = "";
  creator_name: string = ""; //创建者名称
  sponsor: string = ""; //主办单位
  agenda: string = ""; //议程
  guests: string = ""; //嘉宾介绍
  content: string = ""; //会议内容
  category: string = ""; //会议类别
  cover_url: string = ""; //会议封面
  create_time: string = ""; //会议创建时间
  status: string[] = [];

  // 格式化开始时间 (HH:mm)
  get formattedStartTime(): string {
    return this.formatTime(this.startTime);
  }

  // 格式化结束时间 (HH:mm)
  get formattedEndTime(): string {
    return this.formatTime(this.endTime);
  }

  // 时间格式化方法
  private formatTime(timeString: string): string {
    const timePart = timeString.split(" ")[1];
    return timePart.substring(0, 5);
  }

  //获取日期
  get date(): string {
    return this.startTime.split(" ")[0];
  }

  // 持续时间
  get duration(): string {
    return `${this.formattedStartTime} - ${this.formattedEndTime}`;
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
    status: string[]
  ) {
    this.id = id;
    this.name = name;
    this.location = location;
    this.startTime = startTime;
    this.endTime = endTime;
    this.creator_name = creator_name;
    this.sponsor = sponsor;
    this.agenda = agenda;
    this.guests = guests;
    this.content = content;
    this.category = category;
    this.cover_url = cover_url;
    this.create_time = create_time;
    this.status = status;
  }
}