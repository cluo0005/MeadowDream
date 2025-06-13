## Product Evaluation Metrics Framework (Metrics Framework) - Meadow Dream

## 1. Framework Overview

This document aims to define a comprehensive evaluation metrics system for the "Meadow Dream" iOS application. By continuously tracking and analyzing these metrics, the team can effectively measure product performance, user behavior (particularly on the iOS platform), feature effectiveness (such as voice input, tag library, AI positive guidance), and the achievement of business goals, thereby guiding product iteration and optimization of operational strategies to ensure the realization of Wellness value.

## 2. North Star Metric

- **Definition:** **The number of users who complete at least one “Positive Dream Interaction” per week through “Meadow Dream”.**
    - *“Positive Dream Interaction” Definition:* Users successfully log a dream (text or voice), **manually trigger** and view AI-generated dream interpretations with **positive psychological guidance**, or provide effective feedback on the guidance content (e.g., marking it as “helpful”), or use the tag library to effectively manage dreams, or experience positive emotional feedback due to the App's guidance.
    - *Selection Rationale:* This metric directly reflects whether users consistently use the core functionality of the product (logging dreams, receiving AI interpretation and **positive guidance**, using the **tag library**) and perceive **Wellness value** from it.  It combines user activity, depth of core feature use (particularly acceptance of **manual triggering** and **positive guidance**), and delivery of the product’s core value (**Wellness**).  It is highly aligned with the product vision defined in the PRD – “to become a personalized Wellness companion for users to explore the subconscious, understand themselves, and enhance psychological well-being through positive guidance.”
- **Measurement Goals:**
    - 3 months after MVP (iOS) launch: The number of users completing at least one “Positive Dream Interaction” per week reaches 15% of Firebase registered users.
    - After V1.1 (iOS) launch: The number of users completing at least one “Positive Dream Interaction” per week reaches 25% of MAU.

## 3. Core Metrics System

We will combine various metrics models to comprehensively evaluate the product, such as the AARRR model and elements of the HEART model.

### 3.1 AARRR Model (User Lifecycle)

#### 3.1.1 Acquisition (Acquire Users - iOS & Firebase)

- **Metrics:**
    - iOS App Downloads (App Store Connect Downloads)
    - New User Registrations (Firebase Authentication New Users - Email, Sign in with Apple)
    - Customer Acquisition Cost (CAC) (e.g., for paid promotions like Apple Search Ads)
    - Channel Source Distribution (Channel Source Distribution for iOS)
- **Data Sources:** App Store Connect, Firebase Analytics, Promotion Platform Data.
- **Analysis Dimensions:** Efficiency of user acquisition from different iOS promotion channels, user personas.

#### 3.1.2 Activation (Activate Users - iOS & Wellness Focus)

- **Metrics:**
    - Percentage of Users Completing First “Positive Dream Interaction” (e.g., First Successful Dream Log, **manually triggering AI interpretation & positive guidance** and viewing / Total Firebase Registered Users)
    - New User Onboarding Flow Completion Rate (iOS Onboarding Completion Rate – emphasizing Wellness value and core features such as **voice input, tag library**)
    - “Aha Moment” Achievement Rate (The moment users experience the product’s core Wellness value, e.g., first time feeling mood improvement from positive guidance)
    - **First-time Voice Input Success Rate**
    - **First-time Tag Library Use Success Rate**
- **Data Sources:** Firebase Analytics, Product Event Tracking.
- **Analysis Dimensions:** New iOS user conversion funnel, effectiveness of the onboarding flow, adoption rate of core new features.

#### 3.1.3 Retention (Retain Users)

- **Metrics:**
    - Day 1 Retention Rate
    - Day 7 Retention Rate
    - Day 30 Retention Rate
    - Churn Rate
    - Weekly Active Users (WAU)
    - Monthly Active Users (MAU)
    - DAU/MAU Ratio (User Stickiness)
- **Data Sources:** Product Event Tracking.
- **Analysis Dimensions:** Retention rates by different user segments, churn reason analysis.

#### 3.1.4 Referral (Refer Users)

