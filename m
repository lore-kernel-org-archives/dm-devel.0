From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/4] brd: handle misaligned discard
Date: Wed, 26 Oct 2016 17:46:11 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1610261733190.25893@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1610211406290.9197@file01.intranet.prod.int.rdu2.redhat.com> <20161021200022.GA12580@redhat.com> <alpine.LRH.2.02.1610211616450.31606@file01.intranet.prod.int.rdu2.redhat.com> <20161024155756.GA48306@redhat.com>
 <20161025130712.GA12717@infradead.org> <20161025143719.GA51266@redhat.com> <710b07a3-9091-6935-37c4-ea1dcedcab4f@kernel.dk> <alpine.LRH.2.02.1610261624100.12287@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1610261625580.12287@file01.intranet.prod.int.rdu2.redhat.com>
 <338b76f0-40d1-904f-66e0-f6455c5287e7@sandisk.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <338b76f0-40d1-904f-66e0-f6455c5287e7@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids



On Wed, 26 Oct 2016, Bart Van Assche wrote:

> On 10/26/2016 01:26 PM, Mikulas Patocka wrote:
> > The brd driver refuses misaligned discard requests with an error. However,
> > this is suboptimal, misaligned requests could be handled by discarding a
> > part of the request that is aligned on a page boundary. This patch changes
> > the code so that it handles misaligned requests.
> 
> Hello Mikulas,
> 
> We do not want this kind of discard request processing in every block driver.
> This is why I think that this kind of processing should be added to the block
> layer. See also "[PATCH v3 0/5] Make blkdev_issue_discard() submit aligned
> discard requests" (http://www.spinics.net/lists/linux-block/msg02360.html).
> 
> Bart.

I don't like the idea of complicating the code by turning discards into 
writes. You can just turn off the flag "discard_zeroes_data" and drop all 
the splitting code.

The flag "discard_zeroes_data" is actually misdesigned, because the 
storage stack can change dynamically while bios are in progress. You can 
send a discard bio to a device mapper device that has 
"discard_zeroes_data" - and while the bio is in progress, the device 
mapper stack can be reconfigured to redirect the bio to another device 
that doesn't have "discard_zeroes_data" - and the bio won't zero data and 
the caller that issued it has no way to find it out.

I think the proper thing would be to move "discard_zeroes_data" flag into 
the bio itself - there would be REQ_OP_DISCARD and REQ_OP_DISCARD_ZERO - 
and if the device doesn't support REQ_OP_DISCARD_ZERO, it rejects the bio 
and the caller is supposed to do zeroing manually.

Mikulas
