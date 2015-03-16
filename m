From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/78] mpath_persist: Do not call exit() from a
	shared library
Date: Mon, 16 Mar 2015 13:35:49 +0100
Message-ID: <1426509425-15978-3-git-send-email-hare@suse.de>
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

mpath_persist is a shared library, and shouldn't call exit().
Just return an error code here.

And cleanup formatting while we're at it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmpathpersist/mpath_persist.c | 52 ++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index bd30125..9f65ca6 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -386,18 +386,20 @@ void * mpath_prin_pthread_fn (void *p)
 	int ret;
 	struct prin_param * pparam = (struct prin_param *)p;
 
-	ret = prin_do_scsi_ioctl(pparam->dev, pparam->rq_servact, pparam->resp,  pparam->noisy);
-	pparam->status = ret;	
-	pthread_exit(NULL);	
+	ret = prin_do_scsi_ioctl(pparam->dev, pparam->rq_servact,
+				 pparam->resp,  pparam->noisy);
+	pparam->status = ret;
+	pthread_exit(NULL);
 }
 
-int mpath_send_prin_activepath (char * dev, int rq_servact, struct prin_resp * resp, int noisy)
+int mpath_send_prin_activepath (char * dev, int rq_servact,
+				struct prin_resp * resp, int noisy)
 {
 
 	int rc;
 
 	rc = prin_do_scsi_ioctl(dev, rq_servact, resp,  noisy);
-	
+
 	return (rc);
 }
 
@@ -409,14 +411,14 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	struct pathgroup *pgp = NULL;
 	struct path *pp = NULL;
 	int rollback = 0;
-	int active_pathcount=0;	
+	int active_pathcount=0;
 	int rc;
 	int count=0;
 	int status = MPATH_PR_SUCCESS;
 	uint64_t sa_key = 0;
 
 	if (!mpp)
-		return MPATH_PR_DMMP_ERROR; 
+		return MPATH_PR_DMMP_ERROR;
 
 	active_pathcount = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
 
@@ -444,12 +446,13 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 
 		condlog (3, "THRED ID [%d] INFO]", i);
 		condlog (3, "rq_servact=%d ", thread[i].param.rq_servact);
-		condlog (3, "rq_scope=%d ", thread[i].param.rq_scope); 
-		condlog (3, "rq_type=%d ", thread[i].param.rq_type);  
-		condlog (3, "rkey="); 
-		condlog (3, "paramp->sa_flags =%02x ", thread[i].param.paramp->sa_flags); 
-		condlog (3, "noisy=%d ", thread[i].param.noisy); 
-		condlog (3, "status=%d ", thread[i].param.status); 
+		condlog (3, "rq_scope=%d ", thread[i].param.rq_scope);
+		condlog (3, "rq_type=%d ", thread[i].param.rq_type);
+		condlog (3, "rkey=");
+		condlog (3, "paramp->sa_flags =%02x ",
+			 thread[i].param.paramp->sa_flags);
+		condlog (3, "noisy=%d ", thread[i].param.noisy);
+		condlog (3, "status=%d ", thread[i].param.status);
 	}
 
 	pthread_attr_t attr;
@@ -548,13 +551,15 @@ int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope,
 	vector_foreach_slot (mpp->pg, pgp, j){
 		vector_foreach_slot (pgp->paths, pp, i){
 			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
-				condlog (1, "%s: %s path not up. Skip", mpp->wwid, pp->dev); 
+				condlog (1, "%s: %s path not up. Skip",
+					 mpp->wwid, pp->dev);
 				continue;
 			}
 
 			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
-			ret = send_prout_activepath(pp->dev, rq_servact, rq_scope, rq_type, 
-					paramp, noisy); 
+			ret = send_prout_activepath(pp->dev, rq_servact,
+						    rq_scope, rq_type,
+						    paramp, noisy);
 			return ret ;
 		}
 	}
@@ -585,7 +590,7 @@ int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
 	rc = pthread_create(&thread, &attr, mpath_prout_pthread_fn, (void *)(&param));
 	if (rc){
 		condlog (3, "%s: failed to create thread %d", dev, rc);
-		exit(-1);
+		return MPATH_PR_OTHER;
 	}
 	/* Free attribute and wait for the other threads */
 	pthread_attr_destroy(&attr);
@@ -723,16 +728,21 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 		condlog (3, "%s: reservation key set.", mpp->wwid);
 	}
 
-	mpath_prout_common (mpp, MPATH_PROUT_CLEAR_SA, rq_scope, rq_type, pamp,
-			noisy);
+	status = mpath_prout_common (mpp, MPATH_PROUT_CLEAR_SA,
+				     rq_scope, rq_type, pamp, noisy);
+
+	if (status) {
+		condlog(0, "%s: failed to send CLEAR_SA", mpp->wwid);
+		goto out1;
+	}
 
 	pamp->num_transportid = 1;
 	pptr=pamp->trnptid_list[0];
 
 	for (i = 0; i < num; i++){
-		if (mpp->reservation_key && 
+		if (mpp->reservation_key &&
 			memcmp(pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key,
-			mpp->reservation_key, 8)){	
+			       mpp->reservation_key, 8)){
 			/*register with tarnsport id*/
 			memset(pamp, 0, length);
 			pamp->trnptid_list[0] = pptr;
-- 
1.8.4.5
