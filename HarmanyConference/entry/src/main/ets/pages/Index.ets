
import { LoginRequest, User, UserData } from '../model/User';


import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { bufferToString } from '../util/BufferUtil';

import { http } from '@kit.NetworkKit';



@Entry
@Component
struct Index {
  @StorageLink('currentUser') currentUser: User | null = null;
  @State username: string = '';
  @State password: string = '';
  @State company: string = '';
  @State isLoading: boolean = false;
  @State errorMessage: string = '';
  @State showPassword: boolean = false;



  // 处理登录逻辑
  async handleLogin() {
    if (!this.username || !this.password || !this.company) {
      this.errorMessage = '请填写所有字段';
      return;
    }
    this.isLoading = true;
    this.errorMessage = '';

    const requestData :LoginRequest={
      username: this.username,
      password: this.password,
      companyName: this.company
    };
//调用后端接口检查用户是否存在
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'http://172.22.123.162:8080/mobileLogin',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify(requestData)
        }
      );

      if (response.responseCode === 200) {
        const user = JSON.parse(response.result.toString()) as User;
        this.currentUser = user;
        promptAction.showToast({ message: '登录成功', duration: 1000 });
        setTimeout(() => {
          router.replaceUrl({ url: 'pages/MasterPage' });
        }, 1200);
      } else if (response.responseCode === 401) {
        this.errorMessage = '用户名、密码或公司不正确';
      } else {
        this.errorMessage = '登录失败，状态码：' + response.responseCode;
      }

      httpRequest.destroy();
    } catch (error) {
      console.error('Login error:', JSON.stringify(error));
      this.errorMessage = '网络错误，无法登录';

    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // 顶部标题
      Text('欢迎登录')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 80, bottom: 50 })
        .fontColor('#0A59F7')

      // 登录表单
      Column() {
        // 用户名输入框
        TextInput({ text: this.username, placeholder: '请输入用户名' })
          .placeholderFont({ size: 16 })
          .type(InputType.Normal)
          .height(50)
          .width('90%')
          .margin({ bottom: 20 })
          .borderRadius(10)
          .backgroundColor(Color.White)
          .padding(10)
          .onChange(value => this.username = value)

        // 密码输入框
        Row() {
          TextInput({ text: this.password, placeholder: '请输入密码' })
            .placeholderFont({ size: 16 })
            .type(this.showPassword ? InputType.Normal : InputType.Password)
            .height(50)
            .layoutWeight(1)
            .borderRadius(10)
            .backgroundColor(Color.White)
            .padding(10)
            .onChange(value => this.password = value)

          Button(this.showPassword ? '隐藏' : '显示')
            .width(70)
            .height(50)
            .fontSize(14)
            .backgroundColor(Color.Transparent)
            .fontColor('#0A59F7')
            .onClick(() => this.showPassword = !this.showPassword)
        }
        .height(50)
        .width('90%')
        .borderRadius(10)
        .backgroundColor(Color.White)
        .padding({ right: 10 })
        .margin({ bottom: 20 })

        // 公司输入框
        TextInput({ text: this.company, placeholder: '请输入公司名称' })
          .placeholderFont({ size: 16 })
          .type(InputType.Normal)
          .height(50)
          .width('90%')
          .borderRadius(10)
          .backgroundColor(Color.White)
          .padding(10)
          .onChange(value => this.company = value)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)

      // 错误提示
      if (this.errorMessage) {
        Text(this.errorMessage)
          .fontSize(14)
          .fontColor(Color.Red)
          .margin({ top: 15, bottom: 10 })
      }

      // 登录按钮
      Button('登录', { type: ButtonType.Capsule, stateEffect: true })
        .width('80%')
        .height(50)
        .margin({ top: 30, bottom: 20 })
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#0A59F7')
        .onClick(() => this.handleLogin())
        .opacity(this.isLoading ? 0.7 : 1)

      // 加载指示器
      if (this.isLoading) {
        LoadingProgress()
          .width(40)
          .height(40)
          .margin({ top: 10 })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .padding(20)
    .backgroundColor('#F5F7FA')
  }
}