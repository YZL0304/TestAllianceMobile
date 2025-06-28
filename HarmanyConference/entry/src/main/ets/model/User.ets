// src/main/ets/model/User.ets
export interface UserData {
  user_id: string;
  compony: string;
  username: string;
  nickname: string;
  phone: string;
  email: string;
  password: string;
}

export class User {
  user_id: string = "";
  compony: string = "";
  username: string = "";
  nickname: string = "";
  phone: string = "";
  email: string = "";
  password: string = "";

  constructor(
    user_id: string,
    compony: string,
    username: string,
    nickname: string,
    phone: string,
    email: string,
    password: string
  ) {
    this.user_id = user_id;
    this.compony = compony;
    this.username = username;
    this.nickname = nickname;
    this.phone = phone;
    this.email = email;
    this.password = password;
  }

  // 从JSON数据创建User实例
  static fromJson(data: UserData): User {
    return new User(
      data.user_id,
      data.compony,
      data.username,
      data.nickname,
      data.phone,
      data.email,
      data.password
    );
  }
}