import os
from django.http import HttpResponse, HttpResponseRedirect, JsonResponse, QueryDict
from django.http import HttpResponseRedirect, JsonResponse, QueryDict
from django.shortcuts import get_object_or_404, redirect, render
from django.contrib.auth.decorators import login_required
from django.core.files.storage import FileSystemStorage
from django.urls import reverse
from django.contrib.auth import *
from datetime import datetime as dt
from django.conf import settings
from .models import *
import random
from django.contrib.auth.decorators import user_passes_test

from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status
from .serializers import *

import base64


def logout_view(request):
    logout(request)
    return HttpResponseRedirect(reverse("store:productslist"))


def has_permission(request, perm_list):
    userext = User_Extension.objects.get(User=request.user)
    for i in userext.get_tipo_permissions():
        if i in perm_list:
            return True
    return False


@api_view(["GET"])
def produtos(request):
    produtos = Produto.objects.all()
    for p in produtos:
        p.Imagem = p.Imagem[7:]
    serializerP = ProdutoSerializer(produtos, context={"request": request}, many=True)
    return Response(serializerP.data)


@api_view(["GET"])
def produtoimagem(request, pathimagem):
    fs = FileSystemStorage()
    img = fs.open(fs.base_location + "/images/" + pathimagem)

    return HttpResponse(img.read(), content_type="image/png")


def index(request):
    return HttpResponseRedirect(reverse("store:productslist"))


