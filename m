From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/6] multipath: tweak logging style
Date: Wed, 10 Oct 2018 13:01:08 -0500
Message-ID: <1539194473-6243-2-git-send-email-bmarzins@redhat.com>
References: <1539194473-6243-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539194473-6243-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

When multipathd commands are run, errors should be printed to stderr,
instead of syslog. Also, when the multipath is run and calls
device-mapper, device-mapper should log to stderr instead of stdout,
just like multipath does now.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 8 ++++----
 multipathd/main.c        | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 8136d15..0433b49 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -80,11 +80,11 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
 			strftime(buff, sizeof(buff), "%b %d %H:%M:%S", tb);
 			buff[sizeof(buff)-1] = '\0';
 
-			fprintf(stdout, "%s | ", buff);
+			fprintf(stderr, "%s | ", buff);
 		}
-		fprintf(stdout, "libdevmapper: %s(%i): ", file, line);
-		vfprintf(stdout, f, ap);
-		fprintf(stdout, "\n");
+		fprintf(stderr, "libdevmapper: %s(%i): ", file, line);
+		vfprintf(stderr, f, ap);
+		fprintf(stderr, "\n");
 	} else {
 		condlog(level, "libdevmapper: %s(%i): ", file, line);
 		log_safe(level + 3, f, ap);
diff --git a/multipathd/main.c b/multipathd/main.c
index af33239..5f0193b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2984,6 +2984,7 @@ main (int argc, char *argv[])
 			logsink = -1;
 			break;
 		case 'k':
+			logsink = 0;
 			conf = load_config(DEFAULT_CONFIGFILE);
 			if (!conf)
 				exit(1);
@@ -3013,6 +3014,7 @@ main (int argc, char *argv[])
 		char * s = cmd;
 		char * c = s;
 
+		logsink = 0;
 		conf = load_config(DEFAULT_CONFIGFILE);
 		if (!conf)
 			exit(1);
-- 
2.7.4
