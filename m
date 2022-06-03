Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9F7AC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  6 Jun 2022 06:46:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-nHwMZXg5Pj21Wf9qr-aM1A-1; Mon, 06 Jun 2022 02:46:23 -0400
X-MC-Unique: nHwMZXg5Pj21Wf9qr-aM1A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D5441C13961;
	Mon,  6 Jun 2022 06:46:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 876572166B2D;
	Mon,  6 Jun 2022 06:46:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AACDE1947B99;
	Mon,  6 Jun 2022 06:46:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E0A6F1947040
 for <dm-devel@listman.corp.redhat.com>; Fri,  3 Jun 2022 08:19:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D2F5F492CA2; Fri,  3 Jun 2022 08:19:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CD870492C3B
 for <dm-devel@redhat.com>; Fri,  3 Jun 2022 08:19:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0F14101A54E
 for <dm-devel@redhat.com>; Fri,  3 Jun 2022 08:19:36 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-LhkUw7XbOC-FNhK_aW5hYg-1; Fri, 03 Jun 2022 04:19:32 -0400
X-MC-Unique: LhkUw7XbOC-FNhK_aW5hYg-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2533AiJT010186;
 Fri, 3 Jun 2022 06:55:52 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc4xv7ss-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 03 Jun 2022 06:55:52 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 2536oNhb025389; Fri, 3 Jun 2022 06:55:51 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3gc8p5nyqv-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 03 Jun 2022 06:55:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2789.namprd10.prod.outlook.com (2603:10b6:a03:82::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.19; Fri, 3 Jun 2022 06:55:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 06:55:49 +0000
From: Mike Christie <michael.christie@oracle.com>
To: linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 hch@lst.de, axboe@kernel.dk, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org
Date: Fri,  3 Jun 2022 01:55:28 -0500
Message-Id: <20220603065536.5641-4-michael.christie@oracle.com>
In-Reply-To: <20220603065536.5641-1-michael.christie@oracle.com>
References: <20220603065536.5641-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM5PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:3:c0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8b685ff-424d-4383-3378-08da452e16e5
X-MS-TrafficTypeDiagnostic: BYAPR10MB2789:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2789AADA576EC5C1B8126B05F1A19@BYAPR10MB2789.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: DbtBCNp2kG0FzxJBAY8tdIuAGZTMbuj/SL0pieGO53Ius98GLsCSGkSOjGJxiNU/Gm1UojX4fZ5UVdwQQzz49pXZwEVcK7DuGe22f5hmAFsGM3iHc+2HjBzoMMsep/8nrs7WJb1dTDzn3VfAXiqtBv0sGqmEvlQqd6OB9Mun/IveyOeKJpSqeGM25ewIaiPU0aI8r93YQN64bJJEf4co32W2gGwrRt+gp772F8uATuRY7rJuUlk737UjJTcK2Ml7D+f+zRFaXbUbrOMe5hDix854D+GgkD2BFbgfKiQV1MqBNneOdYlt5DuJ/awIzR6niEtqr/5Ck/x2Naq5fuygUjsUzc5NA49ktBuXPMsyAFzVKUXbQEXPT90eEZnLYOlQwFDFwFva6CtQhk8XbiZ5CYGZJxLpz09fwxGlB1HXycyheR3XOyh7wp0EPh5bTDU6E0UV1/fTQ31JcMck2qUUb5t2nthkM0TBf7GcXvP3CKLu38PLkakN81cZN2bIcFHEk1/+T4NX6yvV0uOZrTSNEh6mhD7t/lg2pQMSwsKe6Qq6E3S+q//zPRRPR7+b+f6V6XUj0aAmuAEGfCRTJyBsQLoh0FnACx62Ee4S7Qd6IUyZHn+JTG3f+gp01ouNQ3ZasmrgyfzQRNk7kUtfP02o7RxRaKZBu+nwN/QdSfn+o2e9cbKz4hWIRLNdif//qRvNVUOeomiP8sNex1Nzu4v54Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66946007)(8676002)(38350700002)(38100700002)(66476007)(4326008)(66556008)(86362001)(83380400001)(36756003)(8936002)(107886003)(6486002)(2616005)(316002)(5660300002)(1076003)(6512007)(26005)(2906002)(6506007)(52116002)(186003)(6666004)(508600001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0Zvam5uYFAekBXXYpt9TmVkd3NPxITb0GagFo+4pgulHdKKnKgOYx5LTANIK?=
 =?us-ascii?Q?vEilZ7sr3U6b65s7K9c0oaquRLe8o0SZZ1RWU1595LGWnVcu00gaWj6lg+Xu?=
 =?us-ascii?Q?hM02Ce5xMNR3R30CKcF7h+8os502i9P2hk/9U1U1/cOv69H5UiOmocVn8YFJ?=
 =?us-ascii?Q?3nh1uH+g4Zp6lv3UTiF8zn3JsrETCfzkG8CmOuMCvdgL/5MQjYdcZMmyNy6f?=
 =?us-ascii?Q?hRa9ZUCB7+xHeEqp0s2PuHV/E6P4JbRTJ1Kve3GsZ2GEq+mLVroTf+sx2qYy?=
 =?us-ascii?Q?FYuKrUhLatxOiWHlqap1QwTcRQV1iHqTn838y0mGGHlMGfBXbcNjSK4yLEFO?=
 =?us-ascii?Q?1hQ0SObWRM3jH1rj/Ah0c2GnF+vTHoIa/UD5zuBNg50ZGUJHIwQVpjkKzEhu?=
 =?us-ascii?Q?KodwIe6ekUBC6qonTDcfUkKUrf4CZ6uUnX1cScIYhafJg4FtxSJLXiMfk0qs?=
 =?us-ascii?Q?mUR1OMG12Ald1OV8I2sz0hkOAhQXNfYBt/FRpxXE8CXMG/26EnCX3Dp9Rc+V?=
 =?us-ascii?Q?n8d+V8qNHRyb+0xbGr4QZOnxndVaqnpf/IBRlmd1Ztq+rgSSekHh8Z1J164D?=
 =?us-ascii?Q?kiY+HLs9lHf6OhxRrbkiNUEsLEidkcutN3bxZSviYqn/n1iCFQKa8oekzB+D?=
 =?us-ascii?Q?kYBDAOZrLNI+igmJ1RegVzJFneEwRSfuMXZBP3Xv/2UpYe2kwHSfaWjzE8WC?=
 =?us-ascii?Q?hVA2hlwxjpIMPY7uAdP+uyJO7gHsS2cNAN/YI84SrpWC1UfQf8cBpm9Dn7xS?=
 =?us-ascii?Q?35BM+6e8TvCGno2+M51jWWr/bQcozFDd9LYZHP6T90GkDjLARiqsnkyG9W7h?=
 =?us-ascii?Q?iFgC3kSeB1sWes2wAajhCpqGM9ZXqdbckfVZsWzi6r5vBYVegtEjmZAbDw1i?=
 =?us-ascii?Q?6+xrhbj29GFC2C4W3OTJ20z6lTWwrPeE9Pzgh62djFY96XsLgrGqVHJuRb8p?=
 =?us-ascii?Q?nxv+Ol3ydv8ICTFdim2zwruXK/qmYNNCrpM/nPnC3NFshAjHb2PI1GLySqQ6?=
 =?us-ascii?Q?Vr896Ny7Lz/zfdchMamA12bhaH4ixxRtyp0Nxj2T57SvfrH6ulhY1xiF/RcJ?=
 =?us-ascii?Q?llsW2UH8G9zmyPrmkiQyfttywixIuHnU/+CmgoyL2QZHKycsoj8Qj6z5jJKs?=
 =?us-ascii?Q?pEE5uhDZd/Bx5JHn59aG4LLDaboiwIBMfY42Sfqpgris8Br4/Lf2xE6b9tPU?=
 =?us-ascii?Q?KLFOe9zzkjTEF65L/tmYdJ1I4OXVkptzVTy/AJqHwiYDcjVCmxvDGpSJW2fZ?=
 =?us-ascii?Q?awhfsTrz8joj6tXJpfOqy+lLKH5nNnmyiqEUCOZUxBDlJfWIO2CIAfN706w7?=
 =?us-ascii?Q?V3p9ZzSD0k5Ke4VBqUxvo9K9UJ2gl5pEqGzbzzZxoVa4J/ORQBue44cG4k1i?=
 =?us-ascii?Q?LfqlspIAwTraZoxsDL6oFqNtUvPa524BYyZmkxH4YfEzjO1gnOP+hTTCKGQE?=
 =?us-ascii?Q?uEBVftbptBXcbK1LK4bSBFOwBnySdgcSTyNc5J7zHYg7zBQRZz+789OzxNoB?=
 =?us-ascii?Q?pCwbNZTsNKoVeG1C8H5NA0TYMysTb01G05ZoR6zkyBh3u7GVFEg5GfwFdfm7?=
 =?us-ascii?Q?jYmd11BO9AHKpJlZeEtfiFZ8k1f55icvzqLzlrF8rCADE3YkCee0457hAlBE?=
 =?us-ascii?Q?le4Feu1843mj6tazZD60IgRJ/ZeKla7BDI2Hk/XRqI7zZnEIfANbzx0W+PNr?=
 =?us-ascii?Q?lhpCCspEtmXDSFbB0Koi0v9zvFNsX2e1FnlwexhuIy8VAaMnaAWyJzBunLMh?=
 =?us-ascii?Q?gvU3LPrrOqUIp0MZIPdawBo0xkNrKfM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b685ff-424d-4383-3378-08da452e16e5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 06:55:48.2684 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mTUN4mmG6Om3PfqZcbc8wNvfmVfcBVhZpzkG1OiJLzfxehuyPisQUaahztkbTnKXsoWrk3EKIbKBOezgQQ0IQjGb6Ktv+N6cQ5GwMuHjhD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2789
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.874
 definitions=2022-06-03_02:2022-06-02,
 2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030029
X-Proofpoint-GUID: slBpevspyyqvYQ2UcdU8SrUfmIapUBgp
X-Proofpoint-ORIG-GUID: slBpevspyyqvYQ2UcdU8SrUfmIapUBgp
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Mon, 06 Jun 2022 06:46:17 +0000
Subject: [dm-devel] [PATCH 03/11] scsi: Move sd_pr_type to header to share.
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

LIO is going to want to do the same block to/from SCSI pr types as sd.c
so this moves the sd_pr_type helper to a new file and adds a helper to
go from the SCSI value to the block one.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c            | 29 +++++-----------------
 include/scsi/scsi_block_pr.h | 47 ++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 23 deletions(-)
 create mode 100644 include/scsi/scsi_block_pr.h

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 24e61647064c..765fca0f38c7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -67,6 +67,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_block_pr.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -1683,26 +1684,6 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
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
 static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
@@ -1749,19 +1730,21 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
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
diff --git a/include/scsi/scsi_block_pr.h b/include/scsi/scsi_block_pr.h
new file mode 100644
index 000000000000..7d137c067331
--- /dev/null
+++ b/include/scsi/scsi_block_pr.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_BLOCK_PR_H
+#define _SCSI_BLOCK_PR_H
+
+#include <uapi/linux/pr.h>
+
+static inline char block_pr_type_to_scsi(enum pr_type type)
+{
+	switch (type) {
+	case PR_WRITE_EXCLUSIVE:
+		return 0x01;
+	case PR_EXCLUSIVE_ACCESS:
+		return 0x03;
+	case PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return 0x05;
+	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return 0x06;
+	case PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return 0x07;
+	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return 0x08;
+	default:
+		return 0;
+	}
+};
+
+static inline enum pr_type scsi_pr_type_to_block(char type)
+{
+	switch (type) {
+	case 0x01:
+		return PR_WRITE_EXCLUSIVE;
+	case 0x03:
+		return PR_EXCLUSIVE_ACCESS;
+	case 0x05:
+		return PR_WRITE_EXCLUSIVE_REG_ONLY;
+	case 0x06:
+		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
+	case 0x07:
+		return PR_WRITE_EXCLUSIVE_ALL_REGS;
+	case 0x08:
+		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
+	default:
+		return 0;
+	}
+}
+
+#endif
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

