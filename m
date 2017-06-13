From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/4] libmultipath: Simplify assemble_map()
Date: Tue, 13 Jun 2017 09:33:37 -0700
Message-ID: <20170613163339.23005-3-bart.vanassche@sandisk.com>
References: <20170613163339.23005-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170613163339.23005-1-bart.vanassche@sandisk.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Introduce a macro for appending formatted text to the output buffer.
Eliminate the local variables 'shift' and 'freechar'. Move the
code for freeing a temporary buffer to the end of the function.
Handle snprintf() conversion errors. This patch avoids that gcc 7
reports the following warning:

dmparser.c:137:20: warning: '__builtin_snprintf' output truncated before the last format character [-Wformat-truncation=]
  snprintf(p, 1, "\n");
                    ^

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/dmparser.c | 67 +++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 469e60d2..ba09dc72 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -45,6 +45,22 @@ merge_words (char ** dst, char * word, int space)
 	return 0;
 }
 
+#define APPEND(p, end, args...)						\
+({									\
+	int ret;							\
+									\
+	ret = snprintf(p, end - p, ##args);				\
+	if (ret < 0) {							\
+		condlog(0, "%s: conversion error", mp->alias);		\
+		goto err;						\
+	}								\
+	p += ret;							\
+	if (p >= end) {							\
+		condlog(0, "%s: params too small", mp->alias);		\
+		goto err;						\
+	}								\
+})
+
 /*
  * Transforms the path group vector into a proper device map string
  */
@@ -52,10 +68,10 @@ int
 assemble_map (struct multipath * mp, char * params, int len)
 {
 	int i, j;
-	int shift, freechar;
 	int minio;
 	int nr_priority_groups, initial_pg_nr;
 	char * p, * f;
+	const char *const end = params + len;
 	char no_path_retry[] = "queue_if_no_path";
 	char retain_hwhandler[] = "retain_attached_hw_handler";
 	struct pathgroup * pgp;
@@ -63,7 +79,6 @@ assemble_map (struct multipath * mp, char * params, int len)
 
 	minio = mp->minio;
 	p = params;
-	freechar = len;
 
 	nr_priority_groups = VECTOR_SIZE(mp->pg);
 	initial_pg_nr = (nr_priority_groups ? mp->bestpg : 0);
@@ -86,29 +101,13 @@ assemble_map (struct multipath * mp, char * params, int len)
 	if (mp->retain_hwhandler == RETAIN_HWHANDLER_ON)
 		add_feature(&f, retain_hwhandler);
 
-	shift = snprintf(p, freechar, "%s %s %i %i",
-			 f, mp->hwhandler,
-			 nr_priority_groups, initial_pg_nr);
-
-	FREE(f);
-
-	if (shift >= freechar) {
-		condlog(0, "%s: params too small", mp->alias);
-		return 1;
-	}
-	p += shift;
-	freechar -= shift;
+	APPEND(p, end, "%s %s %i %i", f, mp->hwhandler, nr_priority_groups,
+	       initial_pg_nr);
 
 	vector_foreach_slot (mp->pg, pgp, i) {
 		pgp = VECTOR_SLOT(mp->pg, i);
-		shift = snprintf(p, freechar, " %s %i 1", mp->selector,
-				 VECTOR_SIZE(pgp->paths));
-		if (shift >= freechar) {
-			condlog(0, "%s: params too small", mp->alias);
-			return 1;
-		}
-		p += shift;
-		freechar -= shift;
+		APPEND(p, end, " %s %i 1", mp->selector,
+		       VECTOR_SIZE(pgp->paths));
 
 		vector_foreach_slot (pgp->paths, pp, j) {
 			int tmp_minio = minio;
@@ -118,28 +117,24 @@ assemble_map (struct multipath * mp, char * params, int len)
 				tmp_minio = minio * pp->priority;
 			if (!strlen(pp->dev_t) ) {
 				condlog(0, "dev_t not set for '%s'", pp->dev);
-				return 1;
+				goto err;
 			}
-			shift = snprintf(p, freechar, " %s %d",
-					 pp->dev_t, tmp_minio);
-			if (shift >= freechar) {
-				condlog(0, "%s: params too small", mp->alias);
-				return 1;
-			}
-			p += shift;
-			freechar -= shift;
+			APPEND(p, end, " %s %d", pp->dev_t, tmp_minio);
 		}
 	}
-	if (freechar < 1) {
-		condlog(0, "%s: params too small", mp->alias);
-		return 1;
-	}
-	snprintf(p, 1, "\n");
+	APPEND(p, end, "\n");
 
+	FREE(f);
 	condlog(3, "%s: assembled map [%s]", mp->alias, params);
 	return 0;
+
+err:
+	FREE(f);
+	return 1;
 }
 
+#undef APPEND
+
 int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 		    int is_daemon)
 {
-- 
2.12.2
