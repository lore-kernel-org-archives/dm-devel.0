From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm transaction manager: fix shadow_info leaks on
	dm_tm_destroy
Date: Mon, 18 Jun 2012 21:04:04 -0400
Message-ID: <1340067844-3321-1-git-send-email-snitzer@redhat.com>
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
To: agk@redhat.com
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

Cleanup the shadow table before destroying the transaction manager.

reference: leak was identified with kmemleak when running
test_discard_random_sectors in the thinp-test-suite.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 .../md/persistent-data/dm-transaction-manager.c    |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index 400fe14..02bf78e 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -138,6 +138,9 @@ EXPORT_SYMBOL_GPL(dm_tm_create_non_blocking_clone);
 
 void dm_tm_destroy(struct dm_transaction_manager *tm)
 {
+	if (!tm->is_clone)
+		wipe_shadow_table(tm);
+
 	kfree(tm);
 }
 EXPORT_SYMBOL_GPL(dm_tm_destroy);
-- 
1.7.4.4
