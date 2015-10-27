From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 5/6] dm-switch: Remove unnecessary condition in
	conditional
Date: Wed, 28 Oct 2015 04:38:59 +0900
Message-ID: <1445974740-8362-5-git-send-email-kusumi.tomohiro@gmail.com>
References: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, mpatocka@redhat.com
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

It's always (sctx->nr_regions == nr_regions) considering
the assignment right before this conditional, and this
function is only used by .ctr.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 drivers/md/dm-switch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index 50fca46..372ec34 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -100,7 +100,7 @@ static int alloc_region_table(struct dm_target *ti, unsigned nr_paths)
 		nr_regions++;
 
 	sctx->nr_regions = nr_regions;
-	if (sctx->nr_regions != nr_regions || sctx->nr_regions >= ULONG_MAX) {
+	if (sctx->nr_regions >= ULONG_MAX) {
 		ti->error = "Region table too large";
 		return -EINVAL;
 	}
-- 
1.7.1
