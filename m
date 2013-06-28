From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 2/8] load the dm-multipath module on multipathd
	startup
Date: Fri, 28 Jun 2013 18:26:15 -0500
Message-ID: <1372461981-6333-3-git-send-email-bmarzins@redhat.com>
References: <1372461981-6333-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1372461981-6333-1-git-send-email-bmarzins@redhat.com>
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

This makes systemd modprobe dm-multipath before starting multipathd

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.service | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index d6da067..b9f1210 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -8,6 +8,7 @@ Conflicts=shutdown.target
 [Service]
 Type=forking
 PIDFile=/var/run/multipathd.pid
+ExecStartPre=/sbin/modprobe dm-multipath
 ExecStart=/sbin/multipathd
 ExecReload=/sbin/multipathd reconfigure
 #ExecStop=/path/to/scrip delete-me if not necessary
-- 
1.8.2
