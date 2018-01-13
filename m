From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 13/20] multipathd.service: drop
	Before=lvm2-lvmetad.service
Date: Sat, 13 Jan 2018 22:19:31 +0100
Message-ID: <20180113211938.31552-14-mwilck@suse.com>
References: <20180113211938.31552-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

lvm2-lvmetad does not depend on multipathd. On the contrary,
when multipathd sets up a map that contains LVM PVs, it's good
if lvm2-lvmetad is already running.
---
 multipathd/multipathd.service | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index fd66cf62af17..0cf99b2f2df5 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -1,7 +1,7 @@
 [Unit]
 Description=Device-Mapper Multipath Device Controller
 Wants=systemd-udev-trigger.service systemd-udev-settle.service
-Before=iscsi.service iscsid.service lvm2-lvmetad.service lvm2-activation-early.service
+Before=iscsi.service iscsid.service lvm2-activation-early.service
 Before=local-fs-pre.target blk-availability.service
 After=multipathd.socket systemd-udev-trigger.service systemd-udev-settle.service
 DefaultDependencies=no
-- 
2.15.1
