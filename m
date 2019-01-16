From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 4/6] multipathd: cancel threads early
	during shutdown
Date: Wed, 16 Jan 2019 17:40:56 -0600
Message-ID: <20190116234056.GT11315@octiron.msp.redhat.com>
References: <20190104175914.22784-1-mwilck@suse.com>
	<20190104175914.22784-5-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190104175914.22784-5-mwilck@suse.com>
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
Cc: Chongyun Wu <wu.chongyun@h3c.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jan 04, 2019 at 06:59:12PM +0100, Martin Wilck wrote:
> Cancel the other threads before taking vecs->lock. This avoids
> delays during shutdown caused e.g. by the checker thread holding
> the vecs lock.

Before this change, multipathd was guaranteed that once a thread had
locked the vecs lock, and checked if it had been cancelled, it could not
be cancelled after that until it unlocked the vecs lock.  Undoing this
guarantee will likely make it possible for multipathd to leak memory
where it wasn't possible before. However, since it's happening during
shutdown, I'm not sure that we really need to care. Or, perhaps you
audited this, and I'm wrong.

At any rate, it's at least worth mentioning.

-Ben

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 413beee0..569a27ac 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2872,23 +2872,24 @@ child (void * param)
>  		}
>  	}
>  
> -	lock(&vecs->lock);
> +	pthread_cancel(check_thr);
> +	pthread_cancel(uevent_thr);
> +	pthread_cancel(uxlsnr_thr);
> +	pthread_cancel(uevq_thr);
> +	if (poll_dmevents)
> +		pthread_cancel(dmevent_thr);
> +
>  	conf = get_multipath_config();
>  	queue_without_daemon = conf->queue_without_daemon;
>  	put_multipath_config(conf);
> +
> +	lock(&vecs->lock);
>  	if (queue_without_daemon == QUE_NO_DAEMON_OFF)
>  		vector_foreach_slot(vecs->mpvec, mpp, i)
>  			dm_queue_if_no_path(mpp->alias, 0);
>  	remove_maps_and_stop_waiters(vecs);
>  	unlock(&vecs->lock);
>  
> -	pthread_cancel(check_thr);
> -	pthread_cancel(uevent_thr);
> -	pthread_cancel(uxlsnr_thr);
> -	pthread_cancel(uevq_thr);
> -	if (poll_dmevents)
> -		pthread_cancel(dmevent_thr);
> -
>  	pthread_join(check_thr, NULL);
>  	pthread_join(uevent_thr, NULL);
>  	pthread_join(uxlsnr_thr, NULL);
> -- 
> 2.19.2
