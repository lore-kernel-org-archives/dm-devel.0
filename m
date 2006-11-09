From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipath devices are not created for the Luns
	having 8 paths
Date: Thu, 9 Nov 2006 22:16:15 +0000 (UTC)
Message-ID: <20061109221551.D285773C48@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Date: Wed Nov 8 09:40:12 2006 +0100
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: dm-devel.ids

When setting the rr_weight to 'priorities' multipath fails to
setup a device-mapper table. This is due to a missing initialization
of the minio field, which will be multiplied by the path priority
for each path. This results in an eventual overflow of the minio
field and an invalid device mapper table.

References: 203823
Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 libmultipath/dmparser.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

df3c39a22efd7e028aca40320ab2cbbd1c4b3bd5
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 2b170c6..c450882 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -84,11 +84,14 @@ assemble_map (struct multipath * mp)
 		freechar -= shift;
 
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (mp->rr_weight == RR_WEIGHT_PRIO && pp->priority)
-				minio *= pp->priority;
+			int tmp_minio = minio;
+
+			if (mp->rr_weight == RR_WEIGHT_PRIO 
+			    && pp->priority > 0)
+				tmp_minio = minio * pp->priority;
 
 			shift = snprintf(p, freechar, " %s %d",
-					 pp->dev_t, minio);
+					 pp->dev_t, tmp_minio);
 			if (shift >= freechar) {
 				fprintf(stderr, "mp->params too small\n");
 				return 1;
@@ -117,6 +120,7 @@ disassemble_map (vector pathvec, char * 
 	int num_pg_args = 0;
 	int num_paths = 0;
 	int num_paths_args = 0;
+	int def_minio = 0;
 	struct path * pp;
 	struct pathgroup * pgp;
 
@@ -305,12 +309,15 @@ #endif
 				if (k == 0 && !strncmp(mpp->selector,
 						       "round-robin", 11)) {
 					p += get_word(p, &word);
-					mpp->minio = atoi(word);
+					def_minio = atoi(word);
 
-					if (mpp->rr_weight)
-						mpp->minio /= mpp->rr_weight;
+					if (mpp->rr_weight == RR_WEIGHT_PRIO 
+					    && pp->priority > 0)
+						def_minio /= pp->priority;
 
 					FREE(word);
+					if (def_minio != mpp->minio)
+						mpp->minio = def_minio;
 				}
 				else
 					p += get_word(p, NULL);
-- 
1.3.1


--------------010500070209030807080204--
