From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 01/23] multipathd: uxlsnr: avoid deadlock on
	exit
Date: Fri, 25 Sep 2020 20:52:07 -0500
Message-ID: <20200926015207.GJ3384@octiron.msp.redhat.com>
References: <20200924134054.14632-1-mwilck@suse.com>
	<20200924134054.14632-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924134054.14632-2-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 24, 2020 at 03:40:32PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The uxlsnr wouldn't always release the client lock when cancelled,
> causing a deadlock in uxsock_cleanup(). While this hasn't been
> caused by commit 3d611a2, the deadlock seems to have become much
> more likely after that patch. Solving this means that we have to
> treat reallocation failure of the pollfd array differently.
> We will now just ignore any clients above the last valid pfd index.
> That's a minor problem, as we're in an OOM situation anyway.
> 
> Moreover, client_lock is not a "struct lock", but a plain
> pthread_mutex_t.
> 
> Fixes: 3d611a2 ("multipathd: cancel threads early during shutdown")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/uxlsnr.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 1c5ce9d..d47ba1a 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -35,6 +35,7 @@
>  #include "config.h"
>  #include "mpath_cmd.h"
>  #include "time-util.h"
> +#include "util.h"
>  
>  #include "main.h"
>  #include "cli.h"
> @@ -116,7 +117,7 @@ static void _dead_client(struct client *c)
>  
>  static void dead_client(struct client *c)
>  {
> -	pthread_cleanup_push(cleanup_lock, &client_lock);
> +	pthread_cleanup_push(cleanup_mutex, &client_lock);
>  	pthread_mutex_lock(&client_lock);
>  	_dead_client(c);
>  	pthread_cleanup_pop(1);
> @@ -306,6 +307,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
>  
>  		/* setup for a poll */
>  		pthread_mutex_lock(&client_lock);
> +		pthread_cleanup_push(cleanup_mutex, &client_lock);
>  		num_clients = 0;
>  		list_for_each_entry(c, &clients, node) {
>  			num_clients++;
> @@ -322,14 +324,13 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
>  						sizeof(struct pollfd));
>  			}
>  			if (!new) {
> -				pthread_mutex_unlock(&client_lock);
>  				condlog(0, "%s: failed to realloc %d poll fds",
>  					"uxsock", 2 + num_clients);
> -				sched_yield();
> -				continue;
> +				num_clients = old_clients;

O.k. I'm getting way into the theoretical weeds here, but I believe that
realloc() is technically allowed to return NULL when it shrinks
allocated memory. In this case num_clients would be too big.  Later in
this function, when we loop through num_clients

                for (i = 2; i < num_clients + 2; i++) {
                        if (polls[i].revents & POLLIN) {
 
We could look at an unused polls entry, since its revents doesn't get
cleared. It's also possible that the fd of this unused entry matches the
fd of an existing client. Then we could try to get a packet from a
client that isn't sending one, and kill that client. Yeah, this will
almost certainly never happen.  But we could just zero out the revents
field, or loop over the actual number of structures we polled, and then
it can't happen.

-Ben

> +			} else {
> +				old_clients = num_clients;
> +				polls = new;
>  			}
> -			old_clients = num_clients;
> -			polls = new;
>  		}
>  		polls[0].fd = ux_sock;
>  		polls[0].events = POLLIN;
> @@ -347,8 +348,10 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
>  			polls[i].fd = c->fd;
>  			polls[i].events = POLLIN;
>  			i++;
> +			if (i >= 2 + num_clients)
> +				break;
>  		}
> -		pthread_mutex_unlock(&client_lock);
> +		pthread_cleanup_pop(1);
>  
>  		/* most of our life is spent in this call */
>  		poll_count = ppoll(polls, i, &sleep_time, &mask);
> -- 
> 2.28.0
