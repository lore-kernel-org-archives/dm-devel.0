Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63067FA3740
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198329;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ji+JIcTuz2bXzZKTpDSY8ExSf2T+iCKtotyBwEvSG2U=;
	b=SbXSewbV2VRkdNTu6gH6bf/RNuXSZvtHFMJ7OJfQLor4UBOW96F4S7JUXePovLB7WDw036
	41yP5gC/dDglp696i6H+jjL1R+uHYNWCe6cPhyJT8YOxY4doTfummzmKAY16t+66e9kO6b
	Wwd9EFxOwShV2LT3Md5ia5UaUjnCNeA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-_FKpnALVO22kHp1eVKreew-1; Mon, 31 Oct 2022 02:38:47 -0400
X-MC-Unique: _FKpnALVO22kHp1eVKreew-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 917B0806005;
	Mon, 31 Oct 2022 06:38:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A47440C206B;
	Mon, 31 Oct 2022 06:38:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 754C319465B9;
	Mon, 31 Oct 2022 06:38:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4A6191946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Oct 2022 23:22:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3FD6940C83BA; Wed, 26 Oct 2022 23:22:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3753040C83AD
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16F9F1C07542
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:29 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-Wm-eZCB0PvqlGTcXx_8hPQ-1; Wed, 26 Oct 2022 19:22:27 -0400
X-MC-Unique: Wm-eZCB0PvqlGTcXx_8hPQ-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLNlTe022179;
 Wed, 26 Oct 2022 23:20:15 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahe8n8w-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:20:15 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29QM16LD009431; Wed, 26 Oct 2022 23:20:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kfagedtke-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:20:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5690.namprd10.prod.outlook.com (2603:10b6:303:19b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.27; Wed, 26 Oct 2022 23:20:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:12 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Wed, 26 Oct 2022 18:19:42 -0500
Message-Id: <20221026231945.6609-17-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH2PR19CA0007.namprd19.prod.outlook.com
 (2603:10b6:610:4d::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5690:EE_
X-MS-Office365-Filtering-Correlation-Id: 12a356d4-2d98-4a55-6d75-08dab7a8a1a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: o3UOJGHee5tWJCsB9gmd0Zr8E3Q2yta3ikNYoYxsxSiZM2W644/3LObugToDIJFsnhku9eALTQqicLN96+xkJjpXzk8xag5u0mLusAj1WnQlDiyn+8yZdm18QK0pGixi7k7jG3oNNSb25DWlGkov8jQxuDga3zMVjIfEldfMtvzh/xvzEk0BgMLMgggRwB2kzGgvQTtmzLG6HKhFlvjE8HZU0IpX5pvPHSajUGiDoMJ74Tvy1Ycz45kD2eLXMxP6LI0esjApOuJ1ilV5sfaI+TxjIxECKV0vFKSVjN6oKAKLCJGLRaaRLksiC9M6hfmcFMtV2jrAK3dFqRydph1fvmwUUnGHFO9teJUeA3dDRh2QRYW2QFl4yQlu8HKeFUVSORaUUuABOAZshbWNNSFUCiI6J3hU0ZLhCAd/Nu/t8CIOw2CfKT09sY+DJBeh50LrYGMe2UhK8DG4ePx/8g7wciq/vNIVSyXD8pvbLV77tp3e7HUi0LoM7iJcr/+VTLbETOBKJFXyFPWPl98HQC72JFfUR5VVlcWyqfVskfkdjbdDSVU2T5x86IZ5Zao57e9eOsPq8GQS5Mr/yJbTJp3VuxBuMnJYUzhW3uua9s4WDMlKm1L1YRblzC4JGNVfVAsAzgPWDtvoQfz/Gu/oG8s9Z1SdXbSSI++7w82DPSgpZgxYWy1K8dDcrIk2WzN4JZJuFh9ArMCsuipxE1EOFKGlwajAOjUCLMlvkilV2dpSqKpwn/9Role39Ze8/0zL80jp
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199015)(316002)(186003)(8676002)(66946007)(2906002)(4326008)(66556008)(66476007)(86362001)(5660300002)(38100700002)(41300700001)(8936002)(83380400001)(478600001)(1076003)(6666004)(6486002)(107886003)(2616005)(921005)(26005)(6512007)(6506007)(7416002)(36756003);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UIKQpiI5J+kV9hsTccyYeeMyD1v8LeOhbEZArFiRnEMgjbp8mfOAJF0ZwmUu?=
 =?us-ascii?Q?WGOOVGRGrpIXQOByZ3J8Fw1TmedzYqdMY24dE/v9MegaLt/jIs5882W7ozQC?=
 =?us-ascii?Q?mFx3a9E3NPuvO7ZEZDGh+dfAeefmdzafL9b/984YYHt18UWfB1H3XbbYC75e?=
 =?us-ascii?Q?Jm6giLqcpBMGVP3R+ywp3eG+GG2YHIaUF06ga14iItUEEdeKtXq8JsBYAJze?=
 =?us-ascii?Q?fLY8SiD59vd00vnMQ/hlm9Sm5U083+wQbANZhgieYU1dFKSXX7hpcD4Dr1+V?=
 =?us-ascii?Q?zMo3+v3cBG6rCQhoHGerDeB6cbpIG1NCRFRITkWIzH8T+QHHaXdmvdFArkL8?=
 =?us-ascii?Q?88iT8tSy+7E3ApxmZPaY5pNuMQ17P50qgPYQ/WQnUBhb917tU5kS50J4Ar/A?=
 =?us-ascii?Q?unyMmKlrcd3TqCa1Ycocgn2rSKEPtgvmz6yxGw/kcSltXvV7bw6FdVn+OWG/?=
 =?us-ascii?Q?4dVs3y/6XOFwcCat41bVhG6Fl7uIgubV3F43fwwZS/q32PXyp/LZ6CGAPqCO?=
 =?us-ascii?Q?gWvJiqrxJ+Zc/Xml4abZX/OCpTI4I6W9rGJ27kmKSaxLmkLLcVG9l68WKUSM?=
 =?us-ascii?Q?9i+YH28GFSBUlfceWWNZk1DSA8phJdmZGj9ZIG1K6QBmazj4Bd9pDAbuTnKS?=
 =?us-ascii?Q?Dhc5YaVoGRDEsrqxUvhJ60IHbDo29hf/ba/eLriqjkKUltmOoC5HY/IryNk8?=
 =?us-ascii?Q?wy5YrogofNYZD0yKHNQJApO565dyLnrE9KUtpI4GO7l7r+5IhJ/3ulILssnJ?=
 =?us-ascii?Q?C+lBKyCMmYxbgq9ntZU3YRPVAyzID38ZIs4CkUCND0fxrxdkESR+SK9QKcmV?=
 =?us-ascii?Q?cCV6agXszv714mPhcUd9PvZM/U7cgj/gWJ7OmjKZeM1q+sb78qf0FPbrBwhL?=
 =?us-ascii?Q?3aiPIw0tG77Va4wlqK/cgNU3t4rD7MPhMxOk0ISOyhS3vfTmylD3U1cAMqXY?=
 =?us-ascii?Q?Oi3+qm/liw2Ha1Ftzu5lpYIzARgPLYDinfAKJ96ze/6RT0jZSmhAjt2us+cn?=
 =?us-ascii?Q?eHHSizL98bvbER4uJEEogyOx6IdKWX1biaFxEocy6xZOnnoiEuUMmIGuVD9E?=
 =?us-ascii?Q?D9MTLYMBBWmaDsHErR7IKp+Aw2NZaial9Rw6IvNLKveP+EgV13GYwkkmG2No?=
 =?us-ascii?Q?dg1qQEqNh11zxYUlsHtTrmKi0wAgNYIIfbpDXniDM/YUmsMTusQ+3uO6Okfw?=
 =?us-ascii?Q?fD4GvmGsE0OVyMpNsqVHB9glgkBjZHXha0L+66/dLD+qHQC+XgkNId/7L5gV?=
 =?us-ascii?Q?zsSAZOMO++ehSKTdx1bla7TSE6LYmlsMCs8iCAPAsRBwrAgY65mr/MfEEhqt?=
 =?us-ascii?Q?HEIj+lLmBigy9JpRnKIJXKiAELy1ksxs2pwAY8E9kLHSIDZgh/dsbQEEt4vV?=
 =?us-ascii?Q?x7YrGzK/PNSAAddC/gDCVbPRRstGNZUtvqHwl+CarcE8YoskhHoZZtCi0mtN?=
 =?us-ascii?Q?M3y2AJGF0p/ydA11K4bsaj0FL/VgP8igDiwvh4wxGmkyxkMf/vfmdsxwbpDa?=
 =?us-ascii?Q?/oW1sIXlcv8/JtdKWkgf70S5sNfgnDzCfViMTf7O8AHxlHULRxPH/ZTPqZYc?=
 =?us-ascii?Q?3L6kQLGdA3lVWZQSu2EzE+O06n+gIfsCrt0k9nwDkQC9AmzyCPburgrdW/ZS?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a356d4-2d98-4a55-6d75-08dab7a8a1a7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:12.2401 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nFp+hJD3SaaGBK8QkGRFJ1p0xVeddiwVgcQMM/IQYQd7mGZYBSfxi+EHSoe9yXwz03+fuL24MnTeFzFGpktE1bEgnCwuN9C1FpwvtKQyJJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5690
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: x8e4pX4vzwmtYQsNmOHMyDXN77n__G0T
X-Proofpoint-ORIG-GUID: x8e4pX4vzwmtYQsNmOHMyDXN77n__G0T
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: [dm-devel] [PATCH v3 16/19] scsi: target: Rename sbc_ops to
 exec_cmd_ops
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The next patches allow us to call the block layer's pr_ops from the
backends. This will require allowing the backends to hook into the cmd
processing for SPC commands, so this renames sbc_ops to a more generic
exec_cmd_ops.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c    |  4 ++--
 drivers/target/target_core_iblock.c  |  4 ++--
 drivers/target/target_core_rd.c      |  4 ++--
 drivers/target/target_core_sbc.c     | 13 +++++++------
 include/target/target_core_backend.h |  4 ++--
 5 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 28aa643be5d5..8336c0e0b1db 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -903,7 +903,7 @@ static void fd_free_prot(struct se_device *dev)
 	fd_dev->fd_prot_file = NULL;
 }
 
