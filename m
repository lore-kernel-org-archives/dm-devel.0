From: Patrick Caulfield <pcaulfie@redhat.com>
Subject: [PATCH] [RFC] persistent readable names
Date: Wed, 05 Oct 2005 15:14:52 +0100
Message-ID: <4343DFDC.2020701@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000400080900060901000701"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000400080900060901000701
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch is more for discussion than inclusion at the moment. Basically it's
unrealistic for users with hundreds of disks to alias them all in
/etc/multipath.conf and the default names are very unwieldy.

What this patch does is attach a name to any un-aliased path and write that name
to /etc/multipath.names. The file is read again every time the paths are added
so they are persistent.

There are a small number of possibly contentious things:
- the multipath.names file is in a different format from the config file. It's
easier to parse this one and it's not meant to be human editable really. Also
extending the existing parser to cope with the ability to read bits for the same
MPE from more than one place looked hard :)

- The names file is held in /etc which may not be available if multipath is run
from an initrd - though it does fail silently if it can't be written.

The feature is selected with

defaults {
   autonames 1
}

in the config file, and the names can be formatted with

defaults {
   autoname_prefix "multipath%d"
}
-- 

patrick

--------------000400080900060901000701
Content-Type: text/x-patch;
 name="mpauto.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mpauto.patch"

diff -rwup multipath-tools-0.4.5/libmultipath/config.c multipath-tools-0.4.5.new/libmultipath/config.c
--- multipath-tools-0.4.5/libmultipath/config.c	2005-09-02 14:14:18.000000000 +0100
+++ multipath-tools-0.4.5.new/libmultipath/config.c	2005-10-05 13:39:33.000000000 +0100
@@ -330,6 +330,9 @@ free_config (struct config * conf)
 	if (conf->default_hwhandler)
 		FREE(conf->default_hwhandler);
 
+	if (conf->autoname_prefix)
+		FREE(conf->autoname_prefix);
+
 	free_blacklist(conf->blist);
 	free_mptable(conf->mptable);
 	free_hwtable(conf->hwtable);
@@ -407,6 +410,9 @@ load_config (char * file)
 	if (conf->default_hwhandler == NULL)
 		conf->default_hwhandler = set_default(DEFAULT_HWHANDLER);
 
+	if (conf->autoname_prefix == NULL)
+		conf->autoname_prefix = set_default(DEFAULT_AUTONAME_PREFIX);
+
 	if (!conf->default_selector  || !conf->udev_dir         ||
 	    !conf->default_getuid    || !conf->default_features ||
 	    !conf->default_hwhandler)
