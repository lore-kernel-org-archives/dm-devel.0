From: Todd Gill <tgill@redhat.com>
Subject: [PATCH 3/3] add options to the show groups command
Date: Mon,  1 Feb 2016 07:53:27 -0500
Message-ID: <1454331207-380-3-git-send-email-tgill@redhat.com>
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

Options:

format - allow the user to specify output format via wildcards
raw    - don't display headers for formatted output
%w     - display the WWN for the map that contains the group
%g     - display the group number

These options allow a user to parse the output to connect a pathgroup
to the multipath map.  It also allows a user to determine the member
paths of a pathgroup.

Signed-off-by: Todd Gill <tgill@redhat.com>
---
 libmultipath/print.c      | 18 ++++++++++++++++++
 libmultipath/print.h      |  2 +-
 multipathd/cli.c          |  2 ++
 multipathd/cli_handlers.c | 22 ++++++++++++++++++++++
 multipathd/cli_handlers.h |  2 ++
 multipathd/main.c         |  2 ++
 6 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index c0e6809..98da1e4 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -412,6 +412,22 @@ snprint_pg_selector (char * buff, size_t len, struct pathgroup * pgp, int group)
 }
 
 static int
+snprint_pg_uuid (char * buff, size_t len, struct pathgroup * pgp, int group_num)
+{
+	struct path * pp;
+
+	pp = VECTOR_LAST_SLOT(pgp->paths);
+	return snprint_str(buff, len, pp->wwid);
+}
+
+static int
+snprint_pg_group (char * buff, size_t len, struct pathgroup * pgp,
+		int group_num)
+{
+	return snprint_int(buff, len, group_num);
+}
+
+static int
 snprint_pg_pri (char * buff, size_t len, struct pathgroup * pgp, int group)
 {
 	/*
@@ -602,7 +618,9 @@ struct path_data pd[] = {
 };
 
 struct pathgroup_data pgd[] = {
+	{'w', "uuid",          0, snprint_pg_uuid},
 	{'s', "selector",      0, snprint_pg_selector},
+	{'g', "group",         0, snprint_pg_group},
 	{'p', "pri",           0, snprint_pg_pri},
 	{'t', "dm_st",         0, snprint_pg_state},
 	{0, NULL, 0 , NULL}
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 66b40da..efff693 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -1,7 +1,7 @@
 #define PRINT_PATH_LONG      "%w %i %d %D %p %t %T %s %o"
 #define PRINT_PATH_INDENT    "%i %d %D %t %T %o"
 #define PRINT_PATH_CHECKER   "%i %d %D %p %t %T %o %C"
-#define PRINT_GROUP_CHECKER  "%s %p %t"
+#define PRINT_GROUP_CHECKER  "%w %g %s %p %t"
 #define PRINT_MAP_STATUS     "%n %F %Q %N %t %r"
 #define PRINT_MAP_STATS      "%n %0 %1 %2 %3 %4"
 #define PRINT_MAP_NAMES      "%n %d %w"
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 284741a..8bb15ab 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -476,6 +476,8 @@ cli_init (void) {
 	add_handler(LIST+MAPS+RAW+FMT, NULL);
 	add_handler(LIST+MAPS+TOPOLOGY, NULL);
 	add_handler(LIST+GROUPS, NULL);
+	add_handler(LIST+GROUPS+FMT, NULL);
+	add_handler(LIST+GROUPS+RAW+FMT, NULL);
 	add_handler(LIST+TOPOLOGY, NULL);
 	add_handler(LIST+MAP+TOPOLOGY, NULL);
 	add_handler(LIST+CONFIG, NULL);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index d99fb92..0ff5b2b 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -444,6 +444,28 @@ cli_list_groups (void * v, char ** reply, int * len, void * data)
 }
 
 int
+cli_list_groups_fmt (void * v, char ** reply, int * len, void * data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	char * fmt = get_keyparam(v, FMT);
+
+	condlog(3, "list groups (operator)");
+
+	return show_groups(reply, len, vecs, fmt, 1);
+}
+
+int
+cli_list_groups_raw (void * v, char ** reply, int * len, void * data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	char * fmt = get_keyparam(v, FMT);
+
+	condlog(3, "list groups (operator)");
+
+	return show_groups(reply, len, vecs, fmt, 0);
+}
+
+int
 cli_list_maps_fmt (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index 844c553..85e8b58 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -5,6 +5,8 @@ int cli_list_path (void * v, char ** reply, int * len, void * data);
 int cli_list_status (void * v, char ** reply, int * len, void * data);
 int cli_list_daemon (void * v, char ** reply, int * len, void * data);
 int cli_list_groups (void * v, char ** reply, int * len, void * data);
+int cli_list_groups_fmt (void * v, char ** reply, int * len, void * data);
+int cli_list_groups_raw (void * v, char ** reply, int * len, void * data);
 int cli_list_maps (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_fmt (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_raw (void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index f1a297c..a6027d8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -905,6 +905,8 @@ uxlsnrloop (void * ap)
 	set_handler_callback(LIST+PATH, cli_list_path);
 	set_handler_callback(LIST+MAPS, cli_list_maps);
 	set_handler_callback(LIST+GROUPS, cli_list_groups);
+	set_handler_callback(LIST+GROUPS+FMT, cli_list_groups_fmt);
+	set_handler_callback(LIST+GROUPS+RAW+FMT, cli_list_groups_raw);
 	set_handler_callback(LIST+STATUS, cli_list_status);
 	set_handler_callback(LIST+DAEMON, cli_list_daemon);
 	set_handler_callback(LIST+MAPS+STATUS, cli_list_maps_status);
-- 
2.5.0
