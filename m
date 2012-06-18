From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: optimize modulo max_io_len
Date: Mon, 18 Jun 2012 09:19:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1206180917360.17218@file.rdu.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This patch should be applied after 
dm-support-non-power-of-two-target-max_io_len.patch. It optimizes a case 
when max_io_len is a power of two.

Mikulas

---

dm: optimize modulo max_io_len

Change slow modulo operation to fast bitwise and when max_io_len is a
power of two.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-3.4.2-fast/drivers/md/dm.c
===================================================================
--- linux-3.4.2-fast.orig/drivers/md/dm.c	2012-06-18 11:40:17.000000000 +0200
+++ linux-3.4.2-fast/drivers/md/dm.c	2012-06-18 11:41:05.000000000 +0200
@@ -1004,7 +1004,11 @@ static sector_t max_io_len(sector_t sect
 	 */
 	if (ti->max_io_len) {
 		offset = dm_target_offset(ti, sector);
-		max_len = ti->max_io_len - sector_div(offset, ti->max_io_len);
+		if (unlikely(ti->max_io_len & (ti->max_io_len - 1)))
+			max_len = sector_div(offset, ti->max_io_len);
+		else
+			max_len = offset & (ti->max_io_len - 1);
+		max_len = ti->max_io_len - max_len;
 
 		if (len > max_len)
 			len = max_len;
