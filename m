From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [dm-devel] [PATCH] blk-lib: fix error reporting
Date: Tue, 08 Jul 2014 07:04:06 -0700
Message-ID: <1404828246.1967.8.camel@jarvis.lan>
References: <alpine.LRH.2.02.1407031514320.3347@file01.intranet.prod.int.rdu2.redhat.com>
	 <20140708095038.GA31180@infradead.org>
	 <alpine.LRH.2.02.1407080859370.27276@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1407080859370.27276@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, 2014-07-08 at 09:05 -0400, Mikulas Patocka wrote:
> 
> On Tue, 8 Jul 2014, Christoph Hellwig wrote:
> 
> > > +	if (unlikely(err))
> > > +		ACCESS_ONCE(bb->error) = err;
> > 
> > I can't see a reason for the ACCESS_ONCE here.
> 
> Multiple bios can be completed concurrently, so they write bb->error at 
> the same time. The compiler may do store tearing (see "store tearing" in 
> Documentation/memory-barriers.txt) - it may split one 4-byte write into 
> several smaller writes - and it could result in setting bb->error to 
> invalid value. We need ACCESS_ONCE to make sure that store tearing doesn't 
> happen.

That's not correct, because it's not applicable in this case.  Tearing
may occur on misalignment (which ACCESS_ONCE() cannot rectify because
it's architectural), short constant loads (again, usually architectural)
and structure copies, none of which applies here.

We can rely on a properly aligned 32 bit write being atomic.

James
