From: Mike Snitzer <snitzer@redhat.com>
Subject: should blk-mq halt requeue processing while queue is frozen? [was:
 Re: [PATCH 8/9] dm: Fix two race conditions related to stopping and starting
 queues]
Date: Fri, 2 Sep 2016 12:10:59 -0400
Message-ID: <20160902161059.GB17508@redhat.com>
References: <20160901204806.GA12742@redhat.com>
 <66e36ae7-19ff-058f-049a-3e91a62b19b3@sandisk.com>
 <20160901211718.GA12894@redhat.com>
 <20160901221823.GA13209@redhat.com>
 <f276cf3d-cad3-3e61-2903-754970f90445@sandisk.com>
 <20160901222654.GA13292@redhat.com>
 <938609b9-3a55-0ed3-ffeb-de27e1c1e864@sandisk.com>
 <20160901234754.GA13653@redhat.com>
 <6af010f8-0a8f-cf0e-d819-3b8e1c20b56e@sandisk.com>
 <20160902151213.GA17508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160902151213.GA17508@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: axboe@kernel.dk, device-mapper development <dm-devel@redhat.com>, hch@lst.de, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Sep 02 2016 at 11:12am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> So in the case of blk-mq request-based DM: we cannot expect
> blk_mq_freeze_queue(), during suspend, to complete if requests are
> getting requeued to the blk-mq queue via BLK_MQ_RQ_QUEUE_BUSY.

Looking closer at blk-mq.  Currently __blk_mq_run_hw_queue() will move
any requeued requests to the hctx->dispatch list and then performs async
blk_mq_run_hw_queue().

To do what you hoped (have blk_mq_freeze_queue() discontinue all use of
blk-mq hw queues during DM suspend) I think we'd need blk-mq to:
1) avoid processing requeued IO if blk_mq_freeze_queue() was used to
   freeze the queue.  Meaning it'd have to hold requeued work longer
   than it currently does.
2) Then once blk_mq_unfreeze_queue() is called it'd allow requeues to
   proceed.

This would be catering to a very specific requirement of DM (given it
re-queues IO back to the request_queue during suspend).

BUT all said, relative to request-based DM multipath, what we have is
perfectly fine on a correctness level: the requests are re-queued
because the blk-mq DM device is suspended.

Unfortunately on an efficiency level DM suspend creates a lot of busy
looping in blk-mq, with 100% cpu usage in a threads with names
"kworker/3:1H", ideally we'd avoid that!
