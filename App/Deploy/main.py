from fastapi import FastAPI, UploadFile
from pydantic import BaseModel
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_google_genai import GoogleGenerativeAIEmbeddings
import requests
import httpx
import pandas as pd
import json
from supabase import create_client, Client
import re
import torch
from transformers import BertConfig,BertForSequenceClassification, BertTokenizer
import numpy as np
from sklearn.preprocessing import LabelEncoder
import joblib
import replicate
import os
import requests
import base64
#r8_cFYGBvEWV89rFh63S8n0wNNFizTqbwN2nqtHi
os.environ["REPLICATE_API_TOKEN"] = "r8_Rm0jASnjHEcJKFQuy1OQZ0oEBiIhPw92ZjPoB"
API_KEY1 = "MkKtxUl2wL5wRFmTUcVRSQ9H3AHVjG0k"
API_URL1 = "https://api.apilayer.com/text_to_emotion"
# Loading Emotion Recognition Model 
model_name = "bert_finetune"
config = BertConfig.from_pretrained('bert_finetune/adapter_config.json')
model = BertForSequenceClassification.from_pretrained('bert_finetune/adapter_model.bin', config=config)
model.eval()

tokenizer = BertTokenizer.from_pretrained("bert_tokenizer")
label_encoder = joblib.load('label_encoder.joblib')

