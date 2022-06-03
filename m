Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5130CC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  3 Jun 2022 07:18:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-_Am64D9GNiewtTecsZQsrg-1; Fri, 03 Jun 2022 03:18:02 -0400
X-MC-Unique: _Am64D9GNiewtTecsZQsrg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFE92811E81;
	Fri,  3 Jun 2022 07:18:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9AC3F2026D07;
	Fri,  3 Jun 2022 07:18:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 69A75194704A;
	Fri,  3 Jun 2022 07:17:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A4F3A194704A
 for <dm-devel@listman.corp.redhat.com>; Fri,  3 Jun 2022 06:58:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 93B4F2026D07; Fri,  3 Jun 2022 06:58:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EF132026D64
 for <dm-devel@redhat.com>; Fri,  3 Jun 2022 06:58:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F3AA1C05AE1
 for <dm-devel@redhat.com>; Fri,  3 Jun 2022 06:58:12 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-iBEz3jDLOVWXiF89NiPQkg-1; Fri, 03 Jun 2022 02:58:10 -0400
X-MC-Unique: iBEz3jDLOVWXiF89NiPQkg-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2534esIM016519;
 Fri, 3 Jun 2022 06:56:03 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gf8rwrbf7-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 03 Jun 2022 06:56:03 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 2536oJc5001837; Fri, 3 Jun 2022 06:56:02 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3gc8hyxp4e-3
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 03 Jun 2022 06:56:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2789.namprd10.prod.outlook.com (2603:10b6:a03:82::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.19; Fri, 3 Jun 2022 06:56:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 06:56:00 +0000
From: Mike Christie <michael.christie@oracle.com>
To: linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 hch@lst.de, axboe@kernel.dk, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org
Date: Fri,  3 Jun 2022 01:55:36 -0500
Message-Id: <20220603065536.5641-12-michael.christie@oracle.com>
In-Reply-To: <20220603065536.5641-1-michael.christie@oracle.com>
References: <20220603065536.5641-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM5PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:3:c0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f742ceaf-61b8-4ad6-bfbc-08da452e1b58
X-MS-TrafficTypeDiagnostic: BYAPR10MB2789:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2789CAF8E8FE891466450D73F1A19@BYAPR10MB2789.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: SFNkQ189PXFW+x692fgbhBCfAZNnFG6StmyH/2RUW8lAucY4mX4qmARj2V3f9GF/r4yv99qBIZsA0ieWnHTWTJa4HVEF7Bl8kPNyahK2Vz8MOA3Sb34jG9yO9UP6cN7V/RkXwfTR/wik9HNEft1ersaRoKOYAS1M4CDM/Uh+55OvDcTq4LNxEEWs7gvEeGRsMErnVLxDkXkhXII6lt0fst1F51A6kggQkp7oVFvqdHHP0RFpARjTFSCzpBE+eL7tmJGVmmv/AKbcjocaha325Ci3vg3/90Ki0Yviv2FjkTdZ67T2wx4arK5TZjgihRkq2M8XTnPNBM3U86HMnA2hzEAnsMoCXX2u88pk4gAvER0pncKMM0ACSN/vNW2kZ/NatYhxFLx4KKsMhMxx5M2EgozTdL9qe6YUmT8ZQrRnJjmmbVqLPRUpsMQPbLi1fclyoKeFnaSEkN2qczILJThDxcocvvO2mD8zEkPx50a9Wj038Xcg8u7oHUQGJYBqz9zj/FfJejZHievA0Lok4WdA28xWdO+s7DOdw8HZw6rg1Qs6RzNbXX10d03MOy8QMLwai1Pn0ODpYqDr/0Y7yZFibMqBiUnSmxceQ5wuX2A+ktr6Kxg9nfjPx9HErEmNEdBmFKG4j9TPEfbSuLZJdhsRPktolDQIt3WUYOLCnYkOnVjBnPYRqe68daSvacf5qB1XPYX3Zx7X5kwsEXstfQwwxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66946007)(8676002)(38350700002)(38100700002)(66476007)(4326008)(66556008)(86362001)(83380400001)(36756003)(8936002)(107886003)(6486002)(2616005)(316002)(5660300002)(1076003)(6512007)(26005)(2906002)(6506007)(52116002)(186003)(6666004)(508600001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EAjqUtGX5fjLP4Krt3fKksOWUgXtnlQH64/n+UrXyNuAfyDvkplnGQyyLb0R?=
 =?us-ascii?Q?AScf0+hvWNRad65URT2n3j4ZA0IK7h4QjonjpE7/TlVqc70jpkj7Rqclx9Kr?=
 =?us-ascii?Q?c3d8lSwKHi/WqH5ojw/73bwhDmzCTAUFJZymQS2sVjAFSRER+FdrXqJld2LM?=
 =?us-ascii?Q?FRzsZ8w/keZHek8waQp6mXXcw2k8vUtBRyQR3M9UJpyJWGpuah325C+Efw2q?=
 =?us-ascii?Q?MUT2Ji+9U3vOBrQ7HBEEUxiekxRrqeGLUz9+jhKBci74EPFnJI0ICU6KjU3t?=
 =?us-ascii?Q?sU7O/Yhn0uk7HL1AHA3jatUONRmmPEmlbhIQWQ0RBR9G3kntxgfR0Hly0SFP?=
 =?us-ascii?Q?oj0wJUEqSPeUYeH8FF4nfazuyN+pMuay20iZfsE37E4SZyfVjummB9FqFQJw?=
 =?us-ascii?Q?d5ujgtpC2mZ/DGrj9h+YRIJyKSrwXMQn4PZ9ChsqXCizSMHcJ0F33vX3122V?=
 =?us-ascii?Q?QxAGWXILvg7MFXZvqME75XLxaVuT6JcnGEFboBBA1DRotU2DEkQ/tjqU95Gf?=
 =?us-ascii?Q?Dk4RDhWY3i95odbCKvWNxZsdE4prjOoQVWikqAD0dJW4Yygz3zEbRe8pGA1v?=
 =?us-ascii?Q?hNd4aJy0silJDZw2A8ftOo0um8Tc76KCjZB0IclKX4uqsvY+OiyN7N33Bgh7?=
 =?us-ascii?Q?cQQNtf7KfIDUIre02qT7iw13EZtT+PcAf2upZplsGv2l1cS6ZweXQU8WVlux?=
 =?us-ascii?Q?R9gJFKrB8B7PZvbw1fNS7+7s049ZXo7s/Qic86kXb5ImWfQR4EXQCHk+ClPg?=
 =?us-ascii?Q?yqjMiVLJPI4L4EqAssg2gkk+Zy6AE3VBEwxvTHOMg31MWYBclGE2junSaFnI?=
 =?us-ascii?Q?dhnnKfcz/4u3TSgse8or/RhIZkaDz1k4lh8dmUebw4decgIkkWACo2JTJUNR?=
 =?us-ascii?Q?v5GApU2DB+ivy6YTnUnyDsRjT/RsZduyt1IWCJW0nY9c5WE0v2tm1SOp78V7?=
 =?us-ascii?Q?61cSWNEjqcp22wAKeYhsVy7kD1YozJMm2lo13N6IMbhyp0oxqjC/680M3V9o?=
 =?us-ascii?Q?+JvGTUi4RPB67c16tXz7OjYAAmV5tdp7Mg/lofw3Wiw3thu04Yb7dfRsEbUl?=
 =?us-ascii?Q?secJ8pVx7yHPc4IWfsgeBMH8voZNiJwE/EE28pIo/ZFBN0GCH09FYNLT2XmO?=
 =?us-ascii?Q?i6uvQnqJPXu2l3DGaBpkRiboTGZ5mItaCdsoiC4G6CdAGN5J5/esINGQrRU4?=
 =?us-ascii?Q?y3ENrocgB0yynxnmntD/7qjlsbIDx+zmjYCrzTr6hyykvGsa8t09f9nsLZVO?=
 =?us-ascii?Q?V2x5zsFPLy4/7KuGKhny17Xy7vEugbn7rR9s7hlJ/s4ZGMHUyP9UYJ78Hb3W?=
 =?us-ascii?Q?v43pDKLJZxf6anmdw1HHEqkmnVsQRzmfy+Ru8tqrS/es+RQsifC66p1x8FLf?=
 =?us-ascii?Q?OPbHRjOTyERv2+1K6BMTu5fajIBygNYKuog8rt6qdbJHWuPN9WDhJjTuXcm6?=
 =?us-ascii?Q?vYI6f1RMSAWhd6xeEtGh9T1hgz7CedgDFxqaPqLWN8oByBpYSNAccdB8HSn/?=
 =?us-ascii?Q?lgsp+mcKgNFDlWzH+J+mhQFtiCraTzOXe1MZyWPtWM5AjgQ5T1UxvqnjxS1g?=
 =?us-ascii?Q?eQ9gVZ/4bBrOQYZOTQCYczTXWyB5ZteaZ33KtZN8dxJhcrq77pjIGLIGM0Km?=
 =?us-ascii?Q?6YuQGjTzH6c0ZdP7tCuNFe4CVNblqisgyycpBuf/pWcOngWIJ2qbbi/pAfHw?=
 =?us-ascii?Q?NuSk2Yg7Ja53JI3C+oOgNMF0wl++oK0KJCT+zGVVzXlyhTurkqt45iHP0Ip/?=
 =?us-ascii?Q?CuzOoEI3Ghyj+scFgblRPNOLd8ahmC8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f742ceaf-61b8-4ad6-bfbc-08da452e1b58
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 06:55:55.8459 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mY2xzVm2VN945w7chvns6fBsMBqZrdb4GRoA6Pvbk3Gv/8Y54UHj0oHT7KVMFBG/GaIzeSstTOFeZKWd56y4wdu6mc6no3FuGKDTHDXjRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2789
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.874
 definitions=2022-06-03_02:2022-06-02,
 2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206030029
X-Proofpoint-GUID: WuDPelidR2xkIuX7mJU-_LS-mhObuxqO
X-Proofpoint-ORIG-GUID: WuDPelidR2xkIuX7mJU-_LS-mhObuxqO
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Fri, 03 Jun 2022 07:17:56 +0000
Subject: [dm-devel] [PATCH 11/11] scsi: target: Handle BLK_STS_RSV_CONFLICT.
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If we get a BLK_STS_RSV_CONFLICT report it to the initiator instead of
using the SAM_STAT_CHECK_CONDITION which gets translated to a generic
error that initiators don't know how to handle.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_iblock.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index e8cf201e59ca..2a964b57303a 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -309,7 +309,7 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 	return blocks_long;
 }
 
