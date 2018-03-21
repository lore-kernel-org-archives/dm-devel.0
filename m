From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/2] libmultipath: don't reject maps with
	undefined prio
Date: Wed, 21 Mar 2018 10:34:18 +0100
Message-ID: <20180321093419.9295-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

libmultipath's prio routines can deal with pp->priority == PRIO_UNDEF
just fine. PRIO_UNDEF is just a very low priority. So there's
no reason to reject setting up a multipath map because paths have
undefined priority.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index fa6e21cb31af..bb3d8771592d 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -993,9 +993,6 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 			continue;
 		}
 
-		if (pp1->priority == PRIO_UNDEF)
-			mpp->action = ACT_REJECT;
-
 		if (!mpp->paths) {
 			condlog(0, "%s: skip coalesce (no paths)", mpp->alias);
 			remove_map(mpp, vecs, 0);
@@ -1021,8 +1018,6 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 					mpp->size);
 				mpp->action = ACT_REJECT;
 			}
-			if (pp2->priority == PRIO_UNDEF)
-				mpp->action = ACT_REJECT;
 		}
 		verify_paths(mpp, vecs);
 
-- 
2.16.1
