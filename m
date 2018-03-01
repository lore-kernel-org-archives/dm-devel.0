From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 1/6] multipathd/main.c: Fix indentation
Date: Thu,  1 Mar 2018 11:29:30 -0800
Message-ID: <20180301192935.14643-2-bart.vanassche@wdc.com>
References: <20180301192935.14643-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180301192935.14643-1-bart.vanassche@wdc.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This patch avoids that gcc reports the following:

main.c: In function 'uev_pathfail_check':
main.c:1022:5: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
     if (!pp)
     ^~
main.c:1024:2: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
  r = io_err_stat_handle_pathfail(pp);
  ^

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
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
2.16.2
