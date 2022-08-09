Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE6CC00140
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 00:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660003641;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UlV6tqr7kPviV5RI0k6KwhF7GAYhjJASD5jAufJvkeo=;
	b=hMfjrqq+ek3A47tg3rKEp4gHUdPBI6ytODf6IS7TV0/aF4WiB83tt6+cMDpLAE7I3WOKwJ
	ywpSoJDb/qc2c9KJAgpYG6msmQP8hdPIse80AQszO+O55kFVT+iCmnHjnQxTtj94yul76f
	J0RpjGdRm47vKuXV9+/e0+3rulMhy7s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-9Ta3BNrCP2mEyQTLR-zIjQ-1; Mon, 08 Aug 2022 20:05:21 -0400
X-MC-Unique: 9Ta3BNrCP2mEyQTLR-zIjQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25C993C0D188;
	Tue,  9 Aug 2022 00:05:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 11CE72166B29;
	Tue,  9 Aug 2022 00:05:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C173D1946A50;
	Tue,  9 Aug 2022 00:05:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F20C91946A4F
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 00:05:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E36051121315; Tue,  9 Aug 2022 00:05:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DEA301121314
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:05:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2355801585
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:05:17 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-PnDWohS1OWuon3H3Rbc6rw-1; Mon, 08 Aug 2022 20:05:15 -0400
X-MC-Unique: PnDWohS1OWuon3H3Rbc6rw-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NwVuV028542;
 Tue, 9 Aug 2022 00:04:48 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hseqcn0mj-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:48 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 278M0if4014103; Tue, 9 Aug 2022 00:04:47 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3hser8emhy-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4907.namprd10.prod.outlook.com (2603:10b6:610:db::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:45 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Date: Mon,  8 Aug 2022 19:04:15 -0500
Message-Id: <20220809000419.10674-17-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH2PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:610:59::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e1c2df3-de6e-4612-dacd-08da799ac4af
X-MS-TrafficTypeDiagnostic: CH0PR10MB4907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: r/1GW7KuDsLs7WeMwueB6JREcwwT73ev/U76Xy+0HO1xlzEuWuvXQw+Qje5TT5thxDrBgqQWvo1NU44jMoPSevWVdUaJCHmS2vZBVM74JNYs8i+Dt2Q6VKujD5CXODzvln2+IDUQeXu9iqam33dL8JBNoKh7v2Svpk/Xl12xF1Pme1cSZ+VVoX/2SgdmIBBP8hvZmrDq98VjZKRSFbzc/J9NUxbg627Nb/dER2HZ7/Xcf/8sZdLqNw/LBJuSAqBXkG8LsBGLUy72IsbU9Hj5+DiCmRrlhST23Y+aRuk6Z5bHwh3+R0YOS8bH6qPhZIUVYHCI60zrYlmRl2vSCFnCeL6zNWSDPHUBbeNZ+4x4tWJZ5A5tYl6YxK1wBtTxYePqaydHtLkYXL97KQvECObG0E5ASZn/4bWvMAeTnx3MizoylX85LGn2XeuhgGQR4BkescaTP6wM/n1P4Cg3qX7A7oCFDWJ6zvscs832eJXARligU3geNFV5UoVMZvRG2//pWnvdIXTXZc6JiIPETtPHDXuQhZMfJh19aj5/7ugm/e5A1O+VzZKSDxxP8p6LmfyMfjEv78IVv3OgX6x2mytaot7O5fqGOCFWMyk1LcV/veaa1VQ5gbIdkmFZLKwSIPgOV0Rg2NHS3Ev20Mm7FroghfglcmO4hLNfbaxJP8bMkQPi1Ca5M4P1XN2BqzTDDDwP6DmQN5ep7EY4yYcd7GxjOn0qwBpkRXpricTvPT44BYOGPu+zVVgoUdGLJapaPl588HxXi7JyHn2y/Sa990Ql0vx8X+K5cqSY+3j8KSY0JG8=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(366004)(136003)(346002)(376002)(39860400002)(921005)(6666004)(41300700001)(6512007)(26005)(2906002)(6506007)(83380400001)(2616005)(107886003)(38100700002)(86362001)(186003)(6486002)(1076003)(316002)(66476007)(66556008)(36756003)(8676002)(66946007)(4326008)(8936002)(478600001)(5660300002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?scM1GqmpTc4LsYdtitXVJnVVUSZ2B1dsgIA31wBla5C7e4HaEfIm6bBRcPv+?=
 =?us-ascii?Q?aIKKhOII8KrmBM+d1eapeVdoZ5bQ5ZqWQ30NY/zwuLvaJYQa8htPgJStFN1H?=
 =?us-ascii?Q?F06eMgfbDhuRWlRFCD6B1ycxF/AsL7HCwXD3H+kjQoK67nYTZUrXwQraanVS?=
 =?us-ascii?Q?vdY6JwG3+TAG8Nn6YCk1VRTBqibc5CMoKcFNGgUSRkjFnq4XyA/QgdlbYcTJ?=
 =?us-ascii?Q?0P92qUxIZKLOvsHe3qSNZ3bU11aZOIoOFPqFSpm2K71joObv1wEY2I9b6afv?=
 =?us-ascii?Q?H2eN1eMWngvaaLzqY/QbVfqycuXdrX67FaS5dUvh92BAfIAPS4UWOWyJ/2VA?=
 =?us-ascii?Q?ud7u4StB02SavKqjHVIj35MRPN36ZSzFNerPPHdESejwa84CnL7t/B00J76X?=
 =?us-ascii?Q?0NGvsNA7RgIED5SLkpU9oiYs9TBTsAoHQuxdBLks/oqWNkZ/7Bn7qglkzj2N?=
 =?us-ascii?Q?k8AFVvm2qgHaxDeHfKcjK7Upm7rJNhvSWDxMa/a19FlKxRkscs5UT/KetNSA?=
 =?us-ascii?Q?wdJWka4GSQzkVfedrz2uLQ16p8JpJ2Uv+b3Ozcuuj5ZPlXEKX3J7GwlDHj7J?=
 =?us-ascii?Q?X6eMSna/gSinJ6b1Tcqx1nnHEk8C4q7Vdhtbzz0y+Fy7LY2coyePMr5L0Dzr?=
 =?us-ascii?Q?yjsfZnOtue+lroNfwRzqVnw9tWSFslAa7cbfqyGaeOokKQHJkpBixGYY8eJr?=
 =?us-ascii?Q?ZUYMbv3l7ctLgY47Ut+jPLE0wRFE2Uoe97Uo3+UEkkv9ORWZ5j91s1tpqjOD?=
 =?us-ascii?Q?xJs12tAVt4dEckQhUnIVLS03JAx+tmOmIGTrFXHAA9jcbFQpyx6sfqYv0BGh?=
 =?us-ascii?Q?rjK8bR5PPcEcxo+4dAhYEXkR+pyLbAVhxJYQ3m7XvfCuZVglUfS0KtTBbvcB?=
 =?us-ascii?Q?DRCy96QAfHmCqIM7U7/ZOmmGMgbHZ1hF7ZF9d+iqyXcXzVcs2LOVvzZ1hcin?=
 =?us-ascii?Q?tRhFrHjuc6EXM8jXmBvTUt9klF7XV6aIsf5HgfS8dew8jEyDpQkxv9Sg3vt1?=
 =?us-ascii?Q?uDfE0m7B3CgYFVMQkc7diVB11ZVuumV4lrkaa3bImttMohKH4FF/JXXVIysc?=
 =?us-ascii?Q?tiU8cXjlZI4Gs4kZoNXO8j5C7PaLyhcFj0IP5xYz4oQARGmvz1oSB1TL8BJU?=
 =?us-ascii?Q?RcaF8a35WNCfmzCIKdCpEro7M6me7b4ms+eSFSY+ld9hiIpJDqlqEQvadYt0?=
 =?us-ascii?Q?QNE3pzObA8BV2Qrjx7QggvPZiCYmvCdoYSybViiRDrjd8yClDRQR61aZFc2k?=
 =?us-ascii?Q?hPLvevvgTuqTEouI99UH6FcvyTwL1B+5l7/bMaDMOiqvic+tNe7toKALQrOl?=
 =?us-ascii?Q?mvBwZ/3TFxZXclvJjzzkPk77mdCJruVj6a+mHixyzzbtppnma9TM5WiRSgR6?=
 =?us-ascii?Q?s5H5WTVdCEtU56u5kFK6ZBEVtSZLmfkVi28/D8eusmlDS1JmZzcDd26dpNO9?=
 =?us-ascii?Q?2m4Wa4m3wlFhRPjxaA3p9MRnCGIgDkpnuAFLoqr8ToEF5BoR+lga3k+KIbU2?=
 =?us-ascii?Q?ykcK8BkwuJQVNkOHIdANSDg7+g6cWr6d4exqVnfH7wd1GGZVLPQgnR4FysEM?=
 =?us-ascii?Q?aJkx6ZbIpbKtEnkWc6ChisOnU4dsxbLUDzASwJpjy92ybPoPdAKgTUR1S5km?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e1c2df3-de6e-4612-dacd-08da799ac4af
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:45.9380 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rkcRt3rUE67iHYvlYrJUs66CyfeG8H96Q6GBzQ62cIoLEY55hX/k+Jy9rjIdhOt4uM4Fu2vOKTcvQzN+R9UC3YQfc3GMGcjDkOo5OFVDAo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 bulkscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: OT81z6P8j08-tVbkdrnIe3ptuUH7nlob
X-Proofpoint-GUID: OT81z6P8j08-tVbkdrnIe3ptuUH7nlob
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v2 16/20] scsi: Have sd pr_ops return a
 blk_status_t
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
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch has the sd pr_ops convert from the low level SCSI errors to a
blk_status_t.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 61e88c7ffa44..31b4eafadc44 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1686,7 +1686,8 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 #define SCSI_PR_UA_RETRIES 5
 
 static int sd_pr_in_command(struct block_device *bdev, u8 sa,
-			    unsigned char *data, int data_len)
+			    unsigned char *data, int data_len,
+			    blk_status_t *blk_stat)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1710,6 +1711,9 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
 
