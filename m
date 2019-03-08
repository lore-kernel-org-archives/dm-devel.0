From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 02/12] libmultipath: handle existing paths in
	marginal_path enqueue
Date: Fri,  8 Mar 2019 17:11:55 -0600
Message-ID: <1552086725-18476-3-git-send-email-bmarzins@redhat.com>
References: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If the path that enqueue_io_err_stat_by_path() is trying to add
is already on the list, just return success. There's no reason
to fail in this case.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/io_err_stat.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 02b1453..1cb3ffe 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -254,7 +254,6 @@ static void free_io_err_pathvec(struct io_err_stat_pathvec *p)
  * return value
  * 0: enqueue OK
  * 1: fails because of internal error
- * 2: fails because of existing already
  */
 static int enqueue_io_err_stat_by_path(struct path *path)
 {
@@ -264,7 +263,7 @@ static int enqueue_io_err_stat_by_path(struct path *path)
 	p = find_err_path_by_dev(paths->pathvec, path->dev);
 	if (p) {
 		pthread_mutex_unlock(&paths->mutex);
-		return 2;
+		return 0;
 	}
 	pthread_mutex_unlock(&paths->mutex);
 
@@ -418,9 +417,8 @@ int hit_io_err_recheck_time(struct path *pp)
 			io_err_stat_log(3, "%s: enqueue fails, to recover",
 					pp->dev);
 			goto recover;
-		} else if (!r) {
+		} else
 			pp->io_err_pathfail_cnt = PATH_IO_ERR_IN_CHECKING;
-		}
 	}
 
 	return 1;
-- 
2.17.2
