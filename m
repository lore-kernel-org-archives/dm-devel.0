From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] [PATCH 1/2] blkdev: fix merge_bvec_fn return value
	checks
Date: Thu, 4 Mar 2010 13:19:31 +0100
Message-ID: <20100304121931.GB5768@kernel.dk>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org> <20100228184634.GI5768@kernel.dk> <874okyf4iw.fsf@openvz.org> <170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com> <87wrxtkzwu.fsf@openvz.org> <20100303191613.GB18480@redhat.com> <87lje9kx9i.fsf@openvz.org> <20100303200734.GW5768@kernel.dk> <Pine.LNX.4.64.1003040629230.990@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003040629230.990@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Thu, Mar 04 2010, Mikulas Patocka wrote:
> 
> 
> On Wed, 3 Mar 2010, Jens Axboe wrote:
> 
> > On Wed, Mar 03 2010, Dmitry Monakhov wrote:
> > > Mike Snitzer <snitzer@redhat.com> writes:
> > > 
> > > > Linux has all sorts of internal interfaces that are "odd"... the current
> > > > 'q->merge_bvec_fn' interface included.  But odd is not a problem (nor is
> > > > it "broken") unless you make changes that don't consider how the current
> > > > interface is defined.
> > > Ok. then cant you please explain more historical questions
> > > 1) Why bio_add_page() can not add less data than requested?
> > >    Seems that it doesn't make caller's code much complicate
> > >    Off course barrier bio is special case. I don't consider it here.
> > 
> > Because the caller may not expect that, a partial add may not make any
> > sense to the caller. The bio code obviously doesn't care. And it
> > certainly could complicate the caller a lot, if they need to now issue
> > and wait for several bio's instead of just a single one. Now a single
> > completion queue and wait_for_completion() is not enough.
> 
> The whole thing is lame by design.
> 
> As a consequence, the code for splitting these page-sized bios is being 
> duplicated in md, dm and request-based device (and maybe in other drivers).
> 
> And there is a long standing unfixable bug --- adding a device to raid1 
> may fail if the device has smaller request size than the other raid1 leg.
> Think about this:
> 
> * thread 1:
> bio_add_page() -> returns ok
> ...
> bio_add_page() -> returns ok
> * scheduling to thread 2 *
> * thread 2:
> add a raid1 leg to the block device
> * scheduling to thread 1 *
> * thread 1:
> submit_bio() --- the bio already oversized for the new raid1 leg and there 
> is no way to shrink it.
> 
> 
> I think it should be redesigned in this way:
> * the bio should be allowed to have arbitrary size, up to BIO_MAX_PAGES
> * the code for splitting bios should be just at one place --- in the 
> generic block layer and it should work with all drivers. I.e.
> q->make_request_fn will return that the request is too big for the given 
> driver and the generic code will allocate few another bios from 
> per-request_queue mempool and split the bio.
> * then, we would fix the raid1 bug and we would also simplify md and dm 
> --- remove the splitting code.

The design certainly isn't perfect, but neither is the one that you
suggest. For instance, what would the point of building bigger bios just
to split them _everytime_ be? That's not good design, and it's certainly
not helping performance much.

Alasdair had an idea for doing a map/unmap like interface instead, which
I think is a lot better. I don't think he ever coded it up, though.
Perhaps talk to him, if you want to improve our situation in this area.

-- 
Jens Axboe
