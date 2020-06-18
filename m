From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 069/108] dm zoned: return NULL if dmz_get_zone_for_reclaim() fails to find a zone
Date: Wed, 17 Jun 2020 21:25:21 -0400
Message-ID: <20200618012600.608744-69-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Damien Le Moal <damien.lemoal@wdc.com>, Mike Snitzer <snitzer@redhat.com>, Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 489dc0f06a5837f87482c0ce61d830d24e17082e ]

The only case where dmz_get_zone_for_reclaim() cannot return a zone is
if the respective lists are empty. So we should just return a simple
NULL value here as we really don't have an error code which would make
sense.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-zoned-metadata.c | 4 ++--
 drivers/md/dm-zoned-reclaim.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 4d658a0c6025..c6d3a4bc811c 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1580,7 +1580,7 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd)
 			return dzone;
 	}
 
-	return ERR_PTR(-EBUSY);
+	return NULL;
 }
 
 /*
@@ -1600,7 +1600,7 @@ static struct dm_zone *dmz_get_seq_zone_for_reclaim(struct dmz_metadata *zmd)
 			return zone;
 	}
 
-	return ERR_PTR(-EBUSY);
+	return NULL;
 }
 
 /*
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 2fad512dce98..1015b200330b 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -350,8 +350,8 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
 
 	/* Get a data zone */
 	dzone = dmz_get_zone_for_reclaim(zmd);
-	if (IS_ERR(dzone))
-		return PTR_ERR(dzone);
+	if (!dzone)
+		return -EBUSY;
 
 	start = jiffies;
 
-- 
2.25.1
