from django.urls import include, path
from . import views
from django.conf import settings
from django.conf.urls.static import static


app_name = "store"

urlpatterns = [
    path('api/produtos/', views.produtos),
    path('api/produtoimagem/<str:pathimagem>', views.produtoimagem),
    path("", views.index, name="index"),
    path("login", views.loginview, name="login"),
    path("logout_view", views.logout_view, name="logout_view"),
    path("register", views.register, name="register"),
    path("addproduct", views.addproduct, name="addproduct"),
    path("userdetails", views.userdetails, name="userdetails"),
    path("alteruserdetails", views.alteruserdetails, name="alteruserdetails"),
    path("saleslist", views.saleslist, name="saleslist"),
    path("reserveslist", views.reserveslist, name="reserveslist"),
    path("addreserve", views.addreserve, name="addreserve"),
    path("reserveslist/<int:reserveid>", views.reservedetails, name="reservedetails"),
    path("reserveslist/<int:reserveid>/pay", views.pay, name="pay"),
    path("productslist", views.productslist, name="productslist"),
    path("productslist/<int:productid>", views.productdetail, name="productdetail"),
    path("saleslist/<int:saleid>", views.saledetails, name="saledetails"),
    path("saleslist/<int:saleid>/sent", views.sent, name="sent"),
    path("stockorder", views.stockorder, name="stockorder"),
    path("stockorder/<int:orderid>", views.orderdetails, name="orderdetails"),
    path("stockorder/<int:orderid>/received", views.received, name="received"),
    path("users", views.users, name="users"),
    path("users", views.users, name="addemployee"),
    path("inactivateuser/<int:userid>", views.inactivateuser, name="inactivateuser"),
    path("activateuser/<int:userid>", views.activateuser, name="activateuser"),
    path("addorder", views.addorder, name="addorder"),
    path("addorderprocess", views.addorderprocess, name="addorderprocess"),
    path("get_items/", views.get_items, name="get_items"),
    path("cart", views.cart, name="cart"),
    path("addtocart/<int:productid>/<int:quantity>", views.addtocart, name="addtocart"),
    path("removefromcart/<int:productid>", views.removefromcart, name="removefromcart"),
]
