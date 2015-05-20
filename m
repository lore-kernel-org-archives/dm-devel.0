From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 01/11] block: make generic_make_request handle
	arbitrarily sized bios
Date: Wed, 20 May 2015 14:44:18 +0200
Message-ID: <20150520124418.GA15594@lst.de>
References: <1430980461-5235-1-git-send-email-mlin@kernel.org> <1430980461-5235-2-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430980461-5235-2-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: dm-devel.ids

This needs the patch below for the blk-mq case with multiple queues.

Also I wonder why we really want to push this below ->make_request.
Moving it just outside ->make_request would make the callchain more
obvious and avoid the recursion into the driver.


diff --git a/block/blk-mq.c b/block/blk-mq.c
index e9bbc04..e7fae76 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1256,6 +1256,8 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		return;
 	}
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	rq = blk_mq_map_request(q, bio, &data);
 	if (unlikely(!rq))
 		return;
