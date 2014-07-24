From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 07/12] Make multipathd orphan paths that were
	removed externally
Date: Thu, 24 Jul 2014 10:41:38 +0200
Message-ID: <CABr-GnfZUwBA0DXY=6okz=W3MVrkD4Cp01P5-uC-Ov-p5v7EWg@mail.gmail.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-8-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7474865234632793197=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-8-git-send-email-bmarzins@redhat.com>
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

--===============7474865234632793197==
Content-Type: multipart/alternative; boundary=e89a8fb1ea68d6820c04feec6ca0

--e89a8fb1ea68d6820c04feec6ca0
Content-Type: text/plain; charset=UTF-8

Applied,
Thanks.


On Mon, Jun 30, 2014 at 7:13 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> Multipathd was only orphaning paths that it removed, not ones that were
> removed by the multipath command.  This could cause problems if a path
> was failed but not removed, and "multipath -r" was run.  multipath would
> remove the path, and when multipathd updated itself, it would remove
> that path from the multipath device's path list, but not orphan it.
> When the path became active again, multipathd crashed trying to adjust
> the pathgroups of the multipath device it had previously belonged to.
>
> This patch makes sure that whenever multipathd updates the multipath device
> table, it first makes sure the mpp->paths is uptodate.  Once it has
> finished updating the device table, it orphans any paths in mpp->paths
> that are no longer part of the multipath device.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/structs_vec.c | 31 +++++++++++++++++++++++++++----
>  multipathd/main.c          |  4 ++++
>  2 files changed, 31 insertions(+), 4 deletions(-)
>
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 8cdbe3d..23f5bbb 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -281,12 +281,38 @@ update_multipath_status (struct multipath *mpp)
>         return 0;
>  }
>
> +void sync_paths(struct multipath *mpp, vector pathvec)
> +{
> +       struct path *pp;
> +       struct pathgroup  *pgp;
> +       int found, i, j;
> +
> +       vector_foreach_slot (mpp->paths, pp, i) {
> +               found = 0;
> +               vector_foreach_slot(mpp->pg, pgp, j) {
> +                       if (find_slot(pgp->paths, (void *)pp) != -1) {
> +                               found = 1;
> +                               break;
> +                       }
> +               }
> +               if (!found) {
> +                       condlog(3, "%s dropped path %s", mpp->alias,
> pp->dev);
> +                       vector_del_slot(mpp->paths, i--);
> +                       orphan_path(pp, "path removed externally");
> +               }
> +       }
> +       update_mpp_paths(mpp, pathvec);
> +       vector_foreach_slot (mpp->paths, pp, i)
> +               pp->mpp = mpp;
> +}
> +
>  extern int
>  update_multipath_strings (struct multipath *mpp, vector pathvec)
>  {
>         if (!mpp)
>                 return 1;
>
> +       update_mpp_paths(mpp, pathvec);
>         condlog(4, "%s: %s", mpp->alias, __FUNCTION__);
>
>         free_multipath_attributes(mpp);
> @@ -295,6 +321,7 @@ update_multipath_strings (struct multipath *mpp,
> vector pathvec)
>
>         if (update_multipath_table(mpp, pathvec))
>                 return 1;
> +       sync_paths(mpp, pathvec);
>
>         if (update_multipath_status(mpp))
>                 return 1;
> @@ -508,13 +535,9 @@ int update_multipath (struct vectors *vecs, char
> *mapname, int reset)
>                 return 2;
>         }
>
> -       free_pgvec(mpp->pg, KEEP_PATHS);
> -       mpp->pg = NULL;
> -
>         if (__setup_multipath(vecs, mpp, reset))
>                 return 1; /* mpp freed in setup_multipath */
>
> -       adopt_paths(vecs->pathvec, mpp, 0);
>         /*
>          * compare checkers states with DM states
>          */
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 56d00d3..337bfe9 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1170,6 +1170,10 @@ check_path (struct vectors * vecs, struct path * pp)
>                         pp->dev);
>                 pp->dmstate = PSTATE_UNDEF;
>         }
> +       /* if update_multipath_strings orphaned the path, quit early */
> +       if (!pp->mpp)
> +               return 0;
> +
>         pp->chkrstate = newstate;
>         if (newstate != pp->state) {
>                 int oldstate = pp->state;
> --
> 1.8.3.1
>
>

--e89a8fb1ea68d6820c04feec6ca0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><br><div class=3D"gmail_quote">On Mon, Jun 30, 2014 at 7:13 AM, Benjam=
in Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" t=
arget=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Multipathd was only orphaning paths that it =
removed, not ones that were<br>
removed by the multipath command. =C2=A0This could cause problems if a path=
<br>
was failed but not removed, and &quot;multipath -r&quot; was run. =C2=A0mul=
tipath would<br>
remove the path, and when multipathd updated itself, it would remove<br>
that path from the multipath device&#39;s path list, but not orphan it.<br>
When the path became active again, multipathd crashed trying to adjust<br>
the pathgroups of the multipath device it had previously belonged to.<br>
<br>
This patch makes sure that whenever multipathd updates the multipath device=
<br>
table, it first makes sure the mpp-&gt;paths is uptodate. =C2=A0Once it has=
<br>
finished updating the device table, it orphans any paths in mpp-&gt;paths<b=
r>
that are no longer part of the multipath device.<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/structs_vec.c | 31 +++++++++++++++++++++++++++----<br>
=C2=A0multipathd/main.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A04 ++++<br=
>
=C2=A02 files changed, 31 insertions(+), 4 deletions(-)<br>
<br>
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c<br>
index 8cdbe3d..23f5bbb 100644<br>
--- a/libmultipath/structs_vec.c<br>
+++ b/libmultipath/structs_vec.c<br>
@@ -281,12 +281,38 @@ update_multipath_status (struct multipath *mpp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
+void sync_paths(struct multipath *mpp, vector pathvec)<br>
+{<br>
+ =C2=A0 =C2=A0 =C2=A0 struct path *pp;<br>
+ =C2=A0 =C2=A0 =C2=A0 struct pathgroup =C2=A0*pgp;<br>
+ =C2=A0 =C2=A0 =C2=A0 int found, i, j;<br>
+<br>
+ =C2=A0 =C2=A0 =C2=A0 vector_foreach_slot (mpp-&gt;paths, pp, i) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 found =3D 0;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vector_foreach_slot(mpp-=
&gt;pg, pgp, j) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (find_slot(pgp-&gt;paths, (void *)pp) !=3D -1) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 found =3D 1;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 }<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!found) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 condlog(3, &quot;%s dropped path %s&quot;, mpp-&gt;alias, pp-&gt;dev);<=
br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 vector_del_slot(mpp-&gt;paths, i--);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 orphan_path(pp, &quot;path removed externally&quot;);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+ =C2=A0 =C2=A0 =C2=A0 }<br>
+ =C2=A0 =C2=A0 =C2=A0 update_mpp_paths(mpp, pathvec);<br>
+ =C2=A0 =C2=A0 =C2=A0 vector_foreach_slot (mpp-&gt;paths, pp, i)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;mpp =3D mpp;<br>
+}<br>
+<br>
=C2=A0extern int<br>
=C2=A0update_multipath_strings (struct multipath *mpp, vector pathvec)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!mpp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
+ =C2=A0 =C2=A0 =C2=A0 update_mpp_paths(mpp, pathvec);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(4, &quot;%s: %s&quot;, mpp-&gt;alias, _=
_FUNCTION__);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 free_multipath_attributes(mpp);<br>
@@ -295,6 +321,7 @@ update_multipath_strings (struct multipath *mpp, vector=
 pathvec)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (update_multipath_table(mpp, pathvec))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
