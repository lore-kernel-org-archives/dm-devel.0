From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: lazy device-mapper
	initialization
Date: Wed, 21 Jun 2017 12:24:41 +0200
Message-ID: <CABr-Gnc0pToHqDGc6KZJTN1yRda7=XvTDPtSp=O6gemvpimE+Q@mail.gmail.com>
References: <20170606193311.5096-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4712110298980686384=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170606193311.5096-1-mwilck@suse.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4712110298980686384==
Content-Type: multipart/alternative; boundary="94eb2c095084b45648055275c695"

--94eb2c095084b45648055275c695
Content-Type: text/plain; charset="UTF-8"

Merged,
Thanks.

On Tue, Jun 6, 2017 at 9:33 PM, Martin Wilck <mwilck@suse.com> wrote:

> The multipath command fails early if libdevmapper and/or the
> dm_multipath driver are not found. But some multipath operations
> don't require device mapper, notably the path checking operations
> called from udev rules during early boot.
>
> This patch delays dm initialization until the first device-mapper
> call, allowing such operations to succeed even if the dm_multipath
> driver is not loaded yet.
>
> This fixes the following problem: during system boot, the dm_multipath
> driver is usually loaded via "ExecStartPre" from the multipathd service
> file. But with commit d7188fcd, this service is started only after
> udev settle and thus the modules are loaded too late for udev
> rule processing, causing "multipath" invocations from udev rules to fail
> and paths to be wrongly classified as non-multipath.
>
> Fixes: d7188fcd "multipathd: start daemon after udev trigger"
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 79 ++++++++++++++++++++++++++++++
> ++++--------------
>  libmultipath/devmapper.h |  4 ++-
>  libmultipath/waiter.c    |  2 +-
>  multipath/main.c         |  8 ++---
>  multipathd/main.c        |  4 +--
>  5 files changed, 63 insertions(+), 34 deletions(-)
>
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 69b634bf..4319b381 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -21,6 +21,7 @@
>  #include "memory.h"
>  #include "devmapper.h"
>  #include "sysfs.h"
> +#include "config.h"
>
>  #include "log_pthread.h"
>  #include <sys/types.h>
> @@ -178,7 +179,7 @@ out:
>  }
>
>  static int
> -dm_drv_prereq (void)
> +dm_drv_prereq (unsigned int *ver)
>  {
>         unsigned int minv[3] = {1, 0, 3};
>         unsigned int version[3] = {0, 0, 0};
> @@ -193,19 +194,51 @@ dm_drv_prereq (void)
>         condlog(3, "DM multipath kernel driver v%u.%u.%u",
>                 v[0], v[1], v[2]);
>
> -       if VERSION_GE(v, minv)
> +       if (VERSION_GE(v, minv)) {
> +               ver[0] = v[0];
> +               ver[1] = v[1];
> +               ver[2] = v[2];
>                 return 0;
> +       }
>
>         condlog(0, "DM multipath kernel driver must be >= v%u.%u.%u",
>                 minv[0], minv[1], minv[2]);
>         return 1;
>  }
>
> -int dm_prereq(void)
> +static int dm_prereq(unsigned int *v)
>  {
>         if (dm_lib_prereq())
>                 return 1;
> -       return dm_drv_prereq();
> +       return dm_drv_prereq(v);
> +}
> +
> +static int libmp_dm_udev_sync = 0;
> +
> +void libmp_udev_set_sync_support(int on)
> +{
> +       libmp_dm_udev_sync = !!on;
> +}
> +
> +void libmp_dm_init(void)
> +{
> +       struct config *conf;
> +
> +       conf = get_multipath_config();
> +       dm_init(conf->verbosity);
> +       if (dm_prereq(conf->version))
> +               exit(1);
> +       put_multipath_config(conf);
> +       dm_udev_set_sync_support(libmp_dm_udev_sync);
> +}
> +
> +struct dm_task*
> +libmp_dm_task_create(int task)
> +{
> +       static pthread_once_t dm_initialized = PTHREAD_ONCE_INIT;
> +
> +       pthread_once(&dm_initialized, libmp_dm_init);
> +       return dm_task_create(task);
>  }
>
>  #define do_deferred(x) ((x) == DEFERRED_REMOVE_ON || (x) ==
> DEFERRED_REMOVE_IN_PROGRESS)
> @@ -219,7 +252,7 @@ dm_simplecmd (int task, const char *name, int
> no_flush, int need_sync, uint16_t
>         uint32_t cookie = 0;
>         struct dm_task *dmt;
>
> -       if (!(dmt = dm_task_create (task)))
> +       if (!(dmt = libmp_dm_task_create (task)))
>                 return 0;
>
>         if (!dm_task_set_name (dmt, name))
> @@ -274,7 +307,7 @@ dm_addmap (int task, const char *target, struct
> multipath *mpp,
>         uint32_t cookie = 0;
>         uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK |
> ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
>
> -       if (!(dmt = dm_task_create (task)))
> +       if (!(dmt = libmp_dm_task_create (task)))
>                 return 0;
>
>         if (!dm_task_set_name (dmt, mpp->alias))
> @@ -411,7 +444,7 @@ do_get_info(const char *name, struct dm_info *info)
>         int r = -1;
>         struct dm_task *dmt;
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_INFO)))
>                 return r;
>
>         if (!dm_task_set_name(dmt, name))
> @@ -449,7 +482,7 @@ int dm_get_map(const char *name, unsigned long long
> *size, char *outparams)
>         char *target_type = NULL;
>         char *params = NULL;
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_TABLE)))
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
>                 return 1;
>
>         if (!dm_task_set_name(dmt, name))
> @@ -485,7 +518,7 @@ dm_get_prefixed_uuid(const char *name, char *uuid)
>         const char *uuidtmp;
>         int r = 1;
>
> -       dmt = dm_task_create(DM_DEVICE_INFO);
> +       dmt = libmp_dm_task_create(DM_DEVICE_INFO);
>         if (!dmt)
>                 return 1;
>
> @@ -548,7 +581,7 @@ int dm_get_status(char *name, char *outstatus)
>         char *target_type = NULL;
>         char *status = NULL;
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_STATUS)))
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_STATUS)))
>                 return 1;
>
>         if (!dm_task_set_name(dmt, name))
> @@ -591,7 +624,7 @@ int dm_type(const char *name, char *type)
>         char *target_type = NULL;
>         char *params;
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_TABLE)))
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
>                 return 0;
>
>         if (!dm_task_set_name(dmt, name))
> @@ -627,7 +660,7 @@ int dm_is_mpath(const char *name)
>         char *params;
>         const char *uuid;
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_TABLE)))
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
>                 return 0;
>
>         if (!dm_task_set_name(dmt, name))
> @@ -679,7 +712,7 @@ dm_get_opencount (const char * mapname)
>         struct dm_task *dmt;
>         struct dm_info info;
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_INFO)))
>                 return 0;
>
>         if (!dm_task_set_name(dmt, mapname))
> @@ -837,7 +870,7 @@ int dm_flush_maps (int retries)
>         struct dm_names *names;
>         unsigned next = 0;
>
> -       if (!(dmt = dm_task_create (DM_DEVICE_LIST)))
> +       if (!(dmt = libmp_dm_task_create (DM_DEVICE_LIST)))
>                 return 0;
>
>         dm_task_no_open_count(dmt);
> @@ -868,7 +901,7 @@ dm_message(const char * mapname, char * message)
>         int r = 1;
>         struct dm_task *dmt;
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_TARGET_MSG)))
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_TARGET_MSG)))
>                 return 1;
>
>         if (!dm_task_set_name(dmt, mapname))
> @@ -970,7 +1003,7 @@ dm_get_maps (vector mp)
>         if (!mp)
>                 return 1;
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_LIST)))
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_LIST)))
>                 return 1;
>
>         dm_task_no_open_count(dmt);
> @@ -1056,7 +1089,7 @@ dm_mapname(int major, int minor)
>         int r;
>         int loop = MAX_WAIT * LOOPS_PER_SEC;
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_STATUS)))
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_STATUS)))
>                 return NULL;
>
>         if (!dm_task_set_major(dmt, major) ||
> @@ -1109,7 +1142,7 @@ do_foreach_partmaps (const char * mapname,
>         int r = 1;
>         char *p;
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_LIST)))
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_LIST)))
>                 return 1;
>
>         dm_task_no_open_count(dmt);
> @@ -1333,7 +1366,7 @@ dm_rename (const char * old, char * new, char
> *delim, int skip_kpartx)
>         if (dm_rename_partmaps(old, new, delim))
>                 return r;
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_RENAME)))
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_RENAME)))
>                 return r;
>
>         if (!dm_task_set_name(dmt, old))
> @@ -1382,7 +1415,7 @@ int dm_reassign_table(const char *name, char *old,
> char *new)
>         char *buff;
>         void *next = NULL;
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_TABLE)))
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
>                 return 0;
>
>         if (!dm_task_set_name(dmt, name))
> @@ -1392,7 +1425,7 @@ int dm_reassign_table(const char *name, char *old,
> char *new)
>
>         if (!dm_task_run(dmt))
>                 goto out;
> -       if (!(reload_dmt = dm_task_create(DM_DEVICE_RELOAD)))
> +       if (!(reload_dmt = libmp_dm_task_create(DM_DEVICE_RELOAD)))
>                 goto out;
>         if (!dm_task_set_name(reload_dmt, name))
>                 goto out_reload;
> @@ -1456,7 +1489,7 @@ int dm_reassign(const char *mapname)
>                 return 1;
>         }
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_DEPS))) {
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_DEPS))) {
>                 condlog(3, "%s: couldn't make dm task", mapname);
>                 return 0;
>         }
> @@ -1514,7 +1547,7 @@ int dm_setgeometry(struct multipath *mpp)
>                 return 1;
>         }
>
> -       if (!(dmt = dm_task_create(DM_DEVICE_SET_GEOMETRY)))
> +       if (!(dmt = libmp_dm_task_create(DM_DEVICE_SET_GEOMETRY)))
>                 return 0;
>
>         if (!dm_task_set_name(dmt, mpp->alias))
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index fa739bcc..99a554b5 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -25,7 +25,9 @@
>  #endif
>
>  void dm_init(int verbosity);
> -int dm_prereq (void);
> +void libmp_dm_init(void);
> +void libmp_udev_set_sync_support(int on);
> +struct dm_task *libmp_dm_task_create(int task);
>  int dm_drv_version (unsigned int * version, char * str);
>  int dm_simplecmd_flush (int, const char *, uint16_t);
>  int dm_simplecmd_noflush (int, const char *, uint16_t);
> diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
> index 995ea1ad..cb9708b2 100644
> --- a/libmultipath/waiter.c
> +++ b/libmultipath/waiter.c
> @@ -76,7 +76,7 @@ static int waiteventloop (struct event_thread *waiter)
>         if (!waiter->event_nr)
>                 waiter->event_nr = dm_geteventnr(waiter->mapname);
>
> -       if (!(waiter->dmt = dm_task_create(DM_DEVICE_WAITEVENT))) {
> +       if (!(waiter->dmt = libmp_dm_task_create(DM_DEVICE_WAITEVENT))) {
>                 condlog(0, "%s: devmap event #%i dm_task_create error",
>                                 waiter->mapname, waiter->event_nr);
>                 return 1;
> diff --git a/multipath/main.c b/multipath/main.c
> index 4174d43d..dede017e 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -634,12 +634,6 @@ main (int argc, char *argv[])
>                 exit(1);
>         }
>
> -       dm_init(conf->verbosity);
> -       if (dm_prereq())
> -               exit(1);
> -       dm_drv_version(conf->version, TGT_MPATH);
> -       dm_udev_set_sync_support(1);
> -
>         if (optind < argc) {
>                 dev = MALLOC(FILE_NAME_SIZE);
>
> @@ -670,6 +664,8 @@ main (int argc, char *argv[])
>                                 conf->max_fds, strerror(errno));
>         }
>
> +       libmp_udev_set_sync_support(1);
> +
>         if (init_checkers(conf->multipath_dir)) {
>                 condlog(0, "failed to initialize checkers");
>                 goto out;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 81c76cab..4be2c579 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2408,8 +2408,6 @@ child (void * param)
>                 conf->ignore_new_devs = ignore_new_devs;
>         uxsock_timeout = conf->uxsock_timeout;
>         rcu_assign_pointer(multipath_conf, conf);
> -       dm_init(conf->verbosity);
> -       dm_drv_version(conf->version, TGT_MPATH);
>         if (init_checkers(conf->multipath_dir)) {
>                 condlog(0, "failed to initialize checkers");
>                 goto failed;
> @@ -2458,7 +2456,6 @@ child (void * param)
>         setscheduler();
>         set_oom_adj();
>
> -       dm_udev_set_sync_support(0);
>  #ifdef USE_SYSTEMD
>         envp = getenv("WATCHDOG_USEC");
>         if (envp && sscanf(envp, "%lu", &checkint) == 1) {
> @@ -2700,6 +2697,7 @@ main (int argc, char *argv[])
>         pthread_cond_init_mono(&config_cond);
>
>         udev = udev_new();
> +       libmp_udev_set_sync_support(0);
>
>         while ((arg = getopt(argc, argv, ":dsv:k::Bn")) != EOF ) {
>                 switch(arg) {
> --
> 2.13.0
>
>

--94eb2c095084b45648055275c695
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Tue, Jun 6, 2017 at 9:33 PM, Martin Wilck=
 <span dir=3D"ltr">&lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blank"=
>mwilck@suse.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote"=
 style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Th=
e multipath command fails early if libdevmapper and/or the<br>
dm_multipath driver are not found. But some multipath operations<br>
don&#39;t require device mapper, notably the path checking operations<br>
called from udev rules during early boot.<br>
<br>
This patch delays dm initialization until the first device-mapper<br>
call, allowing such operations to succeed even if the dm_multipath<br>
driver is not loaded yet.<br>
<br>
This fixes the following problem: during system boot, the dm_multipath<br>
driver is usually loaded via &quot;ExecStartPre&quot; from the multipathd s=
ervice<br>
file. But with commit d7188fcd, this service is started only after<br>
udev settle and thus the modules are loaded too late for udev<br>
rule processing, causing &quot;multipath&quot; invocations from udev rules =
to fail<br>
and paths to be wrongly classified as non-multipath.<br>
<br>
Fixes: d7188fcd &quot;multipathd: start daemon after udev trigger&quot;<br>
Signed-off-by: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@s=
use.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/devmapper.c | 79 ++++++++++++++++++++++++++++++<wbr>++++=
--------------<br>
=C2=A0libmultipath/devmapper.h |=C2=A0 4 ++-<br>
=C2=A0libmultipath/waiter.c=C2=A0 =C2=A0 |=C2=A0 2 +-<br>
=C2=A0multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 8 ++---<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 4 +--<br>
=C2=A05 files changed, 63 insertions(+), 34 deletions(-)<br>
<br>
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c<br>
index 69b634bf..4319b381 100644<br>
--- a/libmultipath/devmapper.c<br>
+++ b/libmultipath/devmapper.c<br>
@@ -21,6 +21,7 @@<br>
=C2=A0#include &quot;memory.h&quot;<br>
=C2=A0#include &quot;devmapper.h&quot;<br>
=C2=A0#include &quot;sysfs.h&quot;<br>
+#include &quot;config.h&quot;<br>
<br>
=C2=A0#include &quot;log_pthread.h&quot;<br>
=C2=A0#include &lt;sys/types.h&gt;<br>
@@ -178,7 +179,7 @@ out:<br>
=C2=A0}<br>
<br>
=C2=A0static int<br>
-dm_drv_prereq (void)<br>
+dm_drv_prereq (unsigned int *ver)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int minv[3] =3D {1, 0, 3};<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int version[3] =3D {0, 0, 0};<br>
@@ -193,19 +194,51 @@ dm_drv_prereq (void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;DM multipath kernel driver v%u=
.%u.%u&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 v[0], v[1], v[2]);<=
br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if VERSION_GE(v, minv)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (VERSION_GE(v, minv)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ver[0] =3D v[0];<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ver[1] =3D v[1];<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ver[2] =3D v[2];<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(0, &quot;DM multipath kernel driver mus=
t be &gt;=3D v%u.%u.%u&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 minv[0], minv[1], m=
inv[2]);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0}<br>
<br>
-int dm_prereq(void)<br>
+static int dm_prereq(unsigned int *v)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dm_lib_prereq())<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return dm_drv_prereq();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return dm_drv_prereq(v);<br>
+}<br>
+<br>
+static int libmp_dm_udev_sync =3D 0;<br>
+<br>
+void libmp_udev_set_sync_support(<wbr>int on)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0libmp_dm_udev_sync =3D !!on;<br>
+}<br>
+<br>
+void libmp_dm_init(void)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct config *conf;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_init(conf-&gt;verbosity);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (dm_prereq(conf-&gt;version))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit(1);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_udev_set_sync_support(<wbr>libmp_dm_udev_syn=
c);<br>
+}<br>
+<br>
+struct dm_task*<br>
+libmp_dm_task_create(int task)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0static pthread_once_t dm_initialized =3D PTHREA=
D_ONCE_INIT;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_once(&amp;dm_initialized, libmp_dm_init=
);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return dm_task_create(task);<br>
=C2=A0}<br>
<br>
=C2=A0#define do_deferred(x) ((x) =3D=3D DEFERRED_REMOVE_ON || (x) =3D=3D D=
EFERRED_REMOVE_IN_PROGRESS)<br>
@@ -219,7 +252,7 @@ dm_simplecmd (int task, const char *name, int no_flush,=
 int need_sync, uint16_t<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uint32_t cookie =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_task *dmt;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create (task)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create (task)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_name (dmt, name))<br>
