From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 4/5] libmultipath: Print line number for which
	parsing failed
Date: Fri, 18 Jul 2014 14:54:13 +0200
Message-ID: <53C918F5.2050703@acm.org>
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

Make it easier to figure out which line contains a syntax error
by printing the line number and the offending line itself.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 libmultipath/parser.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index b7bdfcc..d8673bc 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -460,7 +460,7 @@ int
 process_stream(vector keywords)
 {
 	int i;
-	int r = 0;
+	int r = 0, t;
 	struct keyword *keyword;
 	char *str;
 	char *buf;
@@ -501,8 +501,13 @@ process_stream(vector keywords)
 						free_strvec(strvec);
 						goto out;
 				}
-				if (keyword->handler)
-					r += (*keyword->handler) (strvec);
+				if (keyword->handler) {
+					t = (*keyword->handler) (strvec);
+					r += t;
+					if (t)
+						condlog(1, "multipath.conf +%d parsing failed: %s",
+							line_nr, buf);
+				}
 
 				if (keyword->sub) {
 					kw_level++;
-- 
1.8.4.5
