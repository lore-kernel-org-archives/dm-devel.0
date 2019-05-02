From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: document missing multipath
	flags in help output
Date: Thu,  2 May 2019 21:24:08 +0200
Message-ID: <20190502192408.31187-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/main.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 008e3d3..252ade7 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -133,11 +133,15 @@ usage (char * progname)
 {
 	fprintf (stderr, VERSION_STRING);
 	fprintf (stderr, "Usage:\n");
-	fprintf (stderr, "  %s [-a|-c|-w|-W] [-d] [-r] [-i] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
-	fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [-R num] [dev]\n", progname);
-	fprintf (stderr, "  %s -F [-v lvl] [-R num]\n", progname);
-	fprintf (stderr, "  %s [-t|-T]\n", progname);
-	fprintf (stderr, "  %s -h\n", progname);
+	fprintf (stderr, "  %s [-v level] [-B|-d|-i|-q|-r] [-b file] [-p policy] [device]\n", progname);
+	fprintf (stderr, "  %s [-v level] [-R retries] -f device\n", progname);
+	fprintf (stderr, "  %s [-v level] [-R retries] -F\n", progname);
+	fprintf (stderr, "  %s [-v level] [-l|-ll] [device]\n", progname);
+	fprintf (stderr, "  %s [-v level] [-a|-w] device\n", progname);
+	fprintf (stderr, "  %s [-v level] -W\n", progname);
+	fprintf (stderr, "  %s [-v level] [-i] [-c|-C] device\n", progname);
+	fprintf (stderr, "  %s [-v level] [-i] [-u|-U]\n", progname);
+	fprintf (stderr, "  %s [-h|-t|-T]\n", progname);
 	fprintf (stderr,
 		"\n"
 		"Where:\n"
@@ -159,23 +163,28 @@ usage (char * progname)
 		"  -b fil  bindings file location\n"
 		"  -w      remove a device from the wwids file\n"
 		"  -W      reset the wwids file include only the current devices\n"
-		"  -p pol  force all maps to specified path grouping policy :\n"
+		"  -R num  number of times to retry removes of in-use devices\n"
+		"  -u      check if the device specified in the program environment should be a\n"
+		"          path in a multipath device\n"
+		"  -U      check if the device specified in the program environment is a\n"
+		"          multipath device with usable paths, see -C flag\n"
+		"  -p pol  force all maps to specified path grouping policy:\n"
 		"          . failover            one path per priority group\n"
 		"          . multibus            all paths in one priority group\n"
 		"          . group_by_serial     one priority group per serial\n"
 		"          . group_by_prio       one priority group per priority lvl\n"
 		"          . group_by_node_name  one priority group per target node\n"
-		"  -v lvl  verbosity level\n"
+		"  -v lvl  verbosity level:\n"
 		"          . 0 no output\n"
 		"          . 1 print created devmap names only\n"
 		"          . 2 default verbosity\n"
 		"          . 3 print debug information\n"
-		"  -R num  number of times to retry removes of in-use devices\n"
-		"  dev     action limited to:\n"
-		"          . multipath named 'dev' (ex: mpath0) or\n"
-		"          . multipath whose wwid is 'dev' (ex: 60051..)\n"
-		"          . multipath including the path named 'dev' (ex: /dev/sda)\n"
-		"          . multipath including the path with maj:min 'dev' (ex: 8:0)\n"
+		"  device  action limited to:\n"
+		"          . multipath named 'device' (ex: mpath0)\n"
+		"          . multipath whose wwid is 'device' (ex: 60051...)\n"
+		"          . multipath including the path named 'device' (ex: /dev/sda or\n"
+		"            /dev/dm-0)\n"
+		"          . multipath including the path with maj:min 'device' (ex: 8:0)\n"
 		);
 
 }
-- 
2.21.0
