From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 18/24] multipathd: uev_remove_path: remove
	redundant orphan_paths call
Date: Mon, 10 Dec 2018 10:49:53 +0100
Message-ID: <20181210094959.11338-19-mwilck@suse.com>
References: <20181210094959.11338-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210094959.11338-1-mwilck@suse.com>
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

The remove_map_and_stop_waiter() call which follows immediately
will do the same thing.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 4d7c2598..5e6c35d4 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -786,7 +786,6 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
 		goto out;
 	}
 
-	orphan_paths(vecs->pathvec, mpp);
 	remove_map_and_stop_waiter(mpp, vecs);
 out:
 	lock_cleanup_pop(vecs->lock);
-- 
2.19.2
