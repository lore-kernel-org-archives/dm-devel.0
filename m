From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 06/10] multipathd: add new protocol path wildcard
Date: Fri, 13 Jul 2018 14:39:11 -0500
Message-ID: <1531510755-16046-7-git-send-email-bmarzins@redhat.com>
References: <1531510755-16046-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1531510755-16046-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This patch adds a new path wildcard 'P', that will print the path's
protocol.  For scsi devices, it will additionally print the transport
protocol being used.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 libmultipath/print.h |  2 ++
 2 files changed, 45 insertions(+)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 222d270..ecfcb48 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -638,6 +638,48 @@ snprint_path_failures(char * buff, size_t len, const struct path * pp)
 	return snprint_int(buff, len, pp->failcount);
 }
 
+/* if you add a protocol string bigger than "scsi:unspec" you must
+ * also change PROTOCOL_BUF_SIZE */
+int
+snprint_path_protocol(char * buff, size_t len, const struct path * pp)
+{
+	switch (pp->bus) {
+	case SYSFS_BUS_SCSI:
+		switch (pp->sg_id.proto_id) {
+		case SCSI_PROTOCOL_FCP:
+			return snprintf(buff, len, "scsi:fcp");
+		case SCSI_PROTOCOL_SPI:
+			return snprintf(buff, len, "scsi:spi");
+		case SCSI_PROTOCOL_SSA:
+			return snprintf(buff, len, "scsi:ssa");
+		case SCSI_PROTOCOL_SBP:
+			return snprintf(buff, len, "scsi:sbp");
+		case SCSI_PROTOCOL_SRP:
+			return snprintf(buff, len, "scsi:srp");
+		case SCSI_PROTOCOL_ISCSI:
+			return snprintf(buff, len, "scsi:iscsi");
+		case SCSI_PROTOCOL_SAS:
+			return snprintf(buff, len, "scsi:sas");
+		case SCSI_PROTOCOL_ADT:
+			return snprintf(buff, len, "scsi:adt");
+		case SCSI_PROTOCOL_ATA:
+			return snprintf(buff, len, "scsi:ata");
+		case SCSI_PROTOCOL_UNSPEC:
+		default:
+			return snprintf(buff, len, "scsi:unspec");
+		}
+	case SYSFS_BUS_CCW:
+		return snprintf(buff, len, "ccw");
+	case SYSFS_BUS_CCISS:
+		return snprintf(buff, len, "cciss");
+	case SYSFS_BUS_NVME:
+		return snprintf(buff, len, "nvme");
+	case SYSFS_BUS_UNDEF:
+	default:
+		return snprintf(buff, len, "undef");
+	}
+}
+
 struct multipath_data mpd[] = {
 	{'n', "name",          0, snprint_name},
 	{'w', "uuid",          0, snprint_multipath_uuid},
@@ -687,6 +729,7 @@ struct path_data pd[] = {
 	{'a', "host adapter",  0, snprint_host_adapter},
 	{'G', "foreign",       0, snprint_path_foreign},
 	{'0', "failures",      0, snprint_path_failures},
+	{'P', "protocol",      0, snprint_path_protocol},
 	{0, NULL, 0 , NULL}
 };
 
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 608b7d5..e2fb865 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -133,6 +133,8 @@ int snprint_host_wwnn (char *, size_t, const struct path *);
 int snprint_host_wwpn (char *, size_t, const struct path *);
 int snprint_tgt_wwnn (char *, size_t, const struct path *);
 int snprint_tgt_wwpn (char *, size_t, const struct path *);
+#define PROTOCOL_BUF_SIZE sizeof("scsi:unspec")
+int snprint_path_protocol(char *, size_t, const struct path *);
 
 void _print_multipath_topology (const struct gen_multipath * gmp,
 				int verbosity);
-- 
2.7.4
