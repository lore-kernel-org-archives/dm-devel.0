From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 06/16] libmultipath: let ignore_wwids be set
	in config file
Date: Fri, 19 Jan 2018 01:29:06 +0100
Message-ID: <20180119002916.10323-7-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This allows to generalize this option, use it for multipathd as well,
and make sure to use the same logic in both tools.
---
 libmultipath/config.c   | 1 +
 libmultipath/defaults.h | 1 +
 libmultipath/dict.c     | 4 ++++
 3 files changed, 6 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 3d6a24c94fab..436179a87494 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -615,6 +615,7 @@ load_config (char * file)
 	conf->partition_delim = DEFAULT_PARTITION_DELIM;
 	conf->processed_main_config = 0;
 	conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
+	conf->ignore_wwids = DEFAULT_IGNORE_WWIDS;
 	conf->uxsock_timeout = DEFAULT_REPLY_TIMEOUT;
 	conf->retrigger_tries = DEFAULT_RETRIGGER_TRIES;
 	conf->retrigger_delay = DEFAULT_RETRIGGER_DELAY;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index c9e3411aa579..a6a526a10ac3 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -18,6 +18,7 @@
 #define DEFAULT_VERBOSITY	2
 #define DEFAULT_REASSIGN_MAPS	0
 #define DEFAULT_FIND_MULTIPATHS	0
+#define DEFAULT_IGNORE_WWIDS	1
 #define DEFAULT_FAST_IO_FAIL	5
 #define DEFAULT_DEV_LOSS_TMO	600
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index e52f1f798f7a..feab547ad9fc 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -241,6 +241,9 @@ declare_def_snprint(partition_delim, print_str)
 declare_def_handler(find_multipaths, set_yes_no)
 declare_def_snprint(find_multipaths, print_yes_no)
 
+declare_def_handler(ignore_wwids, set_yes_no)
+declare_def_snprint(ignore_wwids, print_yes_no)
+
 declare_def_handler(selector, set_str)
 declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
 declare_hw_handler(selector, set_str)
@@ -1469,6 +1472,7 @@ init_keywords(vector keywords)
 	install_keyword("marginal_path_double_failed_time", &def_marginal_path_double_failed_time_handler, &snprint_def_marginal_path_double_failed_time);
 
 	install_keyword("find_multipaths", &def_find_multipaths_handler, &snprint_def_find_multipaths);
+	install_keyword("ignore_wwids", &def_ignore_wwids_handler, &snprint_def_ignore_wwids);
 	install_keyword("uxsock_timeout", &def_uxsock_timeout_handler, &snprint_def_uxsock_timeout);
 	install_keyword("retrigger_tries", &def_retrigger_tries_handler, &snprint_def_retrigger_tries);
 	install_keyword("retrigger_delay", &def_retrigger_delay_handler, &snprint_def_retrigger_delay);
-- 
2.15.1
