From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 39/57] devmapper: do not flush I/O for
	DM_DEVICE_CREATE
Date: Wed, 27 Apr 2016 13:10:40 +0200
Message-ID: <1461755458-29225-40-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

DM_DEVICE_CREATE loads a new table, so there cannot be any
I/O pending. Hence we should be setting the 'no flush'
and 'skip lockfs' flag to avoid delays during creation.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 15c91c9..c2ae83b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -321,11 +321,16 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 
 	dm_task_no_open_count(dmt);
 
-	if (cookie &&
-	    !dm_task_set_cookie(dmt, cookie,
-				DM_UDEV_DISABLE_LIBRARY_FALLBACK)) {
-		dm_udev_complete(*cookie);
-		goto freeout;
+	if (cookie) {
+		if (!dm_task_set_cookie(dmt, cookie,
+					DM_UDEV_DISABLE_LIBRARY_FALLBACK)) {
+			dm_udev_complete(*cookie);
+			goto freeout;
+		}
+		dm_task_skip_lockfs(dmt);
+#ifdef LIBDM_API_FLUSH
+		dm_task_no_flush(dmt);
+#endif
 	}
 	r = dm_task_run (dmt);
 
-- 
2.6.6