# Intialize Supabase and Embeddings Model
supabase: Client = create_client("https://dexeuhpsbffhmsxdtxre.supabase.co", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRleGV1aHBzYmZmaG1zeGR0eHJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDk2MzM2OTEsImV4cCI6MjAyNTIwOTY5MX0.6E8rjoBpEblVCEF1gfKX42I6KRuOxWTbUMya93FiI8s")
embeddings = GoogleGenerativeAIEmbeddings(model = "models/embedding-001",google_api_key="AIzaSyC1P8AvCkfZjNwFJW8MurcZVZBIG5AZOM8")

# Extract Info from myfitnesspal

def extract_info(food_list,quantity):
    extracted_data = []

    for i in range(len(food_list)):
        res = requests.get(f"https://www.myfitnesspal.com/api/nutrition?query=${food_list[i]}").json()["items"]
        
        for item in res:
            product = item['item']
            nutrition = product['nutritional_contents']

            for serving in product['serving_sizes']:
                if serving['nutrition_multiplier'] == 1:
                    extracted_data.append({
                        'Description': product['description'],
                        'Calories': nutrition['energy']['value'] if 'energy' in nutrition else None,
                        'Carbs': nutrition['carbohydrates'] if 'carbohydrates' in nutrition else None,
                        'Protein': nutrition['protein'] if 'protein' in nutrition else None,
                        'Fat': nutrition['fat'] if 'fat' in nutrition else None,
                        'Verified': product['verified'],
                        'Standard Serving Size': str(serving["value"])+ " " + serving["unit"],
                        "Quantity":quantity[i]
                    })
        
    return extracted_data

def preprocess_data(extracted_data):
    res_df = pd.DataFrame(extracted_data)

    res_df = res_df.sort_values(by='Verified', ascending=False)
    res_df['Description'] = res_df['Description'].str.lower().str.strip()

    res_df = res_df.drop_duplicates(subset="Description",keep="first")
    final_df = pd.DataFrame()

    if (res_df["Verified"] == True).any():
        final_df = res_df[res_df["Verified"] == True]
    else:
        final_df = res_df

    final_df.reset_index(inplace=True)
    final_df.drop(columns="index",axis=1,inplace=True)
    
    return final_df.to_json()

# DataType for body variables
class userQuery(BaseModel):
    query: str


class userWorkout(BaseModel):
    query: str
    weight: int | None = None
    duration: int | None = None


app = FastAPI()


@app.post("/intent")
async def root(query:userQuery):

    model = ChatGoogleGenerativeAI(model="gemini-pro",
                        temperature=0.5,google_api_key="AIzaSyCWZgi1sH1szGO1G1kXTfVY3dDTHP2WHI8")
    print(query)
    print(query.query)


    result = model.invoke(f'''
                    
        Your task is to classify the Query in one of the four categories, "calorie_tracking", "workout_tracking",
        "wellbeing_check" and "wellbeing_relief". If the Query does not fit in one of these four only then will you respond
        with "Out of Scope".
                      
        "wellbeing_check" intent will only be used for anxiety and depression related issues.
        "wellbeing_relief" intent will include meditation, relaxation techniques and any type of quotes.
        "workout_tracking" intent will only include when the user has finished some sort of physical activity.
        "calorie_tracking" intent will include only when the user has eaten something.
                    
        Use the following examples to classify the query,
        
        Example: I snacked on an apple and some almonds this afternoon.
        Intent: calorie_tracking
                    
        Example: I went for a 20-minute swim this afternoon.
        Intent: workout_tracking
                    
        Example: I've been feeling very low and uninterested. Is this depression?
        Intent: wellbeing_check
                    
        Example: I'm feeling down. Can you suggest activities to uplift my mood?
        Intent: wellbeing_relief
        
        Query: {query.query}
        Intent: 
                    
    ''')

    return result.content

@app.post("/calorie")
async def root(query:userQuery):
    model = ChatGoogleGenerativeAI(model="gemini-pro",
                        temperature=0.5,google_api_key="AIzaSyCWZgi1sH1szGO1G1kXTfVY3dDTHP2WHI8")

    result = model.invoke(f'''
                    
        Your task is to extract only the food items present in the Query and "NA" if there aren't any food items in the Query.
    
        Use the following format for your output,         
        Format: Food_Item : Quantity ,
                          
        Example: I just had a plate of biryani and 2 glasses of coke
        Output:
        biryani : 1,coke : 2
                          
        Query: {query.query}
        Output: 

    ''')

    food_items = result.content.split(",")

    first_items = [item.split(':')[0].strip() for item in food_items]
    quantity = [item.split(':')[1].strip() for item in food_items]

    info = extract_info(first_items,quantity)
    data = preprocess_data(info)
    formatted_data = {}
    for key in json.loads(data).keys():
        values = list(json.loads(data)[key].values())
        formatted_data[key] = values
    return formatted_data



@app.post("/workout")
async def root(usrwk:userWorkout):
    
    model = ChatGoogleGenerativeAI(model="gemini-pro",
                    temperature=0.5,google_api_key="AIzaSyCWZgi1sH1szGO1G1kXTfVY3dDTHP2WHI8")

    response = model.invoke(f'''You have to pick out exercise names only from the sentence below and only mention them 
                                if any in your response, seperate the picked out exercises using commas. If the sentence 
                                doesnt have any exercise mentioned respond with "NA" only.

                                Do not mention the quantity with the exercise name

                                Query: {usrwk.query}
    ''')

    if response.content.lower() == "na":
        return "NA"

    exercises = response.content.split(",")

    results = []
    
    for exercise in exercises:
        # Split exercise to get the activity name
        activity = exercise.strip()
        
        # Prepare parameters for API request
        params = {
            "activity": activity,
            "weight": usrwk.weight,
            "duration": usrwk.duration,  
        }

        filtered_params = {k: v for k, v in params.items() if v}

        response = requests.get("https://api.api-ninjas.com/v1/caloriesburned", 
                                headers={"X-Api-Key": "hrl2QRxS6Zm1x0wE97bbCg==JqUsJKwkgj5KFZVX"}, 
                                params=filtered_params)
        
        results.append(response.json())
        headers = []
        for item in results[0]:
            headers.extend(item.keys())
        headers = list(dict.fromkeys(headers))
        header_values = {header: [] for header in headers}
        for item in results[0]:
            for header in headers:
                header_values[header].append(item.get(header))
        print(header_values)
    return header_values


@app.post("/relief")
async def root(query:userQuery):
    
    model = ChatGoogleGenerativeAI(model="gemini-pro",
                        temperature=0.5,google_api_key="AIzaSyCWZgi1sH1szGO1G1kXTfVY3dDTHP2WHI8")


    result = model.invoke(f'''
                
                You have to classify if the Query below needs an activity/meditation/relaxation technique or does it need 
                a motivational/inspirational quote.
                          
                Respond with "MRT" if it needs an activity/meditation/relaxation technique
                And Respond with "MIQ" if it needs a motivational/inspirational quote.
                          
                Respond with "NA" if it needs neither
                          
                Query: {query.query}
                      
        ''')
    
    if result.content.lower() == "na":
        return "NA"
    
    elif result.content.lower() == "mrt":

        query_embedding = embeddings.embed_query(query.query)
        match_count = 2

        response = supabase.rpc('match_meditation', {
            'query_embedding': query_embedding,
            'match_count': match_count
        })

        out = response.execute().data

        body = [by["body"] for by in out]

        model = ChatGoogleGenerativeAI(model="gemini-pro",
                        temperature=0.2,google_api_key="AIzaSyCWZgi1sH1szGO1G1kXTfVY3dDTHP2WHI8")


        result = model.invoke(f'''
                    
            Using the context below which might contain list of meditation or relaxation techniques 
            explain the technique using the instruction mentioned in the context.
                              
            Context: {body}

            Query: {query.query}

            Answer:
                      
        ''')


        return result.content
    
    elif result.content.lower() == "miq":

        query_embedding = embeddings.embed_query(query.query)
        match_count = 2

        response = supabase.rpc('match_documents', {
            'query_embedding': query_embedding,
            'match_count': match_count
        })

        out = response.execute().data

        body = [by["body"] for by in out]

        model = ChatGoogleGenerativeAI(model="gemini-pro",
                        temperature=0.5,google_api_key="AIzaSyCWZgi1sH1szGO1G1kXTfVY3dDTHP2WHI8")


        result = model.invoke(f'''
                    
            You have to explain the context in an articulate way.
            
            If the Context are not relevant to the query then simply reply,
            "I am sorry but our database doesn't have any quotes related to this topic".
                
            Context: {body}

            Query: {query}

            Answer:
                      
        ''')

        return result.content
    
@app.post("/emotion")
async def get_emotion(query: userQuery):
    url = "https://api.apilayer.com/text_to_emotion"

    headers= {
    "apikey": "MkKtxUl2wL5wRFmTUcVRSQ9H3AHVjG0k"
    }
    inputquery=query.query
    print("inputquery ",inputquery)
   #if inputquery is less then 10 characters then add . until it reaches 10 characters
    while len(inputquery)<10:
        inputquery=inputquery+"." 
    response = requests.request("POST", url, headers=headers, data = inputquery)

    status_code = response.status_code
    result = response.text
    #convert the string to dictionary
    result = json.loads(result)
    print("result ",result.values())
    highest_emotion = max(result, key=result.get)

    sad = highest_emotion

    return sad
# Speech to Text
@app.post("/stt")
async def root(file: UploadFile):
    return {"filename": "file.filename"}

    # binary = await file.read()
    # # Encode the binary data using Base64
    # encoded_data = base64.b64encode(binary).decode('utf-8')
        
    # request = requests.post(url="https://api.deepinfra.com/v1/inference/openai/whisper-large?version=9065fbc87cc7164fda86caa00cdeec40f846dbca",json={"audio":encoded_data})
    # print(request.json()["text"])
    # return request.json()["text"]

# Text to Speech
@app.post("/tts")
async def root(text:userQuery):
    print(text.query)
    api = replicate.Client(api_token=os.environ["REPLICATE_API_TOKEN"])
    #print(api.list_models())
    input = {
        "speaker": "https://replicate.delivery/pbxt/Jt79w0xsT64R1JsiJ0LQRL8UcWspg5J4RFrU6YwEKpOT1ukS/male.wav",
        "text": text.query
    }

    output = api.run(
        "lucataco/xtts-v2:684bc3855b37866c0c65add2ff39c78f3dea3f4ff103a436465326e0f438d55e",
        input=input
    )
    
    return output