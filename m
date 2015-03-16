From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 37/78] mpath_persist: cleanup
Date: Mon, 16 Mar 2015 13:36:24 +0100
Message-ID: <1426509425-15978-38-git-send-email-hare@suse.de>
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

Cleanup whitespace issues and use the standard 'major' and 'minor'
macros.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmpathpersist/mpath_persist.c | 106 +++++++++++++++++++++-------------------
 libmpathpersist/mpathpr.h       |   3 +-
 2 files changed, 58 insertions(+), 51 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index d427c5b..eba26a2 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -1,7 +1,7 @@
 #include <libdevmapper.h>
 #include <defaults.h>
 #include <sys/stat.h>
-#include <linux/kdev_t.h>
+#include <sys/types.h>
 #include <fcntl.h>
 #include <vector.h>
 #include <checkers.h>
@@ -19,6 +19,7 @@
 #include <dmparser.h>
 #include <ctype.h>
 #include <propsel.h>
+#include <util.h>
 
 #include "mpath_persist.h"
 #include "mpathpr.h"
@@ -71,7 +72,8 @@ updatepaths (struct multipath * mpp)
 
 		vector_foreach_slot (pgp->paths, pp, j){
 			if (!strlen(pp->dev)){
-				if (devt2devname(pp->dev, pp->dev_t)){
+				if (devt2devname(pp->dev, PATH_SIZE,
+						 pp->dev_t)){
 					/*
 					 * path is not in sysfs anymore
 					 */
@@ -94,7 +96,7 @@ updatepaths (struct multipath * mpp)
 	return 0;
 }
 
-int 
+int
 mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 	struct prin_resp * resp, int noisy)
 {
@@ -104,14 +106,19 @@ mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 
 	vector_foreach_slot (mpp->pg, pgp, j){
 		vector_foreach_slot (pgp->paths, pp, i){
-			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
-				condlog(2, "%s: %s not available. Skip.", mpp->wwid, pp->dev);
-				condlog(3, "%s: status = %d.", mpp->wwid, pp->state);
+			if (!((pp->state == PATH_UP) ||
+			      (pp->state == PATH_GHOST))){
+				condlog(2, "%s: %s not available. Skip.",
+					mpp->wwid, pp->dev);
+				condlog(3, "%s: status = %d.",
+					mpp->wwid, pp->state);
 				continue;
 			}
 
-			condlog(3, "%s: sending pr in command to %s ", mpp->wwid, pp->dev);
-			ret = mpath_send_prin_activepath(pp->dev, rq_servact, resp, noisy);
+			condlog(3, "%s: sending pr in command to %s ",
+				mpp->wwid, pp->dev);
+			ret = mpath_send_prin_activepath(pp->dev, rq_servact,
+							 resp, noisy);
 			switch(ret)
 			{
 				case MPATH_PR_SUCCESS:
@@ -122,10 +129,11 @@ mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 			}
 		}
 	}
-	return ret;	
+	return ret;
 }
 
-int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)
+int mpath_persistent_reserve_in (int fd, int rq_servact,
+	struct prin_resp *resp, int noisy, int verbose)
 {
 	struct stat info;
 	vector curmp = NULL;
@@ -141,14 +149,14 @@ int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp *resp,
 	if (fstat( fd, &info) != 0){
 		condlog(0, "stat error %d", fd);
 		return MPATH_PR_FILE_ERROR;
-	} 
+	}
 	if(!S_ISBLK(info.st_mode)){
 		condlog(0, "Failed to get major:minor. fd = %d", fd);
 		return MPATH_PR_FILE_ERROR;
 	}
 
-	major = (int)MAJOR(info.st_rdev);
-	minor = (int)MINOR(info.st_rdev);	
+	major = major(info.st_rdev);
+	minor = minor(info.st_rdev);
 	condlog(4, "Device %d:%d:  ", major, minor);
 
 	/* get alias from major:minor*/
@@ -201,14 +209,14 @@ int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp *resp,
 
 out1:
 	free_multipathvec(curmp, KEEP_PATHS);
-	free_pathvec(pathvec, FREE_PATHS);	
+	free_pathvec(pathvec, FREE_PATHS);
 out:
 	FREE(alias);
-	return ret; 						
+	return ret;
 }
 
 int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
-		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy, int verbose)
+	unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy, int verbose)
 {
 
 	struct stat info;
@@ -223,7 +231,7 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	int ret;
 	int j;
 	unsigned char *keyp;
-	uint64_t prkey;		
+	uint64_t prkey;
 
 	conf->verbosity = verbose;
 
@@ -234,11 +242,11 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 
 	if(!S_ISBLK(info.st_mode)){
 		condlog(3, "Failed to get major:minor. fd=%d", fd);
-		return MPATH_PR_FILE_ERROR;	
-	}	
+		return MPATH_PR_FILE_ERROR;
+	}
 
-	major = (int)MAJOR(info.st_rdev);
-	minor = (int)MINOR(info.st_rdev);
+	major = major(info.st_rdev);
+	minor = minor(info.st_rdev);
 	condlog(4, "Device  %d:%d", major, minor);
 
 	/* get WWN of the device from major:minor*/
