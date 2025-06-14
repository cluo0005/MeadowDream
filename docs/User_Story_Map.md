# User Story Map - Meadow Dream

## 1. User Story Map Overview

This user story map visualizes the core activities, tasks, and supporting user stories for the "Meadow Dream" iOS app. It helps the team better understand user needs, plan feature priorities, and ensure a user-centered development process, with special attention to iOS platform features, Firebase integration, and the delivery of Wellness value.

The horizontal axis represents the main sequence of user activities (the backbone of the user journey), while the vertical axis breaks down each activity into specific user tasks and corresponding user stories.

## 2. User Activity Flow (Activities - Horizontal Backbone)

| **Core User (iOS)** | **Activity 1: Explore & Onboarding (iOS & Firebase)** | **Activity 2: Dream Recording & Management (iOS, Voice, Tag Library)** | **Activity 3: Interpretation & Understanding (Manual Trigger, Wellness)** | **Activity 4: Interaction & Sharing (V1.2+)** | **Activity 5: Personal Growth & Review (Wellness & Guidance)** |
| :----------- | :-------------------- | :---------------------- | :---------------------- | :------------------------- | :------------------------ |
| New iOS User/Visitor  | Learn about app features (Wellness core) |                         |                         |                            |                           |
| Registered iOS User (Firebase) |                       | Record new dream (text/voice)  | **Manually trigger AI interpretation & positive guidance** | (Optional) Share dream/interpretation      | View dream history & Wellness trends |
|              |                       | Edit/delete dream           | Provide feedback on interpretation/guidance    | (Optional) Join community discussion       | Set personalized preferences (iOS)      |
|              |                       | **Use tag library to manage dreams**  | Favorite important interpretations/guidance      |                            | **Receive dream guidance & prediction reminders** |

## 3. User Task Breakdown & User Stories (Tasks & Stories - Vertical Details)

### Activity 1: Explore & Onboarding (iOS & Firebase)

| User Task             | User Story                                                                 | Priority (Roadmap Version) | Notes                       |
| :-------------------------- | :------------------------------------------------------------------------------------ | :-------------------- | :------------------------- |
| Understand product core value (Wellness) | As a **potential iOS user interested in self-exploration and positive psychology**, I want to **quickly understand how "Meadow Dream" helps me improve wellness through dream recording, AI interpretation, and positive guidance**, so I can **decide whether to download and try the app**.              | MVP                   | App Store description (highlight Wellness, iOS features), product intro page, first-launch onboarding       |
| Browse main feature intro            | As a **first-time iOS user**, I want to **learn about the app's core features (e.g., voice/text dream recording, manual AI interpretation & positive guidance, tag library, Firebase account system) through clear onboarding**, so I can **quickly get started**.                        | MVP                   | First-launch onboarding flow (SwiftUI), feature highlight cards |
| View user reviews/feedback (external) | As a potential iOS user, I want to see other users' reviews to judge the product's credibility and effectiveness.                  | N/A                   | App Store reviews           |
| **Register via Firebase** | As a **new iOS user who decides to use the app**, I want to **register easily (email, Sign in with Apple) via Firebase**, so I can **securely save my dream data and use all features**.              | MVP                   | **Firebase Authentication (Email, Sign in with Apple)** |
| **Login via Firebase**    | As a **registered iOS user**, I want to **log in securely and conveniently via Firebase (email/password or Apple ID)**, so I can **access my dreams and personalized settings**.                      | MVP                   | **Firebase Authentication**                            |
| **Password recovery via Firebase**    | As an iOS user, I want to easily recover my account via Firebase if I forget my password, so I can continue using the service. | MVP                   | Firebase Password Reset | 

### Activity 2: Dream Recording & Management (iOS, Voice, Tag Library)