+	if (blk_stat && result >= 0)
+		*blk_stat = scsi_result_to_blk_status(result);
+
 	return result;
 }
 
@@ -1724,7 +1728,7 @@ static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info,
 	if (!data)
 		return -ENOMEM;
 
-	result = sd_pr_in_command(bdev, READ_KEYS, data, data_len);
+	result = sd_pr_in_command(bdev, READ_KEYS, data, data_len, blk_stat);
 	if (result)
 		goto free_data;
 
@@ -1753,7 +1757,8 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 	u8 data[24] = { 0, };
 	int result, len;
 
-	result = sd_pr_in_command(bdev, READ_RESERVATION, data, sizeof(data));
+	result = sd_pr_in_command(bdev, READ_RESERVATION, data, sizeof(data),
+				  blk_stat);
 	if (result)
 		return result;
 
@@ -1777,7 +1782,7 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 }
 
 static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
-		u64 sa_key, u8 type, u8 flags)
+		u64 sa_key, u8 type, u8 flags, blk_status_t *blk_stat)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1808,6 +1813,9 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
 
+	if (blk_stat && result >= 0)
+		*blk_stat = scsi_result_to_blk_status(result);
+
 	return result;
 }
 
@@ -1818,7 +1826,8 @@ static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 		return -EOPNOTSUPP;
 	return sd_pr_out_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
 			old_key, new_key, 0,
