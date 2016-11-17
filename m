From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] RFC: dm: avoid the mutex lock in
 dm_bufio_shrink_count()
Date: Thu, 17 Nov 2016 14:20:08 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1611171413450.99747@chino.kir.corp.google.com>
References: <1479417398-2593-1-git-send-email-dianders@chromium.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479417398-2593-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Anderson <dianders@chromium.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Sonny Rao <sonnyrao@chromium.org>, linux@roeck-us.net, dm-devel@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, 17 Nov 2016, Douglas Anderson wrote:

> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index b3ba142e59a4..885ba5482d9f 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -89,6 +89,7 @@ struct dm_bufio_client {
>  
>  	struct list_head lru[LIST_SIZE];
>  	unsigned long n_buffers[LIST_SIZE];
> +	unsigned long n_all_buffers;
>  
>  	struct block_device *bdev;
>  	unsigned block_size;
> @@ -485,6 +486,7 @@ static void __link_buffer(struct dm_buffer *b, sector_t block, int dirty)
>  	struct dm_bufio_client *c = b->c;
>  
>  	c->n_buffers[dirty]++;
> +	c->n_all_buffers++;
>  	b->block = block;
>  	b->list_mode = dirty;
>  	list_add(&b->lru_list, &c->lru[dirty]);
> @@ -502,6 +504,7 @@ static void __unlink_buffer(struct dm_buffer *b)
>  	BUG_ON(!c->n_buffers[b->list_mode]);
>  
>  	c->n_buffers[b->list_mode]--;
> +	c->n_all_buffers--;
>  	__remove(b->c, b);
>  	list_del(&b->lru_list);
>  }
> @@ -515,6 +518,7 @@ static void __relink_lru(struct dm_buffer *b, int dirty)
>  
>  	BUG_ON(!c->n_buffers[b->list_mode]);
>  
> +	/* NOTE: don't update n_all_buffers: -1 + 1 = 0 */
>  	c->n_buffers[b->list_mode]--;
>  	c->n_buffers[dirty]++;
>  	b->list_mode = dirty;
> @@ -1588,17 +1592,10 @@ static unsigned long
>  dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
>  {
>  	struct dm_bufio_client *c;
> -	unsigned long count;
>  
>  	c = container_of(shrink, struct dm_bufio_client, shrinker);
> -	if (sc->gfp_mask & __GFP_FS)
> -		dm_bufio_lock(c);
> -	else if (!dm_bufio_trylock(c))
> -		return 0;
>  
> -	count = c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY];
> -	dm_bufio_unlock(c);
> -	return count;
> +	return c->n_all_buffers;
>  }
>  
>  /*

Would be better to just avoid taking the mutex at all and returning 
c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY] with a comment that 
the estimate might be wrong, but the actual count may vary between 
->count_objects() and ->scan_objects() anyway, so we don't actually care?
