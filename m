From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/2] blkdev: fix merge_bvec_fn return value
 checks
Date: Thu, 4 Mar 2010 16:55:29 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1003041615120.17032@hs20-bc2-1.build.redhat.com>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
 <20100228184634.GI5768@kernel.dk> <874okyf4iw.fsf@openvz.org>
 <170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
 <87wrxtkzwu.fsf@openvz.org> <20100303191613.GB18480@redhat.com>
 <87lje9kx9i.fsf@openvz.org> <20100303200734.GW5768@kernel.dk>
 <Pine.LNX.4.64.1003040629230.990@hs20-bc2-1.build.redhat.com>
 <20100304121931.GB5768@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100304121931.GB5768@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

> > I think it should be redesigned in this way:
> > * the bio should be allowed to have arbitrary size, up to BIO_MAX_PAGES
> > * the code for splitting bios should be just at one place --- in the 
> > generic block layer and it should work with all drivers. I.e.
> > q->make_request_fn will return that the request is too big for the given 
> > driver and the generic code will allocate few another bios from 
> > per-request_queue mempool and split the bio.
> > * then, we would fix the raid1 bug and we would also simplify md and dm 
> > --- remove the splitting code.
> 
> The design certainly isn't perfect, but neither is the one that you
> suggest. For instance, what would the point of building bigger bios just
> to split them _everytime_ be? That's not good design, and it's certainly
> not helping performance much.

The point for building a big bio and splitting it is code size reduction.

You must realize that you need to split the request anyway. If the caller 
needs to read/write M sectors and the device can process at most N 
sectors, where N<M, then the i/o must be split. You can't get rid of that 
split.

Now, the question is, where this splitting happens. Currently, the 
splitting happens in the issuers of the bio (for example dm-io, which is a 
big chunk of code written just to work around the uncertain bio size 
limits) as well as in the consumers of the bio (md, dm and request-based 
drivers, if their maximum transfer size < PAGE_SIZE).

What I'm proposing is to put that bio splitting just in one place and 
remove it from both the issuers and the consumers of the bio.

There is just one case, where it is not desirable to create larger 
requests than the physical transfer size because of performance --- that 
is page cache readahead. That could use the current approach of querying 
the queue for limits and not stuffing more data than the device can 
handle.

In all the other (non-readahead) cases, the caller is waiting for all the 
data anyway, there is no performance problem with creating a larger 
requests and splitting them.

> Alasdair had an idea for doing a map/unmap like interface instead, which
> I think is a lot better. I don't think he ever coded it up, though.
> Perhaps talk to him, if you want to improve our situation in this area.

It would increase code size, not reduce it.

> -- 
> Jens Axboe

BTW. see fs/bio.c:bio_split --- it uses a shared mempool. It can deadlock 
if the devices depend on each other. You need to use per-queue mempool.

Mikulas
