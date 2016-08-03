From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/5] multipath-tools: fix spacing around operators
Date: Wed,  3 Aug 2016 20:13:57 +0200
Message-ID: <1470248040-11789-2-git-send-email-xose.vazquez@gmail.com>
References: <1470248040-11789-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470248040-11789-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Found by checkpatch - ERROR: need consistent spacing around "x"

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/ps3.c                    | 2 +-
 libmpathpersist/mpath_persist.c | 2 +-
 libmultipath/blacklist.c        | 2 +-
 libmultipath/checkers/tur.c     | 2 +-
 mpathpersist/main.c             | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kpartx/ps3.c b/kpartx/ps3.c
index 2fe868d..8455097 100644
--- a/kpartx/ps3.c
+++ b/kpartx/ps3.c
@@ -28,7 +28,7 @@ struct disklabel {
 	u_int64_t d_res2;
 	u_int64_t d_res3;
 	struct d_partition d_partitions[MAX_PARTITIONS];
-	u_int8_t d_pad[0x600 - MAX_PARTITIONS * sizeof(struct d_partition)- 0x30];
+	u_int8_t d_pad[0x600 - MAX_PARTITIONS * sizeof(struct d_partition) - 0x30];
 };
 
 static int
diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 252d6fc..c5be6cd 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -514,7 +514,7 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 			if (rc){
 				condlog (0, "%s: failed to create thread %d", mpp->wwid, rc);
 			}
-			count = count +1;
+			count = count + 1;
 		}
 	}
 	for( i=0; i < active_pathcount ; i++){
diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 2400eda..9687399 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -210,7 +210,7 @@ setup_default_blist (struct config * conf)
 			if (alloc_ble_device(conf->blist_device))
 				return 1;
 			ble = VECTOR_SLOT(conf->blist_device,
-					  VECTOR_SIZE(conf->blist_device) -1);
+					  VECTOR_SIZE(conf->blist_device) - 1);
 			if (set_ble_device(conf->blist_device,
 					   STRDUP(hwe->vendor),
 					   STRDUP(hwe->bl_product),
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index c4ef8a8..b53078f 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -345,7 +345,7 @@ libcheck_check (struct checker * c)
 		r = pthread_cond_timedwait(&ct->active, &ct->lock, &tsp);
 		tur_status = ct->state;
 		strncpy(c->message, ct->message,CHECKER_MSG_LEN);
-		c->message[CHECKER_MSG_LEN -1] = '\0';
+		c->message[CHECKER_MSG_LEN - 1] = '\0';
 		pthread_mutex_unlock(&ct->lock);
 		if (ct->thread &&
 		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 5bf0740..2cf0a9c 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -662,7 +662,7 @@ void mpath_print_buf_readfullstat( struct prin_resp *pr_buff)
 
 		if (pr_buff->prin_descriptor.prin_readfd.descriptors[i]->flag & 0x1) {
 			printf("      << Reservation holder >>\n");
-			j = ((pr_buff->prin_descriptor.prin_readfd.descriptors[i]->scope_type>> 4) & 0xf);
+			j = ((pr_buff->prin_descriptor.prin_readfd.descriptors[i]->scope_type >> 4) & 0xf);
 			if (0 == j)
 				printf("      scope: LU_SCOPE, ");
 			else
-- 
2.7.4
