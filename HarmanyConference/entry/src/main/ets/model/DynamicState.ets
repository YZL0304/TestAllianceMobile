import Dynamics from "./Dynamics";
import { User } from '../model/User';


export class DynamicState {
  // 当前选中的课程
  private _selectedDynamics: Dynamics | null = null;
  private currentUser: User | null = null;

  private constructor() {}

  get selectedDynamics(): Dynamics | null {
    return this._selectedDynamics;
  }
  set selectedDynamics(dynamics: Dynamics | null) {
    this._selectedDynamics = dynamics;
  }
  // 单例模式
  private static instance: DynamicState;
  static getInstance(): DynamicState {
    if (!DynamicState.instance) {
      DynamicState.instance = new DynamicState();
    }
    return DynamicState.instance;
  }

  public setCurrentUser(user: User | null): void {
    this.currentUser = user;
  }

  public getCurrentUserId(): number | null {
    const user_id = this.currentUser?.user_id; // 保持下划线
    return user_id ? parseInt(user_id, 10) : null;
  }
  public recordVisitTime(dynamicId: number): void {
    // 可以在这里添加本地访问时间记录逻辑
    console.log(`记录动态${dynamicId}的访问时间: ${new Date().toISOString()}`);
  }
}