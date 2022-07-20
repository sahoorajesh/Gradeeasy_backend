from django.db import models

class Feedback_model(models.Model):
    feedback= models.TextField()
    
    def __str__(self):
        
        return self.feedback
# Create your models here.