| User Task         | User Story                                                                 | Priority (Roadmap Version) | Notes                               |
| :---------------------- | :------------------------------------------------------------------------------------ | :-------------------- | :--------------------------------- |
| **Create new dream record (text)** | As an **iOS user who wants to record and understand my dreams**, I want to **easily record dream details via text input, including description, date, main emotion, and tags from the tag library or custom tags**, so I can **review, manage, and get interpretation/guidance later, with data stored in Firebase**. | MVP                   | SwiftUI text input, date picker, emotion selection, **tag library integration**, **Firebase Firestore storage** |
| **Create new dream record (voice-to-text)** | As an **iOS user who just woke up or can't type**, I want to **quickly record dreams via voice input, with automatic speech-to-text filling the dream description**, so I can **add details later, with optional voice file storage in Firebase Storage**. | MVP                  | **SFSpeechRecognizer (iOS native speech recognition)**, voice permissions, edit transcribed text |
| Edit recorded dream        | As an iOS user, I want to **easily modify or add to previously recorded dream content, emotion, tags, or date**, so I can **ensure completeness and accuracy**.                  | MVP                   |                                    |
| Delete unwanted dream records    | As an iOS user, I want to **delete unneeded, duplicate, or incorrect dream records**, so I can **keep my dream list tidy**.                                  | MVP                   | Support single/batch delete (batch in V1.1+) |
| View dream list            | As an iOS user, I want to **see all my dream records in reverse chronological order, with title/summary, date, and emotion**, so I can **quickly browse and select dreams to review or act on**.                          | MVP                   | SwiftUI List with date, title/summary, emotion icon |
| Search specific dreams            | As an iOS user, I want to **search all my dreams by keyword (content, tags)**, so I can **quickly find dreams with specific info**.                  | MVP                   | Search bar, support content/tag search (tag search based on tag library) |
| **Use tag library to add/manage tags** | As an iOS user, I want to **use a tag library with preset and custom tags to add one or more tags to my dreams**, so I can **better classify, manage, search, and later analyze patterns and get personalized guidance**. | MVP                   | **Tag library management UI (create, edit, delete tags), tag selector** |
| Mark dream emotion            | As an iOS user, I want to **mark the main emotion (e.g., joy, fear, anxiety, confusion) when recording or after**, so I can **better understand the dream's tone and provide data for emotion pattern analysis and Wellness tracking**. | MVP                   | Preset emotions (emoji+text), single/multi-select (multi in V1.1+) |

### Activity 3: Interpretation & Understanding (Manual Trigger, Wellness)

| User Task         | User Story                                                                     | Priority (Roadmap Version) | Notes                                     |
| :---------------------- | :---------------------------------------------------------------------------------------- | :-------------------- | :--------------------------------------- |
| **Manually trigger AI dream interpretation & positive guidance** | As an **iOS user who wants guidance after recording a dream**, I want to **manually trigger AI analysis and get positive psychological guidance and Wellness advice**, so I can **better understand my dream and improve my mood**. | MVP                   | Clear "Get Interpretation & Guidance" button after recording |
| **View AI interpretation & positive guidance results** | As an iOS user, I want to **see AI-generated dream interpretation and positive guidance in a clear, structured, and understandable way, including summary, symbol analysis, emotion links, positive thinking, and actionable Wellness advice**, so I can **gain inspiration and support**. | MVP                   | Structured display: summary, key symbols, emotion analysis, **positive guidance, Wellness action points** |
| Understand interpretation dimensions (advanced) | As an **iOS user interested in deeper dream interpretation**, I want to **(in advanced version) choose or learn about different psychological/cultural interpretation perspectives and positive psychology methods**, so I can **get richer, multi-layered understanding**. | V1.2 (Advanced)           | (Advanced) Optional models or reference info |
| **Give feedback on AI interpretation & guidance** | As an iOS user, I want to **rate the accuracy, helpfulness, or relevance of AI dream interpretation and positive guidance (e.g., like/dislike, or fit tags)**, so I can **help improve the AI and let developers know its quality**.                | MVP                   | Simple feedback: useful/not, or star rating |
| View dream's interpretation history  | As an iOS user, if I request multiple interpretations for the same dream (e.g., after AI model updates), I want to **easily view all historical interpretations and guidance for that dream**, so I can **compare versions or track deeper understanding**.              | V1.1                  | Show history entry in dream details |
| Favorite valuable dreams/interpretations & guidance | As an iOS user, I want to **favorite or mark as important the dreams and interpretations/guidance that are especially inspiring, important, or interesting**, so I can **quickly find and review them later**.                    | V1.1                  | Favorite/star feature, separate list |
| Get more personalized AI interpretation & guidance (advanced) | As an **iOS user seeking deeper insights**, I am willing to **(in advanced version, with consent) let AI use my long-term dream patterns or limited personal context (e.g., recent stress, focus) for more personalized interpretation/guidance/Wellness plan**. | V1.2 (Advanced) / V2.0+ | (Advanced) User opt-in, privacy emphasized |

