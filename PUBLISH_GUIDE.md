# 发布指南

本文档介绍如何使用自动化发布脚本来发布 `hzy_normal_network` 包到 pub.dev。

## 脚本功能

发布脚本提供以下功能：

1. **自动版本管理**：支持语义化版本控制（major.minor.patch）
2. **自动生成更新日志**：基于 Git 提交历史生成 CHANGELOG.md
3. **Git 状态检查**：确保所有更改已提交并推送到远程仓库
4. **自动标签管理**：为每个版本创建对应的 Git 标签
5. **代码质量检查**：运行测试和代码分析
6. **自动发布**：发布到 pub.dev

## 使用方法

### macOS/Linux 用户

使用 Bash 脚本：

```bash
# 进入项目目录
cd /path/to/hzy_normal_network

# 运行发布脚本
./publish.sh
```

### Windows 用户

使用批处理脚本：

```cmd
REM 进入项目目录
cd C:\path\to\hzy_normal_network

REM 运行发布脚本
publish.bat
```

## 发布流程

### 1. 准备工作

在运行发布脚本之前，请确保：

- ✅ 已安装 Flutter SDK
- ✅ 已配置 pub.dev 账户和认证
- ✅ 项目代码已完成开发和测试
- ✅ 所有更改已提交到 Git
- ✅ 本地分支与远程分支同步

### 2. 运行脚本

运行发布脚本后，系统会提示您选择版本增量类型：

```
请选择版本增量类型:
1) patch (修复: 0.0.2 -> 0.0.3)
2) minor (功能: 0.0.2 -> 0.1.0)
3) major (重大: 0.0.2 -> 1.0.0)
4) 自定义版本号
5) 使用当前版本号 (0.0.2)

请选择 (1-5):
```

#### 版本类型说明

- **patch (修复版本)**：用于 bug 修复和小的改进
- **minor (功能版本)**：用于新功能添加，向后兼容
- **major (重大版本)**：用于重大更改，可能不向后兼容
- **自定义版本号**：手动输入版本号
- **使用当前版本号**：不更改版本号，重新发布当前版本

### 3. 自动化流程

选择版本后，脚本将自动执行以下步骤：

1. **Git 状态检查**
   - 检查是否有未提交的更改
   - 检查是否有未推送的提交

2. **版本号更新**
   - 更新 `pubspec.yaml` 中的版本号
   - 提交版本号更改

3. **生成更新日志**
   - 基于 Git 提交历史生成 `CHANGELOG.md`
   - 提交更新日志

4. **推送更改**
   - 推送所有更改到远程仓库

5. **创建标签**
   - 创建版本标签（如 `v0.0.3`）
   - 推送标签到远程仓库

6. **代码质量检查**
   - 运行 `flutter test`
   - 运行 `flutter analyze`
   - 运行 `flutter pub publish --dry-run`

7. **发布确认**
   - 提示用户确认发布
   - 执行 `flutter pub publish`

## 配置 pub.dev 认证

首次发布前，需要配置 pub.dev 认证：

```bash
# 登录 pub.dev 账户
flutter pub login

# 或者使用 dart 命令
dart pub login
```

按照提示完成认证流程。

## 常见问题

### Q: 脚本提示 "检测到未提交的更改"

**A:** 请先提交所有更改：

```bash
git add .
git commit -m "your commit message"
git push
```

### Q: 脚本提示 "检测到未推送的提交"

**A:** 请先推送到远程仓库：

```bash
git push origin main
```

### Q: 测试失败导致发布中止

**A:** 请修复测试问题后重新运行脚本：

```bash
# 运行测试查看具体错误
flutter test

# 修复问题后重新发布
./publish.sh
```

### Q: 代码分析失败

**A:** 请修复代码分析问题：

```bash
# 查看分析结果
flutter analyze

# 修复问题后重新发布
./publish.sh
```

### Q: 标签已存在

**A:** 如果标签已存在，可以：

1. 选择不同的版本号
2. 或删除现有标签（谨慎操作）：

```bash
# 删除本地标签
git tag -d v0.0.3

# 删除远程标签
git push origin :refs/tags/v0.0.3
```

### Q: pub.dev 发布失败

**A:** 常见原因和解决方案：

1. **未登录**：运行 `flutter pub login`
2. **包名冲突**：检查包名是否已被占用
3. **版本号问题**：确保版本号大于已发布的版本
4. **文件缺失**：确保 `README.md`、`CHANGELOG.md` 等文件存在

## 手动发布

如果自动化脚本出现问题，也可以手动发布：

```bash
# 1. 更新版本号
# 编辑 pubspec.yaml 文件

# 2. 更新 CHANGELOG.md
# 手动编辑更新日志

# 3. 提交更改
git add .
git commit -m "chore: bump version to x.y.z"
git push

# 4. 创建标签
git tag -a "vx.y.z" -m "Release version x.y.z"
git push origin "vx.y.z"

# 5. 发布
flutter pub publish
```

## 最佳实践

1. **定期发布**：建议定期发布新版本，保持包的活跃度

2. **语义化版本**：严格遵循语义化版本控制规范

3. **详细的提交信息**：编写清晰的提交信息，便于生成更新日志

4. **测试覆盖**：确保有足够的测试覆盖率

5. **文档更新**：及时更新 README.md 和 API 文档

6. **向后兼容**：尽量保持向后兼容，避免破坏性更改

## 提交信息规范

为了生成更好的更新日志，建议使用以下提交信息格式：

```
type(scope): description

[optional body]

[optional footer]
```

### 类型（type）

- `feat`: 新功能
- `fix`: bug 修复
- `docs`: 文档更新
- `style`: 代码格式化
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具的变动

### 示例

```bash
git commit -m "feat: add request timeout configuration"
git commit -m "fix: resolve null pointer exception in response handler"
git commit -m "docs: update README with new examples"
git commit -m "refactor: improve error handling mechanism"
```

## 支持

如果在使用发布脚本过程中遇到问题，请：

1. 检查本文档的常见问题部分
2. 在项目仓库提交 Issue
3. 联系项目维护者

---

**注意**：首次使用发布脚本前，建议在测试环境中验证脚本功能。