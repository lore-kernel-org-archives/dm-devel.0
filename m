From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] Do not open log and cow device read-write for
	read-only mappings
Date: Tue, 15 Feb 2011 14:52:39 +0100
Message-ID: <1297777960-22662-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Always use mode specified in table (as otherwise in code).

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-log.c  |    2 +-
 drivers/md/dm-snap.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 6951536..8e8a868 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -543,7 +543,7 @@ static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	r = dm_get_device(ti, argv[0], FMODE_READ | FMODE_WRITE, &dev);
+	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &dev);
 	if (r)
 		return r;
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index fdde53c..a2d3309 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1080,7 +1080,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	argv++;
 	argc--;
 
-	r = dm_get_device(ti, cow_path, FMODE_READ | FMODE_WRITE, &s->cow);
+	r = dm_get_device(ti, cow_path, dm_table_get_mode(ti->table), &s->cow);
 	if (r) {
 		ti->error = "Cannot get COW device";
 		goto bad_cow;
-- 
1.7.2.3
