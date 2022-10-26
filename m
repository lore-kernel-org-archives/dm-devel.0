Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95FD5FA3741
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198330;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nKCqkB5a/vhi5380PqMiBgNurJx0RSnsbpX80j4FW78=;
	b=bhCGy/X9D6eTQh+hPGsQm6we5lPs78pMq3YgCQuY8jc2+YIOnJOjpY1scB4W6rUaTfdk4J
	HBF8hoU/6NLyQtGflJOfEk/I6pdgf37H04g9J8zw0XSnE7JRcuP2Az+GNdVTJvEz0ev8Db
	JbKERaZ4EH8mT/+yK2hPOokDd19X4Tk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-HzZlFfJzPESJs4ES2X6UIQ-1; Mon, 31 Oct 2022 02:38:47 -0400
X-MC-Unique: HzZlFfJzPESJs4ES2X6UIQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F45C827982;
	Mon, 31 Oct 2022 06:38:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 646274B400F;
	Mon, 31 Oct 2022 06:38:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0A52A1946A68;
	Mon, 31 Oct 2022 06:38:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 04DEA1946597
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Oct 2022 00:11:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE19B2166B39; Thu, 27 Oct 2022 00:11:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B5F3C2166B2B
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 00:11:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91C1D101A52A
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 00:11:15 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-GrO4TtB_NvC77kNY9qjb2w-1; Wed, 26 Oct 2022 20:11:13 -0400
X-MC-Unique: GrO4TtB_NvC77kNY9qjb2w-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLHdMc020594;
 Wed, 26 Oct 2022 23:19:56 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahe8n82-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:19:56 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29QM7DO9006899; Wed, 26 Oct 2022 23:19:55 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kfaggdrg5-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:19:55 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:19:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:19:53 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Wed, 26 Oct 2022 18:19:29 -0500
