---
title: "Angular 筆記"
date: 2024-05-24T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: ["framework", "javascript"]
categories : ["full-stack"]
---

## 基礎概念
### Module
- 把相關的 Component、Directive、Pipe、Service 等打包在一起的容器
- Lazy Loading
### Component
- Angular 應用程式的基本組成單位
### Pipe
- 用來轉換資料的工具，可以把字串格式化、日期格式化等
### Directive
- 用來修改 DOM 元素的外觀或行為
  - 比如說 ngIf、ngFor、ngStyle、ngClass
  - 類型
    - Structural Directive: 修改 DOM 的結構
      - 可以搭配
        - `ng-container`
          - 不會產生額外的 DOM 元素，可以用在想要用 ngIf 和 ngFor 但不想產生額外元素的情況
      - `*ngFor`
        - `let item of items; index as i`
    - Attribute Directive: 修改 DOM 的屬性
    - Component Directive: 包含 template 的 directive
### Service
- 負責 API 請求、資料處理等工作
- Dependency Injection
- @Injectable
  - providedIn
    - root: 全域共用
    - 也可以在 component 的 providers 中設定要注入的 service
### Router
- 負責處理 URL 路由
- routes
  - path
  - component
  - <canActivate>
    - 可以設定 guard
- guard
  - `ng g guard <guard-name>`
    - CanActivate
      - 


## CLI Command
- `ng new my-app`: 建立新的 Angular 專案
- `ng serve`: 啟動開發伺服器
- `ng build`: 打包專案
- generate
  - `ng generate module my-module`: 建立新的 Module
  - `ng generate component my-component`: 建立新的 Component
    - `--module=app`: 指定 Component 所屬的 Module
  - `ng generate service my-service`: 建立新的 Service
  - `ng generate pipe my-pipe`: 建立新的 Pipe
  - `ng generate directive my-directive`: 建立新的 Directive

## Module
- NgModule
  - declarations: 定義同一 Module 中的 Component、Directive、Pipe
  - imports: 匯入其他 Module
  - providers: 定義 Service
  - bootstrap: 定義啟動的 Component
  - exports: 定義要匯出的 Component、Directive、Pipe

## Component
- 包含元素
  - Template
  - TypeScript Class
    - .spec.ts: 測試檔
  - Selector: 定義 Component 的名稱
  - CSS Style
- standalone
  - 新版 Angular 預設 app 使用 Standalone 模式，使 component 不再需要透過 NgModule 管理

## Lifecycle Hooks
- ngOnChanges
  - 當 Angular 重新綁定輸入屬性時調用
- ngOnInit
  - 當 Angular 初始化指令/元件時調用
  - 在第一輪 ngOnChanges 後調用
  - 只調用一次
  - 使用場景
    - 初始化資料（需要根據 @Input 變數）
    - fetch data from API
- ngDoCheck
  - 在 ngOnChange 和 ngOnInit 之後調用
- ngAfterContentInit
  - 在 Angular 把 ng-content 投影到 view 後調用
  - 在第一個 ngDoCheck 之後調用
- ngAfterContentChecked
  - 在 ng-content 的內容變更後調用
- ngAfterViewInit
  - 在 Angular 初始化完 view 後調用
- ngAfterViewChecked
  - 在每次做完 view 的變更檢查後調用
- ngOnDestroy
  - 在 Angular 銷毀 directive/component 前調用

### Component check
- 操作
  - update child component input binding
  - update DOM interpolation
  - update query list

## Sharing Data
- @Input
  - 父元件傳遞資料給子元件
- @Output
  - 子元件傳遞資料給父元件

## Binding
### Property Binding
- 用來設定 HTML 元素的屬性
- 用中括號 `[]` 包住屬性名稱
- ex: `<img [src]="imageUrl">`
### Event Binding
- 用來設定 HTML 元素的事件
- 用小括號 `()` 包住事件名稱
- ex: `<button (click)="onClick()">`
- `$event`: 可以取得事件物件
### Two-way Binding
- 把屬性和事件綁定在一起
- 用中括號和小括號 `[(ngModel)]` 包住屬性名稱
- ex: `<input [(ngModel)]="name">`