From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] dm persistent data: convert to use le32_add_cpu()
Date: Wed, 26 Sep 2012 17:45:57 +0800
Message-ID: <CAPgLHd-10XV1VAhjtr7XRqae37w_TuMXgFTuZRiXetfbOzozXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: agk@redhat.com, neilb@suse.de
Cc: yongjun_wei@trendmicro.com.cn, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Convert cpu_to_le32(le32_to_cpu(E1) + E2) to use le32_add_cpu().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/md/persistent-data/dm-space-map-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index d77602d..f3a9af8 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -434,14 +434,14 @@ int sm_ll_insert(struct ll_disk *ll, dm_block_t b,
 	if (ref_count && !old) {
 		*ev = SM_ALLOC;
 		ll->nr_allocated++;
-		ie_disk.nr_free = cpu_to_le32(le32_to_cpu(ie_disk.nr_free) - 1);
+		le32_add_cpu(&ie_disk.nr_free, -1);
 		if (le32_to_cpu(ie_disk.none_free_before) == bit)
 			ie_disk.none_free_before = cpu_to_le32(bit + 1);
 
 	} else if (old && !ref_count) {
 		*ev = SM_FREE;
 		ll->nr_allocated--;
-		ie_disk.nr_free = cpu_to_le32(le32_to_cpu(ie_disk.nr_free) + 1);
+		le32_add_cpu(&ie_disk.nr_free, 1);
 		ie_disk.none_free_before = cpu_to_le32(min(le32_to_cpu(ie_disk.none_free_before), bit));
 	}
 


