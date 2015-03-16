From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 59/78] Revert to ACT_RELOAD in domap if the map
	exists
Date: Mon, 16 Mar 2015 13:36:46 +0100
Message-ID: <1426509425-15978-60-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

ACT_CREATE checks for an existing map already, so we might as
well revert to ACT_RELOAD in these cases and avoid an error
during configuration.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c | 16 ++++++++--------
 libmultipath/devmapper.c |  5 ++++-
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index ef217de..24ad948 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -577,7 +577,7 @@ fail:
 extern int
 domap (struct multipath * mpp, char * params)
 {
-	int r = 0;
+	int r = DOMAP_FAIL;
 
 	/*
 	 * last chance to quit before touching the devmaps
@@ -587,6 +587,12 @@ domap (struct multipath * mpp, char * params)
 		return DOMAP_DRY;
 	}
 
+	if (mpp->action == ACT_CREATE &&
+	    dm_map_present(mpp->alias)) {
+		condlog(3, "%s: map already present", mpp->alias);
+		mpp->action = ACT_RELOAD;
+	}
+
 	switch (mpp->action) {
 	case ACT_REJECT:
 	case ACT_NOTHING:
@@ -609,12 +615,6 @@ domap (struct multipath * mpp, char * params)
 			return DOMAP_RETRY;
 		}
 
-		if (dm_map_present(mpp->alias)) {
-			condlog(3, "%s: map already present", mpp->alias);
-			lock_multipath(mpp, 0);
-			break;
-		}
-
 		r = dm_addmap_create(mpp, params);
 
 		lock_multipath(mpp, 0);
@@ -650,7 +650,7 @@ domap (struct multipath * mpp, char * params)
 		break;
 	}
 
-	if (r) {
+	if (r == DOMAP_OK) {
 		/*
 		 * DM_DEVICE_CREATE, DM_DEVICE_RENAME, or DM_DEVICE_RELOAD
 		 * succeeded
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 1712c56..560d418 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -347,8 +347,11 @@ dm_addmap_create (struct multipath *mpp, char * params) {
 			condlog(3, "%s: failed to load map (a path might be in use)", mpp->alias);
 			dm_flush_map_nosync(mpp->alias);
 		}
-		if (err != EROFS)
+		if (err != EROFS) {
+			condlog(3, "%s: failed to load map, error %d",
+				mpp->alias, err);
 			break;
+		}
 	}
 	return 0;
 }
-- 
1.8.4.5
