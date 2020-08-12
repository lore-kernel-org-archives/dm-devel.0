From: mwilck@suse.com
Subject: [PATCH v2 40/42] libmultipath: free_multipath(): remove
	mpp references
Date: Wed, 12 Aug 2020 13:34:04 +0200
Message-ID: <20200812113405.26206-2-mwilck@suse.com>
References: <20200812113405.26206-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200812113405.26206-1-mwilck@suse.com>
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

If free_paths is false, make sure no references to the dropped
multipath remain. Otherwise multipathd may crash later when
trying to access these.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index da898b7..d227ec0 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -258,6 +258,21 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
 		mpp->dmi = NULL;
 	}
 
+	if (!free_paths && mpp->pg) {
+		struct pathgroup *pgp;
+		struct path *pp;
+		int i, j;
+
+		/*
+		 * Make sure paths carry no reference to this mpp any more
+		 */
+		vector_foreach_slot(mpp->pg, pgp, i) {
+			vector_foreach_slot(pgp->paths, pp, j)
+				if (pp->mpp == mpp)
+					pp->mpp = NULL;
+		}
+	}
+
 	free_pathvec(mpp->paths, free_paths);
 	free_pgvec(mpp->pg, free_paths);
 	FREE_PTR(mpp->mpcontext);
-- 
2.28.0
