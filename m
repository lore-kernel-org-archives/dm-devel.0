From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/2] libmultipath: print.c: make sure lines
	are 0-terminated
Date: Wed, 17 May 2017 17:24:45 +0200
Message-ID: <20170517152446.2526-2-mwilck@suse.com>
References: <20170517152446.2526-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517152446.2526-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Under certain conditions, the output of "multipath -ll" or
"multipathd show topology", or the multipathd logs, may
contain garbage characters. Fix that by making sure that
the strings are always properly zero-terminated.

While touching this code, substitute a function for the
complex ENDLINE macro.

Note 1: The way this is coded, the previously written
character is overwritten by the newline. That behavior is
unchanged by this patch. I didn't want to fuzz with the
carefully crafted print.c code more than necessary at
this point.

Note 2: The condition (c <= line + len - 1) is equivalent to
(TAIL >= 0). It should always hold the way ENDLINE is called
after PRINT and PAD in print.c, and is only added as an
additional safeguard, e.g. against future code changes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 7c2a1588..95dff90b 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -39,9 +39,18 @@ do { \
 	s = c; \
 } while (0)
 
-#define ENDLINE \
-		if (c > line) \
-			line[c - line - 1] = '\n'
+static char *
+__endline(char *line, size_t len, char *c)
+{
+	if (c > line) {
+		if (c >= line + len)
+			c = line + len - 1;
+		*(c - 1) = '\n';
+		*c = '\0';
+	}
+	return c;
+}
+
 #define PRINT(var, size, format, args...) \
 do { \
 	fwd = snprintf(var, size, format, ##args); \
@@ -802,7 +811,7 @@ snprint_multipath_header (char * line, int len, char * format)
 		PAD(data->width);
 	} while (*f++);
 
-	ENDLINE;
+	__endline(line, len, c);
 	return (c - line);
 }
 
@@ -838,7 +847,7 @@ snprint_multipath (char * line, int len, char * format,
 		buff[0] = '\0';
 	} while (*f++);
 
-	ENDLINE;
+	__endline(line, len, c);
 	return (c - line);
 }
 
@@ -869,7 +878,7 @@ snprint_path_header (char * line, int len, char * format)
 		PAD(data->width);
 	} while (*f++);
 
-	ENDLINE;
+	__endline(line, len, c);
 	return (c - line);
 }
 
@@ -904,7 +913,7 @@ snprint_path (char * line, int len, char * format,
 			PAD(data->width);
 	} while (*f++);
 
-	ENDLINE;
+	__endline(line, len, c);
 	return (c - line);
 }
 
@@ -938,7 +947,7 @@ snprint_pathgroup (char * line, int len, char * format,
 		PAD(data->width);
 	} while (*f++);
 
-	ENDLINE;
+	__endline(line, len, c);
 	return (c - line);
 }
 
-- 
2.12.2
