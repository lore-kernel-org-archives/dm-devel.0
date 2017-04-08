From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace multipath configuration
	output
Date: Sat,  8 Apr 2017 15:30:42 +0200
Message-ID: <20170408133042.4478-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/propsel.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index dd10ceb..5f70d86 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -162,7 +162,7 @@ int select_pgpolicy(struct config *conf, struct multipath * mp)
 
 	if (conf->pgpolicy_flag > 0) {
 		mp->pgpolicy = conf->pgpolicy_flag;
-		origin = "(cmd line flag)";
+		origin = "(setting: multipath command line [-p] flag)";
 		goto out;
 	}
 	mp_set_mpe(pgpolicy);
@@ -251,18 +251,18 @@ int select_alias(struct config *conf, struct multipath * mp)
 				mp->alias_old, mp->alias_prefix,
 				conf->bindings_read_only);
 		memset (mp->alias_old, 0, WWID_SIZE);
-		origin = "(using existing alias)";
+		origin = "(setting: using existing alias)";
 	}
 
 	if (mp->alias == NULL) {
 		mp->alias = get_user_friendly_alias(mp->wwid,
 				conf->bindings_file, mp->alias_prefix, conf->bindings_read_only);
-		origin = "(user_friendly_name)";
+		origin = "(setting: user_friendly_name)";
 	}
 out:
 	if (mp->alias == NULL) {
 		mp->alias = STRDUP(mp->wwid);
-		origin = "(default to wwid)";
+		origin = "(setting: default to WWID)";
 	}
 	if (mp->alias)
 		condlog(3, "%s: alias = %s %s", mp->wwid, mp->alias, origin);
@@ -565,7 +565,7 @@ int select_retain_hwhandler(struct config *conf, struct multipath *mp)
 
 	if (!VERSION_GE(conf->version, minv_dm_retain)) {
 		mp->retain_hwhandler = RETAIN_HWHANDLER_OFF;
-		origin = "(requires kernel version >= 1.5.0)";
+		origin = "(setting: WARNING, requires kernel version >= 1.5.0)";
 		goto out;
 	}
 	mp_set_ovr(retain_hwhandler);
@@ -614,7 +614,7 @@ int select_deferred_remove(struct config *conf, struct multipath *mp)
 
 #ifndef LIBDM_API_DEFERRED
 	mp->deferred_remove = DEFERRED_REMOVE_OFF;
-	origin = "(not compiled with support)";
+	origin = "(setting: WARNING, not compiled with support)";
 	goto out;
 #endif
 	if (mp->deferred_remove == DEFERRED_REMOVE_IN_PROGRESS) {
-- 
2.12.2
