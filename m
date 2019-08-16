From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: [PATCH v2 1/2] md raid0/linear: Introduce new array
	state 'broken'
Date: Fri, 16 Aug 2019 10:40:58 -0300
Message-ID: <20190816134059.29751-1-gpiccoli@canonical.com>
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
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, gpiccoli@canonical.com, NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, jay.vosburgh@canonical.com
List-Id: dm-devel.ids

Currently if md raid0/linear array gets one or more members removed while
being mounted, kernel keeps showing state 'clean' in the 'array_state'
sysfs attribute. Despite udev signaling the member device is gone, 'mdadm'
cannot issue the STOP_ARRAY ioctl successfully, given the array is mounted.

Nothing else hints that something is wrong (except that the removed devices
don't show properly in the output of 'mdadm detail' command). There is no
other property to be checked, and if user is not performing reads/writes
to the array, even kernel log is quiet and doesn't give a clue about the
missing member.

This patch changes this behavior; when 'array_state' is read we introduce
a non-expensive check (only for raid0/md-linear) that relies in the
comparison of the total number of disks when array was assembled with
gendisk flags of those devices to validate if all members are available
and functional. A new array state 'broken' was added: it mimics the state
'clean' in every aspect, being useful only to distinguish if such array
has some member missing. Also, we show a rate-limited warning in kernel
log in such case.

This patch has no proper functional change other than adding the
'clean'-like state; it was tested with ext4 and xfs filesystems. It
requires a 'mdadm' counterpart to handle the 'broken' state.

Cc: NeilBrown <neilb@suse.com>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
---

Cover-letter from v1:
lore.kernel.org/linux-block/20190729203135.12934-1-gpiccoli@canonical.com

v1 -> v2:
* Added handling for md/linear 'broken' state;
* Check for is_missing_dev() instead of personality (thanks Neil for
the suggestion);
* Changed is_missing_dev() handlers to static;
* Print rate-limited warning in case of more members go away, not only
the first.

Song, after thinking and experimenting a bit more, I don't think it
makes sense to allow setting the 'broken' state, unless we refactor
and "re-purpose" this state. What 'broken' really means is a 'clean'
state but with 1+ members missing - setting it is the same as set
'clean', so it'd be counter-intuitive to set 'broken' but having in
fact set 'clean' merely with the name 'broken'.

The purpose of 'broken' is really to only indicate a missing member,
as noticed by kernel in array_state reads.
If you really think we should use 'broken' for other purposes and hence
users should be allowed to set it, let's discuss and rewrite it.
Personally I think the less we change, the better. We just need
some way to warn users about the missing members of their arrays.
Thanks,

Guilherme


 drivers/md/md-linear.c | 25 +++++++++++++++++++++++++
 drivers/md/md.c        | 22 ++++++++++++++++++----
 drivers/md/md.h        |  2 ++
 drivers/md/raid0.c     | 26 ++++++++++++++++++++++++++
 4 files changed, 71 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index ed2297541414..a404f700e3f8 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -237,6 +237,30 @@ static void linear_free(struct mddev *mddev, void *priv)
 	kfree(conf);
 }
 
