From: mwilck@suse.com
Subject: [PATCH 09/35] libmultipath: use bitfields in
	group_by_match()
Date: Thu,  9 Jul 2020 12:15:54 +0200
Message-ID: <20200709101620.6786-10-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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

From: Martin Wilck <mwilck@suse.com>

This makes "bitmap" a proper bitmap, and decreases memory consumption.
Unit tests for pgpolicy.c still pass.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/pgpolicies.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index 02cafdc..0e55109 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -196,20 +196,20 @@ int group_by_match(struct multipath * mp, vector paths,
 		   bool (*path_match_fn)(struct path *, struct path *))
 {
 	int i, j;
-	int * bitmap;
+	struct bitfield *bitmap;
 	struct path * pp;
 	struct pathgroup * pgp;
 	struct path * pp2;
 
 	/* init the bitmap */
-	bitmap = (int *)MALLOC(VECTOR_SIZE(paths) * sizeof (int));
+	bitmap = alloc_bitfield(VECTOR_SIZE(paths));
 
 	if (!bitmap)
 		goto out;
 
 	for (i = 0; i < VECTOR_SIZE(paths); i++) {
 
-		if (bitmap[i])
+		if (is_bit_set_in_bitfield(i, bitmap))
 			continue;
 
 		pp = VECTOR_SLOT(paths, i);
@@ -227,11 +227,11 @@ int group_by_match(struct multipath * mp, vector paths,
 		if (store_path(pgp->paths, pp))
 			goto out1;
 
-		bitmap[i] = 1;
+		set_bit_in_bitfield(i, bitmap);
 
 		for (j = i + 1; j < VECTOR_SIZE(paths); j++) {
 
-			if (bitmap[j])
+			if (is_bit_set_in_bitfield(j, bitmap))
 				continue;
 
 			pp2 = VECTOR_SLOT(paths, j);
@@ -240,7 +240,7 @@ int group_by_match(struct multipath * mp, vector paths,
 				if (store_path(pgp->paths, pp2))
 					goto out1;
 
-				bitmap[j] = 1;
+				set_bit_in_bitfield(j, bitmap);
 			}
 		}
 	}
-- 
2.26.2
