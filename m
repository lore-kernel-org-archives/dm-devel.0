From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] Don't forget to reload table when both
 reload and rename is required
Date: Tue, 1 Jul 2014 20:46:24 +0200
Message-ID: <CABr-Gnfc2=v6__Gn0gGh5u+=SdxtWX3vUo5XZvGoXWVTmyxRTQ@mail.gmail.com>
References: <1403686653-14879-1-git-send-email-vaughan.cao@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4689150060836020056=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1403686653-14879-1-git-send-email-vaughan.cao@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4689150060836020056==
Content-Type: multipart/alternative; boundary=089e0129534e4bda7204fd2631cc

--089e0129534e4bda7204fd2631cc
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.


On Wed, Jun 25, 2014 at 10:57 AM, Vaughan Cao <vaughan.cao@oracle.com>
wrote:

> We encounter the following case:
>
> @ After adding a multipaths section into /etc/multipath.conf to specify
> 'alias'
> @ and other attributes for a particular multipath device and
> @ reloading/restarting the multipathd service, only renaming of the
> multipath
> @ device is done, other attribute changes are ignored.
> @
> @ It is more evident if you directly run 'multipath -r' to reload devmap
> after
> @ adding the 'multipaths' section with alias into /etc/multipath.conf.
> @
> @ When reload/restart multipathd service or 'multipath -r' again, new
> settings
> @ can be applied right.
>
> It's because that in select_action() when force_reload is set, if we also
> need
> rename the mpp device, reload action won't be taken any more.
>
> I did this patch by introducing a new action ACT_RENAME2 to group these two
> action. Test passed. However, it seems to be a rough patch and I am not
> certain if this bind is fine refering to dm_reassign. Please comment,
> Thanks.
>
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  libmultipath/configure.c | 11 +++++++++++
>  libmultipath/configure.h |  1 +
>  2 files changed, 12 insertions(+)
>
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 3ed6b55..7331f90 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -385,6 +385,8 @@ select_action (struct multipath * mpp, vector curmp,
> int force_reload)
>                                 cmpp->alias, mpp->alias);
>                         strncpy(mpp->alias_old, cmpp->alias, WWID_SIZE);
>                         mpp->action = ACT_RENAME;
> +                       if (force_reload)
> +                               mpp->action = ACT_RENAME2;
>                         return;
>                 }
>                 mpp->action = ACT_CREATE;
> @@ -623,6 +625,15 @@ domap (struct multipath * mpp, char * params)
>                 r = dm_rename(mpp->alias_old, mpp->alias);
>                 break;
>
> +       case ACT_RENAME2:
> +               r = dm_rename(mpp->alias_old, mpp->alias);
> +               if (r) {
> +                       r = dm_addmap_reload(mpp, params);
> +                       if (r)
> +                               r = dm_simplecmd_noflush(DM_DEVICE_RESUME,
> mpp->alias, MPATH_UDEV_RELOAD_FLAG);
> +               }
> +               break;
> +
>         default:
>                 break;
>         }
> diff --git a/libmultipath/configure.h b/libmultipath/configure.h
> index b3a6bb8..c014b55 100644
> --- a/libmultipath/configure.h
> +++ b/libmultipath/configure.h
> @@ -18,6 +18,7 @@ enum actions {
>         ACT_RENAME,
>         ACT_CREATE,
>         ACT_RESIZE,
> +       ACT_RENAME2,
>  };
>
>  #define FLUSH_ONE 1
> --
> 1.9.0
>
>

--089e0129534e4bda7204fd2631cc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Applied.<br></div>Thanks.<br></div><div class=3D"gmai=
l_extra"><br><br><div class=3D"gmail_quote">On Wed, Jun 25, 2014 at 10:57 A=
M, Vaughan Cao <span dir=3D"ltr">&lt;<a href=3D"mailto:vaughan.cao@oracle.c=
om" target=3D"_blank">vaughan.cao@oracle.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">We encounter the following case:<br>
<br>
@ After adding a multipaths section into /etc/multipath.conf to specify &#3=
9;alias&#39;<br>
@ and other attributes for a particular multipath device and<br>
@ reloading/restarting the multipathd service, only renaming of the multipa=
th<br>
@ device is done, other attribute changes are ignored.<br>
@<br>
@ It is more evident if you directly run &#39;multipath -r&#39; to reload d=
evmap after<br>
@ adding the &#39;multipaths&#39; section with alias into /etc/multipath.co=
nf.<br>
@<br>
@ When reload/restart multipathd service or &#39;multipath -r&#39; again, n=
ew settings<br>
@ can be applied right.<br>
<br>
It&#39;s because that in select_action() when force_reload is set, if we al=
so need<br>
rename the mpp device, reload action won&#39;t be taken any more.<br>
<br>
I did this patch by introducing a new action ACT_RENAME2 to group these two=
<br>
action. Test passed. However, it seems to be a rough patch and I am not<br>
certain if this bind is fine refering to dm_reassign. Please comment, Thank=
s.<br>
<br>
Signed-off-by: Vaughan Cao &lt;<a href=3D"mailto:vaughan.cao@oracle.com">va=
ughan.cao@oracle.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/configure.c | 11 +++++++++++<br>
=C2=A0libmultipath/configure.h | =C2=A01 +<br>
=C2=A02 files changed, 12 insertions(+)<br>
<br>
diff --git a/libmultipath/configure.c b/libmultipath/configure.c<br>
index 3ed6b55..7331f90 100644<br>
--- a/libmultipath/configure.c<br>
+++ b/libmultipath/configure.c<br>
@@ -385,6 +385,8 @@ select_action (struct multipath * mpp, vector curmp, in=
t force_reload)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cmpp-&gt;alias, mpp-&gt;alias);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 strncpy(mpp-&gt;alias_old, cmpp-&gt;alias, WWID_SIZE);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 mpp-&gt;action =3D ACT_RENAME;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (force_reload)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpp-&gt;action =3D ACT_RENAME2;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpp-&gt;action =3D =
ACT_CREATE;<br>
@@ -623,6 +625,15 @@ domap (struct multipath * mpp, char * params)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D dm_rename(mpp=
-&gt;alias_old, mpp-&gt;alias);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>
<br>
+ =C2=A0 =C2=A0 =C2=A0 case ACT_RENAME2:<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D dm_rename(mpp-&gt;=
alias_old, mpp-&gt;alias);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (r) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 r =3D dm_addmap_reload(mpp, params);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (r)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D dm_simplecmd_noflush(DM_DEVICE_RESUME=
, mpp-&gt;alias, MPATH_UDEV_RELOAD_FLAG);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 default:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
diff --git a/libmultipath/configure.h b/libmultipath/configure.h<br>
index b3a6bb8..c014b55 100644<br>
--- a/libmultipath/configure.h<br>
+++ b/libmultipath/configure.h<br>
@@ -18,6 +18,7 @@ enum actions {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ACT_RENAME,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ACT_CREATE,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ACT_RESIZE,<br>
+ =C2=A0 =C2=A0 =C2=A0 ACT_RENAME2,<br>
=C2=A0};<br>
<br>
=C2=A0#define FLUSH_ONE 1<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.9.0<br>
<br>
</font></span></blockquote></div><br></div>

--089e0129534e4bda7204fd2631cc--


--===============4689150060836020056==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4689150060836020056==--
