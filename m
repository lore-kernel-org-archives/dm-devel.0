From: mwilck@suse.com
Subject: [PATCH 20/35] libmultipath: decrease log level of "SCSI
	target" log message
Date: Thu,  9 Jul 2020 12:16:05 +0200
Message-ID: <20200709101620.6786-21-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

... in sysfs_get_tgt_nodename().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index aa5942c..1039fc4 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -391,7 +391,7 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 		tgtdev = udev_device_new_from_subsystem_sysname(udev,
 				"fc_remote_ports", value);
 		if (tgtdev) {
-			condlog(3, "SCSI target %d:%d:%d -> "
+			condlog(4, "SCSI target %d:%d:%d -> "
 				"FC rport %d:%d-%d",
 				pp->sg_id.host_no, pp->sg_id.channel,
 				pp->sg_id.scsi_id, host, channel,
-- 
2.26.2
