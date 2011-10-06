From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [dm-devel] Block regression since 3.1-rc3
Date: Thu, 06 Oct 2011 15:51:00 -0400
Message-ID: <x49bottoq57.fsf@segfault.boston.devel.redhat.com>
References: <1317397918.27140.15.camel@localhost>
	<x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	<1317729761.25998.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1317729761.25998.4.camel@localhost> (Christophe Saout's message
	of "Tue, 04 Oct 2011 14:02:41 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe Saout <christophe@saout.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

Christophe Saout <christophe@saout.de> writes:

> Hi Jeff,
>
>> Anyway, it would help a great deal if you could retrigger the failure
>> and provide the full failure output.  You can get that by issuing the
>> 'dmesg' command and redirecting it to a file.
>
> Oh, sorry, yes, there's a line missing.
>
> Line 323 is this one: BUG_ON(!rq->bio || rq->bio != rq->biotail);

OK, it turns out my testing was incomplete.  I only tested targets that
had a write-through cache, so I didn't hit this problem.  It reproduces
pretty easily with just multipath involved (no linear target on top) when
running against the right storage.

So, here's a patch, but I don't have a full explanation for it just yet.
What I observed was that, on fsync, blkdev_issue_flush was called.
Eventually, the flush request gets cloned, and blk_insert_cloned_request
is called.  This cloned request never actually gets issued to the
q->requst_fn (scsi_request_fn in my case).  So, it may be that there is
no plug list for this, so the queue isn't goosed?  I'll try to come up
with a better explanation, or Tejun may just know off the top of his
head what's going on.

So, the patch works for me, but is very much just an RFC.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 491eb30..7aa4736 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -320,7 +320,7 @@ void blk_insert_flush(struct request *rq)
 		return;
 	}
 
-	BUG_ON(!rq->bio || rq->bio != rq->biotail);
+	BUG_ON(rq->bio && rq->bio != rq->biotail);
 
 	/*
 	 * If there's data but flush is not necessary, the request can be
@@ -345,6 +345,12 @@ void blk_insert_flush(struct request *rq)
 	rq->end_io = flush_data_end_io;
 
 	blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
+
+	/*
+	 * A cloned empty flush needs a queue kick to make progress.
+	 */
+	if (!rq->bio)
+		blk_run_queue_async(q);
 }
 
 /**
