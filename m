From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 06/18] libmultipath: fix PAD and PRINT macros
Date: Thu,  7 Apr 2016 18:20:00 -0500
Message-ID: <1460071212-21018-7-git-send-email-bmarzins@redhat.com>
References: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
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

The PAD and PRINT macros are multi-line macros that aren't enclosed in
braces. This means that if they are used as single line code blocks
with no braces, they won't work correctly. This is currently happening
with the PAD macro, but should be fixed in both.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 6215d0b..13d076a 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -32,14 +32,21 @@
 #define MAX(x,y) (x > y) ? x : y
 #define TAIL     (line + len - 1 - c)
 #define NOPAD    s = c
-#define PAD(x)   while ((int)(c - s) < (x) && (c < (line + len - 1))) \
-			*c++ = ' '; s = c
+#define PAD(x) \
+do { \
+	while ((int)(c - s) < (x) && (c < (line + len - 1))) \
+		*c++ = ' '; \
+	s = c; \
+} while (0)
+
 #define ENDLINE \
 		if (c > line) \
 			line[c - line - 1] = '\n'
-#define PRINT(var, size, format, args...)      \
-		fwd = snprintf(var, size, format, ##args); \
-		 c += (fwd >= size) ? size : fwd;
+#define PRINT(var, size, format, args...) \
+do { \
+	fwd = snprintf(var, size, format, ##args); \
+	c += (fwd >= size) ? size : fwd; \
+} while (0)
 
 /*
  * information printing helpers
-- 
1.8.3.1
