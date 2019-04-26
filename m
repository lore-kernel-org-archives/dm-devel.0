From: Helen Koike <helen.koike@collabora.com>
Subject: [PATCH] dm: init: fix max devices/targets checks
Date: Fri, 26 Apr 2019 17:09:55 -0300
Message-ID: <20190426200955.17886-1-helen.koike@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: kernel@collabora.com, Helen Koike <helen.koike@collabora.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

dm-init should allow up to DM_MAX_{DEVICES,TARGETS} for devices/targets,
and not DM_MAX_{DEVICES,TARGETS} - 1.

Fix the checks and also fix the error message when the number of devices
is surpassed.

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---
Hi,

This patch was tested by manipulating DM_MAX_TARGETS and DM_MAX_DEVICES
macros and making sure the test cases in the following test script[1] was
passing or failing when they should.

[1] https://gitlab.collabora.com/koike/dm-cmdline-test

Thanks
Helen

 drivers/md/dm-init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index 4b76f84424c3..352e803f566e 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -160,7 +160,7 @@ static int __init dm_parse_table(struct dm_device *dev, char *str)
 
 	while (table_entry) {
 		DMDEBUG("parsing table \"%s\"", str);
-		if (++dev->dmi.target_count >= DM_MAX_TARGETS) {
+		if (++dev->dmi.target_count > DM_MAX_TARGETS) {
 			DMERR("too many targets %u > %d",
 			      dev->dmi.target_count, DM_MAX_TARGETS);
 			return -EINVAL;
@@ -242,9 +242,9 @@ static int __init dm_parse_devices(struct list_head *devices, char *str)
 			return -ENOMEM;
 		list_add_tail(&dev->list, devices);
 
-		if (++ndev >= DM_MAX_DEVICES) {
-			DMERR("too many targets %u > %d",
-			      dev->dmi.target_count, DM_MAX_TARGETS);
+		if (++ndev > DM_MAX_DEVICES) {
+			DMERR("too many devices %lu > %d",
+			      ndev, DM_MAX_DEVICES);
 			return -EINVAL;
 		}
 
-- 
2.20.1