+ =C2=A0 =C2=A0 =C2=A0 sync_paths(mpp, pathvec);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (update_multipath_status(mpp))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
@@ -508,13 +535,9 @@ int update_multipath (struct vectors *vecs, char *mapn=
ame, int reset)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 2;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
- =C2=A0 =C2=A0 =C2=A0 free_pgvec(mpp-&gt;pg, KEEP_PATHS);<br>
- =C2=A0 =C2=A0 =C2=A0 mpp-&gt;pg =3D NULL;<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (__setup_multipath(vecs, mpp, reset))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1; /* mpp fr=
eed in setup_multipath */<br>
<br>
- =C2=A0 =C2=A0 =C2=A0 adopt_paths(vecs-&gt;pathvec, mpp, 0);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* compare checkers states with DM states<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 56d00d3..337bfe9 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -1170,6 +1170,10 @@ check_path (struct vectors * vecs, struct path * pp)=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 pp-&gt;dev);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;dmstate =3D =
PSTATE_UNDEF;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+ =C2=A0 =C2=A0 =C2=A0 /* if update_multipath_strings orphaned the path, qu=
it early */<br>
+ =C2=A0 =C2=A0 =C2=A0 if (!pp-&gt;mpp)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;chkrstate =3D newstate;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (newstate !=3D pp-&gt;state) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int oldstate =3D pp=
-&gt;state;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--e89a8fb1ea68d6820c04feec6ca0--


--===============7474865234632793197==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7474865234632793197==--