- **Metrics:**
    - Net Promoter Score (NPS)
    - Share Feature Usage Count/Rate (if sharing functionality is provided)
    - K-Factor (if applicable)
- **Data Sources:** Surveys, Product Event Tracking.
- **Analysis Dimensions:** User word-of-mouth, product dissemination effectiveness.

#### 3.1.5 Revenue (Revenue)

- **Metrics:** (Based on the business model defined in the PRD: Freemium + Light Advertising + One-Time In-App Purchases for Premium Features/Interpretation Packages)
    - **Freemium revenue:**
        - Premium Subscriber Count
        - Free to Premium Conversion Rate
        - Average Revenue Per Paying User (ARPPU - for subscribers)
        - Subscription Renewal Rate
        - One-time In-App Purchases (e.g., Deep Interpretation Packages) – count and amount.
    - **Advertising Revenue:**
        - Ad Impressions
        - Ad Click-Through Rate (CTR)
        - Revenue Per Mille (RPM)
        - Ad Fill Rate
    - **Overall Revenue:**
        - Total Revenue
        - Average Revenue Per User (ARPU - overall)
        - Customer Lifetime Value (LTV)
- **Data Sources:** Payment Platform Data, Product Backend, Advertising Platform SDK Data.
- **Analysis Dimensions:** Paying user personas, conversion effectiveness of different paypoints/ad placements, LTV/CAC ratio, willingness to pay among different user segments.

### 3.2 HEART Model (User Experience)

#### 3.2.1 Happiness (Satisfaction)

- **Metrics:**
    - Customer Satisfaction Score (CSAT) (Collected through in-app surveys or feedback)
    - App Store Rating and Sentiment Analysis of Reviews
    - Feedback after using Specific Features (e.g., Satisfaction with interpretation results)
- **Data Sources:** Surveys, App Stores, User Feedback System.

#### 3.2.2 Engagement (Engagement)

- **Metrics:**
    - Average Session Length
    - Daily/Weekly Usage Frequency
    - Core Feature Usage Depth (e.g., Average number of dreams logged per session, proportion of users viewing interpretation detail pages)
    - Content Interaction Rate (e.g., Likes, comments, saves, if a community function is provided)
- **Data Sources:** Product Event Tracking.

#### 3.2.3 Adoption (Adoption)

- **Metrics:**
    - New Feature/Characteristic Usage Rate
    - Acceptance of New Features by Specific User Groups
- **Data Sources:** Product Event Tracking.

#### 3.2.4 Retention (Retention)

- *(Same as Retention metrics in the AARRR Model)*

#### 3.2.5 Task Success (Task Success)

- **Metrics:**
    - Core Task Completion Rate (e.g., Successfully logging a dream, successfully receiving an interpretation)
    - Task Completion Time
    - Error Rate (in key processes)
- **Data Sources:** Product Event Tracking.

## 4. Feature-Level Evaluation Metrics

Corresponding evaluation metrics also need to be set for the product’s specific functional modules.

- **Dream Logging Function (iOS - Text/Voice, Tag Library):**
    - Average Logging Completeness (e.g., text length, **number of tags used**)
    - **Text Logging vs. Voice Logging Usage Ratio (iOS)**
    - **Speech-to-Text Accuracy (indirectly assessed through user editing behavior)**
    - Logging Interruption Rate
    - **Tag Library Usage Frequency (Creation, Selection of Pre-set Tags)**
    - **Average Number of Tags Used Per Dream**
- **AI Dream Interpretation & Positive Guidance Function (iOS – Manually Triggered, Wellness):**
    - **Manually Triggered** Interpretation and Guidance Request Count
    - Interpretation and Guidance Result View Rate
    - User Feedback Distribution Regarding Interpretation Results (“Helpful”, “Neutral”, “Not Helpful”)
    - **User Acceptance of Positive Guidance Content (e.g., Change in emotional feedback after guidance, click-through rate of specific guidance)**
    - User Preference for Different Interpretation Types (if multiple interpretation methods are provided)
