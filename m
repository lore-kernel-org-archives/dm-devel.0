From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 06/12] libmpathcmd(coverity): limit reply length
Date: Tue,  8 Jan 2019 23:54:03 +0100
Message-ID: <20190108225409.15977-7-mwilck@suse.com>
References: <20190108225409.15977-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190108225409.15977-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

coverity warned about tainted input data.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathcmd/mpath_cmd.c   | 4 ++++
 libmpathcmd/mpath_cmd.h   | 6 ++++++
 multipathd/cli.c          | 2 ++
 multipathd/cli.h          | 6 ++++++
 multipathd/cli_handlers.c | 1 +
 5 files changed, 19 insertions(+)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index 61e6a98..df4ca54 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -133,6 +133,10 @@ ssize_t mpath_recv_reply_len(int fd, unsigned int timeout)
 		errno = EIO;
 		return -1;
 	}
+	if (len <= 0 || len >= MAX_REPLY_LEN) {
+		errno = ERANGE;
+		return -1;
+	}
 	return len;
 }
 
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index df9d938..15aeb06 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -20,6 +20,12 @@
 #ifndef LIB_MPATH_CMD_H
 #define LIB_MPATH_CMD_H
 
+/*
+ * This should be sufficient for json output for >10000 maps,
+ * and >60000 paths.
+ */
+#define MAX_REPLY_LEN (32 * 1024 * 1024)
+
 #ifdef __cplusplus
 extern "C" {
 #endif
diff --git a/multipathd/cli.c b/multipathd/cli.c
index a75afe3..ca176a9 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -13,7 +13,9 @@
 #include "version.h"
 #include <readline/readline.h>
 
+#include "mpath_cmd.h"
 #include "cli.h"
+#include "debug.h"
 
 static vector keys;
 static vector handlers;
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 7cc7e4b..f3fa077 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -96,6 +96,12 @@ enum {
 	do {							\
 		if ((a)) {					\
 			char *tmp = (r);			\
+								\
+			if (m >= MAX_REPLY_LEN) {		\
+				condlog(1, "Warning: max reply length exceeded"); \
+				free(tmp);			\
+				r = NULL;			\
+			}					\
 			(r) = REALLOC((r), (m) * 2);		\
 			if ((r)) {				\
 				memset((r) + (m), 0, (m));	\
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 6304ed3..f979a18 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -26,6 +26,7 @@
 #include "prkey.h"
 #include "propsel.h"
 #include "main.h"
+#include "mpath_cmd.h"
 #include "cli.h"
 #include "uevent.h"
 #include "foreign.h"
-- 
2.19.2
