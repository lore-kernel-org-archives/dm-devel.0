From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH V2 09/12] dm raid: group rw and in_sync
	definitions with mddev_resume()
Date: Sat,  2 Dec 2017 01:03:56 +0100
Message-ID: <cfecba1ac3a41800920fa4cd6c9f8b6180796eb9.1512171097.git.heinzm@redhat.com>
References: <cover.1512171097.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1512171097.git.heinzm@redhat.com>
In-Reply-To: <cover.1512171097.git.heinzm@redhat.com>
References: <cover.1512171097.git.heinzm@redhat.com>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

---
 drivers/md/dm-raid.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 1a652772224a..75b0ce91a3f0 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3950,9 +3950,6 @@ static void raid_resume(struct dm_target *ti)
 		attempt_restore_of_faulty_devices(rs);
 	}
 
-	mddev->ro = 0;
-	mddev->in_sync = 0;
-
 	/* Only reduce raid set size before running a disk removing reshape. */
 	if (mddev->delta_disks < 0)
 		rs_set_capacity(rs);
@@ -3976,6 +3973,8 @@ static void raid_resume(struct dm_target *ti)
 
 	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
 		mddev_lock_nointr(mddev);
+		mddev->ro = 0;
+		mddev->in_sync = 0;
 		mddev_resume(mddev);
 		mddev_unlock(mddev);
 	}
-- 
2.13.6
