From: Andrei Warkentin <andrey.warkentin@gmail.com>
Subject: [PATCH] DM: Minor fix to dm-snap metadata backend registration.
Date: Fri, 24 Feb 2012 21:26:52 -0500
Message-ID: <1330136812-4377-1-git-send-email-andrey.warkentin@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, andreiw@vmware.com, Andrei Warkentin <andrey.warkentin@gmail.com>
List-Id: dm-devel.ids

Cleanup in dm_exception_store_init was messed up.

Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>
---
 drivers/md/dm-exception-store.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 042e719..aa70f7d 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -283,7 +283,7 @@ int dm_exception_store_init(void)
 	return 0;
 
 persistent_fail:
-	dm_persistent_snapshot_exit();
+	dm_transient_snapshot_exit();
 transient_fail:
 	return r;
 }
-- 
1.7.8.3
