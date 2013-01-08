From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 29/42] libmultipath: Print out uevent sequence
	number
Date: Tue,  8 Jan 2013 14:54:07 +0100
Message-ID: <1357653259-62650-30-git-send-email-hare@suse.de>
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

For debugging we should be printing out the sequence number.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/uevent.c |   11 ++++++++++-
 libmultipath/uevent.h |    1 +
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 5b0b258..bc74d38 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -361,11 +361,20 @@ int failback_listen(void)
 			key = &buffer[bufpos];
 			keylen = strlen(key);
 			uev->envp[i] = key;
+			/* Filter out sequence number */
+			if (strncmp(key, "SEQNUM=", 7) == 0) {
+				char *eptr;
+
+				uev->seqnum = strtoul(key + 7, &eptr, 10);
+				if (eptr == key + 7)
+					uev->seqnum = -1;
+			}
 			bufpos += keylen + 1;
 		}
 		uev->envp[i] = NULL;
 
-		condlog(3, "uevent '%s' from '%s'", uev->action, uev->devpath);
+		condlog(3, "uevent %ld '%s' from '%s'", uev->seqnum,
+			uev->action, uev->devpath);
 		uev->kernel = strrchr(uev->devpath, '/');
 		if (uev->kernel)
 			uev->kernel++;
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 64f00b7..762595a 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -20,6 +20,7 @@ struct uevent {
 	char *devpath;
 	char *action;
 	char *kernel;
+	unsigned long seqnum;
 	char *envp[HOTPLUG_NUM_ENVP];
 };
 
-- 
1.7.4.2
