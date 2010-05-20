From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: close sysfs file after setting value
Date: Wed, 19 May 2010 22:59:57 -0500
Message-ID: <20100520035957.GS3295@ether.msp.redhat.com>
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

We need to close the sysfs file after setting its value.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/sysfs.c |    1 +
 1 file changed, 1 insertion(+)

Index: multipath-tools/libmultipath/sysfs.c
===================================================================
--- multipath-tools.orig/libmultipath/sysfs.c
+++ multipath-tools/libmultipath/sysfs.c
@@ -407,6 +407,7 @@ sysfs_attr_set_value(const char *devpath
 		    path_full, ret);
 		ret = -1;
 	}
+	close(fd);
 out:
 	return ret;
 }
