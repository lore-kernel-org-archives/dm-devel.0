From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/13] Set priority to '0' for PATH_BLOCKED or
	PATH_DOWN
Date: Fri, 15 Nov 2013 11:29:33 +0100
Message-ID: <1384511384-27642-3-git-send-email-hare@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384511384-27642-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When a path is down or blocked we need to initialize the priority
to '0'. Otherwise multipathd will discard the maps during reload
and fail to start if all paths are temporarily down.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 04e3ead..3292358 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1117,6 +1117,9 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 		} else {
 			condlog(3, "%s: path inaccessible", pp->dev);
 			pp->chkrstate = pp->state = path_state;
+			if (path_state == PATH_PENDING ||
+			    path_state == PATH_DOWN)
+				pp->priority = 0;
 		}
 	}
 
-- 
1.8.1.4
