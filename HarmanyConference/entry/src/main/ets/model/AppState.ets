import Course from "./Course";
import Dynamics from "./Dynamics";

export class AppState {
  // 当前选中的课程
  private _selectedCourse: Course | null = null;

  get selectedCourse(): Course | null {
    return this._selectedCourse;
  }
  set selectedCourse(course: Course | null) {
    this._selectedCourse = course;
  }
  private _selectedDynamics: Dynamics | null = null;

  get selectedDynamics(): Dynamics | null {
    return this._selectedDynamics;
  }
  set selectedDynamics(dynamics: Dynamics | null) {
    this._selectedDynamics = dynamics;
  }
  // 单例模式
  private static instance: AppState;
  static getInstance(): AppState {
    if (!AppState.instance) {
      AppState.instance = new AppState();
    }
    return AppState.instance;
  }
}