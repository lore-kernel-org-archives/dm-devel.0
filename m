From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [dm-devel] [PATCH] block: flush queued bios when the process
 blocks
Date: Tue, 27 May 2014 12:59:54 -0700
Message-ID: <20140527195954.GF2276@kmo>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com>
 <5384AA79.4010206@kernel.dk>
 <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com>
 <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com>
 <5384CE82.90601@kernel.dk>
 <20140527181415.GA8739@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140527181415.GA8739@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, May 27, 2014 at 11:14:15AM -0700, Christoph Hellwig wrote:
> On Tue, May 27, 2014 at 11:42:26AM -0600, Jens Axboe wrote:
> > Except such a thing already exists, there are unplug callback
> > chains. All I'm asking is that you look into how feasible it would
> > be to use something like that, instead of reinventing the wheel.
> 
> I suspect the code from MD could be lifted quite easily.
> 
> It would be nicer to move it up to the block layer entirely, but when I
> tried that a while ago I ran into issues that I unfortunately don't
> remember.

How's md do it?