### Activity 4: Interaction & Sharing (V1.2+)

| User Task         | User Story                                                                     | Priority (Roadmap Version) | Notes                                     |
| :---------------------- | :---------------------------------------------------------------------------------------- | :-------------------- | :--------------------------------------- |
| (Optional) Anonymously share dream snippet externally | As an iOS user, I may want to **anonymously share an interesting dream snippet (not the full record, de-identified) to my social platforms**, so I can **discuss with friends or groups, but not as an in-app community**.          | V1.2 (Optional/Explore)           | **Use iOS native share sheet**, strictly control content, ensure privacy, not an in-app community |
| (Future) Browse anonymous dream themes | As an **iOS user interested in common dream phenomena**, I may want to **(in future, if a safe community is introduced) browse categorized anonymous dream themes or common symbols**, so I can **gain broader perspective and resonance, not individual dreams**.          | V2.0+ (if community)           | Focus on themes/symbols, not individual privacy |
| (Future) Join themed dream discussions | As an **iOS user wanting to discuss dream experiences**, I want to **(in future, if a safe community is introduced) join managed, anonymous discussions around specific dream themes or symbols**, so I can **benefit from collective wisdom**.                | V2.0+ (if community)                 | Strong moderation, anonymity, theme focus |

### Activity 5: Personal Growth & Review (Wellness & Guidance)

| User Task         | User Story                                                                     | Priority (Roadmap Version) | Notes                               |
| :---------------------- | :---------------------------------------------------------------------------------------- | :-------------------- | :--------------------------------- |
| **View personal dream, emotion & Wellness stats** | As an **iOS user wanting to understand myself and improve Wellness through dreams**, I want to **see stats on my dream records, e.g., most common emotions, tags/keywords, trends over time, positive guidance adoption**, so I can **discover subconscious patterns, emotional fluctuations, and Wellness progress**. | V1.1 (basic stats), V1.2 (advanced/paid) | Chart display (Swift Charts), e.g., emotion pie, tag cloud, frequency line, **Wellness tracking** |
| Review dreams by date/calendar     | As an iOS user, I want to **review all dreams in a date range or via calendar view**, so I can **relate dreams to life events**.                      | V1.1                  | Calendar view, date range filter |
| **Receive dream guidance & prediction reminders (Wellness)** | As an iOS user, I want to **receive personalized positive guidance, coping tips, or sleep improvement reminders in certain situations (e.g., after a series of anxious dreams, or per my goals)**, to help me adjust mindset and improve Wellness. | V1.1 (basic), V1.2 (personalized/prediction) | **Triggered by Firebase Functions backend, iOS local notifications**, careful trigger/guidance design, user control emphasized |
| Set app preferences & notifications      | As an iOS user, I want to **set preferences like daily dream reminder time, positive guidance frequency/type, notification toggles, theme (e.g., dark mode)**, so the app fits my habits and Wellness needs.                        | V1.1 (reminders), V1.2 (theme) | Settings: reminders, notification mgmt, appearance (iOS dark mode) |
| (Future) Export personal dream data  | As an **iOS user who values data ownership**, I may want to **(in future) export all my dream records and related interpretations/guidance (with consent) in common formats (e.g., JSON, CSV)**, for backup or analysis elsewhere.                              | V2.0+                 | Ensure export is secure, clear format, inform user of data content |

## 4. Story Priority & Version Mapping

Detailed mapping is reflected in the "Priority (Roadmap Version)" column above and aligns with the version planning in the [Product Roadmap](./Roadmap.md).

**Priority definitions (same as PRD and Roadmap):**

