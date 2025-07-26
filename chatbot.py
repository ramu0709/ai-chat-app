import os
from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline

token = os.getenv("HUGGINGFACE_TOKEN")
model_id = "mistralai/Mistral-7B-Instruct-v0.3"

print("[INFO] Loading tokenizer and model (CPU mode)...")

tokenizer = AutoTokenizer.from_pretrained(model_id, token=token)
model = AutoModelForCausalLM.from_pretrained(model_id, token=token)

print("[INFO] ✅ Model loaded successfully!")

generator = pipeline("text-generation", model=model, tokenizer=tokenizer)

print("\n[INFO] Chatbot is ready! Type 'exit' to quit.")
while True:
    prompt = input("\nYou: ")
    if prompt.lower() == "exit":
        break
    response = generator(prompt, max_new_tokens=256, do_sample=True)[0]["generated_text"]
    print(f"\nAI: {response}")
