From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Fixup varags usage
Date: Wed, 30 Apr 2008 11:03:34 +0200
Message-ID: <20080430090334.E5BA118C6FF@pentland.suse.de>
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


We already call va_end() at the correct position, no need to
duplicate it in log_safe().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/log_pthread.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index 8976bfb..8909440 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -15,9 +15,7 @@
 void log_safe (int prio, const char * fmt, va_list ap)
 {
 	pthread_mutex_lock(logq_lock);
-	//va_start(ap, fmt);
 	log_enqueue(prio, fmt, ap);
-	va_end(ap);
 	pthread_mutex_unlock(logq_lock);
 
 	pthread_mutex_lock(logev_lock);
-- 
1.5.2.4
