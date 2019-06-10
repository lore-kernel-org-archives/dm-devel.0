From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v11 7/7] xfs: disable map_sync for async flush
Date: Mon, 10 Jun 2019 14:37:30 +0530
Message-ID: <20190610090730.8589-8-pagupta@redhat.com>
References: <20190610090730.8589-1-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190610090730.8589-1-pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jstaron-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cohuck-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Dont support 'MAP_SYNC' with non-DAX files and DAX files
with asynchronous dax_device. Virtio pmem provides
asynchronous host page cache flush mechanism. We don't
support 'MAP_SYNC' with virtio pmem and xfs.

Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/xfs/xfs_file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a7ceae90110e..f17652cca5ff 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1203,11 +1203,14 @@ xfs_file_mmap(
 	struct file	*filp,
 	struct vm_area_struct *vma)
 {
+	struct dax_device 	*dax_dev;
+
+	dax_dev = xfs_find_daxdev_for_inode(file_inode(filp));
 	/*
-	 * We don't support synchronous mappings for non-DAX files. At least
-	 * until someone comes with a sensible use case.
+	 * We don't support synchronous mappings for non-DAX files and
+	 * for DAX files if underneath dax_device is not synchronous.
 	 */
-	if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
+	if (!daxdev_mapping_supported(vma, dax_dev))
 		return -EOPNOTSUPP;
 
 	file_accessed(filp);
-- 
2.20.1
