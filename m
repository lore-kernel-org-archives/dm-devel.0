From: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH 2/2] dm snap: add fake origin_direct_access
Date: Tue, 28 Jun 2016 13:37:16 -0600
Message-ID: <1467142636-21094-3-git-send-email-toshi.kani@hpe.com>
References: <1467142636-21094-1-git-send-email-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1467142636-21094-1-git-send-email-toshi.kani-ZPxbGqLxI0U@public.gmane.org>
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
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

dax-capable mapped-device is marked as DM_TYPE_DAX_BIO_BASED,
which supports both dax and bio-based operations.  dm-snap
needs to work with dax-capable device when bio-based operation
is used.

Add fake origin_direct_access() to origin device so that its
origin device is also marked as DM_TYPE_DAX_BIO_BASED for
dax-capable device.  This allows to extend target's DM table.
dm-snap works normally when bio-based operation is used.

dm-snap does not support dax operation, and mount with dax
option to a target device or snapshot device fails.

Signed-off-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/md/dm-snap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 69ab1ff..c472f04 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2301,6 +2301,13 @@ static int origin_map(struct dm_target *ti, struct bio *bio)
 	return do_origin(o->dev, bio);
 }
 
+static long origin_direct_access(struct dm_target *ti, sector_t sector,
+		void __pmem **kaddr, pfn_t *pfn, long size)
+{
+	DMWARN("device does not support dax.");
+	return -EIO;
+}
+
 /*
  * Set the target "max_io_len" field to the minimum of all the snapshots'
  * chunk sizes.
@@ -2360,6 +2367,7 @@ static struct target_type origin_target = {
 	.postsuspend = origin_postsuspend,
 	.status  = origin_status,
 	.iterate_devices = origin_iterate_devices,
+	.direct_access = origin_direct_access,
 };
 
 static struct target_type snapshot_target = {