diff -rwup multipath-tools-0.4.5/libmultipath/config.h multipath-tools-0.4.5.new/libmultipath/config.h
--- multipath-tools-0.4.5/libmultipath/config.h	2005-09-02 14:14:18.000000000 +0100
+++ multipath-tools-0.4.5.new/libmultipath/config.h	2005-10-05 13:39:33.000000000 +0100
@@ -55,6 +55,7 @@ struct config {
 	int pgfailback;
 	int remove;
 	int rr_weight;
+	int autoname;
 
 	char * dev;
 	char * multipath;
@@ -64,6 +65,7 @@ struct config {
 	char * default_getprio;
 	char * default_features;
 	char * default_hwhandler;
+	char * autoname_prefix;
 
 	vector mptable;
 	vector hwtable;
diff -rwup multipath-tools-0.4.5/libmultipath/defaults.h multipath-tools-0.4.5.new/libmultipath/defaults.h
--- multipath-tools-0.4.5/libmultipath/defaults.h	2005-09-02 14:14:18.000000000 +0100
+++ multipath-tools-0.4.5.new/libmultipath/defaults.h	2005-10-05 13:39:33.000000000 +0100
@@ -9,5 +9,7 @@
 #define DEFAULT_PIDFILE		"/var/run/multipathd.pid"
 #define DEFAULT_SOCKET		"/var/run/multipathd.sock"
 #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
+#define DEFAULT_NAMEFILE	"/etc/multipath.names"
+#define DEFAULT_AUTONAME_PREFIX "multipath%d"
 
 char * set_default (char * str);
diff -rwup multipath-tools-0.4.5/libmultipath/dict.c multipath-tools-0.4.5.new/libmultipath/dict.c
--- multipath-tools-0.4.5/libmultipath/dict.c	2005-09-02 14:14:18.000000000 +0100
+++ multipath-tools-0.4.5.new/libmultipath/dict.c	2005-10-05 14:27:52.000000000 +0100
@@ -102,6 +102,17 @@ def_prio_callout_handler(vector strvec)
 }
 
 static int
+def_autoname_prefix_handler(vector strvec)
+{
+        conf->autoname_prefix = set_value(strvec);
+
+        if (!conf->autoname_prefix)
+                return 1;
+
+        return 0;
+}
+
+static int
 def_features_handler(vector strvec)
 {
 	conf->default_features = set_value(strvec);
@@ -129,6 +140,23 @@ def_minio_handler(vector strvec)
 }
 
 static int
+def_autoname_handler(vector strvec)
+{
+        char * buff;
+
+        buff = set_value(strvec);
+
+        if (!buff)
+                return 1; 
+
+        conf->autoname = atoi(buff);
+        FREE(buff);                                             
+                                                                
+        return 0;
+}
+
+
+static int
 def_weight_handler(vector strvec)
 {
 	char * buff;
@@ -590,6 +618,8 @@ init_keywords(void)
 	install_keyword("default_features", &def_features_handler);
 	install_keyword("failback", &default_failback_handler);
 	install_keyword("rr_min_io", &def_minio_handler);
+	install_keyword("autoname", &def_autoname_handler);
+	install_keyword("autoname_prefix", &def_autoname_prefix_handler);
 	install_keyword("rr_weight", &def_weight_handler);
 	
 	install_keyword_root("devnode_blacklist", &blacklist_handler);
diff -rwup multipath-tools-0.4.5/multipath/main.c multipath-tools-0.4.5.new/multipath/main.c
--- multipath-tools-0.4.5/multipath/main.c	2005-10-05 14:22:06.000000000 +0100
+++ multipath-tools-0.4.5.new/multipath/main.c	2005-10-05 13:56:40.000000000 +0100
@@ -642,6 +642,42 @@ domap (struct multipath * mpp)
 	return r;
 }
 
+
+static void
+autoname_mpp(struct multipath *mpp)
+{
+	int i;
+	struct mpentry *mpe;
+	FILE *namefile;
+	static int highest = 0;
+
+/* Look through the list of multipaths and look for the next highest autoname number.
+   We then assign that to the passed-in mpp and add it to the multipath.names file */
+
+	/* Only need to scan it once */
+	if (!highest) {
+		vector_foreach_slot (conf->mptable, mpe, i) {
+
+			int thisnum;
+
+			if (mpe->alias && sscanf(mpe->alias, conf->autoname_prefix, &thisnum) == 1)
+				if (thisnum > highest)
+					highest = thisnum;
+		}
+	}
+	highest++;
+	mpp->alias = MALLOC(strlen(conf->autoname_prefix)+10);
+	sprintf(mpp->alias, conf->autoname_prefix, highest);
+
+	/* Add an entry to the names file */
+	namefile = fopen(DEFAULT_NAMEFILE, "a");
+	if (!namefile) {
+		return;
+	}
+	fprintf(namefile, "%s\t%s\n", mpp->wwid, mpp->alias);
+	fclose(namefile);
+}
+
 static int
 coalesce_paths (vector curmp, vector pathvec)
 {
@@ -681,6 +717,8 @@ coalesce_paths (vector curmp, vector pat
 		strcpy(mpp->wwid, pp1->wwid);
 		mpp->size = pp1->size;
 		mpp->paths = vector_alloc();
+		if ((!mpp->alias || mpp->alias == mpp->wwid) && conf->autoname)
+			autoname_mpp(mpp);
 
 		if (pp1->priority < 0)
 			mpp->action = ACT_NOTHING;
@@ -839,6 +877,61 @@ get_dm_mpvec (vector curmp, vector pathv
 	return 0;
 }
 
+static void
+load_autonames(char *fname)
+{
+	char buf[1024];
+	char *alias;
+	int i;
+	struct mpentry *mpe;
+
+	stream = fopen(fname, "r");
+	if (!stream)
+		return; /* File is optional */
+
+	while (read_line(buf, sizeof(buf))) {
+		alias = strchr(buf, '\t');
+		if (!alias)
+			continue;
+		*alias = '\0';
+		alias++;
+
+		/* Look for the WWID and store its autogenerated alias */
+		vector_foreach_slot (conf->mptable, mpe, i) {
+			if (!strcmp(mpe->wwid, buf)) {
+				if (!mpe->alias || mpe->alias == mpe->wwid) {
+					mpe->alias = MALLOC(strlen(alias)+1);
+					if (mpe->alias)
+						strcpy(mpe->alias, alias);
+					break; /* back to read_line loop */
+				}
+			}
+		}
+		/* no mpentry found - need to create one */
+		mpe = alloc_mpe();
+		if (!vector_alloc_slot(conf->mptable)) {
+			FREE(mpe);
+			return;
+		}
+		mpe->wwid = MALLOC(strlen(buf)+1);
+		if (!mpe->wwid) {
+			FREE(mpe);
+			return;
+		}
+		mpe->alias = MALLOC(strlen(alias)+1);
+		if (!mpe->alias) {
+			FREE(mpe->wwid);
+			FREE(mpe);
+			return;
+		}
+		strcpy(mpe->wwid, buf);
+		strcpy(mpe->alias, alias);
+		vector_set_slot(conf->mptable, mpe);
+        }
+
+	fclose(stream);
+}
+
 int
 main (int argc, char *argv[])
 {
@@ -1006,7 +1099,10 @@ main (int argc, char *argv[])
 	if (conf->list)
 		goto out;
 
+	/* This has auto-named paths in it */
+	load_autonames(DEFAULT_NAMEFILE); 
+
 	/*
 	 * core logic entry point
 	 */
 

--------------000400080900060901000701
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000400080900060901000701--
