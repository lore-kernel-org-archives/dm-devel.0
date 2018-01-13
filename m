From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 14/20] multipathd: fix compiler warning for
	uev_pathfail_check
Date: Sat, 13 Jan 2018 22:19:32 +0100
Message-ID: <20180113211938.31552-15-mwilck@suse.com>
References: <20180113211938.31552-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

gcc7 spits out an indentation warning for this function.

Fixes: 8392431 "multipath-tools: check null path before handle path-failed event"
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 27cf234623d0..ccbb0ad13d32 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1020,8 +1020,8 @@ uev_pathfail_check(struct uevent *uev, struct vectors *vecs)
 	lock(&vecs->lock);
 	pthread_testcancel();
 	pp = find_path_by_devt(vecs->pathvec, devt);
-    if (!pp)
-        goto out_lock;
+	if (!pp)
+		goto out_lock;
 	r = io_err_stat_handle_pathfail(pp);
 	if (r)
 		condlog(3, "io_err_stat: %s: cannot handle pathfail uevent",
-- 
2.15.1
