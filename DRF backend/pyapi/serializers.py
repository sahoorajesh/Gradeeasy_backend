from rest_framework import serializers 
from .models import Similarity,Stu_ans

class SimilaritySerializers(serializers.ModelSerializer): 
    class Meta(): 
        model=Similarity
        fields='__all__'

class Stu_ansSerializers(serializers.ModelSerializer):
    class Meta(): 
        model=Stu_ans
        fields='__all__'     