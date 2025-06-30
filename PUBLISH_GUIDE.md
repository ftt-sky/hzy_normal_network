# 发布指南

本文档介绍如何使用自动化发布脚本来发布 `hzy_normal_network` 包到 pub.dev。

## 脚本功能

发布脚本提供以下功能：

1. **自动版本管理**：支持 patch、minor、major 版本增量，或自定义版本号
2. **更新日志生成**：自动更新 CHANGELOG.md 文件
3. **Git 集成**：自动提交、推送和创建标签
4. **智能测试检查**：如果存在测试目录则运行测试，否则跳过
5. **发布前检查**：代码分析和发布预检查
6. **pub.dev 发布**：自动发布到 pub.dev 平台
7. **错误回滚**：发布失败时自动回滚版本号、Git 提交和标签
8. **通用性**：可在任何 Flutter 项目中直接使用

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

### 准备工作

1. 确保所有代码已提交到 Git
2. 确保本地分支与远程分支同步
3. 确保已配置 pub.dev 认证（见下文）

### 运行脚本

**macOS/Linux：**
```bash
./publish.sh
```

**Windows：**
```cmd
publish.bat
```

### 自动化流程

脚本将按以下顺序执行：

1. **检查环境**：验证 Flutter 安装和项目文件
2. **版本选择**：选择版本增量类型或输入自定义版本
3. **Git 状态检查**：确保工作目录干净且与远程同步
4. **版本更新**：更新 pubspec.yaml 中的版本号
5. **更新日志**：生成或更新 CHANGELOG.md
6. **质量检查**：运行代码分析，如果存在测试则运行测试
7. **发布确认**：显示发布信息并等待确认
8. **pub.dev 发布**：执行实际发布操作
9. **Git 操作**：发布成功后提交更改并推送到远程仓库
10. **标签创建**：创建并推送版本标签

### 错误处理和回滚

如果发布过程中出现错误，脚本会自动执行回滚操作：

- **删除远程标签**：如果已推送标签
- **删除本地标签**：如果已创建标签
- **回滚 Git 提交**：撤销版本号和更新日志的提交
- **恢复版本号**：将 pubspec.yaml 恢复到原始版本

## 配置 pub.dev 认证

脚本已配置为直接发布到官方 pub.dev。在首次发布前，需要配置 pub.dev 认证：

```bash
# 登录 pub.dev 账户
flutter pub login

# 或者使用 dart 命令
dart pub login
```

按照提示完成认证流程。脚本会自动设置 `PUB_HOSTED_URL=https://pub.dev` 确保发布到官方仓库。

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

### Q: 没有测试目录会怎样？

**A:** 脚本会自动检测测试目录，如果不存在或为空则跳过测试步骤，不会影响发布流程。

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

### Q: 发布到 pub.dev 失败怎么办？

**A:** 脚本会自动回滚所有更改，包括版本号和 Git 提交。修复问题后可以重新运行脚本。

### Q: 如何在其他项目中使用？

**A:** 直接将 `publish.sh` 或 `publish.bat` 复制到任何 Flutter 项目根目录即可使用，无需修改。

### Q: 发布过程中断网怎么办？

**A:** 如果在推送到 pub.dev 时断网，脚本会检测到失败并自动回滚。网络恢复后重新运行即可。

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

1. **通用脚本**：将脚本复制到每个 Flutter 项目中，无需修改即可使用
2. **版本规范**：遵循语义化版本控制（patch/minor/major）
3. **测试覆盖**：虽然脚本会跳过缺失的测试，但建议添加测试以提高代码质量
4. **代码质量**：保持代码分析无警告
5. **Git 习惯**：发布前确保所有更改已提交
6. **网络稳定**：确保网络连接稳定，避免发布过程中断
7. **权限检查**：确保有足够的 Git 和 pub.dev 权限
8. **错误处理**：如果发布失败，检查错误信息后重新运行脚本

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