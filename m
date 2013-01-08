From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH 42/42] multipathd: lock vectors during
 initial configuration
Date: Wed, 09 Jan 2013 00:37:22 +0100
Message-ID: <1357688242.12137.3.camel@lapoo.opensvc.com>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
	<1357653259-62650-42-git-send-email-hare@suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-42-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On mar., 2013-01-08 at 14:54 +0100, Hannes Reinecke wrote:
> During initial configuration the CLI thread is already running,
> so we need to lock the vectors here to not race with the
> 'reconfigure' CLI command.
> 
Are you sure of the 41 - 42 patches ?

- 41 moves the vecs locking from reconfigure caller to reconfigure
- 42 removes the locking from reconfigure

Regards,
Christophe Varoqui
www.opensvc.com
 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  multipathd/main.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 395307e..8917499 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1389,7 +1389,6 @@ reconfigure (struct vectors * vecs)
>  	struct config * old = conf;
>  	int retval = 1;
>  
> -	lock(vecs->lock);
>  	/*
>  	 * free old map and path vectors ... they use old conf state
>  	 */
> @@ -1410,7 +1409,6 @@ reconfigure (struct vectors * vecs)
>  		retval = 0;
>  	}
>  
> -	unlock(vecs->lock);
>  	return retval;
>  }
>  
> @@ -1641,9 +1639,9 @@ child (void * param)
>  	/*
>  	 * fetch and configure both paths and multipaths
>  	 */
> -	lock(vecs->lock);
>  	running_state = DAEMON_CONFIGURE;
>  
> +	lock(vecs->lock);
>  	if (configure(vecs, 1)) {
>  		unlock(vecs->lock);
>  		condlog(0, "failure during configuration");
