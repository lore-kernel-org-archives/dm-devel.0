From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath: add "count paths"
	multipathd	command
Date: Mon, 24 May 2010 10:13:46 -0500
Message-ID: <20100524151345.GW3295@ether.msp.redhat.com>
References: <20100517190427.GP3295@ether.msp.redhat.com>
	<1274459404.8014.6.camel@Nokia-N900-42-11>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1274459404.8014.6.camel@Nokia-N900-42-11>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, May 21, 2010 at 06:30:04PM +0200, Christophe Varoqui wrote:
>    Hi Ben,
> 
>    Do you mind if I merge this output to the 'show status' command output ?

That's fine with me.

-Ben

> 
>    ----- Message d'origine -----
>    > This adds a new multipathd command, "count paths". which returns
>    information in
>    > the format
>    >
>    > Paths: <nr_of_paths>
>    > Busy: <True|False>
>    >
>    > where "Paths" is the number of monitored paths, and "Busy" is set when
>    > multipathd is currently handling uevents.  With this, it is possible to
>    quickly
>    > get the number of paths being monitored, as well as an idea if more
>    paths may
>    > be showing up shortly.
>    >
>    > Signed-off-by: Benjamin Marzinski <[1]bmarzins@redhat.com>
>    > ---
>    >  libmultipath/uevent.c        |      8 ++++++++
>    >  libmultipath/uevent.h        |      1 +
>    >  multipathd/cli.c                  |      2 ++
>    >  multipathd/cli.h                  |      2 ++
>    >  multipathd/cli_handlers.c |    33 +++++++++++++++++++++++++++++++++
>    >  multipathd/cli_handlers.h |      1 +
>    >  multipathd/main.c                |      1 +
>    >  multipathd/multipathd.8    |      4 ++++
>    >  8 files changed, 52 insertions(+)
>    >
>    > Index: multipath-tools-100510/libmultipath/uevent.c
>    > ===================================================================
>    > --- multipath-tools-100510.orig/libmultipath/uevent.c
>    > +++ multipath-tools-100510/libmultipath/uevent.c
>    > @@ -52,6 +52,12 @@ pthread_mutex_t uevc_lock, *uevc_lockp =
>    >  pthread_cond_t  uev_cond,  *uev_condp  = &uev_cond;
>    >  uev_trigger *my_uev_trigger;
>    >  void * my_trigger_data;
>    > +int servicing_uev;
>    > +
>    > +int is_uevent_busy(void)
>    > +{
>    > +    return (uevqhp != NULL || servicing_uev);
>    > +}
>    >
>    >  static struct uevent * alloc_uevent (void)
>    >  {
>    > @@ -96,7 +102,9 @@ uevq_thread(void * et)
>    >
>    >      while (1) {
>    >          pthread_mutex_lock(uevc_lockp);
>    > +        servicing_uev = 0;
>    >          pthread_cond_wait(uev_condp, uevc_lockp);
>    > +        servicing_uev = 1;
>    >          pthread_mutex_unlock(uevc_lockp);
>    >
>    >          service_uevq();
>    > Index: multipath-tools-100510/libmultipath/uevent.h
>    > ===================================================================
>    > --- multipath-tools-100510.orig/libmultipath/uevent.h
>    > +++ multipath-tools-100510/libmultipath/uevent.h
>    > @@ -17,3 +17,4 @@ struct uevent {
>    >
>    >  int uevent_listen(int (*store_uev)(struct uevent *, void *
>    trigger_data),
>    >            void * trigger_data);
>    > +int is_uevent_busy(void);
>    > Index: multipath-tools-100510/multipathd/cli.c
>    > ===================================================================
>    > --- multipath-tools-100510.orig/multipathd/cli.c
>    > +++ multipath-tools-100510/multipathd/cli.c
>    > @@ -174,6 +174,7 @@ load_keys (void)
>    >      r += add_key(keys, "devices", DEVICES, 0);
>    >      r += add_key(keys, "format", FMT, 1);
>    >      r += add_key(keys, "wildcards", WILDCARDS, 0);
>    > +    r += add_key(keys, "count", COUNT, 0);
>    >      r += add_key(keys, "quit", QUIT, 0);
>    >      r += add_key(keys, "exit", QUIT, 0);
>    >
>    > @@ -443,6 +444,7 @@ cli_init (void) {
>    >      add_handler(RESTOREQ+MAPS, NULL);
>    >      add_handler(REINSTATE+PATH, NULL);
>    >      add_handler(FAIL+PATH, NULL);
>    > +    add_handler(COUNT+PATHS, NULL);
>    >      add_handler(QUIT, NULL);
>    >
>    >      return 0;
>    > Index: multipath-tools-100510/multipathd/cli_handlers.h
>    > ===================================================================
>    > --- multipath-tools-100510.orig/multipathd/cli_handlers.h
>    > +++ multipath-tools-100510/multipathd/cli_handlers.h
>    > @@ -25,5 +25,6 @@ int cli_restore_all_queueing(void * v, c
>    >  int cli_suspend(void * v, char ** reply, int * len, void * data);
>    >  int cli_resume(void * v, char ** reply, int * len, void * data);
>    >  int cli_reinstate(void * v, char ** reply, int * len, void * data);
>    > +int cli_count_paths(void * v, char ** reply, int * len, void * data);
>    >  int cli_fail(void * v, char ** reply, int * len, void * data);
>    >  int cli_quit(void * v, char ** reply, int * len, void * data);
>    > Index: multipath-tools-100510/multipathd/main.c
>    > ===================================================================
>    > --- multipath-tools-100510.orig/multipathd/main.c
>    > +++ multipath-tools-100510/multipathd/main.c
>    > @@ -783,6 +783,7 @@ uxlsnrloop (void * ap)
>    >      set_handler_callback(RESTOREQ+MAP, cli_restore_queueing);
>    >      set_handler_callback(DISABLEQ+MAPS, cli_disable_all_queueing);
>    >      set_handler_callback(RESTOREQ+MAPS, cli_restore_all_queueing);
>    > +    set_handler_callback(COUNT+PATHS, cli_count_paths);
>    >      set_handler_callback(QUIT, cli_quit);
>    >
>    >      umask(077);
>    > Index: multipath-tools-100510/multipathd/cli.h
>    > ===================================================================
>    > --- multipath-tools-100510.orig/multipathd/cli.h
>    > +++ multipath-tools-100510/multipathd/cli.h
>    > @@ -23,6 +23,7 @@ enum {
>    >      __BLACKLIST,
>    >      __DEVICES,
>    >      __FMT,
>    > +    __COUNT,
>    >      __WILDCARDS,
>    >      __QUIT,
>    >  };
>    > @@ -51,6 +52,7 @@ enum {
>    >  #define BLACKLIST    (1 << __BLACKLIST)
>    >  #define DEVICES      (1 << __DEVICES)
>    >  #define FMT         (1 << __FMT)
>    > +#define COUNT        (1 << __COUNT)
>    >  #define WILDCARDS    (1 << __WILDCARDS)
>    >  #define QUIT        (1 << __QUIT)
>    >
>    > Index: multipath-tools-100510/multipathd/cli_handlers.c
>    > ===================================================================
>    > --- multipath-tools-100510.orig/multipathd/cli_handlers.c
>    > +++ multipath-tools-100510/multipathd/cli_handlers.c
>    > @@ -18,6 +18,29 @@
>    >
>    >  #include "main.h"
>    >  #include "cli.h"
>    > +#include "uevent.h"
>    > +
>    > +int
>    > +count_paths(char  **r, int *l, struct vectors *vecs)
>    > +{
>    > +    int i, len;
>    > +    struct path *pp;
>    > +    char * reply;
>    > +    unsigned int maxlen = INITIAL_REPLY_LEN;
>    > +    int monitored_count = 0;
>    > +
>    > +    reply = MALLOC(maxlen);
>    > +    if (!reply)
>    > +        return 1;
>    > +    vector_foreach_slot(vecs->pathvec, pp, i)
>    > +        if (pp->fd != -1)
>    > +            monitored_count++;
>    > +    len = sprintf(reply, "Paths: %d\nBusy: %s\n", monitored_count,
>    > +              is_uevent_busy()? "True" : "False");
>    > +    *r = reply;
>    > +    *l = len + 1;
>    > +    return 0;
>    > +}
>    >
>    >  int
>    >  show_paths (char ** r, int * len, struct vectors * vecs, char * style)
>    > @@ -176,6 +199,16 @@ cli_list_config (void * v, char ** reply
>    >  }
>    >
>    >  int
>    > +cli_count_paths (void * v, char ** reply, int * len, void * data)
>    > +{
>    > +    struct vectors * vecs = (struct vectors *)data;
>    > +
>    > +    condlog(3, "count paths (operator)");
>    > +
>    > +    return count_paths(reply, len, vecs);
>    > +}
>    > +
>    > +int
>    >  cli_list_paths (void * v, char ** reply, int * len, void * data)
>    >  {
>    >      struct vectors * vecs = (struct vectors *)data;
>    > Index: multipath-tools-100510/multipathd/multipathd.8
>    > ===================================================================
>    > --- multipath-tools-100510.orig/multipathd/multipathd.8
>    > +++ multipath-tools-100510/multipathd/multipathd.8
>    > @@ -69,6 +69,10 @@ Add a path to the list of monitored path
>    >  .B remove|del path $path
>    >  Stop monitoring a path. $path is as listed in /sys/block (e.g. sda).
>    >  .TP
>    > +.B count paths
>    > +Show the number of monitored paths, and whether multipathd is currently
>    > +handling a uevent.
>    > +.TP
>    >  .B add map $map
>    >  Add a multipath device to the list of monitored devices. $map can
>    either be a
>    > device-mapper device as listed in /sys/block (e.g. dm-0) or it can be
>    the alias
>    > for the multipath device (e.g. mpath1) or the uid of the multipath
>    device (e.g.
>    > 36005076303ffc56200000000000010aa).    .TP
>    >
>    > --
>    > dm-devel mailing list
>    > [2]dm-devel@redhat.com
>    > [3]https://www.redhat.com/mailman/listinfo/dm-devel
> 
> References
> 
>    Visible links
>    1. mailto:bmarzins@redhat.com
>    2. mailto:dm-devel@redhat.com
>    3. https://www.redhat.com/mailman/listinfo/dm-devel
