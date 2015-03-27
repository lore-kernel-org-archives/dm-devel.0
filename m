From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 74/78] Allow specific CLI commands to run
	unlocked
Date: Fri, 27 Mar 2015 00:38:28 -0500
Message-ID: <20150327053828.GU29132@octiron.msp.redhat.com>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
	<1426509425-15978-75-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1426509425-15978-75-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Mon, Mar 16, 2015 at 01:37:01PM +0100, Hannes Reinecke wrote:
> When multipath is busy with checking paths or processing udev
> events it'll take the vector lock, causing the CLI
> to become unresponsive.
> This patch allows certain CLI commands to not wait for the vector
> lock, so that those commands will always succeed.

This one looks like it can actually cause memory corruption.

Holding the vecs lock is necessary to protect the vecs vectors and
conf, and the only unlocked handler that doesn't touch anything that
vecs protects is cli_quit.

All the others at least call condlog, which calls dlog, which includes
this line

thres = (conf) ? conf->verbosity : 0;

During a reconfigure, conf will temporarily be null, and it can happen
after the check.   Now as the code stands at this patch, the cli
handlers are protected from concurrent reconfigure calls because
reconfigure() is also called by uxsock_listen, so it can't run at the
same time as a cli handler. But your later patch "multipathd:
asynchronous configuration" moves this handling to child(), and I don't
see anything that will keep it from running reconfigure() while a
cli_handler is running.

cli_reconfigure and cli_list_blacklist make use of conf for much more
than the initial condlog, so they are even more at risk.

But the biggest problem is cli_list_status, which traverses
vecs->pathvec without the vecs lock held.  I don't see anything to stop,
for instance, ev_add_path from running at the same time.  This means
that it's possible that vecs->pathvec will get realloced out from under
cli_list_status.

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  multipathd/cli.c  | 26 +++++++++++++++++++++++++-
>  multipathd/cli.h  |  2 ++
>  multipathd/main.c | 17 ++++++-----------
>  3 files changed, 33 insertions(+), 12 deletions(-)
> 
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index acc4249..2d3d02d 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -1,8 +1,11 @@
>  /*
>   * Copyright (c) 2005 Christophe Varoqui
>   */
> +#include <pthread.h>
>  #include <memory.h>
>  #include <vector.h>
> +#include <structs.h>
> +#include <structs_vec.h>
>  #include <parser.h>
>  #include <util.h>
>  #include <version.h>
> @@ -99,6 +102,19 @@ set_handler_callback (unsigned long fp, int (*fn)(void *, char **, int *, void *
>  	if (!h)
>  		return 1;
>  	h->fn = fn;
> +	h->locked = 1;
> +	return 0;
> +}
> +
> +int
> +set_unlocked_handler_callback (unsigned long fp,int (*fn)(void *, char **, int *, void *))
> +{
> +	struct handler * h = find_handler(fp);
> +
> +	if (!h)
> +		return 1;
> +	h->fn = fn;
> +	h->locked = 0;
>  	return 0;
>  }
>  
> @@ -396,7 +412,15 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data)
>  	/*
>  	 * execute handler
>  	 */
> -	r = h->fn(cmdvec, reply, len, data);
> +	if (h->locked) {
> +		struct vectors * vecs = (struct vectors *)data;
> +		pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +		lock(vecs->lock);
> +		pthread_testcancel();
> +		r = h->fn(cmdvec, reply, len, data);
> +		lock_cleanup_pop(vecs->lock);
> +	} else
> +		r = h->fn(cmdvec, reply, len, data);
>  	free_keys(cmdvec);
>  
>  	return r;
> diff --git a/multipathd/cli.h b/multipathd/cli.h
> index 09fdc68..b35a315 100644
> --- a/multipathd/cli.h
> +++ b/multipathd/cli.h
> @@ -82,12 +82,14 @@ struct key {
>  
>  struct handler {
>  	unsigned long fingerprint;
> +	int locked;
>  	int (*fn)(void *, char **, int *, void *);
>  };
>  
>  int alloc_handlers (void);
>  int add_handler (unsigned long fp, int (*fn)(void *, char **, int *, void *));
>  int set_handler_callback (unsigned long fp, int (*fn)(void *, char **, int *, void *));
> +int set_unlocked_handler_callback (unsigned long fp, int (*fn)(void *, char **, int *, void *));
>  int parse_cmd (char * cmd, char ** reply, int * len, void *);
>  int load_keys (void);
>  char * get_keyparam (vector v, unsigned long code);
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 9e7bf4f..ab2a3a7 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -773,10 +773,6 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
>  	*len = 0;
>  	vecs = (struct vectors *)trigger_data;
>  
> -	pthread_cleanup_push(cleanup_lock, &vecs->lock);
> -	lock(vecs->lock);
> -	pthread_testcancel();
> -
>  	r = parse_cmd(str, reply, len, vecs);
>  
>  	if (r > 0) {
> @@ -791,7 +787,6 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
>  	}
>  	/* else if (r < 0) leave *reply alone */
>  
> -	lock_cleanup_pop(vecs->lock);
>  	return r;
>  }
>  
> @@ -903,16 +898,16 @@ uxlsnrloop (void * ap)
>  	set_handler_callback(LIST+PATHS+FMT, cli_list_paths_fmt);
>  	set_handler_callback(LIST+PATH, cli_list_path);
>  	set_handler_callback(LIST+MAPS, cli_list_maps);
> -	set_handler_callback(LIST+STATUS, cli_list_status);
> -	set_handler_callback(LIST+DAEMON, cli_list_daemon);
> +	set_unlocked_handler_callback(LIST+STATUS, cli_list_status);
> +	set_unlocked_handler_callback(LIST+DAEMON, cli_list_daemon);
>  	set_handler_callback(LIST+MAPS+STATUS, cli_list_maps_status);
>  	set_handler_callback(LIST+MAPS+STATS, cli_list_maps_stats);
>  	set_handler_callback(LIST+MAPS+FMT, cli_list_maps_fmt);
>  	set_handler_callback(LIST+MAPS+TOPOLOGY, cli_list_maps_topology);
>  	set_handler_callback(LIST+TOPOLOGY, cli_list_maps_topology);
>  	set_handler_callback(LIST+MAP+TOPOLOGY, cli_list_map_topology);
> -	set_handler_callback(LIST+CONFIG, cli_list_config);
> -	set_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
> +	set_unlocked_handler_callback(LIST+CONFIG, cli_list_config);
> +	set_unlocked_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
>  	set_handler_callback(LIST+DEVICES, cli_list_devices);
>  	set_handler_callback(LIST+WILDCARDS, cli_list_wildcards);
>  	set_handler_callback(ADD+PATH, cli_add_path);
> @@ -932,8 +927,8 @@ uxlsnrloop (void * ap)
>  	set_handler_callback(RESTOREQ+MAP, cli_restore_queueing);
>  	set_handler_callback(DISABLEQ+MAPS, cli_disable_all_queueing);
>  	set_handler_callback(RESTOREQ+MAPS, cli_restore_all_queueing);
> -	set_handler_callback(QUIT, cli_quit);
> -	set_handler_callback(SHUTDOWN, cli_shutdown);
> +	set_unlocked_handler_callback(QUIT, cli_quit);
> +	set_unlocked_handler_callback(SHUTDOWN, cli_shutdown);
>  	set_handler_callback(GETPRSTATUS+MAP, cli_getprstatus);
>  	set_handler_callback(SETPRSTATUS+MAP, cli_setprstatus);
>  	set_handler_callback(UNSETPRSTATUS+MAP, cli_unsetprstatus);
> -- 
> 1.8.4.5
