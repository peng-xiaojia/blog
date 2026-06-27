---
title: '零成本部署个人网站：从 GitHub Pages 到 Cloudflare Pages'
date: '2026-06-27T09:00:00+08:00'
draft: false
slug: 'zero-cost-deploy'
categories: ['技术']
tags: ['部署', 'GitHub', '静态网站', '教程']
description: '用 Git 存代码，靠 Pages 服务部署，一分钱不花。'
series: []
---

自己搭博客或者个人网站，最烦的不是写代码，是部署。

买服务器要钱，配 Nginx 要时间，搞 HTTPS 证书要折腾。对只是想写点东西的人来说，太重了。

现在有几个平台可以把这件事简化到几乎零成本——代码推上去，自动部署，自带域名和 HTTPS。这篇文章把这几种方案捋一遍，包括每个平台的官网、注册要求、操作方式，以及怎么让本地智能体帮你搞定这些。

## 核心思路

不管用哪个平台，流程都一样：

1. 本地写代码，用 Git 管理。
2. 推到 GitHub 或 Gitee。
3. 平台自动检测到推送，触发构建和部署。

对静态网站——HTML、CSS、JS，或者 Hugo、Hexo、VuePress 这类生成的——编译完就是一堆静态文件，不需要服务器跑程序。这些平台天然适合。

如果需要后端逻辑，情况就不一样了。后面细说。

## 平台速览

先给一张总表，知道去哪找、怎么进：

| 平台 | 官网 | 注册要求 | 国内访问 |
|------|------|----------|----------|
| GitHub Pages | github.com | 注册 GitHub 账号，邮箱即可，免费 | 可访问，偶有波动 |
| Gitee Pages | gitee.com | 注册 Gitee 账号 + 实名认证（身份证） | 畅通 |
| Netlify | netlify.com | 用 GitHub / GitLab / Bitbucket 账号直接登录 | 可访问，速度偏慢 |
| Vercel | vercel.com | 用 GitHub / GitLab / Bitbucket 账号直接登录 | 可访问，速度偏慢 |
| Cloudflare Pages | pages.cloudflare.com | 注册 Cloudflare 账号，邮箱即可，免费 | 可访问，部分节点不稳 |

## GitHub Pages

官网：https://github.com

最老牌的一个。GitHub 自带，每个仓库都能开 Pages。

注册：用邮箱注册 GitHub 账号，不需要付费。注册完创建一个仓库，把代码推上去。

操作步骤：
1. 在仓库页面点 Settings → Pages。
2. Source 选 Deploy from a branch，再选分支（一般 master 或 main）和目录（/root 或 /docs）。
3. 推送代码后自动部署。以后每次 push 都会重新构建。
4. 默认域名是 `用户名.github.io/仓库名`。也可以绑自己的域名，在 Settings → Pages → Custom domain 里填上就行。

限制：
- 纯静态。不支持任何服务端代码。
- 如果要编译（比如 Hugo 生成 HTML），需要加一个 GitHub Actions 配置文件。免费额度每月 2000 分钟，个人用绰绰有余。
- 单个文件不能超过 1GB，站点总大小不超过 1GB。

适合：纯静态博客、文档站、作品集。

## Gitee Pages

官网：https://gitee.com

国内版，Gitee 提供。最大的好处是访问速度快，服务器在国内。

注册：注册 Gitee 账号后，必须完成实名认证（上传身份证）才能开通 Pages。这是国内合规要求。

操作步骤：
1. 在 Gitee 上创建仓库，推送代码。
2. 进入仓库 → 服务 → Gitee Pages。
3. 选择部署分支，点击"更新"按钮手动触发部署。
4. 如果代码有更新，需要再次手动点"更新"。想要推送自动触发部署，得买 Gitee Pages Pro（99 元/年）。

限制：
- 免费版必须手动部署，不能自动触发。
- 绑定自定义域名也需要 Pro 版。
- 同样纯静态，不支持服务端代码。

适合：面向国内读者的纯静态站，能接受手动部署。

## Netlify

官网：https://netlify.com

比 GitHub Pages 多了不少东西。不用单独注册，直接用 GitHub 账号登录。

操作步骤：
1. 打开 netlify.com，点 Sign up，选 GitHub 授权登录。
2. 授权后选要部署的仓库。
3. 设置构建命令和输出目录。比如 Hugo 项目，构建命令填 `hugo`，输出目录填 `public`。
4. 点 Deploy。以后每次 push 代码，Netlify 自动构建部署。
5. 默认给一个 `xxx.netlify.app` 的域名，也可以绑自己的。

Netlify 有几个实际有用的功能：
- **表单处理**：在 HTML 里加 `netlify` 属性，就能收表单数据，不需要后端。
- **Functions**：可以写简单的服务端逻辑，比如处理 webhook、发邮件。底层是 AWS Lambda。免费额度每月 125K 次请求。
- **重定向和 Header 配置**：一个 `_redirects` 文件搞定。
- **Branch Deploy**：每个分支自动生成一个预览链接，适合团队协作。

限制：Functions 有 10 秒超时，不能跑长任务。免费套餐带宽 100GB/月。

适合：静态站为主，偶尔需要一点服务端逻辑——比如表单提交、API 代理。

