#!/bin/bash

# 콘텐츠 디렉토리 설정
CONTENT_DIR="content"
# 정적 파일 디렉토리 설정
STATIC_DIR="$CONTENT_DIR/posts/static"

mv "$CONTENT_DIR/posts/assets" "$STATIC_DIR/assets"