@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM hzy_normal_network 发布脚本 (Windows版本)
REM 功能：
REM 1. 自动生成更新文档
REM 2. 自动增加版本号
REM 3. 检测本地修改是否提交到远程仓库
REM 4. 创建版本标签
REM 5. 发布到 pub.dev

REM 颜色定义
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM 项目根目录
set "PROJECT_DIR=%~dp0"
set "PUBSPEC_FILE=%PROJECT_DIR%pubspec.yaml"
set "CHANGELOG_FILE=%PROJECT_DIR%CHANGELOG.md"

REM 打印带颜色的消息
:print_info
echo %BLUE%[INFO]%NC% %~1
goto :eof

:print_success
echo %GREEN%[SUCCESS]%NC% %~1
goto :eof

:print_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:print_error
echo %RED%[ERROR]%NC% %~1
goto :eof

REM 获取当前版本号
:get_current_version
for /f "tokens=2" %%i in ('findstr "^version:" "%PUBSPEC_FILE%"') do (
    set "CURRENT_VERSION=%%i"
)
goto :eof

REM 增加版本号
:increment_version
set "version=%~1"
set "increment_type=%~2"

for /f "tokens=1,2,3 delims=." %%a in ("%version%") do (
    set "major=%%a"
    set "minor=%%b"
    set "patch=%%c"
)

if "%increment_type%"=="major" (
    set /a major+=1
    set "minor=0"
    set "patch=0"
) else if "%increment_type%"=="minor" (
    set /a minor+=1
    set "patch=0"
) else if "%increment_type%"=="patch" (
    set /a patch+=1
)

set "NEW_VERSION=%major%.%minor%.%patch%"
goto :eof

REM 更新 pubspec.yaml 中的版本号
:update_pubspec_version
set "new_version=%~1"
powershell -Command "(Get-Content '%PUBSPEC_FILE%') -replace '^version: .*', 'version: %new_version%' | Set-Content '%PUBSPEC_FILE%'"
call :print_success "已更新 pubspec.yaml 版本号为: %new_version%"
goto :eof

REM 检查是否有未提交的更改
:check_git_status
git diff-index --quiet HEAD -- >nul 2>&1
if errorlevel 1 (
    call :print_error "检测到未提交的更改，请先提交所有更改后再发布"
    git status --porcelain
    exit /b 1
)

REM 检查是否有未推送的提交
git log @{u}.. --oneline >nul 2>&1
if not errorlevel 1 (
    for /f %%i in ('git log @{u}.. --oneline ^| find /c /v ""') do set "unpushed=%%i"
    if !unpushed! gtr 0 (
        call :print_error "检测到 !unpushed! 个未推送的提交，请先推送到远程仓库"
        git log @{u}.. --oneline
        exit /b 1
    )
)

call :print_success "Git 状态检查通过"
goto :eof

REM 生成更新日志
:generate_changelog
set "version=%~1"
for /f "tokens=1-3 delims=/" %%a in ('%date%') do set "current_date=%%c-%%a-%%b"

call :print_info "生成版本 %version% 的更新日志..."

REM 获取上一个版本标签
for /f "delims=" %%i in ('git describe --tags --abbrev=0 2^>nul') do set "last_tag=%%i"

if "%last_tag%"=="" (
    call :print_warning "未找到上一个版本标签，将显示所有提交"
    git log --oneline --pretty=format:"- %%s" | head -20 > temp_commits.txt
) else (
    call :print_info "从标签 %last_tag% 开始生成更新日志"
    git log %last_tag%..HEAD --oneline --pretty=format:"- %%s" > temp_commits.txt
)

REM 创建新的更新日志
echo ## [%version%] - %current_date% > temp_changelog.md
echo. >> temp_changelog.md
type temp_commits.txt >> temp_changelog.md 2>nul
echo. >> temp_changelog.md

if exist "%CHANGELOG_FILE%" (
    type "%CHANGELOG_FILE%" >> temp_changelog.md
) else (
    echo # 更新日志 >> temp_changelog.md
    echo. >> temp_changelog.md
    echo 本文档记录了项目的所有重要更改。 >> temp_changelog.md
    echo. >> temp_changelog.md
)

move temp_changelog.md "%CHANGELOG_FILE%" >nul
del temp_commits.txt 2>nul