@@ -274,7 +307,7 @@ dm_addmap (int task, const char *target, struct multipa=
th *mpp,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uint32_t cookie =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uint16_t udev_flags =3D DM_UDEV_DISABLE_LIBRARY=
_<wbr>FALLBACK | ((skip_kpartx =3D=3D SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX=
_FLAG : 0);<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create (task)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create (task)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_name (dmt, mpp-&gt;alias))<br>
@@ -411,7 +444,7 @@ do_get_info(const char *name, struct dm_info *info)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D -1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_task *dmt;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_INFO)<wb=
r>))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_INFO)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_name(dmt, name))<br>
@@ -449,7 +482,7 @@ int dm_get_map(const char *name, unsigned long long *si=
ze, char *outparams)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *target_type =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *params =3D NULL;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_<wbr>TAB=
LE)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_TABLE)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_name(dmt, name))<br>
@@ -485,7 +518,7 @@ dm_get_prefixed_uuid(const char *name, char *uuid)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 const char *uuidtmp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 1;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dmt =3D dm_task_create(DM_DEVICE_INFO)<wbr>;<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dmt =3D libmp_dm_task_create(DM_<wbr>DEVICE_INF=
O);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dmt)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
@@ -548,7 +581,7 @@ int dm_get_status(char *name, char *outstatus)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *target_type =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *status =3D NULL;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_<wbr>STA=
TUS)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_STATUS)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_name(dmt, name))<br>
@@ -591,7 +624,7 @@ int dm_type(const char *name, char *type)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *target_type =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *params;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_<wbr>TAB=
LE)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_TABLE)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_name(dmt, name))<br>
@@ -627,7 +660,7 @@ int dm_is_mpath(const char *name)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *params;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 const char *uuid;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_<wbr>TAB=
LE)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_TABLE)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_name(dmt, name))<br>
@@ -679,7 +712,7 @@ dm_get_opencount (const char * mapname)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_task *dmt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_info info;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_INFO)<wb=
r>))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_INFO)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_name(dmt, mapname))<br>
@@ -837,7 +870,7 @@ int dm_flush_maps (int retries)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_names *names;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned next =3D 0;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create (DM_DEVICE_LIST)))=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create (DM_DEVICE_L=
IST)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_task_no_open_count(dmt);<br>
@@ -868,7 +901,7 @@ dm_message(const char * mapname, char * message)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_task *dmt;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_<wbr>TAR=
GET_MSG)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_TARGET_MSG)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_name(dmt, mapname))<br>
@@ -970,7 +1003,7 @@ dm_get_maps (vector mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_LIST)<wb=
r>))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_LIST)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_task_no_open_count(dmt);<br>
@@ -1056,7 +1089,7 @@ dm_mapname(int major, int minor)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int loop =3D MAX_WAIT * LOOPS_PER_SEC;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_<wbr>STA=
TUS)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_STATUS)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_major(dmt, major) ||<br>
@@ -1109,7 +1142,7 @@ do_foreach_partmaps (const char * mapname,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *p;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_LIST)<wb=
r>))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_LIST)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_task_no_open_count(dmt);<br>
@@ -1333,7 +1366,7 @@ dm_rename (const char * old, char * new, char *delim,=
 int skip_kpartx)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dm_rename_partmaps(old, new, delim))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_<wbr>REN=
