From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 3/5] multipath: set verbosity to default during
	config
Date: Thu,  1 Jun 2017 22:09:10 -0500
Message-ID: <1496372952-27110-4-git-send-email-bmarzins@redhat.com>
References: <1496372952-27110-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1496372952-27110-1-git-send-email-bmarzins@redhat.com>
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

condlog was setting the verbosity to 0 if there was no configuration.
This keeps multipath from printing warning messages about config file
problems that are found while loading the configuration. Instead, it
should use the default config level until it loads the configuration
to find the current value.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/debug.c b/libmultipath/debug.c
index fbe171a..f89b264 100644
--- a/libmultipath/debug.c
+++ b/libmultipath/debug.c
@@ -11,6 +11,7 @@
 #include "../third-party/valgrind/drd.h"
 #include "vector.h"
 #include "config.h"
+#include "defaults.h"
 
 void dlog (int sink, int prio, const char * fmt, ...)
 {
@@ -21,7 +22,7 @@ void dlog (int sink, int prio, const char * fmt, ...)
 	va_start(ap, fmt);
 	conf = get_multipath_config();
 	ANNOTATE_IGNORE_READS_BEGIN();
-	thres = (conf) ? conf->verbosity : 0;
+	thres = (conf) ? conf->verbosity : DEFAULT_VERBOSITY;
 	ANNOTATE_IGNORE_READS_END();
 	put_multipath_config(conf);
 
-- 
2.7.4
