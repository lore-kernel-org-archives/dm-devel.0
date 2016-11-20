From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: fix missing dm_task_destroy()
	in dm_reassign()
Date: Sun, 20 Nov 2016 14:36:53 +0100
Message-ID: <CABr-GneE+9TeVvvt3Vj1C6PNttcenXzARghCiJrckisZd+gu9w@mail.gmail.com>
References: <1478484077-9740-1-git-send-email-zhou.guichun@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0987183839989236465=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1478484077-9740-1-git-send-email-zhou.guichun@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: zhou.guichun@zte.com.cn
Cc: zhang.kai16@zte.com.cn, tang.junhui@zte.com.cn, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0987183839989236465==
Content-Type: multipart/alternative; boundary=001a1142c1e6e62eaa0541bba1a8

--001a1142c1e6e62eaa0541bba1a8
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Mon, Nov 7, 2016 at 3:01 AM, <zhou.guichun@zte.com.cn> wrote:

> From: "zhou.guichun" <zhou.guichun@zte.com.cn>
>
> dm_task should be destoryed before going out of dm_reassign()
>
> Signed-off-by: zhou.guichun <zhou.guichun@zte.com.cn>
> ---
>  libmultipath/devmapper.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 5aea5b6..e9d13b6 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1582,10 +1582,9 @@ int dm_reassign(const char *mapname)
>                 sysfs_check_holders(dm_dep, dev_t);
>         }
>
> -       dm_task_destroy (dmt);
> -
>         r = 1;
>  out:
> +       dm_task_destroy (dmt);
>         return r;
>  }
>
> --
> 2.8.1.windows.1
>
>

--001a1142c1e6e62eaa0541bba1a8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, Nov 7, 2016 at 3:01 AM,  <span dir=
=3D"ltr">&lt;<a href=3D"mailto:zhou.guichun@zte.com.cn" target=3D"_blank">z=
hou.guichun@zte.com.cn</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex">From: &quot;zhou.guichun&quot; &lt;<a href=3D"mailto:zhou.guichun@zte.c=
om.cn">zhou.guichun@zte.com.cn</a>&gt;<br>
<br>
dm_task should be destoryed before going out of dm_reassign()<br>
<br>
Signed-off-by: zhou.guichun &lt;<a href=3D"mailto:zhou.guichun@zte.com.cn">=
zhou.guichun@zte.com.cn</a>&gt;<br>
---<br>
=C2=A0libmultipath/devmapper.c | 3 +--<br>
=C2=A01 file changed, 1 insertion(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c<br>
index 5aea5b6..e9d13b6 100644<br>
--- a/libmultipath/devmapper.c<br>
+++ b/libmultipath/devmapper.c<br>
@@ -1582,10 +1582,9 @@ int dm_reassign(const char *mapname)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sysfs_check_holders=
(dm_dep, dev_t);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_task_destroy (dmt);<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D 1;<br>
=C2=A0out:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_task_destroy (dmt);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
=C2=A0}<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.8.1.windows.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a1142c1e6e62eaa0541bba1a8--


--===============0987183839989236465==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0987183839989236465==--
