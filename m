From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: check null path before
 handle path-failed event
Date: Sat, 13 Jan 2018 10:11:04 +0100
Message-ID: <CABr-Gnd97schLrwtA_1C6jNp6nKPQstj49krLn=Q7mj0uwhaaA@mail.gmail.com>
References: <1512393350-2956-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6002535035612902386=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512393350-2956-1-git-send-email-guanjunxiong@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Guan Junxiong <guanjunxiong@huawei.com>
Cc: device-mapper development <dm-devel@redhat.com>, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

--===============6002535035612902386==
Content-Type: multipart/alternative; boundary="001a1143877ac4a2e20562a4c270"

--001a1143877ac4a2e20562a4c270
Content-Type: text/plain; charset="UTF-8"

Merged.
Thanks.

On Mon, Dec 4, 2017 at 2:15 PM, Guan Junxiong <guanjunxiong@huawei.com>
wrote:

> In the hot-plug storage OS, if we tear down the target storage,
> there is a race between the path removing from the path list and
> handling the path-failed udev event. Therefore, we need to check
> null path before handle path-failed event.
>
> Signed-off-by: Guan Junxiong <guanjunxiong@huawei.com>
> ---
>  multipathd/main.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 31ce923..84bb2c5 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1073,7 +1073,7 @@ uev_pathfail_check(struct uevent *uev, struct
> vectors *vecs)
>  {
>         char *action = NULL, *devt = NULL;
>         struct path *pp;
> -       int r;
> +       int r = 1;
>
>         action = uevent_get_dm_action(uev);
>         if (!action)
> @@ -1090,15 +1090,17 @@ uev_pathfail_check(struct uevent *uev, struct
> vectors *vecs)
>         lock(&vecs->lock);
>         pthread_testcancel();
>         pp = find_path_by_devt(vecs->pathvec, devt);
> +    if (!pp)
> +        goto out_lock;
>         r = io_err_stat_handle_pathfail(pp);
> -       lock_cleanup_pop(vecs->lock);
> -
>         if (r)
>                 condlog(3, "io_err_stat: %s: cannot handle pathfail
> uevent",
>                                 pp->dev);
> +out_lock:
> +       lock_cleanup_pop(vecs->lock);
>         FREE(devt);
>         FREE(action);
> -       return 0;
> +       return r;
>  out:
>         FREE(action);
>         return 1;
> --
> 2.6.4.windows.1
>
>
>

--001a1143877ac4a2e20562a4c270
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, Dec 4, 2017 at 2:15 PM, Guan Junxion=
g <span dir=3D"ltr">&lt;<a href=3D"mailto:guanjunxiong@huawei.com" target=
=3D"_blank">guanjunxiong@huawei.com</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex">In the hot-plug storage OS, if we tear down the target sto=
rage,<br>
there is a race between the path removing from the path list and<br>
handling the path-failed udev event. Therefore, we need to check<br>
null path before handle path-failed event.<br>
<br>
Signed-off-by: Guan Junxiong &lt;<a href=3D"mailto:guanjunxiong@huawei.com"=
>guanjunxiong@huawei.com</a>&gt;<br>
---<br>
=C2=A0multipathd/main.c | 10 ++++++----<br>
=C2=A01 file changed, 6 insertions(+), 4 deletions(-)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 31ce923..84bb2c5 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -1073,7 +1073,7 @@ uev_pathfail_check(struct uevent *uev, struct vectors=
 *vecs)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *action =3D NULL, *devt =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path *pp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0int r;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int r =3D 1;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 action =3D uevent_get_dm_action(uev);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!action)<br>
@@ -1090,15 +1090,17 @@ uev_pathfail_check(struct uevent *uev, struct vecto=
rs *vecs)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 lock(&amp;vecs-&gt;lock);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_testcancel();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp =3D find_path_by_devt(vecs-&gt;<wbr>pathvec,=
 devt);<br>
+=C2=A0 =C2=A0 if (!pp)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_lock;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D io_err_stat_handle_pathfail(<wbr>pp);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0lock_cleanup_pop(vecs-&gt;lock);<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (r)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;io=
_err_stat: %s: cannot handle pathfail uevent&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;dev);<br>
+out_lock:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lock_cleanup_pop(vecs-&gt;lock);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(devt);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(action);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return r;<br>
=C2=A0out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(action);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.6.4.windows.1<br>
<br>
<br>
</font></span></blockquote></div><br></div>

--001a1143877ac4a2e20562a4c270--


--===============6002535035612902386==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6002535035612902386==--
