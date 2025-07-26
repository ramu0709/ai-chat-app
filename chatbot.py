# chatbot.py
import os
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch
import gradio as gr

print("[INFO] ✅ Loading tokenizer and model (CPU mode)...")

token = os.environ.get("HUGGINGFACE_TOKEN")
model_id = "mistralai/Mistral-7B-Instruct-v0.3"

tokenizer = AutoTokenizer.from_pretrained(model_id, token=token)
model = AutoModelForCausalLM.from_pretrained(model_id, token=token, torch_dtype=torch.float32)

def chat_fn(prompt):
    inputs = tokenizer(prompt, return_tensors="pt")
    outputs = model.generate(**inputs, max_new_tokens=200, do_sample=True)
    response = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return response.strip()

gr.Interface(fn=chat_fn, inputs="text", outputs="text", title="🧠 Mistral Chatbot (CPU Only)").launch(
    server_name="0.0.0.0", server_port=7860
)
