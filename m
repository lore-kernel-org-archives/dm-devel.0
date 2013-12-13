From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/11] Reset timezone information on reconfigure
Date: Fri, 13 Dec 2013 13:14:11 +0100
Message-ID: <1386936854-8399-9-git-send-email-hare@suse.de>
References: <1386936854-8399-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386936854-8399-1-git-send-email-hare@suse.de>
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
List-Id: dm-devel.ids

Whenever 'reconfigure' is called we need to re-initialize the
timezone information as it might have been changed in the
meantime.

References: bnc#830511

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/log.c | 1 +
 multipathd/main.c  | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/libmultipath/log.c b/libmultipath/log.c
index 37c7cd7..74702d8 100644
--- a/libmultipath/log.c
+++ b/libmultipath/log.c
@@ -99,6 +99,7 @@ void log_close (void)
 void log_reset (char *program_name)
 {
 	closelog();
+	tzset();
 	openlog(program_name, 0, LOG_DAEMON);
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 96564f8..1a1aa2d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1416,6 +1416,9 @@ reconfigure (struct vectors * vecs)
 	vecs->pathvec = NULL;
 	conf = NULL;
 
+	/* Re-read any timezone changes */
+	tzset();
+
 	if (!load_config(DEFAULT_CONFIGFILE, udev)) {
 		conf->verbosity = old->verbosity;
 		conf->daemon = 1;
-- 
1.8.1.4
