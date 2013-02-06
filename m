From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 47/77] dm: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:19 -0800
Message-ID: <1360179649-22465-48-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm.c | 54 +++++++++++++++---------------------------------------
 1 file changed, 15 insertions(+), 39 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c644eb6..ac74b81 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1801,62 +1801,38 @@ static void free_minor(int minor)
  */
 static int specific_minor(int minor)
 {
-	int r, m;
+	int r;
 
 	if (minor >= (1 << MINORBITS))
 		return -EINVAL;
 
-	r = idr_pre_get(&_minor_idr, GFP_KERNEL);
-	if (!r)
-		return -ENOMEM;
-
+	idr_preload(GFP_KERNEL);
 	spin_lock(&_minor_lock);
 
-	if (idr_find(&_minor_idr, minor)) {
-		r = -EBUSY;
-		goto out;
-	}
-
-	r = idr_get_new_above(&_minor_idr, MINOR_ALLOCED, minor, &m);
-	if (r)
-		goto out;
+	r = idr_alloc(&_minor_idr, MINOR_ALLOCED, minor, minor + 1, GFP_NOWAIT);
 
-	if (m != minor) {
-		idr_remove(&_minor_idr, m);
-		r = -EBUSY;
-		goto out;
-	}
-
-out:
 	spin_unlock(&_minor_lock);
-	return r;
+	idr_preload_end();
+	if (r < 0)
+		return r == -ENOSPC ? -EBUSY : r;
+	return 0;
 }
 
 static int next_free_minor(int *minor)
 {
-	int r, m;
-
-	r = idr_pre_get(&_minor_idr, GFP_KERNEL);
-	if (!r)
-		return -ENOMEM;
+	int r;
 
+	idr_preload(GFP_KERNEL);
 	spin_lock(&_minor_lock);
 
-	r = idr_get_new(&_minor_idr, MINOR_ALLOCED, &m);
-	if (r)
-		goto out;
-
-	if (m >= (1 << MINORBITS)) {
-		idr_remove(&_minor_idr, m);
-		r = -ENOSPC;
-		goto out;
-	}
-
-	*minor = m;
+	r = idr_alloc(&_minor_idr, MINOR_ALLOCED, 0, 1 << MINORBITS, GFP_NOWAIT);
 
-out:
 	spin_unlock(&_minor_lock);
-	return r;
+	idr_preload_end();
+	if (r < 0)
+		return r;
+	*minor = r;
+	return 0;
 }
 
 static const struct block_device_operations dm_blk_dops;
-- 
1.8.1
