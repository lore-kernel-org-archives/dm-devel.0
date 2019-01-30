From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 4/4] libmultipath: fix marginal_paths nr_active
	check
Date: Wed, 30 Jan 2019 16:13:07 -0600
Message-ID: <1548886387-23381-5-git-send-email-bmarzins@redhat.com>
References: <1548886387-23381-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1548886387-23381-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Guan Junxiong <guanjunxiong@huawei.com>, Martin Wilck <mwilck@suse.com>, Muneendra <muneendra.kumar@broadcom.com>
List-Id: dm-devel.ids

Marginal paths are SHAKY, so they don't count towards the number of
active paths. poll_io_err_stat() shouldn't automatically reinstate a
marginal path if there already is an active path.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/io_err_stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 72aacf3..554b777 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -481,7 +481,7 @@ static int poll_io_err_stat(struct vectors *vecs, struct io_err_stat_path *pp)
 		 */
 		path->tick = 1;
 
-	} else if (path->mpp && path->mpp->nr_active > 1) {
+	} else if (path->mpp && path->mpp->nr_active > 0) {
 		io_err_stat_log(3, "%s: keep failing the dm path %s",
 				path->mpp->alias, path->dev);
 		path->io_err_pathfail_cnt = PATH_IO_ERR_WAITING_TO_CHECK;
-- 
2.17.2