def loginview(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(username=username, password=password)
        if user is not None:
            userExt = get_object_or_404(User_Extension, pk=user.id)
            login(request, user)
            request.session["userext"] = userExt.Tipo
            fs = FileSystemStorage()
            request.session["image_name"] = (
                "media/" + userExt.Imagem
                if os.path.exists(fs.base_location + "/media/" + userExt.Imagem)
                else "images/default.jpg"
            )
            return HttpResponseRedirect(reverse("store:index"))
        else:
            return render(
                request,
                "store/login.html",
                {
                    "class": "is-invalid",
                    "error_message": "Credênciais incorretas",
                },
            )
    else:
        return render(request, "store/login.html")


def register(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        address = request.POST["address"]
        email = request.POST["email"]
        contact = request.POST["contact"]
        name = ""

        if "photo" in request.FILES and request.FILES["photo"]:
            photo = request.FILES["photo"]

            fs = FileSystemStorage()
            name = "media/" + username + ".jpg"

            if os.path.exists(fs.base_location + "/" + name):
                os.remove(fs.base_location + "/" + name)

            fs.save(name, photo)
            name = "media/" + name
            request.session["image_name"] = name

        if name == "":
            name = "media/default.jpg"

        user = User.objects.create_user(username, email, password)
        userExt = User_Extension(
            User=user, Endereco=address, Phone=contact, Imagem=name
        )
        userExt.save()
        return HttpResponseRedirect(reverse("store:login"))
    else:
        return render(request, "store/register.html")


@login_required
def addproduct(request):
    if not has_permission(request, ["is_app_admin"]):
        return HttpResponseRedirect(reverse("store:login"))
    if request.method == "POST":
        name = request.POST["name"]
        photoName = name
        unitPrice = request.POST["price"]
        description = request.POST["description"]

        if request.FILES and request.FILES["photo"]:
            photo = request.FILES["photo"]

            fs = FileSystemStorage()
            photoName = "images/" + "".join(name.split()) + ".jpg"

            if os.path.exists(fs.base_location + "/" + photoName):
                os.remove(fs.base_location + "/" + photoName)

            fs.save(photoName, photo)

        product = Produto.objects.create(
            Nome=name, Imagem=photoName, Preco_Unidade=unitPrice, Descricao=description
        )
        product.save()

        return render(
            request, "store/addproduct.html", {"message": "Sucesso", "type": "success"}
        )
    else:
        return render(request, "store/addproduct.html")


@login_required
def reserveslist(request):
    userext = get_object_or_404(User_Extension, User=request.user)
    if userext.Tipo == "CL":
        reserva = Reserva.objects.filter(Cliente=userext)
    else:
        reserva = Reserva.objects.all().order_by("-Data")
    return render(request, "store/reserveslist.html", {"reserva": reserva})


@login_required
def addreserve(request):
    userext = get_object_or_404(User_Extension, User=request.user)
    total = request.POST["total"]
    address = request.POST["address"]
    reserve = Reserva.objects.create(
        Cliente=userext, Data=dt.now(), PrecoTotal=total, EnderecoAlternativo=address
    )
    reserve.save()
    for i in request.session["cart"]:
        currentProduct = Produto.objects.get(id=i["prodId"])
        if currentProduct is not None:
            pr = ProdutoReserva(
                Reserva=reserve, Produto=currentProduct, Quantidade=i["qt"]
            )
            pr.save()
            currentProduct.Stock = currentProduct.Stock - i["qt"]
            currentProduct.save()
    return HttpResponseRedirect(reverse("store:reserveslist"))


def productslist(request):
    products = Produto.objects.all()
    return render(request, "store/productslist.html", {"products": products})


def productdetail(request, productid):
    product = Produto.objects.filter(id=productid).get()
    return render(request, "store/productdetail.html", {"product": product})


@login_required
def userdetails(request):
    usr = request.user
    userExt = get_object_or_404(User_Extension, User=usr)
    return render(request, "store/userdetails.html", {"usr": usr, "userExt": userExt})


@login_required
def alteruserdetails(request):
    if request.method == "POST":
        address = request.POST["address"]
        email = request.POST["email"]
        contact = request.POST["contact"]
        usr = request.user
        userext = get_object_or_404(User_Extension, User=usr)

        if request.FILES.get("photo"):
            photo = request.FILES["photo"]
            fs = FileSystemStorage()
            name = usr.username + ".jpg"
            path = fs.base_location.replace("\\", "/") + "/media/" + name

            if os.path.exists(path):
                os.remove(path)

            name = "media/" + name
            fs.save(name, photo)
            # request.session["image_name"] = name
            userext.Imagem = name
            userext.save()

        userext = get_object_or_404(User_Extension, User=usr)
        userext.Endereco = address
        userext.Phone = contact
        usr.email = email
        usr.save()
        userext.save()

    return HttpResponseRedirect(reverse("store:userdetails"))


@login_required
def saleslist(request):
    userext = get_object_or_404(User_Extension, User=request.user)
    if userext.Tipo == "CL":
        vendas = Venda.objects.filter(Cliente=userext)
    else:
        vendas = Venda.objects.all().order_by("-Data")
    return render(request, "store/saleslist.html", {"vendas": vendas})


@login_required()
def saledetails(request, saleid):
    userext = User_Extension.objects.get(User=request.user)
    if userext.Tipo == "CL":
        sale = get_object_or_404(
            Venda, Cliente=User_Extension.objects.get(User=request.user), id=saleid
        )
    else:
        sale = get_object_or_404(Venda, id=saleid)

    pv = ProdutoVenda.objects.filter(Venda=sale)
    valset = set(pv.values_list("Produto", flat=True))
    p = Produto.objects.filter(id__in=valset)
    for item in pv:
        item.total = item.Quantidade * item.Produto.Preco_Unidade

    return render(
        request,
        "store/saledetail.html",
        {"pv": pv, "p": p, "v": sale, "userext": userext},
    )


@login_required
def reservedetails(request, reserveid):
    userext = User_Extension.objects.get(User=request.user)
    if userext.Tipo == "CL":
        res = get_object_or_404(
            Reserva, Cliente=User_Extension.objects.get(User=request.user), id=reserveid
        )
    else:
        res = get_object_or_404(Reserva, id=reserveid)

    pr = ProdutoReserva.objects.filter(Reserva=res)
    valset = set(pr.values_list("Produto", flat=True))
    p = Produto.objects.filter(id__in=valset)
    for item in pr:
        item.total = item.Quantidade * item.Produto.Preco_Unidade

    return render(
        request,
        "store/reservedetail.html",
        {"pr": pr, "p": p, "r": res, "userext": userext},
    )


@login_required
def sent(request, saleid):
    if not has_permission(request, ["is_app_admin", "is_employee"]):
        return HttpResponseRedirect(reverse("store:login"))
    userext = User_Extension.objects.get(User=request.user)
    if userext.Tipo != "CL":
        sale = get_object_or_404(Venda, id=saleid)
        sale.Enviado = True
        sale.save()

    return HttpResponseRedirect(reverse("store:saleslist"))


@login_required
def stockorder(request):
    if not has_permission(request, ["is_app_admin", "is_employee"]):
        return HttpResponseRedirect(reverse("store:login"))
    encs = Encomenda.objects.all()
    return render(request, "store/stockorder.html", {"encs": encs})


@login_required
def orderdetails(request, orderid):
    if not has_permission(request, ["is_app_admin", "is_employee"]):
        return HttpResponseRedirect(reverse("store:login"))
    userext = User_Extension.objects.get(User=request.user)
    if userext.Tipo == "AA":
        enc = get_object_or_404(Encomenda, id=orderid)
        pe = ProdutoEncomenda.objects.filter(Encomenda=enc)
        valset = set(pe.values_list("Produto", flat=True))
        p = Produto.objects.filter(id__in=valset)

        for item in pe:
            item.Total = item.Quantidade * item.Preco_Unidade

        return render(
            request,
            "store/orderdetail.html",
            {
                "enc": enc,
                "pe": pe,
            },
        )
    else:
        return HttpResponseRedirect(reverse("store:stockorder"))


@login_required
def received(request, orderid):
    if not has_permission(request, ["is_app_admin", "is_employee"]):
        return HttpResponseRedirect(reverse("store:login"))
    userext = User_Extension.objects.get(User=request.user)
    if userext.Tipo == "AA" or userext.Tipo == "EM":
        enc = get_object_or_404(Encomenda, id=orderid)
        enc.Recebido = True
        enc.save()
        for pe in ProdutoEncomenda.objects.filter(Encomenda=enc):
            p = Produto.objects.get(id=pe.Produto.id)
            p.Stock += pe.Quantidade
            p.save()

    return HttpResponseRedirect(reverse("store:stockorder"))


@login_required
def users(request):
    if not has_permission(request, ["is_app_admin"]):
        return HttpResponseRedirect(reverse("store:login"))
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        address = request.POST["address"]
        email = request.POST["email"]
        contact = request.POST["contact"]
        name = ""

        if "photo" in request.FILES and request.FILES["photo"]:
            photo = request.FILES["photo"]

            fs = FileSystemStorage()
            name = "media/" + username + ".jpg"

            if os.path.exists(fs.base_location + "/" + name):
                os.remove(fs.base_location + "/" + name)

            fs.save(name, photo)
            request.session["image_name"] = name

        if name == "":
            name = "media/default.jpg"

        user = User.objects.create_user(username, email, password)
        userExt = User_Extension(
            User=user, Endereco=address, Phone=contact, Imagem=name, Tipo="EM"
        )
        userExt.save()
        return HttpResponseRedirect(reverse("store:users"))

    else:
        users = User_Extension.objects.filter(Tipo="EM").all()
        return render(request, "store/users.html", {"users": users})


@login_required
def inactivateuser(request, userid):
    if not has_permission(request, ["is_app_admin"]):
        return HttpResponseRedirect(reverse("store:login"))
    userExt = User_Extension.objects.filter(User=userid).get()
    if userExt is not None:
        userExt.Ativo = False
        userExt.save()
    return HttpResponseRedirect(reverse("store:users"))


@login_required
def activateuser(request, userid):
    if not has_permission(request, ["is_app_admin"]):
        return HttpResponseRedirect(reverse("store:login"))
    userExt = User_Extension.objects.filter(User=userid).get()
    if userExt is not None:
        userExt.Ativo = True
        userExt.save()
    return HttpResponseRedirect(reverse("store:users"))


@login_required
def pay(request, reserveid):
    if not has_permission(request, ["is_app_admin", "is_employee"]):
        return HttpResponseRedirect(reverse("store:login"))

    userext = User_Extension.objects.get(User=request.user)
    res = Reserva.objects.get(id=reserveid)
    if userext.Tipo != "CL":
        sale = Venda(
            Cliente=res.Cliente,
            Data=dt.now(),
            Preco_Total=res.PrecoTotal,
            Reserva=res,
            Endereco_Venda=res.EnderecoAlternativo,
        )
        sale.save()
        res.Pago = True
        res.save()

    return HttpResponseRedirect(reverse("store:reserveslist"))


@login_required
def get_items(request):
    if not has_permission(request, ["is_app_admin", "is_employee"]):
        return HttpResponseRedirect(reverse("store:login"))
    items = Produto.objects.all()
    data = []
    for item in items:
        data.append({"id": item.id, "Nome": item.Nome, "Imagem": item.Imagem})
    return JsonResponse(data, safe=False)


@login_required
def addorder(request):
    if not has_permission(request, ["is_app_admin"]):
        return HttpResponseRedirect(reverse("store:login"))
    p = Produto.objects.all()
    return render(request, "store/addorder.html", {"p": p})


@login_required
def addorderprocess(request):
    if not has_permission(request, ["is_app_admin"]):
        return HttpResponseRedirect(reverse("store:login"))
    if request.method == "POST":
        if request.POST.get("item[]"):
            clean_str = str(request.POST)[12:-1]
            vals = eval(clean_str)
            numItems = len(vals["item[]"])
            if numItems > 0:
                enc = Encomenda(
                    Solicitador=User_Extension.objects.get(User=request.user),
                    Data=dt.now(),
                    Preco_Total=0,
                    Recibo=random.randint(0, 10000),
                    Recebido=False,
                )
                pes = []
                pes_id = []
                for i in range(numItems):
                    preco = vals["price[]"][i]
                    quantidade = vals["quantity[]"][i]
                    enc.Preco_Total += float(preco) * int(quantidade)

                    if vals["item[]"][i] in pes_id:
                        for ele in pes:
                            if ele.id == vals["item[]"][i]:
                                oldQ = ele.Quantidade
                                ele.Quantidade += quantidade
                                ele.Preco_Unidade = (
                                    (oldQ * ele.Preco_Unidade) + (quantidade * preco)
                                ) / ele.Quantidade
                    else:
                        pes_id.append(vals["item[]"][i])
                        pes.append(
                            ProdutoEncomenda(
                                Encomenda=enc,
                                Produto=Produto.objects.get(id=vals["item[]"][i]),
                                Quantidade=quantidade,
                                Preco_Unidade=preco,
                            )
                        )

                enc.save()
                for pe in pes:
                    pe.save()

    return HttpResponseRedirect(reverse("store:stockorder"))


def cart(request):
    if "cart" not in request.session:
        request.session["cart"] = []

    products = Produto.objects.filter(
        id__in=map(lambda x: x["prodId"], request.session["cart"])
    ).all()
    total = 0
    for p in products:
        p.Quantidade = next(
            filter(lambda x: x["prodId"] == p.id, request.session["cart"])
        )["qt"]
        p.total = p.Quantidade * p.Preco_Unidade
        total += p.total

    if request.user.is_authenticated:
        userext = User_Extension.objects.get(User=request.user)
        return render(
            request,
            "store/cart.html",
            {"products": products, "total": total, "user": userext},
        )
    else:
        return render(
            request, "store/cart.html", {"products": products, "total": total}
        )


def addtocart(request, productid, quantity):
    if "cart" not in request.session:
        request.session["cart"] = [{"prodId": productid, "qt": quantity}]
    else:
        isNew = True
        cartProducts = request.session["cart"]
        request.session["cart"] = []
        newList = []
        for i in cartProducts:
            if i["prodId"] == productid:
                isNew = False
                i["qt"] = quantity
            newList.append(i)
        if isNew:
            newList.append({"prodId": productid, "qt": quantity})
        request.session["cart"] = newList

    return HttpResponseRedirect(reverse("store:productslist"))


def removefromcart(request, productid):
    request.session["cart"] = [
        x for x in request.session["cart"] if x["prodId"] != productid
    ]
    return HttpResponseRedirect(reverse("store:cart"))
