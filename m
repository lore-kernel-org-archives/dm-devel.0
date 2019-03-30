From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 17/17] libmultipath: silence dm_is_mpath error
	messages
Date: Sat, 30 Mar 2019 01:06:06 -0500
Message-ID: <1553925966-20958-18-git-send-email-bmarzins@redhat.com>
References: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

When "multipath -F" is run, dm_is_mpath was printing error messages
about partition devices, because they had already been removed, when
it checked.  Lower the error logging level so this doesn't happen on
the default verbosity.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 3294bd4..2e79667 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -746,7 +746,7 @@ out_task:
 	dm_task_destroy(dmt);
 out:
 	if (r < 0)
-		condlog(2, "%s: dm command failed in %s", name, __FUNCTION__);
+		condlog(3, "%s: dm command failed in %s: %s", name, __FUNCTION__, strerror(errno));
 	return r;
 }
 
-- 
2.17.2