-static void iblock_complete_cmd(struct se_cmd *cmd)
+static void iblock_complete_cmd(struct se_cmd *cmd, blk_status_t blk_status)
 {
 	struct iblock_req *ibr = cmd->priv;
 	u8 status;
@@ -317,7 +317,9 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
 	if (!refcount_dec_and_test(&ibr->pending))
 		return;
 
-	if (atomic_read(&ibr->ib_bio_err_cnt))
+	if (blk_status == BLK_STS_RSV_CONFLICT)
+		status = SAM_STAT_RESERVATION_CONFLICT;
+	else if (atomic_read(&ibr->ib_bio_err_cnt))
 		status = SAM_STAT_CHECK_CONDITION;
 	else
 		status = SAM_STAT_GOOD;
@@ -330,6 +332,7 @@ static void iblock_bio_done(struct bio *bio)
 {
 	struct se_cmd *cmd = bio->bi_private;
 	struct iblock_req *ibr = cmd->priv;
+	blk_status_t blk_status = bio->bi_status;
 
 	if (bio->bi_status) {
 		pr_err("bio error: %p,  err: %d\n", bio, bio->bi_status);
@@ -342,7 +345,7 @@ static void iblock_bio_done(struct bio *bio)
 
 	bio_put(bio);
 
-	iblock_complete_cmd(cmd);
+	iblock_complete_cmd(cmd, blk_status);
 }
 
 static struct bio *iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num,
@@ -755,7 +758,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	if (!sgl_nents) {
 		refcount_set(&ibr->pending, 1);
-		iblock_complete_cmd(cmd);
+		iblock_complete_cmd(cmd, BLK_STS_OK);
 		return 0;
 	}
 
@@ -813,7 +816,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	}
 
 	iblock_submit_bios(&list);
-	iblock_complete_cmd(cmd);
+	iblock_complete_cmd(cmd, BLK_STS_OK);
 	return 0;
 
 fail_put_bios:
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