- **Search/Filtering Function (Based on Tag Library):**
    - Search Function Usage Frequency (especially tag-based search)
    - Search Result Click-Through Rate
    - Percentage of Zero-Result Searches
- **User Account Management (Firebase):**
    - Registration Success Rate (Email, Sign in with Apple)
    - Login Success Rate
    - Password Recovery Usage Rate
- **Wellness Guidance & Prediction Function:**
    - Open Rate of Proactive Guidance Push Notifications
    - User Adoption Rate of Predictive Suggestions (if applicable)
    - Trend in Emotional Positivity of Long-Term Users (Analyzed through emotion logging and feedback)
- **(If present) Community/Sharing Function:**
    - Content Publication Volume
    - User Interaction Volume (Likes, Comments)
    - Sharing Conversion Rate (iOS sharing functionality)

## 5. Metrics Monitoring Plan

- **Data Collection Tools:**
    - Front-end Event Tracking: **Firebase Analytics (iOS SDK)**, for tracking user behavior, events, screen views, etc. within the iOS application.
    - Back-end Logs: Recording key business operations and system status.
    - Third-Party Platforms: App Store backend, advertising platforms, payment platforms.
- **Data Dashboards & Reports:**
    - Establish a data dashboard for core metrics to monitor product dynamics in real-time.
    - Generate regular product data reports (daily, weekly, monthly) to analyze trends and issues.
    - Conduct specialized data analysis for specific activities or feature launches.
- **Data Analysis Methods:**
    - Trend Analysis: Observing changes in metrics over time.
    - Comparative Analysis: Comparing data performance across different user groups, different versions, and different channels.
    - Funnel Analysis: Analyzing user conversion and drop-off in key processes.
    - User Segmentation: Segmenting by user attributes or behavior to conduct granular analysis.
    - A/B Testing: For verifying the effectiveness of new features or changes.
- **Reporting Frequency & Responsibility:**
    - Core Metrics Daily/Weekly Reports: Product Manager/Data Analyst.
    - Monthly/Quarterly Reviews: Product Team.

*(This metrics framework will be continuously iterated and optimized based on the development stage of the “Meadow Dream” iOS application and changes in Wellness business objectives.)*# 产品评估指标框架 (Metrics Framework) - Meadow Dream



## 1. 指标框架概述

本文档旨在为“Meadow Dream”iOS应用定义一套全面的评估指标体系。通过对这些指标的持续追踪和分析，团队可以有效地衡量产品表现、用户行为（特别是在iOS平台上的行为）、功能效果（如语音输入、标签库、AI积极引导）以及商业目标的达成情况，从而指导产品迭代和运营策略的优化，确保Wellness价值的实现。

## 2. 北极星指标 (North Star Metric)

- **定义：** **每周通过“Meadow Dream”完成至少一次“积极梦境互动”的用户数。**
    - *“积极梦境互动”定义：* 用户成功记录梦境（文本或语音），**手动触发**并查看了AI生成的梦境解读与**积极心理引导**，或对引导内容进行了有效反馈（如标记为“有帮助”），或使用了标签库对梦境进行了有效管理，或因App的引导产生了积极的情绪反馈。
    - *选择依据：* 此指标直接反映了用户是否持续使用产品的核心功能（记录梦境、获取AI解读与**积极引导**、使用**标签库**），并从中感知到**Wellness价值**。它结合了用户活跃度、核心功能使用深度（特别是**手动触发**和**积极引导**的接受度）以及产品核心价值（**Wellness**）的传递。与PRD中定义的产品愿景——“成为用户探索潜意识、理解自我、并通过积极引导提升心理健康的个性化Wellness伙伴”高度契合。
- **衡量目标：** 
    - MVP (iOS) 上线3个月后：每周完成至少一次“积极梦境互动”的用户数达到Firebase注册用户的15%。
    - V1.1 (iOS) 上线后：每周完成至少一次“积极梦境互动”的用户数达到MAU的25%。

## 3. 核心指标体系

我们将结合多种指标模型来全面评估产品，例如 AARRR 模型和 HEART 模型的部分理念。

