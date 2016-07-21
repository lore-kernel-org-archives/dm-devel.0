From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH] multipathd: fix typo that breaks failure path
Date: Thu, 21 Jul 2016 15:59:40 -0500
Message-ID: <1469134780-13163-1-git-send-email-bmarzins@redhat.com>
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
To: dm-devel@redhat.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

There wasn't supposed to be a semicolon after the "else" when checking
paths in checkerloop().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index c129298..d90d856 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1790,7 +1790,7 @@ checkerloop (void *ap)
 					vector_del_slot(vecs->pathvec, i);
 					free_path(pp);
 					i--;
-				} else;
+				} else
 					num_paths += rc;
 			}
 			lock_cleanup_pop(vecs->lock);
-- 
1.8.3.1
