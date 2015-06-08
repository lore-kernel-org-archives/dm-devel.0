From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/4] add raw format multipathd commands
Date: Mon,  8 Jun 2015 13:16:43 -0500
Message-ID: <1433787405-24716-3-git-send-email-bmarzins@redhat.com>
References: <1433787405-24716-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1433787405-24716-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This patch adds the following multipathd interactive commands

show paths raw format $fmt
show maps raw format $fmt

These commands work just like the regular "show ... format"
commands, except that they don't print a header, and don't add
any extra padding that isn't in the format string.  This should
make it easier for programs wanting to parse the output from
these commands.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c      | 25 +++++++++++++-----------
 libmultipath/print.h      |  4 ++--
 multipathd/cli.c          |  5 ++++-
 multipathd/cli.h          |  6 ++++--
 multipathd/cli_handlers.c | 50 +++++++++++++++++++++++++++++++++++------------
 multipathd/cli_handlers.h |  2 ++
 multipathd/main.c         |  2 ++
 7 files changed, 65 insertions(+), 29 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 5d63ed3..831a062 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -732,7 +732,7 @@ snprint_multipath_header (char * line, int len, char * format)
 
 int
 snprint_multipath (char * line, int len, char * format,
-	     struct multipath * mpp)
+	     struct multipath * mpp, int pad)
 {
 	char * c = line;   /* line cursor */
 	char * s = line;   /* for padding */
@@ -759,7 +759,8 @@ snprint_multipath (char * line, int len, char * format,
 
 		data->snprint(buff, MAX_FIELD_LEN, mpp);
 		PRINT(c, TAIL, "%s", buff);
-		PAD(data->width);
+		if (pad)
+			PAD(data->width);
 		buff[0] = '\0';
 	} while (*f++);
 
@@ -802,7 +803,7 @@ snprint_path_header (char * line, int len, char * format)
 
 int
 snprint_path (char * line, int len, char * format,
-	     struct path * pp)
+	     struct path * pp, int pad)
 {
 	char * c = line;   /* line cursor */
 	char * s = line;   /* for padding */
@@ -829,7 +830,8 @@ snprint_path (char * line, int len, char * format,
 
 		data->snprint(buff, MAX_FIELD_LEN, pp);
 		PRINT(c, TAIL, "%s", buff);
-		PAD(data->width);
+		if (pad)
+			PAD(data->width);
 	} while (*f++);
 
 	ENDLINE;
@@ -921,7 +923,7 @@ snprint_multipath_topology (char * buff, int len, struct multipath * mpp,
 	reset_multipath_layout();
 
 	if (verbosity == 1)
-		return snprint_multipath(buff, len, "%n", mpp);
+		return snprint_multipath(buff, len, "%n", mpp, 1);
 
 	if(isatty(1))
 		c += sprintf(c, "%c[%dm", 0x1B, 1); /* bold on */
@@ -940,10 +942,11 @@ snprint_multipath_topology (char * buff, int len, struct multipath * mpp,
 	if(isatty(1))
 		c += sprintf(c, "%c[%dm", 0x1B, 0); /* bold off */
 
-	fwd += snprint_multipath(buff + fwd, len - fwd, style, mpp);
+	fwd += snprint_multipath(buff + fwd, len - fwd, style, mpp, 1);
 	if (fwd > len)
 		return len;
-	fwd += snprint_multipath(buff + fwd, len - fwd, PRINT_MAP_PROPS, mpp);
+	fwd += snprint_multipath(buff + fwd, len - fwd, PRINT_MAP_PROPS, mpp,
+				 1);
 	if (fwd > len)
 		return len;
 
@@ -970,7 +973,7 @@ snprint_multipath_topology (char * buff, int len, struct multipath * mpp,
 				strcpy(f, " |- " PRINT_PATH_INDENT);
 			else
 				strcpy(f, " `- " PRINT_PATH_INDENT);
-			fwd += snprint_path(buff + fwd, len - fwd, fmt, pp);
+			fwd += snprint_path(buff + fwd, len - fwd, fmt, pp, 1);
 			if (fwd > len)
 				return len;
 		}
@@ -1502,7 +1505,7 @@ snprint_devices (char * buff, int len, struct vectors *vecs)
 			if (r > 0)
 				fwd += snprintf(buff + fwd, len - fwd,
 						" devnode blacklisted, unmonitored");
-			else if (r < 0)
+			else if (r <= 0)
 				fwd += snprintf(buff + fwd, len - fwd,
 						" devnode whitelisted, unmonitored");
 		} else
@@ -1532,7 +1535,7 @@ print_path (struct path * pp, char * style)
 	char line[MAX_LINE_LEN];
 
 	memset(&line[0], 0, MAX_LINE_LEN);
-	snprint_path(&line[0], MAX_LINE_LEN, style, pp);
+	snprint_path(&line[0], MAX_LINE_LEN, style, pp, 1);
 	printf("%s", line);
 }
 
@@ -1542,7 +1545,7 @@ print_multipath (struct multipath * mpp, char * style)
 	char line[MAX_LINE_LEN];
 
 	memset(&line[0], 0, MAX_LINE_LEN);
-	snprint_multipath(&line[0], MAX_LINE_LEN, style, mpp);
+	snprint_multipath(&line[0], MAX_LINE_LEN, style, mpp, 1);
 	printf("%s", line);
 }
 
