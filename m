From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 4/5] multipath-tools: indent switch and case at
	the same level
Date: Wed,  3 Aug 2016 20:13:59 +0200
Message-ID: <1470248040-11789-4-git-send-email-xose.vazquez@gmail.com>
References: <1470248040-11789-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470248040-11789-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Found by checkpatch - ERROR: switch and case should be at the same indent

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/kpartx.c                  |   5 +-
 libmpathpersist/mpath_pr_ioctl.c | 118 +++++++++++++++++++--------------------
 libmultipath/prioritizers/alua.c |  52 ++++++++---------
 mpathpersist/main.c              |  60 ++++++++++----------
 multipathd/main.c                |   2 +-
 5 files changed, 119 insertions(+), 118 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index b7b4047..d31fea8 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -258,7 +258,8 @@ main(int argc, char **argv){
 		exit(1);
 	}
 
-	while ((arg = getopt(argc, argv, short_opts)) != EOF) switch(arg) {
+	while ((arg = getopt(argc, argv, short_opts)) != EOF)
+		switch(arg) {
 		case 'r':
 			ro=1;
 			break;
@@ -295,7 +296,7 @@ main(int argc, char **argv){
 		default:
 			usage();
 			exit(1);
-	}
+		}
 
 #ifdef LIBDM_API_COOKIE
 	if (!udev_sync)
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 48d36e9..8b9ac3d 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -272,22 +272,22 @@ decode_transport_id(struct prin_fulldescr *fdesc, unsigned char * p, int length)
 		fdesc->trnptid.format_code = ((p[0] >> 6) & 0x3);
 		fdesc->trnptid.protocol_id = (p[0] & 0xf);
 		switch (fdesc->trnptid.protocol_id) {
-			case MPATH_PROTOCOL_ID_FC:
-				memcpy(&fdesc->trnptid.n_port_name, &p[8], 8);
-				jump = 24;
-				break;
-			case MPATH_PROTOCOL_ID_ISCSI:
-				num = ((p[2] << 8) | p[3]);
-				memcpy(&fdesc->trnptid.iscsi_name, &p[4], num);
-				jump = (((num + 4) < 24) ? 24 : num + 4);
-				break;
-			case MPATH_PROTOCOL_ID_SAS:
-				memcpy(&fdesc->trnptid.sas_address, &p[4], 8);
-				jump = 24;
-				break;
-			default:
-				jump = 24;
-				break;
+		case MPATH_PROTOCOL_ID_FC:
+			memcpy(&fdesc->trnptid.n_port_name, &p[8], 8);
+			jump = 24;
+			break;
+		case MPATH_PROTOCOL_ID_ISCSI:
+			num = ((p[2] << 8) | p[3]);
+			memcpy(&fdesc->trnptid.iscsi_name, &p[4], num);
+			jump = (((num + 4) < 24) ? 24 : num + 4);
+			break;
+		case MPATH_PROTOCOL_ID_SAS:
+			memcpy(&fdesc->trnptid.sas_address, &p[4], 8);
+			jump = 24;
+			break;
+		default:
+			jump = 24;
+			break;
 		}
 	}
 }
