From: Nicholas Krause <xerofoify@gmail.com>
Subject: [PATCH RESEND] md:Check if call to thaw_bdev fails in
	unlock_fs
Date: Thu, 14 Jan 2016 16:05:56 -0500
Message-ID: <1452805556-21972-1-git-send-email-xerofoify@gmail.com>
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
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, neilb@suse.com, snitzer@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This adds a check to the function unlock_fs to check if the call
to thaw_bdev failed by returning a return code and if so print
on the log level of KERN_CRIT that the thaw has failed on the
passed device structure pointer's name before returnin immediately
to this function's caller.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/md/dm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ab37ae1..20ccc36 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3152,7 +3152,11 @@ static void unlock_fs(struct mapped_device *md)
 	if (!test_bit(DMF_FROZEN, &md->flags))
 		return;
 
-	thaw_bdev(md->bdev, md->frozen_sb);
+	if (!thaw_bdev(md->bdev, md->frozen_sb)) {
+		pr_crit("Thaw failed on the file device %s\n", md->name);
+		return;
+	}
+
 	md->frozen_sb = NULL;
 	clear_bit(DMF_FROZEN, &md->flags);
 }
-- 
2.1.4
