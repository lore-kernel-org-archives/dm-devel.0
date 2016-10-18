From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace hardcoded
	USER_FRIENDLY_NAMES_OFF by default
Date: Tue, 18 Oct 2016 15:22:45 +0200
Message-ID: <20161018132245.3061-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/defaults.h | 1 +
 libmultipath/propsel.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index d00a86f..e9581a6 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -32,6 +32,7 @@
 #define DEFAULT_PRIO_ARGS	""
 #define DEFAULT_CHECKER		TUR
 #define DEFAULT_FLUSH		FLUSH_DISABLED
+#define DEFAULT_USER_FRIENDLY_NAMES USER_FRIENDLY_NAMES_OFF
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 88a1916..aaf99fb 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -228,7 +228,7 @@ want_user_friendly_names(struct config *conf, struct multipath * mp)
 	       "(controller setting)");
 	do_set(user_friendly_names, conf, user_friendly_names,
 	       "(config file setting)");
-	do_default(user_friendly_names, USER_FRIENDLY_NAMES_OFF);
+	do_default(user_friendly_names, DEFAULT_USER_FRIENDLY_NAMES);
 out:
 	condlog(3, "%s: user_friendly_names = %s %s", mp->wwid,
 		(user_friendly_names == USER_FRIENDLY_NAMES_ON)? "yes" : "no",
-- 
2.10.1
