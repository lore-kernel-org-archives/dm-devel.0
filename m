From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/13] multipathd: enable core dumps for systemd
Date: Fri, 15 Nov 2013 11:29:41 +0100
Message-ID: <1384511384-27642-11-git-send-email-hare@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384511384-27642-1-git-send-email-hare@suse.de>
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
index 848a231..6472dd5 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -11,6 +11,7 @@ NotifyAccess=main
 ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
 WatchdogSec=5s
+LimitCORE=infinity
 
 [Install]
 WantedBy=sysinit.target
-- 
1.8.1.4
