Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30929C77B7C
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 06:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681195460;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GaUDAyhCyEDX0r/e0jteQPSajGPSW1M4PJAKkxMUvoo=;
	b=Wo9UVLRY4/xFqDkB+cWxbxegEFn17B1Zi3H6pqyw4bMvBHajjQhsn3cskFsxZI89lkTWFh
	hlWISiYY4RgCcBaqxIyfgC10guBW23uJ3gETD+LMmhIRGZ7m4BXcJJm+h1DNv+xZ0+VivS
	PEoDrcm4o5ZhTMFDLxEnV/u/xmu3jEs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-pI2GK38MNz2clAqnC7hwtw-1; Tue, 11 Apr 2023 02:44:18 -0400
X-MC-Unique: pI2GK38MNz2clAqnC7hwtw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69A2B85C06A;
	Tue, 11 Apr 2023 06:44:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5868314171C3;
	Tue, 11 Apr 2023 06:44:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6407A19472F8;
	Tue, 11 Apr 2023 06:44:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F295519465B5
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Apr 2023 20:09:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D7D4E14171BE; Fri,  7 Apr 2023 20:09:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D0A2E1402C08
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:09:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B11D085C06A
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:09:17 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-OrR7sfmUNeGHZSUBfjD1TA-1; Fri, 07 Apr 2023 16:09:15 -0400
X-MC-Unique: OrR7sfmUNeGHZSUBfjD1TA-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 337FxDxu018772; Fri, 7 Apr 2023 20:06:38 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppb1dws0s-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 07 Apr 2023 20:06:38 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19)
 with ESMTP id 337IB9ak034233; Fri, 7 Apr 2023 20:06:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3pptjxefaw-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 07 Apr 2023 20:06:38 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 337K5trO010228;
 Fri, 7 Apr 2023 20:06:37 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-128-1.vpn.oracle.com
 [10.154.128.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id
 3pptjxeeam-17; Fri, 07 Apr 2023 20:06:37 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri,  7 Apr 2023 15:05:49 -0500
Message-Id: <20230407200551.12660-17-michael.christie@oracle.com>
In-Reply-To: <20230407200551.12660-1-michael.christie@oracle.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_12,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304070180
X-Proofpoint-GUID: XpTaNgBy509X8hCf_df6vmrGqD8QNWMH
X-Proofpoint-ORIG-GUID: XpTaNgBy509X8hCf_df6vmrGqD8QNWMH
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Tue, 11 Apr 2023 06:44:09 +0000
Subject: [dm-devel] [PATCH v6 16/18] scsi: target: Pass struct
 target_opcode_descriptor to enabled
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The iblock pr_ops support does not support commands that require port or
I_T Nexus info. This adds a struct target_opcode_descriptor as an argument
to the enabled callout so we can still have the common tcm_is_pr_enabled
and tcm_is_scsi2_reservations_enabled functions and also determine if the
command is supported based on the command and service action and device
settings.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_spc.c  | 40 +++++++++++++++++++------------
 include/target/target_core_base.h |  3 ++-
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 00d34616df5d..caf8d1325007 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1429,7 +1429,8 @@ static struct target_opcode_descriptor tcm_opcode_write_verify16 = {
 	.update_usage_bits = set_dpofua_usage_bits,
 };
 
-static bool tcm_is_ws_enabled(struct se_cmd *cmd)
+static bool tcm_is_ws_enabled(struct target_opcode_descriptor *descr,
+			      struct se_cmd *cmd)
 {
 	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
@@ -1456,7 +1457,8 @@ static struct target_opcode_descriptor tcm_opcode_write_same32 = {
 	.update_usage_bits = set_dpofua_usage_bits32,
 };
 
-static bool tcm_is_caw_enabled(struct se_cmd *cmd)
+static bool tcm_is_caw_enabled(struct target_opcode_descriptor *descr,
+			       struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1496,7 +1498,8 @@ static struct target_opcode_descriptor tcm_opcode_read_capacity16 = {
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_rep_ref_enabled(struct se_cmd *cmd)
+static bool tcm_is_rep_ref_enabled(struct target_opcode_descriptor *descr,
+				   struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1507,7 +1510,6 @@ static bool tcm_is_rep_ref_enabled(struct se_cmd *cmd)
 	}
 	spin_unlock(&dev->t10_alua.lba_map_lock);
 	return true;
-
 }
 
 static struct target_opcode_descriptor tcm_opcode_read_report_refferals = {
@@ -1542,7 +1544,8 @@ static struct target_opcode_descriptor tcm_opcode_sync_cache16 = {
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_unmap_enabled(struct se_cmd *cmd)
+static bool tcm_is_unmap_enabled(struct target_opcode_descriptor *descr,
+				 struct se_cmd *cmd)
 {
 	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
@@ -1664,7 +1667,8 @@ static struct target_opcode_descriptor tcm_opcode_pri_read_resrv = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_pr_enabled(struct se_cmd *cmd)
+static bool tcm_is_pr_enabled(struct target_opcode_descriptor *descr,
+			      struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1793,7 +1797,9 @@ static struct target_opcode_descriptor tcm_opcode_pro_register_move = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static bool tcm_is_scsi2_reservations_enabled(struct se_cmd *cmd)
+static bool
+tcm_is_scsi2_reservations_enabled(struct target_opcode_descriptor *descr,
+				  struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1854,7 +1860,8 @@ static struct target_opcode_descriptor tcm_opcode_inquiry = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_3pc_enabled(struct se_cmd *cmd)
+static bool tcm_is_3pc_enabled(struct target_opcode_descriptor *descr,
+			       struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1915,8 +1922,8 @@ static struct target_opcode_descriptor tcm_opcode_report_target_pgs = {
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
 };
 
-
-static bool spc_rsoc_enabled(struct se_cmd *cmd)
+static bool spc_rsoc_enabled(struct target_opcode_descriptor *descr,
+			     struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1936,7 +1943,8 @@ static struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
 	.enabled = spc_rsoc_enabled,
 };
 
-static bool tcm_is_set_tpg_enabled(struct se_cmd *cmd)
+static bool tcm_is_set_tpg_enabled(struct target_opcode_descriptor *descr,
+				   struct se_cmd *cmd)
 {
 	struct t10_alua_tg_pt_gp *l_tg_pt_gp;
 	struct se_lun *l_lun = cmd->se_lun;
@@ -2123,7 +2131,7 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			if (descr->serv_action_valid)
 				return TCM_INVALID_CDB_FIELD;
 
-			if (!descr->enabled || descr->enabled(cmd))
+			if (!descr->enabled || descr->enabled(descr, cmd))
 				*opcode = descr;
 			break;
 		case 0x2:
@@ -2137,7 +2145,8 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			 */
 			if (descr->serv_action_valid &&
 			    descr->service_action == requested_sa) {
-				if (!descr->enabled || descr->enabled(cmd))
+				if (!descr->enabled || descr->enabled(descr,
+								      cmd))
 					*opcode = descr;
 			} else if (!descr->serv_action_valid)
 				return TCM_INVALID_CDB_FIELD;
@@ -2150,7 +2159,8 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			 * be returned in the one_command parameter data format.
 			 */
 			if (descr->service_action == requested_sa)
-				if (!descr->enabled || descr->enabled(cmd))
+				if (!descr->enabled || descr->enabled(descr,
+								      cmd))
 					*opcode = descr;
 			break;
 		}
@@ -2207,7 +2217,7 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 
 		for (i = 0; i < ARRAY_SIZE(tcm_supported_opcodes); i++) {
 			descr = tcm_supported_opcodes[i];
-			if (descr->enabled && !descr->enabled(cmd))
+			if (descr->enabled && !descr->enabled(descr, cmd))
 				continue;
 
 			response_length += spc_rsoc_encode_command_descriptor(
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 12c9ba16217e..04646b3dbf75 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -878,7 +878,8 @@ struct target_opcode_descriptor {
 	u8			specific_timeout;
 	u16			nominal_timeout;
 	u16			recommended_timeout;
-	bool			(*enabled)(struct se_cmd *cmd);
+	bool			(*enabled)(struct target_opcode_descriptor *descr,
+					   struct se_cmd *cmd);
 	void			(*update_usage_bits)(u8 *usage_bits,
 						     struct se_device *dev);
 	u8			usage_bits[];
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

