From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC PATCH 2/2] dm: don't try to split REQ_OP_ZONE_APPEND bios
Date: Fri, 19 Jun 2020 15:59:05 +0900
Message-ID: <20200619065905.22228-3-johannes.thumshirn@wdc.com>
References: <20200619065905.22228-1-johannes.thumshirn@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200619065905.22228-1-johannes.thumshirn@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Damien Le Moal <Damien.LeMoal@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>
List-Id: dm-devel.ids

REQ_OP_ZONE_APPEND bios cannot be split so return EIO if we can't fit it
into one IO.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/dm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 058c34abe9d1..c720a7e3269a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1609,6 +1609,9 @@ static int __split_and_process_non_flush(struct clone_info *ci)
 
 	len = min_t(sector_t, max_io_len(ci->sector, ti), ci->sector_count);
 
+	if (bio_op(ci->bio) == REQ_OP_ZONE_APPEND && len < ci->sector_count)
+		return -EIO;
+
 	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);
 	if (r < 0)
 		return r;
-- 
2.26.2
