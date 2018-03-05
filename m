From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/23] libmultipath: get rid of selector
	"hack" in print.c
Date: Tue,  6 Mar 2018 00:14:47 +0100
Message-ID: <20180305231507.10386-4-mwilck@suse.com>
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

By properly linking the path groups with their parent multipath,
we don't need this "hack" any more.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dmparser.c   |  2 +-
 libmultipath/pgpolicies.c | 11 ++++++-----
 libmultipath/print.c      |  6 +++---
 libmultipath/structs.c    | 10 ++++++++++
 libmultipath/structs.h    |  3 ++-
 5 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 027ae989781e..783c934f1154 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -267,7 +267,7 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 		if (!pgp)
 			goto out;
 
-		if (store_pathgroup(mpp->pg, pgp))
+		if (add_pathgroup(mpp, pgp))
 			goto out;
 
 		p += get_word(p, &word);
diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index 4ae4afbccdb7..ac2596ada442 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -120,7 +120,7 @@ int group_by_node_name(struct multipath * mp)
 		if (!pgp)
 			goto out1;
 
-		if (store_pathgroup(mp->pg, pgp))
+		if (add_pathgroup(mp, pgp))
 			goto out2;
 
 		/* feed the first path */
@@ -196,7 +196,7 @@ int group_by_serial(struct multipath * mp)
 		if (!pgp)
 			goto out1;
 
-		if (store_pathgroup(mp->pg, pgp))
+		if (add_pathgroup(mp, pgp))
 			goto out2;
 
 		/* feed the first path */
@@ -254,7 +254,7 @@ int one_path_per_group(struct multipath *mp)
 		if (!pgp)
 			goto out;
 
-		if (store_pathgroup(mp->pg, pgp))
+		if (add_pathgroup(mp, pgp))
 			goto out1;
 
 		if (store_path(pgp->paths, pp))
@@ -293,7 +293,7 @@ int one_group(struct multipath *mp)	/* aka multibus */
 
 		vector_free(pgp->paths);
 
-		if (store_pathgroup(mp->pg, pgp))
+		if (add_pathgroup(mp, pgp))
 			goto out1;
 
 		pgp->paths = mp->paths;
@@ -367,8 +367,9 @@ int group_by_prio(struct multipath *mp)
 		if (i < VECTOR_SIZE(mp->pg)) {
 			if (!vector_insert_slot(mp->pg, i, pgp))
 				goto out2;
+			pgp->mpp = mp;
 		} else {
-			if (store_pathgroup(mp->pg, pgp))
+			if (add_pathgroup(mp, pgp))
 				goto out2;
 		}
 
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 27636c35e5ff..8fb5c5058965 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -476,7 +476,9 @@ snprint_pri (char * buff, size_t len, struct path * pp)
 static int
 snprint_pg_selector (char * buff, size_t len, struct pathgroup * pgp)
 {
-	return snprint_str(buff, len, pgp->selector);
+	const char *s = pgp->mpp->selector;
+
+	return snprint_str(buff, len, s ? s : "");
 }
 
 static int
@@ -1030,7 +1032,6 @@ int snprint_multipath_topology(char *buff, int len, struct multipath *mpp,
 
 	vector_foreach_slot (mpp->pg, pgp, j) {
 		f=fmt;
-		pgp->selector = mpp->selector; /* hack */
 		if (j + 1 < VECTOR_SIZE(mpp->pg)) {
 			strcpy(f, "|-+- " PRINT_PG_INDENT);
 		} else
@@ -1122,7 +1123,6 @@ snprint_multipath_fields_json (char * buff, int len,
 
 	vector_foreach_slot (mpp->pg, pgp, i) {
 
-		pgp->selector = mpp->selector;
 		fwd += snprint_pathgroup(buff + fwd, len - fwd, PRINT_JSON_GROUP, pgp);
 		if (fwd >= len)
 			return fwd;
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 4caad2a40302..1ade1a6705ad 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -318,6 +318,16 @@ store_pathgroup (vector pgvec, struct pathgroup * pgp)
 	return 0;
 }
 
+int add_pathgroup(struct multipath *mpp, struct pathgroup *pgp)
+{
+	int ret = store_pathgroup(mpp->pg, pgp);
+
+	if (ret)
+		return ret;
+	pgp->mpp = mpp;
+	return 0;
+}
+
 int
 store_hostgroup(vector hostgroupvec, struct host_group * hgp)
 {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index b951c7b0e157..71b37cc20674 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -340,7 +340,7 @@ struct pathgroup {
 	int priority;
 	int enabled_paths;
 	vector paths;
-	char * selector;
+	struct multipath *mpp;
 };
 
 struct adapter_group {
@@ -379,6 +379,7 @@ int store_hostgroup(vector hostgroupvec, struct host_group *hgp);
 
 int store_path (vector pathvec, struct path * pp);
 int store_pathgroup (vector pgvec, struct pathgroup * pgp);
+int add_pathgroup(struct multipath*, struct pathgroup *);
 
 struct multipath * find_mp_by_alias (vector mp, const char * alias);
 struct multipath * find_mp_by_wwid (vector mp, char * wwid);
-- 
2.16.1
