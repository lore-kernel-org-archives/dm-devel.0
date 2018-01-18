From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] blk mq: don't blk_mq_request_bypass_insert _and_ return
 BLK_STS_RESOURCE
Date: Wed, 17 Jan 2018 22:33:35 -0500
Message-ID: <20180118033334.GA30338@redhat.com>
References: <20180117162558.28553-1-snitzer@redhat.com>
 <45f70a28-aeea-8278-0b8e-9601ea043595@kernel.dk>
 <20180117165832.GA5573@redhat.com>
 <1516231868.2820.84.camel@wdc.com>
 <1516232589.3805.2.camel@redhat.com>
 <1516233206.2820.103.camel@wdc.com>
 <20180118005452.GB7649@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180118005452.GB7649@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, Laurence Oberman <loberman@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>
List-Id: dm-devel.ids

On Wed, Jan 17 2018 at  7:54P -0500,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> But sure, I suppose there is something I missed when refactoring Ming's
> change to get it acceptable for upstream.  I went over the mechanical
> nature of what I did many times (comparing Ming's v4 to my v5).

And yes there is one subtlety that I missed.

> The call to blk_mq_request_bypass_insert will only occur via
> __blk_mq_fallback_to_insert.  Which as the name implies this is not the
> fast path.  This will occur if the underlying blk-mq device cannot get
> resources it needs in order to issue the request.  Specifically: if/when
> in __blk_mq_try_issue_directly() the hctx is stopped, or queue is
> quiesced, or it cannot get the driver tag or dispatch_budget (in the
> case of scsi-mq).
> 
> The same fallback, via call to blk_mq_request_bypass_insert, occured
> with Ming's v4 though.

Turns out Ming's v4 doesn't fallback to insert for the "or it cannot get
the driver tag or dispatch_budget" case.

This patch should fix it (Laurence, please report back on if this fixes
your list_add corruption, pretty sure it will):

From: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 17 Jan 2018 22:02:07 -0500
Subject: [PATCH] blk mq: don't blk_mq_request_bypass_insert _and_ return BLK_STS_RESOURCE

It isn't ever valid to call blk_mq_request_bypass_insert() and return
BLK_STS_RESOURCE.

Unfortunately after commit 396eaf21ee ("blk-mq: improve DM's blk-mq IO
merging via blk_insert_cloned_request feedback") we do just that if
blk_mq_request_direct_issue() cannot get the resources (driver_tag or
dispatch_budget) needed to directly issue a request.  This will lead to
"list_add corruption" because blk-mq submits the IO but then reports
that it didn't (BLK_STS_RESOURCE in this case).

Fix this by simply returning BLK_STS_RESOURCE for this case.

Fixes: 396eaf21ee ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
Reported-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-mq.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c418858a60ef..8bee37239255 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1799,20 +1799,18 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	if (q->elevator && !bypass_insert)
 		goto insert;
 
-	if (!blk_mq_get_driver_tag(rq, NULL, false))
-		goto insert;
-
-	if (!blk_mq_get_dispatch_budget(hctx)) {
+	if (!blk_mq_get_driver_tag(rq, NULL, false) ||
+	    !blk_mq_get_dispatch_budget(hctx)) {
+		/* blk_mq_put_driver_tag() is idempotent */
 		blk_mq_put_driver_tag(rq);
+		if (bypass_insert)
+			return BLK_STS_RESOURCE;
 		goto insert;
 	}
 
 	return __blk_mq_issue_directly(hctx, rq, cookie);
 insert:
 	__blk_mq_fallback_to_insert(rq, run_queue, bypass_insert);
-	if (bypass_insert)
-		return BLK_STS_RESOURCE;
-
 	return BLK_STS_OK;
 }
 
-- 
2.15.0
