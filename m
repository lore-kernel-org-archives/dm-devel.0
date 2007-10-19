From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 19 Oct 2007 21:41:57 -0000
Message-ID: <20071019214157.18801.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2007-10-19 21:41:56

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.defaults 
	kpartx         : kpartx.c 

Log message:
	clarified config files. added fix for bz 320101. kpartx now has a config file,
	/etc/kpartx.conf. This lets it choose whether to always use 'p' as the
	delimiter, or to use the default method, where 'p' is only used if the last
	character is a number.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.1&r2=1.16.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.7&r2=1.5.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/kpartx.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.7.2.1&r2=1.7.2.2

--- multipath-tools/multipath.conf.annotated	2007/10/11 20:17:17	1.16.2.1
+++ multipath-tools/multipath.conf.annotated	2007/10/19 21:41:56	1.16.2.2
@@ -144,14 +144,14 @@
 #}
 #	
 ##
-## name    : blacklist
+## name    : devnode_blacklist 
 ## scope   : multipath & multipathd
 ## desc    : list of device names to discard as not multipath candidates.
 ##           Devices can identified by either their device node name "devnode"
 ##           or their WWID "wwid".
 ## default : cciss, fd, hd, md, dm, sr, scd, st, ram, raw, loop
 ##
-#blacklist {
+#devnode_blacklist {
 #       wwid 26353900f02796769
 #	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
 #	devnode "^hd[a-z]"
--- multipath-tools/multipath.conf.defaults	2007/10/11 20:17:17	1.5.2.7
+++ multipath-tools/multipath.conf.defaults	2007/10/19 21:41:56	1.5.2.8
@@ -14,10 +14,10 @@
 #	failback		immediate
 #	no_path_retry		fail
 #	user_friendly_names	no
-#	bindings_file		/var/lib/multipath/bindings
+#	bindings_file		"/var/lib/multipath/bindings"
 #}
 #
-#blacklist {
+#devnode_blacklist {
 #       devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
 #       devnode "^hd[a-z]"
 #}
--- multipath-tools/kpartx/kpartx.c	2006/09/19 21:06:40	1.7.2.1
+++ multipath-tools/kpartx/kpartx.c	2007/10/19 21:41:56	1.7.2.2
@@ -46,6 +46,8 @@
 #define PARTNAME_SIZE	128
 #define DELIM_SIZE	8
 
+#define DEFAULT_CONFIG_FILE "/etc/kpartx.conf"
+
 struct slice slices[MAXSLICES];
 
 enum action { LIST, ADD, DELETE };
@@ -179,6 +181,89 @@
 	return device;
 }
 
+
+char *
+strip_string(char *str, int remove_quotes)
+{
+	char *c;
+
+	while (isspace(*str) || !isascii(*str))
+		str++;
+	if (*str == '\0')
+		return str;
+	if (*str == '"' && remove_quotes){
+		str++;
+		c = str;
+		while (*c != '"' && *c != '\0') {
+			*c = tolower(*c);
+			c++;
+		}
+	} else {
+		c = str;
+		while (isascii(*c) && !isspace(*c)){
+			*c = tolower(*c);
+			c++;
+		}
+	}
+	*c = '\0';
+	return str;
+}
+	
+
+void
+read_config_file(char *config_file, char **delim)
+{
+	char buf[LINE_MAX];
+	struct stat s;
+	FILE *f;
+
+	if (*delim != NULL)
+		return;
+
+	if (stat(config_file, &s) != 0) {
+		if (errno != ENOENT)
+			fprintf(stderr, "Can't stat '%s' (%s). skipping\n",
+				config_file, strerror(errno));
+		return;
+	}
+ 	if (!S_ISREG(s.st_mode)) {
+		fprintf(stderr, "'%s' is not a regular file. skipping\n",
+			config_file);
+		return;
+	}
+	if (s.st_size == 0)
+		return;
+	f = fopen(config_file, "r");
+	if (!f) {
+		fprintf(stderr, "cannot open bindings file '%s' (%s). "
+			"skipping\n", config_file, strerror(errno));
+		return;
+	}
+	while (fgets(buf, LINE_MAX, f)) {
+		char *c, *value;
+
+		c = strpbrk(buf, "#\n\r");
+		if (c)
+			*c = '\0';
+		c = strchr(buf, '=');
+		if (c){
+			*c = '\0';
+			value = c + 1;
+		}
+		else
+			continue;
+		if (strcmp("consistent_suffix", strip_string(buf, 0)) != 0)
+			continue;
+		value = strip_string(value, 1);
+		if (strcmp(value, "y") == 0 || strcmp(value, "yes") == 0){
+			*delim = "p";
+			goto exit;
+		}
+	}
+exit:			
+	fclose(f);
+}
+
 int
 main(int argc, char **argv){
         int fd, i, j, k, n, op, off, arg;
@@ -195,6 +280,7 @@
 	int loopro = 0;
 	int hotplug = 0;
 	struct stat buf;
+	char *config_file = DEFAULT_CONFIG_FILE;
 
 	initpts();
 	init_crc32();
@@ -266,6 +352,8 @@
 		exit(1);
 	}
 
+	read_config_file(config_file, &delim);
+
 	if (hotplug) {
 		/* already got [disk]device */
 	} else if (optind == argc-2) {
