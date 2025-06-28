import { AppState } from "../model/AppState";
import Course from "../model/Course";
import { User } from "../model/User";
import { faceDetector } from "@kit.CoreVisionKit";
import { promptAction } from "@kit.ArkUI";


//报名表页
@Component
export struct RegisterView {
  @Consume("ConferencePageStack") private pageStack!: NavPathStack;
  @StorageLink('currentUser') currentUser: User | null = null;
  @State course: Course | null = null; //当前填写的会议
  @State username: string = ''; //参会者姓名，自动填充
  @State gender: string = ''; //选择性别
  @State company: string = ''; //公司，自动填充
  @State phone: string = ''; //自动填充
  @State email: string = ''; //自动填充
  @State arrive_way: string = '';
  @State arrive_train: string = '';
  @State arrive_time: string = '';
  @State create_time: string = new Date().toISOString(); //自动获取当前时间
  @State isSaving: boolean = false;


  aboutToAppear() {
    if (this.currentUser) {
      this.username = this.currentUser.username || '';
      this.company = this.currentUser.compony || '';
      this.phone = this.currentUser.phone || '';
      this.email = this.currentUser.email || '';
    }
    this.course = AppState.getInstance().selectedCourse;
    console.log("加载的课程:", this.course);

  }

  //检查是否全部填写
  validateForm(): boolean {
    return this.username.trim() !== '' &&
      this.gender.trim() !== '' &&
      this.company.trim() !== '' &&
      this.phone.trim() !== '' &&
      this.email.trim() !== '' &&
      this.arrive_way.trim() !== '' &&
      this.arrive_train.trim() !== '' &&
      this.arrive_time.trim() !== '';
  }

  //提交操作
onSubmit(){
  if (!this.validateForm()) {
    promptAction.showToast({ message: '请完整填写所有信息' });
    return;
  }
  if (!this.currentUser || !this.course) {
    promptAction.showToast({ message: '用户或课程信息异常' });
    return;
  }
  promptAction.showToast({ message: '填写成功' });
  this.pageStack.pop();
}

  build() {
    NavDestination(){
      Column() {
        // 头部 - 会议名称
        Text(this.course?.name || '会议报名')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 20 })
          .width('90%')
          .textAlign(TextAlign.Center)

        // 表单区域
        Scroll() {
          Column() {
            // 个人信息标题
            Text('个人信息')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 10, bottom: 15, left: 20 })
              .width('90%')
              .textAlign(TextAlign.Start)

            // 姓名
            Text('姓名')
              .fontSize(16)
              .margin({ bottom: 8, left: 20 })
              .width('90%')
              .textAlign(TextAlign.Start)
            TextInput({ text: this.username, placeholder: this.currentUser?.username })
              .placeholderFont({ size: 16 })
              .type(InputType.Normal)
              .height(50)
              .width('90%')
              .margin({ bottom: 20 })
              .borderRadius(10)
              .backgroundColor(Color.White)
              .padding(10)
              .onChange(value => this.username = value)

            // 性别
            Text('性别')
              .fontSize(16)
              .margin({ bottom: 8, left: 20 })
              .width('90%')
              .textAlign(TextAlign.Start)
            Row() {
              Radio({ value: 'male', group: 'gender' })
                .checked(this.gender === 'male')
                .onChange((checked) => checked && (this.gender = 'male'))
                .margin({ right: 10 })
              Text('男').fontSize(16)

              Radio({ value: 'female', group: 'gender' })
                .checked(this.gender === 'female')
                .margin({ left: 30, right: 10 })
                .onChange((checked) => checked && (this.gender = 'female'))
              Text('女').fontSize(16)
            }
            .width('90%')
            .margin({ bottom: 20 })
            .padding(10)

            // 公司
            Text('公司')
              .fontSize(16)
              .margin({ bottom: 8, left: 20 })
              .width('90%')
              .textAlign(TextAlign.Start)
            TextInput({ text: this.company, placeholder: this.currentUser?.compony })
              .placeholderFont({ size: 16 })
              .type(InputType.Normal)
              .height(50)
              .width('90%')
              .margin({ bottom: 20 })
              .borderRadius(10)
              .backgroundColor(Color.White)
              .padding(10)
              .onChange(value => this.company = value)

            // 电话
            Text('电话')
              .fontSize(16)
              .margin({ bottom: 8, left: 20 })
              .width('90%')
              .textAlign(TextAlign.Start)
            TextInput({ text: this.phone, placeholder: this.currentUser?.phone })
              .placeholderFont({ size: 16 })
              .type(InputType.PhoneNumber)
              .height(50)
              .width('90%')
              .margin({ bottom: 20 })
              .borderRadius(10)
              .backgroundColor(Color.White)
              .padding(10)
              .onChange(value => this.phone = value)

            // 邮箱
            Text('邮箱')
              .fontSize(16)
              .margin({ bottom: 8, left: 20 })
              .width('90%')
              .textAlign(TextAlign.Start)
            TextInput({ text: this.email, placeholder: this.currentUser?.email })
              .placeholderFont({ size: 16 })
              .type(InputType.Email)
              .height(50)
              .width('90%')
              .margin({ bottom: 20 })
              .borderRadius(10)
              .backgroundColor(Color.White)
              .padding(10)
              .onChange(value => this.email = value)

            // 到达信息标题
            Text('到达信息')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 10, bottom: 15, left: 20 })
              .width('90%')
              .textAlign(TextAlign.Start)

            // 到达方式
            Text('到达方式')
              .fontSize(16)
              .margin({ bottom: 8, left: 20 })
              .width('90%')
              .textAlign(TextAlign.Start)
            TextInput({ text: this.arrive_way, placeholder: '请输入到达方式' })
              .placeholderFont({ size: 16 })
              .type(InputType.Normal)
              .height(50)
              .width('90%')
              .margin({ bottom: 20 })
              .borderRadius(10)
              .backgroundColor(Color.White)
              .padding(10)
              .onChange(value => this.arrive_way = value)


            Text('到达班次')
              .fontSize(16)
              .margin({ bottom: 8, left: 20 })
              .width('90%')
              .textAlign(TextAlign.Start)

            TextInput({ text: this.arrive_train, placeholder:  '请输入车次' })
              .placeholderFont({ size: 16 })
              .type(InputType.Normal)
              .height(50)
              .width('90%')
              .margin({ bottom: 20 })
              .borderRadius(10)
              .backgroundColor(Color.White)
              .padding(10)
              .onChange(value => this.arrive_train = value)


            // 到达时间
            Text('到达时间')
              .fontSize(16)
              .margin({ bottom: 8, left: 20 })
              .width('90%')
              .textAlign(TextAlign.Start)
            TextInput({ text: this.arrive_time, placeholder: '请选择到达时间' })
              .placeholderFont({ size: 16 })
              .type(InputType.Normal)
              .height(50)
              .width('90%')
              .margin({ bottom: 30 })
              .borderRadius(10)
              .backgroundColor(Color.White)
              .padding(10)
              .onChange(value => this.arrive_time = value)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .layoutWeight(1)

        Text(this.create_time)
          .fontSize(16)
          .margin({ bottom: 8, left: 20 })
          .width('90%')
          .textAlign(TextAlign.Start)
        // 提交按钮
        Button('提交报名', { type: ButtonType.Capsule })
          .width('90%')
          .height(50)
          .fontSize(18)
          .margin({ bottom: 30 })
          .backgroundColor('#0A59F7')
          .onClick(() => this.onSubmit())
          .enabled(!this.isSaving)

      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
      .alignItems(HorizontalAlign.Center)


    }
    .hideTitleBar(true)
  }
}