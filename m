From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] libmultipath/discovery: modify NVMe path
	states
Date: Fri, 15 Sep 2017 08:30:28 +0200
Message-ID: <1505457030-119611-3-git-send-email-hare@suse.de>
References: <1505457030-119611-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505457030-119611-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

The NVMe path states 'resetting' and 'reconnecting' indicate that
the controller could not talk to the namespace, which translates
into a path down state, not a path pending state.
Path pending should only be used for short lived intermediate states
like 'new' or 'deleting'.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 95c138b..a880f4b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1449,8 +1449,7 @@ path_offline (struct path * pp)
 		}
 		pp->offline = 0;
 		if (!strncmp(buff, "new", 3) ||
-		    !strncmp(buff, "reconnecting", 12) ||
-		    !strncmp(buff, "resetting", 9))
+		    !strncmp(buff, "deleting", 8))
 			return PATH_PENDING;
 		else if (!strncmp(buff, "live", 4))
 			return PATH_UP;
-- 
1.8.5.6
