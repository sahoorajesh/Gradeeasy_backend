from django.contrib import admin
from django.urls import path,include
from pyapi import views

from .views import SimilarityView,Student_uploadView,GradeView

urlpatterns = [
   
    path('upload_sample/', SimilarityView.as_view(),name='upload'),
    path('upload_student/',Student_uploadView.as_view(),name='upload_stu'),
    path('grade/',GradeView.as_view(),name = 'view_grade')
]
