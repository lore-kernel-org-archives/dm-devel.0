From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] blk-lib: fix error reporting
Date: Tue, 8 Jul 2014 09:05:05 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407080859370.27276@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407031514320.3347@file01.intranet.prod.int.rdu2.redhat.com> <20140708095038.GA31180@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140708095038.GA31180@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Tue, 8 Jul 2014, Christoph Hellwig wrote:

> > +	if (unlikely(err))
> > +		ACCESS_ONCE(bb->error) = err;
> 
> I can't see a reason for the ACCESS_ONCE here.

Multiple bios can be completed concurrently, so they write bb->error at 
the same time. The compiler may do store tearing (see "store tearing" in 
Documentation/memory-barriers.txt) - it may split one 4-byte write into 
several smaller writes - and it could result in setting bb->error to 
invalid value. We need ACCESS_ONCE to make sure that store tearing doesn't 
happen.

Mikulas

> Also the likely/unlikely annotations here smell like premature
> optimization.
> 
> Otherwise looks good to me.
