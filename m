From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/13] multipathd: Add option '-s' to suppress
	timestamps
Date: Fri, 15 Nov 2013 11:29:39 +0100
Message-ID: <1384511384-27642-9-git-send-email-hare@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384511384-27642-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

systemd prefixes any messages to stdout with a timestamp, so it's
quite pointless to do it ourself.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/debug.c          | 17 ++++++++++-------
 libmultipath/devmapper.c      | 16 +++++++++-------
 multipathd/main.c             | 11 +++++++----
 multipathd/multipathd.8       |  7 +++++--
 multipathd/multipathd.service |  2 +-
 5 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/libmultipath/debug.c b/libmultipath/debug.c
index d30517d..bad78a8 100644
--- a/libmultipath/debug.c
+++ b/libmultipath/debug.c
@@ -21,15 +21,18 @@ void dlog (int sink, int prio, const char * fmt, ...)
 	thres = (conf) ? conf->verbosity : 0;
 
 	if (prio <= thres) {
-		if (!sink) {
-			time_t t = time(NULL);
-			struct tm *tb = localtime(&t);
-			char buff[16];
+		if (sink < 1) {
+			if (sink == 0) {
+				time_t t = time(NULL);
+				struct tm *tb = localtime(&t);
+				char buff[16];
 
-			strftime(buff, sizeof(buff), "%b %d %H:%M:%S", tb);
-			buff[sizeof(buff)-1] = '\0';
+				strftime(buff, sizeof(buff),
+					 "%b %d %H:%M:%S", tb);
+				buff[sizeof(buff)-1] = '\0';
 
-			fprintf(stdout, "%s | ", buff);
+				fprintf(stdout, "%s | ", buff);
+			}
 			vfprintf(stdout, fmt, ap);
 		}
 		else
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 4c8b923..71281e6 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -71,15 +71,17 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
 		return;
 
 	va_start(ap, f);
-	if (!logsink) {
-		time_t t = time(NULL);
-		struct tm *tb = localtime(&t);
-		char buff[16];
+	if (logsink < 1) {
+		if (logsink == 0) {
+			time_t t = time(NULL);
+			struct tm *tb = localtime(&t);
+			char buff[16];
 
-		strftime(buff, sizeof(buff), "%b %d %H:%M:%S", tb);
-		buff[sizeof(buff)-1] = '\0';
+			strftime(buff, sizeof(buff), "%b %d %H:%M:%S", tb);
+			buff[sizeof(buff)-1] = '\0';
 
-		fprintf(stdout, "%s | ", buff);
+			fprintf(stdout, "%s | ", buff);
+		}
 		fprintf(stdout, "libdevmapper: %s(%i): ", file, line);
 		vfprintf(stdout, f, ap);
 		fprintf(stdout, "\n");
diff --git a/multipathd/main.c b/multipathd/main.c
index b4146fd..72b3740 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1598,7 +1598,7 @@ child (void * param)
 	setup_thread_attr(&uevent_attr, 128 * 1024, 1);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
 
-	if (logsink) {
+	if (logsink == 1) {
 		setup_thread_attr(&log_attr, 64 * 1024, 0);
 		log_thread_start(&log_attr);
 		pthread_attr_destroy(&log_attr);
@@ -1754,7 +1754,7 @@ child (void * param)
 
 	condlog(2, "--------shut down-------");
 
-	if (logsink)
+	if (logsink == 1)
 		log_thread_stop();
 
 	/*
@@ -1854,7 +1854,7 @@ main (int argc, char *argv[])
 	if (!conf)
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":dv:k::")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dsv:k::")) != EOF ) {
 	switch(arg) {
 		case 'd':
 			logsink = 0;
@@ -1867,6 +1867,9 @@ main (int argc, char *argv[])
 
 			conf->verbosity = atoi(optarg);
 			break;
+		case 's':
+			logsink = -1;
+			break;
 		case 'k':
 			uxclnt(optarg);
 			exit(0);
@@ -1891,7 +1894,7 @@ main (int argc, char *argv[])
 		exit(0);
 	}
 
-	if (!logsink)
+	if (logsink < 1)
 		err = 0;
 	else
 		err = daemonize();
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index ccc5f54..2aea150 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -20,8 +20,11 @@ devmap reconfiguration, so that it can refresh its failed path list.
 .SH OPTIONS
 .TP
 .B \-d
-Forground Mode. Don't daemonize, and print all messages to stdout and stderr.
-.TP 
+Foreground Mode. Don't daemonize, and print all messages to stdout and stderr.
+.TP
+.B \-s
+Suppress timestamps. Do not prefix logging messages with a timestamp.
+.TP
 .B -v "level"
 Verbosity level. Print additional information while running multipathd. A  level of 0 means only print errors. A level of 3 or greater prints debugging information as well. 
 .TP
diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index 03b4270..fb84025 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -8,7 +8,7 @@ Conflicts=shutdown.target
 [Service]
 Type=notify
 NotifyAccess=main
-ExecStart=/sbin/multipathd -d
+ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
 
 [Install]
-- 
1.8.1.4