Message-Id: <20221026231945.6609-4-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:610:74::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a34542f-eb2d-43da-b66f-08dab7a8966e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: NlvzxDQbCrV1kgU9ubM1vPQLtVJx/VgHEz0i2LHcZ25vlq2bKzyh7celx0g3ozlZLaVntCJ4rUWTeRR2omi57fCWrXeWhxm1ODjX6yeWvx3LybfIC33qpi1C0Qm88f7gH1CgwNwAt7rKH/zmvsEk3uZfm3Gg3w+rVHWnUJfh0T++4FkWPSC8tVxM2xZTjdleRsUk+5W4n6VAQJ4EWA9pOfdgSN3b8huvfZDv03VrTqBlkLnvAIcv/NWIluM1xHeDGJLRoe8hSZ69LHrXOOuHdinp5DLWVzxsIskTDvKtyEcCFRkiHydhWVFY0ftDIQcuhL4UW24zB37YHzTWZRYWejtXec8qU8+jVprlLPwHX8TY2vXiT3N//YikJ9O8zp9Ne9l3E5LzCPEEC9BpWqG7bImNYSjflND6m/4lki3y80r/LSM4lbBbuI6JWNCBa0ql0wB3VBLX0ObRJYZbx58OPOlpwccLHguldiZE4tCJAnpP9hrtQcCLPFDzo9ut162gulE71WJQ5AAblvLrNeQpl8CxY5NhfiNMxZ8Uy56t8YLB7UaAS9zH7zlCpkTSf/qK/ETVqwm6I9Ba+W5VNafd8LKFXHcQgjDFA8dqcObBxTaY+h/5lfzt8c+WPCveTAqCuYkpBAvGIQ7AKpwhgTbISFQXY0VJronWGI98vZXbxEjEVgxC9M4hhYxZnu2tD0oV38pWYP7GPQ72EBfoPwt43Nriu1cf408nHjEgr0H/Nc/f3mhhV6Rlfx9q/YdKF6tV
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sVeIA3cRIyXHXWYJY7jvrKih2coMb6qKTic3L9+ZAqHi5Bwu/I3nn2RQiyzK?=
 =?us-ascii?Q?7juPq2vvhg2r+Uy4sfjl4x9Z1cktqyBEwhhRiflGI3s7OEbAQ2C4b0AQx5II?=
 =?us-ascii?Q?EJCBCNLDxmJziGe7xgKG2BfH8sah73UYI/lIe8wihuCL0rhuOo+iZjUtYktm?=
 =?us-ascii?Q?RqgNVGK059Bppb5HXlPEgAqSMefnNwkHeRw1ePafuHBzWW0BzqYtWWRFKEwi?=
 =?us-ascii?Q?PPXW0K8/g71Qt92O/HPRgeyE8iw9du2bQne1LiALY39ouFe6PnJqupn5XsbZ?=
 =?us-ascii?Q?X2WljXr8leEtolcwlEECj1wSZPODNpFxH2ugLlzu1cX9W+ddB5JSh2TzPKUM?=
 =?us-ascii?Q?0EdTvotXGzaquCfF5o/xyMmYRU9ql07Y/SpCF0XAoxBuaf6RJsK3nPfwKPeF?=
 =?us-ascii?Q?j2ofW94kWnhGwG8aaSYmHW3xMICPZFVJMujvjXqEyixTmmRRblqeBxvwEXV+?=
 =?us-ascii?Q?RNyVT25wmA+cy8ZGCvWgX4MpS9j2XsMHVIV7MwCfS9A46GQ5bl8pybjmznfJ?=
 =?us-ascii?Q?BJH/pSmBO24dx61IIeRBpmiV2O6Z4OVYEaYUigBAoabgRYwR5ttgeAalPBTM?=
 =?us-ascii?Q?9yKdCG3ZBO7Vpc6m0PKtA6ZkMwU3NyM9jW5g2TSKxnhX/nuy1DJt/3h+3q9Q?=
 =?us-ascii?Q?DP6Uu75bvdf3vyR/tsDLSScSxmGW83/fhyg7Q/YVQtnjrPeeXFTJFNaOUNq0?=
 =?us-ascii?Q?zFux0hrwx9fl/kvjnEN/YMP4hEo7xhC86e8K9LqcekZo+DjODg2+jwiWD948?=
 =?us-ascii?Q?q7k5P400CTzHPQZORqs5+W/jZ3qkiPwchL9OBE+z1Ywwp9VaBY3GNwIAr7ZX?=
 =?us-ascii?Q?pvm3F34InWmjwXfz3acS3qUI7BfNC36wvf8IIrRS2V3saLtbD3hSy+wkB23S?=
 =?us-ascii?Q?YPaBTHeKhMjk/R9CNpE3HFstvkmLOGJA208T9yiy3Ptj+5pOfKlWb81VKMqv?=
 =?us-ascii?Q?bLT/dxe7+LmwTrH0TamdDMlrH+X/PgauJDvuF2X+QFmsQRMS7PD1Xr36NC/u?=
 =?us-ascii?Q?LjjqMbxts8dIjVldGTqiIJ8RGVojWRAWTu5jE2HkkWuuJCVZuWhihwVujOOP?=
 =?us-ascii?Q?v0B0Mi/Jchx5RBcw08eNX8pXtYo9DCNoi7XRBNBTgEN8boPoXNNdgyjyG8Mg?=
 =?us-ascii?Q?SNeSdzASXpytzUNaKXBJ6iELSvbUHlphhVKoR9tkpuB8DT9XnwOnJf84BGmV?=
 =?us-ascii?Q?Y0KKVbpZyQLHyvoVhwk/we5dACBxX4qbNGoO1QtzhbBM6jxh0toKlmLfk3Cf?=
 =?us-ascii?Q?StyGtO1CHlG3zatPGSSePa/viybhqls+XjJeY8m8WkN2hO/CogJuesZ9F/P0?=
 =?us-ascii?Q?qBTt6FiBtfETH2w0daB6IcKSe1zl+IxraiRREhc9jt0bjU/W982JlCDd062b?=
 =?us-ascii?Q?LvzXX2iv8OuuoiHFvgyzvhhX/YGPI48zhlzvMZmSV0TfuoPJvbQODnCCVA5E?=
 =?us-ascii?Q?ZnGmX5J5Qo1CO1Ix4YsNaQkr2UOIDEayVv4bIYTAxBI4XaezngR9N/M3sOLi?=
 =?us-ascii?Q?/U7Wgyr7eOFoZy/JUaz3uWk1Cy/+w5FSDV89y1NhpOGFpzBj8XMbw9AalhTD?=
 =?us-ascii?Q?VkGwftBFvk/pBnnO7xuvsExjxGP1cAEqHu98A/DvCZLkxwVDxz0wg+9AyDEt?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a34542f-eb2d-43da-b66f-08dab7a8966e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:19:53.4135 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8v0CsnOo5QTwaq+rfEP/WZA+VcddxgvyXj8I8CGIpaBuPK+SAZyuT+J6VjIT6pbChmeDyuAdgHRdC7vkvDwd0kATnF8f52iNWJ1R7K1QT3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: 8PDjxxknKpQ2_EofDiFo9mrLYCCC_FDr
X-Proofpoint-ORIG-GUID: 8PDjxxknKpQ2_EofDiFo9mrLYCCC_FDr
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: [dm-devel] [PATCH v3 03/19] scsi: Move sd_pr_type to header to share
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

LIO is going to want to do the same block to/from SCSI pr types as sd.c
so this moves the sd_pr_type helper to a new file. The next patch will
then also add a helper to go from the SCSI value to the block one for use
with PERSISTENT_RESERVE_IN commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c            | 31 +++++++------------------------
 include/scsi/scsi_block_pr.h | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 24 deletions(-)
 create mode 100644 include/scsi/scsi_block_pr.h

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4dc5c932fbd3..ad9374b07585 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -67,6 +67,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_block_pr.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -1694,28 +1695,8 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
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
-		u64 key, u64 sa_key, u8 type, u8 flags)
+		u64 key, u64 sa_key, enum scsi_pr_type type, u8 flags)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1778,19 +1759,21 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
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
index 000000000000..6e99f844330d
--- /dev/null
+++ b/include/scsi/scsi_block_pr.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_BLOCK_PR_H
+#define _SCSI_BLOCK_PR_H
+
+#include <uapi/linux/pr.h>
+
+enum scsi_pr_type {
+	SCSI_PR_WRITE_EXCLUSIVE			= 0x01,
+	SCSI_PR_EXCLUSIVE_ACCESS		= 0x03,
+	SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY	= 0x05,
+	SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY	= 0x06,
+	SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS	= 0x07,
+	SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS	= 0x08,
+};
+
+static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
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
+	default:
+		return 0;
+	}
+};
+
+#endif
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

