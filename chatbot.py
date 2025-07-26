import os
import gradio as gr
from transformers import AutoTokenizer, AutoModelForCausalLM

token = os.getenv("HUGGINGFACE_TOKEN")
print("[INFO] ✅ Loading tokenizer and model (CPU mode)...")

tokenizer = AutoTokenizer.from_pretrained(
    "mistralai/Mistral-7B-Instruct-v0.3",
    token=token
)
model = AutoModelForCausalLM.from_pretrained(
    "mistralai/Mistral-7B-Instruct-v0.3",
    token=token
)

def chat_fn(message):
    inputs = tokenizer(message, return_tensors="pt")
    outputs = model.generate(**inputs, max_new_tokens=200)
    return tokenizer.decode(outputs[0], skip_special_tokens=True)

print("[INFO] 🚀 Launching Gradio server...")
gr.Interface(
    fn=chat_fn,
    inputs="text",
    outputs="text",
    title="🧠 Mistral Chatbot (CPU)"
).launch(server_name="0.0.0.0", server_port=7860, share=False, block=True)
