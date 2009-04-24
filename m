From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH 6/7] dm core: disable interrupt when taking
	map_lock
Date: Fri, 24 Apr 2009 13:50:03 +0200
Message-ID: <20090424115002.GA23713@schmichrtp.de.ibm.com>
References: <49F17409.4060201@ct.jp.nec.com> <49F17530.2060701@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49F17530.2060701@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Apr 24, 2009 at 05:15:44PM +0900, Kiyoshi Ueda wrote:
> This patch disables interrupt when taking map_lock to prevent
> needless lockdep warnings in request-based dm.
> 
> request-based dm takes map_lock after taking queue_lock with
> disabling interrupt:
>   spin_lock_irqsave(queue_lock)
>   q->request_fn() == dm_request_fn()
>     => dm_get_table()
>          => read_lock(map_lock)
> while queue_lock could be taken in interrupt context.
> 
> So lockdep warns that a deadlock can happen:
>   write_lock(map_lock)
>   <interrupt>
>   spin_lock_irqsave(queue_lock)
>   q->request_fn() == dm_request_fn()
>     => dm_get_table()
>          => read_lock(map_lock)
> 
> Currently there is no such code path in request-based dm where
> q->request_fn() is called from interrupt context, so no such deadlock
> happens.
> But such warning messages confuse users, so prevent them by disabling
> interrupt when taking map_lock.
> 
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Christof Schmitt <christof.schmitt@de.ibm.com>
> Cc: Alasdair G Kergon <agk@redhat.com>
> ---
>  drivers/md/dm.c |   15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> Index: 2.6.30-rc3/drivers/md/dm.c
> ===================================================================
> --- 2.6.30-rc3.orig/drivers/md/dm.c
> +++ 2.6.30-rc3/drivers/md/dm.c
> @@ -510,12 +510,13 @@ static void queue_io(struct mapped_devic
>  struct dm_table *dm_get_table(struct mapped_device *md)
>  {
>  	struct dm_table *t;
> +	unsigned long flags;
> 
> -	read_lock(&md->map_lock);
> +	read_lock_irqsave(&md->map_lock, flags);
>  	t = md->map;
>  	if (t)
>  		dm_table_get(t);
> -	read_unlock(&md->map_lock);
> +	read_unlock_irqrestore(&md->map_lock, flags);
> 
>  	return t;
>  }
> @@ -1940,6 +1941,7 @@ static int __bind(struct mapped_device *
>  {
>  	struct request_queue *q = md->queue;
>  	sector_t size;
> +	unsigned long flags;
> 
>  	size = dm_table_get_size(t);
> 
> @@ -1971,10 +1973,10 @@ static int __bind(struct mapped_device *
> 
>  	__bind_mempools(md, t);
> 
> -	write_lock(&md->map_lock);
> +	write_lock_irqsave(&md->map_lock, flags);
>  	md->map = t;
>  	dm_table_set_restrictions(t, q);
> -	write_unlock(&md->map_lock);
> +	write_unlock_irqrestore(&md->map_lock, flags);
> 
>  	return 0;
>  }
> @@ -1982,14 +1984,15 @@ static int __bind(struct mapped_device *
>  static void __unbind(struct mapped_device *md)
>  {
>  	struct dm_table *map = md->map;
> +	unsigned long flags;
> 
>  	if (!map)
>  		return;
> 
>  	dm_table_event_callback(map, NULL, NULL);
> -	write_lock(&md->map_lock);
> +	write_lock_irqsave(&md->map_lock, flags);
>  	md->map = NULL;
> -	write_unlock(&md->map_lock);
> +	write_unlock_irqrestore(&md->map_lock, flags);
>  	dm_table_destroy(map);
>  }

Acked-by: Christof Schmitt <christof.schmitt@de.ibm.com>
