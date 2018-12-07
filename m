From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm crypt: fix lost ioprio when queuing crypto bios
 from task with ioprio
Date: Fri, 7 Dec 2018 15:20:30 -0500
Message-ID: <20181207202029.GA21823@redhat.com>
References: <20181206221507.5423-1-snitzer@redhat.com>
	<20181207194319.GA1690@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181207194319.GA1690@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, Eric Wheeler <dm-devel@lists.ewheeler.net>
List-Id: dm-devel.ids

On Fri, Dec 07 2018 at  2:43pm -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Dec 06, 2018 at 05:15:07PM -0500, Mike Snitzer wrote:
> > From: Eric Wheeler <dm-devel@lists.ewheeler.net>
> > 
> > Since dm-crypt queues writes (and sometimes reads) to a different kernel
> > thread (workqueue), the bios will dispatch from tasks with different
> > io_context->ioprio settings than the submitting task, thus giving
> > incorrect ioprio hints to the io scheduler.
> > 
> > By assigning the ioprio to the bio before queuing to a workqueue, the
> > original submitting task's io_context->ioprio setting can be retained
> > through the life of the bio.  We only set the bio's ioprio in dm-crypt
> > if not already set (by somewhere else, higher in the stack).
> 
> The scheme looks a little odd to me.  Instead of requring a driver
> call why don't we just make sure bios always have the submitting
> tasks priority set and then make sure the lower layers can rely on it?

The original patch from Eric was from 2 years ago when
__bio_clone_fast() didn't even copy over the ioprio from the src bio:
https://patchwork.kernel.org/patch/9474535/

So the 2 hunks from that original patch that did the copying of the
ioprio (__bio_clone_fast and clone_init) are no longer needed.

Leaving only these changes as in doubt:

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 509fb20f7f86..ce8f03f52433 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2916,10 +2916,16 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
                io->ctx.r.req = (struct skcipher_request *)(io + 1);

        if (bio_data_dir(io->base_bio) == READ) {
-               if (kcryptd_io_read(io, GFP_NOWAIT))
+               if (kcryptd_io_read(io, GFP_NOWAIT)) {
+                       if (!ioprio_valid(bio_prio(io->base_bio)))
+                               bio_set_prio_from_current(io->base_bio);
                        kcryptd_queue_read(io);
-       } else
+               }
+       } else {
+               if (!ioprio_valid(bio_prio(io->base_bio)))
+                       bio_set_prio_from_current(io->base_bio);
                kcryptd_queue_crypt(io);
+       }

        return DM_MAPIO_SUBMITTED;
 }

I need to look closer at _why_ io->base_bio wouldn't have inherited the
submitting task's ioprio....

Looks like the 2yr old need for the above was simply due to
__bio_clone_fast() not copying over the ioprio.  Because crypt_io_init()
assigns the cloned bio, that DM core sent crypt_map(), to io->base_bio.
Since io->base_bio is a clone it will have been assigned the original
bio's ioprio.  Leaving only remaining question being whether that
original bio had its ioprio previously set?

In this case, bcache appears to be only caller of bio_set_prio(), so for
the bcache on dm-crypt case Eric cares about dm-crypt _should_ inherit
bcache's ioprio.

Long story short: you're correct (driver shouldn't need to do this) and
thankfully it looks like latest upstream code should work fine -- though
I've not tested it to verify.

Eric, it has been a long time since you had a need for these ioprio
changes, to benefit bcache stacked on dm-crypt, but if you still have an
issue with ioprio not being set (or not being from submitting task)
please let us know.

Thanks,
Mike
