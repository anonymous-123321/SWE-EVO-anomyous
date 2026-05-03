#!/usr/bin/env bash
set -euo pipefail

MODELS_FW=(
  # "glm-4p5"
  # "deepseek-r1-0528"
  # "qwen3-coder-30b-a3b-instruct" # By somehow, this model are curently dead in fireworks api key
  "qwen3-coder-480b-a35b-instruct"
  # "gpt-oss-120b"
)

# Run batch for model in fireworks
for MODEL in "${MODELS_FW[@]}"; do
  echo ">>> Running SWE-agent with model: ${MODEL}"

  sweagent run-batch \
    --config config/default.yaml \
    --agent.model.name "fireworks_ai/accounts/fireworks/models/${MODEL}" \
    --agent.model.api_key "${FIREWORKS_API_KEY}" \
    --agent.model.api_base "https://api.fireworks.ai/inference/v1" \
    --instances.type swe_bench \
    --instances.path_override "../hf_out/hf_dataset" \
    --instances.split test \
    --instances.slice :1000 \
    --num_workers 4 \
    --output_dir "trajectories/${MODEL}"
done



MODEL="gpt-5-2025-08-07"
sweagent run-batch \
  --config config/default.yaml \
  --agent.model.name "${MODEL}" \
  --agent.model.api_key "${OPENAI_API_KEY}" \
  --agent.model.api_base "api_base" \
  --agent.model.use_litellm "true" \
  --agent.model.reasoning_effort "medium" \
  --instances.type swe_bench \
  --instances.path_override "your_project_path/SWE-EVO/hf_out/hf_dataset" \
  --instances.split test \
  --instances.slice :1000 \
  --num_workers 4 \
  --output_dir "trajectories/${MODEL}"