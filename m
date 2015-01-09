From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq request allocation stalls [was: Re: [PATCH v3
 0/8] dm: add request-based blk-mq support]
Date: Fri, 09 Jan 2015 14:11:24 -0700
Message-ID: <54B043FC.8000902@kernel.dk>
References: <20141224182143.GA12922@redhat.com>
	<20141224185529.GA13246@redhat.com>
	<20141224192643.GA30461@redhat.com> <54A6DB1D.4030201@acm.org>
	<20150105213557.GA5030@redhat.com> <54ABAB80.70006@acm.org>
	<20150106160553.GB10224@redhat.com> <54AC0A39.90801@kernel.dk>
	<54AD0B63.3010505@acm.org>
	<alpine.LNX.2.00.1501071755110.4026@localhost.lm.intel.com>
	<20150109194955.GA32641@redhat.com> <54B042FE.2000205@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000801010603060707090500"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54B042FE.2000205@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Keith Busch <keith.busch@intel.com>, Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000801010603060707090500
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 01/09/2015 02:07 PM, Jens Axboe wrote:
> On 01/09/2015 12:49 PM, Mike Snitzer wrote:
>> On Wed, Jan 07 2015 at  3:40pm -0500,
>> Keith Busch <keith.busch@intel.com> wrote:
>>
>>> On Wed, 7 Jan 2015, Bart Van Assche wrote:
>>>> On 01/06/15 17:15, Jens Axboe wrote:
>>>>> blk-mq request allocation is pretty much as optimized/fast as it
>>>>> can be.
>>>>> The slowdown must be due to one of two reasons:
>>>>>
>>>>> - A bug related to running out of requests, perhaps a missing queue
>>>>> run
>>>>> or something like that.
>>>>> - A smaller number of available requests, due to the requested
>>>>> queue depth.
>>>>>
>>>>> Looking at Barts results, it looks like it's usually fast, but
>>>>> sometimes
>>>>> very slow. That would seem to indicate it's option #1 above that is
>>>>> the
>>>>> issue. Bart, since this seems to wait for quite a bit, would it be
>>>>> possible to cat the 'tags' file for that queue when it is stuck
>>>>> like that?
>>>>
>>>> Hello Jens,
>>>>
>>>> Thanks for the assistance. Is this the output you were looking for
>>>
>>> I'm a little confused by the later comments given the below data. It
>>> says
>>> multipath_clone_and_map() is stuck at bt_get, but that doesn't block
>>> unless there are no tags available. The tags should be coming from one
>>> of dm-1's path queues, and I'm assuming these queues are provided by sdc
>>> and sdd. All their tags are free, so that looks like a missing wake_up
>>> when the queue idles.
>>
>> Like I said in an earlier email, I cannot reproduce Bart's hangs running
>> mkfs.xfs against a multipath device that is built ontop of a virtio
>> device in a KVM guest.
>>
>> But I can hit __bt_get() failures on the virtio-blk device that I'm
>> using for the root device on this guest.  Bart I'd be interested to see
>> what you get when running the attached debug patch (likely will just
>> echo the same type of info you've already provided).
>>
>> There does appear to be something weird going on with bt_get().  With
>> the debug patch I'm seeing the following when I simply run "make install"
>> of the kernel (it'll run dracut to build the initramfs, etc):
>>
>> You'll note that in all instances where __bt_get() returns -1 nr_free
>> isn't 0.
>
> Yeah, that doesn't look good. Can you try with this patch? The second
> hunk is the interesting bit, the first is more of a cleanup.

Actually, try this one instead, it should be a bit more precise than the 
first.


-- 
Jens Axboe


--------------000801010603060707090500
Content-Type: text/x-patch;
 name="tag-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tag-v2.patch"

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 60c9d4a93fe4..2e38cd118c1d 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -143,7 +143,6 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 static int __bt_get_word(struct blk_align_bitmap *bm, unsigned int last_tag)
 {
 	int tag, org_last_tag, end;
-	bool wrap = last_tag != 0;
 
 	org_last_tag = last_tag;
 	end = bm->depth;
@@ -155,15 +154,16 @@ restart:
 			 * We started with an offset, start from 0 to
 			 * exhaust the map.
 			 */
-			if (wrap) {
-				wrap = false;
+			if (org_last_tag) {
 				end = org_last_tag;
-				last_tag = 0;
+				last_tag = org_last_tag = 0;
 				goto restart;
 			}
 			return -1;
 		}
 		last_tag = tag + 1;
+		if (last_tag >= bm->depth - 1)
+			last_tag = 0;
 	} while (test_and_set_bit(tag, &bm->word));
 
 	return tag;
@@ -199,9 +199,13 @@ static int __bt_get(struct blk_mq_hw_ctx *hctx, struct blk_mq_bitmap_tags *bt,
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

--------------000801010603060707090500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000801010603060707090500--
