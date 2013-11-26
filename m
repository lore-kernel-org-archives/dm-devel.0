From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/9] multipathd: enable core dumps for systemd
Date: Tue, 26 Nov 2013 12:41:28 +0100
Message-ID: <1385466090-24290-8-git-send-email-hare@suse.de>
References: <1385466090-24290-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1385466090-24290-1-git-send-email-hare@suse.de>
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

Add 'LimitCORE' definition to the service file to enable core
dumps when running under systemd.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/multipathd.service.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/multipathd.service.in b/multipathd/multipathd.service.in
index 3874bcb..be3ba3f 100644
--- a/multipathd/multipathd.service.in
+++ b/multipathd/multipathd.service.in
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
