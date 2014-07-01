From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 01/12] Fix memory issues in path reordering
	failure code paths
Date: Tue, 1 Jul 2014 20:45:05 +0200
Message-ID: <CABr-GnfbiKC7X8_BhYqRhy4F6k3iBmei5g3D1gHO55ebs8Ooww@mail.gmail.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-2-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8749790427140265570=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-2-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8749790427140265570==
Content-Type: multipart/alternative; boundary=089e01184c7893ca7904fd262c14

--089e01184c7893ca7904fd262c14
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.


On Mon, Jun 30, 2014 at 7:13 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> There were some possible NULL pointer dereferences and multiple frees
> in the failure code paths of the path reordering code.  This patch
> cleans them up.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/configure.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 3ed6b55..6ad7a80 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -160,8 +160,16 @@ int order_paths_in_pg_by_alt_adapters(struct
> pathgroup *pgp, vector adapters,
>
>         while (total_paths > 0) {
>                 agp = VECTOR_SLOT(adapters, next_adapter_index);
> +               if (!agp) {
> +                       condlog(0, "can't get adapter group %d",
> next_adapter_index);
> +                       return 1;
> +               }
>
>                 hgp = VECTOR_SLOT(agp->host_groups, agp->next_host_index);
> +               if (!hgp) {
> +                       condlog(0, "can't get host group %d of adapter
> group %d", next_adapter_index, agp->next_host_index);
> +                       return 1;
> +               }
>
>                 if (!hgp->num_paths) {
>                         agp->next_host_index++;
> @@ -223,8 +231,8 @@ int rr_optimize_path_order(struct pathgroup *pgp)
>         /* group paths in path group by host adapters
>          */
>         if (group_by_host_adapter(pgp, adapters)) {
> +               /* already freed adapters */
>                 condlog(3, "Failed to group paths by adapters");
> -               free_adaptergroup(adapters);
>                 return 0;
>         }
>
> --
> 1.8.3.1
>
>

--089e01184c7893ca7904fd262c14
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Applied.<br></div>Thanks.<br></div><div class=3D"gmai=
l_extra"><br><br><div class=3D"gmail_quote">On Mon, Jun 30, 2014 at 7:13 AM=
, Benjamin Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redha=
t.com" target=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">There were some possible NULL pointer derefe=
rences and multiple frees<br>
in the failure code paths of the path reordering code. =C2=A0This patch<br>
cleans them up.<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/configure.c | 10 +++++++++-<br>
=C2=A01 file changed, 9 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/configure.c b/libmultipath/configure.c<br>
index 3ed6b55..6ad7a80 100644<br>
--- a/libmultipath/configure.c<br>
+++ b/libmultipath/configure.c<br>
@@ -160,8 +160,16 @@ int order_paths_in_pg_by_alt_adapters(struct pathgroup=
 *pgp, vector adapters,<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 while (total_paths &gt; 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 agp =3D VECTOR_SLOT=
(adapters, next_adapter_index);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!agp) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 condlog(0, &quot;can&#39;t get adapter group %d&quot;, next_adapter_ind=
ex);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return 1;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hgp =3D VECTOR_SLOT=
(agp-&gt;host_groups, agp-&gt;next_host_index);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!hgp) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 condlog(0, &quot;can&#39;t get host group %d of adapter group %d&quot;,=
 next_adapter_index, agp-&gt;next_host_index);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return 1;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!hgp-&gt;num_pa=
ths) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 agp-&gt;next_host_index++;<br>
@@ -223,8 +231,8 @@ int rr_optimize_path_order(struct pathgroup *pgp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* group paths in path group by host adapters<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (group_by_host_adapter(pgp, adapters)) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* already freed adapter=
s */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;Fa=
iled to group paths by adapters&quot;);<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free_adaptergroup(adapte=
rs);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--089e01184c7893ca7904fd262c14--


--===============8749790427140265570==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8749790427140265570==--
