From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 18/28] multipath,
	multipathd: consolidate config dumping
Date: Fri,  8 Jun 2018 12:20:31 +0200
Message-ID: <20180608102041.22904-19-mwilck@suse.com>
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

"multipath -t" and "multipathd show config" use very similar code.
Consolidate it into a libmultipath function. Simplify it a bit in
the process, and do some "const" and "static" cleanup.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c      | 76 ++++++++++++++++++++++++++++++++++-----
 libmultipath/print.h      |  7 +---
 multipath/main.c          | 63 ++++----------------------------
 multipathd/cli_handlers.c | 52 ++-------------------------
 4 files changed, 78 insertions(+), 120 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index b1844c98..7d4e2ace 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1342,7 +1342,8 @@ snprint_multipath_topology_json (char * buff, int len, const struct vectors * ve
 }
 
 static int
-snprint_hwentry (struct config *conf, char * buff, int len, const struct hwentry * hwe)
+snprint_hwentry (const struct config *conf,
+		 char * buff, int len, const struct hwentry * hwe)
 {
 	int i;
 	int fwd = 0;
@@ -1374,7 +1375,8 @@ snprint_hwentry (struct config *conf, char * buff, int len, const struct hwentry
 	return fwd;
 }
 
-int snprint_hwtable(struct config *conf, char *buff, int len, vector hwtable)
+static int snprint_hwtable(const struct config *conf,
+			   char *buff, int len, vector hwtable)
 {
 	int fwd = 0;
 	int i;
@@ -1400,7 +1402,8 @@ int snprint_hwtable(struct config *conf, char *buff, int len, vector hwtable)
 }
 
 static int
-snprint_mpentry (struct config *conf, char * buff, int len, const struct mpentry * mpe)
+snprint_mpentry (const struct config *conf, char * buff, int len,
+		 const struct mpentry * mpe)
 {
 	int i;
 	int fwd = 0;
@@ -1426,7 +1429,8 @@ snprint_mpentry (struct config *conf, char * buff, int len, const struct mpentry
 	return fwd;
 }
 
-int snprint_mptable(struct config *conf, char *buff, int len, vector mptable)
+static int snprint_mptable(const struct config *conf,
+			   char *buff, int len, vector mptable)
 {
 	int fwd = 0;
 	int i;
@@ -1451,8 +1455,8 @@ int snprint_mptable(struct config *conf, char *buff, int len, vector mptable)
 	return fwd;
 }
 
-int snprint_overrides(struct config *conf, char * buff, int len,
-		      const struct hwentry *overrides)
+static int snprint_overrides(const struct config *conf, char * buff, int len,
+			     const struct hwentry *overrides)
 {
 	int fwd = 0;
 	int i;
@@ -1481,7 +1485,7 @@ out:
 	return fwd;
 }
 
-int snprint_defaults(struct config *conf, char *buff, int len)
+static int snprint_defaults(const struct config *conf, char *buff, int len)
 {
 	int fwd = 0;
 	int i;
@@ -1624,7 +1628,7 @@ int snprint_blacklist_report(struct config *conf, char *buff, int len)
 	return fwd;
 }
 
-int snprint_blacklist(struct config *conf, char *buff, int len)
+static int snprint_blacklist(const struct config *conf, char *buff, int len)
 {
 	int i;
 	struct blentry * ble;
@@ -1700,7 +1704,8 @@ int snprint_blacklist(struct config *conf, char *buff, int len)
 	return fwd;
 }
 
-int snprint_blacklist_except(struct config *conf, char *buff, int len)
+static int snprint_blacklist_except(const struct config *conf,
+				    char *buff, int len)
 {
 	int i;
 	struct blentry * ele;
@@ -1776,6 +1781,59 @@ int snprint_blacklist_except(struct config *conf, char *buff, int len)
 	return fwd;
 }
 
+char *snprint_config(const struct config *conf, int *len)
+{
+	char *reply;
+	/* built-in config is >20kB already */
+	unsigned int maxlen = 32768;
+
+	for (reply = NULL; maxlen <= UINT_MAX/2; maxlen *= 2) {
+		char *c, *tmp = reply;
+
+		reply = REALLOC(reply, maxlen);
+		if (!reply) {
+			if (tmp)
+				free(tmp);
+			return NULL;
+		}
+
+		c = reply + snprint_defaults(conf, reply, maxlen);
+		if ((c - reply) == maxlen)
+			continue;
+
+		c += snprint_blacklist(conf, c, reply + maxlen - c);
+		if ((c - reply) == maxlen)
+			continue;
+
+		c += snprint_blacklist_except(conf, c, reply + maxlen - c);
+		if ((c - reply) == maxlen)
+			continue;
+
+		c += snprint_hwtable(conf, c, reply + maxlen - c,
+				     conf->hwtable);
+		if ((c - reply) == maxlen)
+			continue;
+
+		c += snprint_overrides(conf, c, reply + maxlen - c,
+				       conf->overrides);
+		if ((c - reply) == maxlen)
+			continue;
+
+		if (VECTOR_SIZE(conf->mptable) > 0)
+			c += snprint_mptable(conf, c, reply + maxlen - c,
+					     conf->mptable);
+
+		if ((c - reply) < maxlen) {
+			if (len)
+				*len = c - reply;
+			return reply;
+		}
+	}
+
+	free(reply);
+	return NULL;
+}
+
 int snprint_status(char *buff, int len, const struct vectors *vecs)
 {
 	int fwd = 0;
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 9b5a23aa..fed80d55 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -119,18 +119,13 @@ int _snprint_multipath_topology (const struct gen_multipath *, char *, int,
 	_snprint_multipath_topology (dm_multipath_to_gen(mpp), buf, len, v)
 int snprint_multipath_topology_json (char * buff, int len,
 				const struct vectors * vecs);
+char *snprint_config(const struct config *conf, int *len);
 int snprint_multipath_map_json (char * buff, int len,
 				const struct multipath * mpp, int last);
-int snprint_defaults (struct config *, char *, int);
-int snprint_blacklist (struct config *, char *, int);
-int snprint_blacklist_except (struct config *, char *, int);
 int snprint_blacklist_report (struct config *, char *, int);
 int snprint_wildcards (char *, int);
 int snprint_status (char *, int, const struct vectors *);
 int snprint_devices (struct config *, char *, int, const struct vectors *);
-int snprint_hwtable (struct config *, char *, int, const vector);
-int snprint_mptable (struct config *, char *, int, const vector);
-int snprint_overrides (struct config *, char *, int, const struct hwentry *);
 int snprint_path_serial (char *, size_t, const struct path *);
 int snprint_host_wwnn (char *, size_t, const struct path *);
 int snprint_host_wwpn (char *, size_t, const struct path *);
diff --git a/multipath/main.c b/multipath/main.c
index 3f0a6aa7..288251c3 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -753,63 +753,14 @@ out:
 static int
 dump_config (struct config *conf)
 {
-	char * c, * tmp = NULL;
-	char * reply;
-	unsigned int maxlen = 256;
-	int again = 1;
-
-	reply = MALLOC(maxlen);
-
-	while (again) {
-		if (!reply) {
-			if (tmp)
-				free(tmp);
-			return 1;
-		}
-		c = tmp = reply;
-		c += snprint_defaults(conf, c, reply + maxlen - c);
-		again = ((c - reply) == maxlen);
-		if (again) {
-			reply = REALLOC(reply, maxlen *= 2);
-			continue;
-		}
-		c += snprint_blacklist(conf, c, reply + maxlen - c);
-		again = ((c - reply) == maxlen);
-		if (again) {
-			reply = REALLOC(reply, maxlen *= 2);
-			continue;
-		}
-		c += snprint_blacklist_except(conf, c, reply + maxlen - c);
-		again = ((c - reply) == maxlen);
-		if (again) {
-			reply = REALLOC(reply, maxlen *= 2);
-			continue;
-		}
-		c += snprint_hwtable(conf, c, reply + maxlen - c, conf->hwtable);
-		again = ((c - reply) == maxlen);
-		if (again) {
-			reply = REALLOC(reply, maxlen *= 2);
-			continue;
-		}
-		c += snprint_overrides(conf, c, reply + maxlen - c,
-				       conf->overrides);
-		again = ((c - reply) == maxlen);
-		if (again) {
-			reply = REALLOC(reply, maxlen *= 2);
-			continue;
-		}
-		if (VECTOR_SIZE(conf->mptable) > 0) {
-			c += snprint_mptable(conf, c, reply + maxlen - c,
-					     conf->mptable);
-			again = ((c - reply) == maxlen);
-			if (again)
-				reply = REALLOC(reply, maxlen *= 2);
-		}
-	}
+	char * reply = snprint_config(conf, NULL);
 
-	printf("%s", reply);
-	FREE(reply);
-	return 0;
+	if (reply != NULL) {
+		printf("%s", reply);
+		FREE(reply);
+		return 0;
+	} else
+		return 1;
 }
 
 static int
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index ba50fb8f..6f043d7f 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -248,62 +248,16 @@ show_map_json (char ** r, int * len, struct multipath * mpp,
 int
 show_config (char ** r, int * len)
 {
-	char * c;
-	char * reply;
-	unsigned int maxlen = INITIAL_REPLY_LEN;
-	int again = 1;
 	struct config *conf;
-	int fail = 0;
-
-	c = reply = MALLOC(maxlen);
+	char *reply;
 
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
-	while (again) {
-		if (!reply) {
-			fail = 1;
-			break;
-		}
-		c = reply;
-		c += snprint_defaults(conf, c, reply + maxlen - c);
-		again = ((c - reply) == maxlen);
-		REALLOC_REPLY(reply, again, maxlen);
-		if (again)
-			continue;
-		c += snprint_blacklist(conf, c, reply + maxlen - c);
-		again = ((c - reply) == maxlen);
-		REALLOC_REPLY(reply, again, maxlen);
-		if (again)
-			continue;
-		c += snprint_blacklist_except(conf, c, reply + maxlen - c);
-		again = ((c - reply) == maxlen);
-		REALLOC_REPLY(reply, again, maxlen);
-		if (again)
-			continue;
-		c += snprint_hwtable(conf, c, reply + maxlen - c,
-				     conf->hwtable);
-		again = ((c - reply) == maxlen);
-		REALLOC_REPLY(reply, again, maxlen);
-		if (again)
-			continue;
-		c += snprint_overrides(conf, c, reply + maxlen - c,
-				       conf->overrides);
-		again = ((c - reply) == maxlen);
-		REALLOC_REPLY(reply, again, maxlen);
-		if (again)
-			continue;
-		if (VECTOR_SIZE(conf->mptable) > 0) {
-			c += snprint_mptable(conf, c, reply + maxlen - c,
-					     conf->mptable);
-			again = ((c - reply) == maxlen);
-			REALLOC_REPLY(reply, again, maxlen);
-		}
-	}
+	reply = snprint_config(conf, len);
 	pthread_cleanup_pop(1);
-	if (fail)
+	if (reply == NULL)
 		return 1;
 	*r = reply;
-	*len = (int)(c - reply + 1);
 	return 0;
 }
 
-- 
2.17.0
