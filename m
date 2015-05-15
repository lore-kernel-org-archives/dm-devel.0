From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 09/10] Make multipath deactivate devices before
	iscsi shutdown
Date: Fri, 15 May 2015 18:14:12 -0500
Message-ID: <1431731653-3892-10-git-send-email-bmarzins@redhat.com>
References: <1431731653-3892-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1431731653-3892-1-git-send-email-bmarzins@redhat.com>
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

The multipath devices need to be deactivated before iscsi is shutdown,
otherwise the multipath devices will generate a lot of error messages
when it loses its iscsi path devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.service | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index b5b755b..fc2e009 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -1,5 +1,6 @@
 [Unit]
 Description=Device-Mapper Multipath Device Controller
+Requires=blk-availability.service
 Before=iscsi.service iscsid.service lvm2-activation-early.service
 Before=local-fs-pre.target
 After=multipathd.socket
-- 
1.8.3.1
