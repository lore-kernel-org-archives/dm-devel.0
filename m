From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] dmraid: remove partitions with O_RDONLY
Date: Thu, 26 Oct 2017 22:47:22 +0200
Message-ID: <20171026204722.9150-1-mwilck@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.de>, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.com>, Hannes Reinecke <hare@suse.de>
List-Id: dm-devel.ids

It's not necessary to use O_RDWR to use BLKPG_DEL_PARTITION.
It's actually harmful, because closing the device will cause
an IN_CLOSE_WRITE inotify event, which will trigger a BLKRRPART
from systemd, which will reinstate all partitions just deleted.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 lib/device/partition.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/device/partition.c b/lib/device/partition.c
index 9352b0437694..a01cc3583514 100644
--- a/lib/device/partition.c
+++ b/lib/device/partition.c
@@ -22,7 +22,7 @@ _remove_subset_partitions(struct lib_context *lc, struct raid_set *rs)
 	};
 
 	list_for_each_entry(rd, &rs->devs, devs) {
-		int fd = open(rd->di->path, O_RDWR);
+		int fd = open(rd->di->path, O_RDONLY);
 		if (fd < 0)
 			LOG_ERR(lc, 0, "opening %s: %s\n", rd->di->path,
 				strerror(errno));
-- 
2.14.2

