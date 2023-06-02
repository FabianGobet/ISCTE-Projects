from django.db import models
from django.contrib.auth.models import User
from django.utils.translation import gettext_lazy as _


# Create your models here.


class User_Extension(models.Model):
    User = models.OneToOneField(User, on_delete=models.CASCADE)
    Imagem = models.CharField(max_length=250)
    Ativo = models.BooleanField(default=True)
    Endereco = models.CharField(max_length=150)
    Phone = models.CharField(max_length=15)

    class Tipos(models.TextChoices):
        CLIENTE = "CL"
        APPADMIN = "AA"
        EMPREGADO = "EM"

    Tipo = models.CharField(max_length=2, choices=Tipos.choices, default=Tipos.CLIENTE)

    class Meta:
        permissions = [
            ("is_app_admin", _("Is an application administrator.")),
            ("is_employee", _("Is a employee.")),
            ("is_client", _("Is a client.")),
        ]

    def get_tipo_permissions(self):
        if self.Tipo == self.Tipos.CLIENTE.value:
            return ["is_client"]
        elif self.Tipo == self.Tipos.APPADMIN.value:
            return ["is_app_admin"]
        elif self.Tipo == self.Tipos.EMPREGADO.value:
            return ["is_employee"]
        else:
            return []


class Reserva(models.Model):
    Cliente = models.ForeignKey(User_Extension, on_delete=models.CASCADE)
    Data = models.DateTimeField()
    PrecoTotal = models.FloatField()
    EnderecoAlternativo = models.CharField(max_length=150)
    Pago = models.BooleanField(default=False)


class Produto(models.Model):
    Nome = models.CharField(max_length=50)
    Imagem = models.CharField(max_length=250)
    Stock = models.IntegerField(default=0)
    Preco_Unidade = models.FloatField()
    Descricao = models.CharField(max_length=500)


class ProdutoReserva(models.Model):
    Reserva = models.ForeignKey(Reserva, on_delete=models.CASCADE)
    Produto = models.ForeignKey(Produto, on_delete=models.CASCADE)
    Quantidade = models.IntegerField()

    class Meta:
        unique_together = (("Produto", "Reserva"),)


class Venda(models.Model):
    Cliente = models.ForeignKey(User_Extension, on_delete=models.SET_NULL, null=True)
    Data = models.DateTimeField()
    Preco_Total = models.FloatField()
    Reserva = models.ForeignKey(
        Reserva, on_delete=models.SET_NULL, null=True, blank=True
    )
    Enviado = models.BooleanField(default=False)
    Endereco_Venda = models.CharField(max_length=150)


class ProdutoVenda(models.Model):
    Venda = models.ForeignKey(
        Venda,
        on_delete=models.CASCADE,
    )
    Produto = models.ForeignKey(Produto, on_delete=models.CASCADE)
    Quantidade = models.IntegerField()

    class Meta:
        unique_together = (("Venda", "Produto"),)


class Encomenda(models.Model):
    Solicitador = models.ForeignKey(
        User_Extension, on_delete=models.SET_NULL, null=True
    )
    Data = models.DateTimeField()
    Preco_Total = models.FloatField()
    Recibo = models.IntegerField()
    Recebido = models.BooleanField(default=False)


class ProdutoEncomenda(models.Model):
    Encomenda = models.ForeignKey(Encomenda, on_delete=models.CASCADE)
    Produto = models.ForeignKey(Produto, on_delete=models.CASCADE)
    Quantidade = models.IntegerField()
    Preco_Unidade = models.FloatField(default=0)

    class Meta:
        unique_together = (("Encomenda", "Produto"),)
