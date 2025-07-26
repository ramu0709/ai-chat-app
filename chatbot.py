import os
from transformers import AutoTokenizer, AutoModelForCausalLM

token = os.getenv("HUGGINGFACE_TOKEN")
if not token:
    raise ValueError("❌ Missing HUGGINGFACE_TOKEN environment variable!")

print("[INFO] ✅ Loading tokenizer and model (CPU mode)...")
tokenizer = AutoTokenizer.from_pretrained("mistralai/Mistral-7B-Instruct-v0.3", token=token)
model = AutoModelForCausalLM.from_pretrained("mistralai/Mistral-7B-Instruct-v0.3", token=token)

print("[INFO] 🧠 Model loaded successfully and ready for inference.")
