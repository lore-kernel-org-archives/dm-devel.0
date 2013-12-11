From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 12/16] multipathd: Don't touch the multipath
	device after setup_multipath fails
Date: Wed, 11 Dec 2013 00:43:06 -0600
Message-ID: <1386744190-1295-13-git-send-email-bmarzins@redhat.com>
References: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

If setup_multipath fails, it removes the device. multipath always needs
to check its return value and not touch the device if setup_multipath
failed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c |  3 ++-
 multipathd/main.c         | 12 ++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 58a5643..baa43c4 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -634,7 +634,8 @@ cli_resize(void *v, char **reply, int *len, void *data)
 		return 1;
 
 	dm_lib_release();
-	setup_multipath(vecs, mpp);
+	if (setup_multipath(vecs, mpp) != 0)
+		return 1;
 	sync_map_state(mpp);
 
 	return 0;
diff --git a/multipathd/main.c b/multipathd/main.c
index 204fbb1..49e74a6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -139,7 +139,6 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 	struct multipath * ompp;
 	vector ompv = vecs->mpvec;
 	unsigned int i;
-	int j;
 
 	vector_foreach_slot (ompv, ompp, i) {
 		condlog(3, "%s: coalesce map", ompp->alias);
@@ -154,16 +153,17 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 				/*
 				 * may be just because the device is open
 				 */
+				if (setup_multipath(vecs, ompp) != 0) {
+					i--;
+					continue;
+				}
 				if (!vector_alloc_slot(nmpv))
 					return 1;
 
 				vector_set_slot(nmpv, ompp);
-				setup_multipath(vecs, ompp);
 
-				if ((j = find_slot(ompv, (void *)ompp)) != -1)
-					vector_del_slot(ompv, j);
-
-				continue;
+				vector_del_slot(ompv, i);
+				i--;
 			}
 			else {
 				dm_lib_release();
-- 
1.8.4.2
