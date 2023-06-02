from django.contrib.auth import *
from django.contrib.auth.decorators import login_required
from django.shortcuts import get_object_or_404, render
from django.http import Http404, HttpResponse, HttpResponseRedirect
from django.template import loader
from django.urls import reverse
from django.contrib.auth.models import User
from .models import Questao, Opcao, Aluno, VotoUser
from django.utils import timezone
from django.shortcuts import render
from django.conf import settings
from django.core.files.storage import FileSystemStorage
import os
from django.contrib.auth.decorators import user_passes_test

from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status
from .serializers import *  # (2)
from .models import Questao, Opcao


def isSuperUser(user: User):
    return user.is_superuser


@login_required()
def index(request):
    latest_question_list = Questao.objects.order_by("-pub_data")[:5]
    context = {"latest_question_list": latest_question_list}
    return render(request, "votacao/index.html", context)


def base(request):
    return render(request, "votacao/base.html")


@login_required()
def detalhe(request, questao_id):
    questao = get_object_or_404(Questao, pk=questao_id)
    return render(request, "votacao/detalhequestao.html", {"questao": questao})


@login_required()
def voto(request, questao_id):
    questao = get_object_or_404(Questao, pk=questao_id)
    try:
        opcao_seleccionada = questao.opcao_set.get(pk=request.POST["opcao"])
    except (KeyError, Opcao.DoesNotExist):
        # Apresenta de novo o form para votar
        return render(
            request,
            "votacao/detalhequestao.html",
            {
                "questao": questao,
                "error_message": "Não escolheu uma opção",
            },
        )
    else:
        opcao_seleccionada.votos += 1
        opcao_seleccionada.save()
        try:
            votouser = VotoUser.objects.get(user=request.user.id)
        except VotoUser.DoesNotExist:
            print()
        else:
            if votouser is not None:
                if votouser.votos < 39:
                    votouser.votos += 1
                    votouser.save()
                else:
                    return render(
                        request,
                        "votacao/detalhequestao.html",
                        {
                            "questao": questao,
                            "error_message": "Limite de votos atingindo",
                        },
                    )
            else:
                vtu = VotoUser(user=request.user, votos=1)
                vtu.save()
        return HttpResponseRedirect(reverse("votacao:detalhe", args=(questao.id,)))


@login_required()
@user_passes_test(isSuperUser, login_url="votacao:index")
def criarquestao(request):
    return render(request, "votacao/criarquestao.html")


@login_required()
@user_passes_test(isSuperUser, login_url="votacao:index")
def gravarquestao(request):
    try:
        text_questao = request.POST["input-question"]
    except KeyError:
        return render(
            request,
            "votacao/criarquestao.html",
            {
                "error_message": "Não escreveu o texto da pergunta",
            },
        )
    else:
        if text_questao == "":
            return render(
                request,
                "votacao/criarquestao.html",
                {
                    "error_message": "Não escreveu o texto da pergunta",
                },
            )
        else:
            q = Questao(questao_texto=text_questao, pub_data=timezone.now())
            q.save()
            return render(request, "votacao/detalhequestao.html", {"questao": q})


@login_required()
@user_passes_test(isSuperUser, login_url="votacao:index")
def criaropcao(request, questao_id):
    if request.user.is_superuser:
        questao = get_object_or_404(Questao, pk=questao_id)
        return render(request, "votacao/criaropcao.html", {"questao": questao})
    return HttpResponseRedirect(reverse("votacao:index"))


@login_required()
@user_passes_test(isSuperUser, login_url="votacao:index")
def gravaropcao(request, questao_id):
    if not request.user.is_superuser:
        return HttpResponseRedirect(reverse("votacao:index"))
    questao = get_object_or_404(Questao, pk=questao_id)
    try:
        text_opcao = request.POST["input-option"]
    except KeyError:
        return render(
            request,
            "votacao/criaropcao.html",
            {
                "error_message": "Não escreveu o texto da opção",
            },
        )
    else:
        if text_opcao == "":
            return render(
                request,
                "votacao/criaropcao.html",
                {
                    "error_message": "Não escreveu o texto da opção",
                },
            )
        else:
            questao.opcao_set.create(opcao_texto=text_opcao, votos=0)
            return HttpResponseRedirect(reverse("votacao:detalhe", args=(questao.id,)))


