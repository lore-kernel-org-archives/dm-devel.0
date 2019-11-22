From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 100/219] dm raid: fix false -EBUSY when handling check/repair message
Date: Fri, 22 Nov 2019 00:47:12 -0500
Message-ID: <20191122054911.1750-93-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

[ Upstream commit 74694bcbdf7e28a5ad548cdda9ac56d30be00d13 ]

Sending a check/repair message infrequently leads to -EBUSY instead of
properly identifying an active resync.  This occurs because
raid_message() is testing recovery bits in a racy way.

Fix by calling decipher_sync_action() from raid_message() to properly
identify the idle state of the RAID device.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index b78a8a4d061ca..416998523d455 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3690,8 +3690,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			md_reap_sync_thread(mddev);
 		}
-	} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-		   test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
+	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
 		return -EBUSY;
 	else if (!strcasecmp(argv[0], "resync"))
 		; /* MD_RECOVERY_NEEDED set below */
-- 
2.20.1
