From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -stable] block: destroy bdi before blockdev is
 unregistered.
Date: Wed, 29 Apr 2015 18:02:58 +0200
Message-ID: <20150429160258.GK17717@twins.programming.kicks-ass.net>
References: <20150414171537.GH25394@azat>
 <20150423160551.45345f96@notabene.brown>
 <20150427141222.5dac22f1@notabene.brown>
 <CAMM=eLf2aFFH29xeDVrS7beFj6T8kqUQRh=4KB1YO0kWGa7Rog@mail.gmail.com>
 <20150429072530.39d38b00@notabene.brown>
 <20150429133512.GA4436@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150429133512.GA4436@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>, Azat Khuzhin <a3at.mail@gmail.com>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Apr 29, 2015 at 03:35:12PM +0200, Christoph Hellwig wrote:
> On Wed, Apr 29, 2015 at 07:25:30AM +1000, NeilBrown wrote:
> > As bdi_set_min_ratio doesn't touch bdi->dev, there seems to be no need for
> > the test, or the warning.
> > 
> > I wonder if it would make sense to move the bdi_set_min_ratio() call to
> > bdi_destroy, and discard bdi_unregister??
> > There is a comment which suggests bdi_unregister might be of use later, but
> > it might be best to have a clean slate in which to add whatever might be
> > needed??
> 
> This seems fine to me from the block dev point of view.  I don't really
> understand the bdi_min_ratio logic, but Peter might have a better idea.

Ah, that was a bit of digging, I've not looked at that in ages :-)

So if you look at bdi_dirty_limit()'s comment:

 * The bdi's share of dirty limit will be adapting to its throughput and
 * bounded by the bdi->min_ratio and/or bdi->max_ratio parameters, if set.

So the min_ratio is a minimum guaranteed fraction of the total
throughput.

Now the problem before commit ccb6108f5b0b ("mm/backing-dev.c: reset bdi
min_ratio in bdi_unregister()") was that since bdi_set_min_ratio()
keeps a global sum of bdi->min_ratio, you need to subtract from said
global sum when taking the BDI away. Otherwise we loose/leak a fraction
of the total throughput available (to the other BDIs).

Which is what that bdi_set_min_ratio(bdi, 0) in unregister does. It
resets the min_ratio for the bdi being taken out and frees up the min
allocated bandwidth for the others.

So I think moving that do destroy would be fine; assuming the delay
between unregister and destroy is typically 'short'. Because without
that you can 'leak' this min ratio for extended periods which means the
bandwidth is unavailable for other BDIs.

Does that make sense?
