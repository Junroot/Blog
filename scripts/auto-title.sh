#!/bin/bash

# 콘텐츠 디렉토리 설정
CONTENT_DIR="content"

# 콘텐츠 디렉토리 내의 모든 Markdown 파일을 재귀적으로 탐색
find "$CONTENT_DIR" -type f -name "*.md" | while IFS= read -r filepath; do
    # 파일 인코딩 확인 (UTF-8로 가정)
    # 기존에 title이 설정되어 있는지 확인
    title_exist=$(grep -E "^title:.*" "$filepath")
    if [ -n "$title_exist" ]; then
        # title이 이미 존재하면 건너뜁니다 (덮어쓰려면 이 부분을 수정)
        continue
    fi

    # 첫 번째 h1 헤딩 추출
    h1_heading=$(grep -m 1 -E "^#\s*(.*)" "$filepath" | sed 's/^#\s*//' | sed 's/"/\\\\"/g')

    if [ -n "$h1_heading" ]; then
        echo "Updating title in $filepath: $h1_heading"

        # Front Matter의 끝 위치 찾기
        frontmatter_end_line=$(awk '/^---\s*$/{i++}i==2{print NR; exit}' "$filepath")
        if [ -z "$frontmatter_end_line" ]; then
            echo "Front Matter가 올바르지 않습니다: $filepath"
            continue
        fi

        # title을 Front Matter에 추가
        # 임시 파일에 수정된 내용 저장
        awk -v h1_heading="$h1_heading" 'NR=='$frontmatter_end_line'{print "title: \""h1_heading "\""}1' "$filepath" > "$filepath.tmp"

        # 원본 파일 교체
        mv "$filepath.tmp" "$filepath"
    else
        echo "No h1 heading found in $filepath"
    fi
done
