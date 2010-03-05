From: Neil Brown <neilb@suse.de>
Subject: Re: [dm-devel] [PATCH 1/2] blkdev: fix merge_bvec_fn return value
 checks
Date: Sat, 6 Mar 2010 08:56:51 +1100
Message-ID: <20100306085651.1a571571@notabene.brown>
References: <20100228184634.GI5768@kernel.dk>
	<874okyf4iw.fsf@openvz.org>
	<170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
	<87wrxtkzwu.fsf@openvz.org>
	<20100303191613.GB18480@redhat.com>
	<87lje9kx9i.fsf@openvz.org>
	<20100303200734.GW5768@kernel.dk>
	<Pine.LNX.4.64.1003040629230.990@hs20-bc2-1.build.redhat.com>
	<20100304121931.GB5768@kernel.dk>
	<Pine.LNX.4.64.1003041615120.17032@hs20-bc2-1.build.redhat.com>
	<20100305073059.GI5768@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100305073059.GI5768@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: jens.axboe@oracle.com, Mikulas Patocka <mpatocka@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, 5 Mar 2010 08:30:59 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Mar 04 2010, Mikulas Patocka wrote:
> > > > I think it should be redesigned in this way:
> > > > * the bio should be allowed to have arbitrary size, up to BIO_MAX_PAGES
> > > > * the code for splitting bios should be just at one place --- in the 
> > > > generic block layer and it should work with all drivers. I.e.
> > > > q->make_request_fn will return that the request is too big for the given 
> > > > driver and the generic code will allocate few another bios from 
> > > > per-request_queue mempool and split the bio.
> > > > * then, we would fix the raid1 bug and we would also simplify md and dm 
> > > > --- remove the splitting code.
> > > 
> > > The design certainly isn't perfect, but neither is the one that you
> > > suggest. For instance, what would the point of building bigger bios just
> > > to split them _everytime_ be? That's not good design, and it's certainly
> > > not helping performance much.
> > 
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
> 
> The point is not to build it too big to begin with, and keep the
> splitting as the slow path. That's how it was originally designed, and
> it'll surely stay that way. Doing the split handling in generic code is
> a good idea, it definitely should be. But I'm never going to make
> splitting a normal part of IO operations just because we allow
> arbitrarily large bios, sorry but that's insane.

I think that where-ever we put the splitting there is a lot to be gained by
make it easier to split things.

It is a while since I looked closely at this (about 30 months) but last time
I looked, low level devices were allowed to modify the bi_iovec.  This means
that a split has to copy the iovec as well as the bio which significantly
increased the complexity.  If we stored an index into the current bio in
'struct request' rather than using bi_idx plus modifying bv_offset, then I
think we could make bi_iovec read-only and simplify splitting significantly.

I have some patches that did this, but they are very old.  I could probably
refresh them if there was interest.


My preferred end-game would be to allow a bio of any size to be submitted to
any device.  The device would be responsible for cutting it up if necessary.
For the elevator code, I wouldn't bother making new bios, but would teach
'struct request' to be able to reference part of a bio.  So in the general
case, a 'request' would point to a list of bios, but would exclude a prefix
of the first and a suffix of the last. A single bio could then be referenced
by multiple requests if necessary.

It would probably make sense to include a 'max_sectors' concept to discourage
large bios as doing that would probably allow things to run more smoothly
in general.  But if this were a hint rather than a requirement then I think
it would make life a lot easier for a lot of code.

NeilBrown
