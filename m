From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/5] libmultipath: Simplify read_line()
Date: Fri, 18 Jul 2014 14:53:11 +0200
Message-ID: <53C918B7.3010704@acm.org>
References: <53C91871.9070402@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53C91871.9070402@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: device-mapper development <dm-devel@redhat.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

Let read_line() zero-terminate the buffer it returns such that its
callers do not have to clear that buffer before calling read_line().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 libmultipath/parser.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 0d4c870..b7bdfcc 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -282,18 +282,12 @@ out:
 int
 read_line(char *buf, int size)
 {
-	int ch;
-	int count = 0;
-
-	while ((ch = fgetc(stream)) != EOF && (int) ch != '\n'
-	       && (int) ch != '\r') {
-		if (count < size)
-			buf[count] = (int) ch;
-		else
-			break;
-		count++;
-	}
-	return (ch == EOF) ? 0 : 1;
+	char *p;
+
+	if (fgets(buf, size, stream) == NULL)
+		return 0;
+	strtok_r(buf, "\n\r", &p);
+	return 1;
 }
 
 vector
@@ -341,7 +335,6 @@ read_value_block(void)
 			}
 			free_strvec(vec);
 		}
-		memset(buf, 0, MAXBUF);
 	}
 	FREE(buf);
 	return elements;
@@ -379,7 +372,6 @@ alloc_value_block(vector strvec, void (*alloc_func) (vector))
 
 			free_strvec(vec);
 		}
-		memset(buf, 0, MAXBUF);
 	}
 	FREE(buf);
 	return 0;
@@ -489,8 +481,6 @@ process_stream(vector keywords)
 	while (read_line(buf, MAXBUF)) {
 		line_nr++;
 		strvec = alloc_strvec(buf);
-		memset(buf,0, MAXBUF);
-
 		if (!strvec)
 			continue;
 
-- 
1.8.4.5
