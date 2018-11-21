From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 18/19] multipathd: uev_remove_path: remove
	redundant orphan_paths call
Date: Wed, 21 Nov 2018 11:18:38 +0100
Message-ID: <20181121101839.30784-19-mwilck@suse.com>
References: <20181121101839.30784-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181121101839.30784-1-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 79c8ed1e..0c248046 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -787,7 +787,6 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
 		goto out;
 	}
 
-	orphan_paths(vecs->pathvec, mpp);
 	remove_map_and_stop_waiter(mpp, vecs);
 out:
 	lock_cleanup_pop(vecs->lock);
-- 
2.19.1
