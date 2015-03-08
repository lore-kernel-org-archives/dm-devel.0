From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 00/15] Multipath patch resync
Date: Sun, 8 Mar 2015 11:04:19 +0100
Message-ID: <CABr-Gne6q0OedbxfqnQ+Lp9yGXvMC9D_n-9sVdc0Vw1qB-e=bg@mail.gmail.com>
References: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6780544448322378101=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
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

--===============6780544448322378101==
Content-Type: multipart/alternative; boundary=047d7bdc0dd288b7bb0510c40ab5

--047d7bdc0dd288b7bb0510c40ab5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

All good and applied. Thanks.

One minor glitch : building without LIBDM_API_DEFERRED defined leaves the
dm_cancel_remove_partmaps() function without use, which emits the following
build warning

devmapper.c:35:12: warning: =E2=80=98dm_cancel_remove_partmaps=E2=80=99 dec=
lared =E2=80=98static=E2=80=99
but never defined [-Wunused-function]
 static int dm_cancel_remove_partmaps(const char * mapname);


Would moving the function declaration in the #ifdef be fine with you ?

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 69491a3..458841f 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -32,8 +32,6 @@
 #define UUID_PREFIX "mpath-"
 #define UUID_PREFIX_LEN 6

-static int dm_cancel_remove_partmaps(const char * mapname);
-
 #ifndef LIBDM_API_COOKIE
 static inline int dm_task_set_cookie(struct dm_task *dmt, uint32_t *c, int
a)
 {
@@ -1134,9 +1132,15 @@ dm_remove_partmaps (const char * mapname, int
need_sync, int deferred_remove)
        return do_foreach_partmaps(mapname, remove_partmap, &rd);
 }

+
 #ifdef LIBDM_API_DEFERRED

 static int
+dm_cancel_remove_partmaps(const char * mapname) {
+       return do_foreach_partmaps(mapname, cancel_remove_partmap, NULL);
+}
+
+static int
 cancel_remove_partmap (char *name, void *unused)
 {
        if (dm_get_opencount(name))
@@ -1172,11 +1176,6 @@ out:
        return r;
 }