-   **MVP (iOS - Meadow Dream):** Core product features, forming the minimum viable product to validate the core Wellness value proposition. Includes Firebase account, text/voice dream recording, basic tag library, manual AI interpretation & initial positive guidance.
-   **V1.1:** Important enhancements and UX optimizations to improve retention and Wellness effect. Includes enhanced AI guidance, comprehensive tag management, stats/review, proactive guidance reminders, etc.
-   **V1.2:** Further feature improvements and exploration of monetization and deeper user value, possibly including more personalized prediction/guidance and initial sharing features.
-   **V2.0+:** Long-term direction, possibly including advanced AI, content ecosystem, safe community interaction, with priorities adjusted dynamically based on earlier data and feedback.

*(This map will be updated continuously as the product evolves and user feedback is collected)* 


# 用户故事地图 (User Story Map) - Meadow Dream

## 1. 用户故事地图概述

本用户故事地图旨在通过可视化方式，梳理“Meadow Dream”iOS应用用户的核心活动、任务以及支撑这些任务的用户故事。它将帮助团队更好地理解用户需求，规划产品功能优先级，并确保开发过程以用户为中心，特别关注iOS平台特性、Firebase集成以及Wellness价值的传递。

地图的横向轴代表用户在产品中的主要活动序列（用户旅程的骨干），纵向轴则分解每个活动下的具体用户任务和对应的用户故事。

## 2. 用户活动流 (Activities - 横向骨干)

| **核心用户 (iOS)** | **活动1: 探索与初识 (iOS & Firebase)** | **活动2: 记录与管理梦境 (iOS, 语音, 标签库)** | **活动3: 获取与理解解读 (手动触发, Wellness)** | **活动4: 互动与分享 (V1.2+)** | **活动5: 个人成长与回顾 (Wellness & 引导)** |
| :----------- | :-------------------- | :---------------------- | :---------------------- | :------------------------- | :------------------------ |
| 新iOS用户/访客  | 了解应用功能 (Wellness核心) |                         |                         |                            |                           |
| 注册iOS用户 (Firebase) |                       | 记录新梦境 (文本/语音)  | **手动触发AI解读与积极引导** | (可选)分享梦境/解读      | 查看历史梦境与Wellness趋势 |
|              |                       | 编辑/删除梦境           | 对解读与引导进行反馈    | (可选)参与社区讨论       | 设置个性化偏好 (iOS)      |
|              |                       | **使用标签库管理梦境**  | 收藏重要解读与引导      |                            | **接收梦境引导与预测提醒** |

## 3. 用户任务分解与用户故事 (Tasks & Stories - 纵向细节)

### 活动1: 探索与初识 (iOS & Firebase)

| 用户任务 (Task)             | 用户故事 (User Story)                                                                 | 优先级 (Roadmap 版本) | 备注                       |
| :-------------------------- | :------------------------------------------------------------------------------------ | :-------------------- | :------------------------- |
| 了解产品核心价值 (Wellness) | 作为一名**对自我探索和积极心理感兴趣的潜在iOS用户**，我想要**快速了解“Meadow Dream”如何通过梦境记录、AI解读与积极引导帮助我提升个人福祉(wellness)**，以便**决定是否下载和尝试使用这款应用**。              | MVP                   | App Store描述 (突出Wellness, iOS特性)、产品介绍页、首次启动引导       |
| 浏览主要功能介绍            | 作为一名**首次打开应用的iOS新用户**，我想要**通过清晰简洁的引导了解应用的核心功能（如语音/文本记录梦境、手动AI解读与积极引导、标签库、Firebase账户体系）**，以便**快速上手并开始使用**。                        | MVP                   | 首次启动时的引导流程 (SwiftUI实现)、功能亮点介绍卡片 |
| 查看用户评价与反馈 (外部) | 作为一名潜在iOS用户，我想要查看其他用户的评价，以便判断产品的可信度和效果。                  | N/A                   | App Store评论区           |
| **使用Firebase完成用户注册** | 作为一名**决定使用应用的iOS新用户**，我想要**通过简单快捷的方式（如邮箱注册、Sign in with Apple）使用Firebase完成注册**，以便**安全地保存我的梦境数据并使用应用的全部功能**。              | MVP                   | **Firebase Authentication (Email, Sign in with Apple)** |
| **使用Firebase登录应用**    | 作为一名**已注册的iOS用户**，我想要**通过输入账号密码或使用已绑定的Apple ID通过Firebase安全方便地登录应用**，以便**访问我记录的梦境和个性化设置**。                      | MVP                   | **Firebase Authentication**                            |
| **通过Firebase找回密码**    | 作为一名iOS用户，我想要在忘记密码时能通过Firebase的机制方便地找回账户，以便继续使用服务。 | MVP                   | Firebase Password Reset |

