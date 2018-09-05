From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 2/5] dm-raid: fix stripe adding reshape deadlock
Date: Wed,  5 Sep 2018 19:36:42 +0200
Message-ID: <344f4b6d298b2e4058bd57e7197c3914a9040ba5.1536167421.git.heinzm@redhat.com>
References: <cover.1536167421.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1536167421.git.heinzm@redhat.com>
In-Reply-To: <cover.1536167421.git.heinzm@redhat.com>
References: <cover.1536167421.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

When initiating a stripe adding reshape, a deadlock between
md_stop_writes() waiting for the sync thread to stop and the
running sync thread waiting for inactive stripes occurs
(this frequently happens on single-core but rarely
 on multi-core systems).

Resolve by setting MD_RECOVERY_WAIT to request the main MD
resynchronization thread worker function md_do_sync() to bail
out when initiating the reshape via constructor arguments.
Don't set the flag when reloading without those arguments and
avoid superfluous mddev_{suspend,resume} setting up reshape.

Passes all lvm2 raid tests.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/dm-raid.txt |  1 +
 drivers/md/dm-raid.c                    | 13 ++++---------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index f68d06d6f28b..efb73f521568 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -349,3 +349,4 @@ Version History
 	state races.
 1.13.2  Fix raid redundancy validation and avoid keeping raid set frozen
 1.13.3  Fix reshape race on small devices
+1.14.0  Fix stripe adding reshape deadlock/potential data corruption
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index ecb7706f7330..03dd915eff9e 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3871,14 +3871,13 @@ static int rs_start_reshape(struct raid_set *rs)
 	struct mddev *mddev = &rs->md;
 	struct md_personality *pers = mddev->pers;
 
+	/* Don't allow the sync thread to work until the table gets reloaded. */
+	set_bit(MD_RECOVERY_WAIT, &mddev->recovery);
+
 	r = rs_setup_reshape(rs);
 	if (r)
 		return r;
 
-	/* Need to be resumed to be able to start reshape, recovery is frozen until raid_resume() though */
-	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
-		mddev_resume(mddev);
-
 	/*
 	 * Check any reshape constraints enforced by the personalility
 	 *
@@ -3902,10 +3901,6 @@ static int rs_start_reshape(struct raid_set *rs)
 		}
 	}
 
-	/* Suspend because a resume will happen in raid_resume() */
-	set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags);
-	mddev_suspend(mddev);
-
 	/*
 	 * Now reshape got set up, update superblocks to
 	 * reflect the fact so that a table reload will
@@ -4002,7 +3997,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 13, 3},
+	.version = {1, 14, 0},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.17.1
