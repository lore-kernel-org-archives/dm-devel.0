From: Guangliang Zhao <gzhao@suse.com>
Subject: [PATCH 3/3] dm raid1: add interface to get resync speed
Date: Thu, 22 Nov 2012 14:27:53 +0800
Message-ID: <1353565673-4233-4-git-send-email-gzhao@suse.com>
References: <1353565673-4233-1-git-send-email-gzhao@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1353565673-4233-1-git-send-email-gzhao@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
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
index 1da25eb..b7bd93a 100644
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
