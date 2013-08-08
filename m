From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: [PATCH] rdac: Always fail paths when controller reports
 unavailable AAS
Date: Thu, 8 Aug 2013 20:04:17 +0000
Message-ID: <8255ED565A0EAA4A960625E27D49DBF23DE903EE@SACEXCMBX04-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

The RDAC checker should always fail paths that report they are unavailable.
Previously, it only failed paths where the controller was in service mode, but 
in any case that reports an AAS of unavailable, the controller should not be 
used to service I/O.

Signed-off-by: Sean Stewart <Sean.Stewart@netapp.com>
---
diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
index 2e64dd3..b447c72 100644
--- a/libmultipath/checkers/rdac.c
+++ b/libmultipath/checkers/rdac.c
@@ -222,10 +222,9 @@ libcheck_check (struct checker * c)
 		goto done;
 	}
 
-	/* check if controller is in service mode */
+	/* check if controller is reporting asymmetric access state of unavailable */
 	if ((inq.avtcvp & 0x10) &&
-	    ((inq.asym_access_state_cur & 0x0F) == 0x3) &&
-	    (inq.vendor_specific_cur == 0x7)) {
+	    ((inq.asym_access_state_cur & 0x0F) == 0x3))
 		ret = PATH_DOWN;
 		goto done;
 	}
--
