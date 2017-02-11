From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/7] kpartx: don't keep creating recursive
	partitions
Date: Fri, 10 Feb 2017 23:28:46 -0600
Message-ID: <1486790932-30917-2-git-send-email-bmarzins@redhat.com>
References: <1486790932-30917-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1486790932-30917-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Cedric Buissart <cbuissar@redhat.com>
List-Id: dm-devel.ids

If the dos partition table is corrupted, kpartx can just keep creating
the same partitions until it runs out of partition numbers. This check
catches the recursion.

Signed-off-by: Cedric Buissart <cbuissar@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/dos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/dos.c b/kpartx/dos.c
index 64b27b6..4985152 100644
--- a/kpartx/dos.c
+++ b/kpartx/dos.c
@@ -46,7 +46,7 @@ read_extended_partition(int fd, struct partition *ep, int en,
 		for (i=0; i<2; i++) {
 			memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
 			if (is_extended(p.sys_type)) {
-				if (p.nr_sects && !moretodo) {
+				if (p.start_sect && p.nr_sects && !moretodo) {
 					next = start + sector_size_mul * le32_to_cpu(p.start_sect);
 					moretodo = 1;
 				}
-- 
1.8.3.1
