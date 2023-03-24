Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 397C0C7619A
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 05:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679895709;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4I8yc5Pk7dwdFcwIQM6wBPw/4LTW8byT/B0lk7vVW4c=;
	b=hy697e7sahE1Z/yVpnohToyBB6diRi6j4EJrUYTDQrcRGqzrqqUad02RFEmE/0eOSakCyi
	wW8w288R0bUE0onCvdbAZabW8B8e8USz0qsy2sKP0QshskDuMpgTm+W0M/j+rgRec0RvKq
	kecVz54Vx7AHMTGp3UqBB8I4be2DUEk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-tm42tokzNHmd5uHzTNhB2Q-1; Mon, 27 Mar 2023 01:41:45 -0400
X-MC-Unique: tm42tokzNHmd5uHzTNhB2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7997F101A550;
	Mon, 27 Mar 2023 05:41:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6674A111F3CB;
	Mon, 27 Mar 2023 05:41:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF610194974B;
	Mon, 27 Mar 2023 05:41:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 42A721946A62
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 18:20:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 24698492B00; Fri, 24 Mar 2023 18:20:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CA23492C3E
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 18:20:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 010C3884EC0
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 18:20:42 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-BrRCGQZSO_eJ4urFgDZ19g-1; Fri, 24 Mar 2023 14:20:40 -0400
X-MC-Unique: BrRCGQZSO_eJ4urFgDZ19g-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 32OI07Jv032520; Fri, 24 Mar 2023 18:18:26 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phgrj81b0-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Mar 2023 18:18:26 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 32OGTfgh001408; Fri, 24 Mar 2023 18:18:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3pgxk4bxsc-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Mar 2023 18:18:25 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OIHiEr021017;
 Fri, 24 Mar 2023 18:18:25 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-153-54.vpn.oracle.com
 [10.154.153.54])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id
 3pgxk4bx19-18; Fri, 24 Mar 2023 18:18:25 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Mar 2023 13:17:40 -0500
