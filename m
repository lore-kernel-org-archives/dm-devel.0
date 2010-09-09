From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [REGRESSION][BISECTED] virtio-blk serial attribute causes guest
 to hang [Was: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA support
 for request-based dm]
Date: Thu, 9 Sep 2010 16:14:46 -0400
Message-ID: <20100909201445.GA19656@redhat.com>
References: <20100902032246.GA31484@redhat.com>
 <20100909152658.GA8118@redhat.com>
 <20100909154442.GI30086@us.ibm.com>
 <20100909155726.GA9081@redhat.com>
 <20100909160324.GJ30086@us.ibm.com>
 <20100909175537.GA9589@redhat.com>
 <20100909183554.GK30086@us.ibm.com>
 <20100909191555.GA14486@redhat.com>
 <20100909194300.GA16908@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100909194300.GA16908@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Ryan Harper <ryanh@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>, john.cooper@redhat.com, rusty@rustcorp.com.au, hch@infradead.org, kvm@vger.kernel.org
List-Id: dm-devel.ids


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 09 2010 at  3:43pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Interestingly, just this loop:
> 
> while true ; do cat /sys/block/vda/serial && date && sleep 1 ; done
> Thu Sep  9 15:29:30 EDT 2010
> ...
> Thu Sep  9 15:31:19 EDT 2010
> 
> caused the following hang:
...
> So it seems like the virtio requests aren't being properly cleaned up?

Yeap, here is the result with the attached debug patch that Vivek wrote
last week to help chase this issue (which adds 'nr_requests_used').  We
thought the mpath device might be leaking requests; concern for other
devices wasn't on our radar:

# cat /sys/block/vda/queue/nr_requests
128

# while true ; do cat /sys/block/vda/queue/nr_requests_used && cat /sys/block/vda/serial && date && sleep 1 ; done
10
Thu Sep  9 16:04:40 EDT 2010
11
Thu Sep  9 16:04:41 EDT 2010
...
Thu Sep  9 16:06:38 EDT 2010
127
Thu Sep  9 16:06:39 EDT 2010
128

I'll have a quick look at the virtio-blk code to see if I can spot where
the request isn't getting cleaned up.  But I welcome others to have a
look too (I've already spent entirely way to much time on this issue).

Mike

--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="export-nr-requests-throuth-sysfs.patch"

---
 block/blk-sysfs.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-2.6/block/blk-sysfs.c
===================================================================
--- linux-2.6.orig/block/blk-sysfs.c	2010-09-01 09:23:55.000000000 -0400
+++ linux-2.6/block/blk-sysfs.c	2010-09-01 17:55:50.000000000 -0400
@@ -36,6 +36,19 @@ static ssize_t queue_requests_show(struc
 	return queue_var_show(q->nr_requests, (page));
 }
 
+static ssize_t queue_requests_used_show(struct request_queue *q, char *page)
+{
+	struct request_list *rl = &q->rq;
+
+	printk("Vivek: count[sync]=%d count[async]=%d"
+		" congestion_on_thres=%d queue_congestion_off_threshold=%d\n",
+		rl->count[BLK_RW_SYNC], rl->count[BLK_RW_ASYNC],
+		queue_congestion_on_threshold(q),
+		queue_congestion_off_threshold(q));
+
+	return queue_var_show(rl->count[BLK_RW_SYNC], (page));
+}
+
 static ssize_t
 queue_requests_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -266,6 +279,11 @@ static struct queue_sysfs_entry queue_re
 	.store = queue_requests_store,
 };
 
+static struct queue_sysfs_entry queue_requests_used_entry = {
+	.attr = {.name = "nr_requests_used", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_requests_used_show,
+};
+
 static struct queue_sysfs_entry queue_ra_entry = {
 	.attr = {.name = "read_ahead_kb", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_ra_show,
@@ -371,6 +389,7 @@ static struct queue_sysfs_entry queue_ra
 
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
+	&queue_requests_used_entry.attr,
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,

--DocE+STaALJfprDB--
