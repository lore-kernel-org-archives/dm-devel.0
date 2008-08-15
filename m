From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 05/10] dm snapshot: add get_snapshot_info hook to
	struct exception_store
Date: Fri, 15 Aug 2008 15:42:46 +0900
Message-ID: <1218782571-15290-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1218782571-15290-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1218782571-15290-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

dm-snap can use this interface to get the information of available
snapshots (such as the number of current snapshots) from exception
store code.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-snap.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-snap.h b/drivers/md/dm-snap.h
index 3d43307..4eefb90 100644
--- a/drivers/md/dm-snap.h
+++ b/drivers/md/dm-snap.h
@@ -139,6 +139,12 @@ struct exception_store {
 	int (*message)(struct exception_store *store, unsigned argc,
 		       char **argv);
 
+	/*
+	 * get the info about available snapshot
+	 */
+	u32 (*get_snapshot_info)(struct exception_store *store,
+				 unsigned long *map, size_t size);
+
 	struct dm_snapshot *snap;
 	void *context;
 };
-- 
1.5.5.GIT
