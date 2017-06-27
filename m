From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] libmultipath: fix unit to seconds in log message
	for checker timeout
Date: Tue, 27 Jun 2017 17:11:47 +0200
Message-ID: <20170627151147.11776-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

checker_timeout is in seconds, not milliseconds, since 905281da
"Specify checker_timeout in seconds". Fix the log messages.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/propsel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 27f39517..4ac7edcd 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -333,11 +333,11 @@ out:
 				pp->dev, c->timeout);
 	}
 	else if (sysfs_get_timeout(pp, &c->timeout) > 0)
-		condlog(3, "%s: checker timeout = %u ms (setting: kernel sysfs)",
+		condlog(3, "%s: checker timeout = %u s (setting: kernel sysfs)",
 				pp->dev, c->timeout);
 	else {
 		c->timeout = DEF_TIMEOUT;
-		condlog(3, "%s: checker timeout = %u ms (setting: multipath internal)",
+		condlog(3, "%s: checker timeout = %u s (setting: multipath internal)",
 				pp->dev, c->timeout);
 	}
 	return 0;
-- 
2.13.1
