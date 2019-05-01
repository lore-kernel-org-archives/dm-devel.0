From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] dm: remove redundant unsigned comparison to less than zero
Date: Wed,  1 May 2019 13:57:17 +0100
Message-ID: <20190501125717.5695-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Colin Ian King <colin.king@canonical.com>

Variable block is an unsigned long long hence the less than zero
comparison is always false, hence it is redundant and can be removed.

Addresses-Coverity: ("Unsigned compared against 0")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/md/dm-dust.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index 178587bdc626..e739092bfc65 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -411,7 +411,7 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 
 		block = tmp;
 		sector_div(size, dd->sect_per_block);
-		if (block > size || block < 0) {
+		if (block > size) {
 			DMERR("selected block value out of range");
 			return result;
 		}
-- 
2.20.1
