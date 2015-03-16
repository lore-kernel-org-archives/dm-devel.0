From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/78] Use 'SCSI_IDENT_.*' as the default
	property whitelist
Date: Mon, 16 Mar 2015 13:36:02 +0100
Message-ID: <1426509425-15978-16-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

59-scsi-sg_utils.rules export the VPD pages as
SCSI_IDENT_<association>_<type>.
So whenever we have a SCSI_IDENT_* property we know it
has come from VPD pages and we have a legit device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/blacklist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index cea128c..30c5031 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -196,7 +196,7 @@ setup_default_blist (struct config * conf)
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
 		return 1;
 
-	str = STRDUP("(ID_SCSI_VPD|ID_WWN)");
+	str = STRDUP("(SCSI_IDENT_.*|ID_WWN)");
 	if (!str)
 		return 1;
 	if (store_ble(conf->elist_property, str, ORIGIN_DEFAULT))
-- 
1.8.4.5
