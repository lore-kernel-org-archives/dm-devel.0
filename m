From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REQ_OP for zeroing, was Re: [dm-devel] [PATCH 1/4] brd: handle
 misaligned discard
Date: Fri, 28 Oct 2016 06:14:57 -0700
Message-ID: <20161028131457.GA15656@infradead.org>
References: <20161024155756.GA48306@redhat.com>
 <20161025130712.GA12717@infradead.org>
 <20161025143719.GA51266@redhat.com>
 <710b07a3-9091-6935-37c4-ea1dcedcab4f@kernel.dk>
 <alpine.LRH.2.02.1610261624100.12287@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1610261625580.12287@file01.intranet.prod.int.rdu2.redhat.com>
 <338b76f0-40d1-904f-66e0-f6455c5287e7@sandisk.com>
 <alpine.LRH.2.02.1610261733190.25893@file01.intranet.prod.int.rdu2.redhat.com>
 <20161026215052.GA11679@infradead.org>
 <alpine.LRH.2.02.1610280741350.22676@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1610280741350.22676@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
List-Id: dm-devel.ids

[adding Chaitanya to Cc]

On Fri, Oct 28, 2016 at 07:43:41AM -0400, Mikulas Patocka wrote:
> We could detect if the REQ_OP_WRITE_SAME command contains all zeroes and 
> if it does, turn it into "Write Zeroes" or TRIM command (if the device 
> guarantees zeroing on trim). If it doesn't contain all zeroes and the 
> device doesn't support non-zero WRITE SAME, then reject it.

I don't like this because it's very inefficient - we have to allocate
a payload first and then compare the whole payload for very operation.

> Or maybe we could add a new command REQ_OP_WRITE_ZEROES - I'm not sure 
> which of these two possibilities is better.

Chaitanya actually did an initial prototype implementation of this for
NVMe that he shared with me.  I liked it a lot and I think he'll be
ready to post it in a few days.  Now that we have the REQ_OP* values
instead of mapping different command types to flags it's actually
surprisingly easy to add new block layer operations.
