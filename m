From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/39] libmultipath: free pathgroup in
	group_by_prio()
Date: Thu, 16 Jun 2016 11:47:10 +0200
Message-ID: <1466070465-1021-5-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

If we encounter an error when storing the pathgroup or paths
the pathgroup is never deallocated.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/pgpolicies.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index 2981d51..f440441 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -341,8 +341,10 @@ group_by_prio (struct multipath * mp)
 		if (!pgp)
 			goto out;
 
-		if (store_path(pgp->paths, VECTOR_SLOT(mp->paths, 0)))
-				goto out;
+		if (store_path(pgp->paths, VECTOR_SLOT(mp->paths, 0))) {
+			free_pathgroup(pgp, KEEP_PATHS);
+			goto out;
+		}
 
 		vector_del_slot(mp->paths, 0);
 
@@ -350,11 +352,15 @@ group_by_prio (struct multipath * mp)
 		 * Store the new path group into the vector.
 		 */
 		if (i < VECTOR_SIZE(mp->pg)) {
-			if (!vector_insert_slot(mp->pg, i, pgp))
+			if (!vector_insert_slot(mp->pg, i, pgp)) {
+				free_pathgroup(pgp, KEEP_PATHS);
 				goto out;
+			}
 		} else {
-			if (store_pathgroup(mp->pg, pgp))
+			if (store_pathgroup(mp->pg, pgp)) {
+				free_pathgroup(pgp, KEEP_PATHS);
 				goto out;
+			}
 		}
 
 		/*
-- 
2.6.6
