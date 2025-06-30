#!/bin/bash

# hzy_normal_network 发布脚本
# 功能：
# 1. 自动生成更新文档
# 2. 自动增加版本号
# 3. 检测本地修改是否提交到远程仓库
# 4. 创建版本标签
# 5. 发布到 pub.dev

set -e # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PUBSPEC_FILE="$PROJECT_DIR/pubspec.yaml"
CHANGELOG_FILE="$PROJECT_DIR/CHANGELOG.md"

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 获取当前版本号
get_current_version() {
    grep '^version:' "$PUBSPEC_FILE" | sed 's/version: *//'
}

# 解析版本号
parse_version() {
    local version=$1
    echo "${version//[^0-9.]/ }" | awk -F. '{print $1" "$2" "$3}'
}

# 增加版本号
increment_version() {
    local current_version=$1
    local increment_type=$2

    read -r major minor patch <<<"$(parse_version "$current_version")"

    case $increment_type in
    "major")
        major=$((major + 1))
        minor=0
        patch=0
        ;;
    "minor")
        minor=$((minor + 1))
        patch=0
        ;;
    "patch")
        patch=$((patch + 1))
        ;;
    *)
        print_error "无效的版本增量类型: $increment_type"
        exit 1
        ;;
    esac

    echo "$major.$minor.$patch"
}

# 更新 pubspec.yaml 中的版本号
update_pubspec_version() {
    local new_version=$1
    sed -i '' "s/^version: .*/version: $new_version/" "$PUBSPEC_FILE"
    print_success "已更新 pubspec.yaml 版本号为: $new_version"
}

# 检查是否有未提交的更改
check_git_status() {
    if ! git diff-index --quiet HEAD --; then
        print_error "检测到未提交的更改，请先提交所有更改后再发布"
        git status --porcelain
        exit 1
    fi

    # 检查是否有未推送的提交
    local unpushed
    unpushed=$(git log "@{u}.." --oneline 2>/dev/null | wc -l)
    if [ "$unpushed" -gt 0 ]; then
        print_error "检测到 $unpushed 个未推送的提交，请先推送到远程仓库"
        git log @{u}.. --oneline
        exit 1
    fi

    print_success "Git 状态检查通过"
}

# 生成更新日志
generate_changelog() {
    local version=$1
    local date
    date=$(date '+%Y-%m-%d')

    print_info "生成版本 $version 的更新日志..."

    # 获取上一个版本标签
    local last_tag
    last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

    if [ -z "$last_tag" ]; then
        print_warning "未找到上一个版本标签，将显示所有提交"
        local commits
        commits=$(git log --oneline --pretty=format:"- %s" | head -20)
    else
        print_info "从标签 $last_tag 开始生成更新日志"
        local commits
        commits=$(git log "${last_tag}..HEAD" --oneline --pretty=format:"- %s")
    fi

    if [ -z "$commits" ]; then
        print_warning "没有找到新的提交，使用默认更新内容"
        commits="- 版本更新\n- 优化和改进"
    fi

    # 创建临时文件
    local temp_file
    temp_file=$(mktemp)

    # 写入新的更新日志条目
    # echo "## [$version] - $date" >"$temp_file"
    # echo "" >>"$temp_file"
    # echo -e "$commits" >>"$temp_file"
    # echo "" >>"$temp_file"
    {
        echo "## [$version] - $date"
        echo ""
        echo -e "$commits"
        echo ""
    } >>"$temp_file"
    # 如果 CHANGELOG.md 存在，则合并内容
    if [ -f "$CHANGELOG_FILE" ]; then
        cat "$CHANGELOG_FILE" >>"$temp_file"
    else
        # 创建新的 CHANGELOG.md
        # echo "# 更新日志" >>"$temp_file"
        # echo "" >>"$temp_file"
        # echo "本文档记录了项目的所有重要更改。" >>"$temp_file"
        # echo "" >>"$temp_file"

        {
            echo "# 更新日志"
            echo ""
            echo "本文档记录了项目的所有重要更改。"
            echo ""
        } >>"$temp_file"
    fi

    # 替换原文件
    mv "$temp_file" "$CHANGELOG_FILE"

    print_success "已生成更新日志"
}

# 创建 Git 标签
create_git_tag() {
    local version=$1
    local tag_name="v$version"

    print_info "创建 Git 标签: $tag_name"

    # 检查标签是否已存在
    if git tag -l | grep -q "^$tag_name$"; then
        print_error "标签 $tag_name 已存在"
        exit 1
    fi

    # 创建标签
    git tag -a "$tag_name" -m "Release version $version"

    print_success "已创建标签: $tag_name"
}

# 推送标签到远程仓库
push_tag() {
    local version=$1
    local tag_name="v$version"

    print_info "推送标签到远程仓库..."
    git push origin "$tag_name"
    print_success "已推送标签: $tag_name"
}

# 发布到 pub.dev
publish_to_pub() {
    print_info "开始发布到 pub.dev..."

    # 检查是否安装了 Flutter
    if ! command -v flutter &>/dev/null; then
        print_error "Flutter 未安装或不在 PATH 中"
        return 1
    fi

    # 运行测试（如果测试目录存在）
    if [ -d "test" ] && [ "$(ls -A test 2>/dev/null)" ]; then
        print_info "运行测试..."
        flutter test || {
            print_error "测试失败，发布中止"
            return 1
        }
    else
        print_warning "未找到测试目录或测试目录为空，跳过测试"
    fi

    # 分析代码
    print_info "分析代码..."
    flutter analyze || {
        print_error "代码分析失败，发布中止"
        return 1
    }

    # 检查发布前的状态
    print_info "检查发布状态..."
    flutter pub publish --dry-run || {
        print_error "发布预检查失败"
        return 1
    }

    # 确认发布
    echo
    print_warning "即将发布到 pub.dev，请确认:"
    read -p "是否继续发布? (y/N): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        flutter pub publish || {
            print_error "发布失败"
            return 1
        }
        print_success "发布完成！"
        return 0
    else
        print_info "发布已取消"
        return 2
    fi
}

