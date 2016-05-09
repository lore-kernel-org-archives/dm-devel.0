From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/7] configure: Rename ACT_RENAME2 to
	ACT_FORCERENAME
Date: Mon,  9 May 2016 12:53:01 +0200
Message-ID: <1462791185-2903-4-git-send-email-hare@suse.de>
References: <1462791185-2903-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1462791185-2903-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Use a more descriptive name instead of 'ACT_RENAME2'.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/configure.c | 4 ++--
 libmultipath/configure.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index affd1d5..b976da7 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -398,7 +398,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 			strncpy(mpp->alias_old, cmpp->alias, WWID_SIZE);
 			mpp->action = ACT_RENAME;
 			if (force_reload)
-				mpp->action = ACT_RENAME2;
+				mpp->action = ACT_FORCERENAME;
 			return;
 		}
 		mpp->action = ACT_CREATE;
@@ -641,7 +641,7 @@ domap (struct multipath * mpp, char * params)
 		r = dm_rename(mpp->alias_old, mpp->alias);
 		break;
 
-	case ACT_RENAME2:
+	case ACT_FORCERENAME:
 		r = dm_rename(mpp->alias_old, mpp->alias);
 		if (r) {
 			r = dm_addmap_reload(mpp, params);
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index c014b55..f357d9a 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -18,7 +18,7 @@ enum actions {
 	ACT_RENAME,
 	ACT_CREATE,
 	ACT_RESIZE,
-	ACT_RENAME2,
+	ACT_FORCERENAME,
 };
 
 #define FLUSH_ONE 1
-- 
2.6.6
