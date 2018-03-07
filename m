From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 1/2] libmultipath: fix race in
	stop_io_err_stat_thread
Date: Wed,  7 Mar 2018 15:07:32 +0100
Message-ID: <20180307140733.28709-2-mwilck@suse.com>
References: <20180307140733.28709-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307140733.28709-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Guan Junxiong <guanjunxiong@huawei.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

It's wrong, and unnecessary, to call pthread_kill() after
pthread_cancel(). I have observed cases where the io_err checker
thread hung in libpthread after receiving the USR2 signal, in particular
when multipathd is run under strace. (If multipathd is killed with
SIGINT under strace, and the io_error thread is running, it happens
almost every time). If this happens, the io_err thread
tries to obtain a mutex in the urcu code (presumably rcu_unregister_thread())
and the main thread hangs in pthread_join(). multipathd can only be
terminated with kill -KILL in this situation.

With the change from this patch, the thread is shut down cleanly. I haven't
observed the hang under strace with the patch.

Fixes: 95d594fd "multipath-tools: intermittent IO error accounting to improve
reliability"

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/io_err_stat.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 00bac9e0e755..536ba87968fd 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -749,7 +749,6 @@ destroy_ctx:
 void stop_io_err_stat_thread(void)
 {
 	pthread_cancel(io_err_stat_thr);
-	pthread_kill(io_err_stat_thr, SIGUSR2);
 	pthread_join(io_err_stat_thr, NULL);
 	free_io_err_pathvec(paths);
 	io_destroy(ioctx);
-- 
2.16.1
