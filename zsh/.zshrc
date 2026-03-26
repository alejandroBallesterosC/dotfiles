# Open all git worktrees in a single Cursor workspace
compare-worktrees() {
  local repo_root=$(git rev-parse --git-common-dir 2>/dev/null | xargs dirname)
  local repo_name=$(basename "$repo_root")
  local workspace_file="/tmp/${repo_name}-worktrees.code-workspace"
  
  # Generate workspace JSON
  local folders=$(git worktree list --porcelain | grep "^worktree" | sed 's/^worktree //' | \
    awk 'BEGIN{first=1} {if(!first)printf ","; first=0; printf "\n    { \"path\": \"%s\" }", $0}')
  
  echo "{
  \"folders\": [$folders
  ]
}" > "$workspace_file"
  
  cursor --new-window "$workspace_file"
}

# Script for killing all processes on a port
kill_port() {
  if [ -z "$1" ]; then
    echo "Usage: kill_port <port>"
    return 1
  fi
  lsof -ti:$1 | xargs kill -9 2>/dev/null && echo "Killed processes on port $1" || echo "No processes found on port $1"
}

# Sublime Alias
alias sublime="subl"

# Claude Code Skip Perms Alias
alias clauded='claude --dangerously-skip-permissions'

# ── Claude Code Provider Config ──────────────────────────────────────
# Set to "vertex" or "bedrock" or "anthropic"
CLAUDE_PROVIDER="vertex"

# Vertex AI settings
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/claude-vertex-key.json"
export CLOUD_ML_REGION=us-east5 #global
export ANTHROPIC_VERTEX_PROJECT_ID=oleum-claude-code
# AWS settings
export AWS_REGION="us-east-1"

if [[ "$CLAUDE_PROVIDER" == "vertex" ]]; then
  export CLAUDE_CODE_USE_VERTEX=1
  unset CLAUDE_CODE_USE_BEDROCK
  export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-4-6"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4-6"
  export ANTHROPIC_SMALL_FAST_MODEL="claude-haiku-4-5@20251001"
elif [[ "$CLAUDE_PROVIDER" == "bedrock" ]]; then
  export CLAUDE_CODE_USE_BEDROCK=1
  unset CLAUDE_CODE_USE_VERTEX
  export ANTHROPIC_DEFAULT_SONNET_MODEL="us.anthropic.claude-sonnet-4-6"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="us.anthropic.claude-opus-4-6-v1"
  export ANTHROPIC_SMALL_FAST_MODEL="us.anthropic.claude-haiku-4-5-20251001-v1:0"
elif [[ "$CLAUDE_PROVIDER" == "anthropic" ]]; then
  unset CLAUDE_CODE_USE_VERTEX
  unset CLAUDE_CODE_USE_BEDROCK
  export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-4-6"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4-6"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="claude-haiku-4-5-20251001"
fi
