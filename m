From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC][PATCH] dm: Remove dm_bufio_cond_resched()
Date: Mon, 19 Sep 2016 05:49:07 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1609190542150.15526@file01.intranet.prod.int.rdu2.redhat.com>
References: <20160913084520.GA5012@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160913084520.GA5012@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On Tue, 13 Sep 2016, Peter Zijlstra wrote:

> Hi all,
> 
> While grepping for PREEMPT_VOLUNTARY I ran into dm_bufio_cond_resched()
> and wondered WTH it was about.

cond_resched() calls _cond_resched() even if when we have a preemptive 
kernel - with preemptive kernel, calling cond_resched is pointless because 
rescheduling is done peemtively.

So, I added that dm_bufio_cond_resched(), that does nothing on peemptive 
kernels (and also on PREEMPT_NONE kernels where the user doesn't care 
about latency).

What is the reason why cond_resched() tests for rescheduling with 
preemptive kernel? Why should I use cond_resched() in that case?

Mikulas

> Is there anything wrong with the below patch?
> 
> ---
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 8625040bae92..125aedc3875f 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -191,19 +191,6 @@ static void dm_bufio_unlock(struct dm_bufio_client *c)
>  	mutex_unlock(&c->lock);
>  }
>  
> -/*
> - * FIXME Move to sched.h?
> - */
> -#ifdef CONFIG_PREEMPT_VOLUNTARY
> -#  define dm_bufio_cond_resched()		\
> -do {						\
> -	if (unlikely(need_resched()))		\
> -		_cond_resched();		\
> -} while (0)
> -#else
> -#  define dm_bufio_cond_resched()                do { } while (0)
> -#endif
> -
>  /*----------------------------------------------------------------*/
>  
>  /*
> @@ -741,7 +728,7 @@ static void __flush_write_list(struct list_head *write_list)
>  			list_entry(write_list->next, struct dm_buffer, write_list);
>  		list_del(&b->write_list);
>  		submit_io(b, WRITE, b->block, write_endio);
> -		dm_bufio_cond_resched();
> +		cond_resched();
>  	}
>  	blk_finish_plug(&plug);
>  }
> @@ -780,7 +767,7 @@ static struct dm_buffer *__get_unclaimed_buffer(struct dm_bufio_client *c)
>  			__unlink_buffer(b);
>  			return b;
>  		}
> -		dm_bufio_cond_resched();
> +		cond_resched();
>  	}
>  
>  	list_for_each_entry_reverse(b, &c->lru[LIST_DIRTY], lru_list) {
> @@ -791,7 +778,7 @@ static struct dm_buffer *__get_unclaimed_buffer(struct dm_bufio_client *c)
>  			__unlink_buffer(b);
>  			return b;
>  		}
> -		dm_bufio_cond_resched();
> +		cond_resched();
>  	}
>  
>  	return NULL;
> @@ -923,7 +910,7 @@ static void __write_dirty_buffers_async(struct dm_bufio_client *c, int no_wait,
>  			return;
>  
>  		__write_dirty_buffer(b, write_list);
> -		dm_bufio_cond_resched();
> +		cond_resched();
>  	}
>  }
>  
> @@ -973,7 +960,7 @@ static void __check_watermark(struct dm_bufio_client *c,
>  			return;
>  
>  		__free_buffer_wake(b);
> -		dm_bufio_cond_resched();
> +		cond_resched();
>  	}
>  
>  	if (c->n_buffers[LIST_DIRTY] > threshold_buffers)
> @@ -1170,7 +1157,7 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
>  				submit_io(b, READ, b->block, read_endio);
>  			dm_bufio_release(b);
>  
> -			dm_bufio_cond_resched();
> +			cond_resched();
>  
>  			if (!n_blocks)
>  				goto flush_plug;
> @@ -1291,7 +1278,7 @@ int dm_bufio_write_dirty_buffers(struct dm_bufio_client *c)
>  		    !test_bit(B_WRITING, &b->state))
>  			__relink_lru(b, LIST_CLEAN);
>  
> -		dm_bufio_cond_resched();
> +		cond_resched();
>  
>  		/*
>  		 * If we dropped the lock, the list is no longer consistent,
> @@ -1574,7 +1561,7 @@ static unsigned long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
>  				freed++;
>  			if (!--nr_to_scan || ((count - freed) <= retain_target))
>  				return freed;
> -			dm_bufio_cond_resched();
> +			cond_resched();
>  		}
>  	}
>  	return freed;
> @@ -1808,7 +1795,7 @@ static void __evict_old_buffers(struct dm_bufio_client *c, unsigned long age_hz)
>  		if (__try_evict_buffer(b, 0))
>  			count--;
>  
> -		dm_bufio_cond_resched();
> +		cond_resched();
>  	}
>  
>  	dm_bufio_unlock(c);
> 
