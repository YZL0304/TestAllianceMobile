export interface DynamicsData {
  dynamic_id: number;//动态号
  publisher_id: number;//发布者编号
  title: string;//题目
  content: string;//动态内容
  summary: string;//简介
  author: string;//作者
  image_url: string;//动态相关图片
  create_time: string;//创建时间
  audit_status:number;//审核状态
}

export default class Dynamics {
  dynamic_id: number = 0;//动态号
  publisher_id: number = 0;//发布者编号
  title: string = "";//题目
  content: string = "";//动态内容
  summary: string = "";//简介
  author: string = "";//作者
  image_url: string = "";//动态相关图片
  create_time: string = "";//创建时间
  audit_status:number = 0;

  constructor(
    dynamic_id: number,
    publisher_id: number,
    title: string,
    content: string,
    summary: string,
    author: string,
    image_url: string,
    create_time: string,
    audit_status:number
  ){
    this.dynamic_id = dynamic_id;
    this.publisher_id = publisher_id;
    this.title = title;
    this.content = content;
    this.summary = summary;
    this.author = author;
    this.image_url = image_url;
    this.create_time = create_time;
    this.audit_status = audit_status;
  }

  // 时间格式化方法
  private formatTime(timeString: string): string {
    const timePart = timeString.split(" ")[1];
    return timePart.substring(0, 5);
  }
  get formattedStartTime(): string {
    return this.formatTime(this.create_time);
  }
  get date(): string {
    return this.create_time.split(" ")[0];
  }
  get datePart(): string {
    return this.create_time.split(" ")[0] || "";
  }
}



