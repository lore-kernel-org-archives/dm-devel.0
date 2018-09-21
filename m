From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v3 11/19] libmultipath: fix null dereference int
	alloc_path_group
Date: Fri, 21 Sep 2018 18:05:19 -0500
Message-ID: <1537571127-10143-12-git-send-email-bmarzins@redhat.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If all_pathgroup failed to allocate a vector for pgp->paths, instead of
failing after it freed pgp, it would set pgp to NULL and then
dereference it. This patch fixes that. Found by coverity.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index ae847d6..caa178a 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -165,7 +165,7 @@ alloc_pathgroup (void)
 
 	if (!pgp->paths) {
 		FREE(pgp);
-		pgp = NULL;
+		return NULL;
 	}
 
 	dm_pathgroup_to_gen(pgp)->ops = &dm_gen_pathgroup_ops;
-- 
2.7.4
