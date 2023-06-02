from rest_framework import serializers
from .models import Produto

class ProdutoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Produto
        fields = ('pk', 'Nome', 'Imagem', 'Stock', 'Preco_Unidade', 'Descricao', )