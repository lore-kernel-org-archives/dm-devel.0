From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq request allocation stalls [was: Re: [PATCH v3
 0/8] dm: add request-based blk-mq support]
Date: Fri, 09 Jan 2015 14:56:36 -0700
Message-ID: <54B04E94.3010403@kernel.dk>
References: <54A6DB1D.4030201@acm.org> <20150105213557.GA5030@redhat.com>
	<54ABAB80.70006@acm.org> <20150106160553.GB10224@redhat.com>
	<54AC0A39.90801@kernel.dk> <54AD0B63.3010505@acm.org>
	<alpine.LNX.2.00.1501071755110.4026@localhost.lm.intel.com>
	<20150109194955.GA32641@redhat.com>
	<54B042FE.2000205@kernel.dk> <54B043FC.8000902@kernel.dk>
	<20150109214015.GA1032@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080805090701060308050602"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150109214015.GA1032@redhat.com>
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
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------080805090701060308050602
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 01/09/2015 02:40 PM, Mike Snitzer wrote:
> On Fri, Jan 09 2015 at  4:11pm -0500,
> Jens Axboe <axboe@kernel.dk> wrote:
>
>>
>> Actually, try this one instead, it should be a bit more precise than
>> the first.
>>
>
> Thanks for the test patch.
>
> I'm still seeing failures that look wrong (last_tag=127 could be edge
> condition not handled properly?):
>
> [   14.254632] __bt_get: values before for loop: last_tag=127, index=3
> [   14.255841] __bt_get: values after  for loop: last_tag=64, index=2
> [   14.257036]
> [   14.257036] bt_get: __bt_get() returned -1
> [   14.258051] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
> [   14.259246] nr_free=128, nr_reserved=0
> [   14.259963] active_queues=0
>
> [  213.115997] __bt_get: values before for loop: last_tag=127, index=3
> [  213.117115] __bt_get: values after  for loop: last_tag=96, index=3
> [  213.118200]
> [  213.118200] bt_get: __bt_get() returned -1
> [  213.121593] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
> [  213.123960] nr_free=128, nr_reserved=0
> [  213.125880] active_queues=0
>
> [  239.158079] __bt_get: values before for loop: last_tag=8, index=0
> [  239.160363] __bt_get: values after  for loop: last_tag=0, index=0
> [  239.162896]
> [  239.162896] bt_get: __bt_get() returned -1
> [  239.166284] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
> [  239.168623] nr_free=127, nr_reserved=0
> [  239.170508] active_queues=0

Thanks for testing, can you try this one?

-- 
Jens Axboe


--------------080805090701060308050602
Content-Type: text/x-patch;
 name="tag-v3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tag-v3.patch"

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 60c9d4a93fe4..4130c2bdc6c0 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -143,28 +143,31 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 static int __bt_get_word(struct blk_align_bitmap *bm, unsigned int last_tag)
 {
 	int tag, org_last_tag, end;
-	bool wrap = last_tag != 0;
 
 	org_last_tag = last_tag;
 	end = bm->depth;
-	do {
-restart:
-		tag = find_next_zero_bit(&bm->word, end, last_tag);
+	while (1) {
+		tag = find_next_zero_bit(&bm->word, bm->depth, last_tag);
 		if (unlikely(tag >= end)) {
 			/*
 			 * We started with an offset, start from 0 to
 			 * exhaust the map.
 			 */
-			if (wrap) {
-				wrap = false;
+			if (org_last_tag) {
 				end = org_last_tag;
-				last_tag = 0;
-				goto restart;
+				last_tag = org_last_tag = 0;
+				continue;
 			}
 			return -1;
 		}
+
+		if (!test_and_set_bit(tag, &bm->word))
+			break;
+
 		last_tag = tag + 1;
-	} while (test_and_set_bit(tag, &bm->word));
+		if (last_tag >= bm->depth - 1)
+			last_tag = 0;
+	}
 
 	return tag;
 }
@@ -199,9 +202,13 @@ static int __bt_get(struct blk_mq_hw_ctx *hctx, struct blk_mq_bitmap_tags *bt,
 			goto done;
 		}
 
-		last_tag = 0;
-		if (++index >= bt->map_nr)
+		index++;
+		last_tag = (index << bt->bits_per_word);
+
+		if (index >= bt->map_nr) {
 			index = 0;
+			last_tag = 0;
+		}
 	}
 
 	*tag_cache = 0;

--------------080805090701060308050602
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080805090701060308050602--
