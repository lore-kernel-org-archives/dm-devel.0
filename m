From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/42] Path checker should return PATH_DOWN when
	no path is found
Date: Tue,  8 Jan 2013 14:54:01 +0100
Message-ID: <1357653259-62650-24-git-send-email-hare@suse.de>
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

If the path checker fails to lookup the path in sysfs it's
already gone, so we should rather return 'PATH_DOWN' here.
Otherwise the path will never marked failed and no failover
will happen.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6848b70..7ed8556 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -659,11 +659,11 @@ path_offline (struct path * pp)
 
 	if (!parent) {
 		condlog(1, "%s: failed to get sysfs information", pp->dev);
-		return PATH_WILD;
+		return PATH_DOWN;
 	}
 
 	if (sysfs_get_state(parent, buff, SCSI_STATE_SIZE))
-		return PATH_WILD;
+		return PATH_DOWN;
 
 	condlog(3, "%s: path state = %s", pp->dev, buff);
 
-- 
1.7.4.2
