From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] multipathd: fix mpp->hwe handling on path removal
Date: Mon, 25 Jun 2018 17:10:20 +0200
Message-ID: <20180625151020.31927-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

In my previous patch f0462f0c8338, I overlooked that during path removal,
the path that mpp->hwe references may be removed and and thus mpp->hwe
may become stale. Fix it.

Fixes: f0462f0c8338 "libmultipath: use vector for for pp->hwe and mp->hwe"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 72f06b56..cc493c18 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1076,6 +1076,14 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 				mpp->alias);
 			goto fail;
 		}
+
+		/*
+		 * Make sure mpp->hwe doesn't point to freed memory
+		 * We call extract_hwe_from_path() below to restore mpp->hwe
+		 */
+		if (mpp->hwe == pp->hwe)
+			mpp->hwe = NULL;
+
 		if ((i = find_slot(mpp->paths, (void *)pp)) != -1)
 			vector_del_slot(mpp->paths, i);
 
@@ -1109,6 +1117,9 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 			 */
 		}
 
+		if (mpp->hwe == NULL)
+			extract_hwe_from_path(mpp);
+
 		if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
 			condlog(0, "%s: failed to setup map for"
 				" removal of path %s", mpp->alias, pp->dev);
-- 
2.17.1
