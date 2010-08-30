From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] block: initialize flush request with WRITE_FLUSH
 instead of REQ_FLUSH
Date: Mon, 30 Aug 2010 17:42:59 +0200
Message-ID: <4C7BD183.1080801__49143.1152252064$1283197015$gmane$org@kernel.org>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
	<1283162296-13650-5-git-send-email-tj@kernel.org>
	<20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20100830192438.GL9195@redhat.com>
Resent-To: dm-devel@redhat.com
In-Reply-To: <4C7BB932.1070405@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: k-ueda@ct.jp.nec.com, jaxboe@fusionio.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, j-nomura@ce.jp.nec.com, hch@lst.de
List-Id: dm-devel.ids

init_flush_request() only set REQ_FLUSH when initializing flush
requests making them READ requests.  Use WRITE_FLUSH instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mike Snitzer <snitzer@redhat.com>
---
So, this was the culprit for the incorrect data direction for flush
requests.

Thanks.

 block/blk-flush.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: block/block/blk-flush.c
===================================================================
--- block.orig/block/blk-flush.c
+++ block/block/blk-flush.c
@@ -77,7 +77,7 @@ static void post_flush_end_io(struct req
 static void init_flush_request(struct request *rq, struct gendisk *disk)
 {
 	rq->cmd_type = REQ_TYPE_FS;
-	rq->cmd_flags = REQ_FLUSH;
+	rq->cmd_flags = WRITE_FLUSH;
 	rq->rq_disk = disk;
 }
