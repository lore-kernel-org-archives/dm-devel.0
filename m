From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 8/8] dm core: add integrity feature to
	request-based dm
Date: Wed, 18 Mar 2009 17:58:15 +0900
Message-ID: <49C0B7A7.4020808@ct.jp.nec.com>
References: <49C0B474.4000204@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49C0B474.4000204@ct.jp.nec.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, martin.petersen@oracle.com
List-Id: dm-devel.ids

This patch clones integrity payload in request-based dm code path.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: 2.6.29-rc8/drivers/md/dm.c
===================================================================
--- 2.6.29-rc8.orig/drivers/md/dm.c
+++ 2.6.29-rc8/drivers/md/dm.c
@@ -1385,6 +1385,11 @@ static int clone_request_bios(struct req
 		}
 
 		__bio_clone(clone_bio, bio);
+		if (bio_integrity(bio))
+			if (bio_integrity_clone(clone_bio, bio, GFP_ATOMIC,
+						md->bs) < 0)
+				goto free_and_out;
+
 		clone_bio->bi_destructor = dm_bio_destructor;
 		clone_bio->bi_end_io = end_clone_bio;
 		info->rq = clone;
