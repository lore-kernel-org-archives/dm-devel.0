From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/3] dm: add support for passing through inline crypto
 support
Date: Thu, 24 Sep 2020 10:23:54 -0400
Message-ID: <20200924142353.GC13849@redhat.com>
References: <20200909234422.76194-1-satyat@google.com>
 <20200909234422.76194-3-satyat@google.com>
 <20200924012103.GE10500@redhat.com>
 <20200924073842.GA1894729@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200924073842.GA1894729@google.com>
To: Satya Tangirala <satyat@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 24 2020 at  3:38am -0400,
Satya Tangirala <satyat@google.com> wrote:

> On Wed, Sep 23, 2020 at 09:21:03PM -0400, Mike Snitzer wrote:
> > On Wed, Sep 09 2020 at  7:44pm -0400,
> > Satya Tangirala <satyat@google.com> wrote:
> > 
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Update the device-mapper core to support exposing the inline crypto
> > > support of the underlying device(s) through the device-mapper device.
> > > 
> > > This works by creating a "passthrough keyslot manager" for the dm
> > > device, which declares support for encryption settings which all
> > > underlying devices support.  When a supported setting is used, the bio
> > > cloning code handles cloning the crypto context to the bios for all the
> > > underlying devices.  When an unsupported setting is used, the blk-crypto
> > > fallback is used as usual.
> > > 
> > > Crypto support on each underlying device is ignored unless the
> > > corresponding dm target opts into exposing it.  This is needed because
> > > for inline crypto to semantically operate on the original bio, the data
> > > must not be transformed by the dm target.  Thus, targets like dm-linear
> > > can expose crypto support of the underlying device, but targets like
> > > dm-crypt can't.  (dm-crypt could use inline crypto itself, though.)
> > > 
> > > When a key is evicted from the dm device, it is evicted from all
> > > underlying devices.
> > > 
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > Co-developed-by: Satya Tangirala <satyat@google.com>
> > > Signed-off-by: Satya Tangirala <satyat@google.com>
> > > ---
> > >  block/blk-crypto.c              |  1 +
> > >  block/keyslot-manager.c         | 34 ++++++++++++
> > >  drivers/md/dm-core.h            |  4 ++
> > >  drivers/md/dm-table.c           | 52 +++++++++++++++++++
> > >  drivers/md/dm.c                 | 92 ++++++++++++++++++++++++++++++++-
> > >  include/linux/device-mapper.h   |  6 +++
> > >  include/linux/keyslot-manager.h |  7 +++
> > >  7 files changed, 195 insertions(+), 1 deletion(-)
> > > 

> > > diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> > > index c4ef1fceead6..4542050eebfc 100644
> > > --- a/drivers/md/dm-core.h
> > > +++ b/drivers/md/dm-core.h
> > > @@ -12,6 +12,7 @@
> > >  #include <linux/kthread.h>
> > >  #include <linux/ktime.h>
> > >  #include <linux/blk-mq.h>
> > > +#include <linux/keyslot-manager.h>
> > >  
> > >  #include <trace/events/block.h>
> > >  
> > > @@ -49,6 +50,9 @@ struct mapped_device {
> > >  
> > >  	int numa_node_id;
> > >  	struct request_queue *queue;
> > > +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> > > +	struct blk_keyslot_manager ksm;
> > > +#endif
> > >  
> > >  	atomic_t holders;
> > >  	atomic_t open_count;
> > 
> > Any reason you placed the ksm member where you did?
> > 
> > Looking at 'struct blk_keyslot_manager' I'm really hating adding that
> > bloat to every DM device for a feature that really won't see much broad
> > use (AFAIK).
> > 
> > Any chance you could allocate 'struct blk_keyslot_manager' as needed so
> > that most users of DM would only be carrying 1 extra pointer (set to
> > NULL)?
>
> I don't think there's any technical problem with doing that - the only
> other thing that would need addressing is that the patch uses
> "container_of" on that blk_keyslot_manager in dm_keyslot_evict() to get
> a pointer to the struct mapped_device. I could try adding a "private"
> field to struct blk_keyslot_manager and store a pointer to the struct
> mapped_device there).

Yes, that'd be ideal.

As for the lifetime of the struct blk_keyslot_manager pointer DM would
manage (in your future code revision): you meantioned in one reply that
the request_queue takes care of setting up the ksm... but the ksm
is tied to the queue at a later phase using blk_ksm_register(). 

In any case, I think my feature reequest (to have DM allocate the ksm
struct only as needed) is a bit challenging because of how DM allocates
the request_queue upfront in alloc_dev() and then later completes the
request_queue initialization based on DM_TYPE* in dm_setup_md_queue().

It _could_ be that you'll need to add a new DM_TYPE_KSM_BIO_BASED or
something.  But you have a catch-22 in that the dm-table.c code to
establish the intersection of supported modes assumes ksm is already
allocated.  So something needs to give by reasoning through: _what_ is
the invariant that will trigger the delayed allocation of the ksm
struct?  I don't yet see how you can make that informed decision that
the target(s) in the DM table _will_ use the ksm if it exists.

But then once the ksm is allocated, it never gets allocated again
because md->queue->ksm is already set, and it inherits the lifetime that
is used when destroying the mapped_device (md->queue, etc).

Mike