def registar(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        email = request.POST["email"]
        curso = request.POST["curso"]
        if username == "" or password == "" or email == "" or curso == "":
            return render(
                request,
                "votacao/registar.html",
                {
                    "error_message": "Completar todos os campos",
                },
            )
        user = User.objects.create_user(username, email, password)
        aluno = Aluno(user=user, curso=curso)
        aluno.save()
        return HttpResponseRedirect(reverse("votacao:login"))
    else:
        return render(request, "votacao/registar.html")


def loginview(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(username=username, password=password)
        if user is not None:
            if not user.is_superuser:
                aluno = get_object_or_404(Aluno, pk=user.id)
                request.session["curso"] = aluno.curso
            login(request, user)
            fs = FileSystemStorage()
            name = request.user.username + ".jpg"
            request.session["image_name"] = (
                "media/" + name
                if os.path.exists(fs.base_location + "/" + name)
                else "votacao/images/default.jpg"
            )
            return HttpResponseRedirect(reverse("votacao:index"))
        else:
            return render(
                request,
                "votacao/login.html",
                {
                    "error_message": "Erro no login",
                },
            )
    else:
        return render(request, "votacao/login.html")


@login_required()
def logoutview(request):
    logout(request)
    request.session.flush()
    return HttpResponseRedirect(reverse("votacao:login"))


@login_required()
def detalheutilizador(request):
    return render(request, "votacao/detalheutilizador.html")


@login_required()
@user_passes_test(isSuperUser, login_url="votacao:index")
def removerquestao(request, questao_id):
    if request.user.is_superuser:
        questao = get_object_or_404(Questao, pk=questao_id)
        if questao is not None:
            questao.delete()
    return HttpResponseRedirect(reverse("votacao:index"))


@login_required()
@user_passes_test(isSuperUser, login_url="votacao:index")
def removeropcao(request, questao_id, opcao_id):
    if request.user.is_superuser:
        opcao = get_object_or_404(Opcao, pk=opcao_id)
        if opcao is not None:
            opcao.delete()
    return HttpResponseRedirect(reverse("votacao:detalhe", args=(questao_id,)))


@login_required()
def fazer_upload(request):
    if request.method == "POST" and request.FILES["myfile"]:
        myfile = request.FILES["myfile"]
        fs = FileSystemStorage()
        name = request.user.username + ".jpg"

        if os.path.exists(fs.base_location + "/" + name):
            os.remove(fs.base_location + "/" + name)

        fs.save(name, myfile)
        request.session["image_name"] = "media/" + name
    return HttpResponseRedirect(reverse("votacao:detalheutilizador"))


@api_view(["GET", "POST"])
def questoes_lista(request):
    if request.method == "GET":
        questoes = Questao.objects.all()
        serializerQ = QuestaoSerializer(
            questoes, context={"request": request}, many=True
        )
        return Response(serializerQ.data)
    elif request.method == "POST":
        serializer = QuestaoSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(["PUT", "DELETE"])
def questoes_edita(request, pk):
    try:
        questao = Questao.objects.get(pk=pk)
    except Questao.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    if request.method == "PUT":
        serializer = QuestaoSerializer(
            questao, data=request.data, context={"request": request}
        )
        if serializer.is_valid():
            serializer.save()
            return Response(status=status.HTTP_204_NO_CONTENT)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    elif request.method == "DELETE":
        questao.delete()
    return Response(status=status.HTTP_204_NO_CONTENT)


@api_view(["GET", "POST"])
def opcoes_lista(request):
    if request.method == "GET":
        opcoes = Opcao.objects.all()
        serializerO = OpcaoSerializer(opcoes, context={"request": request}, many=True)
        return Response(serializerO.data)
    elif request.method == "POST":
        serializer = OpcaoSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(["PUT", "DELETE"])
def opcoes_edita(request, pk):
    try:
        opcao = Opcao.objects.get(pk=pk)
    except Opcao.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    if request.method == "PUT":
        serializer = OpcaoSerializer(
            opcao, data=request.data, context={"request": request}
        )
        if serializer.is_valid():
            opcao.votos = opcao.votos + 1
            opcao.save()
            # serializer.save()
            return Response(status=status.HTTP_204_NO_CONTENT)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    elif request.method == "DELETE":
        opcao.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
