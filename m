From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: Fix information not shown when
 first path is down.
Date: Tue, 6 Oct 2015 08:54:12 +0200
Message-ID: <CABr-GnfXcKjmJAvrzCrNMN7=DvCGrcMp1zvOf1UemQB6_H-4Tw@mail.gmail.com>
References: <1444076357-18452-1-git-send-email-krisman@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8569103936041290917=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444076357-18452-1-git-send-email-krisman@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: mauricfo@linux.vnet.ibm.com, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
List-Id: dm-devel.ids

--===============8569103936041290917==
Content-Type: multipart/alternative; boundary=089e01184196f7ef9805216a1802

--089e01184196f7ef9805216a1802
Content-Type: text/plain; charset=UTF-8

Applied,
Thanks.

On Mon, Oct 5, 2015 at 10:19 PM, Gabriel Krisman Bertazi <
krisman@linux.vnet.ibm.com> wrote:

> vendor_id and product_id information are not shown when displaying
> multipath topology if the first path is down.
>
> 0QEMU_QEMU_HARDDISK_HELLOWORLD dm-0 ,      <--- Missing vendor and product
> size=10G features='0' hwhandler='0' wp=rw
> |-+- policy='service-time 0' prio=0 status=active
> | `- #:#:#:# -   #:#  active undef running
> `-+- policy='service-time 0' prio=0 status=enabled
>   `- 2:0:1:0 sdd 8:48 active undef running
>
> This happens because we only look at the first_path when printing the
> topology.  This patch looks at every slot in the path vector until we
> find one with the correct value.
>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
> ---
>  libmultipath/print.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 6594fee..fb2551e 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -248,11 +248,20 @@ snprint_multipath_uuid (char * buff, size_t len,
> struct multipath * mpp)
>  static int
>  snprint_multipath_vpr (char * buff, size_t len, struct multipath * mpp)
>  {
> -       struct path * pp = first_path(mpp);
> -       if (!pp)
> -               return 0;
> -       return snprintf(buff, len, "%s,%s",
> -                       pp->vendor_id, pp->product_id);
> +       struct pathgroup * pgp;
> +       struct path * pp;
> +       int i, j;
> +
> +       vector_foreach_slot(mpp->pg, pgp, i) {
> +               if (!pgp)
> +                       continue;
> +               vector_foreach_slot(pgp->paths, pp, j) {
> +                       if (strlen(pp->vendor_id) &&
> strlen(pp->product_id))
> +                               return snprintf(buff, len, "%s,%s",
> +                                               pp->vendor_id,
> pp->product_id);
> +               }
> +       }
> +       return snprintf(buff, len, "##,##");
>  }
>
>  static int
> --
> 2.1.0
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--089e01184196f7ef9805216a1802
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Mon, Oct 5, 2015 at 10:19 PM, Gabriel Kr=
isman Bertazi <span dir=3D"ltr">&lt;<a href=3D"mailto:krisman@linux.vnet.ib=
m.com" target=3D"_blank">krisman@linux.vnet.ibm.com</a>&gt;</span> wrote:<b=
r><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:=
1px #ccc solid;padding-left:1ex">vendor_id and product_id information are n=
ot shown when displaying<br>
multipath topology if the first path is down.<br>
<br>
0QEMU_QEMU_HARDDISK_HELLOWORLD dm-0 ,=C2=A0 =C2=A0 =C2=A0 &lt;--- Missing v=
endor and product<br>
size=3D10G features=3D&#39;0&#39; hwhandler=3D&#39;0&#39; wp=3Drw<br>
|-+- policy=3D&#39;service-time 0&#39; prio=3D0 status=3Dactive<br>
| `- #:#:#:# -=C2=A0 =C2=A0#:#=C2=A0 active undef running<br>
`-+- policy=3D&#39;service-time 0&#39; prio=3D0 status=3Denabled<br>
=C2=A0 `- 2:0:1:0 sdd 8:48 active undef running<br>
<br>
This happens because we only look at the first_path when printing the<br>
topology.=C2=A0 This patch looks at every slot in the path vector until we<=
br>
find one with the correct value.<br>
<br>
Signed-off-by: Gabriel Krisman Bertazi &lt;<a href=3D"mailto:krisman@linux.=
vnet.ibm.com">krisman@linux.vnet.ibm.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/print.c | 19 ++++++++++++++-----<br>
=C2=A01 file changed, 14 insertions(+), 5 deletions(-)<br>
<br>
diff --git a/libmultipath/print.c b/libmultipath/print.c<br>
index 6594fee..fb2551e 100644<br>
--- a/libmultipath/print.c<br>
+++ b/libmultipath/print.c<br>
@@ -248,11 +248,20 @@ snprint_multipath_uuid (char * buff, size_t len, stru=
ct multipath * mpp)<br>
=C2=A0static int<br>
=C2=A0snprint_multipath_vpr (char * buff, size_t len, struct multipath * mp=
p)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct path * pp =3D first_path(mpp);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pp)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return snprintf(buff, len, &quot;%s,%s&quot;,<b=
r>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0pp-&gt;vendor_id, pp-&gt;product_id);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct pathgroup * pgp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct path * pp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int i, j;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0vector_foreach_slot(mpp-&gt;pg, pgp, i) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pgp)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vector_foreach_slot=
(pgp-&gt;paths, pp, j) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (strlen(pp-&gt;vendor_id) &amp;&amp; strlen(pp-&gt;product_id)=
)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return snprintf(buff, len, &quot;%s,%=
s&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0pp-&gt;vendor_id, pp-&gt;product_id);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return snprintf(buff, len, &quot;##,##&quot;);<=
br>
=C2=A0}<br>
<br>
=C2=A0static int<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.1.0<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</font></span></blockquote></div><br></div>

--089e01184196f7ef9805216a1802--


--===============8569103936041290917==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8569103936041290917==--
