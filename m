From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: dm-userspace (no in-kernel cache version)
Date: Fri, 15 Sep 2006 01:27:57 +0900
Message-ID: <20060915012757J.fujita.tomonori@lab.ntt.co.jp>
References: <m3lkoopxf9.fsf@guaranine.beaverton.ibm.com>
	<20060915004807D.fujita.tomonori@lab.ntt.co.jp>
	<m3y7smmobw.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3y7smmobw.fsf@guaranine.beaverton.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Dan Smith <danms@us.ibm.com>
Subject: Re: [dm-devel] dm-userspace (no in-kernel cache version)
Date: Thu, 14 Sep 2006 08:59:15 -0700

> FT> Have you tried SCHED_FIFO?
> 
> Not yet, but that is a good suggestion.
> 
> FT> By the way, can you upload or post the latest kernel and
> FT> user-space code?
> 
> Right now I am working on a version that still uses read()/write(),
> but that does not use a remap cache (in a way very similar to what you
> posted).  When I get it close to stable, I'll post it here for
> comments.

I see.


> After reviewing the ringbuffer code more, I'm not sure that it really
> buys you any additional performance (other than 1/3 less syscalls).
> The amount of memory that is copied around seems to be about the
> same.

Well, my code just uses ring buffer and is not tuned yet. As you know,
you can eliminate memory copies easily (I've attached a patch to do
that for dmu_uspace_send_map_req), though maybe memory copies don't
make the large difference. As you said, after having a stable version
without rmap cache, performance tests (write/read vs. ring buffer)
are necessary.


diff --git a/drivers/md/dm-userspace-chardev.c b/drivers/md/dm-userspace-chardev.c
index 5a4b0d3..42172ce 100644
--- a/drivers/md/dm-userspace-chardev.c
+++ b/drivers/md/dm-userspace-chardev.c
@@ -117,12 +117,35 @@ static int dmu_uspace_send_event(struct 
 
 int dmu_uspace_send_map_req(struct dmu_device *dev, u64 id, u32 flags, u64 block)
 {
-	struct dmu_event ev;
+	struct chardev_transport *t = dev->transport_private;
+	struct dmu_ring *ring = &t->tx;
+	struct dmu_event *ev;
+	int err = 0;
+
+	spin_lock(&ring->r_lock);
+
+	ev = dmu_head_event(ring, ring->r_idx);
+	if (!ev->status) {
+
+		ev->type = DM_USERSPACE_MAP_BLOCK_REQ;
+		ev->status = 1;
+		ev->k.map_req.id = id;
+		ev->k.map_req.flags = flags;
+		ev->k.map_req.block = block;
 
-	ev.k.map_req.id = id;
-	ev.k.map_req.flags = flags;
-	ev.k.map_req.block = block;
-	return dmu_uspace_send_event(dev, DM_USERSPACE_MAP_BLOCK_REQ, &ev);
+		mb();
+		dmu_ring_idx_inc(ring);
+	} else
+		err = -EBUSY;
+
+	spin_unlock(&ring->r_lock);
+
+	if (!err) {
+		flush_dcache_page(virt_to_page(ev));
+		wake_up_interruptible(&t->tx_poll_wait);
+	}
+
+	return err;
 }
 
 int dmu_uspace_send_map_status(struct dmu_device *dev, u64 id, u32 status)
