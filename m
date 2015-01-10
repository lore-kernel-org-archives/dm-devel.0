From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: blk-mq request allocation stalls [was: Re: [PATCH v3
 0/8] dm: add request-based blk-mq support]
Date: Fri, 9 Jan 2015 20:48:11 -0500
Message-ID: <20150110014811.GA2384@redhat.com>
References: <54AC0A39.90801@kernel.dk> <54AD0B63.3010505@acm.org>
	<alpine.LNX.2.00.1501071755110.4026@localhost.lm.intel.com>
	<20150109194955.GA32641@redhat.com> <54B042FE.2000205@kernel.dk>
	<54B043FC.8000902@kernel.dk> <20150109214015.GA1032@redhat.com>
	<54B04E94.3010403@kernel.dk> <20150109222543.GA1190@redhat.com>
	<54B071DC.9000307@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vtzGhvizbBRQ85DL"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54B071DC.9000307@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 09 2015 at  7:27pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> I sent out the half-done v3, unfortunately. Can you try this? Both the
> cases with substantial nr_free are at the end of an index.

I initially thought it was fixed since I didn't see any failures on boot
(which I normally do see 3-4).  I then ran the kernel "make install" to
this virtio-blk root device and also didn't see any failures on the the
first run.  But the 2nd run triggered these:

[   83.711724] __bt_get: values before for loop: last_tag=55, index=1
[   83.713395] __bt_get: values after  for loop: last_tag=32, index=1
[   83.714464] bt_get: __bt_get() returned -1
[   83.715183] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
[   83.716297] nr_free=128, nr_reserved=0
[   83.716940] active_queues=0

[   88.716241] __bt_get: values before for loop: last_tag=15, index=0
[   88.717890] __bt_get: values after  for loop: last_tag=0, index=0
[   88.718956] bt_get: __bt_get() returned -1
[   88.719682] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
[   88.720866] nr_free=128, nr_reserved=0
[   88.721536] active_queues=0

A third "make install" resulted in:

[  543.711782] __bt_get: values before for loop: last_tag=114, index=3
[  543.713411] __bt_get: values after  for loop: last_tag=96, index=3
[  543.714495] bt_get: __bt_get() returned -1
[  543.715222] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
[  543.716351] nr_free=128, nr_reserved=0
[  543.717016] active_queues=0

(things definitely do seem better, e.g. less frequent failure and no
longer see the last_tag=127 case)

> If this one doesn't solve it, I'll reproduce it myself to save the
> ping-pong effort :-)

I don't mind testing it since it is really quick.  But OK.

I've attached the debug patch I've been using in case you'd like to use it.

But feel free to send me additional versions for me to test off-list if
you'd like.

Mike

--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="blk-mq-bt_get-debug-v2.patch"

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 32e8dbb..4f11e7c 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -180,12 +180,16 @@ static int __bt_get(struct blk_mq_hw_ctx *hctx, struct blk_mq_bitmap_tags *bt,
 	unsigned int last_tag, org_last_tag;
 	int index, i, tag;
 
-	if (!hctx_may_queue(hctx, bt))
+	if (!hctx_may_queue(hctx, bt)) {
+		printk("!hctx_may_queue() __bt_get returning -1\n");
 		return -1;
+	}
 
 	last_tag = org_last_tag = *tag_cache;
 	index = TAG_TO_INDEX(bt, last_tag);
 
+	WARN_ON(last_tag > 127);
+
 	for (i = 0; i < bt->map_nr; i++) {
 		tag = __bt_get_word(&bt->map[index], TAG_TO_BIT(bt, last_tag));
 		if (tag != -1) {
@@ -198,6 +202,11 @@ static int __bt_get(struct blk_mq_hw_ctx *hctx, struct blk_mq_bitmap_tags *bt,
 			index = 0;
 	}
 
+	printk("\n%s: values before for loop: last_tag=%u, index=%d\n", __func__,
+	       *tag_cache,  TAG_TO_INDEX(bt, *tag_cache));
+	printk("%s: values after  for loop: last_tag=%u, index=%d\n", __func__,
+	       last_tag, index);
+
 	*tag_cache = 0;
 	return -1;
 
@@ -232,6 +241,27 @@ static struct bt_wait_state *bt_wait_ptr(struct blk_mq_bitmap_tags *bt,
 	return bs;
 }
 
+static unsigned int bt_unused_tags(struct blk_mq_bitmap_tags *bt);
+
+static void print_hctx_tags_usage(struct blk_mq_hw_ctx *hctx)
+{
+	unsigned int free, res;
+	struct blk_mq_tags *tags = hctx->tags;
+
+	if (!tags)
+		return;
+
+	printk("queue_num=%d, nr_tags=%u, reserved_tags=%u, bits_per_word=%u\n",
+	       hctx->queue_num, tags->nr_tags, tags->nr_reserved_tags,
+	       tags->bitmap_tags.bits_per_word);
+
+	free = bt_unused_tags(&tags->bitmap_tags);
+	res = bt_unused_tags(&tags->breserved_tags);
+
+	printk("nr_free=%u, nr_reserved=%u\n", free, res);
+	printk("active_queues=%u\n", atomic_read(&tags->active_queues));
+}
+
 static int bt_get(struct blk_mq_alloc_data *data,
 		struct blk_mq_bitmap_tags *bt,
 		struct blk_mq_hw_ctx *hctx,
@@ -245,6 +275,10 @@ static int bt_get(struct blk_mq_alloc_data *data,
 	if (tag != -1)
 		return tag;
 
+	printk("%s: __bt_get() returned -1\n", __func__);
+	print_hctx_tags_usage(hctx);
+	//dump_stack();
+
 	if (!(data->gfp & __GFP_WAIT))
 		return -1;
 
@@ -256,6 +290,9 @@ static int bt_get(struct blk_mq_alloc_data *data,
 		if (tag != -1)
 			break;
 
+		printk("%s: __bt_get() _still_ returned -1\n", __func__);
+		print_hctx_tags_usage(hctx);
+
 		/*
 		 * We're out of tags on this hardware queue, kick any
 		 * pending IO submits before going to sleep waiting for

--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--vtzGhvizbBRQ85DL--
