From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/2] libmultipath: print.c: make sure lines are
	0-terminated
Date: Wed, 17 May 2017 15:54:38 +0200
Message-ID: <20170517135439.25935-2-mwilck@suse.com>
References: <20170517135439.25935-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517135439.25935-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Under certain conditions, the output of "multipath -ll" or
"multipathd show topology", or the multipathd logs, may
contain garbage characters. Fix that by making sure that
the strings are always properly zero-terminated.

Note 1: The way this is coded, the previously written
character is overwritten by the newline. That behavior is
unchanged by this patch. I didn't want to fuzz with the
carefully crafted print.c code more than necessary at
this point.

Note 2: The condition (c <= line + len - 1) is equivalent to
(TAIL >= 0). It should always hold the way ENDLINE is called
after PRINT and PAD in print.c, and is only added as an
additional safeguard, e.g. against future code changes.
---
 libmultipath/print.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 7c2a1588..3a07fcf5 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -40,8 +40,14 @@ do { \
 } while (0)
 
 #define ENDLINE \
-		if (c > line) \
-			line[c - line - 1] = '\n'
+		if (c > line) {				\
+			if (c <= line + len - 1) {	\
+				*(c - 1) = '\n';	\
+				*c = '\0';		\
+			} else				\
+				line[len - 1] = '\0';	\
+		}
+
 #define PRINT(var, size, format, args...) \
 do { \
 	fwd = snprintf(var, size, format, ##args); \
-- 
2.12.2
