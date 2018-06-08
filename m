From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 22/28] libmultipath: allow printing local maps in
	snprint_config
Date: Fri,  8 Jun 2018 12:20:35 +0200
Message-ID: <20180608102041.22904-23-mwilck@suse.com>
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

"mulitpatd show config" only dumps multipath sections for maps which are
present in local configuration files. This patch adds the ability to dump
"multipath" subsections for every locally detected map, even for those
that have no local configuration, and at the same time, skip dumping
multipath configurations for maps that aree not present locally.

This makes it possible for users to generate a multipath.conf template
matching local devices, and e.g. add explicit alias entries for existing
maps. If user_friendly_names is in use, a commented-out config line is added
to the dump output showing the implicitly configured alias, simplifying
identification of the devices.

This facility is optional and will only be used in new commands added
in follow-up patches.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c      | 60 ++++++++++++++++++++++++++++++++++-----
 libmultipath/print.h      |  3 +-
 multipath/main.c          |  2 +-
 multipathd/cli_handlers.c |  2 +-
 tests/hwtable.c           |  6 ++--
 5 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index af4c00e2..222d2701 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1404,12 +1404,16 @@ static int snprint_hwtable(const struct config *conf,
 
 static int
 snprint_mpentry (const struct config *conf, char * buff, int len,
-		 const struct mpentry * mpe)
+		 const struct mpentry * mpe, const struct _vector *mpvec)
 {
 	int i;
 	int fwd = 0;
 	struct keyword * kw;
 	struct keyword * rootkw;
+	struct multipath *mpp = NULL;
+
+	if (mpvec != NULL && (mpp = find_mp_by_wwid(mpvec, mpe->wwid)) == NULL)
+		return 0;
 
 	rootkw = find_keyword(conf->keywords, NULL, "multipath");
 	if (!rootkw)
@@ -1424,6 +1428,15 @@ snprint_mpentry (const struct config *conf, char * buff, int len,
 		if (fwd >= len)
 			return len;
 	}
+	/*
+	 * This mpp doesn't have alias defined. Add the alias in a comment.
+	 */
+	if (mpp != NULL && strcmp(mpp->alias, mpp->wwid)) {
+		fwd += snprintf(buff + fwd, len - fwd, "\t\t# alias \"%s\"\n",
+				mpp->alias);
+		if (fwd >= len)
+			return len;
+	}
 	fwd += snprintf(buff + fwd, len - fwd, "\t}\n");
 	if (fwd >= len)
 		return len;
@@ -1431,7 +1444,7 @@ snprint_mpentry (const struct config *conf, char * buff, int len,
 }
 
 static int snprint_mptable(const struct config *conf,
-			   char *buff, int len, vector mptable)
+			   char *buff, int len, const struct _vector *mpvec)
 {
 	int fwd = 0;
 	int i;
@@ -1445,11 +1458,43 @@ static int snprint_mptable(const struct config *conf,
 	fwd += snprintf(buff + fwd, len - fwd, "multipaths {\n");
 	if (fwd >= len)
 		return len;
-	vector_foreach_slot (mptable, mpe, i) {
-		fwd += snprint_mpentry(conf, buff + fwd, len - fwd, mpe);
+	vector_foreach_slot (conf->mptable, mpe, i) {
+		fwd += snprint_mpentry(conf, buff + fwd, len - fwd, mpe, mpvec);
 		if (fwd >= len)
 			return len;
 	}
+	if (mpvec != NULL) {
+		struct multipath *mpp;
+
+		vector_foreach_slot(mpvec, mpp, i) {
+			if (find_mpe(conf->mptable, mpp->wwid) != NULL)
+				continue;
+
+			fwd += snprintf(buff + fwd, len - fwd,
+					"\tmultipath {\n");
+			if (fwd >= len)
+				return len;
+			fwd += snprintf(buff + fwd, len - fwd,
+					"\t\twwid \"%s\"\n", mpp->wwid);
+			if (fwd >= len)
+				return len;
+			/*
+			 * This mpp doesn't have alias defined in
+			 * multipath.conf - otherwise find_mpe would have
+			 * found it. Add the alias in a comment.
+			 */
+			if (strcmp(mpp->alias, mpp->wwid)) {
+				fwd += snprintf(buff + fwd, len - fwd,
+						"\t\t# alias \"%s\"\n",
+						mpp->alias);
+				if (fwd >= len)
+					return len;
+			}
+			fwd += snprintf(buff + fwd, len - fwd, "\t}\n");
+			if (fwd >= len)
+				return len;
+		}
+	}
 	fwd += snprintf(buff + fwd, len - fwd, "}\n");
 	if (fwd >= len)
 		return len;
@@ -1783,7 +1828,7 @@ static int snprint_blacklist_except(const struct config *conf,
 }
 
 char *snprint_config(const struct config *conf, int *len,
-		     const struct _vector *hwtable)
+		     const struct _vector *hwtable, const struct _vector *mpvec)
 {
 	char *reply;
 	/* built-in config is >20kB already */
@@ -1821,9 +1866,10 @@ char *snprint_config(const struct config *conf, int *len,
 		if ((c - reply) == maxlen)
 			continue;
 
-		if (VECTOR_SIZE(conf->mptable) > 0)
+		if (VECTOR_SIZE(conf->mptable) > 0 ||
+		    (mpvec != NULL && VECTOR_SIZE(mpvec) > 0))
 			c += snprint_mptable(conf, c, reply + maxlen - c,
-					     conf->mptable);
+					     mpvec);
 
 		if ((c - reply) < maxlen) {
 			if (len)
diff --git a/libmultipath/print.h b/libmultipath/print.h
index c63e0547..608b7d5f 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -120,7 +120,8 @@ int _snprint_multipath_topology (const struct gen_multipath *, char *, int,
 int snprint_multipath_topology_json (char * buff, int len,
 				const struct vectors * vecs);
 char *snprint_config(const struct config *conf, int *len,
-		     const struct _vector *hwtable);
+		     const struct _vector *hwtable,
+		     const struct _vector *mpvec);
 int snprint_multipath_map_json (char * buff, int len,
 				const struct multipath * mpp, int last);
 int snprint_blacklist_report (struct config *, char *, int);
diff --git a/multipath/main.c b/multipath/main.c
index 87d80dd3..54a98026 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -753,7 +753,7 @@ out:
 static int
 dump_config (struct config *conf)
 {
-	char * reply = snprint_config(conf, NULL, NULL);
+	char * reply = snprint_config(conf, NULL, NULL, NULL);
 
 	if (reply != NULL) {
 		printf("%s", reply);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 75cc8a9e..0ac00155 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -253,7 +253,7 @@ show_config (char ** r, int * len, const struct _vector *hwtable)
 
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
-	reply = snprint_config(conf, len, hwtable);
+	reply = snprint_config(conf, len, hwtable, NULL);
 	pthread_cleanup_pop(1);
 	if (reply == NULL)
 		return 1;
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 08ed67d3..1a6b3188 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -458,11 +458,11 @@ static void replicate_config(const struct hwt_state *hwt, bool local)
 	conf = get_multipath_config();
 	if (!local)
 		/* "full" configuration */
-		cfg1 = snprint_config(conf, NULL, NULL);
+		cfg1 = snprint_config(conf, NULL, NULL, NULL);
 	else {
 		/* "local" configuration */
 		hwtable = get_used_hwes(hwt->vecs->pathvec);
-		cfg1 = snprint_config(conf, NULL, hwtable);
+		cfg1 = snprint_config(conf, NULL, hwtable, hwt->vecs->mpvec);
 	}
 
 	assert_non_null(cfg1);
@@ -483,7 +483,7 @@ static void replicate_config(const struct hwt_state *hwt, bool local)
 	}
 
 	conf = get_multipath_config();
-	cfg2 = snprint_config(conf, NULL, NULL);
+	cfg2 = snprint_config(conf, NULL, NULL, NULL);
 	assert_non_null(cfg2);
 	put_multipath_config(conf);
 
-- 
2.17.0
