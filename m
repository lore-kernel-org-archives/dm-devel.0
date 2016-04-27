From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/57] Ensure multipathd is started before
	systemd-udev-trigger.service
Date: Wed, 27 Apr 2016 13:10:28 +0200
Message-ID: <1461755458-29225-28-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

We should be starting multipathd before systemd-udev-trigger
is started to reduce the load on udev during startup.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/multipathd.service | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index b2afd90..e3d6f91 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -1,7 +1,7 @@
 [Unit]
 Description=Device-Mapper Multipath Device Controller
 Before=iscsi.service iscsid.service lvm2-activation-early.service
-Before=local-fs-pre.target
+Before=local-fs-pre.target systemd-udev-trigger.service
 After=multipathd.socket systemd-udevd.service
 DefaultDependencies=no
 Wants=local-fs-pre.target multipathd.socket blk-availability.service
-- 
2.6.6
