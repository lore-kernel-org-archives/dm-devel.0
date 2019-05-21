From: Michael Lass <bevan@bi-co.net>
Subject: [PATCH] dm: make sure to obey max_io_len_target_boundary
Date: Tue, 21 May 2019 21:58:07 +0200
Message-ID: <20190521195807.81035-1-bevan@bi-co.net>
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
Cc: Michael Lass <bevan@bi-co.net>
List-Id: dm-devel.ids

In 61697a6abd24 __send_changing_extent_only() was simplified as splitting
discards is no longer necessary. However, we still need to obey
max_io_len_target_boundary.

Signed-off-by: Michael Lass <bevan@bi-co.net>
---
 drivers/md/dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1fb1333fefec..997385c1ca54 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1469,7 +1469,7 @@ static unsigned get_num_write_zeroes_bios(struct dm_target *ti)
 static int __send_changing_extent_only(struct clone_info *ci, struct dm_target *ti,
 				       unsigned num_bios)
 {
-	unsigned len = ci->sector_count;
+	unsigned len;
 
 	/*
 	 * Even though the device advertised support for this type of
@@ -1480,6 +1480,8 @@ static int __send_changing_extent_only(struct clone_info *ci, struct dm_target *
 	if (!num_bios)
 		return -EOPNOTSUPP;
 
+	len = min((sector_t)ci->sector_count, max_io_len_target_boundary(ci->sector, ti));
+
 	__send_duplicate_bios(ci, ti, num_bios, &len);
 
 	ci->sector += len;
-- 
2.21.0
