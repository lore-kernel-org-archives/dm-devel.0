From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/57] libmultipath: correctly initialize
	pp->sg_id
Date: Wed, 27 Apr 2016 13:10:15 +0200
Message-ID: <1461755458-29225-15-git-send-email-hare@suse.de>
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

The default SCSI protocol is 'SCSI_PROTOCOL_UNSPEC';
'0' is SCSI_PROTOCOL_FCP.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/structs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 0538327..b773d1c 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -94,6 +94,7 @@ alloc_path (void)
 		pp->sg_id.channel = -1;
 		pp->sg_id.scsi_id = -1;
 		pp->sg_id.lun = -1;
+		pp->sg_id.proto_id = SCSI_PROTOCOL_UNSPEC;
 		pp->fd = -1;
 		pp->priority = PRIO_UNDEF;
 	}
-- 
2.6.6