diff --git a/libmultipath/print.h b/libmultipath/print.h
index a3c3319..9344271 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -37,8 +37,8 @@ void get_path_layout (vector pathvec, int header);
 void get_multipath_layout (vector mpvec, int header);
 int snprint_path_header (char *, int, char *);
 int snprint_multipath_header (char *, int, char *);
-int snprint_path (char *, int, char *, struct path *);
-int snprint_multipath (char *, int, char *, struct multipath *);
+int snprint_path (char *, int, char *, struct path *, int);
+int snprint_multipath (char *, int, char *, struct multipath *, int);
 int snprint_multipath_topology (char *, int, struct multipath * mpp,
 				int verbosity);
 int snprint_defaults (char *, int);
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 8d26956..e0a6bec 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -180,7 +180,7 @@ load_keys (void)
 	r += add_key(keys, "config", CONFIG, 0);
 	r += add_key(keys, "blacklist", BLACKLIST, 0);
 	r += add_key(keys, "devices", DEVICES, 0);
-	r += add_key(keys, "format", FMT, 1);
+	r += add_key(keys, "raw", RAW, 0);
 	r += add_key(keys, "wildcards", WILDCARDS, 0);
 	r += add_key(keys, "quit", QUIT, 0);
 	r += add_key(keys, "exit", QUIT, 0);
@@ -188,6 +188,7 @@ load_keys (void)
 	r += add_key(keys, "getprstatus", GETPRSTATUS, 0);
 	r += add_key(keys, "setprstatus", SETPRSTATUS, 0);
 	r += add_key(keys, "unsetprstatus", UNSETPRSTATUS, 0);
