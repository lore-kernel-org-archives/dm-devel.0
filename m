From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] Update ETERNUS DX entry
Date: Mon, 9 Mar 2015 22:49:59 +0100
Message-ID: <CABr-Gnc4mgS_ywcQV2TFtJXOvbw_FTCoSYnMVp9cva+YmEE1uA@mail.gmail.com>
References: <44563972.MCcuCWMjxF@tabasco>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9127990030875670399=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44563972.MCcuCWMjxF@tabasco>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gerhard Wichert <Gerhard.Wichert@ts.fujitsu.com>
Cc: "Wilck, Martin" <Martin.Wilck@ts.fujitsu.com>, device-mapper development <dm-devel@redhat.com>, "Montag,
	Rainer" <Rainer.Montag@ts.fujitsu.com>
List-Id: dm-devel.ids

--===============9127990030875670399==
Content-Type: multipart/alternative; boundary=001a1141c7b4067ba20510e20484

--001a1141c7b4067ba20510e20484
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.

On Mon, Mar 9, 2015 at 3:57 PM, Gerhard Wichert <
Gerhard.Wichert@ts.fujitsu.com> wrote:

>  Add DX8700 S3 and DX8900 S3
>
>
>
> Signed-off-by: Gerhard Wichert <gerhard.wichert@ts.fujitsu.com>
>
> ---
>
>  libmultipath/hwtable.c  | 2 +-
>
>  multipath.conf.defaults | 2 +-
>
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>
> index bf2c2ca..6de915b 100644
>
> --- a/libmultipath/hwtable.c
>
> +++ b/libmultipath/hwtable.c
>
> @@ -308,7 +308,7 @@ static struct hwentry default_hw[] = {
>
> },
>
> {
>
> .vendor = "FUJITSU",
>
> - .product = "ETERNUS_DX(L|M|400|8000)",
>
> + .product = "ETERNUS_DX(H|L|M|400|8000)",
>
> .features = "1 queue_if_no_path",
>
> .hwhandler = DEFAULT_HWHANDLER,
>
> .pgpolicy = GROUP_BY_PRIO,
>
> diff --git a/multipath.conf.defaults b/multipath.conf.defaults
>
> index cf8cfdb..c5f12e8 100644
>
> --- a/multipath.conf.defaults
>
> +++ b/multipath.conf.defaults
>
> @@ -285,7 +285,7 @@
>
> # }
>
> # device {
>
> # vendor "FUJITSU"
>
> -# product "ETERNUS_DX(L|M|400|8000)"
>
> +# product "ETERNUS_DX(H|L|M|400|8000)"
>
> # path_grouping_policy "group_by_prio"
>
> # path_checker "tur"
>
> # features "1 queue_if_no_path"
>
>
>

--001a1141c7b4067ba20510e20484
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Mon, Mar 9, 2015 at 3:57 PM, Gerhard Wic=
hert <span dir=3D"ltr">&lt;<a href=3D"mailto:Gerhard.Wichert@ts.fujitsu.com=
" target=3D"_blank">Gerhard.Wichert@ts.fujitsu.com</a>&gt;</span> wrote:<br=
><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex"><u></u>
<div style=3D"font-family:&#39;Monospace&#39;;font-size:9pt;font-weight:400=
;font-style:normal">
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">Add DX8700 S3 and DX8900 S3</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">=C2=A0</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px"><span style=3D"font-family:&#39;Courier New,courier&#39=
;;font-size:medium;color:#000000">Signed-off-by: Gerhard Wichert &lt;<a hre=
f=3D"mailto:gerhard.wichert@ts.fujitsu.com" target=3D"_blank">gerhard.wiche=
rt@ts.fujitsu.com</a>&gt;</span></p>
<pre style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right=
:0px;text-indent:0px"><span style=3D"font-family:&#39;Courier New,courier&#=
39;;font-size:medium;color:#000000">---</span></pre>
<pre style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right=
:0px;text-indent:0px"><span style=3D"font-family:&#39;Courier New,courier&#=
39;;font-size:medium;color:#000000"> libmultipath/hwtable.c  | 2 +-</span><=
/pre>
<pre style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right=
:0px;text-indent:0px"><span style=3D"font-family:&#39;Courier New,courier&#=
39;;font-size:medium;color:#000000"> multipath.conf.defaults | 2 +-</span><=
/pre>
<pre style=3D"margin-top:0px;margin-bottom:12px;margin-left:0px;margin-righ=
t:0px;text-indent:0px"><span style=3D"font-family:&#39;Courier New,courier&=
#39;;font-size:medium;color:#000000"> 2 files changed, 2 insertions(+), 2 d=
eletions(-)</span></pre>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">diff --git a/libmultipath/hwtable.c b/libmultipath/hwta=
ble.c</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">index bf2c2ca..6de915b 100644</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">--- a/libmultipath/hwtable.c</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">+++ b/libmultipath/hwtable.c</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">@@ -308,7 +308,7 @@ static struct hwentry default_hw[] =
=3D {</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">        },</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">        {</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">                .vendor        =3D &quot;FUJITSU&quot;,=
</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">-               .product       =3D &quot;ETERNUS_DX(L|M=
|400|8000)&quot;,</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">+               .product       =3D &quot;ETERNUS_DX(H|L=
|M|400|8000)&quot;,</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">                .features      =3D &quot;1 queue_if_no_=
path&quot;,</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">                .hwhandler     =3D DEFAULT_HWHANDLER,</=
p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">                .pgpolicy      =3D GROUP_BY_PRIO,</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">diff --git a/multipath.conf.defaults b/multipath.conf.d=
efaults</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">index cf8cfdb..c5f12e8 100644</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">--- a/multipath.conf.defaults</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">+++ b/multipath.conf.defaults</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">@@ -285,7 +285,7 @@</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px"> #      }</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px"> #      device {</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px"> #              vendor &quot;FUJITSU&quot;</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">-#              product &quot;ETERNUS_DX(L|M|400|8000)&=
quot;</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">+#              product &quot;ETERNUS_DX(H|L|M|400|8000=
)&quot;</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px"> #              path_grouping_policy &quot;group_by_pri=
o&quot;</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px"> #              path_checker &quot;tur&quot;</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px"> #              features &quot;1 queue_if_no_path&quot;=
</p>
<p style=3D"margin-top:0px;margin-bottom:0px;margin-left:0px;margin-right:0=
px;text-indent:0px">=C2=A0</p></div></blockquote></div><br></div>

--001a1141c7b4067ba20510e20484--


--===============9127990030875670399==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9127990030875670399==--
