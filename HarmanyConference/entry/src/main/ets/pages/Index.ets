import { User, UserData } from '../model/User';

import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { bufferToString } from '../util/BufferUtil';



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

  // 读取用户数据
  async loadUsers(): Promise<User[]> {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      // 直接获取文件内容为 Uint8Array
      const content: Uint8Array = await context.resourceManager.getRawFileContent('users.json');
      // 使用工具函数将 Uint8Array 转换为字符串
      const jsonStr: string = bufferToString(content);
      // 解析 JSON 数据（使用明确定义的类型）
      const usersData: UserData[] = JSON.parse(jsonStr) as UserData[];
      // 转换为 User 对象
      return usersData.map(user =>
      new User(
        user.user_id,
        user.compony,
        user.username,
        user.nickname,
        user.phone,
        user.email,
        user.password
      )
      );
    } catch (error) {
      console.error('Error loading users:', JSON.stringify(error));
      promptAction.showToast({ message: '加载用户数据失败', duration: 2000 });
      return [];
    }
  }

  // 处理登录逻辑
  async handleLogin() {
    if (!this.username || !this.password || !this.company) {
      this.errorMessage = '请填写所有字段';
      return;
    }
    this.isLoading = true;
    this.errorMessage = '';
    try {
      const users = await this.loadUsers();
      const foundUser = users.find(user =>
      user.username === this.username &&
        user.password === this.password &&
        user.compony === this.company
      );
      if (foundUser) {
        // 存储登录用户信息
        this.currentUser = foundUser;
        promptAction.showToast({ message: '登录成功', duration: 1000 });
        // 延迟跳转以便显示成功提示
        setTimeout(() => {
          router.replaceUrl({ url: 'pages/MasterPage' });
        }, 1200);
      } else {
        this.errorMessage = '用户名、密码或公司信息不正确';
      }
    } catch (error) {
      console.error('Login error:', JSON.stringify(error));
      this.errorMessage = '登录过程中发生错误';
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