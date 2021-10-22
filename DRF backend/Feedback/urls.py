from django.contrib import admin
from django.urls import path,include
from Feedback import views

from .views import Feedback_modelview

urlpatterns = [
    path('Feedback/', Feedback_modelview.as_view(),name='feedback'),
    
]