From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: [PATCH 2/2] dm: fix ioctl retry termination with signal
Date: Tue, 17 Nov 2015 09:39:26 +0000
Message-ID: <20151117093925.GB13022@xzibit.linux.bs1.fc.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: ja-JP
Content-ID: <ED4F2569E887D44C8A2F365C77C56B37@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

dm-mpath retries ioctl, when no path is readily available and the device
is configured to queue I/O in such a case. If you want to stop the retry
before multipathd decides to turn off queueing mode, you could send
signal for the process to exit from the loop.

However the check of fatal signal has not carried along when commit
6c182cd88d17 ("dm mpath: fix ioctl deadlock when no paths") moved the
loop from dm-mpath to dm core. As a result, we can't terminate such
a process in the retry loop.

Easy reproducer of the situation is:

  # dmsetup create mp --table '0 1024 multipath 0 0 0 0'
  # dmsetup message mp 0 'queue_if_no_path'
  # sg_inq /dev/mapper/mp

then you should be able to terminate sg_inq by pressing Ctrl+C.

Fixes: 6c182cd88d17 ("dm mpath: fix ioctl deadlock when no paths")
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-mpath.c | 2 +-
 drivers/md/dm.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0ad50ff..cfa29f5 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1564,7 +1564,7 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	if (r == -ENOTCONN && !fatal_signal_pending(current)) {
+	if (r == -ENOTCONN) {
 		spin_lock_irqsave(&m->lock, flags);
 		if (!m->current_pg) {
 			/* Path status changed, redo selection */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6e15f35..fabd5d8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -591,7 +591,7 @@ retry:
 
 out:
 	dm_put_live_table(md, *srcu_idx);
-	if (r == -ENOTCONN) {
+	if (r == -ENOTCONN && !fatal_signal_pending(current)) {
 		msleep(10);
 		goto retry;
 	}
-- 
2.4.3
