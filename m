From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 7/8] multipathd: unset mpp->hwe when removing
	map
Date: Tue, 11 Aug 2020 16:58:42 -0500
Message-ID: <1597183123-15797-8-git-send-email-bmarzins@redhat.com>
References: <1597183123-15797-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1597183123-15797-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

If the map doesn't unset its hwe pointer before orphaning all the paths,
multipathd will print a warning message in orphan_path() because of
commit "libmultipath: warn if freeing path that holds mpp->hwe".

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 1 +
 multipathd/main.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index ede14297..103ea11e 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -129,6 +129,7 @@ remove_map(struct multipath * mpp, struct vectors * vecs, int purge_vec)
 	/*
 	 * clear references to this map
 	 */
+	mpp->hwe = NULL;
 	orphan_paths(vecs->pathvec, mpp, "map removed internally");
 
 	if (purge_vec &&
diff --git a/multipathd/main.c b/multipathd/main.c
index f014d2a1..2b0e2734 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -666,6 +666,7 @@ flush_map(struct multipath * mpp, struct vectors * vecs, int nopaths)
 		condlog(2, "%s: map flushed", mpp->alias);
 	}
 
+	mpp->hwe = NULL;
 	orphan_paths(vecs->pathvec, mpp, "map flushed");
 	remove_map_and_stop_waiter(mpp, vecs);
 
-- 
2.17.2
