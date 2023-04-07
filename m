Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE5F3C77B7A
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 06:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681195470;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9dOR3Ts7qNH/K2SNIaks4m21QIeATCgv7npSt2xe4Ys=;
	b=ZA8oeTjbXuoEP8LcddH+ihFY8QKPkQuJ03BZ1ZaYMlq6btjnnXV9WxuiSvRdONVYfJfo82
	ILgcWnFekaUQcXwvHStT3lsnp0iLGQ3WkE3xyVBoRQzL7BrGen9iHji5TpPf+7vk2fkLEm
	YHeIpkRw5P06GBR/mdYbS9POoIH8wWI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-lHaWbSM9M7-o0i8Oq9LZUw-1; Tue, 11 Apr 2023 02:44:26 -0400
X-MC-Unique: lHaWbSM9M7-o0i8Oq9LZUw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01B6485C089;
	Tue, 11 Apr 2023 06:44:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DFB544021B9;
	Tue, 11 Apr 2023 06:44:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7AA1B19472E8;
	Tue, 11 Apr 2023 06:44:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7A43E19465B5
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Apr 2023 20:06:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5011BC1602B; Fri,  7 Apr 2023 20:06:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 47F42C1602A
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:06:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C04A3C0D180
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:06:24 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-z5Rk-pA8MM-wfbSnu2zhYQ-1; Fri, 07 Apr 2023 16:06:22 -0400
X-MC-Unique: z5Rk-pA8MM-wfbSnu2zhYQ-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 337FxLZv024780; Fri, 7 Apr 2023 20:06:08 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppcgawubt-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 07 Apr 2023 20:06:08 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19)
 with ESMTP id 337IvZRv034183; Fri, 7 Apr 2023 20:06:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3pptjxeekd-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 07 Apr 2023 20:06:06 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 337K5tr0010228;
 Fri, 7 Apr 2023 20:06:05 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-128-1.vpn.oracle.com
 [10.154.128.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id
 3pptjxeeam-5; Fri, 07 Apr 2023 20:06:05 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri,  7 Apr 2023 15:05:37 -0500
Message-Id: <20230407200551.12660-5-michael.christie@oracle.com>
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
X-Proofpoint-GUID: BUqCgAoPf8T5Ox2jhF9zYyUJ-H8z3gi4
X-Proofpoint-ORIG-GUID: BUqCgAoPf8T5Ox2jhF9zYyUJ-H8z3gi4
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Tue, 11 Apr 2023 06:44:09 +0000
Subject: [dm-devel] [PATCH v6 04/18] scsi: Move sd_pr_type to scsi_common
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

LIO is going to want to do the same block to/from SCSI pr types as sd.c
so this moves the sd_pr_type helper to scsi_common and renames it. The
next patch will then also add a helper to go from the SCSI value to the
block one for use with PERSISTENT_RESERVE_IN commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/scsi/scsi_common.c | 22 ++++++++++++++++++++++
 drivers/scsi/sd.c          | 33 ++++++++-------------------------
 include/scsi/scsi_common.h | 12 ++++++++++++
 3 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 6e50e81a8216..11bf6c275d4e 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -8,6 +8,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/module.h>
+#include <uapi/linux/pr.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi_common.h>
 
@@ -63,6 +64,27 @@ const char *scsi_device_type(unsigned type)
 }
 EXPORT_SYMBOL(scsi_device_type);
 
+enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
+{
+	switch (type) {
+	case PR_WRITE_EXCLUSIVE:
+		return SCSI_PR_WRITE_EXCLUSIVE;
+	case PR_EXCLUSIVE_ACCESS:
+		return SCSI_PR_EXCLUSIVE_ACCESS;
+	case PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY;
+	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY;
+	case PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS;
+	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(block_pr_type_to_scsi);
+
 /**
  * scsilun_to_int - convert a scsi_lun to an int
  * @scsilun:	struct scsi_lun to be converted.
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 00b9b6145fbc..256c582571fd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -67,6 +67,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_common.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -1692,26 +1693,6 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 	return ret;
 }
 
-static char sd_pr_type(enum pr_type type)
-{
-	switch (type) {
-	case PR_WRITE_EXCLUSIVE:
-		return 0x01;
-	case PR_EXCLUSIVE_ACCESS:
-		return 0x03;
-	case PR_WRITE_EXCLUSIVE_REG_ONLY:
-		return 0x05;
-	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
-		return 0x06;
-	case PR_WRITE_EXCLUSIVE_ALL_REGS:
-		return 0x07;
-	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
-		return 0x08;
-	default:
-		return 0;
-	}
-};
-
 static int sd_scsi_to_pr_err(struct scsi_sense_hdr *sshdr, int result)
 {
 	switch (host_byte(result)) {
@@ -1742,8 +1723,8 @@ static int sd_scsi_to_pr_err(struct scsi_sense_hdr *sshdr, int result)
 	}
 }
 
-static int sd_pr_out_command(struct block_device *bdev, u8 sa,
-		u64 key, u64 sa_key, u8 type, u8 flags)
+static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
+			     u64 sa_key, enum scsi_pr_type type, u8 flags)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1795,19 +1776,21 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 {
 	if (flags)
 		return -EOPNOTSUPP;
-	return sd_pr_out_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x01, key, 0,
+				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	return sd_pr_out_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x02, key, 0,
+				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 		enum pr_type type, bool abort)
 {
 	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
-			     sd_pr_type(type), 0);
+				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_clear(struct block_device *bdev, u64 key)
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 5b567b43e1b1..e25291bbbe9b 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -7,8 +7,20 @@
 #define _SCSI_COMMON_H_
 
 #include <linux/types.h>
+#include <uapi/linux/pr.h>
 #include <scsi/scsi_proto.h>
 
+enum scsi_pr_type {
+	SCSI_PR_WRITE_EXCLUSIVE			= 0x01,
+	SCSI_PR_EXCLUSIVE_ACCESS		= 0x03,
+	SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY	= 0x05,
+	SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY	= 0x06,
+	SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS	= 0x07,
+	SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS	= 0x08,
+};
+
+enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type);
+
 static inline unsigned
 scsi_varlen_cdb_length(const void *hdr)
 {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

