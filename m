From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 2/7] multipathd: remove
	init_path_check_interval()
Date: Tue, 30 Oct 2018 22:22:44 +0100
Message-ID: <20181030212249.31127-3-mwilck@suse.com>
References: <20181030212249.31127-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181030212249.31127-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
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
index c24b2b99..e81b9c9e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2130,19 +2130,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
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
@@ -2726,7 +2713,6 @@ child (void * param)
 	 */
 	post_config_state(DAEMON_CONFIGURE);
 
-	init_path_check_interval(vecs);
 
 	if (poll_dmevents) {
 		if (init_dmevent_waiter(vecs)) {
-- 
2.19.1