call :print_success "已生成更新日志"
goto :eof

REM 创建 Git 标签
:create_git_tag
set "version=%~1"
set "tag_name=v%version%"

call :print_info "创建 Git 标签: %tag_name%"

REM 检查标签是否已存在
git tag -l | findstr "^%tag_name%$" >nul
if not errorlevel 1 (
    call :print_error "标签 %tag_name% 已存在"
    exit /b 1
)

REM 创建标签
git tag -a "%tag_name%" -m "Release version %version%"

call :print_success "已创建标签: %tag_name%"
goto :eof

REM 推送标签到远程仓库
:push_tag
set "version=%~1"
set "tag_name=v%version%"

call :print_info "推送标签到远程仓库..."
git push origin "%tag_name%"
call :print_success "已推送标签: %tag_name%"
goto :eof

REM 发布到 pub.dev
:publish_to_pub
call :print_info "开始发布到 pub.dev..."

REM 检查是否安装了 Flutter
flutter --version >nul 2>&1
if errorlevel 1 (
    call :print_error "Flutter 未安装或不在 PATH 中"
    exit /b 1
)

REM 运行测试（如果测试目录存在）
if exist "test" (
    dir /b "test" >nul 2>&1
    if not errorlevel 1 (
        call :print_info "运行测试..."
        flutter test
        if errorlevel 1 (
            call :print_error "测试失败，发布中止"
            exit /b 1
        )
    ) else (
        call :print_warning "测试目录为空，跳过测试"
    )
) else (
    call :print_warning "未找到测试目录，跳过测试"
)

REM 分析代码
call :print_info "分析代码..."
flutter analyze
if errorlevel 1 (
    call :print_error "代码分析失败，发布中止"
    exit /b 1
)

REM 检查发布前的状态
call :print_info "检查发布状态..."
flutter pub publish --dry-run
if errorlevel 1 (
    call :print_error "发布预检查失败"
    exit /b 1
)

REM 确认发布
echo.
call :print_warning "即将发布到 pub.dev，请确认:"
set /p "confirm=是否继续发布? (y/N): "

if /i "%confirm%"=="y" (
    flutter pub publish
    if errorlevel 1 (
        call :print_error "发布失败"
        exit /b 1
    )
    call :print_success "发布完成！"
    exit /b 0
) else (
    call :print_info "发布已取消"
    exit /b 2
)
goto :eof

REM 回滚版本号
:rollback_version
set "original_version=%~1"
call :print_warning "回滚版本号到: %original_version%"
call :update_pubspec_version %original_version%
goto :eof

REM 回滚 Git 提交
:rollback_git_changes
set "commit_count=%~1"
if %commit_count% gtr 0 (
    call :print_warning "回滚最近 %commit_count% 个提交"
    git reset --hard HEAD~%commit_count%
)
goto :eof

REM 删除本地标签
:delete_local_tag
set "tag_name=%~1"
git tag -l | findstr /x "%tag_name%" >nul
if not errorlevel 1 (
    call :print_warning "删除本地标签: %tag_name%"
    git tag -d "%tag_name%"
)
goto :eof

REM 错误清理函数
:cleanup_on_error
call :print_error "发布过程中出现错误，开始回滚..."

REM 如果推送了标签，尝试删除远程标签
if "%tag_pushed%"=="true" (
    call :print_warning "删除远程标签: %tag_name%"
    git push origin ":refs/tags/%tag_name%" 2>nul
)

REM 删除本地标签
if "%tag_created%"=="true" (
    call :delete_local_tag "%tag_name%"
)

REM 回滚 Git 提交
if %commits_made% gtr 0 (
    call :rollback_git_changes %commits_made%
)

REM 回滚版本号
if not "%TARGET_VERSION%"=="%initial_version%" (
    call :rollback_version "%initial_version%"
)

call :print_error "回滚完成，项目已恢复到发布前状态"
exit /b 1

REM 主函数
:main
call :print_info "开始 Flutter 包发布流程..."

REM 切换到项目目录
cd /d "%PROJECT_DIR%"

REM 检查必要文件
if not exist "%PUBSPEC_FILE%" (
    call :print_error "未找到 pubspec.yaml 文件，请确保在 Flutter 项目根目录中运行此脚本"
    exit /b 1
)

