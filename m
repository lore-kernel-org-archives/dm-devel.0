From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] dm thin: inverted down_trylock() test
Date: Tue, 25 Feb 2014 11:35:09 +0300
Message-ID: <20140225083509.GB5023@elgon.mountain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, kernel-janitors@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

down_trylock() is the opposite of mutex_trylock().  It returns zero on
success and one on failure.

Fixes: f4ef95631ebf ('dm thin: do not run the worker thread if pool is suspended')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 6cbe9d2e0385..7d8e03c21fa9 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -237,7 +237,7 @@ struct thin_c {
  */
 static void wake_worker(struct pool *pool)
 {
-	if (down_trylock(&pool->queue_work_lock)) {
+	if (!down_trylock(&pool->queue_work_lock)) {
 		queue_work(pool->wq, &pool->worker);
 		up(&pool->queue_work_lock);
 	}
