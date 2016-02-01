From: Todd Gill <tgill@redhat.com>
Subject: [PATCH 2/3] add 'show groups' command to multipathd
Date: Mon,  1 Feb 2016 07:53:26 -0500
Message-ID: <1454331207-380-2-git-send-email-tgill@redhat.com>
References: <1454331207-380-1-git-send-email-tgill@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454331207-380-1-git-send-email-tgill@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Todd Gill <tgill@redhat.com>
List-Id: dm-devel.ids

Command allows user to display pathgroups.  This is a step towards
allowing a user to parse the output of multipathd and be able to
understand the groups.

Signed-off-by: Todd Gill <tgill@redhat.com>
---
 libmultipath/print.c      | 73 +++++++++++++++++++++++++++++++++++++++++------
 libmultipath/print.h      |  9 ++++--
 multipathd/cli.c          |  2 ++
 multipathd/cli.h          |  2 ++
 multipathd/cli_handlers.c | 59 ++++++++++++++++++++++++++++++++++++++
 multipathd/cli_handlers.h |  1 +
 multipathd/main.c         |  1 +
 7 files changed, 137 insertions(+), 10 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 332327a..c0e6809 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -406,13 +406,13 @@ snprint_pri (char * buff, size_t len, struct path * pp)
 }
 
 static int
-snprint_pg_selector (char * buff, size_t len, struct pathgroup * pgp)
+snprint_pg_selector (char * buff, size_t len, struct pathgroup * pgp, int group)
 {
 	return snprint_str(buff, len, pgp->selector);
 }
 
 static int
