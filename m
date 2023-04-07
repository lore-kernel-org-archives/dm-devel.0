Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5264EC7619A
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 06:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681195455;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9fozgOyKoBiJZ+AEtSmnbJeAMOWncsySs8s5i9F/Lz8=;
	b=MPQq/62pZKybdLVaR1bZtFUB3oD62RnNAG1zHdUc8y5FX8mKVWHULdoGRgMe/FqdMJQsfo
	1GXYRat1TPKpcBJnO20pb5cfwipl55bzYPDEys/s4Ju1eJe79/s9Hrh9UfFnDjdEnp8POO
	uMPLelFVj5bpBVDhkt6JT/eQmr4JEfE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-OM1m71qhPHeYQnpliBwnNQ-1; Tue, 11 Apr 2023 02:44:13 -0400
X-MC-Unique: OM1m71qhPHeYQnpliBwnNQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90D7E857FB7;
	Tue, 11 Apr 2023 06:44:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 07275407D451;
	Tue, 11 Apr 2023 06:44:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5BA661946A43;
	Tue, 11 Apr 2023 06:44:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 274FD19465B5
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Apr 2023 20:08:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 19B1C2027063; Fri,  7 Apr 2023 20:08:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 11C212027062
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:08:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6DE3101A54F
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:08:29 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-gBK48rSWOd2XyazAppOirA-1; Fri, 07 Apr 2023 16:08:25 -0400
X-MC-Unique: gBK48rSWOd2XyazAppOirA-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 337Fx1rb019789; Fri, 7 Apr 2023 20:06:12 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbd45w5a-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 07 Apr 2023 20:06:12 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19)
 with ESMTP id 337Iw2C5034229; Fri, 7 Apr 2023 20:06:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3pptjxeeqn-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 07 Apr 2023 20:06:11 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 337K5tr4010228;
 Fri, 7 Apr 2023 20:06:11 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-128-1.vpn.oracle.com
 [10.154.128.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id
 3pptjxeeam-7; Fri, 07 Apr 2023 20:06:11 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri,  7 Apr 2023 15:05:39 -0500
Message-Id: <20230407200551.12660-7-michael.christie@oracle.com>
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
X-Proofpoint-ORIG-GUID: h_W7aXW_dOPh0O53ByAJhOel7zPosL3m
X-Proofpoint-GUID: h_W7aXW_dOPh0O53ByAJhOel7zPosL3m
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 11 Apr 2023 06:44:09 +0000
Subject: [dm-devel] [PATCH v6 06/18] dm: Add support for block PR read
 keys/reservation
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This adds support in dm for the block PR read keys and read reservation
callouts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/md/dm.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index dfde0088147a..b4103cb6eb9a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3119,6 +3119,8 @@ struct dm_pr {
 	bool	fail_early;
 	int	ret;
 	enum pr_type type;
+	struct pr_keys *read_keys;
+	struct pr_held_reservation *rsv;
 };
 
 static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
@@ -3351,12 +3353,79 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
 	return r;
 }
 
+static int __dm_pr_read_keys(struct dm_target *ti, struct dm_dev *dev,
+			     sector_t start, sector_t len, void *data)
+{
+	struct dm_pr *pr = data;
+	const struct pr_ops *ops = dev->bdev->bd_disk->fops->pr_ops;
+
+	if (!ops || !ops->pr_read_keys) {
+		pr->ret = -EOPNOTSUPP;
+		return -1;
+	}
+
+	pr->ret = ops->pr_read_keys(dev->bdev, pr->read_keys);
+	if (!pr->ret)
+		return -1;
+
+	return 0;
+}
+
+static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys)
+{
+	struct dm_pr pr = {
+		.read_keys = keys,
+	};
+	int ret;
+
+	ret = dm_call_pr(bdev, __dm_pr_read_keys, &pr);
+	if (ret)
+		return ret;
+
+	return pr.ret;
+}
+
+static int __dm_pr_read_reservation(struct dm_target *ti, struct dm_dev *dev,
+				    sector_t start, sector_t len, void *data)
+{
+	struct dm_pr *pr = data;
+	const struct pr_ops *ops = dev->bdev->bd_disk->fops->pr_ops;
+
+	if (!ops || !ops->pr_read_reservation) {
+		pr->ret = -EOPNOTSUPP;
+		return -1;
+	}
+
+	pr->ret = ops->pr_read_reservation(dev->bdev, pr->rsv);
+	if (!pr->ret)
+		return -1;
+
+	return 0;
+}
+
+static int dm_pr_read_reservation(struct block_device *bdev,
+				  struct pr_held_reservation *rsv)
+{
+	struct dm_pr pr = {
+		.rsv = rsv,
+	};
+	int ret;
+
+	ret = dm_call_pr(bdev, __dm_pr_read_reservation, &pr);
+	if (ret)
+		return ret;
+
+	return pr.ret;
+}
+
 static const struct pr_ops dm_pr_ops = {
 	.pr_register	= dm_pr_register,
 	.pr_reserve	= dm_pr_reserve,
 	.pr_release	= dm_pr_release,
 	.pr_preempt	= dm_pr_preempt,
 	.pr_clear	= dm_pr_clear,
+	.pr_read_keys	= dm_pr_read_keys,
+	.pr_read_reservation = dm_pr_read_reservation,
 };
 
 static const struct block_device_operations dm_blk_dops = {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

