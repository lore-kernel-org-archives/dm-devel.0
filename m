From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/9] nvme: opencode revalidate_disk in nvme_validate_ns
Date: Tue,  1 Sep 2020 17:57:45 +0200
Message-ID: <20200901155748.2884-7-hch@lst.de>
References: <20200901155748.2884-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20200901155748.2884-1-hch@lst.de>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
 <mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
 <mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Errors-To: virtualization-bounces@lists.linux-foundation.org
Sender: "Virtualization" <virtualization-bounces@lists.linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, nbd@other.debian.org, virtualization@lists.linux-foundation.org, ceph-devel@vger.kernel.org
List-Id: dm-devel.ids

Keep control in the NVMe driver instead of going through an indirect
call back into ->revalidate_disk.  Also reorder the function a bit to be
easier to follow with the additional code.

And now that we have removed all callers of revalidate_disk() in the nvme
code, ->revalidate_disk is only called from the open code when first
opening the device.  Which is of course totally pointless as we have
a valid size since the initial scan, and will get an updated view
through the asynchronous notifiation everytime the size changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index bc18523774b4be..9428e7deb68b09 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2323,7 +2323,6 @@ static const struct block_device_operations nvme_fops = {
 	.open		= nvme_open,
 	.release	= nvme_release,
 	.getgeo		= nvme_getgeo,
-	.revalidate_disk= nvme_revalidate_disk,
 	.report_zones	= nvme_report_zones,
 	.pr_ops		= &nvme_pr_ops,
 };
@@ -4020,14 +4019,19 @@ static void nvme_ns_remove_by_nsid(struct nvme_ctrl *ctrl, u32 nsid)
 static void nvme_validate_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 {
 	struct nvme_ns *ns;
+	int ret;
 
 	ns = nvme_find_get_ns(ctrl, nsid);
-	if (ns) {
-		if (revalidate_disk(ns->disk))
-			nvme_ns_remove(ns);
-		nvme_put_ns(ns);
-	} else
+	if (!ns) {
 		nvme_alloc_ns(ctrl, nsid);
+		return;
+	}
+
+	ret = nvme_revalidate_disk(ns->disk);
+	revalidate_disk_size(ns->disk, ret == 0);
+	if (ret)
+		nvme_ns_remove(ns);
+	nvme_put_ns(ns);
 }
 
 static void nvme_remove_invalid_namespaces(struct nvme_ctrl *ctrl,
-- 
2.28.0