### 3.1 AARRR 模型 (用户生命周期)

#### 3.1.1 Acquisition (获取用户 - iOS & Firebase)

-   **指标：**
    -   iOS应用下载量 (App Store Downloads)
    -   新用户注册数 (Firebase Authentication New Users - Email, Sign in with Apple)
    -   获客成本 (Customer Acquisition Cost - CAC) (如进行付费推广，如Apple Search Ads)
    -   渠道来源分布 (Channel Source Distribution for iOS)
-   **数据来源：** App Store Connect、Firebase Analytics、推广平台数据。
-   **分析维度：** 不同iOS推广渠道的获客效率、用户画像。

#### 3.1.2 Activation (激活用户 - iOS & Wellness Focus)

-   **指标：**
    -   完成首次“积极梦境互动”的用户比例 (e.g., 首次成功记录梦境、**手动触发AI解读与积极引导**并查看的用户 / 总Firebase注册用户)
    -   新用户引导流程完成率 (iOS Onboarding Completion Rate - 强调Wellness价值和核心功能如**语音输入、标签库**)
    -   “Aha Moment” 到达率 (用户体验到产品核心Wellness价值的时刻，例如首次感受到积极引导带来的情绪改善)
    -   **首次使用语音输入成功率**
    -   **首次使用标签库成功率**
-   **数据来源：** Firebase Analytics, 产品埋点数据。
-   **分析维度：** 新iOS用户转化漏斗、引导流程的有效性、核心新功能上手率。

#### 3.1.3 Retention (提高留存)

-   **指标：**
    -   次日留存率 (Day 1 Retention Rate)
    -   7日留存率 (Day 7 Retention Rate)
    -   30日留存率 (Day 30 Retention Rate)
    -   用户流失率 (Churn Rate)
    -   周/月活跃用户数 (WAU/MAU)
    -   DAU/MAU 比率 (用户粘性)
-   **数据来源：** 产品埋点数据。
-   **分析维度：** 不同用户群体的留存情况、流失原因分析。

#### 3.1.4 Referral (推荐传播)

-   **指标：**
    -   用户推荐指数 (Net Promoter Score - NPS)
    -   分享功能使用次数/比率 (如果提供分享功能)
    -   病毒系数 (K-Factor) (如果适用)
-   **数据来源：** 问卷调研、产品埋点数据。
-   **分析维度：** 用户口碑、产品传播效果。

#### 3.1.5 Revenue (获取收入)

-   **指标：** (根据PRD中定义的商业模式：免费增值 + 轻度广告 + 一次性内购高级功能/解读包)
    -   **增值服务：**
        -   高级功能订阅用户数 (Premium Subscribers)
        -   订阅转化率 (Free to Premium Conversion Rate)
        -   平均每付费用户收入 (ARPPU - for subscribers)
        -   订阅续费率 (Subscription Renewal Rate)
        -   一次性内购（如深度解读包）购买次数与金额
    -   **广告变现：**
        -   广告展示次数 (Ad Impressions)
        -   广告点击率 (Ad Click-Through Rate - CTR)
        -   每千次展示收入 (Revenue Per Mille - RPM)
        -   广告填充率 (Ad Fill Rate)
    -   **整体营收：**
        -   总收入 (Total Revenue)
        -   平均每用户收入 (ARPU - overall)
        -   用户生命周期价值 (Customer Lifetime Value - LTV)
-   **数据来源：** 支付平台数据、产品后台、广告平台SDK数据。
-   **分析维度：** 付费用户画像、不同付费点/广告位转化效果、LTV/CAC 比率、不同用户群体的付费意愿。

### 3.2 HEART 模型 (用户体验)

#### 3.2.1 Happiness (愉悦度)

-   **指标：**
    -   用户满意度评分 (Customer Satisfaction - CSAT) (通过应用内调研或反馈收集)
    -   应用商店评分与评论情感分析
    -   特定功能使用后的反馈 (例如，对解读结果的满意度)
-   **数据来源：** 问卷调研、应用商店、用户反馈系统。

#### 3.2.2 Engagement (参与度)