### 活动2: 记录与管理梦境 (iOS, 语音, 标签库)

| 用户任务 (Task)         | 用户故事 (User Story)                                                                 | 优先级 (Roadmap 版本) | 备注                               |
| :---------------------- | :------------------------------------------------------------------------------------ | :-------------------- | :--------------------------------- |
| **新建梦境记录 (文本)** | 作为一名**希望记录和理解自己梦境的iOS用户**，我想要**轻松便捷地通过文本输入记录下我的梦境细节，包括梦境内容描述、发生日期、我的主要情绪以及从标签库选择或创建的标签**，以便**后续进行回顾、管理和获取解读与引导，数据存储于Firebase**。 | MVP                   | SwiftUI 文本输入、日期选择器、情绪选择、**与标签库集成**、**Firebase Firestore存储** |
| **新建梦境记录 (语音转文字)** | 作为一名**刚睡醒或不便打字的iOS用户**，我想要**通过语音输入快速记录梦境，应用能自动将我的语音转换为文字并填充到梦境描述中**，以便**稍后有时间再进行详细补充和整理，语音文件可选存储于Firebase Storage**。                  | MVP                  | **SFSpeechRecognizer (iOS原生语音识别)**、语音权限处理、编辑转换后的文本 |
| 编辑已记录的梦境        | 作为一名iOS用户，我想要**方便地修改或补充先前记录的梦境内容、情绪、标签或日期等信息**，以便**确保梦境记录的完整性和准确性**。                  | MVP                   |                                    |
| 删除不需要的梦境记录    | 作为一名iOS用户，我想要**能够删除不再需要、重复或错误的梦境记录**，以便**保持我的梦境列表整洁有序**。                                  | MVP                   | 支持单条删除、批量删除（V1.1后考虑） |
| 查看梦境列表            | 作为一名iOS用户，我想要**按时间倒序清晰地查看到我所有记录过的梦境列表，并能看到每个梦境的标题/摘要、记录日期和情绪**，以便**快速浏览和选择特定梦境进行回顾或操作**。                          | MVP                   | SwiftUI List展示，包含日期、标题/摘要、情绪缩略图 |
| 搜索特定梦境            | 作为一名iOS用户，我想要**通过输入关键词（如梦境内容、标签）来搜索我记录过的所有梦境**，以便**快速定位并找到包含特定信息的梦境记录**。                  | MVP                   | 搜索框，支持按内容、标签搜索 (标签搜索基于标签库) |
| **使用标签库为梦境添加/管理标签** | 作为一名iOS用户，我想要**使用一个包含预设常用标签和允许我创建、编辑、删除自定义标签的标签库，来为我的梦境添加一个或多个标签**，以便**更好地对梦境进行分类、管理、搜索和后续的模式分析与个性化引导**。 | MVP                   | **标签库管理界面 (创建、编辑、删除标签)，标签选择器** |
| 标记梦境情绪            | 作为一名iOS用户，我想要**在记录梦境时或之后，标记该梦境带给我的主要情绪（例如：喜悦、恐惧、焦虑、困惑）**，以便**更好地理解梦境的感受基调，并为后续的情绪模式分析和Wellness追踪提供数据**。 | MVP                   | 预设情绪选项（如表情符号+文字），允许单选或多选（V1.1后考虑） |

### 活动3: 获取与理解解读 (手动触发, Wellness)

