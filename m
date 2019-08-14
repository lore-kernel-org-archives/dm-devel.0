From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: add print_foreign option
Date: Wed, 14 Aug 2019 12:22:00 -0500
Message-ID: <1565803320-6996-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

This adds a print_foreign multipath.conf defaults option, that allows
users to disable printing foreign devices and paths. It defaults to
"yes".

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c      |  1 +
 libmultipath/config.h      |  1 +
 libmultipath/defaults.h    |  1 +
 libmultipath/dict.c        |  4 ++++
 multipath/main.c           |  4 ++--
 multipath/multipath.conf.5 | 12 ++++++++++++
 multipathd/cli_handlers.c  | 40 ++++++++++++++++++++++++++++++--------
 7 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 20e3b8bf..ec437a15 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -717,6 +717,7 @@ load_config (char * file)
 	conf->remove_retries = 0;
 	conf->ghost_delay = DEFAULT_GHOST_DELAY;
 	conf->all_tg_pt = DEFAULT_ALL_TG_PT;
+	conf->print_foreign = DEFAULT_PRINT_FOREIGN;
 	/*
 	 * preload default hwtable
 	 */
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 0b978970..f3060ff9 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -187,6 +187,7 @@ struct config {
 	int ghost_delay;
 	int find_multipaths_timeout;
 	int marginal_pathgroups;
+	int print_foreign;
 	unsigned int version[3];
 
 	char * multipath_dir;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index decc9335..926ba7a3 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -48,6 +48,7 @@
 #define DEFAULT_FIND_MULTIPATHS_TIMEOUT -10
 #define DEFAULT_UNKNOWN_FIND_MULTIPATHS_TIMEOUT 1
 #define DEFAULT_ALL_TG_PT ALL_TG_PT_OFF
+#define DEFAULT_PRINT_FOREIGN	1
 
 #define CHECKINT_UNDEF		(~0U)
 #define DEFAULT_CHECKINT	5
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index b5feb884..dcf4599b 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1342,6 +1342,9 @@ declare_hw_snprint(all_tg_pt, print_yes_no_undef)
 declare_def_handler(marginal_pathgroups, set_yes_no)
 declare_def_snprint(marginal_pathgroups, print_yes_no)
 
+declare_def_handler(print_foreign, set_yes_no)
+declare_def_snprint(print_foreign, print_yes_no)
+
 static int
 def_uxsock_timeout_handler(struct config *conf, vector strvec)
 {
@@ -1713,6 +1716,7 @@ init_keywords(vector keywords)
 			&def_find_multipaths_timeout_handler,
 			&snprint_def_find_multipaths_timeout);
 	install_keyword("marginal_pathgroups", &def_marginal_pathgroups_handler, &snprint_def_marginal_pathgroups);
+	install_keyword("print_foreign", &def_print_foreign_handler, &snprint_def_print_foreign);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/multipath/main.c b/multipath/main.c
index 96a11468..4f3f8641 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -304,8 +304,8 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 
 	if (cmd == CMD_LIST_SHORT || cmd == CMD_LIST_LONG) {
 		struct config *conf = get_multipath_config();
-
-		print_foreign_topology(conf->verbosity);
+		if (conf->print_foreign)
+			print_foreign_topology(conf->verbosity);
 		put_multipath_config(conf);
 	}
 
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index a85a8a60..c1711a20 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1224,6 +1224,18 @@ The default is: \fBno\fR
 .RE
 .
 .
+.TP
+.B print_foreign
+This controls whether or not multipath's path and device listings show natively
+multipathed devices, that are not managed by the multipath and multipathd
+programs. Currently this only controls wherely native nvme multipathed
+devices and paths will be shown.
+.RS
+.TP
+The default is: \fByes\fR
+.RE
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "blacklist and blacklist_exceptions sections"
 .\" ----------------------------------------------------------------------------
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 8a899049..c401f9e3 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -42,9 +42,16 @@ show_paths (char ** r, int * len, struct vectors * vecs, char * style,
 	char * reply, * header;
 	unsigned int maxlen = INITIAL_REPLY_LEN;
 	int again = 1;
+	struct config *conf;
+	int print_foreign;
+
+	conf = get_multipath_config();
+	print_foreign = conf->print_foreign;
+	put_multipath_config(conf);
 
 	get_path_layout(vecs->pathvec, 1);
-	foreign_path_layout();
+	if (print_foreign)
+		foreign_path_layout();
 
 	reply = MALLOC(maxlen);
 
@@ -63,8 +70,9 @@ show_paths (char ** r, int * len, struct vectors * vecs, char * style,
 			c += snprint_path(c, reply + maxlen - c,
 					  style, pp, pretty);
 
-		c += snprint_foreign_paths(c, reply + maxlen - c,
-					   style, pretty);
+		if (print_foreign)
+			c += snprint_foreign_paths(c, reply + maxlen - c,
+						   style, pretty);
 
 		again = ((c - reply) == (maxlen - 1));
 
@@ -149,9 +157,16 @@ show_maps_topology (char ** r, int * len, struct vectors * vecs)
 	char * reply;
 	unsigned int maxlen = INITIAL_REPLY_LEN;
 	int again = 1;
+	struct config *conf;
+	int print_foreign;
+
+	conf = get_multipath_config();
+	print_foreign = conf->print_foreign;
+	put_multipath_config(conf);
 
 	get_path_layout(vecs->pathvec, 0);
-	foreign_path_layout();
+	if (print_foreign)
+		foreign_path_layout();
 
 	reply = MALLOC(maxlen);
 
@@ -169,7 +184,8 @@ show_maps_topology (char ** r, int * len, struct vectors * vecs)
 			c += snprint_multipath_topology(c, reply + maxlen - c,
 							mpp, 2);
 		}
-		c += snprint_foreign_topology(c, reply + maxlen - c, 2);
+		if (print_foreign)
+			c += snprint_foreign_topology(c, reply + maxlen - c, 2);
 
 		again = ((c - reply) == (maxlen - 1));
 
@@ -506,9 +522,16 @@ show_maps (char ** r, int *len, struct vectors * vecs, char * style,
 	char * reply;
 	unsigned int maxlen = INITIAL_REPLY_LEN;
 	int again = 1;
+	struct config *conf;
+	int print_foreign;
+
+	conf = get_multipath_config();
+	print_foreign = conf->print_foreign;
+	put_multipath_config(conf);
 
 	get_multipath_layout(vecs->mpvec, 1);
-	foreign_multipath_layout();
+	if (print_foreign)
+		foreign_multipath_layout();
 
 	reply = MALLOC(maxlen);
 
@@ -531,8 +554,9 @@ show_maps (char ** r, int *len, struct vectors * vecs, char * style,
 					       style, mpp, pretty);
 
 		}
-		c += snprint_foreign_multipaths(c, reply + maxlen - c,
-						style, pretty);
+		if (print_foreign)
+			c += snprint_foreign_multipaths(c, reply + maxlen - c,
+							style, pretty);
 		again = ((c - reply) == (maxlen - 1));
 
 		REALLOC_REPLY(reply, again, maxlen);
-- 
2.17.2
