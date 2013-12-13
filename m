From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/11] libmultipath: Fix typo in
	retain_attached_hw_handler
Date: Fri, 13 Dec 2013 13:14:06 +0100
Message-ID: <1386936854-8399-4-git-send-email-hare@suse.de>
References: <1386936854-8399-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386936854-8399-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/propsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index f092227..5fe72af 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -680,7 +680,7 @@ select_retain_hwhandler (struct multipath * mp)
 
 	if (!VERSION_GE(conf->version, minv_dm_retain)) {
 		mp->retain_hwhandler = RETAIN_HWHANDLER_OFF;
-		condlog(3, "%s: retain_attached_hw_hander disabled (requires kernel version >= 1.5.0)", mp->alias);
+		condlog(3, "%s: retain_attached_hw_handler disabled (requires kernel version >= 1.5.0)", mp->alias);
 		return 0;
 	}
 
-- 
1.8.1.4
