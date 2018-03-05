From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 02/23] libmultipath: remove unused "stdout
	helpers"
Date: Tue,  6 Mar 2018 00:14:46 +0100
Message-ID: <20180305231507.10386-3-mwilck@suse.com>
References: <20180305231507.10386-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 26 --------------------------
 libmultipath/print.h |  5 -----
 2 files changed, 31 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 65a98247a753..27636c35e5ff 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1765,32 +1765,6 @@ void print_path(struct path *pp, char *style)
 	printf("%s", line);
 }
 
-void print_multipath(struct multipath *mpp, char *style)
-{
-	char line[MAX_LINE_LEN];
-
-	memset(&line[0], 0, MAX_LINE_LEN);
-	snprint_multipath(&line[0], MAX_LINE_LEN, style, mpp, 1);
-	printf("%s", line);
-}
-
-void print_pathgroup(struct pathgroup *pgp, char *style)
-{
-	char line[MAX_LINE_LEN];
-
-	memset(&line[0], 0, MAX_LINE_LEN);
-	snprint_pathgroup(&line[0], MAX_LINE_LEN, style, pgp);
-	printf("%s", line);
-}
-
-void print_map(struct multipath *mpp, char *params)
-{
-	if (mpp->size && params)
-		printf("0 %llu %s %s\n",
-			 mpp->size, TGT_MPATH, params);
-	return;
-}
-
 void print_all_paths(vector pathvec, int banner)
 {
 	print_all_paths_custo(pathvec, banner, PRINT_PATH_LONG);
diff --git a/libmultipath/print.h b/libmultipath/print.h
index b8c343679e15..734f43fd4cb6 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -119,10 +119,5 @@ int snprint_tgt_wwnn (char *, size_t, struct path *);
 int snprint_tgt_wwpn (char *, size_t, struct path *);
 
 void print_multipath_topology (struct multipath * mpp, int verbosity);
-void print_path (struct path * pp, char * style);
-void print_multipath (struct multipath * mpp, char * style);
-void print_pathgroup (struct pathgroup * pgp, char * style);
-void print_map (struct multipath * mpp, char * params);
 void print_all_paths (vector pathvec, int banner);
 void print_all_paths_custo (vector pathvec, int banner, char *fmt);
-void print_hwtable (vector hwtable);
-- 
2.16.1