+	r += add_key(keys, "format", FMT, 1);
 
 	if (r) {
 		free_keys(keys);
@@ -463,6 +464,7 @@ cli_init (void) {
 
 	add_handler(LIST+PATHS, NULL);
 	add_handler(LIST+PATHS+FMT, NULL);
+	add_handler(LIST+PATHS+RAW+FMT, NULL);
 	add_handler(LIST+PATH, NULL);
 	add_handler(LIST+STATUS, NULL);
 	add_handler(LIST+DAEMON, NULL);
@@ -470,6 +472,7 @@ cli_init (void) {
 	add_handler(LIST+MAPS+STATUS, NULL);
 	add_handler(LIST+MAPS+STATS, NULL);
 	add_handler(LIST+MAPS+FMT, NULL);
+	add_handler(LIST+MAPS+RAW+FMT, NULL);
 	add_handler(LIST+MAPS+TOPOLOGY, NULL);
 	add_handler(LIST+TOPOLOGY, NULL);
 	add_handler(LIST+MAP+TOPOLOGY, NULL);
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 2e0e1da..f6d2726 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -26,13 +26,14 @@ enum {
 	__CONFIG,
 	__BLACKLIST,
 	__DEVICES,
-	__FMT,
+	__RAW,
 	__WILDCARDS,
 	__QUIT,
 	__SHUTDOWN,
 	__GETPRSTATUS,
 	__SETPRSTATUS,
 	__UNSETPRSTATUS,
+	__FMT,
 };
 
 #define LIST		(1 << __LIST)
@@ -62,7 +63,7 @@ enum {
 #define CONFIG		(1 << __CONFIG)
 #define BLACKLIST	(1 << __BLACKLIST)
 #define DEVICES		(1 << __DEVICES)
-#define FMT		(1 << __FMT)
+#define RAW		(1 << __RAW)
 #define COUNT		(1 << __COUNT)
 #define WILDCARDS	(1 << __WILDCARDS)
 #define QUIT		(1 << __QUIT)
@@ -70,6 +71,7 @@ enum {
 #define GETPRSTATUS	(1UL << __GETPRSTATUS)
 #define SETPRSTATUS	(1UL << __SETPRSTATUS)
 #define UNSETPRSTATUS	(1UL << __UNSETPRSTATUS)
+#define FMT		(1UL << __FMT)
 
 #define INITIAL_REPLY_LEN	1200
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 8cde810..ff4c2d1 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -24,7 +24,8 @@
 #include "uevent.h"
 
 int
-show_paths (char ** r, int * len, struct vectors * vecs, char * style)
+show_paths (char ** r, int * len, struct vectors * vecs, char * style,
+	    int pretty)
 {
 	int i;
 	struct path * pp;
@@ -42,13 +43,13 @@ show_paths (char ** r, int * len, struct vectors * vecs, char * style)
 
 		c = reply;
 
-		if (VECTOR_SIZE(vecs->pathvec) > 0)
+		if (pretty && VECTOR_SIZE(vecs->pathvec) > 0)
 			c += snprint_path_header(c, reply + maxlen - c,
 						 style);
 
 		vector_foreach_slot(vecs->pathvec, pp, i)
 			c += snprint_path(c, reply + maxlen - c,
-					  style, pp);
+					  style, pp, pretty);
 
 		again = ((c - reply) == (maxlen - 1));
 
@@ -77,7 +78,7 @@ show_path (char ** r, int * len, struct vectors * vecs, struct path *pp,
 
 		c = reply;
 
-		c += snprint_path(c, reply + maxlen - c, style, pp);
+		c += snprint_path(c, reply + maxlen - c, style, pp, 0);
 
 		again = ((c - reply) == (maxlen - 1));
 
@@ -220,7 +221,7 @@ cli_list_paths (void * v, char ** reply, int * len, void * data)
 
 	condlog(3, "list paths (operator)");
 
-	return show_paths(reply, len, vecs, PRINT_PATH_CHECKER);
+	return show_paths(reply, len, vecs, PRINT_PATH_CHECKER, 1);
 }
 
 int
@@ -231,7 +232,18 @@ cli_list_paths_fmt (void * v, char ** reply, int * len, void * data)
 
 	condlog(3, "list paths (operator)");
 
-	return show_paths(reply, len, vecs, fmt);
+	return show_paths(reply, len, vecs, fmt, 1);
+}
+
+int
+cli_list_paths_raw (void * v, char ** reply, int * len, void * data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	char * fmt = get_keyparam(v, FMT);
+
+	condlog(3, "list paths (operator)");
+
+	return show_paths(reply, len, vecs, fmt, 0);
 }
 
 int
@@ -337,7 +349,8 @@ show_daemon (char ** r, int *len)
 }
 
 int
-show_maps (char ** r, int *len, struct vectors * vecs, char * style)
+show_maps (char ** r, int *len, struct vectors * vecs, char * style,
+	   int pretty)
 {
 	int i;
 	struct multipath * mpp;
@@ -354,13 +367,13 @@ show_maps (char ** r, int *len, struct vectors * vecs, char * style)
 			return 1;
 
 		c = reply;
-		if (VECTOR_SIZE(vecs->mpvec) > 0)
+		if (pretty && VECTOR_SIZE(vecs->mpvec) > 0)
 			c += snprint_multipath_header(c, reply + maxlen - c,
 						      style);
 
 		vector_foreach_slot(vecs->mpvec, mpp, i)
 			c += snprint_multipath(c, reply + maxlen - c,
-					       style, mpp);
+					       style, mpp, pretty);
 
 		again = ((c - reply) == (maxlen - 1));
 
@@ -379,7 +392,18 @@ cli_list_maps_fmt (void * v, char ** reply, int * len, void * data)
 
 	condlog(3, "list maps (operator)");
 
-	return show_maps(reply, len, vecs, fmt);
+	return show_maps(reply, len, vecs, fmt, 1);
+}
+
+int
+cli_list_maps_raw (void * v, char ** reply, int * len, void * data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	char * fmt = get_keyparam(v, FMT);
+
+	condlog(3, "list maps (operator)");
+
+	return show_maps(reply, len, vecs, fmt, 0);
 }
 
 int
@@ -389,7 +413,7 @@ cli_list_maps (void * v, char ** reply, int * len, void * data)
 
 	condlog(3, "list maps (operator)");
 
-	return show_maps(reply, len, vecs, PRINT_MAP_NAMES);
+	return show_maps(reply, len, vecs, PRINT_MAP_NAMES, 1);
 }
 
 int
@@ -409,7 +433,7 @@ cli_list_maps_status (void * v, char ** reply, int * len, void * data)
 
 	condlog(3, "list maps status (operator)");
 
-	return show_maps(reply, len, vecs, PRINT_MAP_STATUS);
+	return show_maps(reply, len, vecs, PRINT_MAP_STATUS, 1);
 }
 
 int
