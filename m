From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: request to update man
 pages/TEMPLATE if "device subsection" keywords are changed
Date: Mon, 29 Aug 2016 09:25:56 +0200
Message-ID: <CABr-Gnd8j9eXtdmNUA8imo2zxt7B5aUH7XBoQGoOezkcruHwCg@mail.gmail.com>
References: <1472424064-9669-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9097378186477736577=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1472424064-9669-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============9097378186477736577==
Content-Type: multipart/alternative; boundary=94eb2c07a47e6690f4053b30c60a

--94eb2c07a47e6690f4053b30c60a
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Mon, Aug 29, 2016 at 12:41 AM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> and s/keywork/keyword
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/dict.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index e8c6804..7c21e72 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -1330,7 +1330,7 @@ snprint_deprecated (struct config *conf, char *
> buff, int len, void * data)
>  #define __deprecated
>
>  /*
> - * If you add or remove a keywork also update multipath/multipath.conf.5
> + * If you add or remove a keyword also update multipath/multipath.conf.5
>   */
>  void
>  init_keywords(vector keywords)
> @@ -1421,7 +1421,10 @@ init_keywords(vector keywords)
>         __deprecated install_keyword("product", &ble_product_handler,
> &snprint_bled_product);
>         __deprecated install_sublevel_end();
>  #endif
> -
> +/*
> + * If you add or remove a "device subsection" keyword also update
> + * multipath/multipath.conf.5 and the TEMPLATE in libmultipath/hwtable.c
> + */
>         install_keyword_root("devices", &devices_handler);
>         install_keyword_multi("device", &device_handler, NULL);
>         install_sublevel();
> --
> 2.7.4
>
>

--94eb2c07a47e6690f4053b30c60a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, Aug 29, 2016 at 12:41 AM, Xose Vazqu=
ez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" ta=
rget=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">and s/keywork/keyword<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/dict.c | 7 +++++--<br>
=C2=A01 file changed, 5 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/dict.c b/libmultipath/dict.c<br>
index e8c6804..7c21e72 100644<br>
--- a/libmultipath/dict.c<br>
+++ b/libmultipath/dict.c<br>
@@ -1330,7 +1330,7 @@ snprint_deprecated (struct config *conf, char * buff,=
 int len, void * data)<br>
=C2=A0#define __deprecated<br>
<br>
=C2=A0/*<br>
- * If you add or remove a keywork also update multipath/multipath.conf.5<b=
r>
+ * If you add or remove a keyword also update multipath/multipath.conf.5<b=
r>
=C2=A0 */<br>
=C2=A0void<br>
=C2=A0init_keywords(vector keywords)<br>
@@ -1421,7 +1421,10 @@ init_keywords(vector keywords)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __deprecated install_keyword(&quot;product&quot=
;, &amp;ble_product_handler, &amp;snprint_bled_product);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __deprecated install_sublevel_end();<br>
=C2=A0#endif<br>
-<br>
+/*<br>
+ * If you add or remove a &quot;device subsection&quot; keyword also updat=
e<br>
+ * multipath/multipath.conf.5 and the TEMPLATE in libmultipath/hwtable.c<b=
r>
+ */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword_root(&quot;devices&quot;<wbr>, =
&amp;devices_handler);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword_multi(&quot;device&quot;<wbr>, =
&amp;device_handler, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_sublevel();<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c07a47e6690f4053b30c60a--


--===============9097378186477736577==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9097378186477736577==--
