export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Homebrew SQLite (with extension loading enabled)
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.pixi/bin:$PATH"
# Add Npm Global Bin to PATH
export PATH="$HOME/.npm-global/bin:$PATH"

# Dont want to auto update homebrew so I can update to releases used for atleast seven days by the community to avoid prompt injection or exfiltration hack attempts
export HOMEBREW_NO_AUTO_UPDATE=1

[ -f "$HOME/.zshrc.secrets" ] && source "$HOME/.zshrc.secrets"

kill_port() {
  if [ -z "$1" ]; then
    echo "Usage: kill_port <port>"
    return 1
  fi
  lsof -ti:$1 | xargs kill -9 2>/dev/null && echo "Killed processes on port $1" || echo "No processes found on port $1"
}

alias sublime="subl"
alias clauded='claude --dangerously-skip-permissions'

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc" ; fi

# ── Claude Code Provider Config ──────────────────────────────────────
# Set to "vertex" or "bedrock" or "anthropic"
CLAUDE_PROVIDER="vertex"

# Vertex AI settings
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/claude-vertex-key.json"
export CLOUD_ML_REGION=global #us-east5
export ANTHROPIC_VERTEX_PROJECT_ID=oleum-claude-code
# AWS settings
export AWS_REGION="us-east-1"

if [[ "$CLAUDE_PROVIDER" == "vertex" ]]; then
  export CLAUDE_CODE_USE_VERTEX=1
  unset CLAUDE_CODE_USE_BEDROCK
  export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-4-6[1m]"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4-6[1m]"
  # export ANTHROPIC_SMALL_FAST_MODEL="claude-haiku-4-5@20251001"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="claude-haiku-4-5@20251001"
elif [[ "$CLAUDE_PROVIDER" == "bedrock" ]]; then
  export CLAUDE_CODE_USE_BEDROCK=1
  unset CLAUDE_CODE_USE_VERTEX
  # General-purpose recommendation: Bedrock global inference profiles.
  # If you require US-only routing, replace global. with us.
  export ANTHROPIC_DEFAULT_SONNET_MODEL="global.anthropic.claude-sonnet-4-6[1m]"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="global.anthropic.claude-opus-4-6-v1[1m]"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="global.anthropic.claude-haiku-4-5-20251001-v1:0"
elif [[ "$CLAUDE_PROVIDER" == "anthropic" ]]; then
  unset CLAUDE_CODE_USE_VERTEX
  unset CLAUDE_CODE_USE_BEDROCK
  export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-4-6[1m]"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4-6[1m]"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="claude-haiku-4-5-20251001"
fi
