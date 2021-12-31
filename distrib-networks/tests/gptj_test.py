from GPTJ.gptj_api import Completion

context = "This is an intelligent agent conversation bot that has read frankenstein"

examples = {
    "Do you understand this feeling?": "This breeze, which has travelled from the regions towards which I am advancing, gives me a foretaste of those icy climes. Inspirited by this wind of promise, my daydreams become more fervent and vivid. I try in vain to be persuaded that the pole is the seat of frost and desolation; it ever presents itself to my imagination as the region of beauty and delight.",
    "What may not be expected in a country of eternal light? ": "I may there discover the wondrous power which attracts the needle and may regulate a thousand celestial observations that require only this voyage to render their seeming eccentricities consistent for ever. I shall satiate my ardent curiosity with the sight of a part of the world never before visited, and may tread a land never before imprinted by the foot of man.",
    "Do I not deserve to accomplish some great purpose?": "My life might have been passed in ease and luxury, but I preferred glory to every enticement that wealth placed in my path. Oh, that some encouraging voice would answer in the affirmative! My courage and my resolution is firm; but my hopes fluctuate, and my spirits are often depressed. I am about to proceed on a long and difficult voyage, the emergencies of which will demand all my fortitude: I am required not only to raise the spirits of others, but sometimes to sustain my own, when theirs are failing.",
    " I do not intend to sail until the month of June; and when shall I return? Ah, dear sister, how can I answer this question? ": "If I succeed, many, many months, perhaps years, will pass before you and I may meet. If I fail, you will see me again soon, or never.",
    "What can stop the determined heart and resolved will of man?": "My swelling heart involuntarily pours itself out thus. But I must finish. Heaven bless my beloved sister!",
    "And did the man whom you pursued travel in the same fashion?": "Yes.",
    "How can I see so noble a creature destroyed by misery without feeling the most poignant grief?":"He is so gentle, yet so wise; his mind is so cultivated, and when he speaks, although his words are culled with the choicest art, yet they flow with rapidity and unparalleled eloquence.",
    "Do you share my madness? Have you drunk also of the intoxicating draught?":"Hear me; let me reveal my tale, and you will dash the cup from your lips!",
    "And why should I describe a sorrow which all have felt, and must feel?":"The time at length arrives when grief is rather an indulgence than a necessity; and the smile that plays upon the lips, although it may be deemed a sacrilege, is not banished. My mother was dead, but we had still duties which we ought to perform; we must continue our course with the rest and learn to think ourselves fortunate whilst one remains whom the spoiler has not seized."}

context_setting = Completion(context, examples)

prompt = "AKW has become a monster house."


max_tokens = 250

User = "AKW"
Bot = "SCOT"

temperature = 0.1

top_probability = 1.0


response = context_setting.completion(prompt,
              user=User,
              bot=Bot,
              max_tokens=max_tokens,
              temperature=temperature,
              top_p=top_probability)

print(response)

# import requests
# context = "In a shocking finding, scientist discovered a herd of unicorns living in a remote, previously unexplored valley, in the Andes Mountains. Even more surprising to the researchers was the fact that the unicorns spoke perfect English."
# payload = {
#     "context": context,
#     "token_max_length": 512,
#     "temperature": 1.0,
#     "top_p": 0.9,
# }
# response = requests.post("http://api.vicgalle.net:5000/generate", params=payload).json()
# print(response)