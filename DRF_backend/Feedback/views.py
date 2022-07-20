from django.shortcuts import render
from rest_framework.views import APIView
from django.core import serializers
from .serializers import Feedback_modelSerializers
from rest_framework import status

from rest_framework.response import Response
class Feedback_modelview(APIView):  
    
    def post(self, request, *args, **kwargs):
        feed_serializer = Feedback_modelSerializers(data=request.data)
        if feed_serializer.is_valid():
            feed_serializer.save()
        return Response("ok", status=status.HTTP_201_CREATED)    
# Create your views here.