# 回滚版本号
rollback_version() {
    local original_version=$1
    print_warning "回滚版本号到: $original_version"
    update_pubspec_version "$original_version"
}

# 回滚 Git 提交
rollback_git_changes() {
    local commit_count=$1
    if [ "$commit_count" -gt 0 ]; then
        print_warning "回滚最近 $commit_count 个提交"
        git reset --hard "HEAD~${commit_count}"
    fi
}

# 删除本地标签
delete_local_tag() {
    local tag_name=$1
    if git tag -l | grep -q "^$tag_name$"; then
        print_warning "删除本地标签: $tag_name"
        git tag -d "$tag_name"
    fi
}

# 主函数
main() {
    print_info "开始 Flutter 包发布流程..."

    # 切换到项目目录
    cd "$PROJECT_DIR"

    # 检查必要文件
    if [ ! -f "$PUBSPEC_FILE" ]; then
        print_error "未找到 pubspec.yaml 文件，请确保在 Flutter 项目根目录中运行此脚本"
        exit 1
    fi

    # 获取当前版本
    local current_version
    current_version=$(get_current_version)
    print_info "当前版本: $current_version"

    # 询问版本增量类型
    echo
    print_info "请选择版本增量类型:"
    echo "1) patch (修复: \"$current_version\" -> \"$(increment_version "$current_version" "patch")\")"
    echo "2) minor (功能: \"$current_version\" -> \"$(increment_version "$current_version" "minor")\")"
    echo "3) major (重大: \"$current_version\" -> \"$(increment_version "$current_version" "major")\")"
    echo "4) 自定义版本号"
    echo "5) 使用当前版本号 ($current_version)"
    echo

    read -r -p "请选择 (1-5): " choice

    local new_version
    case $choice in
    1)
        new_version=$(increment_version "$current_version" "patch")
        ;;
    2)
        new_version=$(increment_version "$current_version" "minor")
        ;;
    3)
        new_version=$(increment_version "$current_version" "major")
        ;;
    4)
        read -r -p "请输入新版本号 (格式: x.y.z): " new_version
        if ! [[ $new_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            print_error "版本号格式无效"
            exit 1
        fi
        ;;
    5)
        new_version=$current_version
        ;;
    *)
        print_error "无效选择"
        exit 1
        ;;
    esac

    print_info "目标版本: $new_version"

    # 确认继续
    echo
    read -p "是否继续发布流程? (y/N): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "发布已取消"
        exit 0
    fi

    # 检查 Git 状态
    check_git_status

    # 记录初始状态
    local initial_version=$current_version
    local commits_made=0
    local tag_created=false
    local tag_pushed=false
    local tag_name="v$new_version"

    # 错误处理函数
    cleanup_on_error() {
        print_error "发布过程中出现错误，开始回滚..."

        # 如果推送了标签，尝试删除远程标签
        if [ "$tag_pushed" = true ]; then
            print_warning "删除远程标签: $tag_name"
            git push origin ":refs/tags/$tag_name" 2>/dev/null || true
        fi

        # 删除本地标签
        if [ "$tag_created" = true ]; then
            delete_local_tag "$tag_name"
        fi

        # 回滚 Git 提交
        if [ $commits_made -gt 0 ]; then
            rollback_git_changes $commits_made
        fi

        # 回滚版本号
        if [ "$new_version" != "$initial_version" ]; then
            rollback_version "$initial_version"
        fi

        print_error "回滚完成，项目已恢复到发布前状态"
        exit 1
    }

    # 设置错误陷阱
    trap cleanup_on_error ERR

    # 更新版本号（如果需要）
    if [ "$new_version" != "$current_version" ]; then
        update_pubspec_version "$new_version"

        # 提交版本号更改
        git add "$PUBSPEC_FILE"
        git commit -m "chore: bump version to $new_version"
        commits_made=$((commits_made + 1))
    fi

    # 生成更新日志
    generate_changelog "$new_version"

    # 提交更新日志
    if [ -f "$CHANGELOG_FILE" ]; then
        git add "$CHANGELOG_FILE"
        if git commit -m "docs: update changelog for version $new_version" 2>/dev/null; then
            commits_made=$((commits_made + 1))
        fi
    fi

    # 设置发布到官方 pub.dev
    export PUB_HOSTED_URL=https://pub.dev
    
    # 发布到 pub.dev（在推送和创建标签之前）
    publish_result=0
    publish_to_pub || publish_result=$?
    
    if [ $publish_result -eq 1 ]; then
        # 发布失败，触发回滚
        cleanup_on_error
    elif [ $publish_result -eq 2 ]; then
        # 用户取消发布，触发回滚
        cleanup_on_error
    fi

    # 发布成功后才推送更改和创建标签
    print_info "发布成功，推送更改到远程仓库..."
    git push origin "$(git branch --show-current)"

    # 创建并推送标签
    create_git_tag "$new_version"
    tag_created=true

    push_tag "$new_version"
    tag_pushed=true

    # 取消错误陷阱
    trap - ERR

    print_success "🎉 版本 $new_version 发布完成！"
    print_info "标签: v$new_version"
    print_info "更新日志已更新"
    print_info "已发布到 pub.dev"
}

# 运行主函数
main "$@"
