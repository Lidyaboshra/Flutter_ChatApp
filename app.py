from flask import Flask, request, redirect, url_for,jsonify
from flask.json.tag import JSONTag
import json

from flask.sessions import NullSession


app = Flask(__name__)

@app.route("/",methods = ['Post','GET'])
def home():
    if(request.method == 'POST'):
         return NullSession
    else:
         return 'Hello'
    #     #fetching the global response variable to manipulate inside the function
    # global response

    # #checking the request type we get from the app
    # if(request.method == 'POST'):
    #     request_data = request.data #getting the response data
    #     request_data = JSONTag.loads(request_data.decode('utf-8')) #converting it from json to key value pair
    #     name = request_data['name'] #assigning it to name
    #     response = f'Hi {name}! this is Python' #re-assigning response with the name we got from the user
    #     return " " #to avoid a type error 
    # else:
    #     return jsonify({'name' : response})


if __name__ =="__main__":
    app.run(debug = True)