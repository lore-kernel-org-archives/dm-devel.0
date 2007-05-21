From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 8/21] [multipath] add '-t' option to dump
	internal hwtable
Date: Mon, 21 May 2007 11:23:44 +0200
Message-ID: <20070521092344.8F1DBD44CB@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


This patch adds an option '-t' to dump the internal hardware table.
Quite handy if you want to know the default settings.
In doing so it also fixes the keyword allocation; currently the
keywords are only initialised if a configuration file is used.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.c |    5 +++-
 libmultipath/parser.c |   15 +++++++++---
 libmultipath/parser.h |    1 +
 libmultipath/print.c  |    2 +-
 multipath/main.c      |   57 +++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 72 insertions(+), 8 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index a39af8a..1dfc18c 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -366,12 +366,15 @@ load_config (char * file)
 	/*
 	 * read the config file
 	 */
+	set_current_keywords(&conf->keywords);
+	alloc_keywords();
 	if (filepresent(file)) {
-		set_current_keywords(&conf->keywords);
 		if (init_data(file, init_keywords)) {
 			condlog(0, "error parsing config file");
 			goto out;
 		}
+	} else {
+	    init_keywords();
 	}
 	
 	/*
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index f9c555e..5302970 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -455,16 +455,23 @@ process_stream(vector keywords)
 	return r;
 }
 
+int alloc_keywords(void)
+{
+	if (!keywords)
+		keywords = vector_alloc();
+
+	if (!keywords)
+		return 1;
+
+	return 0;
+}
+
 /* Data initialization */
 int
 init_data(char *conf_file, void (*init_keywords) (void))
 {
 	int r;
 
-	if (!keywords)
-		keywords = vector_alloc();
-	if (!keywords)
-		return 1;
 	stream = fopen(conf_file, "r");
 	if (!stream) {
 		syslog(LOG_WARNING, "Configuration file open problem");
diff --git a/libmultipath/parser.h b/libmultipath/parser.h
index 95d4e6f..8496684 100644
--- a/libmultipath/parser.h
+++ b/libmultipath/parser.h
@@ -74,6 +74,7 @@ extern vector read_value_block(void);
 extern int alloc_value_block(vector strvec, void (*alloc_func) (vector));
 extern void *set_value(vector strvec);
 extern int process_stream(vector keywords);
+extern int alloc_keywords(void);
 extern int init_data(char *conf_file, void (*init_keywords) (void));
 extern struct keyword * find_keyword(vector v, char * name);
 void set_current_keywords (vector *k);
diff --git a/libmultipath/print.c b/libmultipath/print.c
index e50f37d..dc8af48 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -734,7 +734,7 @@ snprint_hwentry (char * buff, int len, s
 	if (fwd > len)
 		return len;
 	iterate_sub_keywords(rootkw, kw, i) {
-		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
+		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k \"%v\"\n",
 				kw, hwe);
 		if (fwd > len)
 			return len;
diff --git a/multipath/main.c b/multipath/main.c
index acc3137..c3d0dac 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -72,7 +72,7 @@ static void
 usage (char * progname)
 {
 	fprintf (stderr, VERSION_STRING);
-	fprintf (stderr, "Usage: %s\t[-v level] [-d] [-h|-l|-ll|-f|-F]\n",
+	fprintf (stderr, "Usage: %s\t[-v level] [-d] [-h|-l|-ll|-f|-F|-t]\n",
 		progname);
 	fprintf (stderr,
 		"\t\t\t[-p failover|multibus|group_by_serial|group_by_prio]\n" \
@@ -90,6 +90,7 @@ usage (char * progname)
 		"\t-ll\t\tshow multipath topology (maximum info)\n" \
 		"\t-f\t\tflush a multipath device map\n" \
 		"\t-F\t\tflush all multipath device maps\n" \
+		"\t-t\t\tprint internal hardware table\n" \
 		"\t-p policy\tforce all maps to specified policy :\n" \
 		"\t   failover\t\t1 path per priority group\n" \
 		"\t   multibus\t\tall paths in 1 priority group\n" \
@@ -307,6 +308,55 @@ out:
 	return r;
 }
 
+static int
+dump_config (void)
+{
+	char * c;
+	char * reply;
+	unsigned int maxlen = 256;
+	int again = 1;
+
+	reply = MALLOC(maxlen);
+
+	while (again) {
+		if (!reply)
+			return 1;
+		c = reply;
+		c += snprint_defaults(c, reply + maxlen - c);
+		again = ((c - reply) == maxlen);
+		if (again) {
+			reply = REALLOC(reply, maxlen *= 2);
+			continue;
+		}
+		c += snprint_blacklist(c, reply + maxlen - c);
+		again = ((c - reply) == maxlen);
+		if (again) {
+			reply = REALLOC(reply, maxlen *= 2);
+			continue;
+		}
+		c += snprint_blacklist_except(c, reply + maxlen - c);
+		again = ((c - reply) == maxlen);
+		if (again) {
+			reply = REALLOC(reply, maxlen *= 2);
+			continue;
+		}
+		c += snprint_hwtable(c, reply + maxlen - c, conf->hwtable);
+		again = ((c - reply) == maxlen);
+		if (again) {
+			reply = REALLOC(reply, maxlen *= 2);
+			continue;
+		}
+		c += snprint_mptable(c, reply + maxlen - c, conf->mptable);
+		again = ((c - reply) == maxlen);
+		if (again)
+			reply = REALLOC(reply, maxlen *= 2);
+	}
+
+	printf("%s", reply);
+	FREE(reply);
+	return 0;
+}
+
 int
 main (int argc, char *argv[])
 {
@@ -330,7 +380,7 @@ main (int argc, char *argv[])
 	if (load_config(DEFAULT_CONFIGFILE))
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:t")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -373,6 +423,9 @@ main (int argc, char *argv[])
 				usage(argv[0]);
 			}                
 			break;
+		case 't':
+			dump_config();
+			goto out;
 		case 'h':
 			usage(argv[0]);
 		case ':':
-- 
1.4.3.4
