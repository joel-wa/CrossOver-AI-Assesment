import json
import re
from flask import Flask, request, jsonify
from flask_caching import Cache
import replicate
from flask_cors import CORS
import openai
import replicate
import os



openai.api_key = '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'
os.environ["REPLICATE_API_TOKEN"] = "r8_WYxUzEqqzbgVUgaPcBI1XIIOBcuGseA1wakWQ" 



def parseAIResponse(response_message):
    if response_message.get("function_call"):
        function_name = response_message['function_call']['name']
        function_args = response_message["function_call"]["arguments"]
        #
        #begin parsing
        if function_name == 'questionGenerator':
            value = function_args
            return value
    else:
        message = response_message['content']
        return message



def requestQuestion(userPrompt):
    functions = [{'name': 'questionGenerator', 'description': 'function to generate an objective question given a question standard and a topic of interest of the user, where the user must choose one of your provided answers.', 'parameters': {'type': 'object', 'properties': {'intro': {'type': 'string', 'description': 'a quick introduction and context of the topic of the question being asked.'}, 'question': {'type': 'string', 'description': 'the actual question the user must answer.'}, 'possibleAnswers': {'type': 'string', 'description': 'a list of the possible answers the user must choose from separated by a comma and encapsulated in []eg. [answer A,answer B, answer C, answer D].'}, 'answer': {'type': 'string', 'description': 'the index of the right answer in the possible answers list'}, 'explanation': {'type': 'string', 'description': 'an explanation of why the right answer should be the right answer. It should be clear and comprehensive.'}}}}]

    response = openai.ChatCompletion.create(
    model="gpt-3.5-turbo-0613",
    messages = [{"role":"system","content":"You are a questions generator, give only 4 possible answers with exactly one valid answer among them."},{"role": "user", "content": userPrompt}],
    functions=functions,
    function_call="auto",  # auto is default, but we'll be explicit
    )
    response_message = parseAIResponse(response["choices"][0]["message"])
    q = evaluateQuestion(response_message)
    print(q)
    return q


def evalAnswer(question,userAns,correctAns):
    system_prompt = f"You are an AI teacher talking to your student directly. You asked your student this {question}, but they chose {userAns} instead of {correctAns}. Explain to the student why they are wrong and how they can improve."
    response = openai.ChatCompletion.create(
    model="gpt-3.5-turbo-0613",
    messages = [{"role":"system","content":system_prompt}],
    )
    response_message = parseAIResponse(response["choices"][0]["message"])
    print(response)
    return response_message



def evaluateQuestion(question):
    system_prompt = "You are to evaluate the question.Make sure that 'question', 'intro','answer','possibleAnswers'(in the form of strings), and 'explanation' parameters are present and that there are 4 possible answers in a List form and that the right answer is part of it. If no changes are needed, then output the exact question in the exact format recieved.If it doesn't, then add the right answer and correct the 'answer' section to this new answer. Also make sure there are 4 different possible answers.Make sure that the possible answers are ot type List, and that the correct answer is the exact copy of what is in the possible answers list"
    response = openai.ChatCompletion.create(
    model="gpt-3.5-turbo-0613",
    messages = [{"role":"system","content":system_prompt},{"role": "user", "content": question}],
    )
    response_message = parseAIResponse(response["choices"][0]["message"])
    print(response)
    return response_message


# Create the Flask app
app = Flask(__name__)


CORS(app)

@app.route(f'/getQuestion/<data>',methods = ['POST','GET'])
def getQuestion(data):
    # data = 'standard: 4th Grade Common Core Writing standard, my interests: baseball'
    output = requestQuestion(data)
    print(output)
    # response_data = {"body": output, "status": 201}
    return output,201

@app.route('/evaluateAnswer', methods=['POST'])
def evaluateAnswer():
    data = request.get_json()
    print(data)
    question = data.get('question', '')
    userAns = data.get('userAns', '')
    correctAns = data.get('correctAns', '')

    output = evalAnswer(question, userAns, correctAns)
    print(output)
    return output, 201



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)