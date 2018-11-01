From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 4/7] multipathd: open client socket early
Date: Thu, 1 Nov 2018 16:49:06 -0500
Message-ID: <20181101214906.GD29522@octiron.msp.redhat.com>
References: <20181030212249.31127-1-mwilck@suse.com>
	<20181030212249.31127-5-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181030212249.31127-5-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Oct 30, 2018 at 10:22:46PM +0100, Martin Wilck wrote:
> Open the unix socket in multipathd code and pass the fd to
> uxsock_listen(). This will enable us to make the main thread
> wait for successful socket initialization in a follow-up patch.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c   | 22 ++++++++++++++++++----
>  multipathd/uxlsnr.c | 11 ++---------
>  multipathd/uxlsnr.h |  2 +-
>  3 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index a2b01705..e45e45dc 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -66,6 +66,7 @@ static int use_watchdog;
>  #include "pgpolicies.h"
>  #include "uevent.h"
>  #include "log.h"
> +#include "uxsock.h"
>  
>  #include "mpath_cmd.h"
>  #include "mpath_persist.h"
> @@ -1493,12 +1494,23 @@ uevqloop (void * ap)
>  static void *
>  uxlsnrloop (void * ap)
>  {
> +	int ux_sock;
> +
> +	pthread_cleanup_push(rcu_unregister, NULL);
> +	rcu_register_thread();
> +
> +	ux_sock = ux_socket_listen(DEFAULT_SOCKET);
> +	if (ux_sock == -1) {
> +		condlog(1, "could not create uxsock: %d", errno);
> +		exit_daemon();
> +		goto out;
> +	}
> +
>  	if (cli_init()) {
>  		condlog(1, "Failed to init uxsock listener");
> -		return NULL;
> +		exit_daemon();
> +		goto out;

I don't know now much this matters, seeing as we're exitting the daemon
anyway, but we don't close ux_sock if we fail here. It would make more
sense to push and pop uxsock_cleanup from this function, instead of
uxsock_listen()

-Ben

>  	}
> -	pthread_cleanup_push(rcu_unregister, NULL);
> -	rcu_register_thread();
>  	set_handler_callback(LIST+PATHS, cli_list_paths);
>  	set_handler_callback(LIST+PATHS+FMT, cli_list_paths_fmt);
>  	set_handler_callback(LIST+PATHS+RAW+FMT, cli_list_paths_raw);
> @@ -1553,7 +1565,9 @@ uxlsnrloop (void * ap)
>  	set_handler_callback(UNSETPRKEY+MAP, cli_unsetprkey);
>  
>  	umask(077);
> -	uxsock_listen(&uxsock_trigger, ap);
> +	uxsock_listen(&uxsock_trigger, ux_sock, ap);
> +
> +out:
>  	pthread_cleanup_pop(1);
>  	return NULL;
>  }
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 6f666663..04967e9a 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -165,22 +165,15 @@ void uxsock_cleanup(void *arg)
>  /*
>   * entry point
>   */
> -void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
> +void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
> +		     void * trigger_data)
>  {
> -	long ux_sock;
>  	int rlen;
>  	char *inbuf;
>  	char *reply;
>  	sigset_t mask;
>  	int old_clients = MIN_POLLS;
>  
> -	ux_sock = ux_socket_listen(DEFAULT_SOCKET);
> -
> -	if (ux_sock == -1) {
> -		condlog(1, "could not create uxsock: %d", errno);
> -		exit_daemon();
> -	}
> -
>  	pthread_cleanup_push(uxsock_cleanup, (void *)ux_sock);
>  
>  	condlog(3, "uxsock: startup listener");
> diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
> index d51a8f99..c7f25b2b 100644
> --- a/multipathd/uxlsnr.h
> +++ b/multipathd/uxlsnr.h
> @@ -5,7 +5,7 @@
>  
>  typedef int (uxsock_trigger_fn)(char *, char **, int *, bool, void *);
>  
> -void * uxsock_listen(uxsock_trigger_fn uxsock_trigger,
> +void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
>  		     void * trigger_data);
>  
>  #endif
> -- 
> 2.19.1
