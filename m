From: heinzm@redhat.com
Subject: [PATCH] [REGRESSION] md: md.c: fix oops in mddev_suspend
	for raid0
Date: Mon,  9 May 2016 17:50:42 +0200
Message-ID: <1462809042-2974-1-git-send-email-heinzm@redhat.com>
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
To: dm-devel@redhat.com
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Introduced by upstream commit 70d9798b95562abac005d4ba71d28820f9a201eb

The raid0 personality does not create mddev->thread as oposed to
other personalities leading to its unconditional access in
mddev_suspend() causing an oops.

Patch checks for mddev->thread in order to keep the
intention of aforementioned commit.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>


---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 194580f..d91920d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -305,7 +305,7 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
  */
 void mddev_suspend(struct mddev *mddev)
 {
-	WARN_ON_ONCE(current == mddev->thread->tsk);
+	WARN_ON_ONCE(mddev->thread && current == mddev->thread->tsk);
 	if (mddev->suspended++)
 		return;
 	synchronize_rcu();
-- 
2.5.5
