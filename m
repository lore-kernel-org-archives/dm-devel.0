From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH] mpathpersist: fix one more crash possiblity
Date: Sat, 13 May 2017 00:44:58 -0500
Message-ID: <1494654298-22658-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

when mpathpersist goes to rollback reservations, it doesn't do a
rollback (and thus doesn't create a pthread) on paths that didn't
successfully create a reservation in the first place. It also doesn't
do any rollbacks at all if the last path in the multipath device was down,
which is completely broken. However it still tries to join these
non-existant pthreads, causing crashes.  To fix this, set the status to
-1 (now MPATH_PR_SKIP) on threadinfos that don't get rollbacks, and
remove the broken path state checking.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c | 13 +++++++------
 libmpathpersist/mpath_persist.h |  1 +
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index bf06efe..7fd4cb8 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -481,7 +481,7 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 		thread[i].param.rq_type = rq_type;
 		thread[i].param.paramp = paramp;
 		thread[i].param.noisy = noisy;
-		thread[i].param.status = -1;
+		thread[i].param.status = MPATH_PR_SKIP;
 
 		condlog (3, "THRED ID [%d] INFO]", i);
 		condlog (3, "rq_servact=%d ", thread[i].param.rq_servact);
@@ -548,8 +548,7 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	if (rollback && ((rq_servact == MPATH_PROUT_REG_SA) && sa_key != 0 )){
 		condlog (3, "%s: ERROR: initiating pr out rollback", mpp->wwid);
 		for( i=0 ; i < active_pathcount ; i++){
-			if((thread[i].param.status == MPATH_PR_SUCCESS) &&
-					((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
+			if(thread[i].param.status == MPATH_PR_SUCCESS) {
 				memcpy(&thread[i].param.paramp->key, &thread[i].param.paramp->sa_key, 8);
 				memset(&thread[i].param.paramp->sa_key, 0, 8);
 				thread[i].param.status = MPATH_PR_SUCCESS;
@@ -559,10 +558,12 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 					condlog (0, "%s: failed to create thread for rollback. %d",  mpp->wwid, rc);
 					thread[i].param.status = MPATH_PR_THREAD_ERROR;
 				}
-			}
+			} else
+				thread[i].param.status = MPATH_PR_SKIP;
 		}
 		for(i=0; i < active_pathcount ; i++){
-			if (thread[i].param.status != MPATH_PR_THREAD_ERROR) {
+			if (thread[i].param.status != MPATH_PR_SKIP &&
+			    thread[i].param.status != MPATH_PR_THREAD_ERROR) {
 				rc = pthread_join(thread[i].id, NULL);
 				if (rc){
 					condlog (3, "%s: failed to join thread while rolling back %d",
@@ -676,7 +677,7 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 		thread[i].param.rq_type = rq_type;
 		thread[i].param.paramp = paramp;
 		thread[i].param.noisy = noisy;
-		thread[i].param.status = -1;
+		thread[i].param.status = MPATH_PR_SKIP;
 
 		condlog (3, " path count = %d", i);
 		condlog (3, "rq_servact=%d ", thread[i].param.rq_servact);
diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index 0f95943..1a34ce7 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -43,6 +43,7 @@ extern "C" {
 
 
 /* PR RETURN_STATUS */
+#define MPATH_PR_SKIP			-1  /* skipping this path */
 #define MPATH_PR_SUCCESS		0
 #define MPATH_PR_SYNTAX_ERROR		1   /*  syntax error or invalid parameter */
 					    /* status for check condition */
-- 
1.8.3.1
