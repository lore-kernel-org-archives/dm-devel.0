From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: fix skip_kpartx support for
	removing maps
Date: Fri, 14 Apr 2017 10:42:52 +0200
Message-ID: <CABr-Gnd=M3+OMo_D7LrR1hLrW+Hd0GBELD91_UaYHbJZ1V3ezg@mail.gmail.com>
References: <20170405224402.GI19236@octiron.msp.redhat.com>
	<20170413130548.20420-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4388107817416555079=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170413130548.20420-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.de>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4388107817416555079==
Content-Type: multipart/alternative; boundary=001a113d217259db92054d1c6da3

--001a113d217259db92054d1c6da3
Content-Type: text/plain; charset=UTF-8

Merged,
Thanks.

On Thu, Apr 13, 2017 at 3:05 PM, Martin Wilck <mwilck@suse.com> wrote:

> Commit 79a05a4e inadvertently removed the code necessary
> to support multipath maps without partitions, as introduced
> in b73a34ea "libmultipath: add skip_kpartx option". Revert
> this part of the commit, so that skip_kpartx works again.
>
> Fixes: 79a05a4e libmultipath: move suspend logic to _dm_flush_map
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 026418f8..5fb9d9ac 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -761,6 +761,12 @@ out:
>  }
>
>  static int
> +has_partmap(const char *name, void *data)
> +{
> +       return 1;
> +}
> +
> +static int
>  partmap_in_use(const char *name, void *data)
>  {
>         int part_count, *ret_count = (int *)data;
> @@ -785,12 +791,18 @@ int _dm_flush_map (const char * mapname, int
> need_sync, int deferred_remove,
>  {
>         int r;
>         int queue_if_no_path = 0;
> +       int udev_flags = 0;
>         unsigned long long mapsize;
>         char params[PARAMS_SIZE] = {0};
>
>         if (!dm_is_mpath(mapname))
>                 return 0; /* nothing to do */
>
> +       /* if the device currently has no partitions, do not
> +          run kpartx on it if you fail to delete it */
> +       if (do_foreach_partmaps(mapname, has_partmap, NULL) == 0)
> +               udev_flags |= MPATH_UDEV_NO_KPARTX_FLAG;
> +
>         /* If you aren't doing a deferred remove, make sure that no
>          * devices are in use */
>         if (!do_deferred(deferred_remove) && partmap_in_use(mapname, NULL))
> @@ -834,7 +846,7 @@ int _dm_flush_map (const char * mapname, int
> need_sync, int deferred_remove,
>                                 mapname);
>                         if (need_suspend && queue_if_no_path != -1) {
>                                 dm_simplecmd_noflush(DM_DEVICE_RESUME,
> -                                                    mapname, 0);
> +                                                    mapname, udev_flags);
>                         }
>                 }
>                 if (retries)
> --
> 2.12.2
>
>

--001a113d217259db92054d1c6da3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Thu, Apr 13, 2017 at 3:05 PM, Martin Wilc=
k <span dir=3D"ltr">&lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blank=
">mwilck@suse.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">C=
ommit 79a05a4e inadvertently removed the code necessary<br>
to support multipath maps without partitions, as introduced<br>
in b73a34ea &quot;libmultipath: add skip_kpartx option&quot;. Revert<br>
this part of the commit, so that skip_kpartx works again.<br>
<br>
Fixes: 79a05a4e libmultipath: move suspend logic to _dm_flush_map<br>
Signed-off-by: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@s=
use.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/devmapper.c | 14 +++++++++++++-<br>
=C2=A01 file changed, 13 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c<br>
index 026418f8..5fb9d9ac 100644<br>
--- a/libmultipath/devmapper.c<br>
+++ b/libmultipath/devmapper.c<br>
@@ -761,6 +761,12 @@ out:<br>
=C2=A0}<br>
<br>
=C2=A0static int<br>
+has_partmap(const char *name, void *data)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
+}<br>
+<br>
+static int<br>
=C2=A0partmap_in_use(const char *name, void *data)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int part_count, *ret_count =3D (int *)data;<br>
@@ -785,12 +791,18 @@ int _dm_flush_map (const char * mapname, int need_syn=
c, int deferred_remove,<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int queue_if_no_path =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int udev_flags =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long long mapsize;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char params[PARAMS_SIZE] =3D {0};<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_is_mpath(mapname))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0; /* nothin=
g to do */<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* if the device currently has no partitions, d=
o not<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 run kpartx on it if you fail to delete =
it */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (do_foreach_partmaps(mapname, has_partmap, N=
ULL) =3D=3D 0)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0udev_flags |=3D MPA=
TH_UDEV_NO_KPARTX_FLAG;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* If you aren&#39;t doing a deferred remove, m=
ake sure that no<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* devices are in use */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!do_deferred(deferred_remove) &amp;&amp; pa=
rtmap_in_use(mapname, NULL))<br>
@@ -834,7 +846,7 @@ int _dm_flush_map (const char * mapname, int need_sync,=
 int deferred_remove,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mapname);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (need_suspend &amp;&amp; queue_if_no_path !=3D -1) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_simplecmd_noflush(DM_<wbr>DEVICE_=
RESUME,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mapname, 0);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mapname, udev_flags);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (retries)<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.12.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a113d217259db92054d1c6da3--


--===============4388107817416555079==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4388107817416555079==--
