From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thinp bug
Date: Wed, 27 Apr 2011 10:08:59 +0100
Message-ID: <1303895339.4679.51.camel@ubuntu>
References: <20110426184742.GA13880@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110426184742.GA13880@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Tue, 2011-04-26 at 14:47 -0400, Christoph Hellwig wrote:
> The virtio bug on says that it gets more segments than it allows to
> higher layers. 

I think this is simply because I omitted the iterate_devices callback in
the thinp target.

I'll try and find time to test this patch later this week.
Alternatively you could just switch to multisnap which already has this
in.

- Joe



diff --git a/drivers/md/dm-thin-prov.c b/drivers/md/dm-thin-prov.c
index 4d382c8..054b4f9 100644
--- a/drivers/md/dm-thin-prov.c
+++ b/drivers/md/dm-thin-prov.c
@@ -643,6 +643,14 @@ thinp_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	blk_limits_io_opt(limits, data_dev_block_size(tc));
 }
 
+static int thinp_iterate_devices(struct dm_target *ti,
+				 iterate_devices_callout_fn fn,
+				 void *data)
+{
+	struct thinp_c *tc = ti->private;
+	return fn(ti, tc->data_dev, 0, tc->data_size << tc->block_shift, data);
+}
+
 /* Thinp pool control target interface. */
 static struct target_type thinp_target = {
 	.name = "thin-prov",
@@ -658,6 +666,7 @@ static struct target_type thinp_target = {
 	.status = thinp_status,
 	.merge = thinp_bvec_merge,
 	.io_hints = thinp_io_hints,
+	.iterate_devices = thinp_iterate_devices,
 };
 
 static int __init dm_thinp_init(void)
