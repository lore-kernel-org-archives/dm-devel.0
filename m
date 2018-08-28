From: KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
Subject: [PATCH] libmultipath: Increase SERIAL_SIZE to 256 bytes
Date: Tue, 28 Aug 2018 16:34:19 -0500
Message-ID: <1535492059-29311-1-git-send-email-kmahlkuc@linux.vnet.ibm.com>
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
To: dm-devel@redhat.com
Cc: KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
List-Id: dm-devel.ids

Certain IBM FlashSystem LUNs can return up to 85 bytes of serial
number in the Unit Serial Number VPD page, which is larger than
the current SERIAL_SIZE definition of 65 bytes. Since the max
size of this field does not appear to be defined in SPC, increasing
to 256 bytes should hopefully prevent us from hitting this
in future.

This is an example of a serial number from a FlashSystem:
Unit serial number VPD page:
Unit serial number: 3321360050764008101AB300000000000012204214503IBMfcp

Before this patch multipath returns the error:
Jul 17 11:24:58 | vpd pg80 overflow, 85/65 bytes required

After the patch is applied the error no longer occur.

Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>
---
 libmultipath/structs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index bfa660a..00a1b1a 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -8,7 +8,7 @@
 #include "byteorder.h"
 
 #define WWID_SIZE		128
-#define SERIAL_SIZE		65
+#define SERIAL_SIZE		256
 #define NODE_NAME_SIZE		224
 #define PATH_STR_SIZE		16
 #define PARAMS_SIZE		4096
-- 
1.8.3.1
