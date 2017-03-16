From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] uevent_can_discard: optimize devpath check
Date: Thu, 16 Mar 2017 07:42:34 +0100
Message-ID: <CABr-GncK5N0kP4WLM50WPNFT-DQ+VFP1MR8cs377AvYN8227zA@mail.gmail.com>
References: <20170301172219.9683-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7521505892953483701=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170301172219.9683-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

--===============7521505892953483701==
Content-Type: multipart/alternative; boundary=94eb2c0b86ecb81a8e054ad35d95

--94eb2c0b86ecb81a8e054ad35d95
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.

On Wed, Mar 1, 2017 at 6:22 PM, Martin Wilck <mwilck@suse.com> wrote:

> This uses roughly 10% cycles of the sscanf-based implementation.
>
> Improves: ee8888f0 "multipath-tools: improve processing efficiency..."
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/uevent.c | 37 +++++++++++++++++++++++--------------
>  1 file changed, 23 insertions(+), 14 deletions(-)
>
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index 6e2527bd..367e129a 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -143,26 +143,35 @@ uevent_need_merge(void)
>         return need_merge;
>  }
>
> +static bool
> +uevent_can_discard_by_devpath(const char *devpath)
> +{
> +       static const char BLOCK[] = "/block/";
> +       const char *tmp = strstr(devpath, BLOCK);
> +
> +       if (tmp == NULL) {
> +               condlog(4, "no /block/ in '%s'", devpath);
> +               return true;
> +       }
> +       tmp += sizeof(BLOCK) - 1;
> +       if (*tmp == '\0')
> +               /* just ".../block/" - discard */
> +               return true;
> +       /*
> +        * If there are more path elements after ".../block/xyz",
> +        * it's a partition - discard it; but don't discard
> ".../block/sda/".
> +        */
> +       tmp = strchr(tmp, '/');
> +       return tmp != NULL && *(tmp + 1) != '\0';
> +}
> +
>  bool
>  uevent_can_discard(struct uevent *uev)
>  {
> -       char *tmp;
> -       char a[11], b[11];
>         struct config * conf;
>
> -       /*
> -        * keep only block devices, discard partitions
> -        */
> -       tmp = strstr(uev->devpath, "/block/");
> -       if (tmp == NULL){
> -               condlog(4, "no /block/ in '%s'", uev->devpath);
> +       if (uevent_can_discard_by_devpath(uev->devpath))
>                 return true;
> -       }
> -       if (sscanf(tmp, "/block/%10s", a) != 1 ||
> -           sscanf(tmp, "/block/%10[^/]/%10s", a, b) == 2) {
> -               condlog(4, "discard event on %s", uev->devpath);
> -               return true;
> -       }
>
>         /*
>          * do not filter dm devices by devnode
> --
> 2.12.0
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--94eb2c0b86ecb81a8e054ad35d95
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Wed, Mar 1, 2017 at 6:22 PM, Martin Wilc=
k <span dir=3D"ltr">&lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blank=
">mwilck@suse.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">T=
his uses roughly 10% cycles of the sscanf-based implementation.<br>
<br>
Improves: ee8888f0 &quot;multipath-tools: improve processing efficiency...&=
quot;<br>
Signed-off-by: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@s=
use.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/uevent.c | 37 +++++++++++++++++++++++-------<wbr>-------=
<br>
=C2=A01 file changed, 23 insertions(+), 14 deletions(-)<br>
<br>
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c<br>
index 6e2527bd..367e129a 100644<br>
--- a/libmultipath/uevent.c<br>
+++ b/libmultipath/uevent.c<br>
@@ -143,26 +143,35 @@ uevent_need_merge(void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return need_merge;<br>
=C2=A0}<br>
<br>
+static bool<br>
+uevent_can_discard_by_<wbr>devpath(const char *devpath)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0static const char BLOCK[] =3D &quot;/block/&quo=
t;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0const char *tmp =3D strstr(devpath, BLOCK);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (tmp =3D=3D NULL) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(4, &quot;no=
 /block/ in &#39;%s&#39;&quot;, devpath);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0tmp +=3D sizeof(BLOCK) - 1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (*tmp =3D=3D &#39;\0&#39;)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* just &quot;.../b=
lock/&quot; - discard */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * If there are more path elements after &quot;=
.../block/xyz&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * it&#39;s a partition - discard it; but don&#=
39;t discard &quot;.../block/sda/&quot;.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0tmp =3D strchr(tmp, &#39;/&#39;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return tmp !=3D NULL &amp;&amp; *(tmp + 1) !=3D=
 &#39;\0&#39;;<br>
+}<br>
+<br>
=C2=A0bool<br>
=C2=A0uevent_can_discard(struct uevent *uev)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0char *tmp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0char a[11], b[11];<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct config * conf;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 * keep only block devices, discard partitions<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0tmp =3D strstr(uev-&gt;devpath, &quot;/block/&q=
uot;);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (tmp =3D=3D NULL){<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(4, &quot;no=
 /block/ in &#39;%s&#39;&quot;, uev-&gt;devpath);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (uevent_can_discard_by_<wbr>devpath(uev-&gt;=
devpath))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return true;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (sscanf(tmp, &quot;/block/%10s&quot;, a) !=
=3D 1 ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sscanf(tmp, &quot;/block/%10[^/]/=
%10s&quot;, a, b) =3D=3D 2) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(4, &quot;di=
scard event on %s&quot;, uev-&gt;devpath);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* do not filter dm devices by devnode<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.12.0<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a><br>
</font></span></blockquote></div><br></div>

--94eb2c0b86ecb81a8e054ad35d95--


--===============7521505892953483701==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7521505892953483701==--
