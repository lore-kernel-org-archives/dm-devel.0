From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 4/4] dm unstriped: remove unnecessary header
	includes
Date: Thu,  1 Feb 2018 19:06:12 +0100
Message-ID: <4d0e7c2481c40d0480124b6bca9b4687e5c1e706.1517504857.git.heinzm@redhat.com>
References: <cover.1517504857.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1517504857.git.heinzm@redhat.com>
In-Reply-To: <cover.1517504857.git.heinzm@redhat.com>
References: <cover.1517504857.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-unstripe.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index c1eddd1f7972..41ed30819e58 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -7,12 +7,6 @@
 #include "dm.h"
 
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/blkdev.h>
-#include <linux/bio.h>
-#include <linux/slab.h>
-#include <linux/bitops.h>
-#include <linux/device-mapper.h>
 
 struct unstriped_c {
 	struct dm_dev *dev;
-- 
2.14.3
