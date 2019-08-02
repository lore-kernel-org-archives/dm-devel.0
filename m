From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 06/16] libmultipath: remove store_pathgroup
Date: Fri,  2 Aug 2019 11:33:32 -0500
Message-ID: <1564763622-31752-7-git-send-email-bmarzins@redhat.com>
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

store_pathgroup() is only called by add_pathgroup(), and doesn't need to
exist as a seperate function.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.c | 16 +++-------------
 libmultipath/structs.h |  1 -
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index fee899bd..bf7fdd73 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -318,23 +318,13 @@ store_path (vector pathvec, struct path * pp)
 	return 0;
 }
 
-int
-store_pathgroup (vector pgvec, struct pathgroup * pgp)
+int add_pathgroup(struct multipath *mpp, struct pathgroup *pgp)
 {
-	if (!vector_alloc_slot(pgvec))
+	if (!vector_alloc_slot(mpp->pg))
 		return 1;
 
-	vector_set_slot(pgvec, pgp);
-
-	return 0;
-}
-
-int add_pathgroup(struct multipath *mpp, struct pathgroup *pgp)
-{
-	int ret = store_pathgroup(mpp->pg, pgp);
+	vector_set_slot(mpp->pg, pgp);
 
-	if (ret)
-		return ret;
 	pgp->mpp = mpp;
 	return 0;
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 1a3d827b..893074eb 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -445,7 +445,6 @@ int store_adaptergroup(vector adapters, struct adapter_group *agp);
 int store_hostgroup(vector hostgroupvec, struct host_group *hgp);
 
 int store_path (vector pathvec, struct path * pp);
-int store_pathgroup (vector pgvec, struct pathgroup * pgp);
 int add_pathgroup(struct multipath*, struct pathgroup *);
 
 struct multipath * find_mp_by_alias (const struct _vector *mp, const char *alias);
-- 
2.17.2