@@ -411,57 +411,57 @@ int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr,
 		return MPATH_PR_SUCCESS;
 
 	switch(io_hdr.status) {
-		case SAM_STAT_GOOD:
-			break;
-		case SAM_STAT_CHECK_CONDITION:
-			condlog(2, "%s: Sense_Key=%02x, ASC=%02x ASCQ=%02x",
-				dev, Sensedata->Sense_Key,
-				Sensedata->ASC, Sensedata->ASCQ);
-			switch(Sensedata->Sense_Key) {
-				case NO_SENSE:
-					return MPATH_PR_NO_SENSE;
-				case RECOVERED_ERROR:
-					return MPATH_PR_SUCCESS;
-				case NOT_READY:
-					return MPATH_PR_SENSE_NOT_READY;
-				case MEDIUM_ERROR:
-					return MPATH_PR_SENSE_MEDIUM_ERROR;
-				case BLANK_CHECK:
-					return MPATH_PR_OTHER;
-				case HARDWARE_ERROR:
-					return MPATH_PR_SENSE_HARDWARE_ERROR;
-				case ILLEGAL_REQUEST:
-					return MPATH_PR_ILLEGAL_REQ;
-				case UNIT_ATTENTION:
-					return MPATH_PR_SENSE_UNIT_ATTENTION;
-				case DATA_PROTECT:
-				case COPY_ABORTED:
-					return MPATH_PR_OTHER;
-				case ABORTED_COMMAND:
-					return MPATH_PR_SENSE_ABORTED_COMMAND;
-
-				default :
-					return MPATH_PR_OTHER;
-			}
-		case SAM_STAT_RESERVATION_CONFLICT:
-			return MPATH_PR_RESERV_CONFLICT;
+	case SAM_STAT_GOOD:
+		break;
+	case SAM_STAT_CHECK_CONDITION:
+		condlog(2, "%s: Sense_Key=%02x, ASC=%02x ASCQ=%02x",
+			dev, Sensedata->Sense_Key,
+			Sensedata->ASC, Sensedata->ASCQ);
+		switch(Sensedata->Sense_Key) {
+		case NO_SENSE:
+			return MPATH_PR_NO_SENSE;
+		case RECOVERED_ERROR:
+			return MPATH_PR_SUCCESS;
+		case NOT_READY:
+			return MPATH_PR_SENSE_NOT_READY;
+		case MEDIUM_ERROR:
+			return MPATH_PR_SENSE_MEDIUM_ERROR;
+		case BLANK_CHECK:
+			return MPATH_PR_OTHER;
+		case HARDWARE_ERROR:
+			return MPATH_PR_SENSE_HARDWARE_ERROR;
+		case ILLEGAL_REQUEST:
+			return MPATH_PR_ILLEGAL_REQ;
+		case UNIT_ATTENTION:
+			return MPATH_PR_SENSE_UNIT_ATTENTION;
+		case DATA_PROTECT:
+		case COPY_ABORTED:
+			return MPATH_PR_OTHER;
+		case ABORTED_COMMAND:
+			return MPATH_PR_SENSE_ABORTED_COMMAND;
 
 		default :
-			return  MPATH_PR_OTHER;
+			return MPATH_PR_OTHER;
+		}
+	case SAM_STAT_RESERVATION_CONFLICT:
+		return MPATH_PR_RESERV_CONFLICT;
+
+	default :
+		return  MPATH_PR_OTHER;
 	}
 
 	switch(io_hdr.host_status) {
-		case DID_OK :
-			break;
-		default :
-			return MPATH_PR_OTHER;
+	case DID_OK :
+		break;
+	default :
+		return MPATH_PR_OTHER;
 	}
 	switch(io_hdr.driver_status)
 	{
-		case DRIVER_OK:
-			break;
-		default :
-			return MPATH_PR_OTHER;
+	case DRIVER_OK:
+		break;
+	default :
+		return MPATH_PR_OTHER;
 	}
 	return MPATH_PR_SUCCESS;
 }
diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index a1c59fd..5636974 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -107,37 +107,37 @@ int getprio (struct path * pp, char * args, unsigned int timeout)
 		aas = (rc & 0x0f);
 		priopath = (rc & 0x80);
 		switch(aas) {
-			case AAS_OPTIMIZED:
-				rc = 50;
-				break;
-			case AAS_NON_OPTIMIZED:
-				rc = 10;
-				break;
-			case AAS_LBA_DEPENDENT:
-				rc = 5;
-				break;
-			case AAS_STANDBY:
-				rc = 1;
-				break;
-			default:
-				rc = 0;
+		case AAS_OPTIMIZED:
+			rc = 50;
+			break;
+		case AAS_NON_OPTIMIZED:
+			rc = 10;
+			break;
+		case AAS_LBA_DEPENDENT:
+			rc = 5;
+			break;
+		case AAS_STANDBY:
+			rc = 1;
+			break;
+		default:
+			rc = 0;
 		}
 		if (priopath && (aas != AAS_OPTIMIZED || exclusive_pref))
 			rc += 80;
 	} else {
 		switch(-rc) {
-			case ALUA_PRIO_NOT_SUPPORTED:
-				condlog(0, "%s: alua not supported", pp->dev);
-				break;
-			case ALUA_PRIO_RTPG_FAILED:
-				condlog(0, "%s: couldn't get target port group", pp->dev);
-				break;
-			case ALUA_PRIO_GETAAS_FAILED:
-				condlog(0, "%s: couldn't get asymmetric access state", pp->dev);
-				break;
-			case ALUA_PRIO_TPGS_FAILED:
-				condlog(3, "%s: couldn't get supported alua states", pp->dev);
-				break;
+		case ALUA_PRIO_NOT_SUPPORTED:
+			condlog(0, "%s: alua not supported", pp->dev);
+			break;
+		case ALUA_PRIO_RTPG_FAILED:
+			condlog(0, "%s: couldn't get target port group", pp->dev);
+			break;
+		case ALUA_PRIO_GETAAS_FAILED:
+			condlog(0, "%s: couldn't get asymmetric access state", pp->dev);
+			break;
+		case ALUA_PRIO_TPGS_FAILED:
+			condlog(3, "%s: couldn't get supported alua states", pp->dev);
+			break;
 		}
 	}
 	return rc;
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 2cf0a9c..a55865f 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -720,37 +720,37 @@ void
 mpath_print_transport_id(struct prin_fulldescr *fdesc)
 {
 	switch (fdesc->trnptid.protocol_id) {
-		case MPATH_PROTOCOL_ID_FC:
-			printf("   FCP-2 ");
-			if (0 != fdesc->trnptid.format_code)
-				printf(" [Unexpected format code: %d]\n",
-						fdesc->trnptid.format_code);
-			dumpHex((const char *)fdesc->trnptid.n_port_name, 8, 0);
-			break;
-		case MPATH_PROTOCOL_ID_ISCSI:
-			printf("   iSCSI ");
-			if (0 == fdesc->trnptid.format_code) {
-				printf("name: %.*s\n", (int)sizeof(fdesc->trnptid.iscsi_name),
+	case MPATH_PROTOCOL_ID_FC:
+		printf("   FCP-2 ");
+		if (0 != fdesc->trnptid.format_code)
+			printf(" [Unexpected format code: %d]\n",
+					fdesc->trnptid.format_code);
+		dumpHex((const char *)fdesc->trnptid.n_port_name, 8, 0);
+		break;
+	case MPATH_PROTOCOL_ID_ISCSI:
+		printf("   iSCSI ");
+		if (0 == fdesc->trnptid.format_code) {
+			printf("name: %.*s\n", (int)sizeof(fdesc->trnptid.iscsi_name),
+				fdesc->trnptid.iscsi_name);
+		}else if (1 == fdesc->trnptid.format_code){
+			printf("world wide unique port id: %.*s\n",
+					(int)sizeof(fdesc->trnptid.iscsi_name),
 					fdesc->trnptid.iscsi_name);
-			}else if (1 == fdesc->trnptid.format_code){
-				printf("world wide unique port id: %.*s\n",
-						(int)sizeof(fdesc->trnptid.iscsi_name),
-						fdesc->trnptid.iscsi_name);
-			}else {
-				printf("  [Unexpected format code: %d]\n", fdesc->trnptid.format_code);
-				dumpHex((const char *)fdesc->trnptid.iscsi_name,
-					 (int)sizeof(fdesc->trnptid.iscsi_name), 0);
-			}
-			break;
-		case MPATH_PROTOCOL_ID_SAS:
-			printf("   SAS ");
-			if (0 != fdesc->trnptid.format_code)
-				printf(" [Unexpected format code: %d]\n",
-						fdesc->trnptid.format_code);
-			dumpHex((const char *)fdesc->trnptid.sas_address, 8, 0);
-			break;
-		default:
-			return;
+		}else {
+			printf("  [Unexpected format code: %d]\n", fdesc->trnptid.format_code);
+			dumpHex((const char *)fdesc->trnptid.iscsi_name,
+				 (int)sizeof(fdesc->trnptid.iscsi_name), 0);
+		}
+		break;
+	case MPATH_PROTOCOL_ID_SAS:
+		printf("   SAS ");
+		if (0 != fdesc->trnptid.format_code)
+			printf(" [Unexpected format code: %d]\n",
+					fdesc->trnptid.format_code);
+		dumpHex((const char *)fdesc->trnptid.sas_address, 8, 0);
+		break;
+	default:
+		return;
 	}
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 20589a7..ec3b907 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2536,7 +2536,7 @@ main (int argc, char *argv[])
 	udev = udev_new();
 
 	while ((arg = getopt(argc, argv, ":dsv:k::Bn")) != EOF ) {
-	switch(arg) {
+		switch(arg) {
 		case 'd':
 			foreground = 1;
 			if (logsink > 0)
-- 
2.7.4
