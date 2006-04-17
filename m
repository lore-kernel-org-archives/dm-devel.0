From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 03/08] dm: fix idr_pre_get lock ordering
Date: Mon, 17 Apr 2006 11:16:02 -0400
Message-ID: <20060417151602.GA18941@locomotive.unixthugs.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Device Mapper Development List <dm-devel@redhat.com>
List-Id: dm-devel.ids


 idr_pre_get() can sleep while allocating memory for the worst-case scenario.
 This isn't a huge deal with the current code, but the next patch will
 switch _minor_lock to a spinlock.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

--
 drivers/md/dm.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff -ruNpX ../dontdiff 2.6.17-rc1-staging1/drivers/md/dm.c 2.6.17-rc1-staging2/drivers/md/dm.c
--- 2.6.17-rc1-staging1/drivers/md/dm.c	2006-04-17 10:51:44.000000000 -0400
+++ 2.6.17-rc1-staging2/drivers/md/dm.c	2006-04-17 10:51:44.000000000 -0400
@@ -766,6 +766,10 @@ static int specific_minor(struct mapped_
 	if (minor >= (1 << MINORBITS))
 		return -EINVAL;
 
+	r = idr_pre_get(&_minor_idr, GFP_KERNEL);
+	if (!r)
+		return -ENOMEM;
+
 	mutex_lock(&_minor_lock);
 
 	if (idr_find(&_minor_idr, minor)) {
@@ -773,12 +777,6 @@ static int specific_minor(struct mapped_
 		goto out;
 	}
 
-	r = idr_pre_get(&_minor_idr, GFP_KERNEL);
-	if (!r) {
-		r = -ENOMEM;
-		goto out;
-	}
-
 	r = idr_get_new_above(&_minor_idr, MINOR_ALLOCED, minor, &m);
 	if (r) {
 		goto out;
@@ -800,13 +798,11 @@ static int next_free_minor(struct mapped
 	int r;
 	unsigned int m;
 
-	mutex_lock(&_minor_lock);
-
 	r = idr_pre_get(&_minor_idr, GFP_KERNEL);
-	if (!r) {
-		r = -ENOMEM;
-		goto out;
-	}
+	if (!r)
+		return -ENOMEM;
+
+	mutex_lock(&_minor_lock);
 
 	r = idr_get_new(&_minor_idr, MINOR_ALLOCED, &m);
 	if (r) {
