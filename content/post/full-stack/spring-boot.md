---
title: "Spring Boot 筆記"
date: 2024-05-06T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: ["framework", "java"]
categories : ["full-stack"]
---

## Spring
### IoC
- Invocation of Constructor
  - 把物件交給 Spring 管理
  - loose coupling
  - Dependency Injection
- Bean
  - 給 Spring 管理的物件
  - 創建方法
    - @Component
      - 創建出的 Bean 名字是 class 的開頭轉小寫
  - 注入方法
    - @Autowired
      - 種類
        - field injection
          - spring boot 會先建立所有 component，在逐一注入，使元件可能短暫處於初始化不完整狀態
        - constructor injection
          - 建立 bean 時就注入
          - 確保 component 被使用時是處於完整的狀態
          - 有利於 unit test，因為可以把設計好的 mock bean 從 constructor 傳入
          - spring 建議使用 constructor injection
      - 限制
        1. 該 Class 也得是 Bean
        2. 會根據類型注入 bean
           - 如果同時有多個同類型的 bean，會報錯，可以用 @Qualifier 指定要注入的 bean 名稱
      - @Qualifier
        - 指定要注入的 bean 名稱 
      - @Primary
        - 如果有多個同類型的 bean，會優先注入這個 bean  
  - 初始化
    - @PostConstruct
      - 創建 bean 後，就會執行這個方法
      - 限制
        - 必須是 public void
        - 不能有參數

### AOP
- Aspect Oriented Programming
- 透過 Aspect 統一處理不同方法的共同邏輯
- 要導入 aop 的 starter
- 只有 Bean 才能設置 @Aspect
- Annotation
  - @Aspect
    - 這個 class 是一個切面
  - @Before
    - 加上切入點，就可以在切入點 (Pointcut) 的方法執行前執行
  - @After
    - 在方法之後執行
  - @Around
    - 在方法之前和之後都執行
- 常用的功能都已經被封裝好了，開發較少用到 AOP

