From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 14/15] libmultipath: Micro-optimize snprint_size()
Date: Tue, 4 Oct 2016 10:41:59 -0700
Message-ID: <f046a639-204e-4ad6-4865-e01c999af57c@sandisk.com>
References: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Eliminate the stack array fmt[]. An interesting side effect of
this patch is that it makes it possible for the compiler to
verify whether the snprintf() arguments have a type that is
appropriate for the format string.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/print.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 94d6384..9aa41ad 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -73,7 +73,6 @@ static int
 snprint_size (char * buff, size_t len, unsigned long long size)
 {
 	float s = (float)(size >> 1); /* start with KB */
-	char fmt[6] = {};
 	char units[] = {'K','M','G','T','P'};
 	char *u = units;
 
@@ -81,12 +80,8 @@ snprint_size (char * buff, size_t len, unsigned long long size)
 		s = s / 1024;
 		u++;
 	}
-	if (s < 10)
-		snprintf(fmt, 6, "%%.1f%c", *u);
-	else
-		snprintf(fmt, 6, "%%.0f%c", *u);
 
-	return snprintf(buff, len, fmt, s);
+	return snprintf(buff, len, "%.*f%c", s < 10, s, *u);
 }
 
 /*
-- 
2.10.0
