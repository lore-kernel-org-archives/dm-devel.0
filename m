Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DC4AC77B76
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 06:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681195469;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oY6gMQEldJZtuWNDDG3/wyZ3lKlumtKkntd6AcdDLvU=;
	b=ixi/0Am1n5EAcUXY2Q2C4+c3vohyPS0mvdaQi6ihXZ5nYuLZgQ876f9A1H014e3FOIhPNO
	PcH8U7VfM48slVJDHWWNtQiBj+L9iaLxlJpGiGseuZ38OUg+LA8rh0XB6vgPD9GXGqMkb6
	ay2ic+uNliYw2XTUhTLWTIe5Vcndot0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-NoqAL1epNyKJOGFGmAG-jw-1; Tue, 11 Apr 2023 02:44:26 -0400
X-MC-Unique: NoqAL1epNyKJOGFGmAG-jw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD55D185A7B3;
	Tue, 11 Apr 2023 06:44:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B9E99492B10;
	Tue, 11 Apr 2023 06:44:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 513BE1946A52;
	Tue, 11 Apr 2023 06:44:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CAA1C19466DF
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Apr 2023 20:06:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BEC6540C83A9; Fri,  7 Apr 2023 20:06:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B700840C20FA
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:06:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CA91185A78B
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:06:21 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-EHxdd4c2PUGe9AD-5IrIMg-1; Fri, 07 Apr 2023 16:06:19 -0400
X-MC-Unique: EHxdd4c2PUGe9AD-5IrIMg-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 337Fx7uB014253; Fri, 7 Apr 2023 20:06:02 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppc7u5src-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 07 Apr 2023 20:06:01 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19)
 with ESMTP id 337IerIw034336; Fri, 7 Apr 2023 20:06:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3pptjxeeft-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 07 Apr 2023 20:06:01 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 337K5tqu010228;
 Fri, 7 Apr 2023 20:06:00 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-128-1.vpn.oracle.com
 [10.154.128.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id
 3pptjxeeam-3; Fri, 07 Apr 2023 20:06:00 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri,  7 Apr 2023 15:05:35 -0500
Message-Id: <20230407200551.12660-3-michael.christie@oracle.com>
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
X-Proofpoint-ORIG-GUID: HA27-HfZF8ZF0x66WCVjofiIbeCUD1q8
X-Proofpoint-GUID: HA27-HfZF8ZF0x66WCVjofiIbeCUD1q8
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Tue, 11 Apr 2023 06:44:09 +0000
Subject: [dm-devel] [PATCH v6 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
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
Cc: Stefan Haberland <sth@linux.ibm.com>,
 Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

BLK_STS_NEXUS is used for NVMe/SCSI reservation conflicts and DASD's
locking feature which works similar to NVMe/SCSI reservations where a
host can get a lock on a device and when the lock is taken it will get
failures.

This patch renames BLK_STS_NEXUS so it better reflects this type of
use.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Acked-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-core.c          | 2 +-
 drivers/nvme/host/core.c  | 2 +-
 drivers/s390/block/dasd.c | 7 ++++++-
 drivers/scsi/scsi_lib.c   | 2 +-
 include/linux/blk_types.h | 4 ++--
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 42926e6cb83c..c64db6fcb997 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -155,7 +155,7 @@ static const struct {
 	[BLK_STS_NOSPC]		= { -ENOSPC,	"critical space allocation" },
 	[BLK_STS_TRANSPORT]	= { -ENOLINK,	"recoverable transport" },
 	[BLK_STS_TARGET]	= { -EREMOTEIO,	"critical target" },
-	[BLK_STS_NEXUS]		= { -EBADE,	"critical nexus" },
+	[BLK_STS_RESV_CONFLICT]	= { -EBADE,	"reservation conflict" },
 	[BLK_STS_MEDIUM]	= { -ENODATA,	"critical medium" },
 	[BLK_STS_PROTECTION]	= { -EILSEQ,	"protection" },
 	[BLK_STS_RESOURCE]	= { -ENOMEM,	"kernel resource" },
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 53ef028596c6..1c9129028bb5 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -279,7 +279,7 @@ static blk_status_t nvme_error_status(u16 status)
 	case NVME_SC_INVALID_PI:
 		return BLK_STS_PROTECTION;
 	case NVME_SC_RESERVATION_CONFLICT:
-		return BLK_STS_NEXUS;
+		return BLK_STS_RESV_CONFLICT;
 	case NVME_SC_HOST_PATH_ERROR:
 		return BLK_STS_TRANSPORT;
 	case NVME_SC_ZONE_TOO_MANY_ACTIVE:
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index a9c2a8d76c45..ca0df87fa8f4 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2723,7 +2723,12 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
 	else if (status == 0) {
 		switch (cqr->intrc) {
 		case -EPERM:
-			error = BLK_STS_NEXUS;
+			/*
+			 * DASD doesn't implement SCSI/NVMe reservations, but it
+			 * implements a locking scheme similar to them. We
+			 * return this error when we no longer have the lock.
+			 */
+			error = BLK_STS_RESV_CONFLICT;
 			break;
 		case -ENOLINK:
 			error = BLK_STS_TRANSPORT;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b7c569a42aa4..e1468483ac7e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -599,7 +599,7 @@ static blk_status_t scsi_result_to_blk_status(int result)
 	case SCSIML_STAT_OK:
 		break;
 	case SCSIML_STAT_RESV_CONFLICT:
-		return BLK_STS_NEXUS;
+		return BLK_STS_RESV_CONFLICT;
 	case SCSIML_STAT_NOSPC:
 		return BLK_STS_NOSPC;
 	case SCSIML_STAT_MED_ERROR:
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 99be590f952f..2b2452086a2f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -96,7 +96,7 @@ typedef u16 blk_short_t;
 #define BLK_STS_NOSPC		((__force blk_status_t)3)
 #define BLK_STS_TRANSPORT	((__force blk_status_t)4)
 #define BLK_STS_TARGET		((__force blk_status_t)5)
-#define BLK_STS_NEXUS		((__force blk_status_t)6)
+#define BLK_STS_RESV_CONFLICT	((__force blk_status_t)6)
 #define BLK_STS_MEDIUM		((__force blk_status_t)7)
 #define BLK_STS_PROTECTION	((__force blk_status_t)8)
 #define BLK_STS_RESOURCE	((__force blk_status_t)9)
@@ -184,7 +184,7 @@ static inline bool blk_path_error(blk_status_t error)
 	case BLK_STS_NOTSUPP:
 	case BLK_STS_NOSPC:
 	case BLK_STS_TARGET:
-	case BLK_STS_NEXUS:
+	case BLK_STS_RESV_CONFLICT:
 	case BLK_STS_MEDIUM:
 	case BLK_STS_PROTECTION:
 		return false;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

