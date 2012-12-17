From: Guangliang Zhao <gzhao@suse.com>
Subject: [PATCH 3/3 v2] dm raid1: add interface to get resync speed
Date: Mon, 17 Dec 2012 16:26:37 +0800
Message-ID: <1355732797-7233-4-git-send-email-gzhao@suse.com>
References: <1355732797-7233-1-git-send-email-gzhao@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1355732797-7233-1-git-send-email-gzhao@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: lucienchao@gmail.com
List-Id: dm-devel.ids

Add ioctl to get resync speed, userspace tool
is dmsetup status:
	dmsetup status $device
e.g.
	dmsetup status /dev/dm-2

Signed-off-by: Guangliang Zhao <gzhao@suse.com>
---
 drivers/md/dm-raid1.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 3cdad37..68081ff 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1427,6 +1427,20 @@ static char device_status_char(struct mirror *m)
 		(test_bit(DM_RAID1_READ_ERROR, &(m->error_type))) ? 'R' : 'U';
 }
 
+/*
+ * get speed from ratelimit_state
+ */
+static unsigned int rlimit_to_speed(struct mirror_set *ms,
+				    struct ratelimit_state *rl)
+{
+	sector_t region_size = dm_rh_get_region_size(ms->rh);
+	unsigned int time, burst;
+
+	time = rl->interval / HZ;
+	burst = (rl->burst * region_size) >> 1;
+
+	return burst / time;
+}
 
 static int mirror_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
@@ -1445,9 +1459,10 @@ static int mirror_status(struct dm_target *ti, status_type_t type,
 		}
 		buffer[m] = '\0';
 
-		DMEMIT("%llu/%llu 1 %s ",
+		DMEMIT("%llu/%llu 1 %u 1 %s ",
 		      (unsigned long long)log->type->get_sync_count(log),
-		      (unsigned long long)ms->nr_regions, buffer);
+		      (unsigned long long)ms->nr_regions,
+		      rlimit_to_speed(ms, &ms->ms_rlimit), buffer);
 
 		sz += log->type->status(log, type, result+sz, maxlen-sz);
 
-- 
1.7.10.4
