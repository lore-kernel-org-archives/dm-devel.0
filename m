From: Brian Wong <bwong@pillardata.com>
Subject: Segfault running multipath -d -v 3 at HOL
Date: Wed, 12 Apr 2006 17:02:02 -0700
Message-ID: <1144886522.7553.6.camel@ca-bwong3.trans.corp>
Reply-To: bwong@pillardata.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-utfUS8a3fCNG4Ie7zfh6"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


--=-utfUS8a3fCNG4Ie7zfh6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Christophe,

I'm seeing a segfault running `multipath -d -v 3` at HOL.  Here's the
fix for the issue.  It might be worth applying similar logic fixes to
the rest of the free_x() calls in free_config(); let me know if you want
that patch too.

cheers,

brian

--=-utfUS8a3fCNG4Ie7zfh6
Content-Disposition: attachment; filename=diff.out
Content-Type: text/x-patch; name=diff.out; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff --git a/libmultipath/config.c b/libmultipath/config.c
index c9d6172..928bfea 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -305,7 +305,8 @@ free_config (struct config * conf)
 	free_blacklist_device(conf->blist_device);
 	free_mptable(conf->mptable);
 	free_hwtable(conf->hwtable);
-	free_keywords(conf->keywords);
+	if (conf->keywords)
+		free_keywords(conf->keywords);
 	FREE(conf);
 }
 
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 385e4fb..bb04968 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -18,6 +18,7 @@
  */
 
 #include <syslog.h>
+#include <assert.h>
 
 #include "parser.h"
 #include "memory.h"
@@ -110,6 +111,9 @@ free_keywords(vector keywords)
 	struct keyword *keyword;
 	int i;
 
+	assert(keywords);
+	if (!keywords) return;
+
 	for (i = 0; i < VECTOR_SIZE(keywords); i++) {
 		keyword = VECTOR_SLOT(keywords, i);
 		if (keyword->sub)
@@ -483,3 +487,11 @@ init_data(char *conf_file, void (*init_k
 
 	return r;
 }
+
+/*
+ * Local Variables: ***
+ * mode:c ***
+ * c-basic-offset:8 ***
+ * indent-tabs-mode:1 ***
+ * End: ***
+ */

--=-utfUS8a3fCNG4Ie7zfh6
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-utfUS8a3fCNG4Ie7zfh6--
