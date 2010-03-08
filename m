From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/2] blkdev: fix merge_bvec_fn return value
 checks
Date: Mon, 8 Mar 2010 04:01:18 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1003080344390.25635@hs20-bc2-1.build.redhat.com>
References: <20100228184634.GI5768@kernel.dk> <874okyf4iw.fsf@openvz.org>
 <170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
 <87wrxtkzwu.fsf@openvz.org> <20100303191613.GB18480@redhat.com>
 <87lje9kx9i.fsf@openvz.org> <20100303200734.GW5768@kernel.dk>
 <Pine.LNX.4.64.1003040629230.990@hs20-bc2-1.build.redhat.com>
 <20100304121931.GB5768@kernel.dk> <Pine.LNX.4.64.1003041615120.17032@hs20-bc2-1.build.redhat.com>
 <20100305073059.GI5768@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100305073059.GI5768@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

> > The point for building a big bio and splitting it is code size reduction.
> > 
> > You must realize that you need to split the request anyway. If the caller 
> > needs to read/write M sectors and the device can process at most N 
> > sectors, where N<M, then the i/o must be split. You can't get rid of that 
> > split.
> 
> If we consider the basic (and mosted used) file system IO path, then
> those 'M' sectors will usually be submitted in units that are smaller
> than 'N' anyway. It would be silly to allocate a bio for 'N' sectors
> (those get big), only to split it up again shortly.

I agree that majority of IOs are page cache reads/writes and they 
shouldn't be split.

> The point is not to build it too big to begin with, and keep the
> splitting as the slow path. That's how it was originally designed, and
> it'll surely stay that way. Doing the split handling in generic code is
> a good idea, it definitely should be. But I'm never going to make
> splitting a normal part of IO operations just because we allow
> arbitrarily large bios, sorry but that's insane.
>
> > There is just one case, where it is not desirable to create larger 
> > requests than the physical transfer size because of performance --- that 
> > is page cache readahead. That could use the current approach of querying 
> > the queue for limits and not stuffing more data than the device can 
> > handle.
> > 
> > In all the other (non-readahead) cases, the caller is waiting for all the 
> > data anyway, there is no performance problem with creating a larger 
> > requests and splitting them.
> 
> But this I still think is crazy, sorry.

It doesn't look crazy to me:

Case 1: the caller constructs a request to dm-io. Dm-io allocates its 
internal structure, splits the request into several bios, submits them, 
waits for them, calls the completion routing when they all finish.

Case 2: the caller constructs a big bio (without care about device 
limits), submits it to the block layer, the block layer splits the bio 
into several smaller bios (it doesn't even have to allocate the vector if 
it splits at page boundaries), submits the smaller bios to the device, 
when they finish, signals the completion of the big bio.

Now tell me, why do you think that "Case 1" is better than "Case 2"? If 
the bio gets split, you get exactly the same number of allocations in both 
cases. If the bio isn't split, "Case 2" is even better (it saves dm-io 
overhead).

> > > Alasdair had an idea for doing a map/unmap like interface instead, which
> > > I think is a lot better. I don't think he ever coded it up, though.
> > > Perhaps talk to him, if you want to improve our situation in this area.
> > 
> > It would increase code size, not reduce it.
> 
> What kind of answer is that?

If you increase code size in the interface, you make the interface more 
complex and any further changes will be harder. It kills the software 
slowly.

> > BTW. see fs/bio.c:bio_split --- it uses a shared mempool. It can deadlock 
> > if the devices depend on each other. You need to use per-queue mempool.
> 
> Only if you need to split the same original bio twice on the same IO
> path.

It may happen if you use stacked MD devices with different small stripe 
sizes. But it's not common because people usually set stripe size as a 
multiple of page size.

Mikulas

> -- 
> Jens Axboe
> 
