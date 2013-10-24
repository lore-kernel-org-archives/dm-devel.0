From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 01/24] dm: nest targets used for testing under
	DM_TEST_TARGETS
Date: Thu, 24 Oct 2013 14:30:14 -0400
Message-ID: <1382639437-27007-2-git-send-email-snitzer@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Both the flakey and delay targets are generally used for testing.  Other
test targets (and cache policies) will be introduced in the future.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/Kconfig | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 30b426e..816e023 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -371,27 +371,12 @@ config DM_MULTIPATH_ST
 
 	  If unsure, say N.
 
-config DM_DELAY
-	tristate "I/O delaying target"
-	depends on BLK_DEV_DM
-	---help---
-	A target that delays reads and/or writes and can send
-	them to different devices.  Useful for testing.
-
-	If unsure, say N.
-
 config DM_UEVENT
 	bool "DM uevents"
 	depends on BLK_DEV_DM
 	---help---
 	Generate udev events for DM events.
 
-config DM_FLAKEY
-       tristate "Flakey target"
-       depends on BLK_DEV_DM
-       ---help---
-         A target that intermittently fails I/O for debugging purposes.
-
 config DM_VERITY
 	tristate "Verity target support"
 	depends on BLK_DEV_DM
@@ -426,4 +411,25 @@ config DM_SWITCH
 
 	  If unsure, say N.
 
+config DM_TEST_TARGETS
+       bool "DM test targets"
+       depends on BLK_DEV_DM
+       ---help---
+         Targets that are only useful for testing.
+
+config DM_FLAKEY
+       tristate "Flakey target (EXPERIMENTAL)"
+       depends on DM_TEST_TARGETS
+       ---help---
+         A target that intermittently fails I/O for debugging purposes.
+
+config DM_DELAY
+	tristate "I/O delaying target (EXPERIMENTAL)"
+	depends on DM_TEST_TARGETS
+	---help---
+	A target that delays reads and/or writes and can send
+	them to different devices.  Useful for testing.
+
+	If unsure, say N.
+
 endif # MD
-- 
1.8.1.4
