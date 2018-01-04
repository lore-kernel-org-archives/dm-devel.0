From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm bufio: fix shrinker scans when (nr_to_scan < retain_target)
Date: Thu, 4 Jan 2018 14:27:05 -0500
Message-ID: <20180104192704.GA14811@redhat.com>
References: <20171206172730.3095-1-surenb@google.com>
 <CAJuCfpGPLvF0Z7La4Gq2zjSHS1+CDnXBgn6X60pjEQ_pCkqoYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJuCfpGPLvF0Z7La4Gq2zjSHS1+CDnXBgn6X60pjEQ_pCkqoYg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suren Baghdasaryan <surenb@google.com>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Todd Kjos <tkjos@google.com>, Tim Murray <timmurray@google.com>
List-Id: dm-devel.ids

This was already included as of v4.15-rc4 via commit fbc7c07ec2 ("dm
bufio: fix shrinker scans when (nr_to_scan < retain_target)")

I even cc'd you on the relevant pull request that I sent to Linus, see:
https://www.redhat.com/archives/dm-devel/2017-December/msg00119.html

Mike

On Thu, Jan 04 2018 at  2:04pm -0500,
Suren Baghdasaryan <surenb@google.com> wrote:

> Dear kernel maintainers. I know it was close to holiday season when I
> send this patch last month, so delay was expected. Could you please
> take a look at it and provide your feedback?
> Thanks!
> 
> On Wed, Dec 6, 2017 at 9:27 AM, Suren Baghdasaryan <surenb@google.com> wrote:
> > When system is under memory pressure it is observed that dm bufio
> > shrinker often reclaims only one buffer per scan. This change fixes
> > the following two issues in dm bufio shrinker that cause this behavior:
> >
> > 1. ((nr_to_scan - freed) <= retain_target) condition is used to
> > terminate slab scan process. This assumes that nr_to_scan is equal
> > to the LRU size, which might not be correct because do_shrink_slab()
> > in vmscan.c calculates nr_to_scan using multiple inputs.
> > As a result when nr_to_scan is less than retain_target (64) the scan
> > will terminate after the first iteration, effectively reclaiming one
> > buffer per scan and making scans very inefficient. This hurts vmscan
> > performance especially because mutex is acquired/released every time
> > dm_bufio_shrink_scan() is called.
> > New implementation uses ((LRU size - freed) <= retain_target)
> > condition for scan termination. LRU size can be safely determined
> > inside __scan() because this function is called after dm_bufio_lock().
> >
> > 2. do_shrink_slab() uses value returned by dm_bufio_shrink_count() to
> > determine number of freeable objects in the slab. However dm_bufio
> > always retains retain_target buffers in its LRU and will terminate
> > a scan when this mark is reached. Therefore returning the entire LRU size
> > from dm_bufio_shrink_count() is misleading because that does not
> > represent the number of freeable objects that slab will reclaim during
> > a scan. Returning (LRU size - retain_target) better represents the
> > number of freeable objects in the slab. This way do_shrink_slab()
> > returns 0 when (LRU size < retain_target) and vmscan will not try to
> > scan this shrinker avoiding scans that will not reclaim any memory.
> >
> > Test: tested using Android device running
> > <AOSP>/system/extras/alloc-stress that generates memory pressure
> > and causes intensive shrinker scans
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  drivers/md/dm-bufio.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> > index b8ac591aaaa7..c546b567f3b5 100644
> > --- a/drivers/md/dm-bufio.c
> > +++ b/drivers/md/dm-bufio.c
> > @@ -1611,7 +1611,8 @@ static unsigned long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
> >         int l;
> >         struct dm_buffer *b, *tmp;
> >         unsigned long freed = 0;
> > -       unsigned long count = nr_to_scan;
> > +       unsigned long count = c->n_buffers[LIST_CLEAN] +
> > +                             c->n_buffers[LIST_DIRTY];
> >         unsigned long retain_target = get_retain_buffers(c);
> >
> >         for (l = 0; l < LIST_SIZE; l++) {
> > @@ -1647,8 +1648,11 @@ static unsigned long
> >  dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
> >  {
> >         struct dm_bufio_client *c = container_of(shrink, struct dm_bufio_client, shrinker);
> > +       unsigned long count = READ_ONCE(c->n_buffers[LIST_CLEAN]) +
> > +                             READ_ONCE(c->n_buffers[LIST_DIRTY]);
> > +       unsigned long retain_target = get_retain_buffers(c);
> >
> > -       return READ_ONCE(c->n_buffers[LIST_CLEAN]) + READ_ONCE(c->n_buffers[LIST_DIRTY]);
> > +       return (count < retain_target) ? 0 : (count - retain_target);
> >  }
> >
> >  /*
> > --
> > 2.15.0.531.g2ccb3012c9-goog
> >
