From: Guido Guenther <agx@sigxcpu.org>
Subject: [PATCH] Fix segfault on disappearing paths
Date: Sat,  9 Jun 2007 17:29:20 +0200
Message-ID: <11814029602134-git-send-email-agx@sigxcpu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The path might already be gone when we process the udev event, in this case
sysfs_device_get return NULL:

Jun 09 16:56:06 | ID_FS_LABEL=
Jun 09 16:56:06 | ID_FS_LABEL_SAFE=
Jun 09 16:56:06 | DEVLINKS=/dev/disk/by-id/scsi-1494554000000000000000000000000010000069d0000000d /dev/disk/by-path/ip-10.0.0.3:3260-iscsi-iqn.2006-12.nix.rs45:storage.disk1-lun-0 /dev/disk/by-uuid/c8db60a3-7795-45cd-8369-a0f9ee876032
Jun 09 16:56:06 | DEVNAME=/dev/sda
/block/sda
open '/block/sda'
stat '/sys/block/sda' failed: No such file or directory
Segmentation fault (core dumped)

Signed-off-by: Guido Guenther <agx@sigxcpu.org>
---
 multipathd/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index a173da3..c432331 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -635,6 +635,9 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 		return 0;
 
 	sysdev = sysfs_device_get(uev->devpath);
+	if(!sysdev)
+		return 0;	
+
 	lock(vecs->lock);
 
 	/*
-- 
1.5.2.1