+static bool linear_is_missing_dev(struct mddev *mddev)
+{
+	struct md_rdev *rdev;
+	static int already_missing;
+	int def_disks, work_disks = 0;
+
+	def_disks = mddev->raid_disks;
+	rdev_for_each(rdev, mddev)
+		if (rdev->bdev->bd_disk->flags & GENHD_FL_UP)
+			work_disks++;
+
+	if (unlikely(def_disks - work_disks)) {
+		if (already_missing < (def_disks - work_disks)) {
+			already_missing = def_disks - work_disks;
+			pr_warn("md: %s: linear array has %d missing/failed members\n",
+				mdname(mddev), already_missing);
+		}
+		return true;
+	}
+
+	already_missing = 0;
+	return false;
+}
+
 static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 {
 	char b[BDEVNAME_SIZE];
@@ -325,6 +349,7 @@ static struct md_personality linear_personality =
 	.size		= linear_size,
 	.quiesce	= linear_quiesce,
 	.congested	= linear_congested,
+	.is_missing_dev	= linear_is_missing_dev,
 };
 
 static int __init linear_init (void)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ba4de55eea13..0ef93d21cab6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4160,12 +4160,17 @@ __ATTR_PREALLOC(resync_start, S_IRUGO|S_IWUSR,
  * active-idle
  *     like active, but no writes have been seen for a while (100msec).
  *
+ * broken
+ *     RAID0/LINEAR-only: same as clean, but array is missing a member.
+ *     It's useful because RAID0/LINEAR mounted-arrays aren't stopped
+ *     when a member is gone, so this state will at least alert the
+ *     user that something is wrong.
  */
 enum array_state { clear, inactive, suspended, readonly, read_auto, clean, active,
-		   write_pending, active_idle, bad_word};
+		   write_pending, active_idle, broken, bad_word};
 static char *array_states[] = {
 	"clear", "inactive", "suspended", "readonly", "read-auto", "clean", "active",
-	"write-pending", "active-idle", NULL };
+	"write-pending", "active-idle", "broken", NULL };
 
 static int match_word(const char *word, char **list)
 {
@@ -4181,7 +4186,7 @@ array_state_show(struct mddev *mddev, char *page)
 {
 	enum array_state st = inactive;
 
-	if (mddev->pers)
+	if (mddev->pers) {
 		switch(mddev->ro) {
 		case 1:
 			st = readonly;
@@ -4201,7 +4206,15 @@ array_state_show(struct mddev *mddev, char *page)
 				st = active;
 			spin_unlock(&mddev->lock);
 		}
-	else {
+
+		if ((mddev->pers->is_missing_dev) &&
+		   ((st == clean) || (st == broken))) {
+			if (mddev->pers->is_missing_dev(mddev))
+				st = broken;
+			else
+				st = clean;
+		}
+	} else {
 		if (list_empty(&mddev->disks) &&
 		    mddev->raid_disks == 0 &&
 		    mddev->dev_sectors == 0)
@@ -4315,6 +4328,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		break;
 	case write_pending:
 	case active_idle:
+	case broken:
 		/* these cannot be set */
 		break;
 	}
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5d7c1cad4946..2b40990c7642 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -590,6 +590,8 @@ struct md_personality
 	int (*congested)(struct mddev *mddev, int bits);
 	/* Changes the consistency policy of an active array. */
 	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
+	/* Check if there are any missing/failed members - RAID0/LINEAR only. */
+	bool (*is_missing_dev)(struct mddev *mddev);
 };
 
 struct md_sysfs_entry {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index ef896ee7198b..f7144be96029 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -455,6 +455,31 @@ static inline int is_io_in_chunk_boundary(struct mddev *mddev,
 	}
 }
 
+static bool raid0_is_missing_dev(struct mddev *mddev)
+{
+	struct md_rdev *rdev;
+	static int already_missing;
+	int def_disks, work_disks = 0;
+	struct r0conf *conf = mddev->private;
+
+	def_disks = conf->strip_zone[0].nb_dev;
+	rdev_for_each(rdev, mddev)
+		if (rdev->bdev->bd_disk->flags & GENHD_FL_UP)
+			work_disks++;
+
+	if (unlikely(def_disks - work_disks)) {
+		if (already_missing < (def_disks - work_disks)) {
+			already_missing = def_disks - work_disks;
+			pr_warn("md: %s: raid0 array has %d missing/failed members\n",
+				mdname(mddev), already_missing);
+		}
+		return true;
+	}
+
+	already_missing = 0;
+	return false;
+}
+
 static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 {
 	struct r0conf *conf = mddev->private;
@@ -788,6 +813,7 @@ static struct md_personality raid0_personality=
 	.takeover	= raid0_takeover,
 	.quiesce	= raid0_quiesce,
 	.congested	= raid0_congested,
+	.is_missing_dev	= raid0_is_missing_dev,
 };
 
 static int __init raid0_init (void)
-- 
2.22.0
