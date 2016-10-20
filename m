From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace pthread_yield with
	sched_yield
Date: Fri, 21 Oct 2016 01:16:20 +0200
Message-ID: <20161020231620.636-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>, Leonardo Arena <rnalrd@alpinelinux.org>, Natanael Copa <ncopa@alpinelinux.org>
List-Id: dm-devel.ids

pthread_yield is not standard.
It was added in 6e14b7b

Please review.

Patch from Alpine Linux: http://git.alpinelinux.org/cgit/aports/plain/main/multipath-tools/fix-yield.patch

Cc: Natanael Copa <ncopa@alpinelinux.org>
Cc: Leonardo Arena <rnalrd@alpinelinux.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipathd/uxlsnr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index daaaa99..dfef03e 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -182,7 +182,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 				pthread_mutex_unlock(&client_lock);
 				condlog(0, "%s: failed to realloc %d poll fds",
 					"uxsock", 1 + num_clients);
-				pthread_yield();
+				sched_yield();
 				continue;
 			}
 			old_clients = num_clients;
-- 
2.10.1
