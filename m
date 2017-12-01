From: heinzm@redhat.com
Subject: [PATCH 07/10] dm raid: group rw and in_sync definitions
	with mddev_resume()
Date: Fri,  1 Dec 2017 01:02:25 +0100
Message-ID: <20171201000228.32677-8-heinzm@redhat.com>
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
Cc: heinzm@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm-raid.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 7fbb31ed9147..1c06417944d7 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3937,9 +3937,6 @@ static void raid_resume(struct dm_target *ti)
 		attempt_restore_of_faulty_devices(rs);
 	}
 
-	mddev->ro = 0;
-	mddev->in_sync = 0;
-
 	/* Only reduce raid set size before running a disk removing reshape. */
 	if (mddev->delta_disks < 0)
 		rs_set_capacity(rs);
@@ -3963,6 +3960,8 @@ static void raid_resume(struct dm_target *ti)
 
 	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
 		mddev_lock_nointr(mddev);
+		mddev->ro = 0;
+		mddev->in_sync = 0;
 		mddev_resume(mddev);
 		mddev_unlock(mddev);
 	}
-- 
2.13.6
