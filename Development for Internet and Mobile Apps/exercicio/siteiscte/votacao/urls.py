from django.urls import include, path
from . import views
from django.conf import settings
from django.conf.urls.static import static


app_name = 'votacao'

urlpatterns = [
    path("", views.index, name='index'),
    path('base', views.base, name='base'),
    path('<int:questao_id>', views.detalhe, name='detalhe'),
    path('<int:questao_id>/voto', views.voto, name='voto'),
    path('criarquestao', views.criarquestao, name='criarquestao'),
    path('gravarquestao', views.gravarquestao, name='gravarquestao'),
    path('<int:questao_id>/criaropcao', views.criaropcao, name='criaropcao'),
    path('<int:questao_id>/gravaropcao', views.gravaropcao, name='gravaropcao'),
    path('login', views.loginview, name='login'),
    path('registar', views.registar, name='registar'),
    path('logout', views.logoutview, name='logout'),
    path('detalheutilizador', views.detalheutilizador, name='detalheutilizador'),
    path('<int:questao_id>/removerquestao', views.removerquestao, name='removerquestao'),
    path('<int:questao_id>/<int:opcao_id>/removeropcao', views.removeropcao, name='removeropcao'),
    path('fazer_upload', views.fazer_upload, name='fazer_upload'),
    path('api/questoes/', views.questoes_lista),
    path('api/questoes/<int:pk>', views.questoes_edita),
    path('api/opcoes/', views.opcoes_lista),
    path('api/opcoes/<int:pk>', views.opcoes_edita),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL,document_root=settings.MEDIA_ROOT)