-static int
-dm_cancel_remove_partmaps(const char * mapname) {
-       return do_foreach_partmaps(mapname, cancel_remove_partmap, NULL);
-}
-
 int
 dm_cancel_deferred_remove (struct multipath *mpp)
 {


Best regards,
Christophe Varoqui
OpenSVC

On Sun, Mar 8, 2015 at 4:31 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> The first eight of these patches are resends of earlier patches, just
> rebased with minor changes. The next two are minor changes, adding
> multipath's -B option to mutipathd, and blacklisting vd.* devices.
> The two after that allow multipath to read additional configuration
> files in a configuration directory /etc/multipath/conf.d by default,
> and then do some cleanup of the parser code that I noticed while
> adding the configuration directories. The next patch adds two new
> configuration parameters that allow multipathd to delay the
> reintegration of paths that are failing repeatedly. The next one
> fixes a hard to hit memory corruption bug, and the last one
> updates the EMC builtin configuration to autodetect ALUA setups.
>
> Benjamin Marzinski (15):
>   correctly set partition delimiter on rename
>   libmultipath: fix sysfs_get_size bug
>   Revert "libmultipath: fixup strlcpy"
>   libmultipath: refactor partmaps code
>   multipathd: fix memory corruption issue
>   multipathd: add deferred_remove support
>   multipathd: don't buffer output with systemd
>   libmutipath: allow blanks in device blacklist
>   multipathd: read-only bindings
>   multipath: blacklist virtio-blk devices
>   multipath: enable configuration directory
>   libmultipath: cleanup parser code
>   multipathd: Add delayed path reintegration
>   Fix doublee free of alias after map add failure
>   libmultipath: autodetect ALUA CLARiiON configurations
>
>  libmultipath/Makefile      |   6 +
>  libmultipath/blacklist.c   |  18 ++-
>  libmultipath/checkers.c    |   1 +
>  libmultipath/checkers.h    |   9 ++
>  libmultipath/config.c      |  69 ++++++++++-
>  libmultipath/config.h      |  12 ++
>  libmultipath/configure.c   |   3 +
>  libmultipath/defaults.h    |   3 +
>  libmultipath/devmapper.c   | 284
> +++++++++++++++++++++++++++++----------------
>  libmultipath/devmapper.h   |  11 +-
>  libmultipath/dict.c        | 126 +++++++++++++++++---
>  libmultipath/dict.h        |   1 +
>  libmultipath/hwtable.c     |   2 +
>  libmultipath/parser.c      | 173 ++++++++-------------------
>  libmultipath/parser.h      |   9 +-
>  libmultipath/print.c       |   2 +
>  libmultipath/propsel.c     |  58 +++++++++
>  libmultipath/propsel.h     |   3 +
>  libmultipath/structs.h     |  17 +++
>  libmultipath/structs_vec.c |   3 +-
>  libmultipath/sysfs.c       |   2 +-
>  libmultipath/util.c        |   3 +-
>  multipath.conf.annotated   |  80 +++++++++++++
>  multipath.conf.defaults    |   7 +-
>  multipath/multipath.conf.5 |  54 +++++++++
>  multipathd/main.c          |  86 ++++++++++----
>  multipathd/multipathd.8    |   5 +
>  27 files changed, 761 insertions(+), 286 deletions(-)
>
> --
> 1.8.3.1
>
>

--047d7bdc0dd288b7bb0510c40ab5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">All good and applied. Thanks.<div><br></div><div>One minor=
 glitch : building without LIBDM_API_DEFERRED defined leaves the dm_cancel_=
remove_partmaps() function without use, which emits the following build war=
ning</div><div><br></div><div><div>devmapper.c:35:12: warning: =E2=80=98dm_=
cancel_remove_partmaps=E2=80=99 declared =E2=80=98static=E2=80=99 but never=
 defined [-Wunused-function]</div><div>=C2=A0static int dm_cancel_remove_pa=
rtmaps(const char * mapname);</div></div><div><br></div><div><br></div><div=
>Would moving the function declaration in the #ifdef be fine with you ?</di=
v><div><br></div><div><div>diff --git a/libmultipath/devmapper.c b/libmulti=
path/devmapper.c</div><div>index 69491a3..458841f 100644</div><div>--- a/li=
bmultipath/devmapper.c</div><div>+++ b/libmultipath/devmapper.c</div><div>@=
@ -32,8 +32,6 @@</div><div>=C2=A0#define UUID_PREFIX &quot;mpath-&quot;</di=
v><div>=C2=A0#define UUID_PREFIX_LEN 6</div><div>=C2=A0</div><div>-static i=
nt dm_cancel_remove_partmaps(const char * mapname);</div><div>-</div><div>=
=C2=A0#ifndef LIBDM_API_COOKIE</div><div>=C2=A0static inline int dm_task_se=
t_cookie(struct dm_task *dmt, uint32_t *c, int a)</div><div>=C2=A0{</div><d=
iv>@@ -1134,9 +1132,15 @@ dm_remove_partmaps (const char * mapname, int nee=
d_sync, int deferred_remove)</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 return d=
o_foreach_partmaps(mapname, remove_partmap, &amp;rd);</div><div>=C2=A0}</di=
v><div>=C2=A0</div><div>+</div><div>=C2=A0#ifdef LIBDM_API_DEFERRED</div><d=
iv>=C2=A0</div><div>=C2=A0static int</div><div>+dm_cancel_remove_partmaps(c=
onst char * mapname) {</div><div>+ =C2=A0 =C2=A0 =C2=A0 return do_foreach_p=
artmaps(mapname, cancel_remove_partmap, NULL);</div><div>+}</div><div>+</di=
v><div>+static int</div><div>=C2=A0cancel_remove_partmap (char *name, void =
*unused)</div><div>=C2=A0{</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dm_get=
_opencount(name))</div><div>@@ -1172,11 +1176,6 @@ out:</div><div>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 return r;</div><div>=C2=A0}</div><div>=C2=A0</div><div=
>-static int</div><div>-dm_cancel_remove_partmaps(const char * mapname) {</=
div><div>- =C2=A0 =C2=A0 =C2=A0 return do_foreach_partmaps(mapname, cancel_=
remove_partmap, NULL);</div><div>-}</div><div>-</div><div>=C2=A0int</div><d=
iv>=C2=A0dm_cancel_deferred_remove (struct multipath *mpp)</div><div>=C2=A0=
{</div></div><div><br></div><div><br></div><div>Best regards,</div><div>Chr=
istophe Varoqui</div><div>OpenSVC</div></div><div class=3D"gmail_extra"><br=
><div class=3D"gmail_quote">On Sun, Mar 8, 2015 at 4:31 AM, Benjamin Marzin=
ski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"=
_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">The first eight of these patches are resends of earlier patches, j=
ust<br>
rebased with minor changes. The next two are minor changes, adding<br>
multipath&#39;s -B option to mutipathd, and blacklisting vd.* devices.<br>
The two after that allow multipath to read additional configuration<br>
files in a configuration directory /etc/multipath/conf.d by default,<br>
and then do some cleanup of the parser code that I noticed while<br>
adding the configuration directories. The next patch adds two new<br>
configuration parameters that allow multipathd to delay the<br>
reintegration of paths that are failing repeatedly. The next one<br>
fixes a hard to hit memory corruption bug, and the last one<br>
updates the EMC builtin configuration to autodetect ALUA setups.<br>
<br>
Benjamin Marzinski (15):<br>
=C2=A0 correctly set partition delimiter on rename<br>
=C2=A0 libmultipath: fix sysfs_get_size bug<br>
=C2=A0 Revert &quot;libmultipath: fixup strlcpy&quot;<br>
=C2=A0 libmultipath: refactor partmaps code<br>
=C2=A0 multipathd: fix memory corruption issue<br>
=C2=A0 multipathd: add deferred_remove support<br>
=C2=A0 multipathd: don&#39;t buffer output with systemd<br>
=C2=A0 libmutipath: allow blanks in device blacklist<br>
=C2=A0 multipathd: read-only bindings<br>
=C2=A0 multipath: blacklist virtio-blk devices<br>
=C2=A0 multipath: enable configuration directory<br>
=C2=A0 libmultipath: cleanup parser code<br>
=C2=A0 multipathd: Add delayed path reintegration<br>
=C2=A0 Fix doublee free of alias after map add failure<br>
=C2=A0 libmultipath: autodetect ALUA CLARiiON configurations<br>
<br>
=C2=A0libmultipath/Makefile=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A06 +<br>
=C2=A0libmultipath/blacklist.c=C2=A0 =C2=A0|=C2=A0 18 ++-<br>
=C2=A0libmultipath/checkers.c=C2=A0 =C2=A0 |=C2=A0 =C2=A01 +<br>
=C2=A0libmultipath/checkers.h=C2=A0 =C2=A0 |=C2=A0 =C2=A09 ++<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 69 ++++++++++-<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 12 ++<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0|=C2=A0 =C2=A03 +<br>
=C2=A0libmultipath/defaults.h=C2=A0 =C2=A0 |=C2=A0 =C2=A03 +<br>
=C2=A0libmultipath/devmapper.c=C2=A0 =C2=A0| 284 ++++++++++++++++++++++++++=
+++----------------<br>
=C2=A0libmultipath/devmapper.h=C2=A0 =C2=A0|=C2=A0 11 +-<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 | 126 ++++++++++++++++=
+---<br>
=C2=A0libmultipath/dict.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A01 +<br>
=C2=A0libmultipath/hwtable.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +<br>
=C2=A0libmultipath/parser.c=C2=A0 =C2=A0 =C2=A0 | 173 ++++++++-------------=
------<br>
=C2=A0libmultipath/parser.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A09 +-<br>
=C2=A0libmultipath/print.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 58 +++++++++<br>
=C2=A0libmultipath/propsel.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A03 +<br>
=C2=A0libmultipath/structs.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 17 +++<br>
=C2=A0libmultipath/structs_vec.c |=C2=A0 =C2=A03 +-<br>
=C2=A0libmultipath/sysfs.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +-<br>
=C2=A0libmultipath/util.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A03 +-<br>
=C2=A0multipath.conf.annotated=C2=A0 =C2=A0|=C2=A0 80 +++++++++++++<br>
=C2=A0multipath.conf.defaults=C2=A0 =C2=A0 |=C2=A0 =C2=A07 +-<br>
=C2=A0multipath/multipath.conf.5 |=C2=A0 54 +++++++++<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 86 ++++++=
++++----<br>
=C2=A0multipathd/multipathd.8=C2=A0 =C2=A0 |=C2=A0 =C2=A05 +<br>
=C2=A027 files changed, 761 insertions(+), 286 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--047d7bdc0dd288b7bb0510c40ab5--


--===============6780544448322378101==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6780544448322378101==--
