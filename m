From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thinp bug
Date: Wed, 27 Apr 2011 10:52:44 +0100
Message-ID: <1303897964.4679.56.camel@ubuntu>
References: <20110426184742.GA13880@infradead.org>
	<1303895339.4679.51.camel@ubuntu>
	<20110427093259.GA24141@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110427093259.GA24141@infradead.org>
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

On Wed, 2011-04-27 at 05:32 -0400, Christoph Hellwig wrote:
> 
> This patch already creashes when creating the table: 

Sigh, it's revealed a bug in io_hints, which isn't ever run if there's
no iterate_devices callback.

The patch below has been regression tested, but not tried above a virtio
device.  It's been pushed too.

- Joe



diff --git a/drivers/md/dm-thin-prov.c b/drivers/md/dm-thin-prov.c
index 6ac802e..a168ee6 100644
--- a/drivers/md/dm-thin-prov.c
+++ b/drivers/md/dm-thin-prov.c
@@ -641,7 +641,15 @@ thinp_io_hints(struct dm_target *ti, struct
queue_limits *limits)
        struct thinp_c *tc = ti->private;
 
        blk_limits_io_min(limits, 0);
-       blk_limits_io_opt(limits, data_dev_block_size(tc));
+       blk_limits_io_opt(limits, tc->block_size << tc->block_shift);
+}
+
+static int thinp_iterate_devices(struct dm_target *ti,
+                                iterate_devices_callout_fn fn,
+                                void *data)
+{
+       struct thinp_c *tc = ti->private;
+       return fn(ti, tc->data_dev, 0, tc->data_size << tc->block_shift,
data);
 }
 
 /* Thinp pool control target interface. */
@@ -659,6 +667,7 @@ static struct target_type thinp_target = {
        .status = thinp_status,
        .merge = thinp_bvec_merge,
        .io_hints = thinp_io_hints,
+       .iterate_devices = thinp_iterate_devices,
 };
 
 static int __init dm_thinp_init(void)
