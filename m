From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [resend PATCH v2 16/33] block,
 dax: convert bdev_dax_supported() to dax_direct_access()
Date: Mon, 17 Apr 2017 12:10:16 -0700
Message-ID: <149245621655.10206.6212373965558626649.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: dm-devel.ids

Kill of the final user of bdev_direct_access() and struct blk_dax_ctl.

Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 fs/block_dev.c |   48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2f7885712575..ecbdc8f9f718 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -788,35 +788,43 @@ EXPORT_SYMBOL(bdev_dax_pgoff);
  */
 int bdev_dax_supported(struct super_block *sb, int blocksize)
 {
-	struct blk_dax_ctl dax = {
-		.sector = 0,
-		.size = PAGE_SIZE,
-	};
-	int err;
+	struct block_device *bdev = sb->s_bdev;
+	struct dax_device *dax_dev;
+	pgoff_t pgoff;
+	int err, id;
+	void *kaddr;
+	pfn_t pfn;
+	long len;
 
 	if (blocksize != PAGE_SIZE) {
 		vfs_msg(sb, KERN_ERR, "error: unsupported blocksize for dax");
 		return -EINVAL;
 	}
 
-	err = bdev_direct_access(sb->s_bdev, &dax);
-	if (err < 0) {
-		switch (err) {
-		case -EOPNOTSUPP:
-			vfs_msg(sb, KERN_ERR,
-				"error: device does not support dax");
-			break;
-		case -EINVAL:
-			vfs_msg(sb, KERN_ERR,
-				"error: unaligned partition for dax");
-			break;
-		default:
-			vfs_msg(sb, KERN_ERR,
-				"error: dax access failed (%d)", err);
-		}
+	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
+	if (err) {
+		vfs_msg(sb, KERN_ERR, "error: unaligned partition for dax");
 		return err;
 	}
 
+	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
+	if (!dax_dev) {
+		vfs_msg(sb, KERN_ERR, "error: device does not support dax");
+		return -EOPNOTSUPP;
+	}
+
+	id = dax_read_lock();
+	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
+	dax_read_unlock(id);
+
+	put_dax(dax_dev);
+
+	if (len < 1) {
+		vfs_msg(sb, KERN_ERR,
+				"error: dax access failed (%d)", len);
+		return len < 0 ? len : -EIO;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(bdev_dax_supported);
