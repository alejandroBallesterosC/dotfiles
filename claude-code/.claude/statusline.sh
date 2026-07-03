#!/usr/bin/env bash
# ABOUTME: Claude Code statusline showing cwd, git branch, model, output style, and context usage.
# ABOUTME: Corrects context_window_size for models where Claude Code under-reports it (see below).

input=$(cat)

dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
model_id=$(echo "$input" | jq -r '.model.id // empty')
style=$(echo "$input" | jq -r '.output_style.name')
used_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

# Claude Code (as of 2.1.200) reports a 200k context_window_size for these
# models even though they actually run with a 1M window on Bedrock/Vertex/
# first-party (see https://github.com/anthropics/claude-code/issues/63447).
# Override the denominator only when Claude Code's own value is smaller, so
# this becomes a no-op once upstream fixes the report.
case "$model_id" in
  *opus-4-6*|*opus-4-7*|*opus-4-8*|*sonnet-4-6*|*sonnet-5*|*fable-5*|*mythos-5*)
    true_window=1000000
    ;;
  *)
    true_window=""
    ;;
esac
if [ -n "$true_window" ] && { [ -z "$ctx_size" ] || [ "$true_window" -gt "$ctx_size" ]; }; then
  ctx_size=$true_window
fi

short_dir="${dir/#$HOME/~}"

git_info=""
if git -C "$dir" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$dir" branch --show-current 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
  [ -n "$branch" ] && git_info=" ($(printf '\033[35m')$branch$(printf '\033[0m'))"
fi

printf '\033[2m\033[36m%s\033[0m\033[2m%s | \033[34m%s\033[0m\033[2m' "$short_dir" "$git_info" "$model"
[ "$style" != "default" ] && [ "$style" != "null" ] && printf ' | \033[33m%s\033[0m\033[2m' "$style"

if [ -n "$used_tokens" ] && [ -n "$ctx_size" ] && [ "$ctx_size" -gt 0 ]; then
  used_pct=$(( used_tokens * 100 / ctx_size ))
  [ "$used_pct" -gt 100 ] && used_pct=100
  remaining_k=$(( (ctx_size - used_tokens) / 1000 ))
  [ "$remaining_k" -lt 0 ] && remaining_k=0
  printf ' | \033[32mctx: %s%% (%sk left)\033[0m\033[2m' "$used_pct" "$remaining_k"
fi

printf '\033[0m'
