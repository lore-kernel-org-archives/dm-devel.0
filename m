From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] multipathd crash on shutdown
Date: Wed, 30 Apr 2008 11:03:24 +0200
Message-ID: <20080430090324.EB97E18C6FF@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


On shutdown multipathd flushes its internal message queue;
but we have to check if the messages on the queue are not empty.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/log_pthread.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index 5a82b6a..8976bfb 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -33,7 +33,8 @@ static void flush_logqueue (void)
 		pthread_mutex_lock(logq_lock);
 		empty = log_dequeue(la->buff);
 		pthread_mutex_unlock(logq_lock);
-		log_syslog(la->buff);
+		if (!empty)
+			log_syslog(la->buff);
 	} while (empty == 0);
 }
 
-- 
1.5.2.4
