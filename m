From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 3/8] md/raid5: use sysfs_notify_dirent_safe to avoid NULL pointer
Date: Mon, 20 Dec 2010 21:37:40 -0500
Message-ID: <1292899065-31943-4-git-send-email-snitzer@redhat.com>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: jbrassow@redhat.com, neilb@suse.de
Cc: agk@redhat.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: Jonathan Brassow <jbrassow@redhat.com>

With the module parameter 'start_dirty_degraded' set,
raid5_spare_active() previously called sysfs_notify_dirent() with a NULL
argument (rdev->sysfs_state) when a rebuild finished.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dc574f3..3219fd9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5339,7 +5339,7 @@ static int raid5_spare_active(mddev_t *mddev)
 		    && !test_bit(Faulty, &tmp->rdev->flags)
 		    && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
 			count++;
-			sysfs_notify_dirent(tmp->rdev->sysfs_state);
+			sysfs_notify_dirent_safe(tmp->rdev->sysfs_state);
 		}
 	}
 	spin_lock_irqsave(&conf->device_lock, flags);
-- 
1.7.2.3

