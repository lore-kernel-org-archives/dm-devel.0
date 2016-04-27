From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/57] Add dependency on systemd-udevd.service
Date: Wed, 27 Apr 2016 13:10:25 +0200
Message-ID: <1461755458-29225-25-git-send-email-hare@suse.de>
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

During startup libdevmapper checks if udev is running or not.
And if it finds udev is _not_ running it'll create the device-nodes
internally, regardless on any magic ioctl flags.
This results in the occasionally message 'conflicting device node found'
in the syslog.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/multipathd.service | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index d5f8606..eb85bee 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -2,7 +2,7 @@
 Description=Device-Mapper Multipath Device Controller
 Before=iscsi.service iscsid.service lvm2-activation-early.service
 Before=local-fs-pre.target
-After=multipathd.socket
+After=multipathd.socket systemd-udevd.service
 DefaultDependencies=no
 Wants=local-fs-pre.target multipathd.socket blk-availability.service
 Conflicts=shutdown.target
-- 
2.6.6
