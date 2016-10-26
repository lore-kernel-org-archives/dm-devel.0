From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] [PATCH 1/4] brd: handle misaligned discard
Date: Wed, 26 Oct 2016 13:38:50 -0700
Message-ID: <338b76f0-40d1-904f-66e0-f6455c5287e7@sandisk.com>
References: <alpine.LRH.2.02.1610211406290.9197@file01.intranet.prod.int.rdu2.redhat.com>
 <20161021200022.GA12580@redhat.com>
 <alpine.LRH.2.02.1610211616450.31606@file01.intranet.prod.int.rdu2.redhat.com>
 <20161024155756.GA48306@redhat.com> <20161025130712.GA12717@infradead.org>
 <20161025143719.GA51266@redhat.com>
 <710b07a3-9091-6935-37c4-ea1dcedcab4f@kernel.dk>
 <alpine.LRH.2.02.1610261624100.12287@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1610261625580.12287@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1610261625580.12287@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 10/26/2016 01:26 PM, Mikulas Patocka wrote:
> The brd driver refuses misaligned discard requests with an error. However,
> this is suboptimal, misaligned requests could be handled by discarding a
> part of the request that is aligned on a page boundary. This patch changes
> the code so that it handles misaligned requests.

Hello Mikulas,

We do not want this kind of discard request processing in every block 
driver. This is why I think that this kind of processing should be added 
to the block layer. See also "[PATCH v3 0/5] Make blkdev_issue_discard() 
submit aligned discard requests" 
(http://www.spinics.net/lists/linux-block/msg02360.html).

Bart.
