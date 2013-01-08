From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 41/42] multipathd: crash in reconfigure CLI
	command
Date: Tue,  8 Jan 2013 14:54:18 +0100
Message-ID: <1357653259-62650-41-git-send-email-hare@suse.de>
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

The 'reconfigure' CLI command doesn't take the vector lock,
so if multipathd is processing a table / udev event at the
same time it'll crash.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f491a24..395307e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1389,6 +1389,7 @@ reconfigure (struct vectors * vecs)
 	struct config * old = conf;
 	int retval = 1;
 
+	lock(vecs->lock);
 	/*
 	 * free old map and path vectors ... they use old conf state
 	 */
@@ -1409,6 +1410,7 @@ reconfigure (struct vectors * vecs)
 		retval = 0;
 	}
 
+	unlock(vecs->lock);
 	return retval;
 }
 
@@ -1466,9 +1468,7 @@ sighup (int sig)
 	if (running_state != DAEMON_RUNNING)
 		return;
 
-	lock(gvecs->lock);
 	reconfigure(gvecs);
-	unlock(gvecs->lock);
 
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
-- 
1.7.4.2
