# Prompt: bold green user@host, bold blue path, matching Ubuntu's default bash PS1,
# plus git branch/status via zsh's built-in vcs_info (dirty files shown in red, staged in yellow)
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr ' %F{yellow}●%f'
zstyle ':vcs_info:git:*' unstagedstr ' %F{red}●%f'
zstyle ':vcs_info:git:*' formats ' %F{magenta}(%b%u%c)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta}(%b|%a%u%c)%f'
precmd_functions+=(vcs_info)

setopt PROMPT_SUBST
PROMPT='%B%F{green}%n@%m%f%b:%B%F{blue}%~%f%b${vcs_info_msg_0_}%# '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Homebrew SQLite (with extension loading enabled)
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.pixi/bin:$PATH"

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

# Custom rsync wrapper bypassing SSH RemoteCommand
mmsync() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: mmsync [options] <source> <destination>"
    echo "Example: mmsync jandro@macmini.local:path/to/file.html ~/Desktop/"
    return 1
  fi

  rsync -avz --progress -e "ssh -o RemoteCommand=none" "$@"
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc" ; fi


# ── Claude Code Provider Config ──────────────────────────────────────
# NOTE: CHANGE THIS to "vertex" or "bedrock" or "anthropic"
CLAUDE_PROVIDER="bedrock"
# Vertex AI settings
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/claude-vertex-key.json"
export CLOUD_ML_REGION=global #us-east5
export ANTHROPIC_VERTEX_PROJECT_ID=oleum-claude-code
# AWS settings
export AWS_REGION="us-east-1"
# Set Default Models for each Provider
if [[ "$CLAUDE_PROVIDER" == "vertex" ]]; then
  export CLAUDE_CODE_USE_VERTEX=1
  unset CLAUDE_CODE_USE_BEDROCK
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="claude-haiku-4-5@20251001"
  export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-5[1m]"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4-8[1m]"
  export ANTHROPIC_DEFAULT_FABLE_MODEL="claude-fable-5[1m]"
elif [[ "$CLAUDE_PROVIDER" == "bedrock" ]]; then
  # General-purpose recommendation: Bedrock global inference profiles (higher throughput/availability)
  # For US-only routing, replace 'global.anthropic..' with 'us.anthropic..'.
  export CLAUDE_CODE_USE_BEDROCK=1
  unset CLAUDE_CODE_USE_VERTEX
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="global.anthropic.claude-haiku-4-5-20251001-v1:0"
  export ANTHROPIC_DEFAULT_SONNET_MODEL="global.anthropic.claude-sonnet-5[1m]"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="global.anthropic.claude-opus-4-8[1m]"
  export ANTHROPIC_DEFAULT_FABLE_MODEL="global.anthropic.claude-fable-5[1m]"
elif [[ "$CLAUDE_PROVIDER" == "anthropic" ]]; then
  unset CLAUDE_CODE_USE_VERTEX
  unset CLAUDE_CODE_USE_BEDROCK
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="claude-haiku-4-5-20251001"
  export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-5[1m]"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4-8[1m]"
  export ANTHROPIC_DEFAULT_FABLE_MODEL="claude-fable-5[1m]"
fi


# ── Oleum Dev Box Helpers ──────────────────────────────────────
# Stop for the day (keeps everything, no rebuild needed):
# Compute billing stops; EBS storage (~$32/mo for 400GB) keeps billing.
# Tailscale hostname (oleum-devbox) goes offline while stopped and reappears once restarted
# no reconfiguration needed. Public IP will change on next start, but you don't rely on it.
dev_stop() {
  aws ec2 stop-instances --instance-ids i-0643e4deb2e1db7d0 --region us-east-1
}

# Start it back up:
# Give it 30-60 seconds to boot and rejoin Tailscale before ssh oleum-devbox works.
dev_start()  {
  aws ec2 start-instances --instance-ids i-0643e4deb2e1db7d0 --region us-east-1
}

# Check current state:
dev_describe() {
  aws ec2 describe-instances --instance-ids i-0643e4deb2e1db7d0 --region us-east-1 --query 'Reservations[0].Instances[0].State.Name' --output text
}
