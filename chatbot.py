import os
import gradio as gr
from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline

token = os.getenv("HUGGINGFACE_TOKEN")
model_id = "mistralai/Mistral-7B-Instruct-v0.3"

print("[INFO] Loading tokenizer and model (CPU mode)...")

tokenizer = AutoTokenizer.from_pretrained(model_id, token=token)
model = AutoModelForCausalLM.from_pretrained(
    model_id, device_map="auto", torch_dtype="auto", token=token
)

print("[INFO] ✅ Model loaded successfully!")

generator = pipeline("text-generation", model=model, tokenizer=tokenizer)

def chat(prompt):
    response = generator(prompt, max_new_tokens=256, do_sample=True)[0]["generated_text"]
    return response

iface = gr.Interface(fn=chat, inputs="text", outputs="text", title="🧠 Mistral Chatbot")
iface.launch(server_name="0.0.0.0", server_port=7860)
