From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 01/33] multipathd.service: fixup Wants= and
	Before= statements
Date: Tue, 28 Feb 2017 17:22:57 +0100
Message-ID: <20170228162329.14517-2-mwilck@suse.com>
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

With the latest LVM2 update we now have the 'lvm2-lvmetad.service'.
Also we need to specify 'blk-availability.service' in the 'Before='
statement, as just adding it to 'Wants=' assumes the multipathd
service should be running after the blk-availability service.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/multipathd.service | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index d26577f3..be13138c 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -1,10 +1,9 @@
 [Unit]
 Description=Device-Mapper Multipath Device Controller
-Before=iscsi.service iscsid.service lvm2-activation-early.service
-Before=local-fs-pre.target systemd-udev-trigger.service
+Before=iscsi.service iscsid.service lvm2-lvmetad.service lvm2-activation-early.service
+Before=local-fs-pre.target systemd-udev-trigger.service blk-availability.service
 After=multipathd.socket systemd-udevd.service
 DefaultDependencies=no
-Wants=local-fs-pre.target multipathd.socket blk-availability.service
 Conflicts=shutdown.target
 
 [Service]
-- 
2.11.0
