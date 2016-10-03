From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 2/2] multipathd,
 libmultipathd: Make delays independent of clock jumps
Date: Mon, 3 Oct 2016 13:55:11 +0200
Message-ID: <CABr-GndHANoDQrriUkZEnAKw+xr=W9MPk=AgrQX=G323+ZBv0A@mail.gmail.com>
References: <55a58c33-1edb-548d-f68b-d25cea442650@sandisk.com>
	<8a70d61e-cdb8-858b-eaec-6bf557412cc8@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7268680632655171336=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8a70d61e-cdb8-858b-eaec-6bf557412cc8@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

--===============7268680632655171336==
Content-Type: multipart/alternative; boundary=001a114b10bac49fe3053df49d5e

--001a114b10bac49fe3053df49d5e
Content-Type: text/plain; charset=UTF-8

Hi Bart,

This patch seems to depend on another patch flagging tur.c some function
static.
It seems I missed this patch. Is it tanked in your tree, and you want to
post it for inclusion ? Or do you prefer to rebase this "clock jump" patch ?

Best regards,
Christophe Varoqui
OpenSVC

On Thu, Sep 29, 2016 at 11:29 PM, Bart Van Assche <
bart.vanassche@sandisk.com> wrote:

> Time synchronization software like ntpd can adjust the clock
> forwards and backwards. Avoid that the duration of a delay is
> influenced by clock jumps initiated by time synchronization
> software.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Mike Christie <mchristi@redhat.com>
> ---
>  libmultipath/Makefile       |  2 +-
>  libmultipath/checkers/rbd.c | 12 +++++-------
>  libmultipath/checkers/tur.c | 20 +++++++++-----------
>  libmultipath/time-util.c    | 42 ++++++++++++++++++++++++++++++
> ++++++++++++
>  libmultipath/time-util.h    | 13 +++++++++++++
>  multipathd/cli.c            |  6 ++----
>  multipathd/main.c           | 39 +++++++++++++++++++++++----------------
>  multipathd/uxlsnr.c         | 19 +++++++++++--------
>  8 files changed, 106 insertions(+), 47 deletions(-)
>  create mode 100644 libmultipath/time-util.c
>  create mode 100644 libmultipath/time-util.h
>
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index 92f130c..495cebe 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -47,7 +47,7 @@ endif
>  OBJS = memory.o parser.o vector.o devmapper.o callout.o \
>         hwtable.o blacklist.o util.o dmparser.o config.o \
>         structs.o discovery.o propsel.o dict.o \
> -       pgpolicies.o debug.o defaults.o uevent.o \
> +       pgpolicies.o debug.o defaults.o uevent.o time-util.o \
>         switchgroup.o uxsock.o print.o alias.o log_pthread.o \
>         log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
>         lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o
> diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
> index 41259c3..bfec2c9 100644
> --- a/libmultipath/checkers/rbd.c
> +++ b/libmultipath/checkers/rbd.c
> @@ -27,6 +27,7 @@
>
>  #include "../libmultipath/debug.h"
>  #include "../libmultipath/uevent.h"
> +#include "../libmultipath/time-util.h"
>
>  struct rbd_checker_context;
>  typedef int (thread_fn)(struct rbd_checker_context *ct, char *msg);
> @@ -75,7 +76,7 @@ int libcheck_init(struct checker * c)
>                 return 1;
>         memset(ct, 0, sizeof(struct rbd_checker_context));
>         ct->holders = 1;
> -       pthread_cond_init(&ct->active, NULL);
> +       pthread_cond_init_mono(&ct->active);
>         pthread_mutex_init(&ct->lock, NULL);
>         pthread_spin_init(&ct->hldr_lock, PTHREAD_PROCESS_PRIVATE);
>         c->context = ct;
> @@ -538,12 +539,9 @@ static void *rbd_thread(void *ctx)
>
>  static void rbd_timeout(struct timespec *tsp)
>  {
> -       struct timeval now;
> -
> -       gettimeofday(&now, NULL);
> -       tsp->tv_sec = now.tv_sec;
> -       tsp->tv_nsec = now.tv_usec * 1000;
> -       tsp->tv_nsec += 1000000; /* 1 millisecond */
> +       clock_gettime(CLOCK_MONOTONIC, tsp);
> +       tsp->tv_nsec += 1000 * 1000; /* 1 millisecond */
> +       normalize_timespec(tsp);
>  }
>
>  static int rbd_exec_fn(struct checker *c, thread_fn *fn)
> diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> index 94e4190..ac272d4 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -20,6 +20,7 @@
>  #include "../libmultipath/debug.h"
>  #include "../libmultipath/sg_include.h"
>  #include "../libmultipath/uevent.h"
> +#include "../libmultipath/time-util.h"
>
>  #define TUR_CMD_LEN 6
>  #define HEAVY_CHECK_COUNT       10
> @@ -60,7 +61,7 @@ int libcheck_init (struct checker * c)
>         ct->state = PATH_UNCHECKED;
>         ct->fd = -1;
>         ct->holders = 1;
> -       pthread_cond_init(&ct->active, NULL);
> +       pthread_cond_init_mono(&ct->active);
>         pthread_mutex_init(&ct->lock, NULL);
>         pthread_spin_init(&ct->hldr_lock, PTHREAD_PROCESS_PRIVATE);
>         c->context = ct;
> @@ -237,29 +238,26 @@ static void *tur_thread(void *ctx)
>
>  static void tur_timeout(struct timespec *tsp)
>  {
> -       struct timeval now;
> -
> -       gettimeofday(&now, NULL);
> -       tsp->tv_sec = now.tv_sec;
> -       tsp->tv_nsec = now.tv_usec * 1000;
> -       tsp->tv_nsec += 1000000; /* 1 millisecond */
> +       clock_gettime(CLOCK_MONOTONIC, tsp);
> +       tsp->tv_nsec += 1000 * 1000; /* 1 millisecond */
> +       normalize_timespec(tsp);
>  }
>
>  static void tur_set_async_timeout(struct checker *c)
>  {
>         struct tur_checker_context *ct = c->context;
> -       struct timeval now;
> +       struct timespec now;
>
> -       gettimeofday(&now, NULL);
> +       clock_gettime(CLOCK_MONOTONIC, &now);
>         ct->time = now.tv_sec + c->timeout;
>  }
>
>  static int tur_check_async_timeout(struct checker *c)
>  {
>         struct tur_checker_context *ct = c->context;
> -       struct timeval now;
> +       struct timespec now;
>
> -       gettimeofday(&now, NULL);
> +       clock_gettime(CLOCK_MONOTONIC, &now);
>         return (now.tv_sec > ct->time);
>  }
>
> diff --git a/libmultipath/time-util.c b/libmultipath/time-util.c
> new file mode 100644
> index 0000000..6d79c0e
> --- /dev/null
> +++ b/libmultipath/time-util.c
> @@ -0,0 +1,42 @@
> +#include <assert.h>
> +#include <pthread.h>
> +#include <time.h>
> +#include "time-util.h"
> +
> +/* Initialize @cond as a condition variable that uses the monotonic clock
> */
> +void pthread_cond_init_mono(pthread_cond_t *cond)
> +{
> +       pthread_condattr_t attr;
> +       int res;
> +
> +       res = pthread_condattr_init(&attr);
> +       assert(res == 0);
> +       res = pthread_condattr_setclock(&attr, CLOCK_MONOTONIC);
> +       assert(res == 0);
> +       res = pthread_cond_init(cond, &attr);
> +       assert(res == 0);
> +       res = pthread_condattr_destroy(&attr);
> +       assert(res == 0);
> +}
> +
> +/* Ensure that 0 <= ts->tv_nsec && ts->tv_nsec < 1000 * 1000 * 1000. */
> +void normalize_timespec(struct timespec *ts)
> +{
> +       while (ts->tv_nsec < 0) {
> +               ts->tv_nsec += 1000UL * 1000 * 1000;
> +               ts->tv_sec--;
> +       }
> +       while (ts->tv_nsec >= 1000UL * 1000 * 1000) {
> +               ts->tv_nsec -= 1000UL * 1000 * 1000;
> +               ts->tv_sec++;
> +       }
> +}
> +
> +/* Compute *res = *a - *b */
> +void timespecsub(const struct timespec *a, const struct timespec *b,
> +                struct timespec *res)
> +{
> +       res->tv_sec = a->tv_sec - b->tv_sec;
> +       res->tv_nsec = a->tv_nsec - b->tv_nsec;
> +       normalize_timespec(res);
> +}
> diff --git a/libmultipath/time-util.h b/libmultipath/time-util.h
> new file mode 100644
> index 0000000..b76d2aa
> --- /dev/null
> +++ b/libmultipath/time-util.h
> @@ -0,0 +1,13 @@
> +#ifndef _TIME_UTIL_H_
> +#define _TIME_UTIL_H_
> +
> +#include <pthread.h>
> +
> +struct timespec;
> +
> +void pthread_cond_init_mono(pthread_cond_t *cond);
> +void normalize_timespec(struct timespec *ts);
> +void timespecsub(const struct timespec *a, const struct timespec *b,
> +                struct timespec *res);
> +
> +#endif /* _TIME_UTIL_H_ */
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index 9a19728..e8a9384 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -454,7 +454,6 @@ parse_cmd (char * cmd, char ** reply, int * len, void
> * data, int timeout )
>         struct handler * h;
>         vector cmdvec = NULL;
>         struct timespec tmo;
> -       struct timeval now;
>
>         r = get_cmdvec(cmd, &cmdvec);
>
> @@ -476,9 +475,8 @@ parse_cmd (char * cmd, char ** reply, int * len, void
> * data, int timeout )
>         /*
>          * execute handler
>          */
> -       if (gettimeofday(&now, NULL) == 0) {
> -               tmo.tv_sec = now.tv_sec + timeout;
> -               tmo.tv_nsec = now.tv_usec * 1000;
> +       if (clock_gettime(CLOCK_MONOTONIC, &tmo) == 0) {
> +               tmo.tv_sec += timeout;
>         } else {
>                 tmo.tv_sec = 0;
>         }
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 96ef01f..76c049f 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -25,6 +25,11 @@
>  #include <time.h>
>
>  /*
> + * libmultipath
> + */
> +#include "time-util.h"
> +
> +/*
>   * libcheckers
>   */
>  #include "checkers.h"
> @@ -106,7 +111,7 @@ int ignore_new_devs;
>  enum daemon_status running_state = DAEMON_INIT;
>  pid_t daemon_pid;
>  pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
> -pthread_cond_t config_cond = PTHREAD_COND_INITIALIZER;
> +pthread_cond_t config_cond;
>
>  /*
>   * global copy of vecs for use in sig handlers
> @@ -193,7 +198,7 @@ int set_config_state(enum daemon_status state)
>                 if (running_state != DAEMON_IDLE) {
>                         struct timespec ts;
>
> -                       clock_gettime(CLOCK_REALTIME, &ts);
> +                       clock_gettime(CLOCK_MONOTONIC, &ts);
>                         ts.tv_sec += 1;
>                         rc = pthread_cond_timedwait(&config_cond,
>                                                     &config_lock, &ts);
> @@ -1744,7 +1749,7 @@ checkerloop (void *ap)
>         int count = 0;
>         unsigned int i;
>         struct itimerval timer_tick_it;
> -       struct timeval last_time;
> +       struct timespec last_time;
>         struct config *conf;
>
>         pthread_cleanup_push(rcu_unregister, NULL);
> @@ -1763,24 +1768,23 @@ checkerloop (void *ap)
>         }
>
>         /* Tweak start time for initial path check */
> -       if (gettimeofday(&last_time, NULL) != 0)
> +       if (clock_gettime(CLOCK_MONOTONIC, &last_time) != 0)
>                 last_time.tv_sec = 0;
>         else
>                 last_time.tv_sec -= 1;
>
>         while (1) {
> -               struct timeval diff_time, start_time, end_time;
> +               struct timespec diff_time, start_time, end_time;
>                 int num_paths = 0, ticks = 0, signo, strict_timing, rc = 0;
>                 sigset_t mask;
>
> -               if (gettimeofday(&start_time, NULL) != 0)
> +               if (clock_gettime(CLOCK_MONOTONIC, &start_time) != 0)
>                         start_time.tv_sec = 0;
>                 if (start_time.tv_sec && last_time.tv_sec) {
> -                       timersub(&start_time, &last_time, &diff_time);
> +                       timespecsub(&start_time, &last_time, &diff_time);
>                         condlog(4, "tick (%lu.%06lu secs)",
> -                               diff_time.tv_sec, diff_time.tv_usec);
> -                       last_time.tv_sec = start_time.tv_sec;
> -                       last_time.tv_usec = start_time.tv_usec;
> +                               diff_time.tv_sec, diff_time.tv_nsec /
> 1000);
> +                       last_time = start_time;
>                         ticks = diff_time.tv_sec;
>                 } else {
>                         ticks = 1;
> @@ -1831,16 +1835,17 @@ checkerloop (void *ap)
>                         lock_cleanup_pop(vecs->lock);
>                 }
>
> -               diff_time.tv_usec = 0;
> +               diff_time.tv_nsec = 0;
>                 if (start_time.tv_sec &&
> -                   gettimeofday(&end_time, NULL) == 0) {
> -                       timersub(&end_time, &start_time, &diff_time);
> +                   clock_gettime(CLOCK_MONOTONIC, &end_time) == 0) {
> +                       timespecsub(&end_time, &start_time, &diff_time);
>                         if (num_paths) {
>                                 unsigned int max_checkint;
>
>                                 condlog(3, "checked %d path%s in %lu.%06lu
> secs",
>                                         num_paths, num_paths > 1 ? "s" :
> "",
> -                                       diff_time.tv_sec,
> diff_time.tv_usec);
> +                                       diff_time.tv_sec,
> +                                       diff_time.tv_nsec / 1000);
>                                 conf = get_multipath_config();
>                                 max_checkint = conf->max_checkint;
>                                 put_multipath_config(conf);
> @@ -1861,10 +1866,10 @@ checkerloop (void *ap)
>                 else {
>                         timer_tick_it.it_interval.tv_sec = 0;
>                         timer_tick_it.it_interval.tv_usec = 0;
> -                       if (diff_time.tv_usec) {
> +                       if (diff_time.tv_nsec) {
>                                 timer_tick_it.it_value.tv_sec = 0;
>                                 timer_tick_it.it_value.tv_usec =
> -                                       (unsigned long)1000000 -
> diff_time.tv_usec;
> +                                    1000ULL * 1000 * 1000 -
> diff_time.tv_nsec;
>                         } else {
>                                 timer_tick_it.it_value.tv_sec = 1;
>                                 timer_tick_it.it_value.tv_usec = 0;
> @@ -2523,6 +2528,8 @@ main (int argc, char *argv[])
>                         strerror(errno));
>         umask(umask(077) | 022);
>
> +       pthread_cond_init_mono(&config_cond);
> +
>         udev = udev_new();
>
>         while ((arg = getopt(argc, argv, ":dsv:k::Bn")) != EOF ) {
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 7a9faf3..daaaa99 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -32,6 +32,7 @@
>  #include "defaults.h"
>  #include "config.h"
>  #include "mpath_cmd.h"
> +#include "time-util.h"
>
>  #include "main.h"
>  #include "cli.h"
> @@ -99,21 +100,22 @@ void free_polls (void)
>                 FREE(polls);
>  }
>
> -void check_timeout(struct timeval start_time, char *inbuf,
> +void check_timeout(struct timespec start_time, char *inbuf,
>                    unsigned int timeout)
>  {
> -       struct timeval diff_time, end_time;
> +       struct timespec diff_time, end_time;
>
> -       if (start_time.tv_sec && gettimeofday(&end_time, NULL) == 0) {
> -               timersub(&end_time, &start_time, &diff_time);
> +       if (start_time.tv_sec &&
> +           clock_gettime(CLOCK_MONOTONIC, &end_time) == 0) {
>                 unsigned long msecs;
>
> +               timespecsub(&end_time, &start_time, &diff_time);
>                 msecs = diff_time.tv_sec * 1000 +
> -                       diff_time.tv_usec / 1000;
> +                       diff_time.tv_nsec / (1000 * 1000);
>                 if (msecs > timeout)
>                         condlog(2, "cli cmd '%s' timeout reached "
>                                 "after %lu.%06lu secs", inbuf,
> -                               diff_time.tv_sec, diff_time.tv_usec);
> +                               diff_time.tv_sec, diff_time.tv_nsec /
> 1000);
>         }
>  }
>
> @@ -220,7 +222,7 @@ void * uxsock_listen(uxsock_trigger_fn
> uxsock_trigger, void * trigger_data)
>                 /* see if a client wants to speak to us */
>                 for (i = 1; i < num_clients + 1; i++) {
>                         if (polls[i].revents & POLLIN) {
> -                               struct timeval start_time;
> +                               struct timespec start_time;
>
>                                 c = NULL;
>                                 pthread_mutex_lock(&client_lock);
> @@ -236,7 +238,8 @@ void * uxsock_listen(uxsock_trigger_fn
> uxsock_trigger, void * trigger_data)
>                                                 i, polls[i].fd);
>                                         continue;
>                                 }
> -                               if (gettimeofday(&start_time, NULL) != 0)
> +                               if (clock_gettime(CLOCK_MONOTONIC,
> &start_time)
> +                                   != 0)
>                                         start_time.tv_sec = 0;
>                                 if (recv_packet(c->fd, &inbuf,
>                                                 uxsock_timeout) != 0) {
> --
> 2.10.0
>
>

--001a114b10bac49fe3053df49d5e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Bart,</div><div><br></div>This patch seems to depe=
nd on another patch flagging tur.c some function static.<div>It seems I mis=
sed this patch. Is it tanked in your tree, and you want to post it for incl=
usion ? Or do you prefer to rebase this &quot;clock jump&quot; patch ?</div=
><div><br></div><div>Best regards,</div><div>Christophe Varoqui</div><div>O=
penSVC</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote"=
>On Thu, Sep 29, 2016 at 11:29 PM, Bart Van Assche <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:bart.vanassche@sandisk.com" target=3D"_blank">bart.vanassch=
e@sandisk.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" st=
yle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Time =
synchronization software like ntpd can adjust the clock<br>
forwards and backwards. Avoid that the duration of a delay is<br>
influenced by clock jumps initiated by time synchronization<br>
software.<br>
<br>
Signed-off-by: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk=
.com">bart.vanassche@sandisk.com</a>&gt;<br>
Cc: Mike Christie &lt;<a href=3D"mailto:mchristi@redhat.com">mchristi@redha=
t.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 2 +-<br>
=C2=A0libmultipath/checkers/rbd.c | 12 +++++-------<br>
=C2=A0libmultipath/checkers/tur.c | 20 +++++++++-----------<br>
=C2=A0libmultipath/time-util.c=C2=A0 =C2=A0 | 42 ++++++++++++++++++++++++++=
++++<wbr>++++++++++++<br>
=C2=A0libmultipath/time-util.h=C2=A0 =C2=A0 | 13 +++++++++++++<br>
=C2=A0multipathd/cli.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 6 +=
+----<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 39 ++++++=
+++++++++++++++++-------<wbr>---------<br>
=C2=A0multipathd/uxlsnr.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 19 +++++++++++=
--------<br>
=C2=A08 files changed, 106 insertions(+), 47 deletions(-)<br>
=C2=A0create mode 100644 libmultipath/time-util.c<br>
=C2=A0create mode 100644 libmultipath/time-util.h<br>
<br>
diff --git a/libmultipath/Makefile b/libmultipath/Makefile<br>
index 92f130c..495cebe 100644<br>
--- a/libmultipath/Makefile<br>
+++ b/libmultipath/Makefile<br>
@@ -47,7 +47,7 @@ endif<br>
=C2=A0OBJS =3D memory.o parser.o vector.o devmapper.o callout.o \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 hwtable.o blacklist.o util.o dmparser.o config.=
o \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 structs.o discovery.o propsel.o dict.o \<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0pgpolicies.o debug.o defaults.o uevent.o \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pgpolicies.o debug.o defaults.o uevent.o time-u=
til.o \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 switchgroup.o uxsock.o print.o alias.o log_pthr=
ead.o \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 log.o configure.o structs_vec.o sysfs.o prio.o =
checkers.o \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 lock.o waiter.o file.o wwids.o prioritizers/alu=
a_rtpg.o<br>
diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c<br>
index 41259c3..bfec2c9 100644<br>
--- a/libmultipath/checkers/rbd.c<br>
+++ b/libmultipath/checkers/rbd.c<br>
@@ -27,6 +27,7 @@<br>
<br>
=C2=A0#include &quot;../libmultipath/debug.h&quot;<br>
=C2=A0#include &quot;../libmultipath/uevent.h&quot;<br>
+#include &quot;../libmultipath/time-util.h&quot;<br>
<br>
=C2=A0struct rbd_checker_context;<br>
=C2=A0typedef int (thread_fn)(struct rbd_checker_context *ct, char *msg);<b=
r>
@@ -75,7 +76,7 @@ int libcheck_init(struct checker * c)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(ct, 0, sizeof(struct rbd_checker_context=
));<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ct-&gt;holders =3D 1;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_cond_init(&amp;ct-&gt;active, NULL);<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_cond_init_mono(&amp;ct-&gt;<wbr>active)=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_mutex_init(&amp;ct-&gt;lock, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_spin_init(&amp;ct-&gt;hldr_<wbr>lock, P=
THREAD_PROCESS_PRIVATE);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 c-&gt;context =3D ct;<br>
@@ -538,12 +539,9 @@ static void *rbd_thread(void *ctx)<br>
<br>
=C2=A0static void rbd_timeout(struct timespec *tsp)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct timeval now;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0gettimeofday(&amp;now, NULL);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0tsp-&gt;tv_sec =3D now.tv_sec;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0tsp-&gt;tv_nsec =3D now.tv_usec * 1000;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0tsp-&gt;tv_nsec +=3D 1000000; /* 1 millisecond =
*/<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0clock_gettime(CLOCK_MONOTONIC, tsp);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0tsp-&gt;tv_nsec +=3D 1000 * 1000; /* 1 millisec=
ond */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0normalize_timespec(tsp);<br>
=C2=A0}<br>
<br>
=C2=A0static int rbd_exec_fn(struct checker *c, thread_fn *fn)<br>
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c<br>
index 94e4190..ac272d4 100644<br>
--- a/libmultipath/checkers/tur.c<br>
+++ b/libmultipath/checkers/tur.c<br>
@@ -20,6 +20,7 @@<br>
=C2=A0#include &quot;../libmultipath/debug.h&quot;<br>
=C2=A0#include &quot;../libmultipath/sg_include.h&quot;<br>
=C2=A0#include &quot;../libmultipath/uevent.h&quot;<br>
+#include &quot;../libmultipath/time-util.h&quot;<br>
<br>
=C2=A0#define TUR_CMD_LEN 6<br>
=C2=A0#define HEAVY_CHECK_COUNT=C2=A0 =C2=A0 =C2=A0 =C2=A010<br>
@@ -60,7 +61,7 @@ int libcheck_init (struct checker * c)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ct-&gt;state =3D PATH_UNCHECKED;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ct-&gt;fd =3D -1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ct-&gt;holders =3D 1;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_cond_init(&amp;ct-&gt;active, NULL);<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_cond_init_mono(&amp;ct-&gt;<wbr>active)=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_mutex_init(&amp;ct-&gt;lock, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_spin_init(&amp;ct-&gt;hldr_<wbr>lock, P=
THREAD_PROCESS_PRIVATE);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 c-&gt;context =3D ct;<br>
@@ -237,29 +238,26 @@ static void *tur_thread(void *ctx)<br>
<br>
=C2=A0static void tur_timeout(struct timespec *tsp)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct timeval now;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0gettimeofday(&amp;now, NULL);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0tsp-&gt;tv_sec =3D now.tv_sec;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0tsp-&gt;tv_nsec =3D now.tv_usec * 1000;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0tsp-&gt;tv_nsec +=3D 1000000; /* 1 millisecond =
*/<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0clock_gettime(CLOCK_MONOTONIC, tsp);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0tsp-&gt;tv_nsec +=3D 1000 * 1000; /* 1 millisec=
ond */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0normalize_timespec(tsp);<br>
=C2=A0}<br>
<br>
=C2=A0static void tur_set_async_timeout(struct checker *c)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct tur_checker_context *ct =3D c-&gt;contex=
t;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct timeval now;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct timespec now;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0gettimeofday(&amp;now, NULL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0clock_gettime(CLOCK_MONOTONIC, &amp;now);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ct-&gt;time =3D now.tv_sec + c-&gt;timeout;<br>
=C2=A0}<br>
<br>
=C2=A0static int tur_check_async_timeout(struct checker *c)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct tur_checker_context *ct =3D c-&gt;contex=
t;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct timeval now;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct timespec now;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0gettimeofday(&amp;now, NULL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0clock_gettime(CLOCK_MONOTONIC, &amp;now);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return (now.tv_sec &gt; ct-&gt;time);<br>
=C2=A0}<br>
<br>
diff --git a/libmultipath/time-util.c b/libmultipath/time-util.c<br>
new file mode 100644<br>
index 0000000..6d79c0e<br>
--- /dev/null<br>
+++ b/libmultipath/time-util.c<br>
@@ -0,0 +1,42 @@<br>
+#include &lt;assert.h&gt;<br>
+#include &lt;pthread.h&gt;<br>
+#include &lt;time.h&gt;<br>
+#include &quot;time-util.h&quot;<br>
+<br>
+/* Initialize @cond as a condition variable that uses the monotonic clock =
*/<br>
+void pthread_cond_init_mono(<wbr>pthread_cond_t *cond)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_condattr_t attr;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int res;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0res =3D pthread_condattr_init(&amp;attr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0assert(res =3D=3D 0);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0res =3D pthread_condattr_setclock(&amp;<wbr>att=
r, CLOCK_MONOTONIC);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0assert(res =3D=3D 0);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0res =3D pthread_cond_init(cond, &amp;attr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0assert(res =3D=3D 0);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0res =3D pthread_condattr_destroy(&amp;<wbr>attr=
);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0assert(res =3D=3D 0);<br>
+}<br>
+<br>
+/* Ensure that 0 &lt;=3D ts-&gt;tv_nsec &amp;&amp; ts-&gt;tv_nsec &lt; 100=
0 * 1000 * 1000. */<br>
+void normalize_timespec(struct timespec *ts)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (ts-&gt;tv_nsec &lt; 0) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ts-&gt;tv_nsec +=3D=
 1000UL * 1000 * 1000;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ts-&gt;tv_sec--;<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (ts-&gt;tv_nsec &gt;=3D 1000UL * 1000 * 1=
000) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ts-&gt;tv_nsec -=3D=
 1000UL * 1000 * 1000;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ts-&gt;tv_sec++;<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+}<br>
+<br>
+/* Compute *res =3D *a - *b */<br>
+void timespecsub(const struct timespec *a, const struct timespec *b,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct timespec *r=
es)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0res-&gt;tv_sec =3D a-&gt;tv_sec - b-&gt;tv_sec;=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0res-&gt;tv_nsec =3D a-&gt;tv_nsec - b-&gt;tv_ns=
ec;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0normalize_timespec(res);<br>
+}<br>
diff --git a/libmultipath/time-util.h b/libmultipath/time-util.h<br>
new file mode 100644<br>
index 0000000..b76d2aa<br>
--- /dev/null<br>
+++ b/libmultipath/time-util.h<br>
@@ -0,0 +1,13 @@<br>
+#ifndef _TIME_UTIL_H_<br>
+#define _TIME_UTIL_H_<br>
+<br>
+#include &lt;pthread.h&gt;<br>
+<br>
+struct timespec;<br>
+<br>
+void pthread_cond_init_mono(<wbr>pthread_cond_t *cond);<br>
+void normalize_timespec(struct timespec *ts);<br>
+void timespecsub(const struct timespec *a, const struct timespec *b,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct timespec *r=
es);<br>
+<br>
+#endif /* _TIME_UTIL_H_ */<br>
diff --git a/multipathd/cli.c b/multipathd/cli.c<br>
index 9a19728..e8a9384 100644<br>
--- a/multipathd/cli.c<br>
+++ b/multipathd/cli.c<br>
@@ -454,7 +454,6 @@ parse_cmd (char * cmd, char ** reply, int * len, void *=
 data, int timeout )<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct handler * h;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 vector cmdvec =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct timespec tmo;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct timeval now;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D get_cmdvec(cmd, &amp;cmdvec);<br>
<br>
@@ -476,9 +475,8 @@ parse_cmd (char * cmd, char ** reply, int * len, void *=
 data, int timeout )<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* execute handler<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (gettimeofday(&amp;now, NULL) =3D=3D 0) {<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tmo.tv_sec =3D now.=
tv_sec + timeout;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tmo.tv_nsec =3D now=
.tv_usec * 1000;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (clock_gettime(CLOCK_<wbr>MONOTONIC, &amp;tm=
o) =3D=3D 0) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tmo.tv_sec +=3D tim=
eout;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tmo.tv_sec =3D 0;<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 96ef01f..76c049f 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -25,6 +25,11 @@<br>
=C2=A0#include &lt;time.h&gt;<br>
<br>
=C2=A0/*<br>
+ * libmultipath<br>
+ */<br>
+#include &quot;time-util.h&quot;<br>
+<br>
+/*<br>
=C2=A0 * libcheckers<br>
=C2=A0 */<br>
=C2=A0#include &quot;checkers.h&quot;<br>
@@ -106,7 +111,7 @@ int ignore_new_devs;<br>
=C2=A0enum daemon_status running_state =3D DAEMON_INIT;<br>
=C2=A0pid_t daemon_pid;<br>
=C2=A0pthread_mutex_t config_lock =3D PTHREAD_MUTEX_INITIALIZER;<br>
-pthread_cond_t config_cond =3D PTHREAD_COND_INITIALIZER;<br>
+pthread_cond_t config_cond;<br>
<br>
=C2=A0/*<br>
=C2=A0 * global copy of vecs for use in sig handlers<br>
@@ -193,7 +198,7 @@ int set_config_state(enum daemon_status state)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (running_state !=
=3D DAEMON_IDLE) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 struct timespec ts;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0clock_gettime(CLOCK_REALTIME, &amp;ts);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0clock_gettime(CLOCK_MONOTONIC, &amp;ts);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ts.tv_sec +=3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D pthread_cond_timedwait(&amp;<wbr>config_cond,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;config_lock, &amp;ts);<br>
@@ -1744,7 +1749,7 @@ checkerloop (void *ap)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int count =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct itimerval timer_tick_it;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct timeval last_time;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct timespec last_time;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct config *conf;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_cleanup_push(rcu_<wbr>unregister, NULL)=
;<br>
@@ -1763,24 +1768,23 @@ checkerloop (void *ap)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Tweak start time for initial path check */<b=
r>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (gettimeofday(&amp;last_time, NULL) !=3D 0)<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (clock_gettime(CLOCK_<wbr>MONOTONIC, &amp;la=
st_time) !=3D 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 last_time.tv_sec =
=3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 else<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 last_time.tv_sec -=
=3D 1;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 while (1) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct timeval diff=
_time, start_time, end_time;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct timespec dif=
f_time, start_time, end_time;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int num_paths =3D 0=
, ticks =3D 0, signo, strict_timing, rc =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sigset_t mask;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (gettimeofday(&a=
mp;start_time, NULL) !=3D 0)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (clock_gettime(C=
LOCK_<wbr>MONOTONIC, &amp;start_time) !=3D 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 start_time.tv_sec =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (start_time.tv_s=
ec &amp;&amp; last_time.tv_sec) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0timersub(&amp;start_time, &amp;last_time, &amp;diff_time);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0timespecsub(&amp;start_time, &amp;last_time, &amp;diff_time);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 condlog(4, &quot;tick (%lu.%06lu secs)&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0diff_time.tv_sec, diff_time.tv_usec);=
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0last_time.tv_sec =3D start_time.tv_sec;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0last_time.tv_usec =3D start_time.tv_usec;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0diff_time.tv_sec, diff_time.tv_nsec /=
 1000);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0last_time =3D start_time;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ticks =3D diff_time.tv_sec;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ticks =3D 1;<br>
@@ -1831,16 +1835,17 @@ checkerloop (void *ap)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 lock_cleanup_pop(vecs-&gt;lock);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0diff_time.tv_usec =
=3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0diff_time.tv_nsec =
=3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (start_time.tv_s=
ec &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0getti=
meofday(&amp;end_time, NULL) =3D=3D 0) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0timersub(&amp;end_time, &amp;start_time, &amp;diff_time);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0clock=
_gettime(CLOCK_MONOTONIC, &amp;end_time) =3D=3D 0) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0timespecsub(&amp;end_time, &amp;start_time, &amp;diff_time);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (num_paths) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int max_checkint;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;checked %d path%s i=
n %lu.%06lu secs&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 num_path=
s, num_paths &gt; 1 ? &quot;s&quot; : &quot;&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0diff_time=
.tv_sec, diff_time.tv_usec);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0diff_time=
.tv_sec,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0diff_time=
.tv_nsec / 1000);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf =3D get_multipath_config();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 max_checkint =3D conf-&gt;max_checki=
nt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 put_multipath_config(conf);<br>
@@ -1861,10 +1866,10 @@ checkerloop (void *ap)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 timer_tick_it.it_interval.tv_<wbr>sec =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 timer_tick_it.it_interval.tv_<wbr>usec =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (diff_time.tv_usec) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (diff_time.tv_nsec) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 timer_tick_it.it_value.tv_sec =3D 0;=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 timer_tick_it.it_value.tv_usec =3D<b=
r>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(unsigned=
 long)1000000 - diff_time.tv_usec;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1000ULL * 1000 * 1000 =
- diff_time.tv_nsec;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 } else {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 timer_tick_it.it_value.tv_sec =3D 1;=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 timer_tick_it.it_value.tv_usec =3D 0=
;<br>
@@ -2523,6 +2528,8 @@ main (int argc, char *argv[])<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 strerror(errno));<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 umask(umask(077) | 022);<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_cond_init_mono(&amp;<wbr>config_cond);<=
br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 udev =3D udev_new();<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 while ((arg =3D getopt(argc, argv, &quot;:dsv:k=
::Bn&quot;)) !=3D EOF ) {<br>
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c<br>
index 7a9faf3..daaaa99 100644<br>
--- a/multipathd/uxlsnr.c<br>
+++ b/multipathd/uxlsnr.c<br>
@@ -32,6 +32,7 @@<br>
=C2=A0#include &quot;defaults.h&quot;<br>
=C2=A0#include &quot;config.h&quot;<br>
=C2=A0#include &quot;mpath_cmd.h&quot;<br>
+#include &quot;time-util.h&quot;<br>
<br>
=C2=A0#include &quot;main.h&quot;<br>
=C2=A0#include &quot;cli.h&quot;<br>
@@ -99,21 +100,22 @@ void free_polls (void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(polls);<br>
=C2=A0}<br>
<br>
-void check_timeout(struct timeval start_time, char *inbuf,<br>
+void check_timeout(struct timespec start_time, char *inbuf,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsign=
ed int timeout)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct timeval diff_time, end_time;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct timespec diff_time, end_time;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (start_time.tv_sec &amp;&amp; gettimeofday(&=
amp;end_time, NULL) =3D=3D 0) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0timersub(&amp;end_t=
ime, &amp;start_time, &amp;diff_time);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (start_time.tv_sec &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0clock_gettime(CLOCK_MONOTONIC, &a=
mp;end_time) =3D=3D 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long msecs=
;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0timespecsub(&amp;en=
d_time, &amp;start_time, &amp;diff_time);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 msecs =3D diff_time=
.tv_sec * 1000 +<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0diff_time.tv_usec / 1000;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0diff_time.tv_nsec / (1000 * 1000);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (msecs &gt; time=
out)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 condlog(2, &quot;cli cmd &#39;%s&#39; timeout reached &quot;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;after %lu.%06lu secs&quot;, in=
buf,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0diff_time.tv_sec, diff_time.tv_usec);=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0diff_time.tv_sec, diff_time.tv_nsec /=
 1000);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0}<br>
<br>
@@ -220,7 +222,7 @@ void * uxsock_listen(uxsock_trigger_<wbr>fn uxsock_trig=
ger, void * trigger_data)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* see if a client =
wants to speak to us */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 1; i &lt=
; num_clients + 1; i++) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (polls[i].revents &amp; POLLIN) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct timeval start_time;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct timespec start_time;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 c =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_mutex_lock(&amp;client_<wbr>=
lock);<br>
@@ -236,7 +238,8 @@ void * uxsock_listen(uxsock_trigger_<wbr>fn uxsock_trig=
ger, void * trigger_data)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 i, polls[i].fd);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (gettimeofday(&amp;start_time, NUL=
L) !=3D 0)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (clock_gettime(CLOCK_<wbr>MONOTONI=
C, &amp;start_time)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!=3D 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 start_ti=
me.tv_sec =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (recv_packet(c-&gt;fd, &amp;inbuf=
,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 uxsock_timeout) !=3D 0) {<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.0<br>
<br>
</font></span></blockquote></div><br></div>

--001a114b10bac49fe3053df49d5e--


--===============7268680632655171336==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7268680632655171336==--
