From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] dm cache policy smq: remove duplicated include from dm-cache-policy-smq.c
Date: Sat, 17 Sep 2016 04:48:23 +0000
Message-ID: <1474087703-22600-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: Wei Yongjun <weiyongjun1@huawei.com>

Remove duplicated include.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/md/dm-cache-policy-smq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index 8de5bd9..c33f4a6 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -14,7 +14,6 @@
 #include <linux/mutex.h>
 #include <linux/vmalloc.h>
 #include <linux/math64.h>
-#include <linux/hash.h>
 
 #define DM_MSG_PREFIX "cache-policy-smq"
 



