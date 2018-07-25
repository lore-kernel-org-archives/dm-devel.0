From: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
Subject: [PATCH v2 6/6] filesystem-dax: Do not request kaddr and pfn when not
 required
Date: Thu, 26 Jul 2018 00:28:49 +0800
Message-ID: <20180725162849.8320-7-yehs2007@zoho.com>
References: <20180725162849.8320-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180725162849.8320-1-yehs2007-ytc+IHgoah0@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, colyli-l3A5Bk7waGM@public.gmane.org, bart.vanassche-Sjgp3cTcYWE@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>

Some functions within fs/dax don't need to get local pointer kaddr
or variable pfn from direct_access. Using NULL instead of having to
pass in useless pointer or variable that caller then just throw away.

Signed-off-by: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
---
 fs/dax.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6411928..959a533 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -647,7 +647,6 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 {
 	void *vto, *kaddr;
 	pgoff_t pgoff;
-	pfn_t pfn;
 	long rc;
 	int id;
 
@@ -656,7 +655,7 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 		return rc;
 
 	id = dax_read_lock();
-	rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, &pfn);
+	rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, NULL);
 	if (rc < 0) {
 		dax_read_unlock(id);
 		return rc;
@@ -967,7 +966,6 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 {
 	const sector_t sector = dax_iomap_sector(iomap, pos);
 	pgoff_t pgoff;
-	void *kaddr;
 	int id, rc;
 	long length;
 
@@ -976,7 +974,7 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 		return rc;
 	id = dax_read_lock();
 	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
-				   &kaddr, pfnp);
+				   NULL, pfnp);
 	if (length < 0) {
 		rc = length;
 		goto out;
@@ -1052,15 +1050,13 @@ int __dax_zero_page_range(struct block_device *bdev,
 		pgoff_t pgoff;
 		long rc, id;
 		void *kaddr;
-		pfn_t pfn;
 
 		rc = bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
 		if (rc)
 			return rc;
 
 		id = dax_read_lock();
-		rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr,
-				&pfn);
+		rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr, NULL);
 		if (rc < 0) {
 			dax_read_unlock(id);
 			return rc;
@@ -1116,7 +1112,6 @@ int __dax_zero_page_range(struct block_device *bdev,
 		ssize_t map_len;
 		pgoff_t pgoff;
 		void *kaddr;
-		pfn_t pfn;
 
 		if (fatal_signal_pending(current)) {
 			ret = -EINTR;
@@ -1128,7 +1123,7 @@ int __dax_zero_page_range(struct block_device *bdev,
 			break;
 
 		map_len = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
-				&kaddr, &pfn);
+				&kaddr, NULL);
 		if (map_len < 0) {
 			ret = map_len;
 			break;
-- 
1.8.3.1