| 用户任务 (Task)         | 用户故事 (User Story)                                                                     | 优先级 (Roadmap 版本) | 备注                                     |
| :---------------------- | :---------------------------------------------------------------------------------------- | :-------------------- | :--------------------------------------- |
| **手动触发AI梦境解读与积极引导** | 作为一名**记录完梦境并希望获得指引的iOS用户**，我想要**通过明确的按钮手动触发AI对当前梦境进行分析解读，并获得相关的积极心理引导和Wellness建议**，以便**更好地理解梦境并改善心境**。 | MVP                   | 记录完成后有明确的“获取解读与引导”按钮 |
| **查看AI解读与积极引导结果** | 作为一名iOS用户，我想要**在请求解读后，清晰、结构化且易于理解地查阅AI生成的梦境解读结果和积极心理引导内容，包括概述、象征物分析、情绪关联、积极思考角度和可行动的Wellness建议**，以便**从中获得启发和支持**。                                        | MVP                   | 结构化展示：解读摘要、关键象征、情绪分析、**积极引导语、Wellness行动点** |
| 理解解读的不同维度 (高级) | 作为一名**对梦境解读有更深兴趣的iOS用户**，我想要**（在高级版中）选择或了解基于不同心理学流派或文化象征体系的解读视角，以及不同积极心理干预方法的来源**，以便**获得更丰富和多层面的理解**。                        | V1.2 (高级功能)           | (高级功能) 可选不同解读模型或参考信息 |
| **对AI解读与引导结果进行反馈** | 作为一名iOS用户，我想要**能够对AI生成的梦境解读和积极引导的准确性、帮助性或相关性进行简单评价（如点赞/点踩、或选择符合度标签）**，以便**帮助AI模型和引导策略持续优化，并让开发者了解其质量**。                | MVP                   | 简单反馈机制：有用/无用，或星级评价 |
| 查看梦境的历史解读记录  | 作为一名iOS用户，如果我对同一个梦境进行了多次解读请求（例如AI模型更新后），我想要**方便地查看该梦境的所有历史解读记录与引导内容**，以便**比较不同版本的解读或追踪理解的深化**。              | V1.1                  | 在梦境详情页展示历史解读入口 |
| 收藏有价值的梦境/解读与引导 | 作为一名iOS用户，我想要**能够将那些对我特别有启发、重要或有趣的梦境记录及其解读和积极引导进行收藏或标记为“重要”**，以便**将来快速找到并回顾它们**。                    | V1.1                  | 收藏/星标功能，独立的收藏列表 |
| 获取更个性化的AI解读与引导 (高级) | 作为一名**希望获得更深度洞察的iOS用户**，我愿意**（在高级版并明确授权后）让AI解读与引导结合我更长期的梦境模式或我主动提供的有限个人背景信息（如近期压力、关注点等）**，以便**获得更具个性化和针对性的解读建议与Wellness方案**。 | V1.2 (高级功能) / V2.0+ | (高级功能) 需用户主动开启并提供有限信息，强调隐私保护 |

### 活动4: 互动与分享 (V1.2+)

| 用户任务 (Task)         | 用户故事 (User Story)                                                                     | 优先级 (Roadmap 版本) | 备注                                     |
| :---------------------- | :---------------------------------------------------------------------------------------- | :-------------------- | :--------------------------------------- |
| (可选)匿名分享梦境片段至外部 | 作为一名iOS用户，我可能想**将某个有趣的梦境片段（非完整记录，且经脱敏处理）匿名地分享到我常用的社交平台**，以便**与朋友或特定群体交流，但不是在应用内形成社区**。          | V1.2 (可选探索)           | **利用iOS原生分享组件**，严格控制分享内容，确保用户隐私，非应用内社区功能 |
| (未来)浏览匿名分享的梦境主题 | 作为一名**对梦境普遍现象感兴趣的iOS用户**，我可能想**（在未来版本，如果引入安全的社区功能后）浏览他人匿名分享的、经过分类的梦境主题或常见象征物**，以便**获得更广泛的视角和共鸣，而非具体个人梦境**。          | V2.0+ (若引入社区)           | 聚焦主题和象征，而非个体隐私 |
| (未来)参与主题性梦境讨论 | 作为一名**希望与他人交流梦境体验的iOS用户**，我想要**（在未来版本，如果引入安全的社区功能后）在围绕特定梦境主题或象征意义的、有管理的讨论区中，匿名参与讨论和分享见解**，以便**从集体智慧中获益**。                | V2.0+ (若引入社区)                 | 强管理、匿名、主题聚焦 |

