From: Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>
Subject: [PATCH] libmultipath: Increase SERIAL_SIZE to 128 bytes
Date: Thu, 13 Dec 2018 10:10:33 -0600
Message-ID: <cad99184-26da-c914-84cc-1a49e5e8300a@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5231214182509206293=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
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
Cc: kylemahl@linux.vnet.ibm.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============5231214182509206293==
Content-Type: multipart/alternative;
	boundary="------------1B16693E3E9280E70ABCB137"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------1B16693E3E9280E70ABCB137
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

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
+#define SERIAL_SIZE		128
  #define NODE_NAME_SIZE		224
  #define PATH_STR_SIZE		16
  #define PARAMS_SIZE		4096
-- 1.8.3.1


--------------1B16693E3E9280E70ABCB137
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <pre wrap="">Certain IBM FlashSystem LUNs can return up to 85 bytes of serial
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

Signed-off-by: Kyle Mahlkuch <a class="moz-txt-link-rfc2396E" href="mailto:kmahlkuc@linux.vnet.ibm.com">&lt;kmahlkuc@linux.vnet.ibm.com&gt;</a>
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
+#define SERIAL_SIZE		128
 #define NODE_NAME_SIZE		224
 #define PATH_STR_SIZE		16
 #define PARAMS_SIZE		4096
<div class="moz-txt-sig">-- 
1.8.3.1

</div></pre>
  </body>
</html>

--------------1B16693E3E9280E70ABCB137--


--===============5231214182509206293==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5231214182509206293==--
