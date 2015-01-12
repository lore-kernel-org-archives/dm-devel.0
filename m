From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: blk-mq request allocation stalls
Date: Mon, 12 Jan 2015 14:07:10 -0500
Message-ID: <20150112190710.GB21518@redhat.com>
References: <54B08779.2080705@kernel.dk> <20150110031057.GA2823@redhat.com>
	<54B3DE54.7090909@sandisk.com> <54B3EB4A.9090404@kernel.dk>
	<54B3F255.5080802@sandisk.com> <54B3F78D.2020704@kernel.dk>
	<54B3FE89.200@sandisk.com> <54B3FFAE.4070609@kernel.dk>
	<alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
	<54B40E8A.6010005@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54B40E8A.6010005@kernel.dk>
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
Cc: Keith Busch <keith.busch@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Mon, Jan 12 2015 at  1:12pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 01/12/2015 10:53 AM, Keith Busch wrote:
> >On Mon, 12 Jan 2015, Jens Axboe wrote:
> >>On 01/12/2015 10:04 AM, Bart Van Assche wrote:
> >>>The tag state after having stopped multipathd (systemctl stop
> >>>multipathd) is as follows:
> >>># dmsetup table /dev/dm-0
> >>>0 256000 multipath 3 queue_if_no_path pg_init_retries 50 0 1 1
> >>>service-time 0 2 2 8:48 1 1 8:32 1 1
> >>># ls -l /dev/sd[cd]
> >>>brw-rw---- 1 root disk 8, 32 Jan 12 17:47 /dev/sdc
> >>>brw-rw---- 1 root disk 8, 48 Jan 12 17:47 /dev/sdd
> >>># for d in sdc sdd dm-0; do echo ==== $d; (cd /sys/block/$d/mq &&
> >>>   find|cut -c3-|grep active|xargs grep -aH ''); done
> >>>==== sdc
> >>>0/active:10
> >>>1/active:14
> >>>2/active:7
> >>>3/active:13
> >>>4/active:6
> >>>5/active:10
> >>>==== sdd
> >>>0/active:17
> >>>1/active:8
> >>>2/active:9
> >>>3/active:13
> >>>4/active:5
> >>>5/active:10
> >>>==== dm-0
> >>>-bash: cd: /sys/block/dm-0/mq: No such file or directory
> >>
> >>OK, so it's definitely leaking, but only partially - the requests are
> >>freed, yet the active count isn't decremented. I wonder if we're
> >>losing that flag along the way. It's numbered high enough that a cast
> >>to int will drop it, perhaps the cmd_flags is being copied/passed
> >>around as an int and not the appropriate u64? We've had bugs like that
> >>before.
> >
> >Is the nr_active count correct prior to starting the mkfs test? Trying
> >to see if someone is calling "blk_mq_alloc_tag_set()" twice on the same
> >set. It might be good to add a WARN if this is detected anyway.
> 
> That might be a good debug aid, I agree. But the above doesn't look
> like it's corrupted. If you add the values, you get 60 and 62 for
> the two cases, which seems to indicate that we did bump the values
> correctly, but for some reason we never did the decrement on
> completion. Hence we stabilize around the queue depth of the device,
> which will be 62 +/- a bit due to the sharing.
> 
> I'm not familiar with how rq based dm works. We clone the original
> request (which has the RQ_MQ_INFLIGHT flag set), then we issue the
> clone(s) to the underlying device(s)?

No, the original request is old request-based path (like I said in my
previous reply to Bart).  So RQ_MQ_INFLIGHT will _not_ have been set in
the original request.  It only gets set in the blk-mq blk_get_request()
path.

Unfortunately any flag changes that blk_get_request() does would get
thrown away very quickly via __blk_rq_prep_clone(), which establishes
the flags with:
  dst->cmd_flags = (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;

The current call sequence is:
1) blk_get_request() -- via dm-mpath.c:__multipath_map()
2) __blk_mq_alloc_request() possibly sets REQ_MQ_INFLIGHT
3) blk_rq_prep_clone() copies cmd_flags to the clone; overwriting the
   clone's cmd_flags!

So the problem must be that REQ_MQ_INFLIGHT is getting dropped on the
floor in step 3.

The ability to cope with the clone request allocation establishing flags
in the clone before actually copying the original request's flags state
is a new requirement from blk-mq.

Should __blk_rq_prep_clone() be updated to preserve REQ_CLONE_MASK in
the cloned request too?  E.g. patch at the end of this mail?

> And when that completes, we complete the original? That would work
> fine with the flag on the original request. Maybe I'm missing
> something, and I'll let more knowledgeable people discuss that.

Yes, once the blk-mq requests issued to the underlying blk-mq devices
complete the original (old) request is completed.

 block/blk-core.c          | 3 ++-
 include/linux/blk_types.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7e78931..40071de 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2895,7 +2895,8 @@ EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
 static void __blk_rq_prep_clone(struct request *dst, struct request *src)
 {
 	dst->cpu = src->cpu;
-	dst->cmd_flags = (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
+	dst->cmd_flags = (dst->cmd_flags & REQ_PRESERVE_CLONE_MASK) |
+		(src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
 	dst->cmd_type = src->cmd_type;
 	dst->__sector = blk_rq_pos(src);
 	dst->__data_len = blk_rq_bytes(src);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 445d592..f5ac72d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -212,6 +212,7 @@ enum rq_flag_bits {
 	 REQ_DISCARD | REQ_WRITE_SAME | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | \
 	 REQ_SECURE | REQ_INTEGRITY)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
+#define REQ_PRESERVE_CLONE_MASK		REQ_MQ_INFLIGHT
 
 #define BIO_NO_ADVANCE_ITER_MASK	(REQ_DISCARD|REQ_WRITE_SAME)
 