-static struct sbc_ops fd_sbc_ops = {
+static struct exec_cmd_ops fd_exec_cmd_ops = {
 	.execute_rw		= fd_execute_rw,
 	.execute_sync_cache	= fd_execute_sync_cache,
 	.execute_write_same	= fd_execute_write_same,
@@ -913,7 +913,7 @@ static struct sbc_ops fd_sbc_ops = {
 static sense_reason_t
 fd_parse_cdb(struct se_cmd *cmd)
 {
-	return sbc_parse_cdb(cmd, &fd_sbc_ops);
+	return sbc_parse_cdb(cmd, &fd_exec_cmd_ops);
 }
 
 static const struct target_backend_ops fileio_ops = {
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8351c974cee3..5db7318b4822 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -878,7 +878,7 @@ static unsigned int iblock_get_io_opt(struct se_device *dev)
 	return bdev_io_opt(bd);
 }
 
-static struct sbc_ops iblock_sbc_ops = {
+static struct exec_cmd_ops iblock_exec_cmd_ops = {
 	.execute_rw		= iblock_execute_rw,
 	.execute_sync_cache	= iblock_execute_sync_cache,
 	.execute_write_same	= iblock_execute_write_same,
@@ -888,7 +888,7 @@ static struct sbc_ops iblock_sbc_ops = {
 static sense_reason_t
 iblock_parse_cdb(struct se_cmd *cmd)
 {
-	return sbc_parse_cdb(cmd, &iblock_sbc_ops);
+	return sbc_parse_cdb(cmd, &iblock_exec_cmd_ops);
 }
 
 static bool iblock_get_write_cache(struct se_device *dev)
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 6648c1c90e19..6f67cc09c2b5 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -643,14 +643,14 @@ static void rd_free_prot(struct se_device *dev)
 	rd_release_prot_space(rd_dev);
 }
 
-static struct sbc_ops rd_sbc_ops = {
+static struct exec_cmd_ops rd_exec_cmd_ops = {
 	.execute_rw		= rd_execute_rw,
 };
 
 static sense_reason_t
 rd_parse_cdb(struct se_cmd *cmd)
 {
-	return sbc_parse_cdb(cmd, &rd_sbc_ops);
+	return sbc_parse_cdb(cmd, &rd_exec_cmd_ops);
 }
 
 static const struct target_backend_ops rd_mcp_ops = {
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 1e3216de1e04..74133efda529 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -192,7 +192,7 @@ EXPORT_SYMBOL(sbc_get_write_same_sectors);
 static sense_reason_t
 sbc_execute_write_same_unmap(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	sector_t nolb = sbc_get_write_same_sectors(cmd);
 	sense_reason_t ret;
 
@@ -279,7 +279,8 @@ static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
 }
 
 static sense_reason_t
-sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *ops)
+sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags,
+		     struct exec_cmd_ops *ops)
 {
 	struct se_device *dev = cmd->se_dev;
 	sector_t end_lba = dev->transport->get_blocks(dev) + 1;
@@ -348,7 +349,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *op
 static sense_reason_t
 sbc_execute_rw(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 
 	return ops->execute_rw(cmd, cmd->t_data_sg, cmd->t_data_nents,
 			       cmd->data_direction);
@@ -564,7 +565,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 static sense_reason_t
 sbc_compare_and_write(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
 	int rc;
@@ -762,7 +763,7 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 }
 
 sense_reason_t
-sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
+sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 {
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = cmd->t_task_cdb;
@@ -1074,7 +1075,7 @@ EXPORT_SYMBOL(sbc_get_device_type);
 static sense_reason_t
 sbc_execute_unmap(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf, *ptr = NULL;
 	sector_t lba;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index a3c193df25b3..c5df78959532 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -62,7 +62,7 @@ struct target_backend_ops {
 	struct configfs_attribute **tb_dev_action_attrs;
 };
 
-struct sbc_ops {
+struct exec_cmd_ops {
 	sense_reason_t (*execute_rw)(struct se_cmd *cmd, struct scatterlist *,
 				     u32, enum dma_data_direction);
 	sense_reason_t (*execute_sync_cache)(struct se_cmd *cmd);
@@ -86,7 +86,7 @@ sense_reason_t	spc_emulate_report_luns(struct se_cmd *cmd);
 sense_reason_t	spc_emulate_inquiry_std(struct se_cmd *, unsigned char *);
 sense_reason_t	spc_emulate_evpd_83(struct se_cmd *, unsigned char *);
 
-sense_reason_t	sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops);
+sense_reason_t	sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops);
 u32	sbc_get_device_rev(struct se_device *dev);
 u32	sbc_get_device_type(struct se_device *dev);
 sector_t	sbc_get_write_same_sectors(struct se_cmd *cmd);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

