From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/4] The return code from the various wait
 functions is never acted upon. So change to uninterrupible waits and change
 the return type to void.
Date: Wed, 3 Aug 2011 10:42:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108031041570.28467@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1108011620590.9983@hs20-bc2-1.build.redhat.com>
	<1312295808-4323-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1312295808-4323-1-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Ack.

Mikulas

On Tue, 2 Aug 2011, Joe Thornber wrote:

> ---
>  drivers/md/persistent-data/dm-block-manager.c |   23 +++++++----------------
>  1 files changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
> index 4e2f240..c9fb132 100644
> --- a/drivers/md/persistent-data/dm-block-manager.c
> +++ b/drivers/md/persistent-data/dm-block-manager.c
> @@ -371,46 +371,37 @@ static void __clear_errors(struct dm_block_manager *bm)
>  
>  #define __wait_block(wq, lock, flags, sched_fn, condition)	\
>  do {								\
> -	int r = 0;						\
> -								\
>  	DEFINE_WAIT(wait);					\
>  	add_wait_queue(wq, &wait);				\
>  								\
>  	for (;;) {						\
> -		prepare_to_wait(wq, &wait, TASK_INTERRUPTIBLE); \
> +		prepare_to_wait(wq, &wait, TASK_UNINTERRUPTIBLE); \
>  		if (condition)					\
>  			break;					\
>  								\
>  		spin_unlock_irqrestore(lock, flags);		\
> -		if (signal_pending(current)) {			\
> -			r = -ERESTARTSYS;			\
> -			spin_lock_irqsave(lock, flags);		\
> -			break;					\
> -		}						\
> -								\
>  		sched_fn();					\
>  		spin_lock_irqsave(lock, flags);			\
>  	}							\
>  								\
>  	finish_wait(wq, &wait);					\
> -	return r;						\
>  } while (0)
>  
> -static int __wait_io(struct dm_block *b, unsigned long *flags)
> +static void __wait_io(struct dm_block *b, unsigned long *flags)
>  	__retains(&b->bm->lock)
>  {
>  	__wait_block(&b->io_q, &b->bm->lock, *flags, io_schedule,
>  		     ((b->state != BS_READING) && (b->state != BS_WRITING)));
>  }
>  
> -static int __wait_unlocked(struct dm_block *b, unsigned long *flags)
> +static void __wait_unlocked(struct dm_block *b, unsigned long *flags)
>  	__retains(&b->bm->lock)
>  {
>  	__wait_block(&b->io_q, &b->bm->lock, *flags, schedule,
>  		     ((b->state == BS_CLEAN) || (b->state == BS_DIRTY)));
>  }
>  
> -static int __wait_read_lockable(struct dm_block *b, unsigned long *flags)
> +static void __wait_read_lockable(struct dm_block *b, unsigned long *flags)
>  	__retains(&b->bm->lock)
>  {
>  	__wait_block(&b->io_q, &b->bm->lock, *flags, schedule,
> @@ -419,21 +410,21 @@ static int __wait_read_lockable(struct dm_block *b, unsigned long *flags)
>  						 b->state == BS_READ_LOCKED)));
>  }
>  
> -static int __wait_all_writes(struct dm_block_manager *bm, unsigned long *flags)
> +static void __wait_all_writes(struct dm_block_manager *bm, unsigned long *flags)
>  	__retains(&bm->lock)
>  {
>  	__wait_block(&bm->io_q, &bm->lock, *flags, io_schedule,
>  		     !bm->writing_count);
>  }
>  
> -static int __wait_all_io(struct dm_block_manager *bm, unsigned long *flags)
> +static void __wait_all_io(struct dm_block_manager *bm, unsigned long *flags)
>  	__retains(&bm->lock)
>  {
>  	__wait_block(&bm->io_q, &bm->lock, *flags, io_schedule,
>  		     !bm->writing_count && !bm->reading_count);
>  }
>  
> -static int __wait_clean(struct dm_block_manager *bm, unsigned long *flags)
> +static void __wait_clean(struct dm_block_manager *bm, unsigned long *flags)
>  	__retains(&bm->lock)
>  {
>  	__wait_block(&bm->io_q, &bm->lock, *flags, io_schedule,
> -- 
> 1.7.4.1
> 
