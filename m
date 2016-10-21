From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 12/15] Use NULL instead of 0 where a pointer is
	expected
Date: Fri, 21 Oct 2016 11:45:54 -0700
Message-ID: <badd54d2-68fd-4bdf-cd13-dedeb3e94635@sandisk.com>
References: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
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

This was detected by sparse.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 kpartx/lopart.c             |  2 +-
 libmultipath/checkers/rbd.c |  2 +-
 mpathpersist/main.h         | 48 ++++++++++++++++++++++-----------------------
 3 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 0ab1688..4502fad 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -228,7 +228,7 @@ find_unused_loop_device (void)
 				"       maybe /dev/loop# has the wrong major number?");
 	} else
 		fprintf(stderr, "mount: could not find any free loop device");
-	return 0;
+	return NULL;
 }
 
 extern int
diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index 745e240..481d860 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -464,7 +464,7 @@ static int rbd_rm_blacklist(struct rbd_checker_context *ct)
 	cmd[1] = NULL;
 
 	ret = rados_mon_command(ct->cluster, (const char **)cmd, 1, "", 0,
-				NULL, 0, &stat, &stat_len);
+				NULL, NULL, &stat, &stat_len);
 	if (ret < 0) {
 		condlog(1, "rbd%d: repair failed to remove blacklist for %s %d",
 			ct->rbd_bus_id, ct->client_addr, ret);
diff --git a/mpathpersist/main.h b/mpathpersist/main.h
index 7c31262..5c0e089 100644
--- a/mpathpersist/main.h
+++ b/mpathpersist/main.h
@@ -1,28 +1,28 @@
 static struct option long_options[] = {
-	{"verbose", 1, 0, 'v'},
-	{"clear", 0, 0, 'C'},
-	{"device", 1, 0, 'd'},
-	{"help", 0, 0, 'h'},
-	{"hex", 0, 0, 'H'},
-	{"in", 0, 0, 'i'},
-	{"out", 0, 0, 'o'},
-	{"param-aptpl", 0, 0, 'Z'},
-	{"param-rk", 1, 0, 'K'},
-	{"param-sark", 1, 0, 'S'},
-	{"preempt", 0, 0, 'P'},
-	{"preempt-abort", 0, 0, 'A'},
-	{"prout-type", 1, 0, 'T'},
-	{"read-full-status", 0, 0, 's'},
-	{"read-keys", 0, 0, 'k'},
-	{"read-reservation", 0, 0, 'r'},
-	{"register", 0, 0, 'G'},
-	{"register-ignore", 0, 0, 'I'},
-	{"release", 0, 0, 'L'},
-	{"report-capabilities", 0, 0, 'c'},
-	{"reserve", 0, 0, 'R'},
-	{"transport-id", 1, 0, 'X'},
-	{"alloc-length", 1, 0, 'l'},
-	{0, 0, 0, 0}
+	{"verbose", 1, NULL, 'v'},
+	{"clear", 0, NULL, 'C'},
+	{"device", 1, NULL, 'd'},
+	{"help", 0, NULL, 'h'},
+	{"hex", 0, NULL, 'H'},
+	{"in", 0, NULL, 'i'},
+	{"out", 0, NULL, 'o'},
+	{"param-aptpl", 0, NULL, 'Z'},
+	{"param-rk", 1, NULL, 'K'},
+	{"param-sark", 1, NULL, 'S'},
+	{"preempt", 0, NULL, 'P'},
+	{"preempt-abort", 0, NULL, 'A'},
+	{"prout-type", 1, NULL, 'T'},
+	{"read-full-status", 0, NULL, 's'},
+	{"read-keys", 0, NULL, 'k'},
+	{"read-reservation", 0, NULL, 'r'},
+	{"register", 0, NULL, 'G'},
+	{"register-ignore", 0, NULL, 'I'},
+	{"release", 0, NULL, 'L'},
+	{"report-capabilities", 0, NULL, 'c'},
+	{"reserve", 0, NULL, 'R'},
+	{"transport-id", 1, NULL, 'X'},
+	{"alloc-length", 1, NULL, 'l'},
+	{NULL, 0, NULL, 0}
 };
 
 static void usage(void);
-- 
2.10.1