### 活动5: 个人成长与回顾 (Wellness & 引导)

| 用户任务 (Task)         | 用户故事 (User Story)                                                                     | 优先级 (Roadmap 版本) | 备注                               |
| :---------------------- | :---------------------------------------------------------------------------------------- | :-------------------- | :--------------------------------- |
| **查看个人梦境、情绪与Wellness统计** | 作为一名**希望通过梦境更了解自己并提升Wellness的iOS用户**，我想要**查看我的梦境记录的统计数据，例如：最常出现的情绪、最常用的标签/关键词、梦境数量随时间的变化趋势、积极引导的采纳情况等**，以便**发现自己潜意识的模式、情绪波动和Wellness进展**。 | V1.1 (基础统计), V1.2 (高级分析，订阅) | 图表化展示 (Swift Charts)，如情绪饼图、标签词云、记录频率折线图、**Wellness指标追踪** |
| 按日期/日历回顾梦境     | 作为一名iOS用户，我想要**通过日历视图或选择特定日期范围来回顾我在某个时间段记录的所有梦境**，以便**将梦境与特定时期的生活事件联系起来思考**。                      | V1.1                  | 日历视图，日期范围筛选 |
| **接收梦境引导与预测提醒 (Wellness)** | 作为一名iOS用户，我想要在特定情境下 (例如记录了连续的焦虑梦境后，或根据用户设定的目标)，**接收到App主动发出的、个性化的积极心理引导、应对技巧或改善睡眠的建议提醒**，以帮助我调整心态，提升Wellness。 | V1.1 (基础提醒), V1.2 (个性化与预测) | **基于Firebase Functions的后端逻辑触发，iOS本地通知**，需精心设计触发机制和引导内容，强调用户可控性 |
| 设置应用偏好与通知      | 作为一名iOS用户，我想要**设置一些应用偏好，例如：每日记录梦境的提醒时间、积极引导提醒的频率和类型、通知开关、主题皮肤（如暗色模式）等**，以便**让应用更符合我的使用习惯和Wellness需求**。                        | V1.1 (提醒), V1.2 (主题) | 设置页面包含：提醒设置、通知管理、外观设置 (支持iOS系统暗色模式) |
| (未来)导出个人梦境数据  | 作为一名**非常关注个人数据所有权的iOS用户**，我可能想要**（在未来版本）将我所有的梦境记录和相关的解读与引导（在用户许可下）以常见的格式（如JSON, CSV）导出**，以便**进行个人备份或在其他工具中进行分析**。                              | V2.0+                 | 需确保数据导出过程安全，格式清晰，明确告知用户数据内容 |

## 4. 故事优先级与版本映射

此部分的详细映射已在上述用户故事的 “优先级 (Roadmap 版本)” 列中体现，并与 [产品路线图 (Roadmap)](./Roadmap.md) 中的版本规划保持一致。

**优先级定义参考 (同PRD和Roadmap):**

-   **MVP (iOS - Meadow Dream):** 产品核心功能，构成最小可行产品，用于验证核心的Wellness价值主张。包括Firebase账户、文本/语音梦境记录、基础标签库、手动AI解读与初步积极引导。
-   **V1.1:** 在MVP基础上进行的重要功能增强和体验优化，旨在提升用户留存和Wellness效果。包括增强的AI引导、完善的标签库管理、统计回顾、主动引导提醒等。
-   **V1.2:** 进一步完善产品功能，并开始探索商业化模式和更深度的用户价值，可能包括更个性化的预测和引导，以及初步的分享功能探索。
-   **V2.0+:** 产品的长期发展方向，可能包括更高级的AI能力、内容生态、安全的社区互动等，具体优先级将根据前期版本的数据和用户反馈动态调整。

*(本地图会随着产品迭代和用户反馈持续更新)*