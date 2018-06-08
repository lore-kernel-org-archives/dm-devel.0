From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 24/28] multipath: implement "multipath -T"
Date: Fri,  8 Jun 2018 12:20:37 +0200
Message-ID: <20180608102041.22904-25-mwilck@suse.com>
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

This does the same as "multipathd show config local", and is
provided for convenience.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.h |  1 +
 multipath/main.c      | 43 +++++++++++++++++++++++++++----------------
 multipath/multipath.8 |  8 +++++++-
 3 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index e1cbd59b..e2fa1852 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -37,6 +37,7 @@ enum mpath_cmds {
 	CMD_RESET_WWIDS,
 	CMD_ADD_WWID,
 	CMD_USABLE_PATHS,
+	CMD_DUMP_CONFIG,
 };
 
 enum force_reload_types {
diff --git a/multipath/main.c b/multipath/main.c
index 54a98026..ed4f40ef 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -80,6 +80,19 @@ void put_multipath_config(void *arg)
 	/* Noop for now */
 }
 
+static int
+dump_config (struct config *conf, vector hwes, vector mpvec)
+{
+	char * reply = snprint_config(conf, NULL, hwes, mpvec);
+
+	if (reply != NULL) {
+		printf("%s", reply);
+		FREE(reply);
+		return 0;
+	} else
+		return 1;
+}
+
 void rcu_register_thread_memb(void) {}
 
 void rcu_unregister_thread_memb(void) {}
@@ -112,7 +125,7 @@ usage (char * progname)
 	fprintf (stderr, "  %s [-a|-c|-w|-W] [-d] [-r] [-i] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
 	fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [-R num] [dev]\n", progname);
 	fprintf (stderr, "  %s -F [-v lvl] [-R num]\n", progname);
-	fprintf (stderr, "  %s -t\n", progname);
+	fprintf (stderr, "  %s [-t|-T]\n", progname);
 	fprintf (stderr, "  %s -h\n", progname);
 	fprintf (stderr,
 		"\n"
@@ -128,6 +141,7 @@ usage (char * progname)
 		"  -q      allow queue_if_no_path when multipathd is not running\n"
 		"  -d      dry run, do not create or update devmaps\n"
 		"  -t      display the currently used multipathd configuration\n"
+		"  -T      display the multipathd configuration without builtin defaults\n"
 		"  -r      force devmap reload\n"
 		"  -i      ignore wwids file\n"
 		"  -B      treat the bindings file as read only\n"
@@ -671,6 +685,13 @@ configure (struct config *conf, enum mpath_cmds cmd,
 
 	filter_pathvec(pathvec, refwwid);
 
+	if (cmd == CMD_DUMP_CONFIG) {
+		vector hwes = get_used_hwes(pathvec);
+
+		dump_config(conf, hwes, curmp);
+		vector_free(hwes);
+		goto out;
+	}
 
 	if (cmd == CMD_VALID_PATH) {
 		struct path *pp;
@@ -750,19 +771,6 @@ out:
 	return r;
 }
 
-static int
-dump_config (struct config *conf)
-{
-	char * reply = snprint_config(conf, NULL, NULL, NULL);
-
-	if (reply != NULL) {
-		printf("%s", reply);
-		FREE(reply);
-		return 0;
-	} else
-		return 1;
-}
-
 static int
 get_dev_type(char *dev) {
 	struct stat buf;
@@ -858,7 +866,7 @@ main (int argc, char *argv[])
 		exit(1);
 	multipath_conf = conf;
 	conf->retrigger_tries = 0;
-	while ((arg = getopt(argc, argv, ":adcChl::FfM:v:p:b:BrR:itquUwW")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":adcChl::FfM:v:p:b:BrR:itTquUwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -923,8 +931,11 @@ main (int argc, char *argv[])
 			conf->find_multipaths |= _FIND_MULTIPATHS_I;
 			break;
 		case 't':
-			r = dump_config(conf);
+			r = dump_config(conf, NULL, NULL);
 			goto out_free_config;
+		case 'T':
+			cmd = CMD_DUMP_CONFIG;
+			break;
 		case 'h':
 			usage(argv[0]);
 			exit(0);
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index 914a8cb2..b5e5292f 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -25,7 +25,7 @@ multipath \- Device mapper target autoconfig.
 .RB [\| \-b\ \c
 .IR bindings_file \|]
 .RB [\| \-d \|]
-.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-C | \-q | \-r | \-i | \-a | \-u | \-U | \-w | \-W \|]
+.RB [\| \-h | \-l | \-ll | \-f | \-t | \-T | \-F | \-B | \-c | \-C | \-q | \-r | \-i | \-a | \-u | \-U | \-w | \-W \|]
 .RB [\| \-p\ \c
 .IR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| \-R\ \c
@@ -89,6 +89,12 @@ Flush all unused multipath device maps.
 Display the currently used multipathd configuration.
 .
 .TP
+.B \-T
+Display the currently used multipathd configuration, limiting the output to
+those devices actually present in the system. This can be used a template for
+creating \fImultipath.conf\fR.
+.
+.TP
 .B \-r
 Force devmap reload.
 .
-- 
2.17.0
