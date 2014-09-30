From: heinzm@redhat.com
Subject: Re: [PATCH]  dm-raid: fix bug when round up region_size
Date: Tue, 30 Sep 2014 13:00:36 +0200
Message-ID: <1412074836-5820-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Liong,
thanks for the catch.
Introduced minor modification utilizing the is_power_of_2() inline.

---

If region_size is not supplied by userspace and the device is very
large, there is a bug in current code preventing region_size from being
correctly set.


Signed-off-by: Lidong Zhong <lzhong@suse.com>
Acked-by:      Heinz Mauelshagen <heinzm@redhat.com>
Tested-by:     Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm-raid.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4880b69..264aef4 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -325,8 +325,10 @@ static int validate_region_size(struct raid_set *rs, unsigned long region_size)
 		 */
 		if (min_region_size > (1 << 13)) {
 			/* If not a power of 2, make it the next power of 2 */
-			if (min_region_size & (min_region_size - 1))
-				region_size = 1 << fls(region_size);
+			if (is_power_of_2(min_region_size))
+				region_size = min_region_size;
+			else
+				region_size = 1 << fls(min_region_size);
 			DMINFO("Choosing default region size of %lu sectors",
 			       region_size);
 		} else {
-- 
1.9.3
