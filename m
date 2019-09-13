From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 5/5] dm-bufio: introduce a global cache
	replacement
Date: Fri, 13 Sep 2019 15:00:11 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1909131459400.12122@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190912084550.401229120@debian-a64.vm>
	<03876828-40a1-7adc-d40c-939853e8259c@redhat.com>
	<alpine.LRH.2.02.1909121206130.31437@file01.intranet.prod.int.rdu2.redhat.com>
	<20190913160006.GA59158@lobo>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190913160006.GA59158@lobo>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, jiyong@google.com, kernel-team@android.com, Heinz Mauelshagen <heinzm@redhat.com>, dariofreni@google.com, dm-devel@redhat.com, maco@google.com, Martijn Coenen <maco@android.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Fri, 13 Sep 2019, Mike Snitzer wrote:

> On Thu, Sep 12 2019 at 12:07P -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Thu, 12 Sep 2019, Heinz Mauelshagen wrote:
> > 
> > > Mikulas,
> > > 
> > > please use list_move instead of list_del/list_add pairs.
> > > 
> > > Heinz
> > 
> > OK. Here I resend it.
> > 
> > 
> > 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > This patch introduces a global cache replacement (instead of per-client
> > cleanup).
> > 
> > If one bufio client uses the cache heavily and another client is not using
> > it, we want to let the first client use most of the cache. The old
> > algorithm would partition the cache equally betwen the clients and that is
> > inoptimal.
> > 
> > For cache replacement, we use the clock algorithm because it doesn't
> > require taking any lock when the buffer is accessed.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> I'd like to fold in this cleanup if you're OK with it.
> 
> Rather use a main control structure for the loop rather than gotos.
> 
> You OK with this?

Yes - you can replace gotos with the loop.

Mikulas

> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 8c6edec8a838..2d519c223562 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -230,7 +230,6 @@ static LIST_HEAD(dm_bufio_all_clients);
>   */
>  static DEFINE_MUTEX(dm_bufio_clients_lock);
>  
> -
>  static struct workqueue_struct *dm_bufio_wq;
>  static struct delayed_work dm_bufio_cleanup_old_work;
>  static struct work_struct dm_bufio_replacement_work;
> @@ -1827,62 +1826,60 @@ static void do_global_cleanup(struct work_struct *w)
>  	struct dm_bufio_client *current_client;
>  	struct dm_buffer *b;
>  	unsigned spinlock_hold_count;
> -	unsigned long threshold = dm_bufio_cache_size - dm_bufio_cache_size / DM_BUFIO_LOW_WATERMARK_RATIO;
> +	unsigned long threshold = dm_bufio_cache_size -
> +		dm_bufio_cache_size / DM_BUFIO_LOW_WATERMARK_RATIO;
>  	unsigned long loops = global_num * 2;
>  
>  	mutex_lock(&dm_bufio_clients_lock);
>  
> -reacquire_spinlock:
> -	cond_resched();
> +	while (1) {
> +		cond_resched();
>  
> -	spin_lock(&global_spinlock);
> -	if (unlikely(dm_bufio_current_allocated <= threshold))
> -		goto exit;
> +		spin_lock(&global_spinlock);
> +		if (unlikely(dm_bufio_current_allocated <= threshold))
> +			break;
>  
> -	spinlock_hold_count = 0;
> +		spinlock_hold_count = 0;
>  get_next:
> -	if (!loops--)
> -		goto exit;
> -	if (unlikely(list_empty(&global_queue)))
> -		goto exit;
> -	b = list_entry(global_queue.prev, struct dm_buffer, global_list);
> -
> -	if (b->accessed) {
> -		b->accessed = 0;
> -		list_move(&b->global_list, &global_queue);
> -		if (likely(++spinlock_hold_count < 16)) {
> -			goto get_next;
> -		}
> -		spin_unlock(&global_spinlock);
> -		goto reacquire_spinlock;
> -	}
> -
> -	current_client = b->c;
> -	if (unlikely(current_client != locked_client)) {
> -		if (locked_client)
> -			dm_bufio_unlock(locked_client);
> +		if (!loops--)
> +			break;
> +		if (unlikely(list_empty(&global_queue)))
> +			break;
> +		b = list_entry(global_queue.prev, struct dm_buffer, global_list);
>  
> -		if (!dm_bufio_trylock(current_client)) {
> +		if (b->accessed) {
> +			b->accessed = 0;
> +			list_move(&b->global_list, &global_queue);
> +			if (likely(++spinlock_hold_count < 16))
> +				goto get_next;
>  			spin_unlock(&global_spinlock);
> -			dm_bufio_lock(current_client);
> -			locked_client = current_client;
> -			goto reacquire_spinlock;
> +			continue;
>  		}
>  
> -		locked_client = current_client;
> -	}
> +		current_client = b->c;
> +		if (unlikely(current_client != locked_client)) {
> +			if (locked_client)
> +				dm_bufio_unlock(locked_client);
>  
> -	spin_unlock(&global_spinlock);
> +			if (!dm_bufio_trylock(current_client)) {
> +				spin_unlock(&global_spinlock);
> +				dm_bufio_lock(current_client);
> +				locked_client = current_client;
> +				continue;
> +			}
> +
> +			locked_client = current_client;
> +		}
>  
> -	if (unlikely(!__try_evict_buffer(b, GFP_KERNEL))) {
> -		spin_lock(&global_spinlock);
> -		list_move(&b->global_list, &global_queue);
>  		spin_unlock(&global_spinlock);
> -	}
>  
> -	goto reacquire_spinlock;
> +		if (unlikely(!__try_evict_buffer(b, GFP_KERNEL))) {
> +			spin_lock(&global_spinlock);
> +			list_move(&b->global_list, &global_queue);
> +			spin_unlock(&global_spinlock);
> +		}
> +	}
>  
> -exit:
>  	spin_unlock(&global_spinlock);
>  
>  	if (locked_client)
> 