@@ -292,22 +300,22 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 
 	switch(rq_servact)
 	{
-		case MPATH_PROUT_REG_SA: 
-		case MPATH_PROUT_REG_IGN_SA:  
-			ret= mpath_prout_reg(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
-			break;
-		case MPATH_PROUT_RES_SA :  
-		case MPATH_PROUT_PREE_SA :  
-		case MPATH_PROUT_PREE_AB_SA :  
-		case MPATH_PROUT_CLEAR_SA:  
-			ret = mpath_prout_common(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
-			break;
-		case MPATH_PROUT_REL_SA:
-			ret = mpath_prout_rel(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
-			break;
-		default:
-			ret = MPATH_PR_OTHER;
-			goto out1;
+	case MPATH_PROUT_REG_SA:
+	case MPATH_PROUT_REG_IGN_SA:
+		ret= mpath_prout_reg(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
+		break;
+	case MPATH_PROUT_RES_SA :
+	case MPATH_PROUT_PREE_SA :
+	case MPATH_PROUT_PREE_AB_SA :
+	case MPATH_PROUT_CLEAR_SA:
+		ret = mpath_prout_common(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
+		break;
+	case MPATH_PROUT_REL_SA:
+		ret = mpath_prout_rel(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
+		break;
+	default:
+		ret = MPATH_PR_OTHER;
+		goto out1;
 	}
 
 	if ((ret == MPATH_PR_SUCCESS) && ((rq_servact == MPATH_PROUT_REG_SA) ||
@@ -326,7 +334,7 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 		else
 			update_prflag(alias, "set", noisy);
 	} else {
-		if ((ret == MPATH_PR_SUCCESS) && ((rq_servact == MPATH_PROUT_CLEAR_SA) || 
+		if ((ret == MPATH_PR_SUCCESS) && ((rq_servact == MPATH_PROUT_CLEAR_SA) ||
 					(rq_servact == MPATH_PROUT_PREE_AB_SA ))){
 			update_prflag(alias, "unset", noisy);
 		}
@@ -337,7 +345,7 @@ out1:
 
 out:
 	FREE(alias);
-	return ret; 
+	return ret;
 }
 
 int
@@ -365,9 +373,9 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
 		dm_get_map(mpp->alias, &mpp->size, params);
 		condlog(3, "params = %s", params);
 		dm_get_status(mpp->alias, status);
-                condlog(3, "status = %s", status);
+		condlog(3, "status = %s", status);
 		disassemble_map (pathvec, params, mpp);
-		
+
 		/*
 		 * disassemble_map() can add new paths to pathvec.
 		 * If not in "fast list mode", we need to fetch information
@@ -542,7 +550,7 @@ void * mpath_prout_pthread_fn(void *p)
 }
 
 int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope,
-        unsigned int rq_type, struct prout_param_descriptor* paramp, int noisy)
+	unsigned int rq_type, struct prout_param_descriptor* paramp, int noisy)
 {
 	int i,j, ret;
 	struct pathgroup *pgp = NULL;
@@ -600,7 +608,7 @@ int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
 }
 
 int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
-        unsigned int rq_type, struct prout_param_descriptor * paramp, int noisy)
+	unsigned int rq_type, struct prout_param_descriptor * paramp, int noisy)
 {
 	int i, j;
 	int num = 0;
@@ -615,7 +623,7 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	struct prout_param_descriptor *pamp;
 	struct prin_resp *pr_buff;
 	int length;
-	struct transportid *pptr;	
+	struct transportid *pptr;
 
 	if (!mpp)
 		return MPATH_PR_DMMP_ERROR;
@@ -649,7 +657,7 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 				condlog (1, "%s: %s path not up.", mpp->wwid, pp->dev);
 				continue;
 			}
-			
+
 			strncpy(thread[count].param.dev, pp->dev, FILE_NAME_SIZE);
 			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
 			rc = pthread_create (&thread[count].id, &attr, mpath_prout_pthread_fn,
@@ -686,13 +694,13 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	num = resp.prin_descriptor.prin_readresv.additional_length / 8;
 	if (num == 0){
 		condlog (2, "%s: Path holding reservation is released.", mpp->wwid);
-		return MPATH_PR_SUCCESS;	
+		return MPATH_PR_SUCCESS;
 	}
 	condlog (2, "%s: Path holding reservation is not avialable.", mpp->wwid);
 
 	pr_buff =  mpath_alloc_prin_response(MPATH_PRIN_RFSTAT_SA);
 	if (!pr_buff){
-		condlog (0, "%s: failed to  alloc pr in response buffer.", mpp->wwid);	
+		condlog (0, "%s: failed to  alloc pr in response buffer.", mpp->wwid);
 		return MPATH_PR_OTHER;
 	}
 
@@ -778,7 +786,7 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 		memset (pamp, 0, length);
 		memcpy (pamp->sa_key, mpp->reservation_key, 8);
 		memset (pamp->key, 0, 8);
-		status = mpath_prout_reg(mpp, MPATH_PROUT_REG_SA, rq_scope, rq_type, pamp, noisy);	
+		status = mpath_prout_reg(mpp, MPATH_PROUT_REG_SA, rq_scope, rq_type, pamp, noisy);
 	}
 
 
@@ -812,7 +820,7 @@ void * mpath_alloc_prin_response(int prin_sa)
 			memset(ptr, 0, size);
 			break;
 		case MPATH_PRIN_RFSTAT_SA:
-			size = sizeof(struct print_fulldescr_list) + 
+			size = sizeof(struct print_fulldescr_list) +
 				sizeof(struct prin_fulldescr *)*MPATH_MX_TIDS;
 			ptr = malloc(size);
 			memset(ptr, 0, size);
diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
index 54dfb3e..d69a732 100644
--- a/libmpathpersist/mpathpr.h
+++ b/libmpathpersist/mpathpr.h
@@ -50,6 +50,5 @@ int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
 int update_prflag(char * arg1, char * arg2, int noisy);
 void * mpath_alloc_prin_response(int prin_sa);
 int update_map_pr(struct multipath *mpp);
-int devt2devname (char *devname, char *devt);
 
-#endif  
+#endif
-- 
1.8.4.5
