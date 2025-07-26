import os
from transformers import AutoTokenizer, AutoModelForCausalLM
import gradio as gr

token = os.environ.get("HUGGINGFACE_TOKEN")
if not token:
    raise ValueError("❌ HUGGINGFACE_TOKEN not found in environment!")

print("[INFO] ✅ Loading tokenizer and model (CPU mode)...")
tokenizer = AutoTokenizer.from_pretrained("mistralai/Mistral-7B-Instruct-v0.3", token=token)
model = AutoModelForCausalLM.from_pretrained("mistralai/Mistral-7B-Instruct-v0.3", token=token)

def chat_fn(input_text):
    inputs = tokenizer(input_text, return_tensors="pt")
    outputs = model.generate(**inputs, max_new_tokens=200)
    return tokenizer.decode(outputs[0], skip_special_tokens=True)

gr.Interface(fn=chat_fn, inputs="text", outputs="text", title="🧠 Mistral Chatbot (CPU)").launch(
    server_name="0.0.0.0", server_port=7860, block=True
)