Message-Id: <20230324181741.13908-18-michael.christie@oracle.com>
In-Reply-To: <20230324181741.13908-1-michael.christie@oracle.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240143
X-Proofpoint-GUID: sRBEZvBdJwyK4Up3LOM7m3caYXj3Y0UB
X-Proofpoint-ORIG-GUID: sRBEZvBdJwyK4Up3LOM7m3caYXj3Y0UB
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 27 Mar 2023 05:41:34 +0000
Subject: [dm-devel] [PATCH v5 17/18] scsi: target: Report and detect
 unsupported PR commands
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The backend modules don't know about ports and I_T nexuses and the pr_ops
callouts the modules will use don't support the old RESERVE/RELEASE
commands. This patch has us report we don't support those types of
commands and fail them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_pr.c  | 17 ++++++++
 drivers/target/target_core_spc.c | 75 +++++++++++++++++++++++---------
 2 files changed, 72 insertions(+), 20 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index e16ef7d676af..7a3f07979a02 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3554,6 +3554,18 @@ target_try_pr_out_pt(struct se_cmd *cmd, u8 sa, u64 res_key, u64 sa_res_key,
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
+	switch (sa) {
+	case PRO_REGISTER_AND_MOVE:
+	case PRO_REPLACE_LOST_RESERVATION:
+		pr_err("SPC-3 PR: PRO_REGISTER_AND_MOVE and PRO_REPLACE_LOST_RESERVATION are not supported by PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	if (spec_i_pt || all_tg_pt) {
+		pr_err("SPC-3 PR: SPEC_I_PT and ALL_TG_PT are not supported by PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
 	return ops->execute_pr_out(cmd, sa, res_key, sa_res_key, type, aptpl);
 }
 
@@ -4082,6 +4094,11 @@ static sense_reason_t target_try_pr_in_pt(struct se_cmd *cmd, u8 sa)
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
+	if (sa == PRI_READ_FULL_STATUS) {
+		pr_err("SPC-3 PR: PRI_READ_FULL_STATUS is not supported by PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
 	buf = transport_kmap_data_sg(cmd);
 	if (!buf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index caf8d1325007..053bd2eea0e6 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1672,7 +1672,41 @@ static bool tcm_is_pr_enabled(struct target_opcode_descriptor *descr,
 {
 	struct se_device *dev = cmd->se_dev;
 
-	return dev->dev_attrib.emulate_pr;
+	if (!dev->dev_attrib.emulate_pr)
+		return false;
+
+	if (!(dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
+		return true;
+
+	switch (descr->opcode) {
+	case RESERVE:
+	case RESERVE_10:
+	case RELEASE:
+	case RELEASE_10:
+		/*
+		 * The pr_ops which are used by the backend modules don't
+		 * support these commands.
+		 */
+		return false;
+	case PERSISTENT_RESERVE_OUT:
+		switch (descr->service_action) {
+		case PRO_REGISTER_AND_MOVE:
+		case PRO_REPLACE_LOST_RESERVATION:
+			/*
+			 * The backend modules don't have access to ports and
+			 * I_T nexuses so they can't handle these type of
+			 * requests.
+			 */
+			return false;
+		}
+		break;
+	case PERSISTENT_RESERVE_IN:
+		if (descr->service_action == PRI_READ_FULL_STATUS)
+			return false;
+		break;
+	}
+
+	return true;
 }
 
 static struct target_opcode_descriptor tcm_opcode_pri_read_caps = {
@@ -1797,22 +1831,13 @@ static struct target_opcode_descriptor tcm_opcode_pro_register_move = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static bool
-tcm_is_scsi2_reservations_enabled(struct target_opcode_descriptor *descr,
-				  struct se_cmd *cmd)
-{
-	struct se_device *dev = cmd->se_dev;
-
-	return dev->dev_attrib.emulate_pr;
-}
-
 static struct target_opcode_descriptor tcm_opcode_release = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = RELEASE,
 	.cdb_size = 6,
 	.usage_bits = {RELEASE, 0x00, 0x00, 0x00,
 		       0x00, SCSI_CONTROL_MASK},
-	.enabled = tcm_is_scsi2_reservations_enabled,
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_release10 = {
@@ -1822,7 +1847,7 @@ static struct target_opcode_descriptor tcm_opcode_release10 = {
 	.usage_bits = {RELEASE_10, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0x00, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
-	.enabled = tcm_is_scsi2_reservations_enabled,
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_reserve = {
@@ -1831,7 +1856,7 @@ static struct target_opcode_descriptor tcm_opcode_reserve = {
 	.cdb_size = 6,
 	.usage_bits = {RESERVE, 0x00, 0x00, 0x00,
 		       0x00, SCSI_CONTROL_MASK},
-	.enabled = tcm_is_scsi2_reservations_enabled,
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_reserve10 = {
@@ -1841,7 +1866,7 @@ static struct target_opcode_descriptor tcm_opcode_reserve10 = {
 	.usage_bits = {RESERVE_10, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0x00, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
-	.enabled = tcm_is_scsi2_reservations_enabled,
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_request_sense = {
@@ -2246,12 +2271,22 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = cmd->t_task_cdb;
 
-	if (!dev->dev_attrib.emulate_pr &&
-	    ((cdb[0] == PERSISTENT_RESERVE_IN) ||
-	     (cdb[0] == PERSISTENT_RESERVE_OUT) ||
-	     (cdb[0] == RELEASE || cdb[0] == RELEASE_10) ||
-	     (cdb[0] == RESERVE || cdb[0] == RESERVE_10))) {
-		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	switch (cdb[0]) {
+	case RESERVE:
+	case RESERVE_10:
+	case RELEASE:
+	case RELEASE_10:
+		if (!dev->dev_attrib.emulate_pr)
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
+		if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		break;
+	case PERSISTENT_RESERVE_IN:
+	case PERSISTENT_RESERVE_OUT:
+		if (!dev->dev_attrib.emulate_pr)
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		break;
 	}
 
 	switch (cdb[0]) {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

