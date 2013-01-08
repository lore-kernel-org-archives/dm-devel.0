From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 28/42] Clean up uevent queue on shutdown
Date: Tue,  8 Jan 2013 14:54:06 +0100
Message-ID: <1357653259-62650-29-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

During shutdown there might be some unprocessed events
in the queue. So clear them up.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/uevent.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index b74fb08..5b0b258 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -132,6 +132,17 @@ static void uevq_stop(void *arg)
 	pthread_mutex_unlock(uevq_lockp);
 }
 
+void
+uevq_cleanup(struct list_head *tmpq)
+{
+	struct uevent *uev, *tmp;
+
+	list_for_each_entry_safe(uev, tmp, tmpq, node) {
+		list_del_init(&uev->node);
+		FREE(uev);
+	}
+}
+
 /*
  * Service the uevent queue.
  */
@@ -163,6 +174,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
 		service_uevq(&uevq_tmp);
 	}
 	condlog(3, "Terminating uev service queue");
+	uevq_cleanup(&uevq);
 	return 0;
 }
 
-- 
1.7.4.2