## Vercel

官网：https://vercel.com

Next.js 背后的公司做的。对前端框架支持最好。用 GitHub 账号直接登录。

操作步骤：
1. 打开 vercel.com，点 Sign up，选 GitHub 授权登录。
2. 导入仓库，设置构建命令和输出目录。
3. 点 Deploy。后续 push 自动部署。

Vercel 的核心差异在后端支持：
- **Serverless Functions**：支持 Node.js、Go、Python、Ruby。比 Netlify Functions 更灵活，能写完整的 API。
- **Edge Functions**：代码跑在全球边缘节点，响应更快，适合做 A/B 测试、鉴权等。
- **ISR（增量静态再生成）**：Next.js 的招牌功能，静态页面可以按需更新，不用全量重建。

限制：免费套餐 Functions 执行时间 10 秒（Pro 版 60 秒），每月 100GB 带宽，100GB-Hrs 函数执行时长。商用需要注意。

适合：前端项目为主，后端逻辑较多的情况。尤其用 Next.js 的话，Vercel 是最好的选择。

## Cloudflare Pages

官网：https://pages.cloudflare.com

CDN 起家的 Cloudflare 做的。需要注册 Cloudflare 账号，邮箱即可，免费。

操作步骤：
1. 注册 Cloudflare 账号，进入 Pages 页面。
2. 连接 GitHub 仓库，设构建命令和输出目录。
3. 推送代码，自动部署。

它的独特之处：
- **Workers**：在 Cloudflare 全球网络上跑 JavaScript/TypeScript 代码。不是传统的 Serverless，是 V8 引擎上跑的，冷启动几乎为零。
- **D1**：Cloudflare 的边缘数据库（SQLite），可以和 Pages 配合用。
- **KV / R2**：键值存储和对象存储，适合存配置、图片等。
- **Durable Objects**：有状态的 Worker，能做 WebSocket、协作编辑这类。

所有 Worker 相关服务都有免费额度，个人项目基本够用。

限制：Worker 每次请求 CPU 时间 10ms（免费版）。不能用 Node.js 原生模块，生态和传统后端不太一样。

适合：对性能要求高的静态站，或者想用 Workers 写轻量后端的项目。

## 后端支持对比

| 平台 | 静态部署 | 表单 | Serverless | 数据库 | 边缘计算 |
|------|---------|------|-----------|--------|----------|
| GitHub Pages | ✅ | ❌ | ❌ | ❌ | ❌ |
| Gitee Pages | ✅ | ❌ | ❌ | ❌ | ❌ |
| Netlify | ✅ | ✅ | ✅ (Node/Go) | ❌ | ❌ |
| Vercel | ✅ | ❌ | ✅ (多语言) | ✅ (第三方) | ✅ |
| Cloudflare Pages | ✅ | ❌ | ✅ (JS/Wasm) | ✅ (D1) | ✅ |

## 让本地智能体帮你搞定

前面这些操作，说到底是几个重复动作：创建项目、装依赖、配 Git、写配置文件、推代码、开 Pages。每一步都不难，但是多。现在可以用本地的 AI 智能体来帮你做这些。

你只需要告诉它目标，它自己动手。具体怎么配合：

**第一步：说清楚你要什么。**

不用给命令，说人话就行。比如：

- "帮我用 Hugo 搭一个博客，放到 GitHub 上，用 GitHub Pages 部署。"
- "帮我把这个项目推到 Gitee，开通 Gitee Pages。"
- "帮我装一下 Node.js 和 Hexo，创建项目，连到 Vercel。"

智能体自己知道 Hugo 怎么装、怎么初始化、GitHub Pages 怎么配。

**第二步：让它做完给你看。**

每做完一步，它可以把结果给你看——Hugo 装好了没、项目创建了没、仓库推了没、Pages 开了没。你不用自己打开浏览器一个一个点。

**第三步：审核后再发布。**

告诉它："写完文章先给我看看，通过再推送。"它就不会自作主张把内容发出去。

**第四步：日常写作和部署。**

搭好之后，日常就是：

- "写一篇关于 XXX 的博客。" — 智能体写好，给你审。
- "通过，推送吧。" — 它帮你 commit + push，平台自动部署。

全程不用离开对话界面。

本质上，智能体替代的不是你的思考，是你不想做的那些重复操作——装环境、改配置、敲 git 命令。你把精力放在内容上，剩下的交给它。

## 我的选择

先想清楚自己要什么，再选平台。

如果只是写博客、放文档，GitHub Pages 够用。不需要任何后端，纯 Markdown 生成 HTML，推上去就行。我现在就在用这个。

如果需要表单提交——比如博客加个留言板——Netlify 最省事。一个属性搞定，不用写一行后端代码。

如果需要跑一些后端逻辑，Vercel 和 Cloudflare Pages 各有优势。Vercel 对前端框架支持好，生态成熟；Cloudflare 全球 CDN 有优势，Workers 免费额度慷慨。

本地用 Git 存代码，推到一个仓库，挂上这些平台的自动部署。域名一年几十块，平台本身免费。环境搭建和日常部署交给智能体，自己只管写。对个人项目来说，够了。
