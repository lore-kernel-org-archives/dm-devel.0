From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 16/20] multipathd.service: set
	TasksMax=infinity
Date: Sat, 13 Jan 2018 22:19:34 +0100
Message-ID: <20180113211938.31552-17-mwilck@suse.com>
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

Systemd 228 introduced a global task limit of 512 for system services.
System 231 changed this to 15% of pid_max, or 4915.
In particular the one of systemd 228 is too low for multipathd with
many LUNs. Use TasksMax=infinity to overcome this limitation.
---
 multipathd/multipathd.service | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index 0cf99b2f2df5..ba24983ef291 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -16,6 +16,7 @@ LimitCORE=infinity
 ExecStartPre=-/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac dm-multipath
 ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
+TasksMax=infinity
 
 [Install]
 WantedBy=sysinit.target
-- 
2.15.1
