From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] dm: remove unused including <linux/version.h>
Date: Tue, 30 Apr 2019 02:01:02 +0000
Message-ID: <20190430020102.56234-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: YueHaibing <yuehaibing@huawei.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

Remove including <linux/version.h> that don't need it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/md/dm-dust.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index 997830984893..df011da50b50 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -10,7 +10,6 @@
 
 #include <linux/device-mapper.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/rbtree.h>
 
 #define DM_MSG_PREFIX "dust"
