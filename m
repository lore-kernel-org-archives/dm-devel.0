From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 16/17] multipathd.service: remove
	blk-availability Requires
Date: Mon, 28 Mar 2016 22:13:13 -0500
Message-ID: <1459221194-23222-17-git-send-email-bmarzins@redhat.com>
References: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

multipathd.service can start up and run just fine without
blk-availability.service. It is only necessary to coordinate shutdown
order in certain multipath setups (over iscsi for instance). Thus,
instead of "Requires", multipathd.service should use "Wants"

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.service | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index fc2e009..d5f8606 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -1,11 +1,10 @@
 [Unit]
 Description=Device-Mapper Multipath Device Controller
-Requires=blk-availability.service
 Before=iscsi.service iscsid.service lvm2-activation-early.service
 Before=local-fs-pre.target
 After=multipathd.socket
 DefaultDependencies=no
-Wants=local-fs-pre.target multipathd.socket
+Wants=local-fs-pre.target multipathd.socket blk-availability.service
 Conflicts=shutdown.target
 
 [Service]
-- 
1.8.3.1
