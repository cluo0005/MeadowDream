# Product Roadmap - Meadow Dream

## 1. Roadmap Overview

This document outlines the development path and feature evolution of the "Meadow Dream" app from MVP to future iterations. The roadmap is designed around core user needs (especially **Wellness and Positive Psychological Guidance**), market opportunities, and technical feasibility (**iOS Swift first, Firebase integration**), while maintaining flexibility to adapt to changes.

## 2. Versioning Strategy

- **MVP (Minimum Viable Product):** Quickly validate core value, focusing on **iOS platform** dream recording (**text and voice input**), **manually triggered basic AI interpretation** (including **initial positive guidance**), **basic tag features** and user feedback mechanism, as well as **Firebase user authentication**.
- **V1.1 (Iterative Optimization & Wellness Enhancement):** Based on MVP feedback, optimize core experience, enhance interpretation accuracy and **effectiveness of positive guidance**, improve **tag library management**, and boost **speech-to-text** accuracy and usability.
- **V1.2 (Feature Expansion & Personalization):** Introduce more comprehensive dream guidance and prediction, explore deeper personalized interpretation (e.g., pattern recognition based on user history), and strengthen **Wellness** features.
- **Future Versions:** Explore deeper AI capabilities, richer interaction forms, potential monetization paths (such as advanced guidance content subscriptions), and adaptation to other platforms.

## 3. Detailed Version Plans

### 3.1 MVP Version (Estimated X Month - Y Month)

- **Core Goal:** Validate user acceptance and basic needs for the core flow of "**convenient recording (including voice) + manual AI interpretation (with positive guidance) + tag management**" on **iOS**, and ensure stable operation of the **Firebase user system**.
- **Main Features:**
    - **iOS app framework (Swift)**
    - **Firebase user registration & login (email/password)**
    - Dream recording:
        - Text input
        - **Voice input and background speech-to-text (iOS native SFSpeechRecognizer)**
        - Emotion selection
        - **Basic tag features (select preset tags, create simple custom tags)**
    - **Manually triggered AI dream interpretation:**
        - Based on general model, provide symbolic meaning and emotion analysis
        - **Initial positive psychological guidance content**
    - View dream history list (sorted by time)
    - Simple feedback on interpretation results (e.g., "Helpful"/"Inaccurate")
    - Basic settings (e.g., notification toggle)
- **Metrics:** **iOS downloads**, user registrations, daily active users, number of dream records (text/voice), **tag usage frequency**, AI interpretation usage rate, **positive guidance feedback**, quantity and quality of user feedback.
- **Estimated Timeline:** 6-8 weeks development (iOS native, including Firebase and speech features), 2 weeks testing and launch prep.

### 3.2 V1.1 Version (Estimated Y+1 Month - Z Month)

- **Core Goal:** Improve **AI interpretation quality and positive guidance effectiveness**, enhance **tag library management**, optimize overall UX, and increase user stickiness.
- **Main Features:**
    - AI interpretation model iteration (based on MVP feedback, improve accuracy, personalization, and **depth/targeting of positive guidance**)
    - **Comprehensive tag library management system:**
        - **View, edit, delete custom tags**
        - **Tag search**
        - **(Optional) Expand and categorize system preset tag library**
    - Optimize dream recording flow (e.g., smarter tag recommendations based on user history)
    - Dream calendar view
    - Simple dream data statistics (e.g., emotion distribution, common tags, **Wellness-related metrics**)
    - Allow users to edit/delete recorded dreams
    - **Optimize voice input experience (e.g., resume recording, edit transcription)**
- **Metrics:** Improved interpretation satisfaction (especially positive guidance), **increased tag feature usage**, higher user retention, increased core feature usage time.
- **Estimated Timeline:** 4-5 weeks development, 1-2 weeks testing.

### 3.3 V1.2 Version (Estimated Z+1 Month - W Month)

- **Core Goal:** Enrich **dream guidance and prediction features**, deepen personalization, and fully enhance the product's **Wellness value**.
- **Main Features:**
    - **Enhanced dream guidance:**
        - **Provide more specific action suggestions or reflection exercises (Wellness exercises) based on interpretation results**
        - **(Explore) Push positive content or guidance based on user emotional state (with user consent)**
    - **(Explore) Initial dream trend prediction:** Analyze long-term records and tags to identify potential emotional fluctuations or recurring dream patterns, and provide alerts or positive coping suggestions.
    - Advanced dream pattern analysis (e.g., recurring themes, emotion fluctuation correlations, **integrated with Wellness goals**)
    - (Optional) Dream sharing feature (optionally anonymous, emphasizing positive feedback and supportive interaction)
    - More comprehensive personalization settings (e.g., customized positive guidance preferences)
