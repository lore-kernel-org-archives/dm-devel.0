From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove getuid/usb_id
Date: Sat,  5 Nov 2016 00:24:14 +0100
Message-ID: <20161104232414.5695-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Unnecessary, because getuid_callout was superseded by uid_attribute.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 getuid/usb_id | 6 ------
 1 file changed, 6 deletions(-)
 delete mode 100755 getuid/usb_id

diff --git a/getuid/usb_id b/getuid/usb_id
deleted file mode 100755
index 800e471..0000000
--- a/getuid/usb_id
+++ /dev/null
@@ -1,6 +0,0 @@
-#!/bin/sh
-#
-# copy in /bin and add this line to a device block in multipath.conf :
-# getuid_callout          "/bin/usb_id %n"
-#
-cd /sys/block/$1 && cd $(ls -l device|cut -d">" -f2) && cd ../../../.. && cat serial
-- 
2.10.2
