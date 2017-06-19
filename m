From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm integrity tests crash kernel (4.12-rc5)
Date: Mon, 19 Jun 2017 10:20:28 -0400
Message-ID: <20170619142026.GA92582@redhat.com>
References: <2b97933e-3f94-8510-cefd-13fae445400e@redhat.com>
 <d32598d1-2ae3-6b0a-690f-7d7dfa43899e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d32598d1-2ae3-6b0a-690f-7d7dfa43899e@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, mpatocka@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

On Mon, Jun 19 2017 at  8:11am -0400,
Ondrej Kozina <okozina@redhat.com> wrote:

> same log again, hopefully prettier format. Sorry:
> 
> [  330.980914] DEBUG_LOCKS_WARN_ON(current->hardirq_context)
> [  330.980923] ------------[ cut here ]------------
> [  330.982627] WARNING: CPU: 1 PID: 0 at kernel/locking/lockdep.c:2748 trace_hardirqs_on_caller+0x107/0x180
...
> [  331.011968] Call Trace:
> [  331.012806]  <IRQ>
> [  331.013684]  trace_hardirqs_on+0xd/0x10
> [  331.014732]  _raw_spin_unlock_irq+0x27/0x30
> [  331.015840]  submit_flush_bio+0x4e/0x80 [dm_integrity]
> [  331.017157]  do_endio_flush+0x41/0x70 [dm_integrity]
> [  331.018476]  dec_in_flight+0x59/0x110 [dm_integrity]
> [  331.019767]  integrity_end_io+0x5e/0x70 [dm_integrity]
> [  331.020965]  bio_endio+0x7c/0x1a0
> [  331.021917]  blk_update_request+0x9f/0x3d0
> [  331.023050]  blk_mq_end_request+0x15/0x60
> [  331.024224]  lo_complete_rq+0x2b/0x80
> [  331.025406]  __blk_mq_complete_request_remote+0xe/0x10
> [  331.026813]  flush_smp_call_function_queue+0x4f/0x110
> [  331.028173]  generic_smp_call_function_single_interrupt+0xe/0x20
> [  331.029616]  smp_call_function_single_interrupt+0x22/0x30
> [  331.031125]  call_function_single_interrupt+0x90/0xa0
> [  331.032819] RIP: 0010:default_idle+0x1b/0x180

Looks like submit_flush_bio() is disabling/enabling interrupts from
interrupt context.  Ondrej, does this patch fix the issue?

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 4ab10cf..93b1810 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1105,10 +1105,13 @@ static void schedule_autocommit(struct dm_integrity_c *ic)
 static void submit_flush_bio(struct dm_integrity_c *ic, struct dm_integrity_io *dio)
 {
 	struct bio *bio;
-	spin_lock_irq(&ic->endio_wait.lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ic->endio_wait.lock, flags);
 	bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 	bio_list_add(&ic->flush_bio_list, bio);
-	spin_unlock_irq(&ic->endio_wait.lock);
+	spin_unlock_irqrestore(&ic->endio_wait.lock, flags);
+
 	queue_work(ic->commit_wq, &ic->commit_work);
 }
 