- **Metrics:** New feature usage, **user evaluation of guidance and prediction**, self-reported Wellness improvement, user interaction metrics (e.g., sharing count).
- **Estimated Timeline:** 5-7 weeks development, 2 weeks testing.

### 3.4 Future Versions (After W Month)

- **Directions:**
    - **Continuous AI evolution:** More precise personalized interpretation, understanding more complex dream metaphors, integrating psychological theory for more professional analysis, **deepen guidance and prediction accuracy/effectiveness**.
    - **Multi-dimensional interaction:** Dream visualization, **more natural voice-based AI interpretation**, sleep quality analysis and dream correlation using biometric data (with user consent and hardware support).
    - **Wellness ecosystem integration:** Consider integration or cooperation with other Wellness apps/services (e.g., meditation, mindfulness).
    - **(Careful evaluation) Cross-platform support:** After iOS is stable/mature, evaluate expansion to Android/other platforms.
    - **Business model deepening:** Explore more Wellness-related value-added services, such as advanced personalized guidance plans, secure professional counselor connections (with strict vetting and compliance). 

## 4. Feature Priority Matrix

| P0 (Core, MVP must-have) | P1 (Important, next iterations) | P2 (Desired, resource/feedback dependent) |
|---|---|---|
| **iOS app framework (Swift)** | AI interpretation model optimization (incl. positive guidance) | Advanced dream pattern analysis (with Wellness) |
| **Firebase user registration/login** | **Comprehensive tag library management** | (Explore) Dream trend prediction |
| **Dream text recording** | Dream calendar view | Dream sharing (emphasizing positive interaction) |
| **Dream voice input & speech-to-text** | Simple dream data stats (Wellness metrics) | (Explore) Emotion-based positive content push |
| **Basic tag features** | Edit/delete dreams | Voice-based AI interpretation (more natural) |
| **Manual AI interpretation (with initial positive guidance)** | **Optimize voice input experience** | (Careful eval) Android support |
| View dream history | Smarter tag recommendations | Professional counselor integration (high bar) |
| Interpretation feedback |  |  |
| Basic settings |  |  |

## 5. Detailed Timeline (Milestones)

- **MVP Version (iOS - Meadow Dream, ~6-8 weeks dev + 2 weeks testing):**
    - Week 1: Environment setup (iOS, Swift, Firebase), detailed design (UI/UX draft, tech architecture confirmation).
    - Weeks 2-3: Firebase auth module dev & test, basic dream recording (text input, emotion selection, basic tag model).
    - Weeks 4-5: **Voice input & speech-to-text dev/integration (SFSpeechRecognizer)**, manual AI interpretation module (connect initial model, design result UI).
    - Week 6: **Basic tag library dev (preset selection, custom creation)**, dream history list, settings & feedback UI.
    - Weeks 7-8: Full feature integration, performance optimization, UI polish, internal testing & bug fixing.
    - Weeks 9-10: Beta test (small user group), adjust per feedback, App Store prep & submission.
- **V1.1 Version (4-5 weeks dev + 1-2 weeks testing after MVP):**
    - Requirements gathering & design (parallel or slightly ahead, focus on AI model iteration and tag library UI).
    - **AI interpretation & positive guidance iteration.**
    - **Comprehensive tag library management dev.**
    - Voice input optimization, other feature iterations.
    - Testing & release.
- **V1.2 Version (5-7 weeks dev + 2 weeks testing after V1.1):**
    - Requirements gathering & design (parallel or slightly ahead, focus on dream guidance/prediction and personalized Wellness features).
    - **Enhanced dream guidance & initial prediction dev.**
    - Other feature iterations & enhancements.
    - Testing & release.

## 6. Resource Planning (Initial Recommendations)

