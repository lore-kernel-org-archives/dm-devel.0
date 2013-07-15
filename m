From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/29] Correctly set pgfailback
Date: Mon, 15 Jul 2013 15:00:20 +0200
Message-ID: <1373893230-26077-20-git-send-email-hare@suse.de>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373893230-26077-1-git-send-email-hare@suse.de>
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

Something weird happened to pgfailback; no default was assigned
when loading the configuration, but then it got set (wrongly)
to the default value when printing the configuration.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.c |    1 +
 libmultipath/dict.c   |   16 +++++-----------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index cc44244..8013a07 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -556,6 +556,7 @@ load_config (char * file, struct udev *udev)
 	conf->reassign_maps = DEFAULT_REASSIGN_MAPS;
 	conf->checkint = DEFAULT_CHECKINT;
 	conf->max_checkint = MAX_CHECKINT(conf->checkint);
+	conf->pgfailback = DEFAULT_FAILBACK;
 	conf->fast_io_fail = DEFAULT_FAST_IO_FAIL;
 	conf->retain_hwhandler = DEFAULT_RETAIN_HWHANDLER;
 	conf->detect_prio = DEFAULT_DETECT_PRIO;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 4b840de..0408e03 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1869,12 +1869,11 @@ snprint_mp_failback (char * buff, int len, void * data)
 {
 	struct mpentry * mpe = (struct mpentry *)data;
 
-	if (!mpe->pgfailback)
+	if (mpe->pgfailback == FAILBACK_UNDEF ||
+	    mpe->pgfailback == DEFAULT_FAILBACK)
 		return 0;
 
 	switch(mpe->pgfailback) {
-	case  FAILBACK_UNDEF:
-		break;
 	case -FAILBACK_MANUAL:
 		return snprintf(buff, len, "\"manual\"");
 	case -FAILBACK_IMMEDIATE:
@@ -2247,12 +2246,11 @@ snprint_hw_failback (char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
 
-	if (!hwe->pgfailback)
+	if (hwe->pgfailback == FAILBACK_UNDEF ||
+	    hwe->pgfailback == DEFAULT_FAILBACK)
 		return 0;
 
 	switch(hwe->pgfailback) {
-	case  FAILBACK_UNDEF:
-		break;
 	case -FAILBACK_MANUAL:
 		return snprintf(buff, len, "\"manual\"");
 	case -FAILBACK_IMMEDIATE:
@@ -2534,13 +2532,9 @@ snprint_def_path_checker (char * buff, int len, void * data)
 static int
 snprint_def_failback (char * buff, int len, void * data)
 {
-	int pgfailback = conf->pgfailback;
-	if (!pgfailback)
-		pgfailback = DEFAULT_FAILBACK;
-
 	switch(conf->pgfailback) {
 	case  FAILBACK_UNDEF:
-		break;
+		return snprintf(buff, len, "\"undef\"");
 	case -FAILBACK_MANUAL:
 		return snprintf(buff, len, "\"manual\"");
 	case -FAILBACK_IMMEDIATE:
-- 
1.7.10.4
