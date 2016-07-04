From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 26/26] libmultipath: Allocate keywords directly
Date: Mon,  4 Jul 2016 09:08:46 +0200
Message-ID: <1467616126-10036-27-git-send-email-hare@suse.de>
References: <1467616126-10036-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467616126-10036-1-git-send-email-hare@suse.de>
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

There is no valid reason why we cannot allocate the keywords
structure within the configuration data directly.
So drop this weird pointer dance and use it directly.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/config.c     |  5 ++---
 libmultipath/dict.c       |  2 +-
 libmultipath/dict.h       |  2 +-
 libmultipath/parser.c     | 39 +++++----------------------------
 libmultipath/parser.h     | 13 +++++------
 libmultipath/print.c      | 56 +++++++++++++++++++++++------------------------
 libmultipath/print.h      |  6 ++---
 multipath/main.c          |  7 +++---
 multipathd/cli_handlers.c |  8 ++++---
 9 files changed, 56 insertions(+), 82 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 216ca22..9a75b4e 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -632,9 +632,8 @@ load_config (char * file)
 	/*
 	 * read the config file
 	 */
-	set_current_keywords(&conf->keywords);
-	alloc_keywords();
-	init_keywords();
+	conf->keywords = vector_alloc();
+	init_keywords(conf->keywords);
 	if (filepresent(file)) {
 		int builtin_hwtable_size;
 
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index ed0502a..7b92a91 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1330,7 +1330,7 @@ snprint_deprecated (struct config *conf, char * buff, int len, void * data)
 #define __deprecated
 
 void
-init_keywords(void)
+init_keywords(vector keywords)
 {
 	install_keyword_root("defaults", NULL);
 	install_keyword("verbosity", &def_verbosity_handler, &snprint_def_verbosity);
diff --git a/libmultipath/dict.h b/libmultipath/dict.h
index 4fdd576..4cd03c5 100644
--- a/libmultipath/dict.h
+++ b/libmultipath/dict.h
@@ -5,7 +5,7 @@
 #include "vector.h"
 #endif
 
-void init_keywords(void);
+void init_keywords(vector keywords);
 int get_sys_max_fds(int *);
 int print_rr_weight (char * buff, int len, void *ptr);
 int print_pgfailback (char * buff, int len, void *ptr);
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 82ce01c..dd955f3 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -28,16 +28,8 @@
 
 /* local vars */
 static int sublevel = 0;
-static vector keywords = NULL;
-static vector *keywords_addr = NULL;
 static int line_nr;
 
-void set_current_keywords (vector *k)
-{
-	keywords_addr = k;
-	keywords = NULL;
-}
-
 int
 keyword_alloc(vector keywords, char *string,
 	      int (*handler) (struct config *, vector),
@@ -64,15 +56,6 @@ keyword_alloc(vector keywords, char *string,
 	return 0;
 }
 
-int
-install_keyword_root(char *string, int (*handler) (struct config *, vector))
-{
-	int r = keyword_alloc(keywords, string, handler, NULL, 1);
-	if (!r)
-		*keywords_addr = keywords;
-	return r;
-}
-
 void
 install_sublevel(void)
 {
@@ -86,7 +69,8 @@ install_sublevel_end(void)
 }
 
 int
-_install_keyword(char *string, int (*handler) (struct config *, vector),
+_install_keyword(vector keywords, char *string,
+		 int (*handler) (struct config *, vector),
 		 int (*print) (struct config *, char *, int, void *), int unique)
 {
 	int i = 0;
@@ -130,7 +114,7 @@ free_keywords(vector keywords)
 }
 
 struct keyword *
-find_keyword(vector v, char * name)
+find_keyword(vector keywords, vector v, char * name)
 {
 	struct keyword *keyword;
 	int i;
@@ -150,7 +134,7 @@ find_keyword(vector v, char * name)
 		    !strcmp(keyword->string, name))
 			return keyword;
 		if (keyword->sub) {
-			keyword = find_keyword(keyword->sub, name);
+			keyword = find_keyword(keywords, keyword->sub, name);
 			if (keyword)
 				return keyword;
 		}
@@ -555,17 +539,6 @@ out:
 	return r;
 }
 
-int alloc_keywords(void)
-{
-	if (!keywords)
-		keywords = vector_alloc();
-
-	if (!keywords)
-		return 1;
-
-	return 0;
-}
-
 /* Data initialization */
 int
 process_file(struct config *conf, char *file)
@@ -573,7 +546,7 @@ process_file(struct config *conf, char *file)
 	int r;
 	FILE *stream;
 
-	if (!keywords) {
+	if (!conf->keywords) {
 		condlog(0, "No keywords alocated");
 		return 1;
 	}
@@ -586,7 +559,7 @@ process_file(struct config *conf, char *file)
 
 	/* Stream handling */
 	line_nr = 0;
-	r = process_stream(conf, stream, keywords, file);
+	r = process_stream(conf, stream, conf->keywords, file);
 	fclose(stream);
 	//free_keywords(keywords);
 
diff --git a/libmultipath/parser.h b/libmultipath/parser.h
index 822b2b4..519b805 100644
--- a/libmultipath/parser.h
+++ b/libmultipath/parser.h
@@ -61,21 +61,20 @@ struct keyword {
 extern int keyword_alloc(vector keywords, char *string,
 			 int (*handler) (struct config *, vector),
 			 int (*print) (struct config *, char *, int, void *), int unique);
-extern int install_keyword_root(char *string, int (*handler) (struct config *, vector));
+#define install_keyword_root(str, h) keyword_alloc(keywords, str, h, NULL, 1)
 extern void install_sublevel(void);
 extern void install_sublevel_end(void);
-extern int _install_keyword(char *string, int (*handler) (struct config *, vector),
+extern int _install_keyword(vector keywords, char *string,
+			    int (*handler) (struct config *, vector),
 			    int (*print) (struct config *, char *, int, void *), int unique);
-#define install_keyword(str, vec, pri) _install_keyword(str, vec, pri, 1)
-#define install_keyword_multi(str, vec, pri) _install_keyword(str, vec, pri, 0)
+#define install_keyword(str, vec, pri) _install_keyword(keywords, str, vec, pri, 1)
+#define install_keyword_multi(str, vec, pri) _install_keyword(keywords, str, vec, pri, 0)
 extern void dump_keywords(vector keydump, int level);
 extern void free_keywords(vector keywords);
 extern vector alloc_strvec(char *string);
 extern void *set_value(vector strvec);
-extern int alloc_keywords(void);
 extern int process_file(struct config *conf, char *conf_file);
-extern struct keyword * find_keyword(vector v, char * name);
-void set_current_keywords (vector *k);
+extern struct keyword * find_keyword(vector keywords, vector v, char * name);
 int snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw,
 		    void *data);
 
diff --git a/libmultipath/print.c b/libmultipath/print.c
index fe3902f..196af61 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1212,19 +1212,19 @@ snprint_multipath_topology_json (char * buff, int len, struct vectors * vecs)
 }
 
 static int
-snprint_hwentry (char * buff, int len, struct hwentry * hwe)
+snprint_hwentry (struct config *conf, char * buff, int len, struct hwentry * hwe)
 {
 	int i;
 	int fwd = 0;
 	struct keyword * kw;
 	struct keyword * rootkw;
 
-	rootkw = find_keyword(NULL, "devices");
+	rootkw = find_keyword(conf->keywords, NULL, "devices");
 
 	if (!rootkw || !rootkw->sub)
 		return 0;
 
-	rootkw = find_keyword(rootkw->sub, "device");
+	rootkw = find_keyword(conf->keywords, rootkw->sub, "device");
 
 	if (!rootkw)
 		return 0;
@@ -1245,14 +1245,14 @@ snprint_hwentry (char * buff, int len, struct hwentry * hwe)
 }
 
 extern int
-snprint_hwtable (char * buff, int len, vector hwtable)
+snprint_hwtable (struct config *conf, char * buff, int len, vector hwtable)
 {
 	int fwd = 0;
 	int i;
 	struct hwentry * hwe;
 	struct keyword * rootkw;
 
-	rootkw = find_keyword(NULL, "devices");
+	rootkw = find_keyword(conf->keywords, NULL, "devices");
 	if (!rootkw)
 		return 0;
 
@@ -1260,7 +1260,7 @@ snprint_hwtable (char * buff, int len, vector hwtable)
 	if (fwd > len)
 		return len;
 	vector_foreach_slot (hwtable, hwe, i) {
-		fwd += snprint_hwentry(buff + fwd, len - fwd, hwe);
+		fwd += snprint_hwentry(conf, buff + fwd, len - fwd, hwe);
 		if (fwd > len)
 			return len;
 	}
@@ -1271,14 +1271,14 @@ snprint_hwtable (char * buff, int len, vector hwtable)
 }
 
 static int
-snprint_mpentry (char * buff, int len, struct mpentry * mpe)
+snprint_mpentry (struct config *conf, char * buff, int len, struct mpentry * mpe)
 {
 	int i;
 	int fwd = 0;
 	struct keyword * kw;
 	struct keyword * rootkw;
 
-	rootkw = find_keyword(NULL, "multipath");
+	rootkw = find_keyword(conf->keywords, NULL, "multipath");
 	if (!rootkw)
 		return 0;
 
@@ -1298,14 +1298,14 @@ snprint_mpentry (char * buff, int len, struct mpentry * mpe)
 }
 
 extern int
-snprint_mptable (char * buff, int len, vector mptable)
+snprint_mptable (struct config *conf, char * buff, int len, vector mptable)
 {
 	int fwd = 0;
 	int i;
 	struct mpentry * mpe;
 	struct keyword * rootkw;
 
-	rootkw = find_keyword(NULL, "multipaths");
+	rootkw = find_keyword(conf->keywords, NULL, "multipaths");
 	if (!rootkw)
 		return 0;
 
@@ -1313,7 +1313,7 @@ snprint_mptable (char * buff, int len, vector mptable)
 	if (fwd > len)
 		return len;
 	vector_foreach_slot (mptable, mpe, i) {
-		fwd += snprint_mpentry(buff + fwd, len - fwd, mpe);
+		fwd += snprint_mpentry(conf, buff + fwd, len - fwd, mpe);
 		if (fwd > len)
 			return len;
 	}
@@ -1324,14 +1324,14 @@ snprint_mptable (char * buff, int len, vector mptable)
 }
 
 extern int
-snprint_overrides (char * buff, int len, struct hwentry *overrides)
+snprint_overrides (struct config *conf, char * buff, int len, struct hwentry *overrides)
 {
 	int fwd = 0;
 	int i;
 	struct keyword *rootkw;
 	struct keyword *kw;
 
-	rootkw = find_keyword(NULL, "overrides");
+	rootkw = find_keyword(conf->keywords, NULL, "overrides");
 	if (!rootkw)
 		return 0;
 
@@ -1361,7 +1361,7 @@ snprint_defaults (struct config *conf, char * buff, int len)
 	struct keyword *rootkw;
 	struct keyword *kw;
 
-	rootkw = find_keyword(NULL, "defaults");
+	rootkw = find_keyword(conf->keywords, NULL, "defaults");
 	if (!rootkw)
 		return 0;
 
@@ -1508,7 +1508,7 @@ snprint_blacklist (struct config *conf, char * buff, int len)
 	struct keyword *rootkw;
 	struct keyword *kw;
 
-	rootkw = find_keyword(NULL, "blacklist");
+	rootkw = find_keyword(conf->keywords, NULL, "blacklist");
 	if (!rootkw)
 		return 0;
 
@@ -1517,7 +1517,7 @@ snprint_blacklist (struct config *conf, char * buff, int len)
 		return len;
 
 	vector_foreach_slot (conf->blist_devnode, ble, i) {
-		kw = find_keyword(rootkw->sub, "devnode");
+		kw = find_keyword(conf->keywords, rootkw->sub, "devnode");
 		if (!kw)
 			return 0;
 		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
@@ -1526,7 +1526,7 @@ snprint_blacklist (struct config *conf, char * buff, int len)
 			return len;
 	}
 	vector_foreach_slot (conf->blist_wwid, ble, i) {
-		kw = find_keyword(rootkw->sub, "wwid");
+		kw = find_keyword(conf->keywords, rootkw->sub, "wwid");
 		if (!kw)
 			return 0;
 		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
@@ -1535,7 +1535,7 @@ snprint_blacklist (struct config *conf, char * buff, int len)
 			return len;
 	}
 	vector_foreach_slot (conf->blist_property, ble, i) {
-		kw = find_keyword(rootkw->sub, "property");
+		kw = find_keyword(conf->keywords, rootkw->sub, "property");
 		if (!kw)
 			return 0;
 		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
@@ -1543,7 +1543,7 @@ snprint_blacklist (struct config *conf, char * buff, int len)
 		if (fwd > len)
 			return len;
 	}
-	rootkw = find_keyword(rootkw->sub, "device");
+	rootkw = find_keyword(conf->keywords, rootkw->sub, "device");
 	if (!rootkw)
 		return 0;
 
@@ -1551,14 +1551,14 @@ snprint_blacklist (struct config *conf, char * buff, int len)
 		fwd += snprintf(buff + fwd, len - fwd, "\tdevice {\n");
 		if (fwd > len)
 			return len;
-		kw = find_keyword(rootkw->sub, "vendor");
+		kw = find_keyword(conf->keywords, rootkw->sub, "vendor");
 		if (!kw)
 			return 0;
 		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
 				       kw, bled);
 		if (fwd > len)
 			return len;
-		kw = find_keyword(rootkw->sub, "product");
+		kw = find_keyword(conf->keywords, rootkw->sub, "product");
 		if (!kw)
 			return 0;
 		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
@@ -1585,7 +1585,7 @@ snprint_blacklist_except (struct config *conf, char * buff, int len)
 	struct keyword *rootkw;
 	struct keyword *kw;
 
-	rootkw = find_keyword(NULL, "blacklist_exceptions");
+	rootkw = find_keyword(conf->keywords, NULL, "blacklist_exceptions");
 	if (!rootkw)
 		return 0;
 
@@ -1594,7 +1594,7 @@ snprint_blacklist_except (struct config *conf, char * buff, int len)
 		return len;
 
 	vector_foreach_slot (conf->elist_devnode, ele, i) {
-		kw = find_keyword(rootkw->sub, "devnode");
+		kw = find_keyword(conf->keywords, rootkw->sub, "devnode");
 		if (!kw)
 			return 0;
 		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
@@ -1603,7 +1603,7 @@ snprint_blacklist_except (struct config *conf, char * buff, int len)
 			return len;
 	}
 	vector_foreach_slot (conf->elist_wwid, ele, i) {
-		kw = find_keyword(rootkw->sub, "wwid");
+		kw = find_keyword(conf->keywords, rootkw->sub, "wwid");
 		if (!kw)
 			return 0;
 		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
@@ -1612,7 +1612,7 @@ snprint_blacklist_except (struct config *conf, char * buff, int len)
 			return len;
 	}
 	vector_foreach_slot (conf->elist_property, ele, i) {
-		kw = find_keyword(rootkw->sub, "property");
+		kw = find_keyword(conf->keywords, rootkw->sub, "property");
 		if (!kw)
 			return 0;
 		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
@@ -1620,7 +1620,7 @@ snprint_blacklist_except (struct config *conf, char * buff, int len)
 		if (fwd > len)
 			return len;
 	}
-	rootkw = find_keyword(rootkw->sub, "device");
+	rootkw = find_keyword(conf->keywords, rootkw->sub, "device");
 	if (!rootkw)
 		return 0;
 
@@ -1628,14 +1628,14 @@ snprint_blacklist_except (struct config *conf, char * buff, int len)
 		fwd += snprintf(buff + fwd, len - fwd, "\tdevice {\n");
 		if (fwd > len)
 			return len;
-		kw = find_keyword(rootkw->sub, "vendor");
+		kw = find_keyword(conf->keywords, rootkw->sub, "vendor");
 		if (!kw)
 			return 0;
 		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
 				       kw, eled);
 		if (fwd > len)
 			return len;
-		kw = find_keyword(rootkw->sub, "product");
+		kw = find_keyword(conf->keywords, rootkw->sub, "product");
 		if (!kw)
 			return 0;
 		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 023f520..b532f24 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -109,9 +109,9 @@ int snprint_blacklist_report (struct config *, char *, int);
 int snprint_wildcards (char *, int);
 int snprint_status (char *, int, struct vectors *);
 int snprint_devices (struct config *, char *, int, struct vectors *);
-int snprint_hwtable (char *, int, vector);
-int snprint_mptable (char *, int, vector);
-int snprint_overrides (char *, int, struct hwentry *);
+int snprint_hwtable (struct config *, char *, int, vector);
+int snprint_mptable (struct config *, char *, int, vector);
+int snprint_overrides (struct config *, char *, int, struct hwentry *);
 int snprint_host_wwnn (char *, size_t, struct path *);
 int snprint_host_wwpn (char *, size_t, struct path *);
 int snprint_tgt_wwnn (char *, size_t, struct path *);
diff --git a/multipath/main.c b/multipath/main.c
index 719d935..e7e35c0 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -458,20 +458,21 @@ dump_config (struct config *conf)
 			reply = REALLOC(reply, maxlen *= 2);
 			continue;
 		}
-		c += snprint_hwtable(c, reply + maxlen - c, conf->hwtable);
+		c += snprint_hwtable(conf, c, reply + maxlen - c, conf->hwtable);
 		again = ((c - reply) == maxlen);
 		if (again) {
 			reply = REALLOC(reply, maxlen *= 2);
 			continue;
 		}
-		c += snprint_overrides(c, reply + maxlen - c, conf->overrides);
+		c += snprint_overrides(conf, c, reply + maxlen - c,
+				       conf->overrides);
 		again = ((c - reply) == maxlen);
 		if (again) {
 			reply = REALLOC(reply, maxlen *= 2);
 			continue;
 		}
 		if (VECTOR_SIZE(conf->mptable) > 0) {
-			c += snprint_mptable(c, reply + maxlen - c,
+			c += snprint_mptable(conf, c, reply + maxlen - c,
 					     conf->mptable);
 			again = ((c - reply) == maxlen);
 			if (again)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 84f430c..2a54cba 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -252,18 +252,20 @@ show_config (char ** r, int * len)
 		REALLOC_REPLY(reply, again, maxlen);
 		if (again)
 			continue;
-		c += snprint_hwtable(c, reply + maxlen - c, conf->hwtable);
+		c += snprint_hwtable(conf, c, reply + maxlen - c,
+				     conf->hwtable);
 		again = ((c - reply) == maxlen);
 		REALLOC_REPLY(reply, again, maxlen);
 		if (again)
 			continue;
-		c += snprint_overrides(c, reply + maxlen - c, conf->overrides);
+		c += snprint_overrides(conf, c, reply + maxlen - c,
+				       conf->overrides);
 		again = ((c - reply) == maxlen);
 		REALLOC_REPLY(reply, again, maxlen);
 		if (again)
 			continue;
 		if (VECTOR_SIZE(conf->mptable) > 0) {
-			c += snprint_mptable(c, reply + maxlen - c,
+			c += snprint_mptable(conf, c, reply + maxlen - c,
 					     conf->mptable);
 			again = ((c - reply) == maxlen);
 			REALLOC_REPLY(reply, again, maxlen);
-- 
2.6.6
