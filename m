From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 2/7] multipathd: remove
	init_path_check_interval()
Date: Fri,  2 Nov 2018 13:23:57 +0100
Message-ID: <20181102122402.31145-3-mwilck@suse.com>
References: <20181102122402.31145-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181102122402.31145-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

After "libmultipath: set pp->checkint in store_pathinfo()",
pp-checkint should always be properly initialized, so this code
is not needed any more.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 958545a4..dfc10e54 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2133,19 +2133,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	return 1;
 }
 
-static void init_path_check_interval(struct vectors *vecs)
-{
-	struct config *conf;
-	struct path *pp;
-	unsigned int i;
-
-	vector_foreach_slot (vecs->pathvec, pp, i) {
-		conf = get_multipath_config();
-		pp->checkint = conf->checkint;
-		put_multipath_config(conf);
-	}
-}
-
 static void *
 checkerloop (void *ap)
 {
@@ -2729,7 +2716,6 @@ child (void * param)
 	 */
 	post_config_state(DAEMON_CONFIGURE);
 
-	init_path_check_interval(vecs);
 
 	if (poll_dmevents) {
 		if (init_dmevent_waiter(vecs)) {
-- 
2.19.1
