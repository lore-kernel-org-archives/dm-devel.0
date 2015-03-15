From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] dm log userspace: transfer: match wait_for_completion_timeout return type
Date: Sun, 15 Mar 2015 13:09:10 -0400
Message-ID: <1426439350-26318-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: dm-devel.ids

Return type of wait_for_completion_timeout is unsigned long not int. An
appropriately named unsigned long is added and the assignments fixed up.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was only compile tested with x86_64_defconfig + CONFIG_DM_LOG_USERSPACE

Patch is against 4.0-rc3 (localversion-next is -next-20150313)

 drivers/md/dm-log-userspace-transfer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index 39ad966..c2050a1 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -172,6 +172,7 @@ int dm_consult_userspace(const char *uuid, uint64_t luid, int request_type,
 			 char *rdata, size_t *rdata_size)
 {
 	int r = 0;
+	unsigned long time_left;
 	size_t dummy = 0;
 	int overhead_size = sizeof(struct dm_ulog_request) + sizeof(struct cn_msg);
 	struct dm_ulog_request *tfr = prealloced_ulog_tfr;
@@ -236,11 +237,12 @@ resend:
 		goto out;
 	}
 
-	r = wait_for_completion_timeout(&(pkg.complete), DM_ULOG_RETRY_TIMEOUT);
+	time_left = wait_for_completion_timeout(&(pkg.complete),
+						DM_ULOG_RETRY_TIMEOUT);
 	spin_lock(&receiving_list_lock);
 	list_del_init(&(pkg.list));
 	spin_unlock(&receiving_list_lock);
-	if (!r) {
+	if (!time_left) {
 		DMWARN("[%s] Request timed out: [%u/%u] - retrying",
 		       (strlen(uuid) > 8) ?
 		       (uuid + (strlen(uuid) - 8)) : (uuid),
-- 
1.7.10.4

