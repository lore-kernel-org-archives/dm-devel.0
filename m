From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 5/6] Fix broken major:minor device handling
Date: Thu, 11 Dec 2008 16:11:40 -0600
Message-ID: <20081211221140.GM1585@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

devt2devname was not actually setting devname, so multipath was not able to
do operate on devices using major:minor

This patch sets devname, and also checks for an unlikely buffer overrun.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: multipath-tools-081203/libmultipath/discovery.c
===================================================================
--- multipath-tools-081203.orig/libmultipath/discovery.c
+++ multipath-tools-081203/libmultipath/discovery.c
@@ -253,7 +253,11 @@ devt2devname (char *devname, char *devt)
 			continue;
 
 		if ((major == tmpmaj) && (minor == tmpmin)) {
-			sprintf(block_path, "/sys/block/%s", dev);
+			if (snprintf(block_path, FILE_NAME_SIZE, "/sys/block/%s", dev) >= FILE_NAME_SIZE) {
+				condlog(0, "device name %s is too long\n", dev);
+				fclose(fd);
+				return 1;
+			}
 			break;
 		}
 	}
@@ -271,6 +275,7 @@ devt2devname (char *devname, char *devt)
 		condlog(0, "sysfs entry %s is not a directory\n", block_path);
 		return 1;
 	}
+	basename(block_path, devname);
 	return 0;
 }
 
