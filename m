From: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH] dm stripe: add DAX support
Date: Fri, 24 Jun 2016 12:23:30 -0600
Message-ID: <1466792610-30369-1-git-send-email-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Change dm-stripe to implement direct_access function,
stripe_direct_access(), which maps bdev and sector and
calls direct_access function of its physical target device.

Signed-off-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/md/dm-stripe.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 48f1c01..8925f6a 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -308,6 +308,30 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
+static long stripe_direct_access(struct dm_target *ti, sector_t sector,
+		void __pmem **kaddr, pfn_t *pfn, long size)
+{
+	struct stripe_c *sc;
+	struct block_device *bdev;
+	uint32_t stripe;
+	struct blk_dax_ctl dax = {
+		.size = size,
+	};
+	long ret;
+
+	sc = ti->private;
+	stripe_map_sector(sc, sector, &stripe, &dax.sector);
+
+	dax.sector += sc->stripe[stripe].physical_start;
+	bdev = sc->stripe[stripe].dev->bdev;
+
+	ret = bdev_direct_access(bdev, &dax);
+	*kaddr = dax.addr;
+	*pfn = dax.pfn;
+
+	return ret;
+}
+
 /*
  * Stripe status:
  *
@@ -425,6 +449,7 @@ static struct target_type stripe_target = {
 	.status = stripe_status,
 	.iterate_devices = stripe_iterate_devices,
 	.io_hints = stripe_io_hints,
+	.direct_access = stripe_direct_access,
 };
 
 int __init dm_stripe_init(void)
