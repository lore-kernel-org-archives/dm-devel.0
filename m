From: Christoph Hellwig <hch@infradead.org>
Subject: REQ_OP for zeroing, was Re: [dm-devel] [PATCH 1/4] brd: handle
 misaligned discard
Date: Wed, 26 Oct 2016 14:50:52 -0700
Message-ID: <20161026215052.GA11679@infradead.org>
References: <20161021200022.GA12580@redhat.com>
 <alpine.LRH.2.02.1610211616450.31606@file01.intranet.prod.int.rdu2.redhat.com>
 <20161024155756.GA48306@redhat.com>
 <20161025130712.GA12717@infradead.org>
 <20161025143719.GA51266@redhat.com>
 <710b07a3-9091-6935-37c4-ea1dcedcab4f@kernel.dk>
 <alpine.LRH.2.02.1610261624100.12287@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1610261625580.12287@file01.intranet.prod.int.rdu2.redhat.com>
 <338b76f0-40d1-904f-66e0-f6455c5287e7@sandisk.com>
 <alpine.LRH.2.02.1610261733190.25893@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1610261733190.25893@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Wed, Oct 26, 2016 at 05:46:11PM -0400, Mikulas Patocka wrote:
> I think the proper thing would be to move "discard_zeroes_data" flag into 
> the bio itself - there would be REQ_OP_DISCARD and REQ_OP_DISCARD_ZERO - 
> and if the device doesn't support REQ_OP_DISCARD_ZERO, it rejects the bio 
> and the caller is supposed to do zeroing manually.

Yes, Martin and I have come to a similar conclusion recently.  An
additional aspect is that NVMe has a Write Zeroes command which is more
limited than what REQ_OP_WRITE_SAME does.

So I think the right way is to add a REQ_OP_WRITE_ZEROES (or
REQ_OP_ZERO) and have modifies if it may discard or not.
