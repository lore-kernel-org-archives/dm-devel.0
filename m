From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/3] multipathd: ignore "disable_changed_wwids"
Date: Mon, 18 Mar 2019 13:12:35 +0100
Message-ID: <20190318121235.8942-4-mwilck@suse.com>
References: <20190318121235.8942-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190318121235.8942-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This option has no effect any more.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c      |  1 -
 libmultipath/config.h      |  1 -
 libmultipath/dict.c        | 18 +++++++++++++++---
 multipath/multipath.conf.5 |  8 ++------
 4 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 24d71aed..141f092b 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -715,7 +715,6 @@ load_config (char * file)
 	conf->retrigger_tries = DEFAULT_RETRIGGER_TRIES;
 	conf->retrigger_delay = DEFAULT_RETRIGGER_DELAY;
 	conf->uev_wait_timeout = DEFAULT_UEV_WAIT_TIMEOUT;
-	conf->disable_changed_wwids = DEFAULT_DISABLE_CHANGED_WWIDS;
 	conf->remove_retries = 0;
 	conf->ghost_delay = DEFAULT_GHOST_DELAY;
 	conf->all_tg_pt = DEFAULT_ALL_TG_PT;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index b938c26c..f5bf5b1b 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -182,7 +182,6 @@ struct config {
 	int delayed_reconfig;
 	int uev_wait_timeout;
 	int skip_kpartx;
-	int disable_changed_wwids;
 	int remove_retries;
 	int max_sectors_kb;
 	int ghost_delay;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index eaad4f18..96815f8a 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -156,6 +156,12 @@ out:
 	return len;
 }
 
+static int
+print_ignored (char *buff, int len)
+{
+	return snprintf(buff, len, "ignored");
+}
+
 static int
 print_yes_no (char *buff, int len, long v)
 {
@@ -548,9 +554,15 @@ declare_hw_handler(skip_kpartx, set_yes_no_undef)
 declare_hw_snprint(skip_kpartx, print_yes_no_undef)
 declare_mp_handler(skip_kpartx, set_yes_no_undef)
 declare_mp_snprint(skip_kpartx, print_yes_no_undef)
-
-declare_def_handler(disable_changed_wwids, set_yes_no)
-declare_def_snprint(disable_changed_wwids, print_yes_no)
+static int def_disable_changed_wwids_handler(struct config *conf, vector strvec)
+{
+	return 0;
+}
+static int snprint_def_disable_changed_wwids(struct config *conf, char *buff,
+					     int len, const void *data)
+{
+	return print_ignored(buff, len);
+}
 
 declare_def_handler(remove_retries, set_int)
 declare_def_snprint(remove_retries, print_int)
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 0fe8461d..a2e3e866 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1148,12 +1148,8 @@ The default is: \fBno\fR
 .
 .TP
 .B disable_changed_wwids
-If set to \fIyes\fR, multipathd will check the path wwid on change events, and
-if it has changed from the wwid of the multipath device, multipathd will
-disable access to the path until the wwid changes back.
-.RS
-.TP
-The default is: \fBno\fR
+This option is deprecated and ignored. If the WWID of a path suddenly changes,
+multipathd handles it as if it was removed and then added again.
 .RE
 .
 .
-- 
2.21.0
