From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/4] dm core: use BUG_ON in dm_end_request()
Date: Fri, 19 Jun 2009 16:49:14 +0900
Message-ID: <4A3B42FA.1010005@ct.jp.nec.com>
References: <4A3B40D4.1040905@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A3B40D4.1040905@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch replaces free_bio_clone() in dm_end_request() with BUG_ON().

free_bio_clone() was there to clean up clone.  However it is
definitely a bug if clone still has bios in dm_end_request().
So use BUG_ON() instead.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.31-rc/drivers/md/dm.c
===================================================================
--- 2.6.31-rc.orig/drivers/md/dm.c
+++ 2.6.31-rc/drivers/md/dm.c
@@ -845,7 +845,7 @@ static void dm_end_request(struct reques
 			rq->sense_len = clone->sense_len;
 	}
 
-	free_bio_clone(md, clone);
+	BUG_ON(clone->bio);
 	free_rq_tio(md, tio);
 
 	blk_end_request_all(rq, error);
