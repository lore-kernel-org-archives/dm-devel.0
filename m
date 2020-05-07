From: Samuel Zou <zou_wei@huawei.com>
Subject: [PATCH -next] dm mpath: Remove unused variable ret
Date: Thu, 7 May 2020 20:26:52 +0800
Message-ID: <1588854412-19301-1-git-send-email-zou_wei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Samuel Zou <zou_wei@huawei.com>
List-Id: dm-devel.ids

This patch fixes below warning reported by coccicheck:

drivers/md/dm-historical-service-time.c:240:14-16: Unneeded variable: "sz". Return "0" on line 261

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Samuel Zou <zou_wei@huawei.com>
---
 drivers/md/dm-historical-service-time.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-historical-service-time.c b/drivers/md/dm-historical-service-time.c
index 186f91e..3c8acb9 100644
--- a/drivers/md/dm-historical-service-time.c
+++ b/drivers/md/dm-historical-service-time.c
@@ -237,7 +237,6 @@ static void hst_destroy(struct path_selector *ps)
 static int hst_status(struct path_selector *ps, struct dm_path *path,
 		     status_type_t type, char *result, unsigned int maxlen)
 {
-	unsigned int sz = 0;
 	struct path_info *pi;
 
 	if (!path) {
@@ -258,7 +257,7 @@ static int hst_status(struct path_selector *ps, struct dm_path *path,
 		}
 	}
 
-	return sz;
+	return 0;
 }
 
 static int hst_add_path(struct path_selector *ps, struct dm_path *path,
-- 
2.6.2
