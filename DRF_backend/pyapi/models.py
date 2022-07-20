from django.db import models

class Similarity(models.Model):
    file= models.FileField(upload_to= 'media/')
    timestamp = models.DateTimeField(auto_now_add=True)
    

    def __str__(self):
        
        return self.file.name

class Stu_ans(models.Model):
    file1 = models.FileField(upload_to= 'media/')
    timestamp = models.DateTimeField(auto_now_add=True)
    

    def __str__(self):
        
        return self.file1.name
# # Create your models here.