REM 获取当前版本
call :get_current_version
call :print_info "当前版本: %CURRENT_VERSION%"

REM 询问版本增量类型
echo.
call :print_info "请选择版本增量类型:"

call :increment_version %CURRENT_VERSION% patch
echo 1^) patch ^(修复: %CURRENT_VERSION% -^> %NEW_VERSION%^)

call :increment_version %CURRENT_VERSION% minor
echo 2^) minor ^(功能: %CURRENT_VERSION% -^> %NEW_VERSION%^)

call :increment_version %CURRENT_VERSION% major
echo 3^) major ^(重大: %CURRENT_VERSION% -^> %NEW_VERSION%^)

echo 4^) 自定义版本号
echo 5^) 使用当前版本号 ^(%CURRENT_VERSION%^)
echo.

set /p "choice=请选择 (1-5): "

if "%choice%"=="1" (
    call :increment_version %CURRENT_VERSION% patch
    set "TARGET_VERSION=%NEW_VERSION%"
) else if "%choice%"=="2" (
    call :increment_version %CURRENT_VERSION% minor
    set "TARGET_VERSION=%NEW_VERSION%"
) else if "%choice%"=="3" (
    call :increment_version %CURRENT_VERSION% major
    set "TARGET_VERSION=%NEW_VERSION%"
) else if "%choice%"=="4" (
    set /p "TARGET_VERSION=请输入新版本号 (格式: x.y.z): "
    echo %TARGET_VERSION% | findstr /r "^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$" >nul
    if errorlevel 1 (
        call :print_error "版本号格式无效"
        exit /b 1
    )
) else if "%choice%"=="5" (
    set "TARGET_VERSION=%CURRENT_VERSION%"
) else (
    call :print_error "无效选择"
    exit /b 1
)

call :print_info "目标版本: %TARGET_VERSION%"

REM 确认继续
echo.
set /p "continue=是否继续发布流程? (y/N): "

if /i not "%continue%"=="y" (
    call :print_info "发布已取消"
    exit /b 0
)

REM 检查 Git 状态
call :check_git_status

REM 记录初始状态
set "initial_version=%CURRENT_VERSION%"
set "commits_made=0"
set "tag_created=false"
set "tag_pushed=false"
set "tag_name=v%TARGET_VERSION%"

REM 更新版本号（如果需要）
if not "%TARGET_VERSION%"=="%CURRENT_VERSION%" (
    call :update_pubspec_version %TARGET_VERSION%
    
    REM 提交版本号更改
    git add "%PUBSPEC_FILE%"
    git commit -m "chore: bump version to %TARGET_VERSION%"
    if not errorlevel 1 set /a commits_made+=1
)

REM 生成更新日志
call :generate_changelog %TARGET_VERSION%

REM 提交更新日志
if exist "%CHANGELOG_FILE%" (
    git add "%CHANGELOG_FILE%"
    git commit -m "docs: update changelog for version %TARGET_VERSION%" 2>nul
    if not errorlevel 1 set /a commits_made+=1
)

REM 设置发布到官方 pub.dev
 set "PUB_HOSTED_URL=https://pub.dev"
 
 REM 发布到 pub.dev（在推送和创建标签之前）
 call :publish_to_pub
 set "publish_result=%errorlevel%"
 
 if %publish_result% equ 1 (
     REM 发布失败，触发回滚
     call :cleanup_on_error
 ) else if %publish_result% equ 2 (
     REM 用户取消发布，触发回滚
     call :cleanup_on_error
 )

REM 发布成功后才推送更改和创建标签
call :print_info "发布成功，推送更改到远程仓库..."
for /f "delims=" %%i in ('git branch --show-current') do set "current_branch=%%i"
git push origin %current_branch%
if errorlevel 1 call :cleanup_on_error

REM 创建并推送标签
call :create_git_tag %TARGET_VERSION%
if errorlevel 1 call :cleanup_on_error
set "tag_created=true"

call :push_tag %TARGET_VERSION%
if errorlevel 1 call :cleanup_on_error
set "tag_pushed=true"

call :print_success "🎉 版本 %TARGET_VERSION% 发布完成！"
call :print_info "标签: v%TARGET_VERSION%"
call :print_info "更新日志已更新"
call :print_info "已发布到 pub.dev"

goto :eof

REM 运行主函数
call :main %*