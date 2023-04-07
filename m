Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BD6AC77B79
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 06:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681195470;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RVZnxkDg9YlmI+AL7w1qU5+Uyp82qZoPiCP8aUW0Pe0=;
	b=GwNbSQf4xBhiV74qQL+JFE6WCYclmm6MJQ022NuoUaBE3lyYgCRLMAYyC5+IcthOlsdhSN
	w5qCKGJLXRgiU/QG6KyQC+poCr9Axn6huAwA4SXVQapfgVy8nQ28AcgpIGMkZW2XFOThU9
	s0hEvcaXDJXFHQXU1wGzyWkZczbELDg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-IKxGBhDkP3Gc83oDlzsNBw-1; Tue, 11 Apr 2023 02:44:26 -0400
X-MC-Unique: IKxGBhDkP3Gc83oDlzsNBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4904F38221D9;
	Tue, 11 Apr 2023 06:44:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 37D98440D7;
	Tue, 11 Apr 2023 06:44:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0B24D1949740;
	Tue, 11 Apr 2023 06:44:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 972A519465B5
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Apr 2023 20:08:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 78F2E40C6E1E; Fri,  7 Apr 2023 20:08:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 719FC40C6EC4
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:08:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5698E85C069
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:08:44 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-8ddQ1OGkM9WYmY5738mVhA-1; Fri, 07 Apr 2023 16:08:42 -0400
X-MC-Unique: 8ddQ1OGkM9WYmY5738mVhA-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 337Fx4YF014224; Fri, 7 Apr 2023 20:06:31 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppc7u5ss9-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 07 Apr 2023 20:06:31 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19)
 with ESMTP id 337ImALe034194; Fri, 7 Apr 2023 20:06:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3pptjxef5s-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 07 Apr 2023 20:06:30 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 337K5trI010228;
 Fri, 7 Apr 2023 20:06:29 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-128-1.vpn.oracle.com
 [10.154.128.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id
 3pptjxeeam-14; Fri, 07 Apr 2023 20:06:29 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri,  7 Apr 2023 15:05:46 -0500
Message-Id: <20230407200551.12660-14-michael.christie@oracle.com>
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
X-Proofpoint-ORIG-GUID: 5si_IelyY2lT6tl4GjteLpEP1MBqzeZd
X-Proofpoint-GUID: 5si_IelyY2lT6tl4GjteLpEP1MBqzeZd
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 11 Apr 2023 06:44:09 +0000
Subject: [dm-devel] [PATCH v6 13/18] nvme: Add pr_ops read_reservation
 support
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
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
 Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch adds support for the pr_ops read_reservation callout by
calling the NVMe Reservation Report helper. It then parses that info to
detect if there is a reservation and if there is then convert the
returned info to a pr_ops pr_held_reservation struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/pr.c | 83 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 732c56b417c2..391b1465ebfd 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -29,6 +29,26 @@ static enum nvme_pr_type nvme_pr_type_from_blk(enum pr_type type)
 	return 0;
 }
 
+static enum pr_type block_pr_type_from_nvme(enum nvme_pr_type type)
+{
+	switch (type) {
+	case NVME_PR_WRITE_EXCLUSIVE:
+		return PR_WRITE_EXCLUSIVE;
+	case NVME_PR_EXCLUSIVE_ACCESS:
+		return PR_EXCLUSIVE_ACCESS;
+	case NVME_PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return PR_WRITE_EXCLUSIVE_REG_ONLY;
+	case NVME_PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
+	case NVME_PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return PR_WRITE_EXCLUSIVE_ALL_REGS;
+	case NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
+	}
+
+	return 0;
+}
+
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
 		struct nvme_command *c, void *data, unsigned int data_len)
 {
@@ -222,6 +242,68 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 	return ret;
 }
 
+static int nvme_pr_read_reservation(struct block_device *bdev,
+		struct pr_held_reservation *resv)
+{
+	struct nvme_reservation_status_ext tmp_rse, *rse;
+	int ret, i, num_regs;
+	u32 rse_len;
+	bool eds;
+
+get_num_regs:
+	/*
+	 * Get the number of registrations so we know how big to allocate
+	 * the response buffer.
+	 */
+	ret = nvme_pr_resv_report(bdev, &tmp_rse, sizeof(tmp_rse), &eds);
+	if (ret)
+		return ret;
+
+	num_regs = get_unaligned_le16(&tmp_rse.regctl);
+	if (!num_regs) {
+		resv->generation = le32_to_cpu(tmp_rse.gen);
+		return 0;
+	}
+
+	rse_len = struct_size(rse, regctl_eds, num_regs);
+	rse = kzalloc(rse_len, GFP_KERNEL);
+	if (!rse)
+		return -ENOMEM;
+
+	ret = nvme_pr_resv_report(bdev, rse, rse_len, &eds);
+	if (ret)
+		goto free_rse;
+
+	if (num_regs != get_unaligned_le16(&rse->regctl)) {
+		kfree(rse);
+		goto get_num_regs;
+	}
+
+	resv->generation = le32_to_cpu(rse->gen);
+	resv->type = block_pr_type_from_nvme(rse->rtype);
+
+	for (i = 0; i < num_regs; i++) {
+		if (eds) {
+			if (rse->regctl_eds[i].rcsts) {
+				resv->key = le64_to_cpu(rse->regctl_eds[i].rkey);
+				break;
+			}
+		} else {
+			struct nvme_reservation_status *rs;
+
+			rs = (struct nvme_reservation_status *)rse;
+			if (rs->regctl_ds[i].rcsts) {
+				resv->key = le64_to_cpu(rs->regctl_ds[i].rkey);
+				break;
+			}
+		}
+	}
+
+free_rse:
+	kfree(rse);
+	return ret;
+}
+
 const struct pr_ops nvme_pr_ops = {
 	.pr_register	= nvme_pr_register,
 	.pr_reserve	= nvme_pr_reserve,
@@ -229,4 +311,5 @@ const struct pr_ops nvme_pr_ops = {
 	.pr_preempt	= nvme_pr_preempt,
 	.pr_clear	= nvme_pr_clear,
 	.pr_read_keys	= nvme_pr_read_keys,
+	.pr_read_reservation = nvme_pr_read_reservation,
 };
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

