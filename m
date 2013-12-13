From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] multipathd: enable core dumps for systemd
Date: Fri, 13 Dec 2013 10:11:17 +0100
Message-ID: <1386925879-31225-2-git-send-email-hare@suse.de>
References: <1386925879-31225-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386925879-31225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Add 'LimitCORE' definition to the service file to enable core
dumps when running under systemd.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/multipathd.service | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index 3874bcb..be3ba3f 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -8,6 +8,7 @@ Conflicts=shutdown.target
 [Service]
 Type=notify
 NotifyAccess=main
+LimitCORE=infinity
 ExecStartPre=/sbin/modprobe dm-multipath
 ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
-- 
1.8.1.4
