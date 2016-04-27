From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 25/57] Load all device handler modules on startup
Date: Wed, 27 Apr 2016 13:10:26 +0200
Message-ID: <1461755458-29225-26-git-send-email-hare@suse.de>
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

Upon multipathd startup the device handler modules are not
necessarily loaded, so we need to load them prior to startup.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/multipathd.service | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index eb85bee..b2afd90 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -11,7 +11,7 @@ Conflicts=shutdown.target
 Type=notify
 NotifyAccess=main
 LimitCORE=infinity
-ExecStartPre=/sbin/modprobe dm-multipath
+ExecStartPre=/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac dm-multipath
 ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
 
-- 
2.6.6
