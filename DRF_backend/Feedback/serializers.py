from rest_framework import serializers 
from .models import Feedback_model

class Feedback_modelSerializers(serializers.ModelSerializer): 
    class Meta(): 
        model= Feedback_model
        fields='__all__'