-			(1 << 0) /* APTPL */);
+			(1 << 0) /* APTPL */,
+			blk_stat);
 }
 
 static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
@@ -1827,27 +1836,27 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 	if (flags)
 		return -EOPNOTSUPP;
 	return sd_pr_out_command(bdev, 0x01, key, 0,
-				 block_pr_type_to_scsi(type), 0);
+				 block_pr_type_to_scsi(type), 0, blk_stat);
 }
 
 static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type,
 		blk_status_t *blk_stat)
 {
 	return sd_pr_out_command(bdev, 0x02, key, 0,
-				 block_pr_type_to_scsi(type), 0);
+				 block_pr_type_to_scsi(type), 0, blk_stat);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 		enum pr_type type, bool abort, blk_status_t *blk_stat)
 {
 	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
-				 block_pr_type_to_scsi(type), 0);
+				 block_pr_type_to_scsi(type), 0, blk_stat);
 }
 
 static int sd_pr_clear(struct block_device *bdev, u64 key,
 		blk_status_t *blk_stat)
 {
-	return sd_pr_out_command(bdev, 0x03, key, 0, 0, 0);
+	return sd_pr_out_command(bdev, 0x03, key, 0, 0, 0, blk_stat);
 }
 
 static const struct pr_ops sd_pr_ops = {
-- 
2.18.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

