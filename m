From: mwilck@suse.com
Subject: [PATCH 59/74] libmultipath: sync_paths(): handle
	INIT_REMOVED
Date: Thu,  9 Jul 2020 12:51:30 +0200
Message-ID: <20200709105145.9211-7-mwilck@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

sync_paths() is the function which is called after getting kernel
state with disassemble_map(). This is the place where we should
check if paths that can eventually be deleted.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 5634101..faa1a2a 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -264,6 +264,38 @@ update_multipath_status (struct multipath *mpp)
 	return DMP_OK;
 }
 
+static struct path *find_devt_in_pathgroups(const struct multipath *mpp,
+					    const char *dev_t)
+{
+	struct pathgroup  *pgp;
+	struct path *pp;
+	int j;
+
+	vector_foreach_slot(mpp->pg, pgp, j) {
+		pp = find_path_by_devt(pgp->paths, dev_t);
+		if (pp)
+			return pp;
+	}
+	return NULL;
+}
+
+static void check_removed_paths(const struct multipath *mpp, vector pathvec)
+{
+	struct path *pp;
+	int i;
+
+	vector_foreach_slot(pathvec, pp, i) {
+		if (pp->initialized != INIT_REMOVED || pp->mpp != mpp)
+			continue;
+		if (!find_devt_in_pathgroups(mpp, pp->dev_t)) {
+			condlog(2, "%s: %s: freeing path in removed state",
+				__func__, pp->dev);
+			vector_del_slot(pathvec, i--);
+			free_path(pp);
+		}
+	}
+}
+
 void sync_paths(struct multipath *mpp, vector pathvec)
 {
 	struct path *pp;
@@ -284,6 +316,7 @@ void sync_paths(struct multipath *mpp, vector pathvec)
 			orphan_path(pp, "path removed externally");
 		}
 	}
+	check_removed_paths(mpp, pathvec);
 	update_mpp_paths(mpp, pathvec);
 	vector_foreach_slot (mpp->paths, pp, i)
 		pp->mpp = mpp;
-- 
2.26.2
