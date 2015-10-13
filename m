From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] dm snapshot: fix memory leak in error path
Date: Tue, 13 Oct 2015 14:36:38 +0200
Message-ID: <1444739798-21892-1-git-send-email-michael.opdenacker@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Opdenacker <michael.opdenacker@free-electrons.com>
List-Id: dm-devel.ids

Fix a memory leak in an error path (reported by Coverity CID 1326059)
Also add a missing workqueue deallocation in the same error path.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/md/dm-snap-persistent.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index aeacad9be51d..1e980fa8bb8b 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -879,6 +879,8 @@ static int persistent_ctr(struct dm_exception_store *store, char *options)
 			store->userspace_supports_overflow = true;
 		else {
 			DMERR("Unsupported persistent store option: %s", options);
+			destroy_workqueue(ps->metadata_wq);
+			kfree(ps);
 			return -EINVAL;
 		}
 	}
-- 
2.1.4