- **Product Team:** Product Manager (1), UI/UX Designer (1)
- **Dev Team (initially iOS-focused):**
    - **iOS Engineer (Swift, 1-2, needs Firebase & speech experience)**
    - **AI/Algorithm Engineer (1, for interpretation model & positive guidance logic, can partly use 3rd-party APIs)**
    - (Optional for MVP, recommended after V1.1) Backend Engineer (1, if Firebase can't cover all backend logic or for future needs)
- **QA Team:** Test Engineer (1, iOS testing experience)
- **Ops Team (initially can be shared):** Marketing (iOS user focus), User Ops (feedback & early Wellness community)
- **Time Investment:**
    - MVP: ~12 weeks (3 months)
    - Each iteration (V1.1, V1.2): 8-12 weeks

## 7. Risk Management

- **Market Risks:**
    - **Intense iOS competition:** Many diary, emotion management, and some dream apps in App Store. (Mitigation: **Differentiate with "Wellness + Positive Guidance"**, deliver refined iOS native UX, target users precisely.)
    - Slow user growth, ineffective channels. (Mitigation: Refined ops, App Store Optimization (ASO), content marketing (blog/social media on positive psychology), KOL partnerships.)
- **Product Risks:**
    - **AI interpretation & guidance may underwhelm:** Users may find interpretations forced or guidance vague. (Mitigation: Ongoing algorithm investment, **work with psychology experts on guidance**, strong feedback loop, set expectations, stress AI is assistive not absolute truth.)
    - **Speech-to-text accuracy/UX issues:** Noise, accents may affect accuracy. (Mitigation: Use mature iOS speech engine, provide editing, guide users to quiet environments.)
    - User privacy leak risk (Firebase data). (Mitigation: Strict Firebase security rules, follow Apple privacy, transparent policy, regular audits.)
- **Tech Risks:**
    - **AI model training/deployment complex, costly:** Especially for personalization and deep guidance. (Mitigation: Start with mature 3rd-party NLP/emotion APIs, gradually build core logic/knowledge base; Firebase ML Kit can help.)
    - **Swift/iOS tech stack mastery:** Team must have relevant experience. (Mitigation: Hire experienced iOS devs, encourage learning/sharing.)
- **Resource Risks:**
    - Hard to hire/retain key talent (esp. AI, experienced Swift devs). (Mitigation: Competitive pay/benefits, growth opportunities, positive team culture.)
    - Funding shortfall. (Mitigation: Clear business model, control MVP costs, seek funding after core value validated.) 
    

# 产品路线图 (Roadmap) - Meadow Dream 

## 1. 路线图概述

本文档旨在规划“**Meadow Dream**”应用从MVP版本到未来迭代的开发路径和功能演进。路线图将围绕用户核心需求（特别是**Wellness和积极心理引导**）、市场机会和技术可行性（**iOS Swift优先，集成Firebase**）进行制定，并保持一定的灵活性以适应变化。

## 2. 版本规划策略

- **MVP (Minimum Viable Product):** 快速验证核心价值，聚焦**iOS平台**的梦境记录（**文本与语音输入**）、**手动触发的基础AI解读**（包含**初步的积极引导**）、**基础标签功能**和用户反馈机制，以及**Firebase用户认证**。
- **V1.1 (迭代优化与Wellness深化):** 根据MVP反馈，优化核心功能体验，增强解读准确性与**积极引导的有效性**，完善**标签库管理**，提升**语音转文字**的准确性和易用性。
- **V1.2 (功能拓展与个性化):** 引入更完善的梦境引导和预测功能，探索更深度的个性化解读，如基于用户历史记录的模式识别，强化**Wellness**特性。
- **未来版本:** 探索更深度的AI能力、更丰富的互动形式、可能的商业化路径（如高级引导内容订阅）、以及对其他平台的适配。

## 3. 详细版本规划

### 3.1 MVP 版本 (预计 X 月 - Y 月)

- **核心目标:** 在**iOS平台**验证用户对“**便捷记录 (含语音) + 手动AI解读 (含积极引导) + 标签管理**”核心流程的接受度和基本需求，并确保**Firebase用户系统**的稳定运行。
- **主要功能:**
    - **iOS应用框架 (Swift)**
    - **Firebase用户注册与登录 (邮箱/密码)**
    - 梦境记录：
        - 文本输入
        - **语音输入与后台转文字 (iOS原生SFSpeechRecognizer)**
        - 情绪选择
        - **基础标签功能 (选择预设标签、创建简单自定义标签)**
    - **手动触发AI梦境解读:**
        - 基于通用模型，提供象征意义、情绪分析
        - **初步的积极心理引导内容**
    - 查看历史梦境列表 (按时间排序)
    - 对解读结果的简单反馈 (如“有帮助”/“不准确”)
    - 基础设置 (如通知开关)
- **衡量指标:** **iOS下载量**、用户注册数、日活跃用户、梦境记录数（区分文本/语音）、**标签使用频率**、AI解读使用率、**积极引导内容反馈**、用户反馈数量与质量。
- **预计时间:** 6-8周开发 (iOS原生，含Firebase集成和语音功能)，2周测试与上线准备。

### 3.2 V1.1 版本 (预计 Y+1 月 - Z 月)

- **核心目标:** 提升**AI解读质量和积极引导的有效性**，完善**标签库管理功能**，优化整体用户体验，增加用户粘性。
- **主要功能:**
    - AI解读模型迭代 (基于MVP反馈，提升准确性、个性化程度和**积极引导的深度与针对性**)
    - **完善的标签库管理系统:**
        - **查看、编辑、删除自定义标签**
        - **搜索标签**
        - **（可选）系统预设标签库扩充与分类**
    - 优化梦境记录流程 (如更智能的标签推荐基于用户历史)
    - 梦境日历视图
    - 简单的梦境数据统计 (如情绪分布、常用标签，**关注与Wellness相关的指标变化**)
    - 允许用户编辑/删除已记录的梦境
    - **优化语音输入体验 (如断点续录、编辑转写结果)**
- **衡量指标:** 解读满意度提升（特别是积极引导部分）、**标签功能使用率提升**、用户留存率提升、核心功能使用时长增加。
- **预计时间:** 4-5周开发，1-2周测试。

### 3.3 V1.2 版本 (预计 Z+1 月 - W 月)

- **核心目标:** 丰富**梦境引导与预测功能**，深化个性化体验，全面提升产品的**Wellness价值**。
- **主要功能:**
    - **增强的梦境引导功能:**
        - **基于解读结果提供更具体的行动建议或反思练习 (Wellness练习)**
        - **（探索）基于用户情绪状态的积极内容推送或引导（需用户授权）**
    - **（探索）初步的梦境趋势预测:** 基于长期记录和标签，分析潜在的情绪波动或特定主题的梦境模式，并提供预警或积极应对建议。
    - 高级梦境模式分析 (如反复出现的主题、情绪波动关联等，**与Wellness目标结合**)
    - （可选）梦境分享功能 (可选择匿名分享，强调积极反馈和支持性互动)
    - 更完善的个性化设置 (如定制化的积极引导偏好)
- **衡量指标:** 新功能使用率、**用户对引导和预测功能的评价**、用户自我报告的Wellness改善、用户互动指标（如分享次数）。
- **预计时间:** 5-7周开发，2周测试。

### 3.4 未来版本 (W月之后)

- **发展方向:**
    - **AI能力持续进化:** 更精准的个性化解读，理解更复杂的梦境隐喻，结合心理学理论提供更专业的分析框架，**深化梦境引导和预测的准确性和有效性**。
    - **多维度互动体验:** 如梦境可视化、**与AI进行更自然的语音交互解读**、结合生物数据的睡眠质量分析与梦境关联（需用户授权和硬件支持）。
    - **Wellness生态整合:** 考虑与冥想、正念练习等其他Wellness应用或服务进行整合或合作。
    - **（谨慎评估）跨平台支持:** 在iOS平台稳定和成熟后，评估扩展到Android或其他平台的需求和成本。
    - **商业模式深化:** 探索更多与Wellness相关的增值服务，如高级定制化的积极引导计划、与专业心理咨询师的安全对接（需严格筛选和合规）。

## 4. 功能优先级矩阵

| P0 (核心功能，MVP必须包含) | P1 (重要功能，后续版本优先迭代) | P2 (期望功能，视资源和反馈决定) |
|---|---|---|
| **iOS应用框架 (Swift)** | AI解读模型优化（含积极引导深化） | 高级梦境模式分析（结合Wellness） |
| **Firebase用户注册/登录** | **完善的标签库管理** | （探索）梦境趋势预测 |
| **梦境文本记录** | 梦境日历视图 | 梦境分享功能（强调积极互动） |
| **梦境语音输入与转文字** | 简单梦境数据统计（关注Wellness指标） | （探索）基于情绪的积极内容推送 |
| **基础标签功能** | 编辑/删除梦境 | 语音交互解读（更自然） |
| **手动触发AI解读 (含初步积极引导)** | **优化语音输入体验** | （谨慎评估）Android平台支持 |
| 查看历史梦境 | 更智能标签推荐 | 专业心理咨询对接（高门槛） |
| 解读结果反馈 |  |  |
| 基础设置 |  |  |

## 5. 详细时间线计划 (里程碑)

- **MVP 版本 (iOS - Meadow Dream, 预计6-8周开发 + 2周测试):**
    - 第1周: 环境搭建 (iOS, Swift, Firebase)，详细设计 (UI/UX初稿，技术架构确认)。
    - 第2-3周: Firebase用户认证模块开发与测试，梦境记录基础功能 (文本输入，情绪选择，基础标签模型)。
    - 第4-5周: **语音输入转文字功能开发与集成 (SFSpeechRecognizer)**，手动触发AI解读模块 (对接初步模型，设计结果展示界面)。
    - 第6周: **基础标签库功能开发 (选择预设，创建自定义)**，历史梦境列表，设置与反馈界面。
    - 第7-8周: 整体功能联调，性能优化，UI细节打磨，内部测试与Bug修复。
    - 第9-10周: Beta测试 (小范围用户)，根据反馈调整，App Store上线准备与提交审核。
- **V1.1 版本 (MVP后约4-5周开发 + 1-2周测试):**
    - 需求收集与设计 (并行或稍提前，重点是AI模型迭代方向和标签库管理界面)。
    - **AI解读模型与积极引导内容迭代开发与集成。**
    - **完善的标签库管理功能开发。**
    - 语音输入体验优化，其他功能迭代。
    - 测试与发布。
- **V1.2 版本 (V1.1后约5-7周开发 + 2周测试):**
    - 需求收集与设计 (并行或稍提前，重点是梦境引导/预测功能和个性化Wellness特性)。
    - **增强的梦境引导与初步预测功能开发。**
    - 其他功能迭代与深化。
    - 测试与发布。

## 6. 资源规划 (初步建议)

- **产品团队:** 产品经理 (1人), UI/UX设计师 (1人)
- **开发团队 (初期聚焦iOS):**
    - **iOS工程师 (Swift, 1-2人, 需有Firebase和语音处理经验)**
    - **AI工程师/算法工程师 (1人, 负责解读模型和积极引导逻辑，可部分依赖第三方API)**
    - (MVP阶段可选，V1.1后建议) 后端工程师 (1人, 若Firebase不足以支撑所有后端逻辑，或未来有更复杂需求时)
- **测试团队:** 测试工程师 (1人, 熟悉iOS测试)
- **运营团队 (初期可兼任):** 市场推广 (针对iOS用户), 用户运营 (关注用户反馈和Wellness社群初期构建)
- **时间投入：**
    - MVP 阶段预计 12 周 (3个月)。
    - 每个迭代版本 (V1.1, V1.2) 预计 8-12 周。

## 7. 风险管理

- **市场风险:**
    - **iOS平台竞争激烈：** App Store中不乏各类日记、情绪管理及少量解梦应用。 (对策：**以“Wellness + 积极心理引导”为核心差异化**，提供精致的iOS原生体验，精准定位目标用户群体。)
    - 用户增长缓慢，推广渠道效果不佳。 (对策：精细化运营，利用App Store优化 (ASO)，内容营销 (如博客、社交媒体分享积极心理相关内容)，与相关领域的KOL合作。)
- **产品风险:**
    - **AI解读与积极引导效果不达预期：** 用户可能觉得解读牵强或引导空泛。 (对策：持续投入算法优化，**与心理学专家合作打磨引导内容**，建立有效反馈机制，管理用户预期，强调AI是辅助工具而非绝对真理。)
    - **语音转文字准确率和体验问题：** 背景噪音、口音等可能影响准确率。 (对策：选用成熟的iOS原生语音识别引擎，提供编辑功能，引导用户在安静环境使用。)
    - 用户隐私泄露风险 (Firebase数据安全)。 (对策：严格配置Firebase安全规则，遵循Apple隐私指南，透明化隐私政策，定期安全审计。)
- **技术风险:**
    - **AI模型训练和部署复杂，成本高：** 特别是涉及个性化和深度引导。 (对策：初期可考虑成熟的第三方NLP及情感分析API，逐步自建核心的引导逻辑和知识库；Firebase ML Kit等也可辅助。)
    - **Swift及iOS新技术栈的掌握：** 团队成员需具备相应的开发经验。 (对策：招聘有经验的iOS开发者，鼓励学习和技术分享。)
- **资源风险:**
    - 核心人才招聘困难或流失 (特别是AI和有经验的Swift开发者)。 (对策：提供有竞争力的薪酬福利和发展空间，打造积极的团队文化。)
    - 资金支持不足。 (对策：清晰的商业模式规划，MVP阶段控制成本，验证核心价值后积极寻求融资。)