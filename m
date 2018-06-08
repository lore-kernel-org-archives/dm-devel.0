From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 04/28] libmultipath/structs.c: constify some
	functions
Date: Fri,  8 Jun 2018 12:20:17 +0200
Message-ID: <20180608102041.22904-5-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c | 20 ++++++++++----------
 libmultipath/structs.h | 24 ++++++++++++------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 991095cb..6df2f4ec 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -353,7 +353,7 @@ store_adaptergroup(vector adapters, struct adapter_group * agp)
 }
 
 struct multipath *
-find_mp_by_minor (vector mpvec, int minor)
+find_mp_by_minor (const struct _vector *mpvec, int minor)
 {
 	int i;
 	struct multipath * mpp;
@@ -372,7 +372,7 @@ find_mp_by_minor (vector mpvec, int minor)
 }
 
 struct multipath *
-find_mp_by_wwid (vector mpvec, char * wwid)
+find_mp_by_wwid (const struct _vector *mpvec, const char * wwid)
 {
 	int i;
 	struct multipath * mpp;
@@ -388,7 +388,7 @@ find_mp_by_wwid (vector mpvec, char * wwid)
 }
 
 struct multipath *
-find_mp_by_alias (vector mpvec, const char * alias)
+find_mp_by_alias (const struct _vector *mpvec, const char * alias)
 {
 	int i;
 	int len;
@@ -411,7 +411,7 @@ find_mp_by_alias (vector mpvec, const char * alias)
 }
 
 struct multipath *
-find_mp_by_str (vector mpvec, char * str)
+find_mp_by_str (const struct _vector *mpvec, const char * str)
 {
 	int minor;
 
@@ -422,7 +422,7 @@ find_mp_by_str (vector mpvec, char * str)
 }
 
 struct path *
-find_path_by_dev (vector pathvec, const char * dev)
+find_path_by_dev (const struct _vector *pathvec, const char * dev)
 {
 	int i;
 	struct path * pp;
@@ -439,7 +439,7 @@ find_path_by_dev (vector pathvec, const char * dev)
 }
 
 struct path *
-find_path_by_devt (vector pathvec, const char * dev_t)
+find_path_by_devt (const struct _vector *pathvec, const char * dev_t)
 {
 	int i;
 	struct path * pp;
@@ -455,7 +455,7 @@ find_path_by_devt (vector pathvec, const char * dev_t)
 	return NULL;
 }
 
-int pathcountgr(struct pathgroup *pgp, int state)
+int pathcountgr(const struct pathgroup *pgp, int state)
 {
 	struct path *pp;
 	int count = 0;
@@ -468,7 +468,7 @@ int pathcountgr(struct pathgroup *pgp, int state)
 	return count;
 }
 
-int pathcount(struct multipath *mpp, int state)
+int pathcount(const struct multipath *mpp, int state)
 {
 	struct pathgroup *pgp;
 	int count = 0;
@@ -481,7 +481,7 @@ int pathcount(struct multipath *mpp, int state)
 	return count;
 }
 
-int pathcmp(struct pathgroup *pgp, struct pathgroup *cpgp)
+int pathcmp(const struct pathgroup *pgp, const struct pathgroup *cpgp)
 {
 	int i, j;
 	struct path *pp, *cpp;
@@ -501,7 +501,7 @@ int pathcmp(struct pathgroup *pgp, struct pathgroup *cpgp)
 }
 
 struct path *
-first_path (struct multipath * mpp)
+first_path (const struct multipath * mpp)
 {
 	struct pathgroup * pgp;
 	if (!mpp->pg)
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index e424b150..fef416b4 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -413,18 +413,18 @@ int store_path (vector pathvec, struct path * pp);
 int store_pathgroup (vector pgvec, struct pathgroup * pgp);
 int add_pathgroup(struct multipath*, struct pathgroup *);
 
-struct multipath * find_mp_by_alias (vector mp, const char * alias);
-struct multipath * find_mp_by_wwid (vector mp, char * wwid);
-struct multipath * find_mp_by_str (vector mp, char * wwid);
-struct multipath * find_mp_by_minor (vector mp, int minor);
-
-struct path * find_path_by_devt (vector pathvec, const char * devt);
-struct path * find_path_by_dev (vector pathvec, const char * dev);
-struct path * first_path (struct multipath * mpp);
-
-int pathcountgr (struct pathgroup *, int);
-int pathcount (struct multipath *, int);
-int pathcmp (struct pathgroup *, struct pathgroup *);
+struct multipath * find_mp_by_alias (const struct _vector *mp, const char *alias);
+struct multipath * find_mp_by_wwid (const struct _vector *mp, const char *wwid);
+struct multipath * find_mp_by_str (const struct _vector *mp, const char *wwid);
+struct multipath * find_mp_by_minor (const struct _vector *mp, int minor);
+
+struct path * find_path_by_devt (const struct _vector *pathvec, const char *devt);
+struct path * find_path_by_dev (const struct _vector *pathvec, const char *dev);
+struct path * first_path (const struct multipath *mpp);
+
+int pathcountgr (const struct pathgroup *, int);
+int pathcount (const struct multipath *, int);
+int pathcmp (const struct pathgroup *, const struct pathgroup *);
 int add_feature (char **, const char *);
 int remove_feature (char **, const char *);
 
-- 
2.17.0
