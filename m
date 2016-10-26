From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/4] brd: support discard
Date: Wed, 26 Oct 2016 16:25:51 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1610261624100.12287@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1610211406290.9197@file01.intranet.prod.int.rdu2.redhat.com> <20161021200022.GA12580@redhat.com> <alpine.LRH.2.02.1610211616450.31606@file01.intranet.prod.int.rdu2.redhat.com> <20161024155756.GA48306@redhat.com>
 <20161025130712.GA12717@infradead.org> <20161025143719.GA51266@redhat.com> <710b07a3-9091-6935-37c4-ea1dcedcab4f@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <710b07a3-9091-6935-37c4-ea1dcedcab4f@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, linux-block@vger.kernel.org
List-Id: dm-devel.ids



On Tue, 25 Oct 2016, Jens Axboe wrote:

> On 10/25/2016 08:37 AM, Mike Snitzer wrote:
> > On Tue, Oct 25 2016 at  9:07P -0400,
> > Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > > I think the right fix is to kill off the BLKFLSBUF special case in
> > > brd.  Yes, it break compatibility - but in this case the compatibility
> > > breaks more than it helps.
> > 
> > Jens, please pick up this patch:
> > 
> > From: Mike Snitzer <snitzer@redhat.com>
> > Date: Tue, 25 Oct 2016 10:25:07 -0400
> > Subject: [PATCH] brd: remove support for BLKFLSBUF
> 
> Added, thanks.
> 
> -- 
> Jens Axboe

Hi

With the removal of BLKFLSBUF, there is no way to free memory allocated by 
ramdisk, so I created these 4 patches that add DISCARD support for 
ramdisk.

Mikulas
