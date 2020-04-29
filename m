From: heinzm@redhat.com
Subject: [PATCH] dm ebs: fix bio->bi_status assignment
Date: Wed, 29 Apr 2020 17:07:09 +0200
Message-ID: <dff475cd16489080bb229af9bb45c0d67480b8be.1588172814.git.heinzm@redhat.com>
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
To: dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Assign blk_status_t to bi_status properly in __ebs_process_bios()
on error (flaw found by static checker).

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-ebs-target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 97703c31771f..c9c66d6b1e56 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -210,7 +210,8 @@ static void __ebs_process_bios(struct work_struct *ws)
 			r = __ebs_discard_bio(ec, bio);
 		}
 
-		bio->bi_status = r;
+		if (r < 0)
+			bio->bi_status = BLK_STS_IOERR;
 	}
 
 	/*
-- 
2.25.4
