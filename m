From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/26] Use 'mptable' as argument for find_mpe()
	and get_mpe_wwid()
Date: Mon, 20 Jun 2016 10:08:49 +0200
Message-ID: <1466410153-23896-3-git-send-email-hare@suse.de>
References: <1466410153-23896-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466410153-23896-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/config.c      | 8 ++++----
 libmultipath/config.h      | 4 ++--
 libmultipath/configure.c   | 2 +-
 libmultipath/propsel.c     | 2 +-
 libmultipath/structs_vec.c | 4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 8b9e770..00f3e53 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -125,7 +125,7 @@ find_hwe (vector hwtable, char * vendor, char * product, char * revision)
 }
 
 extern struct mpentry *
-find_mpe (char * wwid)
+find_mpe (vector mptable, char * wwid)
 {
 	int i;
 	struct mpentry * mpe;
@@ -133,7 +133,7 @@ find_mpe (char * wwid)
 	if (!wwid)
 		return NULL;
 
-	vector_foreach_slot (conf->mptable, mpe, i)
+	vector_foreach_slot (mptable, mpe, i)
 		if (mpe->wwid && !strcmp(mpe->wwid, wwid))
 			return mpe;
 
@@ -141,7 +141,7 @@ find_mpe (char * wwid)
 }
 
 extern char *
-get_mpe_wwid (char * alias)
+get_mpe_wwid (vector mptable, char * alias)
 {
 	int i;
 	struct mpentry * mpe;
@@ -149,7 +149,7 @@ get_mpe_wwid (char * alias)
 	if (!alias)
 		return NULL;
 
-	vector_foreach_slot (conf->mptable, mpe, i)
+	vector_foreach_slot (mptable, mpe, i)
 		if (mpe->alias && strcmp(mpe->alias, alias) == 0)
 			return mpe->wwid;
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 466e31e..2acee25 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -179,8 +179,8 @@ struct config {
 struct config * conf;
 
 struct hwentry * find_hwe (vector hwtable, char * vendor, char * product, char *revision);
-struct mpentry * find_mpe (char * wwid);
-char * get_mpe_wwid (char * alias);
+struct mpentry * find_mpe (vector hwtable, char * wwid);
+char * get_mpe_wwid (vector hwtable, char * alias);
 
 struct hwentry * alloc_hwe (void);
 struct mpentry * alloc_mpe (void);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 8e938c0..a830bcd 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1042,7 +1042,7 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 		/*
 		 * or may be an alias
 		 */
-		refwwid = get_mpe_wwid(dev);
+		refwwid = get_mpe_wwid(conf->hwtable, dev);
 
 		/*
 		 * or directly a wwid
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 4111fa5..f803cdc 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -409,7 +409,7 @@ select_prio (struct path * pp)
 			goto out;
 		}
 	}
-	mpe = find_mpe(pp->wwid);
+	mpe = find_mpe(conf->hwtable, pp->wwid);
 	set_prio(mpe, "(LUN setting)");
 	set_prio(conf->overrides, "(overrides setting)");
 	set_prio(pp->hwe, "controller setting)");
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 20a7457..b00832e 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -385,7 +385,7 @@ __setup_multipath (struct vectors * vecs, struct multipath * mpp, int reset)
 	}
 
 	set_multipath_wwid(mpp);
-	mpp->mpe = find_mpe(mpp->wwid);
+	mpp->mpe = find_mpe(conf->hwtable, mpp->wwid);
 	condlog(3, "%s: discover", mpp->alias);
 
 	if (!mpp->hwe)
@@ -469,7 +469,7 @@ add_map_with_path (struct vectors * vecs,
 	if (!(mpp = alloc_multipath()))
 		return NULL;
 
-	mpp->mpe = find_mpe(pp->wwid);
+	mpp->mpe = find_mpe(conf->hwtable, pp->wwid);
 	mpp->hwe = pp->hwe;
 
 	strcpy(mpp->wwid, pp->wwid);
-- 
2.6.6