AME)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_RENAME)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_name(dmt, old))<br>
@@ -1382,7 +1415,7 @@ int dm_reassign_table(const char *name, char *old, ch=
ar *new)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *buff;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 void *next =3D NULL;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_<wbr>TAB=
LE)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_TABLE)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_name(dmt, name))<br>
@@ -1392,7 +1425,7 @@ int dm_reassign_table(const char *name, char *old, ch=
ar *new)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_run(dmt))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(reload_dmt =3D dm_task_create(DM_DEVICE_<=
wbr>RELOAD)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(reload_dmt =3D libmp_dm_task_create(DM_<w=
br>DEVICE_RELOAD)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_name(reload_dmt, name))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_reload;<br=
>
@@ -1456,7 +1489,7 @@ int dm_reassign(const char *mapname)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_DEPS)<wb=
r>)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_DEPS))) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s=
: couldn&#39;t make dm task&quot;, mapname);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
@@ -1514,7 +1547,7 @@ int dm_setgeometry(struct multipath *mpp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_SET_<wbr=
>GEOMETRY)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D libmp_dm_task_create(DM_<wbr>DEVI=
CE_SET_GEOMETRY)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_set_name(dmt, mpp-&gt;alias))<br>
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h<br>
index fa739bcc..99a554b5 100644<br>
--- a/libmultipath/devmapper.h<br>
+++ b/libmultipath/devmapper.h<br>
@@ -25,7 +25,9 @@<br>
=C2=A0#endif<br>
<br>
=C2=A0void dm_init(int verbosity);<br>
-int dm_prereq (void);<br>
+void libmp_dm_init(void);<br>
+void libmp_udev_set_sync_support(<wbr>int on);<br>
+struct dm_task *libmp_dm_task_create(int task);<br>
=C2=A0int dm_drv_version (unsigned int * version, char * str);<br>
=C2=A0int dm_simplecmd_flush (int, const char *, uint16_t);<br>
=C2=A0int dm_simplecmd_noflush (int, const char *, uint16_t);<br>
diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c<br>
index 995ea1ad..cb9708b2 100644<br>
--- a/libmultipath/waiter.c<br>
+++ b/libmultipath/waiter.c<br>
@@ -76,7 +76,7 @@ static int waiteventloop (struct event_thread *waiter)<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!waiter-&gt;event_nr)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 waiter-&gt;event_nr=
 =3D dm_geteventnr(waiter-&gt;mapname)<wbr>;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(waiter-&gt;dmt =3D dm_task_create(DM_DEVI=
CE_<wbr>WAITEVENT))) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(waiter-&gt;dmt =3D libmp_dm_task_create(D=
M_<wbr>DEVICE_WAITEVENT))) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(0, &quot;%s=
: devmap event #%i dm_task_create error&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 waiter-&gt;mapname, waiter-&gt;event=
_nr);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
diff --git a/multipath/main.c b/multipath/main.c<br>
index 4174d43d..dede017e 100644<br>
--- a/multipath/main.c<br>
+++ b/multipath/main.c<br>
@@ -634,12 +634,6 @@ main (int argc, char *argv[])<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_init(conf-&gt;verbosity);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (dm_prereq())<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit(1);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_drv_version(conf-&gt;version, TGT_MPATH);<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_udev_set_sync_support(1);<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (optind &lt; argc) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dev =3D MALLOC(FILE=
_NAME_SIZE);<br>
<br>
@@ -670,6 +664,8 @@ main (int argc, char *argv[])<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;max_fds, strerror(errno));<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0libmp_udev_set_sync_support(1)<wbr>;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (init_checkers(conf-&gt;<wbr>multipath_dir))=
 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(0, &quot;fa=
iled to initialize checkers&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 81c76cab..4be2c579 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -2408,8 +2408,6 @@ child (void * param)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;ignore_new=
_devs =3D ignore_new_devs;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uxsock_timeout =3D conf-&gt;uxsock_timeout;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rcu_assign_pointer(multipath_<wbr>conf, conf);<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_init(conf-&gt;verbosity);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_drv_version(conf-&gt;version, TGT_MPATH);<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (init_checkers(conf-&gt;<wbr>multipath_dir))=
 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(0, &quot;fa=
iled to initialize checkers&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto failed;<br>
@@ -2458,7 +2456,6 @@ child (void * param)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 setscheduler();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 set_oom_adj();<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_udev_set_sync_support(0);<br>
=C2=A0#ifdef USE_SYSTEMD<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 envp =3D getenv(&quot;WATCHDOG_USEC&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (envp &amp;&amp; sscanf(envp, &quot;%lu&quot=
;, &amp;checkint) =3D=3D 1) {<br>
@@ -2700,6 +2697,7 @@ main (int argc, char *argv[])<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_cond_init_mono(&amp;<wbr>config_cond);<=
br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 udev =3D udev_new();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0libmp_udev_set_sync_support(0)<wbr>;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 while ((arg =3D getopt(argc, argv, &quot;:dsv:k=
::Bn&quot;)) !=3D EOF ) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch(arg) {<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.13.0<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c095084b45648055275c695--


--===============4712110298980686384==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4712110298980686384==--
