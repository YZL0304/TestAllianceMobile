export interface FeedbackData {
  user_id: string;
  meeting_id: string;
  user_name: string;
  gender: string;
  company: string;
  phone: string;
  email: string;
  arrive_way: string;
  arrive_train: string;
  arrive_time: string;
  create_time: string;
}

export class FeedBack {
  user_id: string = "";
  meeting_id: string = "";
  user_name: string = ""; // 参会者姓名
  gender: string = "";
  company: string = ""; // 参会者公司
  phone: string = "";
  email: string = "";
  arrive_way: string = ""; // 到达方式
  arrive_train: string = ""; // 到达车次
  arrive_time: string = ""; // 到达时间
  create_time: string = ""; // 该回执单创建时间

  // 添加空构造方法
  constructor();

  // 带参数的构造方法
  constructor(
    user_id: string,
    meeting_id: string,
    user_name: string,
    gender: string,
    company: string,
    phone: string,
    email: string,
    arrive_way: string,
    arrive_train: string,
    arrive_time: string,
    create_time: string
  );

  // 实现构造方法
  constructor(
    user_id?: string,
    meeting_id?: string,
    user_name?: string,
    gender?: string,
    company?: string,
    phone?: string,
    email?: string,
    arrive_way?: string,
    arrive_train?: string,
    arrive_time?: string,
    create_time?: string
  ) {
    if (user_id !== undefined) {
      this.user_id = user_id;
      this.meeting_id = meeting_id as string;
      this.user_name = user_name as string;
      this.gender = gender as string;
      this.company = company as string;
      this.phone = phone as string;
      this.email = email as string;
      this.arrive_way = arrive_way as string;
      this.arrive_train = arrive_train as string;
      this.arrive_time = arrive_time as string;
      this.create_time = create_time as string;
    }
    // 如果没有参数，则使用默认值（已初始化）
  }
}