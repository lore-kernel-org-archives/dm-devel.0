From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/42] Clarify setting origin in propsel.c
Date: Tue,  8 Jan 2013 14:53:53 +0100
Message-ID: <1357653259-62650-16-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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

We should differentiate between config file and internal default.
And the controller settings are not defaults.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/propsel.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index a02a644..b8c6b08 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -282,8 +282,11 @@ select_features (struct multipath * mp)
 	} else if (mp->hwe && mp->hwe->features) {
 		mp->features = STRDUP(mp->hwe->features);
 		origin = "controller setting";
-	} else {
+	} else if (conf->features) {
 		mp->features = STRDUP(conf->features);
+		origin = "config file default";
+	} else {
+		mp->features = set_default(DEFAULT_FEATURES);
 		origin = "internal default";
 	}
 	condlog(3, "%s: features = %s (%s)",
@@ -561,18 +564,22 @@ select_fast_io_fail(struct multipath *mp)
 	if (mp->hwe && mp->hwe->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
 		mp->fast_io_fail = mp->hwe->fast_io_fail;
 		if (mp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
-			condlog(3, "%s: fast_io_fail_tmo = off (controller default)", mp->alias);
+			condlog(3, "%s: fast_io_fail_tmo = off "
+				"(controller setting)", mp->alias);
 		else
-			condlog(3, "%s: fast_io_fail_tmo = %d (controller default)", mp->alias,
+			condlog(3, "%s: fast_io_fail_tmo = %d "
+				"(controller setting)", mp->alias,
 				mp->fast_io_fail == MP_FAST_IO_FAIL_ZERO ? 0 : mp->fast_io_fail);
 		return 0;
 	}
 	if (conf->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
 		mp->fast_io_fail = conf->fast_io_fail;
 		if (mp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
-			condlog(3, "%s: fast_io_fail_tmo = off (config file default)", mp->alias);
+			condlog(3, "%s: fast_io_fail_tmo = off "
+				"(config file default)", mp->alias);
 		else
-			condlog(3, "%s: fast_io_fail_tmo = %d (config file default)", mp->alias,
+			condlog(3, "%s: fast_io_fail_tmo = %d "
+				"(config file default)", mp->alias,
 				mp->fast_io_fail == MP_FAST_IO_FAIL_ZERO ? 0 : mp->fast_io_fail);
 		return 0;
 	}
-- 
1.7.4.2
