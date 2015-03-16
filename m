From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 46/78] Implement 'uxsock_timeout' keyword
Date: Mon, 16 Mar 2015 13:36:33 +0100
Message-ID: <1426509425-15978-47-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On larger systems the default CLI receive timeout of 1 second
might be too small, and the CLI commands might fail before
they can be processed. For these cases I've implemented a new
keywork 'uxsock_timeout' which can be increased to avoid these
issues.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.c      |  1 +
 libmultipath/config.h      |  1 +
 libmultipath/configure.c   |  2 +-
 libmultipath/dict.c        | 30 ++++++++++++++++++++++++++++++
 multipath/multipath.conf.5 |  9 +++++++++
 multipathd/main.c          |  8 ++++++--
 6 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 1007f32..c788cf6 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -617,6 +617,7 @@ load_config (char * file, struct udev *udev)
 	conf->partition_delim = NULL;
 	conf->processed_main_config = 0;
 	conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
+	conf->uxsock_timeout = DEFAULT_UXSOCK_TIMEOUT;
 	conf->uid_attribute = set_default(DEFAULT_UID_ATTRIBUTE);
 
 	/*
diff --git a/libmultipath/config.h b/libmultipath/config.h
index eff127e..0149ad3 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -135,6 +135,7 @@ struct config {
 	int processed_main_config;
 	int delay_watch_checks;
 	int delay_wait_checks;
+	int uxsock_timeout;
 	unsigned int version[3];
 
 	char * dev;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 720d074..2c10c22 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -714,7 +714,7 @@ int check_daemon(void)
 
 	if (send_packet(fd, "show daemon", 12) != 0)
 		goto out;
-	if (recv_packet(fd, &reply, &len, DEFAULT_UXSOCK_TIMEOUT) != 0)
+	if (recv_packet(fd, &reply, &len, conf->uxsock_timeout) != 0)
 		goto out;
 
 	if (strstr(reply, "shutdown"))
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 35a1cf2..5c2da43 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1034,6 +1034,26 @@ declare_hw_snprint(delay_wait_checks, print_delay_checks)
 declare_mp_handler(delay_wait_checks, set_delay_checks)
 declare_mp_snprint(delay_wait_checks, print_delay_checks)
 
+static int
+def_uxsock_timeout_handler(vector strvec)
+{
+	unsigned int uxsock_timeout;
+	char *buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (sscanf(buff, "%u", &uxsock_timeout) == 1 &&
+	    uxsock_timeout > DEFAULT_UXSOCK_TIMEOUT)
+		conf->uxsock_timeout = uxsock_timeout;
+	else
+		conf->uxsock_timeout = DEFAULT_UXSOCK_TIMEOUT;
+
+	free(buff);
+	return 0;
+}
+
 /*
  * blacklist block handlers
  */
@@ -1115,6 +1135,15 @@ declare_ble_handler(blist_property)
 declare_ble_handler(elist_property)
 
 static int
+snprint_def_uxsock_timeout(char * buff, int len, void * data)
+{
+	if (conf->uxsock_timeout == DEFAULT_UXSOCK_TIMEOUT)
+		return 0;
+
+	return snprintf(buff, len, "%u", conf->uxsock_timeout);
+}
+
+static int
 snprint_ble_simple (char * buff, int len, void * data)
 {
 	struct blentry * ble = (struct blentry *)data;
@@ -1335,6 +1364,7 @@ init_keywords(void)
 	install_keyword("delay_watch_checks", &def_delay_watch_checks_handler, &snprint_def_delay_watch_checks);
 	install_keyword("delay_wait_checks", &def_delay_wait_checks_handler, &snprint_def_delay_wait_checks);
 	install_keyword("find_multipaths", &def_find_multipaths_handler, &snprint_def_find_multipaths);
+	install_keyword("uxsock_timeout", &def_uxsock_timeout_handler, &snprint_def_uxsock_timeout);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index d60dc2e..7e17f62 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -480,6 +480,15 @@ used until it has passed
 .I delay_wait_checks
 checks. Default is
 .I no
+.TP
+.B uxsock_timeout
+CLI receive timeout in milliseconds. For larger systems CLI commands
+might timeout before the multipathd lock is released and the CLI command
+can be processed. This will result in errors like
+'timeout receiving packet' to be returned from CLI commands.
+In these cases it is recommended to increase the CLI timeout to avoid
+those issues. The default is
+.I 1000
 .
 .SH "blacklist section"
 The
diff --git a/multipathd/main.c b/multipathd/main.c
index 9db2e55..e197d59 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2023,7 +2023,9 @@ main (int argc, char *argv[])
 			logsink = -1;
 			break;
 		case 'k':
-			uxclnt(optarg, DEFAULT_UXSOCK_TIMEOUT);
+			if (load_config(DEFAULT_CONFIGFILE, udev_new()))
+				exit(1);
+			uxclnt(optarg, conf->uxsock_timeout);
 			exit(0);
 		case 'B':
 			conf->bindings_read_only = 1;
@@ -2037,6 +2039,8 @@ main (int argc, char *argv[])
 		char * s = cmd;
 		char * c = s;
 
+		if (load_config(DEFAULT_CONFIGFILE, udev_new()))
+			exit(1);
 		while (optind < argc) {
 			if (strchr(argv[optind], ' '))
 				c += snprintf(c, s + CMDSIZE - c, "\"%s\" ", argv[optind]);
@@ -2045,7 +2049,7 @@ main (int argc, char *argv[])
 			optind++;
 		}
 		c += snprintf(c, s + CMDSIZE - c, "\n");
-		uxclnt(s, DEFAULT_UXSOCK_TIMEOUT);
+		uxclnt(s, conf->uxsock_timeout);
 		exit(0);
 	}
 
-- 
1.8.4.5
