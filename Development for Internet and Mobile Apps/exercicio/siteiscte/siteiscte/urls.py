from django.urls import include, path
from django.contrib import admin
from . import views

urlpatterns = [
    path('votacao/', include('votacao.urls')),
    path("", views.index, name='index'),
    path('admin/', admin.site.urls),
]
