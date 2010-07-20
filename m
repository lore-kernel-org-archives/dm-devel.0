From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Fix typo in coalesce_paths
Date: Tue, 20 Jul 2010 10:10:25 +0200
Message-ID: <20100720081025.CC3E729EF6@ochil.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


We allocate space for the alias, but never use it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index c6ca4b6..f32a484 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -577,11 +577,11 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 
 			remove_map(mpp, vecs, 0);
 
-			if (dm_flush_map(mpp->alias))
+			if (dm_flush_map(alias))
 				condlog(2, "%s: remove failed (dead)",
-					mpp->alias);
+					alias);
 			else
-				condlog(2, "%s: remove (dead)", mpp->alias);
+				condlog(2, "%s: remove (dead)", alias);
 		}
 	}
 	return 0;
-- 
1.6.0.2
