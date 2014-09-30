From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH] dm raid: fix bug when round up region_size
Date: Tue, 30 Sep 2014 11:04:53 +0800
Message-ID: <1412046293-4120-1-git-send-email-lzhong@suse.com>
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
List-Id: dm-devel.ids

when region_size if not supplied by userspace and the device is very
large, there is a bug in current code since region_size is correctly
set.

Signed-off-by: Lidong Zhong <lzhong@suse.com>
---
 drivers/md/dm-raid.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4880b69..ecef01f 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -326,7 +326,9 @@ static int validate_region_size(struct raid_set *rs, unsigned long region_size)
 		if (min_region_size > (1 << 13)) {
 			/* If not a power of 2, make it the next power of 2 */
 			if (min_region_size & (min_region_size - 1))
-				region_size = 1 << fls(region_size);
+				region_size = 1 << fls(min_region_size);
+			else
+				region_size = min_region_size;
 			DMINFO("Choosing default region size of %lu sectors",
 			       region_size);
 		} else {
-- 
1.8.1.4
