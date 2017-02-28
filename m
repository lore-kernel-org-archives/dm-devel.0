From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 02/33] multipathd: start daemon after udev trigger
Date: Tue, 28 Feb 2017 17:22:58 +0100
Message-ID: <20170228162329.14517-3-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>

As multipath now relies on udev for device enumeration it needs
to be started after udev trigger has finished sending all events.
Otherwise the daemon will not find any devices during startup
(as udev trigger hasn't been called yet and the udev database is empty).
But after switchover from the initrd there will already be some
multipath device-mapper tables, for which the daemon cannot find
any device. Consequently the daemon will be removing these tables,
only to recreate them later on once udev trigger has run.
This induces a short window during which the device mapper devices
won't be present, causing systemd to umount devices or drop into
emergency mode.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/multipathd.service | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index be13138c..126012b8 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -1,8 +1,9 @@
 [Unit]
 Description=Device-Mapper Multipath Device Controller
+Wants=systemd-udev-trigger.service systemd-udev-settle.service
 Before=iscsi.service iscsid.service lvm2-lvmetad.service lvm2-activation-early.service
-Before=local-fs-pre.target systemd-udev-trigger.service blk-availability.service
-After=multipathd.socket systemd-udevd.service
+Before=local-fs-pre.target blk-availability.service
+After=multipathd.socket systemd-udev-trigger.service systemd-udev-settle.service
 DefaultDependencies=no
 Conflicts=shutdown.target
 
-- 
2.11.0
