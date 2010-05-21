From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: add "count paths"
	multipathd	command
Date: Fri, 21 May 2010 18:30:04 +0200
Message-ID: <1274459404.8014.6.camel@Nokia-N900-42-11>
References: <20100517190427.GP3295@ether.msp.redhat.com>
Reply-To: Christophe Varoqui <christophe.varoqui@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6288047486008220039=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100517190427.GP3295@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>
List-Id: dm-devel.ids


--===============6288047486008220039==
Content-Type: multipart/alternative; boundary="=-SMHcGwYsQN07uql2Hj6n"


--=-SMHcGwYsQN07uql2Hj6n
Content-Type: text/plain; charset=utf-8
Content-ID: <1274459403.8014.3.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx02.colomx.prod.int.phx2.redhat.com id o4NLksbq029723

Hi Ben,

Do you mind if I merge this output to the 'show status' command output ?

----- Message d'origine -----
> This adds a new multipathd command, "count paths". which returns inform=
ation in
> the format
>
> Paths: <nr_of_paths>
> Busy: <True|False>
>
> where "Paths" is the number of monitored paths, and "Busy" is set when
> multipathd is currently handling uevents.=C2=A0 With this, it is possib=
le to quickly
> get the number of paths being monitored, as well as an idea if more pat=
hs may
> be showing up shortly.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>=C2=A0 libmultipath/uevent.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=
=A0 8 ++++++++
>=C2=A0 libmultipath/uevent.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=
=A0 1 +
>=C2=A0 multipathd/cli.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=A0 2 ++
>=C2=A0 multipathd/cli.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=A0 2 ++
>=C2=A0 multipathd/cli_handlers.c |=C2=A0 =C2=A0 33 +++++++++++++++++++++=
++++++++++++
>=C2=A0 multipathd/cli_handlers.h |=C2=A0 =C2=A0 =C2=A0 1 +
>=C2=A0 multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 |=C2=A0 =C2=A0 =C2=A0 1 +
>=C2=A0 multipathd/multipathd.8=C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=A0 4 ++++
>=C2=A0 8 files changed, 52 insertions(+)
>
> Index: multipath-tools-100510/libmultipath/uevent.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-100510.orig/libmultipath/uevent.c
> +++ multipath-tools-100510/libmultipath/uevent.c
> @@ -52,6 +52,12 @@ pthread_mutex_t uevc_lock, *uevc_lockp =3D
>=C2=A0 pthread_cond_t=C2=A0 uev_cond,=C2=A0 *uev_condp=C2=A0 =3D &uev_co=
nd;
>=C2=A0 uev_trigger *my_uev_trigger;
>=C2=A0 void * my_trigger_data;
> +int servicing_uev;
> +
> +int is_uevent_busy(void)
> +{
> +=C2=A0=C2=A0=C2=A0 return (uevqhp !=3D NULL || servicing_uev);
> +}
>=C2=A0
>=C2=A0 static struct uevent * alloc_uevent (void)
>=C2=A0 {
> @@ -96,7 +102,9 @@ uevq_thread(void * et)
>=C2=A0
>=C2=A0 =C2=A0=C2=A0=C2=A0 while (1) {
>=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 pthread_mutex_lock(uevc_loc=
kp);
> +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 servicing_uev =3D 0;
>=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 pthread_cond_wait(uev_condp=
, uevc_lockp);
> +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 servicing_uev =3D 1;
>=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 pthread_mutex_unlock(uevc_l=
ockp);
>=C2=A0
>=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 service_uevq();
> Index: multipath-tools-100510/libmultipath/uevent.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-100510.orig/libmultipath/uevent.h
> +++ multipath-tools-100510/libmultipath/uevent.h
> @@ -17,3 +17,4 @@ struct uevent {
>=C2=A0
>=C2=A0 int uevent_listen(int (*store_uev)(struct uevent *, void * trigge=
r_data),
>=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 void * trigger_data)=
;
> +int is_uevent_busy(void);
> Index: multipath-tools-100510/multipathd/cli.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-100510.orig/multipathd/cli.c
> +++ multipath-tools-100510/multipathd/cli.c
> @@ -174,6 +174,7 @@ load_keys (void)
>=C2=A0 =C2=A0=C2=A0=C2=A0 r +=3D add_key(keys, "devices", DEVICES, 0);
>=C2=A0 =C2=A0=C2=A0=C2=A0 r +=3D add_key(keys, "format", FMT, 1);
>=C2=A0 =C2=A0=C2=A0=C2=A0 r +=3D add_key(keys, "wildcards", WILDCARDS, 0=
);
> +=C2=A0=C2=A0=C2=A0 r +=3D add_key(keys, "count", COUNT, 0);
>=C2=A0 =C2=A0=C2=A0=C2=A0 r +=3D add_key(keys, "quit", QUIT, 0);
>=C2=A0 =C2=A0=C2=A0=C2=A0 r +=3D add_key(keys, "exit", QUIT, 0);
>=C2=A0
> @@ -443,6 +444,7 @@ cli_init (void) {
>=C2=A0 =C2=A0=C2=A0=C2=A0 add_handler(RESTOREQ+MAPS, NULL);
>=C2=A0 =C2=A0=C2=A0=C2=A0 add_handler(REINSTATE+PATH, NULL);
>=C2=A0 =C2=A0=C2=A0=C2=A0 add_handler(FAIL+PATH, NULL);
> +=C2=A0=C2=A0=C2=A0 add_handler(COUNT+PATHS, NULL);
>=C2=A0 =C2=A0=C2=A0=C2=A0 add_handler(QUIT, NULL);
>=C2=A0
>=C2=A0 =C2=A0=C2=A0=C2=A0 return 0;
> Index: multipath-tools-100510/multipathd/cli_handlers.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-100510.orig/multipathd/cli_handlers.h
> +++ multipath-tools-100510/multipathd/cli_handlers.h
> @@ -25,5 +25,6 @@ int cli_restore_all_queueing(void * v, c
>=C2=A0 int cli_suspend(void * v, char ** reply, int * len, void * data);
>=C2=A0 int cli_resume(void * v, char ** reply, int * len, void * data);
>=C2=A0 int cli_reinstate(void * v, char ** reply, int * len, void * data=
);
> +int cli_count_paths(void * v, char ** reply, int * len, void * data);
>=C2=A0 int cli_fail(void * v, char ** reply, int * len, void * data);
>=C2=A0 int cli_quit(void * v, char ** reply, int * len, void * data);
> Index: multipath-tools-100510/multipathd/main.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-100510.orig/multipathd/main.c
> +++ multipath-tools-100510/multipathd/main.c
> @@ -783,6 +783,7 @@ uxlsnrloop (void * ap)
>=C2=A0 =C2=A0=C2=A0=C2=A0 set_handler_callback(RESTOREQ+MAP, cli_restore=
_queueing);
>=C2=A0 =C2=A0=C2=A0=C2=A0 set_handler_callback(DISABLEQ+MAPS, cli_disabl=
e_all_queueing);
>=C2=A0 =C2=A0=C2=A0=C2=A0 set_handler_callback(RESTOREQ+MAPS, cli_restor=
e_all_queueing);
> +=C2=A0=C2=A0=C2=A0 set_handler_callback(COUNT+PATHS, cli_count_paths);
>=C2=A0 =C2=A0=C2=A0=C2=A0 set_handler_callback(QUIT, cli_quit);
>=C2=A0
>=C2=A0 =C2=A0=C2=A0=C2=A0 umask(077);
> Index: multipath-tools-100510/multipathd/cli.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-100510.orig/multipathd/cli.h
> +++ multipath-tools-100510/multipathd/cli.h
> @@ -23,6 +23,7 @@ enum {
>=C2=A0 =C2=A0=C2=A0=C2=A0 __BLACKLIST,
>=C2=A0 =C2=A0=C2=A0=C2=A0 __DEVICES,
>=C2=A0 =C2=A0=C2=A0=C2=A0 __FMT,
> +=C2=A0=C2=A0=C2=A0 __COUNT,
>=C2=A0 =C2=A0=C2=A0=C2=A0 __WILDCARDS,
>=C2=A0 =C2=A0=C2=A0=C2=A0 __QUIT,
>=C2=A0 };
> @@ -51,6 +52,7 @@ enum {
>=C2=A0 #define BLACKLIST=C2=A0=C2=A0=C2=A0 (1 << __BLACKLIST)
>=C2=A0 #define DEVICES=C2=A0 =C2=A0=C2=A0=C2=A0 (1 << __DEVICES)
>=C2=A0 #define FMT =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 (1 << __FMT)
> +#define COUNT=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 (1 << __COUNT)
>=C2=A0 #define WILDCARDS=C2=A0=C2=A0=C2=A0 (1 << __WILDCARDS)
>=C2=A0 #define QUIT=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 (1 << __QUIT)
>=C2=A0
> Index: multipath-tools-100510/multipathd/cli_handlers.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-100510.orig/multipathd/cli_handlers.c
> +++ multipath-tools-100510/multipathd/cli_handlers.c
> @@ -18,6 +18,29 @@
>=C2=A0
>=C2=A0 #include "main.h"
>=C2=A0 #include "cli.h"
> +#include "uevent.h"
> +
> +int
> +count_paths(char=C2=A0 **r, int *l, struct vectors *vecs)
> +{
> +=C2=A0=C2=A0=C2=A0 int i, len;
> +=C2=A0=C2=A0=C2=A0 struct path *pp;
> +=C2=A0=C2=A0=C2=A0 char * reply;
> +=C2=A0=C2=A0=C2=A0 unsigned int maxlen =3D INITIAL_REPLY_LEN;
> +=C2=A0=C2=A0=C2=A0 int monitored_count =3D 0;
> +
> +=C2=A0=C2=A0=C2=A0 reply =3D MALLOC(maxlen);
> +=C2=A0=C2=A0=C2=A0 if (!reply)
> +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return 1;
> +=C2=A0=C2=A0=C2=A0 vector_foreach_slot(vecs->pathvec, pp, i)
> +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (pp->fd !=3D -1)
> +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 monitored_cou=
nt++;
> +=C2=A0=C2=A0=C2=A0 len =3D sprintf(reply, "Paths: %d\nBusy: %s\n", mon=
itored_count,
> +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 is_uevent_b=
usy()? "True" : "False");
> +=C2=A0=C2=A0=C2=A0 *r =3D reply;
> +=C2=A0=C2=A0=C2=A0 *l =3D len + 1;
> +=C2=A0=C2=A0=C2=A0 return 0;
> +}
>=C2=A0
>=C2=A0 int
>=C2=A0 show_paths (char ** r, int * len, struct vectors * vecs, char * s=
tyle)
> @@ -176,6 +199,16 @@ cli_list_config (void * v, char ** reply
>=C2=A0 }
>=C2=A0
>=C2=A0 int
> +cli_count_paths (void * v, char ** reply, int * len, void * data)
> +{
> +=C2=A0=C2=A0=C2=A0 struct vectors * vecs =3D (struct vectors *)data;
> +
> +=C2=A0=C2=A0=C2=A0 condlog(3, "count paths (operator)");
> +
> +=C2=A0=C2=A0=C2=A0 return count_paths(reply, len, vecs);
> +}
> +
> +int
>=C2=A0 cli_list_paths (void * v, char ** reply, int * len, void * data)
>=C2=A0 {
>=C2=A0 =C2=A0=C2=A0=C2=A0 struct vectors * vecs =3D (struct vectors *)da=
ta;
> Index: multipath-tools-100510/multipathd/multipathd.8
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-100510.orig/multipathd/multipathd.8
> +++ multipath-tools-100510/multipathd/multipathd.8
> @@ -69,6 +69,10 @@ Add a path to the list of monitored path
>=C2=A0 .B remove|del path $path
>=C2=A0 Stop monitoring a path. $path is as listed in /sys/block (e.g. sd=
a).
>=C2=A0 .TP
> +.B count paths
> +Show the number of monitored paths, and whether multipathd is currentl=
y
> +handling a uevent.
> +.TP
>=C2=A0 .B add map $map
>=C2=A0 Add a multipath device to the list of monitored devices. $map can=
 either be a
> device-mapper device as listed in /sys/block (e.g. dm-0) or it can be t=
he alias
> for the multipath device (e.g. mpath1) or the uid of the multipath devi=
ce (e.g.
> 36005076303ffc56200000000000010aa).=C2=A0 =C2=A0 .TP
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--=-SMHcGwYsQN07uql2Hj6n
Content-Type: text/html; charset=utf-8
Content-ID: <1274459403.8014.5.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="generator" content="Osso Notes">
    <title></title></head>
<body>
<p>Hi Ben,
<br>
<br>Do you mind if I merge this output to the 'show status' command output ?
<br>
<br>----- Message d'origine -----
<br>&gt; This adds a new multipathd command, "count paths". which returns information in
<br>&gt; the format
<br>&gt;
<br>&gt; Paths: &lt;nr_of_paths&gt;
<br>&gt; Busy: &lt;True|False&gt;
<br>&gt;
<br>&gt; where "Paths" is the number of monitored paths, and "Busy" is set when
<br>&gt; multipathd is currently handling uevents.&nbsp; With this, it is possible to quickly
<br>&gt; get the number of paths being monitored, as well as an idea if more paths may
<br>&gt; be showing up shortly.
<br>&gt;
<br>&gt; Signed-off-by: Benjamin Marzinski &lt;<a href="mailto:bmarzins@redhat.com">bmarzins@redhat.com</a>&gt;
<br>&gt; ---
<br>&gt;&nbsp; libmultipath/uevent.c&nbsp; &nbsp; &nbsp; &nbsp; |&nbsp; &nbsp; &nbsp; 8 ++++++++
<br>&gt;&nbsp; libmultipath/uevent.h&nbsp; &nbsp; &nbsp; &nbsp; |&nbsp; &nbsp; &nbsp; 1 +
<br>&gt;&nbsp; multipathd/cli.c&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |&nbsp; &nbsp; &nbsp; 2 ++
<br>&gt;&nbsp; multipathd/cli.h&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |&nbsp; &nbsp; &nbsp; 2 ++
<br>&gt;&nbsp; multipathd/cli_handlers.c |&nbsp; &nbsp; 33 +++++++++++++++++++++++++++++++++
<br>&gt;&nbsp; multipathd/cli_handlers.h |&nbsp; &nbsp; &nbsp; 1 +
<br>&gt;&nbsp; multipathd/main.c&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |&nbsp; &nbsp; &nbsp; 1 +
<br>&gt;&nbsp; multipathd/multipathd.8&nbsp; &nbsp; |&nbsp; &nbsp; &nbsp; 4 ++++
<br>&gt;&nbsp; 8 files changed, 52 insertions(+)
<br>&gt;
<br>&gt; Index: multipath-tools-100510/libmultipath/uevent.c
<br>&gt; ===================================================================
<br>&gt; --- multipath-tools-100510.orig/libmultipath/uevent.c
<br>&gt; +++ multipath-tools-100510/libmultipath/uevent.c
<br>&gt; @@ -52,6 +52,12 @@ pthread_mutex_t uevc_lock, *uevc_lockp =
<br>&gt;&nbsp; pthread_cond_t&nbsp; uev_cond,&nbsp; *uev_condp&nbsp; = &amp;uev_cond;
<br>&gt;&nbsp; uev_trigger *my_uev_trigger;
<br>&gt;&nbsp; void * my_trigger_data;
<br>&gt; +int servicing_uev;
<br>&gt; +
<br>&gt; +int is_uevent_busy(void)
<br>&gt; +{
<br>&gt; +&nbsp;&nbsp;&nbsp; return (uevqhp != NULL || servicing_uev);
<br>&gt; +}
<br>&gt;&nbsp;
<br>&gt;&nbsp; static struct uevent * alloc_uevent (void)
<br>&gt;&nbsp; {
<br>&gt; @@ -96,7 +102,9 @@ uevq_thread(void * et)
<br>&gt;&nbsp;
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; while (1) {
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; pthread_mutex_lock(uevc_lockp);
<br>&gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; servicing_uev = 0;
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; pthread_cond_wait(uev_condp, uevc_lockp);
<br>&gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; servicing_uev = 1;
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; pthread_mutex_unlock(uevc_lockp);
<br>&gt;&nbsp;
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; service_uevq();
<br>&gt; Index: multipath-tools-100510/libmultipath/uevent.h
<br>&gt; ===================================================================
<br>&gt; --- multipath-tools-100510.orig/libmultipath/uevent.h
<br>&gt; +++ multipath-tools-100510/libmultipath/uevent.h
<br>&gt; @@ -17,3 +17,4 @@ struct uevent {
<br>&gt;&nbsp;
<br>&gt;&nbsp; int uevent_listen(int (*store_uev)(struct uevent *, void * trigger_data),
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp; void * trigger_data);
<br>&gt; +int is_uevent_busy(void);
<br>&gt; Index: multipath-tools-100510/multipathd/cli.c
<br>&gt; ===================================================================
<br>&gt; --- multipath-tools-100510.orig/multipathd/cli.c
<br>&gt; +++ multipath-tools-100510/multipathd/cli.c
<br>&gt; @@ -174,6 +174,7 @@ load_keys (void)
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; r += add_key(keys, "devices", DEVICES, 0);
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; r += add_key(keys, "format", FMT, 1);
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; r += add_key(keys, "wildcards", WILDCARDS, 0);
<br>&gt; +&nbsp;&nbsp;&nbsp; r += add_key(keys, "count", COUNT, 0);
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; r += add_key(keys, "quit", QUIT, 0);
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; r += add_key(keys, "exit", QUIT, 0);
<br>&gt;&nbsp;
<br>&gt; @@ -443,6 +444,7 @@ cli_init (void) {
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; add_handler(RESTOREQ+MAPS, NULL);
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; add_handler(REINSTATE+PATH, NULL);
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; add_handler(FAIL+PATH, NULL);
<br>&gt; +&nbsp;&nbsp;&nbsp; add_handler(COUNT+PATHS, NULL);
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; add_handler(QUIT, NULL);
<br>&gt;&nbsp;
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; return 0;
<br>&gt; Index: multipath-tools-100510/multipathd/cli_handlers.h
<br>&gt; ===================================================================
<br>&gt; --- multipath-tools-100510.orig/multipathd/cli_handlers.h
<br>&gt; +++ multipath-tools-100510/multipathd/cli_handlers.h
<br>&gt; @@ -25,5 +25,6 @@ int cli_restore_all_queueing(void * v, c
<br>&gt;&nbsp; int cli_suspend(void * v, char ** reply, int * len, void * data);
<br>&gt;&nbsp; int cli_resume(void * v, char ** reply, int * len, void * data);
<br>&gt;&nbsp; int cli_reinstate(void * v, char ** reply, int * len, void * data);
<br>&gt; +int cli_count_paths(void * v, char ** reply, int * len, void * data);
<br>&gt;&nbsp; int cli_fail(void * v, char ** reply, int * len, void * data);
<br>&gt;&nbsp; int cli_quit(void * v, char ** reply, int * len, void * data);
<br>&gt; Index: multipath-tools-100510/multipathd/main.c
<br>&gt; ===================================================================
<br>&gt; --- multipath-tools-100510.orig/multipathd/main.c
<br>&gt; +++ multipath-tools-100510/multipathd/main.c
<br>&gt; @@ -783,6 +783,7 @@ uxlsnrloop (void * ap)
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; set_handler_callback(RESTOREQ+MAP, cli_restore_queueing);
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; set_handler_callback(DISABLEQ+MAPS, cli_disable_all_queueing);
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; set_handler_callback(RESTOREQ+MAPS, cli_restore_all_queueing);
<br>&gt; +&nbsp;&nbsp;&nbsp; set_handler_callback(COUNT+PATHS, cli_count_paths);
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; set_handler_callback(QUIT, cli_quit);
<br>&gt;&nbsp;
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; umask(077);
<br>&gt; Index: multipath-tools-100510/multipathd/cli.h
<br>&gt; ===================================================================
<br>&gt; --- multipath-tools-100510.orig/multipathd/cli.h
<br>&gt; +++ multipath-tools-100510/multipathd/cli.h
<br>&gt; @@ -23,6 +23,7 @@ enum {
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; __BLACKLIST,
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; __DEVICES,
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; __FMT,
<br>&gt; +&nbsp;&nbsp;&nbsp; __COUNT,
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; __WILDCARDS,
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; __QUIT,
<br>&gt;&nbsp; };
<br>&gt; @@ -51,6 +52,7 @@ enum {
<br>&gt;&nbsp; #define BLACKLIST&nbsp;&nbsp;&nbsp; (1 &lt;&lt; __BLACKLIST)
<br>&gt;&nbsp; #define DEVICES&nbsp; &nbsp;&nbsp;&nbsp; (1 &lt;&lt; __DEVICES)
<br>&gt;&nbsp; #define FMT &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; (1 &lt;&lt; __FMT)
<br>&gt; +#define COUNT&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; (1 &lt;&lt; __COUNT)
<br>&gt;&nbsp; #define WILDCARDS&nbsp;&nbsp;&nbsp; (1 &lt;&lt; __WILDCARDS)
<br>&gt;&nbsp; #define QUIT&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; (1 &lt;&lt; __QUIT)
<br>&gt;&nbsp;
<br>&gt; Index: multipath-tools-100510/multipathd/cli_handlers.c
<br>&gt; ===================================================================
<br>&gt; --- multipath-tools-100510.orig/multipathd/cli_handlers.c
<br>&gt; +++ multipath-tools-100510/multipathd/cli_handlers.c
<br>&gt; @@ -18,6 +18,29 @@
<br>&gt;&nbsp;
<br>&gt;&nbsp; #include "main.h"
<br>&gt;&nbsp; #include "cli.h"
<br>&gt; +#include "uevent.h"
<br>&gt; +
<br>&gt; +int
<br>&gt; +count_paths(char&nbsp; **r, int *l, struct vectors *vecs)
<br>&gt; +{
<br>&gt; +&nbsp;&nbsp;&nbsp; int i, len;
<br>&gt; +&nbsp;&nbsp;&nbsp; struct path *pp;
<br>&gt; +&nbsp;&nbsp;&nbsp; char * reply;
<br>&gt; +&nbsp;&nbsp;&nbsp; unsigned int maxlen = INITIAL_REPLY_LEN;
<br>&gt; +&nbsp;&nbsp;&nbsp; int monitored_count = 0;
<br>&gt; +
<br>&gt; +&nbsp;&nbsp;&nbsp; reply = MALLOC(maxlen);
<br>&gt; +&nbsp;&nbsp;&nbsp; if (!reply)
<br>&gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; return 1;
<br>&gt; +&nbsp;&nbsp;&nbsp; vector_foreach_slot(vecs-&gt;pathvec, pp, i)
<br>&gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (pp-&gt;fd != -1)
<br>&gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; monitored_count++;
<br>&gt; +&nbsp;&nbsp;&nbsp; len = sprintf(reply, "Paths: %d\nBusy: %s\n", monitored_count,
<br>&gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; is_uevent_busy()? "True" : "False");
<br>&gt; +&nbsp;&nbsp;&nbsp; *r = reply;
<br>&gt; +&nbsp;&nbsp;&nbsp; *l = len + 1;
<br>&gt; +&nbsp;&nbsp;&nbsp; return 0;
<br>&gt; +}
<br>&gt;&nbsp;
<br>&gt;&nbsp; int
<br>&gt;&nbsp; show_paths (char ** r, int * len, struct vectors * vecs, char * style)
<br>&gt; @@ -176,6 +199,16 @@ cli_list_config (void * v, char ** reply
<br>&gt;&nbsp; }
<br>&gt;&nbsp;
<br>&gt;&nbsp; int
<br>&gt; +cli_count_paths (void * v, char ** reply, int * len, void * data)
<br>&gt; +{
<br>&gt; +&nbsp;&nbsp;&nbsp; struct vectors * vecs = (struct vectors *)data;
<br>&gt; +
<br>&gt; +&nbsp;&nbsp;&nbsp; condlog(3, "count paths (operator)");
<br>&gt; +
<br>&gt; +&nbsp;&nbsp;&nbsp; return count_paths(reply, len, vecs);
<br>&gt; +}
<br>&gt; +
<br>&gt; +int
<br>&gt;&nbsp; cli_list_paths (void * v, char ** reply, int * len, void * data)
<br>&gt;&nbsp; {
<br>&gt;&nbsp; &nbsp;&nbsp;&nbsp; struct vectors * vecs = (struct vectors *)data;
<br>&gt; Index: multipath-tools-100510/multipathd/multipathd.8
<br>&gt; ===================================================================
<br>&gt; --- multipath-tools-100510.orig/multipathd/multipathd.8
<br>&gt; +++ multipath-tools-100510/multipathd/multipathd.8
<br>&gt; @@ -69,6 +69,10 @@ Add a path to the list of monitored path
<br>&gt;&nbsp; .B remove|del path $path
<br>&gt;&nbsp; Stop monitoring a path. $path is as listed in /sys/block (e.g. sda).
<br>&gt;&nbsp; .TP
<br>&gt; +.B count paths
<br>&gt; +Show the number of monitored paths, and whether multipathd is currently
<br>&gt; +handling a uevent.
<br>&gt; +.TP
<br>&gt;&nbsp; .B add map $map
<br>&gt;&nbsp; Add a multipath device to the list of monitored devices. $map can either be a
<br>&gt; device-mapper device as listed in /sys/block (e.g. dm-0) or it can be the alias
<br>&gt; for the multipath device (e.g. mpath1) or the uid of the multipath device (e.g.
<br>&gt; 36005076303ffc56200000000000010aa).&nbsp; &nbsp; .TP
<br>&gt;
<br>&gt; --
<br>&gt; dm-devel mailing list
<br>&gt; <a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<br>&gt; <a href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a>
<br><br></p>
</body>
</html>

--=-SMHcGwYsQN07uql2Hj6n--


--===============6288047486008220039==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============6288047486008220039==--