@@ -419,7 +443,7 @@ cli_list_maps_stats (void * v, char ** reply, int * len, void * data)
 
 	condlog(3, "list maps stats (operator)");
 
-	return show_maps(reply, len, vecs, PRINT_MAP_STATS);
+	return show_maps(reply, len, vecs, PRINT_MAP_STATS, 1);
 }
 
 int
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index c4636d2..799f8da 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -1,10 +1,12 @@
 int cli_list_paths (void * v, char ** reply, int * len, void * data);
 int cli_list_paths_fmt (void * v, char ** reply, int * len, void * data);
+int cli_list_paths_raw (void * v, char ** reply, int * len, void * data);
 int cli_list_path (void * v, char ** reply, int * len, void * data);
 int cli_list_status (void * v, char ** reply, int * len, void * data);
 int cli_list_daemon (void * v, char ** reply, int * len, void * data);
 int cli_list_maps (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_fmt (void * v, char ** reply, int * len, void * data);
+int cli_list_maps_raw (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_status (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_stats (void * v, char ** reply, int * len, void * data);
 int cli_list_map_topology (void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index f17b7da..09defc9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -904,6 +904,7 @@ uxlsnrloop (void * ap)
 
 	set_handler_callback(LIST+PATHS, cli_list_paths);
 	set_handler_callback(LIST+PATHS+FMT, cli_list_paths_fmt);
+	set_handler_callback(LIST+PATHS+RAW+FMT, cli_list_paths_raw);
 	set_handler_callback(LIST+PATH, cli_list_path);
 	set_handler_callback(LIST+MAPS, cli_list_maps);
 	set_handler_callback(LIST+STATUS, cli_list_status);
@@ -911,6 +912,7 @@ uxlsnrloop (void * ap)
 	set_handler_callback(LIST+MAPS+STATUS, cli_list_maps_status);
 	set_handler_callback(LIST+MAPS+STATS, cli_list_maps_stats);
 	set_handler_callback(LIST+MAPS+FMT, cli_list_maps_fmt);
+	set_handler_callback(LIST+MAPS+RAW+FMT, cli_list_maps_raw);
 	set_handler_callback(LIST+MAPS+TOPOLOGY, cli_list_maps_topology);
 	set_handler_callback(LIST+TOPOLOGY, cli_list_maps_topology);
 	set_handler_callback(LIST+MAP+TOPOLOGY, cli_list_map_topology);
-- 
1.8.3.1
