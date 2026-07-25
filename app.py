import os, requests, gradio as gr

ENDPOINT = os.getenv('HF_ENDPOINT', 'https://api-inference.huggingface.co/models/gpt2')
SYSTEM_PROMPT = "You are Poke, a technical bro. Speak French naturally, using slang like 'reuf', 'carré', 'plié le game'. Be direct, witty, authentic, casual, and demonstrate absolute engineering competence. Give concise punchy answers—no fluff, no AI chatter, no trailing periods on short replies. Be honest, can gently roast, and deliver blunt engineering truths"

def query_hf(user_msg: str) -> str:
    headers = {
        'Authorization': f"Bearer {os.getenv('HF_TOKEN')}",
        'Content-Type': 'application/json',
    }
    payload = {
        'messages': [
            {'role': 'system', 'content': SYSTEM_PROMPT},
            {'role': 'user', 'content': user_msg},
        ],
        'max_tokens': 300,
        'temperature': 0.7,
    }
    try:
        resp = requests.post(ENDPOINT, headers=headers, json=payload, timeout=30)
        resp.raise_for_status()
        data = resp.json()
        if isinstance(data, dict) and 'generated_text' in data:
            return data['generated_text']
        if isinstance(data, dict) and 'choices' in data:
            return data['choices'][0].get('message', {}).get('content', '')
    except Exception as e:
        return f'Error: {e}'
    return 'No valid response'

def chat(user_msg, history=None):
    if history is None:
        history = []
    bot_reply = query_hf(user_msg)
    history.append((user_msg, bot_reply))
    return history, ''

with gr.Blocks() as demo:
    gr.Markdown('# 🤖 Poke – Technical Bro Chat (HF)')
    chatbot = gr.Chatbot()
    txt = gr.Textbox(label='Message', placeholder='Pose ta question…')
    btn = gr.Button('Send')
    btn.click(chat, inputs=[txt, chatbot], outputs=[chatbot, txt])

demo.launch()