-snprint_pg_pri (char * buff, size_t len, struct pathgroup * pgp)
+snprint_pg_pri (char * buff, size_t len, struct pathgroup * pgp, int group)
 {
 	/*
 	 * path group priority is not updated for every path prio change,
@@ -425,7 +425,7 @@ snprint_pg_pri (char * buff, size_t len, struct pathgroup * pgp)
 }
 
 static int
-snprint_pg_state (char * buff, size_t len, struct pathgroup * pgp)
+snprint_pg_state (char * buff, size_t len, struct pathgroup * pgp, int group)
 {
 	switch (pgp->status) {
 	case PGSTATE_ENABLED:
@@ -648,6 +648,30 @@ get_path_layout (vector pathvec, int header)
 	}
 }
 
+void
+get_pathgroup_layout (vector mpvec, int header)
+{
+	int i, j, k;
+	char buff[MAX_FIELD_LEN];
+	struct pathgroup * pgp;
+	struct multipath * mpp;
+
+	for (i = 0; pgd[i].header; i++) {
+		if (header)
+			pgd[i].width = strlen(pgd[i].header);
+		else
+			pgd[i].width = 0;
+
+		vector_foreach_slot (mpvec, mpp, j) {
+			vector_foreach_slot (mpp->pg, pgp, k) {
+				pgp->selector = mpp->selector; /* hack */
+				pgd[i].snprint(buff, MAX_FIELD_LEN, pgp, k);
+				pgd[i].width = MAX(pgd[i].width, strlen(buff));
+			}
+		}
+	}
+}
+
 static void
 reset_multipath_layout (void)
 {
@@ -856,7 +880,7 @@ snprint_path (char * line, int len, char * format,
 
 int
 snprint_pathgroup (char * line, int len, char * format,
-		   struct pathgroup * pgp)
+		   struct pathgroup * pgp, int group)
 {
 	char * c = line;   /* line cursor */
 	char * s = line;   /* for padding */
@@ -881,7 +905,7 @@ snprint_pathgroup (char * line, int len, char * format,
 		if (!(data = pgd_lookup(*f)))
 			continue;
 
-		data->snprint(buff, MAX_FIELD_LEN, pgp);
+		data->snprint(buff, MAX_FIELD_LEN, pgp, group);
 		PRINT(c, TAIL, "%s", buff);
 		PAD(data->width);
 	} while (*f++);
@@ -890,6 +914,39 @@ snprint_pathgroup (char * line, int len, char * format,
 	return (c - line);
 }
 
+int
+snprint_pathgroup_header (char * line, int len, char * format)
+{
+	char * c = line;   /* line cursor */
+	char * s = line;   /* for padding */
+	char * f = format; /* format string cursor */
+	int fwd;
+	struct pathgroup_data * data;
+
+	memset(line, 0, len);
+
+	do {
+		if (!TAIL)
+			break;
+
+		if (*f != '%') {
+			*c++ = *f;
+			NOPAD;
+			continue;
+		}
+		f++;
+
+		if (!(data = pgd_lookup(*f)))
+			continue; /* unknown wildcard */
+
+		PRINT(c, TAIL, "%s", data->header);
+		PAD(data->width);
+	} while (*f++);
+
+	ENDLINE;
+	return (c - line);
+}
+
 extern void
 print_multipath_topology (struct multipath * mpp, int verbosity)
 {
@@ -976,7 +1033,7 @@ snprint_multipath_topology (char * buff, int len, struct multipath * mpp,
 			strcpy(f, "|-+- " PRINT_PG_INDENT);
 		} else
 			strcpy(f, "`-+- " PRINT_PG_INDENT);
-		fwd += snprint_pathgroup(buff + fwd, len - fwd, fmt, pgp);
+		fwd += snprint_pathgroup(buff + fwd, len - fwd, fmt, pgp, j);
 		if (fwd > len)
 			return len;
 
@@ -1566,12 +1623,12 @@ print_multipath (struct multipath * mpp, char * style)
 }
 
 extern void
-print_pathgroup (struct pathgroup * pgp, char * style)
+print_pathgroup (struct pathgroup * pgp, char * style, int group)
 {
 	char line[MAX_LINE_LEN];
 
 	memset(&line[0], 0, MAX_LINE_LEN);
-	snprint_pathgroup(&line[0], MAX_LINE_LEN, style, pgp);
+	snprint_pathgroup(&line[0], MAX_LINE_LEN, style, pgp, group);
 	printf("%s", line);
 }
 
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 9344271..66b40da 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -1,6 +1,7 @@
 #define PRINT_PATH_LONG      "%w %i %d %D %p %t %T %s %o"
 #define PRINT_PATH_INDENT    "%i %d %D %t %T %o"
 #define PRINT_PATH_CHECKER   "%i %d %D %p %t %T %o %C"
+#define PRINT_GROUP_CHECKER  "%s %p %t"
 #define PRINT_MAP_STATUS     "%n %F %Q %N %t %r"
 #define PRINT_MAP_STATS      "%n %0 %1 %2 %3 %4"
 #define PRINT_MAP_NAMES      "%n %d %w"
@@ -30,14 +31,18 @@ struct pathgroup_data {
 	char wildcard;
 	char * header;
 	int width;
-	int (*snprint)(char * buff, size_t len, struct pathgroup * pgp);
+	int (*snprint)(char * buff, size_t len, struct pathgroup * pgp, int group);
 };
 
 void get_path_layout (vector pathvec, int header);
 void get_multipath_layout (vector mpvec, int header);
+void get_pathgroup_layout (vector mpvec, int header);
 int snprint_path_header (char *, int, char *);
 int snprint_multipath_header (char *, int, char *);
+int snprint_pathgroup_header (char *, int, char *);
 int snprint_path (char *, int, char *, struct path *, int);
+int snprint_pathgroup (char * line, int len, char * format,
+		struct pathgroup * pgp, int group);
 int snprint_multipath (char *, int, char *, struct multipath *, int);
 int snprint_multipath_topology (char *, int, struct multipath * mpp,
 				int verbosity);
@@ -55,7 +60,7 @@ int snprint_overrides (char *, int, struct hwentry *);
 void print_multipath_topology (struct multipath * mpp, int verbosity);
 void print_path (struct path * pp, char * style);
 void print_multipath (struct multipath * mpp, char * style);
-void print_pathgroup (struct pathgroup * pgp, char * style);
+void print_pathgroup (struct pathgroup * pgp, char * style, int group);
 void print_map (struct multipath * mpp, char * params);
 void print_all_paths (vector pathvec, int banner);
 void print_all_paths_custo (vector pathvec, int banner, char *fmt);
diff --git a/multipathd/cli.c b/multipathd/cli.c
index e0a6bec..284741a 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -168,6 +168,7 @@ load_keys (void)
 	r += add_key(keys, "paths", PATHS, 0);
 	r += add_key(keys, "maps", MAPS, 0);
 	r += add_key(keys, "multipaths", MAPS, 0);
+	r += add_key(keys, "groups", GROUPS, 0);
 	r += add_key(keys, "path", PATH, 1);
 	r += add_key(keys, "map", MAP, 1);
 	r += add_key(keys, "multipath", MAP, 1);
@@ -474,6 +475,7 @@ cli_init (void) {
 	add_handler(LIST+MAPS+FMT, NULL);
 	add_handler(LIST+MAPS+RAW+FMT, NULL);
 	add_handler(LIST+MAPS+TOPOLOGY, NULL);
+	add_handler(LIST+GROUPS, NULL);
 	add_handler(LIST+TOPOLOGY, NULL);
 	add_handler(LIST+MAP+TOPOLOGY, NULL);
 	add_handler(LIST+CONFIG, NULL);
diff --git a/multipathd/cli.h b/multipathd/cli.h
index f6d2726..c21d331 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -15,6 +15,7 @@ enum {
 	__RESTOREQ,
 	__PATHS,
 	__MAPS,
+	__GROUPS,
 	__PATH,
 	__MAP,
 	__GROUP,
@@ -55,6 +56,7 @@ enum {
 #define PATH		(1 << __PATH)
 #define MAP		(1 << __MAP)
 #define GROUP		(1 << __GROUP)
+#define GROUPS		(1 << __GROUPS)
 #define RECONFIGURE	(1 << __RECONFIGURE)
 #define DAEMON		(1 << __DAEMON)
 #define STATUS		(1 << __STATUS)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index a44281f..d99fb92 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -24,6 +24,55 @@
 #include "uevent.h"
 
 int
+show_groups (char ** r, int * len, struct vectors * vecs, char * style,
+	    int pretty)
+{
+	int i, j;
+	struct multipath * mpp;
+	struct pathgroup * pgp;
+	char * c;
+	char * reply;
+	unsigned int maxlen = INITIAL_REPLY_LEN;
+	int again = 1;
+
+	reply = MALLOC(maxlen);
+
+	while (again) {
+		if (!reply)
+			return 1;
+
+		c = reply;
+
+		get_pathgroup_layout(vecs->mpvec, pretty);
+
+		if (pretty && VECTOR_SIZE(vecs->pathvec) > 0)
+			c += snprint_pathgroup_header(c, reply + maxlen - c,
+						 style);
+
+		vector_foreach_slot(vecs->mpvec, mpp, i) {
+
+			if (update_multipath(vecs, mpp->alias, 0)) {
+				i--;
+				continue;
+			}
+
+			vector_foreach_slot(mpp->pg, pgp, j) {
+				pgp->selector = mpp->selector; /* hack */
+				c += snprint_pathgroup (c, reply + maxlen - c, style, pgp, j);
+			}
+
+		}
+
+		again = ((c - reply) == (maxlen - 1));
+
+		REALLOC_REPLY(reply, again, maxlen);
+	}
+	*r = reply;
+	*len = (int)(c - reply + 1);
+	return 0;
+}
+
+int
 show_paths (char ** r, int * len, struct vectors * vecs, char * style,
 	    int pretty)
 {
@@ -385,6 +434,16 @@ show_maps (char ** r, int *len, struct vectors * vecs, char * style,
 }
 
 int
+cli_list_groups (void * v, char ** reply, int * len, void * data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+
+	condlog(3, "list groups (operator)");
+
+	return show_groups(reply, len, vecs, PRINT_GROUP_CHECKER, 1);
+}
+
+int
 cli_list_maps_fmt (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index 799f8da..844c553 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -4,6 +4,7 @@ int cli_list_paths_raw (void * v, char ** reply, int * len, void * data);
 int cli_list_path (void * v, char ** reply, int * len, void * data);
 int cli_list_status (void * v, char ** reply, int * len, void * data);
 int cli_list_daemon (void * v, char ** reply, int * len, void * data);
+int cli_list_groups (void * v, char ** reply, int * len, void * data);
 int cli_list_maps (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_fmt (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_raw (void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index 04f6d02..f1a297c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -904,6 +904,7 @@ uxlsnrloop (void * ap)
 	set_handler_callback(LIST+PATHS+RAW+FMT, cli_list_paths_raw);
 	set_handler_callback(LIST+PATH, cli_list_path);
 	set_handler_callback(LIST+MAPS, cli_list_maps);
+	set_handler_callback(LIST+GROUPS, cli_list_groups);
 	set_handler_callback(LIST+STATUS, cli_list_status);
 	set_handler_callback(LIST+DAEMON, cli_list_daemon);
 	set_handler_callback(LIST+MAPS+STATUS, cli_list_maps_status);
-- 
2.5.0
