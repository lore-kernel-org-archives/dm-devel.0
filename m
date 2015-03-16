From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/78] Fixup dependencies in multipathd.service
Date: Mon, 16 Mar 2015 13:35:58 +0100
Message-ID: <1426509425-15978-12-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The multipathd.service should be started after the .socket,
and it requires local-fs-pre to be reached.
Otherwise it won't be able to access /sys etc.

References: bnc#872712

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/multipathd.service | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index 1ecc151..b5b755b 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -2,8 +2,9 @@
 Description=Device-Mapper Multipath Device Controller
 Before=iscsi.service iscsid.service lvm2-activation-early.service
 Before=local-fs-pre.target
+After=multipathd.socket
 DefaultDependencies=no
-Wants=multipathd.socket
+Wants=local-fs-pre.target multipathd.socket
 Conflicts=shutdown.target
 
 [Service]
-- 
1.8.4.5
