import Course from '../model/Course'
import { User } from '../model/User';
import { CourseItem } from './CourseItem'

@Component
export struct CourseView {
  // 使用 @Prop 管理数据
  @Prop courses: Course[] = [];

  // 修改1: 添加@Prop声明回调函数
  private  onCourseClick: (course: Course) => void = () => {};

  @StorageLink('currentUser') currentUser: User | null = null;

  // 选中的日期状态
  @Prop selectedDate: Date = new Date();

  // 更新选中日期
  onDateSelected(date: Date) {
    this.selectedDate = date;
  }

  build() {
    Column() {
      List() {
        ForEach(this.courses.filter(course => course.status.includes(this.currentUser!.user_id)), (course: Course) => {
          ListItem() {
            CourseItem({
              course: course,
              // 修改2: 正确传递回调函数
              onItemClick: () => {
                this.onCourseClick(course);
              }
            })
          }
        }, (course: Course) => course.id)
      }
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 0.5, color: 0xEEEEEE })
      .edgeEffect(EdgeEffect.Spring)
    }
  }
}