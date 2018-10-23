From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/7] multipathd: remove init_path_check_interval()
Date: Wed, 24 Oct 2018 00:05:47 +0200
Message-ID: <20181023220552.1306-3-mwilck@suse.com>
References: <20181023220552.1306-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181023220552.1306-1-mwilck@suse.com>
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
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

After "libmultipath: set pp->checkint in store_pathinfo()",
pp-checkint should always be properly initialized, so this code
is not needed any more.

Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index b8423d89..3464ebfa 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2131,19 +2131,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
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
@@ -2727,7 +2714,6 @@ child (void * param)
 	 */
 	post_config_state(DAEMON_CONFIGURE);
 
-	init_path_check_interval(vecs);
 
 	if (poll_dmevents) {
 		if (init_dmevent_waiter(vecs)) {
-- 
2.19.1
