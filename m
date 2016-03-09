From: Vladimir Zapolskiy <vz@mleia.com>
Subject: [PATCH] dm: log writes: fix check of kthread_run() return value
Date: Thu, 10 Mar 2016 01:22:19 +0200
Message-ID: <1457565739-32039-1-git-send-email-vz@mleia.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

The kthread_run() function returns either a valid task_struct or
ERR_PTR() value, check for NULL is invalid. The change fixes potential
oops, e.g. in OOM situation.

Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
---
 drivers/md/dm-log-writes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 624589d..c2f2972 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -456,9 +456,9 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	ret = -EINVAL;
 	lc->log_kthread = kthread_run(log_writes_kthread, lc, "log-write");
-	if (!lc->log_kthread) {
+	if (IS_ERR(lc->log_kthread)) {
+		ret = PTR_ERR(lc->log_kthread);
 		ti->error = "Couldn't alloc kthread";
 		dm_put_device(ti, lc->dev);
 		dm_put_device(ti, lc->logdev);
-- 
2.1.4

