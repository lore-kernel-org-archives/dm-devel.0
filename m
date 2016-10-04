From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 07/15] multipathd: Fix a data race
Date: Tue, 4 Oct 2016 10:39:30 -0700
Message-ID: <0084c5eb-4cda-ea52-3532-47b2ca1314a4@sandisk.com>
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

Avoid that the path check interval initialization loop races with
other code that accesses the path vectors by executing that code
on the context of the main thread instead of the checker loop.
This patch avoids that DRD reports the following:

Conflicting store by thread 1 at 0x07f3f1f8 size 8
   at 0x40B50C: reconfigure (main.c:2014)
   by 0x40C2EC: child (main.c:2371)
   by 0x40CDA1: main (main.c:2609)
Address 0x7f3f1f8 is at offset 40 from 0x7f3f1d0. Allocation context:
   at 0x4C32995: calloc (in /usr/lib64/valgrind/vgpreload_drd-amd64-linux.so)
   by 0x5DDAC36: zalloc (memory.c:34)
   by 0x40B61A: init_vecs (main.c:2043)
   by 0x40BF01: child (main.c:2295)
   by 0x40CDA1: main (main.c:2609)

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 multipathd/main.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 3030e85..cdfafe8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1742,6 +1742,19 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	return 1;
 }
 
+static void init_path_check_interval(struct vectors *vecs)
+{
+	struct config *conf;
+	struct path *pp;
+	unsigned int i;
+
+	vector_foreach_slot (vecs->pathvec, pp, i) {
+		conf = get_multipath_config();
+		pp->checkint = conf->checkint;
+		put_multipath_config(conf);
+	}
+}
+
 static void *
 checkerloop (void *ap)
 {
@@ -1759,15 +1772,6 @@ checkerloop (void *ap)
 	vecs = (struct vectors *)ap;
 	condlog(2, "path checkers start up");
 
-	/*
-	 * init the path check interval
-	 */
-	vector_foreach_slot (vecs->pathvec, pp, i) {
-		conf = get_multipath_config();
-		pp->checkint = conf->checkint;
-		put_multipath_config(conf);
-	}
-
 	/* Tweak start time for initial path check */
 	if (clock_gettime(CLOCK_MONOTONIC, &last_time) != 0)
 		last_time.tv_sec = 0;
@@ -2327,6 +2331,8 @@ child (void * param)
 	 */
 	post_config_state(DAEMON_CONFIGURE);
 
+	init_path_check_interval(vecs);
+
 	/*
 	 * Start uevent listener early to catch events
 	 */
-- 
2.10.0
