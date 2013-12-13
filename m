From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 10/11] multipathd: add path when transitioned
 from 'blocked' state
Date: Fri, 13 Dec 2013 23:02:53 +0100
Message-ID: <CABr-Gnek4cHGdp=74RvK4s95jZ6vw9ya+_oqY7aM1C5onaVh9Q@mail.gmail.com>
References: <1386936854-8399-1-git-send-email-hare@suse.de>
	<1386936854-8399-11-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7627857287062977148=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386936854-8399-11-git-send-email-hare@suse.de>
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
List-Id: dm-devel.ids

--===============7627857287062977148==
Content-Type: multipart/alternative; boundary=20cf30363fa1b6840604ed719f54

--20cf30363fa1b6840604ed719f54
Content-Type: text/plain; charset=ISO-8859-1

Hannes,

I merged the patchset.

Can you post a patch to set return values to the
multipathd/main.c::patch_check() exit points where it is not present.
This 11/12 patch adds one, and the "proactive path removal" patch adds the
other.
This requirement was introduced by your earlier "check timing" patch.

Thanks,
Christophe Varoqui


On Fri, Dec 13, 2013 at 1:14 PM, Hannes Reinecke <hare@suse.de> wrote:

> When a path is discovered in 'blocked' state it won't be added
> to the path list as we cannot get the path uuid.
> And any further check will fail here as the uuid won't be
> recovered. So add a check in checkerloop() to re-add the
> path if it gets out of a 'blocked' state.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  multipathd/main.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 7058147..cc5cf67 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1111,9 +1111,6 @@ check_path (struct vectors * vecs, struct path * pp)
>         int chkr_new_path_up = 0;
>         int oldchkrstate = pp->chkrstate;
>
> -       if (!pp->mpp)
> -               return;
> -
>         if (pp->tick && --pp->tick)
>                 return; /* don't check this path yet */
>
> @@ -1139,6 +1136,17 @@ check_path (struct vectors * vecs, struct path * pp)
>                 pathinfo(pp, conf->hwtable, 0);
>                 return;
>         }
> +       if (!pp->mpp) {
> +               if (!strlen(pp->wwid) &&
> +                   (newstate == PATH_UP || newstate == PATH_GHOST)) {
> +                       condlog(2, "%s: add missing path", pp->dev);
> +                       if (pathinfo(pp, conf->hwtable, DI_ALL) == 0) {
> +                               ev_add_path(pp, vecs);
> +                               pp->tick = 1;
> +                       }
> +               }
> +               return;
> +       }
>         /*
>          * Async IO in flight. Keep the previous path state
>          * and reschedule as soon as possible
> --
> 1.8.1.4
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--20cf30363fa1b6840604ed719f54
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hannes,<div><br></div><div>I merged the patchset.</div><di=
v><br></div><div>Can you post a patch to set return values to the multipath=
d/main.c::patch_check() exit points where it is not present.</div><div>This=
 11/12 patch adds one, and the &quot;proactive path removal&quot; patch add=
s the other.</div>
<div>This requirement was introduced by your earlier &quot;check timing&quo=
t; patch.</div><div><br></div><div>Thanks,</div><div>Christophe Varoqui</di=
v></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Fr=
i, Dec 13, 2013 at 1:14 PM, Hannes Reinecke <span dir=3D"ltr">&lt;<a href=
=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a>&gt;</span> wrot=
e:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">When a path is discovered in &#39;blocked&#3=
9; state it won&#39;t be added<br>
to the path list as we cannot get the path uuid.<br>
And any further check will fail here as the uuid won&#39;t be<br>
recovered. So add a check in checkerloop() to re-add the<br>
path if it gets out of a &#39;blocked&#39; state.<br>
<br>
Signed-off-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@sus=
e.de</a>&gt;<br>
---<br>
=A0multipathd/main.c | 14 +++++++++++---<br>
=A01 file changed, 11 insertions(+), 3 deletions(-)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 7058147..cc5cf67 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -1111,9 +1111,6 @@ check_path (struct vectors * vecs, struct path * pp)<=
br>
=A0 =A0 =A0 =A0 int chkr_new_path_up =3D 0;<br>
=A0 =A0 =A0 =A0 int oldchkrstate =3D pp-&gt;chkrstate;<br>
<br>
- =A0 =A0 =A0 if (!pp-&gt;mpp)<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;<br>
-<br>
=A0 =A0 =A0 =A0 if (pp-&gt;tick &amp;&amp; --pp-&gt;tick)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return; /* don&#39;t check this path yet */=
<br>
<br>
@@ -1139,6 +1136,17 @@ check_path (struct vectors * vecs, struct path * pp)=
<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pathinfo(pp, conf-&gt;hwtable, 0);<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;<br>
=A0 =A0 =A0 =A0 }<br>
+ =A0 =A0 =A0 if (!pp-&gt;mpp) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!strlen(pp-&gt;wwid) &amp;&amp;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (newstate =3D=3D PATH_UP || newstate =
=3D=3D PATH_GHOST)) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 condlog(2, &quot;%s: add miss=
ing path&quot;, pp-&gt;dev);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pathinfo(pp, conf-&gt;hwt=
able, DI_ALL) =3D=3D 0) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ev_add_path(p=
p, vecs);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pp-&gt;tick =
=3D 1;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;<br>
+ =A0 =A0 =A0 }<br>
=A0 =A0 =A0 =A0 /*<br>
=A0 =A0 =A0 =A0 =A0* Async IO in flight. Keep the previous path state<br>
=A0 =A0 =A0 =A0 =A0* and reschedule as soon as possible<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.1.4<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</font></span></blockquote></div><br></div>

--20cf30363fa1b6840604ed719f54--


--===============7627857287062977148==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7627857287062977148==--
