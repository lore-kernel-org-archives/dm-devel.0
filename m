From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 6/6] mpath_persist: Don't join threads that don't
	exist
Date: Tue,  9 May 2017 11:57:05 -0500
Message-ID: <1494349025-6561-7-git-send-email-bmarzins@redhat.com>
References: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
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

There are a couple of places in the mpath_persist code that were calling
pthread join, even if the pthread_create call failed, and the thread id
was undefined. This can cause crashes, so don't do it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c | 34 ++++++++++++++++++++++------------
 libmpathpersist/mpath_persist.h |  3 ++-
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 982c795..bf06efe 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -519,14 +519,17 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 			rc = pthread_create(&thread[count].id, &attr, mpath_prout_pthread_fn, (void *)(&thread[count].param));
 			if (rc){
 				condlog (0, "%s: failed to create thread %d", mpp->wwid, rc);
+				thread[count].param.status = MPATH_PR_THREAD_ERROR;
 			}
 			count = count + 1;
 		}
 	}
 	for( i=0; i < active_pathcount ; i++){
-		rc = pthread_join(thread[i].id, NULL);
-		if (rc){
-			condlog (0, "%s: Thread[%d] failed to join thread %d", mpp->wwid, i, rc);
+		if (thread[i].param.status != MPATH_PR_THREAD_ERROR) {
+			rc = pthread_join(thread[i].id, NULL);
+			if (rc){
+				condlog (0, "%s: Thread[%d] failed to join thread %d", mpp->wwid, i, rc);
+			}
 		}
 		if (!rollback && (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)){
 			rollback = 1;
@@ -554,14 +557,17 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 						(void *)(&thread[i].param));
 				if (rc){
 					condlog (0, "%s: failed to create thread for rollback. %d",  mpp->wwid, rc);
+					thread[i].param.status = MPATH_PR_THREAD_ERROR;
 				}
 			}
 		}
 		for(i=0; i < active_pathcount ; i++){
-			rc = pthread_join(thread[i].id, NULL);
-			if (rc){
-				condlog (3, "%s: failed to join thread while rolling back %d",
-						mpp->wwid, i);
+			if (thread[i].param.status != MPATH_PR_THREAD_ERROR) {
+				rc = pthread_join(thread[i].id, NULL);
+				if (rc){
+					condlog (3, "%s: failed to join thread while rolling back %d",
+						 mpp->wwid, i);
+				}
 			}
 		}
 	}
@@ -630,7 +636,7 @@ int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
 	rc = pthread_create(&thread, &attr, mpath_prout_pthread_fn, (void *)(&param));
 	if (rc){
 		condlog (3, "%s: failed to create thread %d", dev, rc);
-		return MPATH_PR_OTHER;
+		return MPATH_PR_THREAD_ERROR;
 	}
 	/* Free attribute and wait for the other threads */
 	pthread_attr_destroy(&attr);
@@ -695,16 +701,20 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
 			rc = pthread_create (&thread[count].id, &attr, mpath_prout_pthread_fn,
 					(void *) (&thread[count].param));
-			if (rc)
+			if (rc) {
 				condlog (0, "%s: failed to create thread. %d",  mpp->wwid, rc);
+				thread[count].param.status = MPATH_PR_THREAD_ERROR;
+			}
 			count = count + 1;
 		}
 	}
 	pthread_attr_destroy (&attr);
 	for (i = 0; i < active_pathcount; i++){
-		rc = pthread_join (thread[i].id, NULL);
-		if (rc){
-			condlog (1, "%s: failed to join thread.  %d",  mpp->wwid,  rc);
+		if (thread[i].param.status != MPATH_PR_THREAD_ERROR) {
+			rc = pthread_join (thread[i].id, NULL);
+			if (rc){
+				condlog (1, "%s: failed to join thread.  %d",  mpp->wwid,  rc);
+			}
 		}
 	}
 
diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index 79de5b5..0f95943 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -59,7 +59,8 @@ extern "C" {
 #define MPATH_PR_RESERV_CONFLICT	11  /* Reservation conflict on the device */
 #define MPATH_PR_FILE_ERROR		12  /* file (device node) problems(e.g. not found)*/
 #define MPATH_PR_DMMP_ERROR		13  /* DMMP related error.(e.g Error in getting dm info */
-#define MPATH_PR_OTHER			14  /*other error/warning has occurred(transport
+#define MPATH_PR_THREAD_ERROR		14  /* pthreads error (e.g. unable to create new thread) */
+#define MPATH_PR_OTHER			15  /*other error/warning has occurred(transport
 					      or driver error) */
 
 /* PR MASK */
-- 
1.8.3.1
