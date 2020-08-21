From: mwilck@suse.com
Subject: [PATCH 1/3] libmultipath: update_multipath_table(): add
	flags argument
Date: Fri, 21 Aug 2020 15:54:16 +0200
Message-ID: <20200821135418.28138-2-mwilck@suse.com>
References: <20200821135418.28138-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200821135418.28138-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng@huawei.com
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com, Zhiqiang Liu <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

... to be passed to update_pathvec_from_dm().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 6 +++---
 libmultipath/structs_vec.h | 2 +-
 multipathd/main.c          | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index cc2dafa..3d4f855 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -406,7 +406,7 @@ extract_hwe_from_path(struct multipath * mpp)
 }
 
 int
-update_multipath_table (struct multipath *mpp, vector pathvec)
+update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 {
 	int r = DMP_ERR;
 	char params[PARAMS_SIZE] = {0};
@@ -426,7 +426,7 @@ update_multipath_table (struct multipath *mpp, vector pathvec)
 	}
 
 	/* FIXME: we should deal with the return value here */
-	update_pathvec_from_dm(pathvec, mpp, 0);
+	update_pathvec_from_dm(pathvec, mpp, flags);
 
 	return DMP_OK;
 }
@@ -532,7 +532,7 @@ update_multipath_strings(struct multipath *mpp, vector pathvec)
 	free_pgvec(mpp->pg, KEEP_PATHS);
 	mpp->pg = NULL;
 
-	r = update_multipath_table(mpp, pathvec);
+	r = update_multipath_table(mpp, pathvec, 0);
 	if (r != DMP_OK)
 		return r;
 	sync_paths(mpp, pathvec);
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 39cb074..478168f 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -39,7 +39,7 @@ struct multipath * add_map_with_path (struct vectors * vecs,
 				struct path * pp, int add_vec);
 void update_queue_mode_del_path(struct multipath *mpp);
 void update_queue_mode_add_path(struct multipath *mpp);
-int update_multipath_table (struct multipath *mpp, vector pathvec);
+int update_multipath_table (struct multipath *mpp, vector pathvec, int flags);
 int update_multipath_status (struct multipath *mpp);
 vector get_used_hwes(const struct _vector *pathvec);
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 9f12a57..b8019ec 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -552,7 +552,7 @@ add_map_without_path (struct vectors *vecs, const char *alias)
 	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
 	put_multipath_config(conf);
 
-	if (update_multipath_table(mpp, vecs->pathvec) != DMP_OK)
+	if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK)
 		goto out;
 	if (update_multipath_status(mpp) != DMP_OK)
 		goto out;
@@ -1412,7 +1412,7 @@ map_discovery (struct vectors * vecs)
 		return 1;
 
 	vector_foreach_slot (vecs->mpvec, mpp, i)
-		if (update_multipath_table(mpp, vecs->pathvec) != DMP_OK ||
+		if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK ||
 		    update_multipath_status(mpp) != DMP_OK) {
 			remove_map(mpp, vecs, 1);
 			i--;
-- 
2.28.0
