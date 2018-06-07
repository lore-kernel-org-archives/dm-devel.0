From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] dm: writecache: fix autocommit_time option
Date: Thu, 7 Jun 2018 11:28:38 +0300
Message-ID: <20180607082838.xbrgbboil4kay7zw@kili.mountain>
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
To: Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, kernel-janitors@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The option is in terms of msecs so we should be using msecs_to_jiffies()
to convert it instead of the other way around.

Fixes: 1be8d9c3da01 ("dm: add writecache target")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index f2ae02f22c43..c755e8bc6bdd 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1995,7 +1995,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 				goto invalid_optional;
 			if (autocommit_msecs > 3600000)
 				goto invalid_optional;
-			wc->autocommit_jiffies = jiffies_to_msecs(autocommit_msecs);
+			wc->autocommit_jiffies = msecs_to_jiffies(autocommit_msecs);
 			wc->autocommit_time_set = true;
 		} else if (!strcasecmp(string, "fua")) {
 			if (WC_MODE_PMEM(wc)) {
