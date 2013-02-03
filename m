From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 31/62] dm: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:32 -0800
Message-ID: <1359854463-2538-32-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
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
Cc: axboe@kernel.dk, skinsbursky@parallels.com, rusty@rustcorp.com.au, jmorris@namei.org, linux-kernel@vger.kernel.org, bfields@fieldses.org, dm-devel@redhat.com, ebiederm@xmission.com, Tejun Heo <tj@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/md/dm.c | 54 +++++++++++++++---------------------------------------
 1 file changed, 15 insertions(+), 39 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ea1a6ca..29cd4e2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1753,62 +1753,38 @@ static void free_minor(int minor)
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
