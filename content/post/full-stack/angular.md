---
title: "Angular 筆記"
date: 2024-05-24T00:00:17+08:00
draft: true
description: ""
type: "post"
tags: ["framework", "javascript"]
categories : ["full-stack"]
---

## 基礎概念
### Module
- 把相關的 Component、Directive、Pipe、Service 等打包在一起的容器
- 可以使用 Lazy Loading 延遲加載模組，提高效能

### Component
- Angular 應用程式的基本組成單位
- 由 HTML、CSS、TypeScript 共同組成
- 具有自己的 `@Component` 裝飾器

### Pipe
- 用來轉換資料的工具，可以用於字串格式化、日期格式化等
- 可以透過 `|` 符號在模板中使用，例如 `{{ value | uppercase }}`
- 內建 Pipes：`date`、`uppercase`、`lowercase`、`currency`、`percent` 等
- 可以建立自訂 Pipe

### Directive
- 用來修改 DOM 元素的外觀或行為
  - 例如 `ngIf`、`ngFor`、`ngStyle`、`ngClass`
  - 分為三種類型：
    - **Structural Directive**: 修改 DOM 的結構
      - `*ngIf`, `*ngFor`, `*ngSwitch`
      - 可搭配 `ng-container`
        - 不會產生額外的 DOM 元素，適合在 `ngIf` 和 `ngFor` 不希望產生額外元素時使用
      - `*ngFor` 例子：`let item of items; index as i`
    - **Attribute Directive**: 修改 DOM 的屬性，例如 `ngClass`, `ngStyle`
    - **Component Directive**: 包含 template 的 directive
### Service
- 負責 API 請求、資料處理等工作
- 透過 **Dependency Injection (DI)** 來提供服務
- `@Injectable()` 裝飾器用來標記服務
  - `providedIn`
    - `root`: 服務將在整個應用程式中可用
    - 也可以在特定 Module 或 Component 的 `providers` 中設定要注入的 Service

### Router
- 負責處理 URL 路由
- 設定路由時使用 `routes` 陣列
  - `path`: 定義路徑
  - `component`: 指定對應的 Component
  - `canActivate`: 設定路由守衛 (Guard)
- 路由守衛 (Guard)
  - 透過 `ng g guard <guard-name>` 來產生
  - `CanActivate`:
    - 控制是否允許使用者進入某個路由
    - 適合用來驗證使用者權限

## CLI Command
- `ng new my-app`: 建立新的 Angular 專案
- `ng serve`: 啟動開發伺服器
- `ng build`: 打包專案
- `ng generate` (縮寫 `ng g`)
  - `ng g module my-module`: 建立新的 Module
  - `ng g component my-component`: 建立新的 Component
    - `--module=app`: 指定 Component 所屬的 Module
  - `ng g service my-service`: 建立新的 Service
  - `ng g pipe my-pipe`: 建立新的 Pipe
  - `ng g directive my-directive`: 建立新的 Directive

## Module
- `@NgModule()`
  - `declarations`: 定義同一 Module 中的 Component、Directive、Pipe
  - `imports`: 匯入其他 Module
  - `providers`: 定義 Service
  - `bootstrap`: 定義應用程式啟動時的根 Component
  - `exports`: 定義要匯出的 Component、Directive、Pipe

## Component
- 包含的主要部分：
  - **Template**: HTML 模板
  - **TypeScript Class**: 包含 Component 的邏輯與屬性
  - **Selector**: 定義 Component 在 HTML 中的名稱
  - **CSS Style**: 樣式
  - **.spec.ts**: 測試檔案
- **Standalone Component**
  - Angular 新版預設採用 Standalone Component 模式
  - Component 不再需要透過 `NgModule` 管理

## Lifecycle Hooks
- `ngOnChanges`: 當輸入屬性變更時調用
- `ngOnInit`: 組件初始化時調用（僅執行一次）
- `ngDoCheck`: 手動偵測變更
- `ngAfterContentInit`: `ng-content` 投影完成後調用
- `ngAfterContentChecked`: `ng-content` 內容變更後調用
- `ngAfterViewInit`: `ViewChild`、`ViewChildren` 初始化後調用
- `ngAfterViewChecked`: 每次檢查變更後調用
- `ngOnDestroy`: 組件銷毀前調用，可用於取消訂閱與清除資源

## Sharing Data (資料傳遞)
- `@Input`: 父元件傳遞資料給子元件
- `@Output`: 子元件透過 `EventEmitter` 傳遞資料給父元件
- 其他方式：
  - 透過 **Service** 和 **RxJS** Subject/BehaviorSubject 來進行資料共享

## Data Binding (資料綁定)
### Property Binding (屬性綁定)
- 用來設定 HTML 元素的屬性
- 使用中括號 `[]` 包住屬性名稱
- 範例：
  ```html
  <img [src]="imageUrl">
  ```

### Event Binding (事件綁定)
- 用來設定 HTML 元素的事件
- 使用小括號 `()` 包住事件名稱
- 範例：
  ```html
  <button (click)="onClick()">Click Me</button>
  ```
- `$event`: 取得事件物件
  ```html
  <input (input)="onInput($event)">
  ```

### Two-way Binding (雙向綁定)
- 屬性與事件綁定結合在一起
- 使用 `[(ngModel)]` 綁定表單輸入
- 需要匯入 `FormsModule`
- 範例：
  ```html
  <input [(ngModel)]="name">
  ```