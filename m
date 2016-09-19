From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] dm: Remove dm_bufio_cond_resched()
Date: Mon, 19 Sep 2016 12:53:25 +0200
Message-ID: <20160919105325.GW5016@twins.programming.kicks-ass.net>
References: <20160913084520.GA5012@twins.programming.kicks-ass.net>
 <20160913133959.GA22833@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160913133959.GA22833@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 13, 2016 at 09:39:59AM -0400, Mike Snitzer wrote:
> So I'm not sure how this dm-bufio local cond_resched() wrapper still got
> in... happy to take your patch.
> 
> Please respond with whatever SOB you'd like applied to the patch header.

Sorry, for the delay, here goes.

---
Subject: dm: Remove dm_bufio_cond_resched()
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 13 Sep 2016 10:45:20 +0200

Remove pointless local wrappery. Use cond_resched() like everybody else.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 drivers/md/dm-bufio.c |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -191,19 +191,6 @@ static void dm_bufio_unlock(struct dm_bu
 	mutex_unlock(&c->lock);
 }
 
-/*
- * FIXME Move to sched.h?
- */
-#ifdef CONFIG_PREEMPT_VOLUNTARY
-#  define dm_bufio_cond_resched()		\
-do {						\
-	if (unlikely(need_resched()))		\
-		_cond_resched();		\
-} while (0)
-#else
-#  define dm_bufio_cond_resched()                do { } while (0)
-#endif
-
 /*----------------------------------------------------------------*/
 
 /*
@@ -741,7 +728,7 @@ static void __flush_write_list(struct li
 			list_entry(write_list->next, struct dm_buffer, write_list);
 		list_del(&b->write_list);
 		submit_io(b, WRITE, b->block, write_endio);
-		dm_bufio_cond_resched();
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 }
@@ -780,7 +767,7 @@ static struct dm_buffer *__get_unclaimed
 			__unlink_buffer(b);
 			return b;
 		}
-		dm_bufio_cond_resched();
+		cond_resched();
 	}
 
 	list_for_each_entry_reverse(b, &c->lru[LIST_DIRTY], lru_list) {
@@ -791,7 +778,7 @@ static struct dm_buffer *__get_unclaimed
 			__unlink_buffer(b);
 			return b;
 		}
-		dm_bufio_cond_resched();
+		cond_resched();
 	}
 
 	return NULL;
@@ -923,7 +910,7 @@ static void __write_dirty_buffers_async(
 			return;
 
 		__write_dirty_buffer(b, write_list);
-		dm_bufio_cond_resched();
+		cond_resched();
 	}
 }
 
@@ -973,7 +960,7 @@ static void __check_watermark(struct dm_
 			return;
 
 		__free_buffer_wake(b);
-		dm_bufio_cond_resched();
+		cond_resched();
 	}
 
 	if (c->n_buffers[LIST_DIRTY] > threshold_buffers)
@@ -1170,7 +1157,7 @@ void dm_bufio_prefetch(struct dm_bufio_c
 				submit_io(b, READ, b->block, read_endio);
 			dm_bufio_release(b);
 
-			dm_bufio_cond_resched();
+			cond_resched();
 
 			if (!n_blocks)
 				goto flush_plug;
@@ -1291,7 +1278,7 @@ int dm_bufio_write_dirty_buffers(struct
 		    !test_bit(B_WRITING, &b->state))
 			__relink_lru(b, LIST_CLEAN);
 
-		dm_bufio_cond_resched();
+		cond_resched();
 
 		/*
 		 * If we dropped the lock, the list is no longer consistent,
@@ -1574,7 +1561,7 @@ static unsigned long __scan(struct dm_bu
 				freed++;
 			if (!--nr_to_scan || ((count - freed) <= retain_target))
 				return freed;
-			dm_bufio_cond_resched();
+			cond_resched();
 		}
 	}
 	return freed;
@@ -1808,7 +1795,7 @@ static void __evict_old_buffers(struct d
 		if (__try_evict_buffer(b, 0))
 			count--;
 
-		dm_bufio_cond_resched();
+		cond_resched();
 	}
 
 	dm_bufio_unlock(c);
