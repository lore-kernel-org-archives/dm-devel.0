From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/42] Do not call sysfs_get_timeout for non-SCSI
	devices
Date: Tue,  8 Jan 2013 14:54:02 +0100
Message-ID: <1357653259-62650-25-git-send-email-hare@suse.de>
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

Only SCSI devices have a timeout, so there is no point in
trying to set a timeout for other types.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 7ed8556..3ffdc62 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -761,11 +761,13 @@ get_state (struct path * pp, int daemon)
 	checker_clear_message(c);
 	if (daemon)
 		checker_set_async(c);
-	if (!conf->checker_timeout)
-		sysfs_get_timeout(pp, &(c->timeout));
+	if (!conf->checker_timeout &&
+	    (pp->bus != SYSFS_BUS_SCSI ||
+	     sysfs_get_timeout(pp, &(c->timeout))))
+		c->timeout = DEF_TIMEOUT;
 	state = checker_check(c);
 	condlog(3, "%s: state = %s", pp->dev, checker_state_name(state));
-	if (state == PATH_DOWN && strlen(checker_message(c)))
+	if (state != PATH_UP && strlen(checker_message(c)))
 		condlog(3, "%s: checker msg is \"%s\"",
 			pp->dev, checker_message(c));
 	return state;
-- 
1.7.4.2
