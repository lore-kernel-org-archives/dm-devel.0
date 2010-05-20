From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: fix fast_io_fail_tmo typo
Date: Wed, 19 May 2010 22:57:52 -0500
Message-ID: <20100520035752.GR3295@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The name of the sysfs file is actually fast_io_fail_tmo, not fast_io_fail

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: multipath-tools-100510/libmultipath/discovery.c
===================================================================
--- multipath-tools-100510.orig/libmultipath/discovery.c
+++ multipath-tools-100510/libmultipath/discovery.c
@@ -233,7 +233,7 @@ sysfs_set_scsi_tmo (struct multipath *mp
 				sprintf(value, "off");
 			else
 				snprintf(value, 11, "%u", mpp->fast_io_fail);
-			if (sysfs_attr_set_value(attr_path, "fast_io_fail",
+			if (sysfs_attr_set_value(attr_path, "fast_io_fail_tmo",
 						 value))
 				return 1;
 		}
