import { DataClass } from '../model/DataClass';

@Component
export struct CalendarView {
  @State private currentDate: Date = new Date();
  @State private weekDates: DataClass[] = [];
  private weekDays: string[] = ['日', '一', '二', '三', '四', '五', '六'];

  // 添加选中日期状态
  @Link selectedDate: Date;

  // 添加回调函数用于通知父组件日期变化
  onDateSelected : (date:Date) => void = () => {}

  aboutToAppear() {
    if (!this.currentDate) {
      this.currentDate = new Date();
    }
    this.updateWeekDates();
  }

  private updateWeekDates() {
    this.weekDates = this.getWeekDates();
  }

  private isSameDay(date1: Date, date2: Date): boolean {
    return date1.getFullYear() === date2.getFullYear() &&
      date1.getMonth() === date2.getMonth() &&
      date1.getDate() === date2.getDate();
  }

  private getWeekDates(): DataClass[] {
    const dates: DataClass[] = [];
    const today = new Date();
    const current = new Date(this.currentDate);

    current.setDate(current.getDate() - current.getDay());

    for (let i = 0; i < 7; i++) {
      const date = new Date(current);
      date.setDate(date.getDate() + i);

      const isToday = this.isSameDay(date, today);
      const isCurrentMonth = date.getMonth() === this.currentDate.getMonth();
      const isSelected = this.isSameDay(date, this.selectedDate);

      dates.push(new DataClass(
        date.getDate(),
        isCurrentMonth,
        isToday,
        isSelected,
        date // 存储完整日期对象
      ));
    }
    return dates;
  }

  private changeWeek(delta: number): void {
    const newDate = new Date(this.currentDate);
    newDate.setDate(newDate.getDate() + delta * 7);
    this.currentDate = newDate;
    this.updateWeekDates();
  }

  // 处理日期点击
  private handleDateClick(item: DataClass): void {
    if (item.date) {
      // 更新选中的日期
      this.selectedDate = new Date(item.date);

      // 通知父组件日期变化
      if (this.onDateSelected) {
        this.onDateSelected(new Date(item.date));
      }

      // 强制刷新UI
      this.updateWeekDates();
    }
  }

  build() {

    // 使用 Column 作为单一根容器
    Column() {
      Row() {
        // 左箭头 (固定在左侧)
        Image($r('app.media.ic_left_arrow'))
          .width(24)
          .height(24)
          .onClick(() => this.changeWeek(-1))
          .margin({ right: 8 }) // 添加右侧间距避免紧贴文本

        // 关键修改：添加空白容器占用空间
        Column() {
          Text(`${this.currentDate.getFullYear()}年${this.currentDate.getMonth()+1}月`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .layoutWeight(1) // 使用权重填充中间空间
        .justifyContent(FlexAlign.Center) // 内容居中
        .alignItems(HorizontalAlign.Center)

        // 右箭头 (固定在右侧)
        Image($r('app.media.ic_right_arrow'))
          .width(24)
          .height(24)
          .onClick(() => this.changeWeek(1))
          .margin({ left: 8 }) // 添加左侧间距避免紧贴文本
      }
      .width('100%') // 关键：容器必须设置100%宽度
      .justifyContent(FlexAlign.SpaceBetween) // 均匀分布元素
      .height(40)
      .padding({left:12,right:12})

      // 星期标题 - 确保与日期对齐
      Row() {
        ForEach(this.weekDays, (day: string) => {
          Text(day)
            .fontSize(14)
            .fontWeight(500)
            .textAlign(TextAlign.Center)
            .fontColor('#666666')
            .layoutWeight(1) // 每个元素均匀分配空间
        })
      }
      .width('100%')
      .padding({ left: 8, right: 8 }) // 添加内边距
      .margin({ bottom: 10 })
      .height(30)


      Row() {
        ForEach(this.weekDates, (item: DataClass) => {
          Column() {
            Text(item.data > 0 ? item.data.toString() : '')
              .fontSize(16)
              .fontWeight(item.isToday ? FontWeight.Bold : FontWeight.Normal)
              .fontColor(item.isToday || item.isSelected
                ? '#FFFFFF'
                : item.isCurrentMonth
                  ? '#000000'
                  : '#CCCCCC')
          }
          .layoutWeight(1) // 均匀分配宽度
          .width('100%')
          .height(40)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor(item.isToday
            ? '#007AFF'
            : item.isSelected
              ? '#DDDDDD'  // 选中状态使用灰色背景
              : 'transparent')
          .borderRadius(20)
          .onClick(() => this.handleDateClick(item))
        })
      }
      .width('100%')
      .padding({ left: 8, right: 8 }) // 添加内边距
    }
    .width('100%')
    .padding({ top: 15, bottom: 15 })
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ left: 16, right: 16, top: 10 })
    .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: 2 })
  }
}