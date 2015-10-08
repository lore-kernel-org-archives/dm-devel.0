From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 10/18] resize reply buffer for mutipathd help
	message
Date: Thu,  8 Oct 2015 14:44:43 -0500
Message-ID: <1444333491-16265-11-git-send-email-bmarzins@redhat.com>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Unlike the other reply messages from multipathd, the generic help
message code couldn't resize the buffer, and the reply had grown too big
for the initial buffer size. This was causing memory corruption and
crashing multipathd instead of printing a help message. This patch
increases the size of the initial reply buffer, and makes the help
message code able to resize the buffer so this doesn't happen in the
future.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli.c          | 88 +++++++++++++++++++++++++++++++++--------------
 multipathd/cli.h          | 16 ++++++++-
 multipathd/cli_handlers.c | 14 --------
 3 files changed, 78 insertions(+), 40 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index acc4249..8d26956 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -320,52 +320,90 @@ alloc_handlers (void)
 }
 
 static int
-genhelp_sprint_aliases (char * reply, vector keys, struct key * refkw)
+genhelp_sprint_aliases (char * reply, int maxlen, vector keys,
+			struct key * refkw)
 {
-	int i, fwd = 0;
+	int i, len = 0;
 	struct key * kw;
 
-	vector_foreach_slot (keys, kw, i)
-		if (kw->code == refkw->code && kw != refkw)
-			fwd += sprintf(reply, "|%s", kw->str);
+	vector_foreach_slot (keys, kw, i) {
+		if (kw->code == refkw->code && kw != refkw) {
+			len += snprintf(reply + len, maxlen - len,
+					"|%s", kw->str);
+			if (len >= maxlen)
+				return len;
+		}
+	}
 
-	return fwd;
+	return len;
 }
 
-static char *
-genhelp_handler (void)
-{
+static int
+do_genhelp(char *reply, int maxlen) {
+	int len = 0;
 	int i, j;
 	unsigned long fp;
 	struct handler * h;
 	struct key * kw;
-	char * reply;
-	char * p;
-
-	reply = MALLOC(INITIAL_REPLY_LEN);
 
-	if (!reply)
-		return NULL;
-
-	p = reply;
-	p += sprintf(p, VERSION_STRING);
-	p += sprintf(p, "CLI commands reference:\n");
+	len += snprintf(reply + len, maxlen - len, VERSION_STRING);
+	if (len >= maxlen)
+		goto out;
+	len += snprintf(reply + len, maxlen - len, "CLI commands reference:\n");
+	if (len >= maxlen)
+		goto out;
 
 	vector_foreach_slot (handlers, h, i) {
 		fp = h->fingerprint;
 		vector_foreach_slot (keys, kw, j) {
 			if ((kw->code & fp)) {
 				fp -= kw->code;
-				p += sprintf(p, " %s", kw->str);
-				p += genhelp_sprint_aliases(p, keys, kw);
-
-				if (kw->has_param)
-					p += sprintf(p, " $%s", kw->str);
+				len += snprintf(reply + len , maxlen - len,
+						" %s", kw->str);
+				if (len >= maxlen)
+					goto out;
+				len += genhelp_sprint_aliases(reply + len,
+							      maxlen - len,
+							      keys, kw);
+				if (len >= maxlen)
+					goto out;
+
+				if (kw->has_param) {
+					len += snprintf(reply + len,
+							maxlen - len,
+							" $%s", kw->str);
+					if (len >= maxlen)
+						goto out;
+				}
 			}
 		}
-		p += sprintf(p, "\n");
+		len += snprintf(reply + len, maxlen - len, "\n");
+		if (len >= maxlen)
+			goto out;
 	}
+out:
+	return len;
+}
+
 
+static char *
+genhelp_handler (void)
+{
+	char * reply;
+	char * p = NULL;
+	int maxlen = INITIAL_REPLY_LEN;
+	int again = 1;
+
+	reply = MALLOC(maxlen);
+
+	while (again) {
+		if (!reply)
+			return NULL;
+		p = reply;
+		p += do_genhelp(reply, maxlen);
+		again = ((p - reply) >= maxlen);
+		REALLOC_REPLY(reply, again, maxlen);
+	}
 	return reply;
 }
 
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 09fdc68..2e0e1da 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -71,7 +71,21 @@ enum {
 #define SETPRSTATUS	(1UL << __SETPRSTATUS)
 #define UNSETPRSTATUS	(1UL << __UNSETPRSTATUS)
 
-#define INITIAL_REPLY_LEN	1100
+#define INITIAL_REPLY_LEN	1200
+
+#define REALLOC_REPLY(r, a, m)					\
+	do {							\
+		if ((a)) {					\
+			char *tmp = (r);			\
+			(r) = REALLOC((r), (m) * 2);		\
+			if ((r)) {				\
+				memset((r) + (m), 0, (m));	\
+				(m) *= 2;			\
+			}					\
+			else					\
+				free(tmp);			\
+		}						\
+	} while (0)
 
 struct key {
 	char * str;
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 305cd7f..8cde810 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -23,20 +23,6 @@
 #include "cli.h"
 #include "uevent.h"
 
-#define REALLOC_REPLY(r, a, m)					\
-	do {							\
-		if ((a)) {					\
-			char *tmp = (r);			\
-			(r) = REALLOC((r), (m) * 2);		\
-			if ((r)) {				\
-				memset((r) + (m), 0, (m));	\
-				(m) *= 2;			\
-			}					\
-			else					\
-				free(tmp);			\
-		}						\
-	} while (0)
-
 int
 show_paths (char ** r, int * len, struct vectors * vecs, char * style)
 {
-- 
1.8.3.1
