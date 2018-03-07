From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/4] libmultipath: fix crash on shutdown if
	io_err thread isn't running
Date: Thu,  8 Mar 2018 00:08:56 +0100
Message-ID: <20180307230859.14926-2-mwilck@suse.com>
References: <20180307230859.14926-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307230859.14926-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If we've never created the io_error checker thread, we shouldn't
cancel it.

Fixes: 160da9fa4339 "multipathd: start marginal path checker thread
lazily"

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/io_err_stat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index ac81b4b9390d..02b1453ea527 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -793,6 +793,9 @@ destroy_ctx:
 
 void stop_io_err_stat_thread(void)
 {
+	if (io_err_stat_thr == (pthread_t)0)
+		return;
+
 	if (uatomic_read(&io_err_thread_running) == 1)
 		pthread_cancel(io_err_stat_thr);
 
-- 
2.16.1
