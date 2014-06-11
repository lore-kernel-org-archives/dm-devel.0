From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] dm-thin: Export proper discard_granularity
Date: Wed, 11 Jun 2014 14:32:09 +0200
Message-ID: <1402489929-16466-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>
List-Id: dm-devel.ids

Currently if the underlying device is discard capable and the
discard_passdown is enabled, the discard_granularity will be inherited
from that device.

This will pose a problem in the case that the device discard_granularity
is smaller than thin volume chunk size, because in that case discard
requests will not be chunk size aligned so it will be ignored by
dm-thin.

Fix this by setting thin volume discard granularity to the bigger of the
two max(device discard_granularity, thin volume chunk size). Strictly
speaking it is not necessary to get the bigger of the two, because
the thin volume chunk size will always be >= device discard_granularity.
However I believe that the reason for this is only because dm-thin can
not handle discard requests bigger than chunk size which is hopefully
going to change soon. This way it is future proof.

RHBZ: 1106856

Reported-by: Zdenek Kabelac <zkabelac@fedoraproject.org>
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 drivers/md/dm-thin.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 242ac2e..fdd7089 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3068,7 +3068,9 @@ static void set_discard_limits(struct pool_c *pt, struct queue_limits *limits)
 	 */
 	if (pt->adjusted_pf.discard_passdown) {
 		data_limits = &bdev_get_queue(pt->data_dev->bdev)->limits;
-		limits->discard_granularity = data_limits->discard_granularity;
+		limits->discard_granularity =
+				max(data_limits->discard_granularity,
+				    pool->sectors_per_block << SECTOR_SHIFT);
 	} else
 		limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
 }
-- 
1.8.3.1
