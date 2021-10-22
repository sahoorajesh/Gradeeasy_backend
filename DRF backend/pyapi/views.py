from __future__ import print_function
from django.shortcuts import render
from django.core import serializers
from rest_framework import viewsets
from .serializers import SimilaritySerializers,Stu_ansSerializers 
from .models import Similarity,Stu_ans
import os
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
import nltk
from nltk import bleu_score
# nltk.download()
from nltk.corpus import wordnet   #Import wordnet from the NLTK
from nltk.tokenize import sent_tokenize,word_tokenize
from nltk.stem import WordNetLemmatizer
from nltk.corpus import stopwords
import gensim
from gensim.parsing.preprocessing import remove_stopwords
import text_preprocessing
from text_preprocessing import to_lower, remove_email, remove_url, remove_punctuation, lemmatize_word
import skfuzzy as fuzz
from skfuzzy import control as ctrl

import pdfplumber
import sklearn

# Import all of the scikit learn stuff
from rest_framework.views import APIView
from sklearn.decomposition import TruncatedSVD
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.preprocessing import Normalizer
from sklearn import metrics
from sklearn.cluster import KMeans, MiniBatchKMeans
import pandas as pd
import numpy 
from rest_framework.parsers import MultiPartParser, FormParser
from nltk.translate.bleu_score import sentence_bleu
wordnet_lemmatizer = WordNetLemmatizer()

grand_final1 =""
stu_grand_final1=""
token_word =''
bleu_student =[]
# C:\Users\Rajesh\Projects\django-rest-framework-tutorial-master\django-rest-framework-tutorial-master\media\media
class SimilarityView(APIView): 

    parser_classes = (MultiPartParser, FormParser) 
    
    def post(self, request, *args, **kwargs):
        global grand_final1,token_word
        file_serializer = SimilaritySerializers(data=request.data)
        if file_serializer.is_valid():
            file_serializer.save()
          

    
            for filename, files in request.FILES.items():
                name1= request.FILES[filename].name
           
            sample_final = []
            grand_final=[]
            print(name1)
            
            os.chdir('C:/Users/vedan/OneDrive/Documents/New Folder/Minor Project/Gradeeasy/media/media')
            
            with pdfplumber.open(name1) as pdf:
                first_page = pdf.pages[0]
                text_sample = first_page.extract_text()
                text_lower= text_sample.lower()
                stop_word=remove_stopwords(text_lower)  
                filter_word=remove_punctuation(stop_word) 
                
                token_word = filter_word.split()                    # print(token_word)
                

                l = len(token_word)

                for i in range (0,l):  
                    for synset in wordnet.synsets(token_word[i]):
                        for lemma in synset.lemmas():
                            sample_final.append(lemma.name())    #add the synonyms
                    
                for i in sample_final: 
                    if i not in grand_final: 
                        grand_final.append(i.lower()) 
                
                grand_final1 = " ".join(grand_final)
                res = {
                   'status' : 'ok',
               }
                
            
            return Response(res, status=status.HTTP_200_OK)  
        # else:
        #     data={
        #         'status': 'Error'
        #     }
        #     return Response(data, status=status.HTTP_500_INTERNAL_SERVER_ERROR)   
     
       


class Student_uploadView(APIView): 

    parser_classes = (MultiPartParser, FormParser) 
    
    def post(self, request, *args, **kwargs):
        global stu_grand_final1,bleu_student
        file_serializer1 = Stu_ansSerializers(data=request.data)
        if file_serializer1.is_valid():
            file_serializer1.save()
            
            
            for filename, files in request.FILES.items():
                name2= request.FILES[filename].name
            stu_final = []
            stu_grand_final=[]
            print(name2)
            os.chdir('C:/Users/vedan/OneDrive/Documents/New Folder/Minor Project/Gradeeasy/media/media')
            
            with pdfplumber.open(name2) as pdf:
                first_page = pdf.pages[0]
                stu_text_sample = first_page.extract_text()
                
                stu_text_lower= stu_text_sample.lower()
                
                stu_stop_word=remove_stopwords(stu_text_lower) 

                stu_filter_word=remove_punctuation(stu_stop_word) 
                
                stu_token_word = stu_filter_word.split()
                bleu_student.append(stu_token_word)
               
                
                

                l = len(stu_token_word)
                for i in range (0,l):  
                    for synset in wordnet.synsets(stu_token_word[i]):
                        for lemma in synset.lemmas():
                            stu_final.append(lemma.name())    #add the synonyms 
                

                 
                for i in stu_final: 
                    if i not in stu_grand_final: 
                        stu_grand_final.append(i.lower()) 
                stu_grand_final1 = " ".join(stu_grand_final)

        
        data = {
            'status' : 'ok',
        }   

        return Response(data, status=status.HTTP_200_OK)
     