-   **指标：**
    -   平均使用时长 (Average Session Length)
    -   每日/每周使用频率 (Frequency of Use)
    -   核心功能使用深度 (e.g., 平均每次使用记录梦境数、查看解读详情页比例)
    -   内容互动率 (e.g., 点赞、评论、收藏，如果提供社区功能)
-   **数据来源：** 产品埋点数据。

#### 3.2.3 Adoption (接受度)

-   **指标：**
    -   新功能/特性使用率 (Feature Adoption Rate)
    -   特定用户群体对新功能的接受程度
-   **数据来源：** 产品埋点数据。

#### 3.2.4 Retention (留存度)

-   *(同 AARRR 模型中的 Retention 指标)*

#### 3.2.5 Task Success (任务完成度)

-   **指标：**
    -   核心任务完成率 (e.g., 成功记录梦境的比例、成功获取解读的比例)
    -   任务完成时长 (Time to Complete Task)
    -   操作错误率 (Error Rate) (在关键流程中)
-   **数据来源：** 产品埋点数据。

## 4. 功能级评估指标

针对产品的具体功能模块，也需要设定相应的评估指标。

-   **梦境记录功能 (iOS - 文本/语音, 标签库)：**
    -   平均记录完整度 (例如，文本长度、**标签使用数量**)
    -   **文本记录 vs 语音记录使用比例 (iOS)**
    -   **语音转文字准确率 (通过用户编辑行为间接评估)**
    -   记录中断率
    -   **标签库使用频率 (创建、选择预设标签)**
    -   **平均每个梦境使用的标签数**
-   **AI梦境解读与积极引导功能 (iOS - 手动触发, Wellness)：**
    -   **手动触发**解读与引导的请求次数
    -   解读与引导结果查看率
    -   用户对解读结果的反馈分布 (“有帮助”、“一般”、“无帮助”)
    -   **用户对积极引导内容的接受度 (例如，引导后的情绪反馈变化，特定引导的点击率)**
    -   不同解读类型的使用偏好 (如果提供多种解读方式)
-   **搜索/筛选功能 (基于标签库)：**
    -   搜索功能使用频率 (特别是基于标签的搜索)
    -   搜索结果点击率
    -   零结果搜索占比
-   **用户账户管理 (Firebase)：**
    -   注册成功率 (Email, Sign in with Apple)
    -   登录成功率
    -   密码找回使用率
-   **Wellness引导与预测功能：**
    -   主动引导推送的打开率
    -   用户对预测性建议的采纳率 (如适用)
    -   长期使用用户的情绪积极度变化趋势 (通过情绪记录和反馈分析)
-   **(如果存在) 社区/分享功能：**
    -   内容发布量
    -   用户互动量 (点赞、评论)
    -   分享转化率 (iOS分享功能)

## 5. 指标监测计划

-   **数据收集工具：**
    -   前端埋点：**Firebase Analytics (iOS SDK)**，用于追踪用户在iOS应用内的行为、事件、屏幕浏览等。
    -   后端日志：记录关键业务操作和系统状态。
    -   第三方平台：应用商店后台、广告平台、支付平台。
-   **数据看板与报告：**
    -   建立核心指标的数据看板 (Dashboard)，实时监控产品动态。
    -   定期生成产品数据报告 (日报、周报、月报)，分析趋势和问题。
    -   针对特定活动或功能上线，进行专项数据分析。
-   **数据分析方法：**
    -   趋势分析：观察指标随时间的变化。
    -   对比分析：比较不同用户群、不同版本、不同渠道的数据表现。
    -   漏斗分析：分析用户在关键流程中的转化和流失。
    -   用户分群 (Segmentation)：根据用户属性或行为进行细分，进行精细化分析。
    -   A/B 测试：用于验证新功能或改动的效果。
-   **报告频率与负责人：**
    -   核心指标日报/周报：产品经理/数据分析师。
    -   月度/季度回顾：产品团队。

*(本指标框架将根据“Meadow Dream”iOS应用的发展阶段和Wellness业务目标的变化进行持续迭代和优化。)*
