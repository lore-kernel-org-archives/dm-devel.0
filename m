From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 07/16] libmultipath: make one_group allocate a
	new vector
Date: Fri,  2 Aug 2019 11:33:33 -0500
Message-ID: <1564763622-31752-8-git-send-email-bmarzins@redhat.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, Muneendra Kumar <mkumar@redhat.com>
List-Id: dm-devel.ids

All the pgpolicy functions besides one_group() allocate a new vector for
the pathgroups. If one_group() works the same, it is easier to factor
out the common code.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/pgpolicies.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index d447c46e..1af42f52 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -267,24 +267,24 @@ out:
 
 int one_group(struct multipath *mp)	/* aka multibus */
 {
+	int i;
+	struct path * pp;
 	struct pathgroup * pgp;
 
-	if (VECTOR_SIZE(mp->paths) > 0) {
-		pgp = alloc_pathgroup();
+	pgp = alloc_pathgroup();
 
-		if (!pgp)
-			goto out;
+	if (!pgp)
+		goto out;
 
-		vector_free(pgp->paths);
+	if (add_pathgroup(mp, pgp))
+		goto out1;
 
-		if (add_pathgroup(mp, pgp))
-			goto out1;
+	for (i = 0; i < VECTOR_SIZE(mp->paths); i++) {
+		pp = VECTOR_SLOT(mp->paths, i);
 
-		pgp->paths = mp->paths;
-		/* Do this to avoid freeing vector in group_paths */
-		mp->paths = NULL;
+		if (store_path(pgp->paths, pp))
+			goto out;
 	}
-
 	return 0;
 out1:
 	free_pathgroup(pgp, KEEP_PATHS);
-- 
2.17.2