class GradeView(SimilarityView,Student_uploadView):
    def get(self,request,format=None):
        

        example=[grand_final1,stu_grand_final1]
        # print(example)
        vectorizer = CountVectorizer(min_df = 1, stop_words = 'english')
        dtm = vectorizer.fit_transform(example)
        vectorizer.get_feature_names()
        
        lsa = TruncatedSVD(2, algorithm = 'randomized')

        dtm_lsa = lsa.fit_transform(dtm)
        dtm_lsa = Normalizer(copy=False).fit_transform(dtm_lsa)




        xs = [w[0] for w in dtm_lsa]
        ys = [w[1] for w in dtm_lsa]
        xs, ys

        
        similarity = numpy.asarray(numpy.asmatrix(dtm_lsa) * numpy.asmatrix(dtm_lsa).T)
        # print(similarity)
        # pd.DataFrame(similarity,index=example, columns=example).head(10)
        lsa_score =[]
        for i in range(1,len(similarity)):
            lsa_score.append(similarity[0][i])
            
        score =[]
        score = bleu_score.sentence_bleu([token_word],bleu_student[0],(1.,0,0))
        

        quality = ctrl.Antecedent(numpy.arange(0, 1.1, 1/2), 'quality')
        service = ctrl.Antecedent(numpy.arange(0, 1.1, 1/2), 'service')
        tip = ctrl.Consequent(numpy.arange(0, 4/3, 1/3), 'tip')

        
        quality.automf(3)

        service.automf(3)

    
        
        tip['D'] = fuzz.trimf(tip.universe, [0, 0, 1/3])
        tip['C'] = fuzz.trimf(tip.universe, [0, 1/3, 2/3])
        tip['B'] = fuzz.trimf(tip.universe, [1/3, 2/3, 1])
        tip['A'] = fuzz.trimf(tip.universe, [2/3, 1, 1])
        
        rule1 = ctrl.Rule(quality['poor'] & service['poor'], tip['D'])
        rule2 = ctrl.Rule(quality['poor'] & service['average'], tip['C'])
        rule3 = ctrl.Rule(quality['poor'] & service['good']  , tip['C'])

        rule4 = ctrl.Rule(quality['average'] & service['poor'], tip['C'])
        rule5 = ctrl.Rule(quality['average'] & service['average'], tip['B'])
        rule6 = ctrl.Rule(quality['average'] & service['good']  , tip['B'])

        rule7 = ctrl.Rule(quality['good'] & service['poor'], tip['C'])
        rule8 = ctrl.Rule(quality['good'] & service['average'], tip['B'])
        rule9 = ctrl.Rule(quality['good'] & service['good']  , tip['A'])



        
        tipping_ctrl = ctrl.ControlSystem([rule1, rule2, rule3, rule4, rule5, rule6,rule7, rule8, rule9])
        tipping = ctrl.ControlSystemSimulation(tipping_ctrl)
        
        tipping.input['quality'] = lsa_score[0]
        tipping.input['service'] = score
        tipping.compute()
        Final_Grade = tipping.output['tip']
        Final_Grade = str(numpy.asarray(Final_Grade))
        grade = {
            'Final Grade': Final_Grade
        }
        print(grade)
        return Response(grade, status=status.HTTP_200_OK)