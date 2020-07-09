From: mwilck@suse.com
Subject: [PATCH 38/39] libmultipath: print message if setting
	dev_loss_tmo is unsupported
Date: Thu,  9 Jul 2020 12:19:51 +0200
Message-ID: <20200709101952.7285-4-mwilck@suse.com>
References: <20200709101952.7285-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101952.7285-1-mwilck@suse.com>
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

If dev_loss_tmo can't be set because it's not supported for the
protocol at hand, let the user know.

Fixme: we could implement this for other protocols such as NVMe.
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e2aea81..c00af7e 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -33,6 +33,8 @@
 #include "unaligned.h"
 #include "prioritizers/alua_rtpg.h"
 #include "foreign.h"
+#include "configure.h"
+#include "print.h"
 
 struct vpd_vendor_page vpd_vendor_pages[VPD_VP_ARRAY_SIZE] = {
 	[VPD_VP_UNDEF]	= { 0x00, "undef" },
@@ -765,6 +767,7 @@ sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint)
 	struct path *pp;
 	int i;
 	unsigned int dev_loss_tmo = mpp->dev_loss;
+	struct path *err_path = NULL;
 
 	if (mpp->no_path_retry > 0) {
 		uint64_t no_path_retry_tmo =
@@ -795,12 +798,34 @@ sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint)
 		return 0;
 
 	vector_foreach_slot(mpp->paths, pp, i) {
-		if (pp->sg_id.proto_id == SCSI_PROTOCOL_FCP)
+		if (pp->bus != SYSFS_BUS_SCSI) {
+			if (!err_path)
+				err_path = pp;
+			continue;
+		}
+
+		switch (pp->sg_id.proto_id) {
+		case SCSI_PROTOCOL_FCP:
 			sysfs_set_rport_tmo(mpp, pp);
-		if (pp->sg_id.proto_id == SCSI_PROTOCOL_ISCSI)
+			continue;
+		case SCSI_PROTOCOL_ISCSI:
 			sysfs_set_session_tmo(mpp, pp);
-		if (pp->sg_id.proto_id == SCSI_PROTOCOL_SAS)
+			continue;
+		case SCSI_PROTOCOL_SAS:
 			sysfs_set_nexus_loss_tmo(mpp, pp);
+			continue;
+		default:
+			if (!err_path)
+				err_path = pp;
+		}
+	}
+
+	if (err_path) {
+		char proto_buf[32];
+
+		snprint_path_protocol(proto_buf, sizeof(proto_buf), err_path);
+		condlog(2, "%s: setting dev_loss_tmo is unsupported for protocol %s",
+			mpp->alias, proto_buf);
 	}
 	return 0;
 }
-- 
2.26.2
