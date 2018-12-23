From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 01/20] libmultipath: Increase SERIAL_SIZE to
	128 bytes
Date: Sun, 23 Dec 2018 23:21:07 +0100
Message-ID: <20181223222126.30882-2-mwilck@suse.com>
References: <20181223222126.30882-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181223222126.30882-1-mwilck@suse.com>
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
Cc: Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>

Certain IBM FlashSystem LUNs can return up to 85 bytes of serial
number in the Unit Serial Number VPD page, which is larger than
the current SERIAL_SIZE definition of 65 bytes. Since the max
size of this field does not appear to be defined in SPC, increasing
to 128 bytes should hopefully prevent us from hitting this
in future.

This is an example of a serial number from a FlashSystem:
Unit serial number VPD page:
Unit serial number: 3321360050764008101AB300000000000012204214503IBMfcp

Before this patch multipath returns the error:
Jul 17 11:24:58 | vpd pg80 overflow, 85/65 bytes required

After the patch is applied the error no longer occur.

Signed-off-by: Kyle Mahlkuch<kmahlkuc@linux.vnet.ibm.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 0a2623a0..d8961164 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -9,7 +9,7 @@
 #include "generic.h"
 
 #define WWID_SIZE		128
-#define SERIAL_SIZE		65
+#define SERIAL_SIZE		128
 #define NODE_NAME_SIZE		224
 #define PATH_STR_SIZE		16
 #define PARAMS_SIZE		4096
-- 
2.19.2
