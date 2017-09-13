From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-crypt: Reject sector_size feature if device
	length is not aligned to it
Date: Wed, 13 Sep 2017 15:45:56 +0200
Message-ID: <20170913134556.23145-1-gmazyland@gmail.com>
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
Cc: mpatocka@redhat.com, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

If a crypt mapping uses optional sector_size feature, additional
restrictions to mapped device segment size must be applied in constructor,
otherwise the device activation will fail later.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 54aef8ed97db..488ecd0b1bd0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2584,6 +2584,10 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
 				ti->error = "Invalid feature value for sector_size";
 				return -EINVAL;
 			}
+			if (ti->len & ((cc->sector_size >> SECTOR_SHIFT) - 1)) {
+				ti->error = "Device size is not multiple of sector_size feature";
+				return -EINVAL;
+			}
 			cc->sector_shift = __ffs(cc->sector_size) - SECTOR_SHIFT;
 		} else if (!strcasecmp(opt_string, "iv_large_sectors"))
 			set_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);
-- 
2.14.1
