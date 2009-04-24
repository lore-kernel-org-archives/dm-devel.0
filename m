From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 2/7] dm core: add integrity feature to
	request-based dm
Date: Fri, 24 Apr 2009 17:13:28 +0900
Message-ID: <49F174A8.1010703@ct.jp.nec.com>
References: <49F17409.4060201@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49F17409.4060201@ct.jp.nec.com>
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

This patch clones integrity payload in request-based dm code path.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: 2.6.30-rc3/drivers/md/dm.c
===================================================================
--- 2.6.30-rc3.orig/drivers/md/dm.c
+++ 2.6.30-rc3/drivers/md/dm.c
@@ -1375,6 +1375,14 @@ static int clone_request_bios(struct req
 		}
 
 		__bio_clone(clone_bio, bio);
+
+		if (bio_integrity(bio) &&
+		    !bio_integrity_clone(clone_bio, bio, GFP_ATOMIC)) {
+			bio_free(clone_bio, md->bs);
+			free_bio_info(md, info);
+			goto free_and_out;
+		}
+
 		clone_bio->bi_destructor = dm_bio_destructor;
 		clone_bio->bi_end_io = end_clone_bio;
 		info->rq = clone;
