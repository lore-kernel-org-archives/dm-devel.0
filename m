From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove final \ in fprintf
Date: Mon, 18 Jul 2016 15:23:59 +0200
Message-ID: <1468848239-6163-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Useless.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/main.c | 64 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 907a96c..0bec0d2 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -110,38 +110,38 @@ usage (char * progname)
 	fprintf (stderr,
 		"\n"
 		"Where:\n"
-		"  -h      print this usage text\n" \
-		"  -l      show multipath topology (sysfs and DM info)\n" \
-		"  -ll     show multipath topology (maximum info)\n" \
-		"  -f      flush a multipath device map\n" \
-		"  -F      flush all multipath device maps\n" \
-		"  -a      add a device wwid to the wwids file\n" \
-		"  -c      check if a device should be a path in a multipath device\n" \
-		"  -q      allow queue_if_no_path when multipathd is not running\n"\
-		"  -d      dry run, do not create or update devmaps\n" \
-		"  -t      dump internal hardware table\n" \
-		"  -r      force devmap reload\n" \
-		"  -i      ignore wwids file\n" \
-		"  -B      treat the bindings file as read only\n" \
-		"  -b fil  bindings file location\n" \
-		"  -w      remove a device from the wwids file\n" \
-		"  -W      reset the wwids file include only the current devices\n" \
-		"  -p pol  force all maps to specified path grouping policy :\n" \
-		"          . failover            one path per priority group\n" \
-		"          . multibus            all paths in one priority group\n" \
-		"          . group_by_serial     one priority group per serial\n" \
-		"          . group_by_prio       one priority group per priority lvl\n" \
-		"          . group_by_node_name  one priority group per target node\n" \
-		"  -v lvl  verbosity level\n" \
-		"          . 0 no output\n" \
-		"          . 1 print created devmap names only\n" \
-		"          . 2 default verbosity\n" \
-		"          . 3 print debug information\n" \
-		"  dev     action limited to:\n" \
-		"          . multipath named 'dev' (ex: mpath0) or\n" \
-		"          . multipath whose wwid is 'dev' (ex: 60051..)\n" \
-		"          . multipath including the path named 'dev' (ex: /dev/sda)\n" \
-		"          . multipath including the path with maj:min 'dev' (ex: 8:0)\n" \
+		"  -h      print this usage text\n"
+		"  -l      show multipath topology (sysfs and DM info)\n"
+		"  -ll     show multipath topology (maximum info)\n"
+		"  -f      flush a multipath device map\n"
+		"  -F      flush all multipath device maps\n"
+		"  -a      add a device wwid to the wwids file\n"
+		"  -c      check if a device should be a path in a multipath device\n"
+		"  -q      allow queue_if_no_path when multipathd is not running\n"
+		"  -d      dry run, do not create or update devmaps\n"
+		"  -t      dump internal hardware table\n"
+		"  -r      force devmap reload\n"
+		"  -i      ignore wwids file\n"
+		"  -B      treat the bindings file as read only\n"
+		"  -b fil  bindings file location\n"
+		"  -w      remove a device from the wwids file\n"
+		"  -W      reset the wwids file include only the current devices\n"
+		"  -p pol  force all maps to specified path grouping policy :\n"
+		"          . failover            one path per priority group\n"
+		"          . multibus            all paths in one priority group\n"
+		"          . group_by_serial     one priority group per serial\n"
+		"          . group_by_prio       one priority group per priority lvl\n"
+		"          . group_by_node_name  one priority group per target node\n"
+		"  -v lvl  verbosity level\n"
+		"          . 0 no output\n"
+		"          . 1 print created devmap names only\n"
+		"          . 2 default verbosity\n"
+		"          . 3 print debug information\n"
+		"  dev     action limited to:\n"
+		"          . multipath named 'dev' (ex: mpath0) or\n"
+		"          . multipath whose wwid is 'dev' (ex: 60051..)\n"
+		"          . multipath including the path named 'dev' (ex: /dev/sda)\n"
+		"          . multipath including the path with maj:min 'dev' (ex: 8:0)\n"
 		);
 
 }
-- 
2.7.4
