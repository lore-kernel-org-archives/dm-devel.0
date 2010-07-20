From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] libmultipath: always allocate space for alias
Date: Tue, 20 Jul 2010 10:10:14 +0200
Message-ID: <20100720081014.5885D29D22@ochil.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


We should always allocating space for alias. This makes
freeing up and allocation tracking far easier.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/propsel.c     |    6 +++---
 libmultipath/structs.c     |    4 +---
 libmultipath/structs_vec.c |   10 ++++++++--
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index ee4109e..3074ce1 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -239,7 +239,7 @@ extern int
 select_alias (struct multipath * mp)
 {
 	if (mp->mpe && mp->mpe->alias)
-		mp->alias = mp->mpe->alias;
+		mp->alias = STRDUP(mp->mpe->alias);
 	else {
 		mp->alias = NULL;
 		if (conf->user_friendly_names) {
@@ -257,7 +257,7 @@ select_alias (struct multipath * mp)
 			}
 		}
 		if (mp->alias == NULL)
-			mp->alias = mp->wwid;
+			mp->alias = STRDUP(mp->wwid);
 	}
 
 	return 0;
@@ -472,7 +472,7 @@ select_pg_timeout(struct multipath *mp)
 		return 0;
 	}
 	mp->pg_timeout = PGTIMEOUT_UNDEF;
-	condlog(3, "pg_timeout = NONE (internal default)");
+	condlog(3, "%s: pg_timeout = NONE (internal default)", mp->alias);
 	return 0;
 }
 
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index a4b86d2..82df680 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -163,9 +163,7 @@ free_multipath (struct multipath * mpp, int free_paths)
 
 	free_multipath_attributes(mpp);
 
-	if (mpp->alias &&
-	    (!mpp->mpe || (mpp->mpe && mpp->alias != mpp->mpe->alias)) &&
-	    (mpp->wwid && mpp->alias != mpp->wwid)) {
+	if (mpp->alias) {
 		FREE(mpp->alias);
 		mpp->alias = NULL;
 	}
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 699efa1..51c41e8 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -335,8 +335,13 @@ retry:
 	condlog(3, "%s: discover", mpp->alias);
 
 	if (update_multipath_strings(mpp, vecs->pathvec)) {
-		char new_alias[WWID_SIZE];
+		char *new_alias;
 
+		new_alias = MALLOC(WWID_SIZE);
+		if (!new_alias) {
+			condlog(0, "%s: failed to allocate alias", mpp->alias);
+			goto out;
+		}
 		/*
 		 * detect an external rename of the multipath device
 		 */
@@ -344,7 +349,8 @@ retry:
 			condlog(3, "%s multipath mapped device name has "
 				"changed from %s to %s", mpp->wwid,
 				mpp->alias, new_alias);
-			strcpy(mpp->alias, new_alias);
+			FREE(mpp->alias);
+			mpp->alias = new_alias;
 
 			if (mpp->waiter)
 				strncpy(((struct event_thread *)mpp->waiter)->mapname,
-- 
1.6.0.2
