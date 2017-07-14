From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/4] libmultipath: drop
	uevent_can_discard_by_devpath
Date: Fri, 14 Jul 2017 13:32:07 +0200
Message-ID: <20170714113209.17177-3-mwilck@suse.com>
References: <20170714113209.17177-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170714113209.17177-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, tang.junhui@zte.com.cn, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>, Guan Junxiong <guanjunxiong@huawei.com>
Cc: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

This function is broken. Not all devices that matter for multipathd
follow the block/$DEVICE/$PARTITION convention (example: NVME)

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/uevent.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 4fbd1dfb..b688ca03 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -143,36 +143,11 @@ uevent_need_merge(void)
 	return need_merge;
 }
 
-static bool
-uevent_can_discard_by_devpath(const char *devpath)
-{
-	static const char BLOCK[] = "/block/";
-	const char *tmp = strstr(devpath, BLOCK);
-
-	if (tmp == NULL) {
-		condlog(4, "no /block/ in '%s'", devpath);
-		return true;
-	}
-	tmp += sizeof(BLOCK) - 1;
-	if (*tmp == '\0')
-		/* just ".../block/" - discard */
-		return true;
-	/*
-	 * If there are more path elements after ".../block/xyz",
-	 * it's a partition - discard it; but don't discard ".../block/sda/".
-	 */
-	tmp = strchr(tmp, '/');
-	return tmp != NULL && *(tmp + 1) != '\0';
-}
-
 bool
 uevent_can_discard(struct uevent *uev)
 {
 	struct config * conf;
 
-	if (uevent_can_discard_by_devpath(uev->devpath))
-		return true;
-
 	/*
 	 * do not filter dm devices by devnode
 	 */
-- 
2.13.2
