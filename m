From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/9] dm snapshot: add message hook to struct
	exception_store
Date: Thu, 27 Nov 2008 01:17:33 +0900
Message-ID: <1227716259-31952-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1227716259-31952-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1227716259-31952-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1227716259-31952-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1227716259-31952-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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

This enables exception store code to handle the message hook in struct
target_type. Exception store implementations can provide useful
features such as providing delta between two snapshots to user space.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-snap.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-snap.h b/drivers/md/dm-snap.h
index 579ac9d..6a8a4d8 100644
--- a/drivers/md/dm-snap.h
+++ b/drivers/md/dm-snap.h
@@ -132,6 +132,13 @@ struct exception_store {
 	struct dm_snap_exception *(*lookup_completed_exception)
 	(struct exception_store *store, chunk_t chunk);
 
+	/*
+	 * let exception store code to handle the message hook in
+	 * struct target_type.
+	 */
+	int (*message)(struct exception_store *store, unsigned argc,
+		       char **argv);
+
 	struct dm_snapshot *snap;
 	void *context;
 };
-- 
1.5.5.GIT