## 特性
### Starter
- [Spring Boot Starters](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#using.build-systems.starters)

官方的 starter 命名是 `spring-boot-starter-*`
第三方的 starter 命名是 `*-spring-boot-starter`

### 外部化配置
- `application.properties`
  - 重新啟動 jar 時會自動載入，不用改配置要重新 build jar
  - 集中管理
  - @Value
    - 可以注入到變數中
    - 可以用 `:` 來設定預設值
    - 限制
      - 只能在 Bean 和 Configuration 中使用
  - YAML
    - application.properties 寫多後，沒有層級辨識度
    - application.yml
- profiles
  - 可以根據不同的環境來設定不同的配置 (dev, test, prod)
  - `application-{profile}.properties`
  - `application-{profile}.yml`
  - `spring.profiles.active`
    - 指定啟用的 profile
  - jar
    - `-Dspring.profiles.active=dev`
- 指定配置文件
  - cli
    - `--spring.config.location`
- Config 資料夾
  - 可以在 jar 目錄下建立 config 資料夾，放配置文件，不用輸入額外的 args
    

### Dependency Management
- parent 寫了版本號，故 dependency 可以不用寫版本號
- 真的要指定的話，可以利用 maven 的就近原則

### Auto Configuration
- Component Scan
  - Spring Boot 會掃描主程式所在的 package 以及子 package
  - 也可以在主程式上加以下註解來指定掃描的 package
    - `@SpringBootApplication(scanBasePackages = "com.example")`
  - 所有 starter 都有 `spring-boot-starter`，`spring-boot-starter` 又有 `spring-boot-autoconfigure`，這個就是自動配置的地方
- spring boot 默認掃描不到 spring-boot-autoconfigure 的所有配置類 (因為預設只掃描 Main Application Class 的 package)，但是 @SpringBootApplication 的 @EnableAutoConfiguration 會預設掃描 spring-boot-autoconfigure 的所有配置類
  - 它們再依據 conditional annotation 來決定是否要啟用這個配置類

## Common Annotations
Spring Boot 放棄了 XML 配置，改用 Annotation 配置

### Component registration
- @Configuration, @SpringBootConfiguration
  - @Bean
- @Controller, @Service, @Repository, @Component
  - 三層式架構
    - @Controller
      - 用來處理請求
    - @Service
      - 用來處理業務邏輯
    - @Repository
      - 用來處理資料庫操作
- @SpringBootApplication
  - 由以下組成
    - @SpringBootConfiguration
    - @EnableAutoConfiguration
    - @ComponentScan
- Web
  - @RestController
    - @Controller + @ResponseBody
  - @RequestMapping
    - 設置 route
    - Method
      - @GetMapping
      - @PostMapping
      - @PutMapping
      - @DeleteMapping
      - @PatchMapping
  - 取得參數
    - @RequestParam
      - 取得 url 中的參數
    - @RequestBody
      - 取得 request body
      - 根據欄位名字調用對應的 setter
    - @RequestHeader
      - 取得 header
    - @PathVariable
      - 取得 route 中的參數
- @Scope
  - mode
    - singleton
      - 預設，共用一個 instance
    - prototype
      - 每次注入都創建新的 instance
      - 可以用 proxy.mode = ScopedProxyMode.TARGET_CLASS，會變成每次調用 method 都創建新的 instance
      - prototype 的元件生出後，spring 不會再管理，要自己管理生命週期，相當於 new 出物件的替代作法
    - request
      - 每個 request 都有一個獨立的 instance
      - request 指的是 HTTP request，從進入 controller 到離開 controller
### Conditional Annotations
- 條件成立則觸發指定行為
- ConditionalOn<Condition>
  - example
    - ConditionalOnClass
      - 如果 classpath 有指定的 class 才會觸發
    - ConditionalOnMissingClass
      - 如果 classpath 沒有指定的 class 才會觸發
    - ConditionalOnBean
      - 如果容器中有指定的 bean 才會觸發
    - ConditionalOnMissingBean
      - 如果容器中沒有指定的 bean 才會觸發
  - Scenario
    - 如果有某個 dependency，則創建某個 bean

### Property Binding
- 把任意 Bean 的 property 與配置文件 (application.properties) 中的 property 綁定
- annotations
  - @ConfigurationProperties
    - prefix
  - @EnableConfigurationProperties
    - 如果 class 只有 @ConfigurationProperties，沒有 @Component，需要加這個 annotation
    - 用在第三方 package 上，因為默認掃不到第三方的 @component

## Logging
- Logging 選擇
  - Logging API
    - JCL
    - SLF4J (Simple Logging Facade for Java)
    - jboss-logging
  - Logging implementation
    - Logback
    - Log4j2
    - JUL (java.util.logging)
  - Spring Boot 預設使用 Logback 和 SLF4J

- spring-boot-starter 引用了 spring-boot-starter-logging

### Log Format
- Default example
  - ```
    2024-05-06T19:21:40.751+08:00  INFO 22932 --- [demo] [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port 8080 (http) with context path ''
    ```
    - 時間, 日誌等級, pid, 分割符, thread, logger, message

### Log Level
- Type (由低到高)
  - ALL
  - TRACE
    - 一般不用
  - DEBUG
  - INFO
  - WARN
  - ERROR
  - FATAL
  - OFF
- 會 print 出比設定的等級高的 log

### Log Configuration
- logging.level.*
  - 設定不同 package 的 log 等級
  - ```
    logging.level.com.example=DEBUG
    ```

- logging.group.<groupname>
  - 把多個 package 放在一組，可以統一設定
  - 預設有 web, sql 組

- logging.file
  - .name
    - 檔名

- 歸檔 and 切割
  - 歸檔
    - 每天單獨存
    - .logback.rolllingpolicy.file-name-pattern
  - 切割
    - 超過指定大小就切割
    - .logback.rolllingpolicy.max-file-size

## Filter
- 實做 javax.servlet.Filter，就能註冊為 spring 的 filter
- OncePerRequestFilter
  - 保證一次 request 只會執行一次
  - doFilterInternal
    - chain.doFilter(request, response)
      - 這行之後代表後面的 filter 都執行完了
      - 如果只有一個 filter，就代表 controller 執行完了
  - shouldNotFilter
    - 可以設定不要執行的 url pattern

### 註冊 Filter
- 流程
  - 設定 @Configuration
  - 加到 Bean
    - <option> setUrlPatterns
      - 只有符合 url pattern 的 request 才會經過這個 filter
    - <option> setOrder
      - 決定 filter 的順序
- 如果 filter 要取得 request 和 response 的內容，可以用 ContentCachingRequestWrapper 和 ContentCachingResponseWrapper 重新包裝
  - 因為原本的作法是用 stream 讀取資料，只能讀一次

- @WebFilter
  - 屬於 Java servlet 而非 Spring
    - 要在 application 補上 @ServletComponentScan
  - 可以直接註冊 filter

## Spring Security
- 名詞
  - Authentication
    - 認證
      - 檢查是不是系統的使用者，以及是哪個使用者
  - Authorization
    - 授權
      - 檢查使用者有沒有權限做某件事
### 流程
- filter chain
  - example
    - UsernamePasswordAuthenticationFilter
      - 檢查使用者名稱和密碼
    - ExceptionTranslationFilter
      - 處理例外
    - FilterSecurityInterceptor
      - 檢查授權
  - authorizeHttpRequests
    - 設定哪些 request 需要什麼權限

- example: JWT 驗證流程
  - 先透過 filter chain 經過 JWT filter
  - 透過 UserDetailsService 取得使用者資訊
  - 驗證使用者資訊
  - 更新 SecurityContextHolder
    - 用來判斷使用者是否已經通過 authentication

### Configuration
- @EnableWebSecurity
  - 啟用 web security
- example
  - ```java
    @Configuration
    @EnableWebSecurity
    public class SecurityConfig {
        @Bean
        public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
            http.authorizeHttpRequests((requests) -> {
                ((AuthorizeHttpRequestsConfigurer.AuthorizedUrl)requests.anyRequest()).authenticated();
            });
            http.httpBasic(Customizer.withDefaults());
            return (SecurityFilterChain)http.build();
        }
    }
    ```
      - 把 Spring Boot 預設實作的 fitler chain 的 @Order 拿掉，這是決定誰的優先序高
      - 也把 formLogin 拿掉，就不會有登入頁面

### UserDetails
- 實現 UserDetailsService 的 Bean 可以被用來取得 UserDetails
- implements UserDetails
  - getAuthorities
  - getUsername
  - getPassword
  - isAccountNonExpired
  - isAccountNonLocked
  - isCredentialsNonExpired
  - isEnabled

### SecurityContextHolder
- 用來存放 authentication

## JPA
- Java Persistence API
- Annotation
  - @Entity, @Table
    - 也要記得寫 getter, setter
  - @Transient
    - 不會被序列化，不會被存到資料庫
    - 可用在可以單獨計算的欄位，比如用資料庫的生日可以算出年齡
  - @Transactional
- 語法範例
  - findByXxx
    - 用 XXX 的欄位來查詢
  - findByXXXLike
    - 用 XXX 的欄位來模糊查詢

### Repository
- @Repository
  - 用來標記 DAO
  - extends JpaRepository<Entity, ID>
    - 第一個參數是 entity
    - 第二個參數是 entity 的 id 的型態
  - 可以自定義方法
    - 遵循命名規則，他會自己轉 SQL
    - 也可以用 @Query 來自定義 SQL
      - <?0> 代表第一個參數，以此類推

## Validation
- field validation
  - @NotEmpty
  - @Min
  - @Max

- @Valid
  - 用在 controller 上，才會自動檢查參數

## Testing
### Integration Test
- 在 test class 前面的 annotation
  - @RunWith(SpringRunner.class)
  - @SpringBootTest
  - @AutoConfigureMockMvc
    - 測試開始時會在容器中創建 MockMvc
- 在 test method 前面加的 annotation
  - @Test
  - @Before, @After
    - 在每個測試前後執行，可以用來清空資料庫和設置 header

#### MockMvc
- 用來模擬 HTTP request
- example
  - ```java
    @Autowired
    private MockMvc mockMvc;

    @Test
    public void test() throws Exception {
        mockMvc.perform(get("/hello"))
            .andExpect(status().isOk())
            .andExpect(content().string("Hello World"));
    }
    ```

## 其他
### Lombok
- @Getter, @Setter
  - 生成 getter, setter
- @ToString
  - 印出所有變數
- @EqualsAndHashCode
  - 生成 equals, hashCode
- Args
  - @NoArgsConstructor
    - 生成無參數建構子
  - @AllArgsConstructor
    - 生成所有參數建構子
  - @RequiredArgsConstructor
    - 只幫 final 變數生成建構子
- @Data
  - 同時用 @Getter, @Setter, @ToString, @EqualsAndHashCode, @RequiredArgsConstructor
- @Value
  - 把所有變數都設成 final
  - 同時用 @Getter, @ToString, @EqualsAndHashCode, @RequiredArgsConstructor
  - 和 Spring boot 的 @Value 撞名
- @Builder
  - 生成 builder pattern
- @Slf4j
  - 生成 log 變數

### Jackson
- ObjectMapper
  - 用來轉換物件和 JSON
  - readValue
    - 把 JSON 轉成物件
- 用 getter, setter 來判斷欄位
- Annotation
  - @JsonIgnore
    - 不轉換
  - @JsonProperty
    - 指定欄位名字
  - @JsonUnwrapped
    - 把物件的欄位展開，從巢狀變成平面
  - @JsonInclude
    - 設定要不要轉換 null
    - 如果設定為 Include.NON_NULL，給 null 的話，就不會轉換
  - @JsonFormat
    - 設定日期格式