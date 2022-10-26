Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68163FA3747
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198335;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xpV/7stl934nS7vFw8j0zJ/VySbq0zfD2++yNxWa4ls=;
	b=ENUm+vE8h+wniN2DUz5oyflTWTbywRGfDut9b46coQ/MD3kpKB6Di1vez2R5UnudUpZN0N
	cMKeHErG62DwoPTyV/wI6hD4nVzCAFhsUYUjVJIbRtFfikg2qvOI76NFrnqk6guwzc57l7
	/zQcINkQfKpz0UMwMYabtYUlh8m63Ts=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-38dSdh5JN-CdMK6z5N_YFQ-1; Mon, 31 Oct 2022 02:38:51 -0400
X-MC-Unique: 38dSdh5JN-CdMK6z5N_YFQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1CEA80A0AE;
	Mon, 31 Oct 2022 06:38:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9FBD3140EBF5;
	Mon, 31 Oct 2022 06:38:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14E9B1946A45;
	Mon, 31 Oct 2022 06:38:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 545591946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Oct 2022 23:22:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3B451492B18; Wed, 26 Oct 2022 23:22:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 32787492B16
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7E9785A59D
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:34 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-maCm2IC4P_OXO0Pl5qVMQg-1; Wed, 26 Oct 2022 19:22:31 -0400
X-MC-Unique: maCm2IC4P_OXO0Pl5qVMQg-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLHdMe020594;
 Wed, 26 Oct 2022 23:20:00 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahe8n85-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:20:00 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29QM2B77011647; Wed, 26 Oct 2022 23:19:59 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3kfagqduvx-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:19:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:19:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:19:57 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Wed, 26 Oct 2022 18:19:32 -0500
Message-Id: <20221026231945.6609-7-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH2PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:610:4c::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 78e65c10-a66d-4dcd-c67e-08dab7a898f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ybSNEqjAgQkQ/Dgo1ZXRjuqji265Soha5j8jma0OUj0GhT5X+Bu7slltIrCkGr0t548GL3aBBNN8aAFgMiYu2OlLMLnrCWDmKRwAFz93c7v4QU0TB+v15IhX+xgdbZSOZuU8C2HwMVN8pBgPuC2+bPhd5OpVghPqBY9LogPyD5murAHEtVhyEASg9tB4xX0LgadhsigKR+PURaEc8nWl3dgfexLVWLczRhTWQeLtbpTuiufCaolgVme47UHgPP6IDtD3Zx3pRhPzuIV1KPIsKSeG7LkHeawmziVKDugDPtSNlyIwJygvlsr7v5y4ESL9uww0QY6GUSQnbRwvFruTYDe7XAYi0AlvTlLYVwsORpFe5GCqsQwCW1dmX97n5pVpMR2bNXKNqixXx16MWJYrPUbEcfYr32QswGtzH5rCMO8SFlAVN/yrX0kybSvssLD8REy2yh7bW7eqxVJ/1iW7e80bj4W/vFXG+IUBJZuyf1h17425wc563qtZBf2JI/b1XK8Zx2v2BOXpgwCnjAXw/H9tKIaMrxwOzp27pKs3JFdyYQhQyx61sMzrg61xPNiMQRk3sgxmTtH+14LtKb25Yu1xeHqPcir3f7/gQmSboxLS7wEV0+s+ayN84kKddPs3chwxhOP4tKWV9anCfKf8/n42h52D3z9xMZFrEucVr75jwCXof2dekezuHoD8bF8E/wYmJ++EIlnaK6icJBDkkCmATZLph/hYI6CRPUOp7yxdwxBK+kC/8bBSsHmYq7zJ
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GpHtxvxOjp2yV8RHxoeenslBTf7D1/oe9xV5ol5f/N6yiOhr7ETa61rvfUG5?=
 =?us-ascii?Q?w73Xe/dnjOr4fQZQ0oXFxQESFeJV2IHhIL99fI0nbTvU050ZUjfR3oLcay9k?=
 =?us-ascii?Q?Y0+i8E9v2J2pX9dkyUQTpEMa6OsRRDjncclbmZi8zKYpjg2jxevlL3L01wnr?=
 =?us-ascii?Q?dMSte+XcZdqIm/S1+ivkZzT7xvydLo4lh7ENts4zOUZXVtIDEcYdYZM5anmV?=
 =?us-ascii?Q?jOGtgAr4Bw1lqYd2T1ijoWOih3iuBL28FcFoLyRO1o8fBOBJSIVo0S0MP9/g?=
 =?us-ascii?Q?VwJnaxLNIkf33nKfn3RWnsXsWapA0qcJk69dUpA2ntdNrFufvpfjghY/TSBo?=
 =?us-ascii?Q?jJJAvKUq+qbgmPLbZiHFP/cJcem1yWqgNl+AtYyti40I24kx68pbJtqNjUzw?=
 =?us-ascii?Q?6GCms1RBcJCz2/uNbLqJ7ZgKvs9dhBfzKRurw/8x+7BytCkKD7wp0WnHw9tY?=
 =?us-ascii?Q?SVE6kqG578w0ngMFhstkjZbX7C6rLp2zJ/K9jP9nMaiNfIURczW9VGeCJw6/?=
 =?us-ascii?Q?R+CSArH1sOlOeTbkZTbbpwRgqfKyFIpm+ZbSJkmk3pRwUDvL4WckHZLKNtba?=
 =?us-ascii?Q?YNf2gCR8Di+5Z0/GYIjNDKd+iHoZlu9iLsF5DSTvIGI2szsGhPGjXosOnU7w?=
 =?us-ascii?Q?NTlltq2OTHlijlIEpumGJ5jbuVreCLu77EWN4WoECGOZeFGJ94ag4WMnO7W8?=
 =?us-ascii?Q?cw2HLD8g+MuL/+jimDoK0DMSSeLAX6DOLsXjrs0kXXVKoFeSR9BeKdmXDzHv?=
 =?us-ascii?Q?++uPuyX0z7Al1Lv8xpqNKIELe1JWqpxhYC01aghENDhs63yfOppymeAUhfdn?=
 =?us-ascii?Q?WTdZPApNj0FmzWhEkn/kM5HbnZIbGOWlLIVn/zHHmEskDBvyeupEJmsQkSCI?=
 =?us-ascii?Q?bDhovTnROnMmFVV+8doRGFs3I5m5KWZVfx9XQBjjexg/ndIP+cMgNxlTJn+P?=
 =?us-ascii?Q?AOLpZQYACAlPBnfLm1S1TA1GarJt6DnV6sEJNoNKLlRscdnYtP1UVZwWXhy4?=
 =?us-ascii?Q?fsqMLLKPsE5XLg3x/fF9sYtfjJjvxceV5z6joobXRNR058AllRmb6MdUT2te?=
 =?us-ascii?Q?86umAkRQxMIQ7+YZWgctCiqnoIWxMYjAwnuMYs6K2/+El2pwdC7WFObSrCYr?=
 =?us-ascii?Q?Ok9OuWBz0NmMsJI0Rw52sAxU7h4BLn5TmdbN+EFl8B/ckB5cpgYg7n9Q1VTO?=
 =?us-ascii?Q?S9EEbkunpm+KYhLNtEXSQ8ld5vuiwNNjr6MMhb0aKOKlfb8y+P+MEyM45WwO?=
 =?us-ascii?Q?nSc26WVQ6rBG8irGpxoJasHWC7EiSTYThVopFKTtL4379iMRQ2C+QkUmJCZ6?=
 =?us-ascii?Q?dXE1o5FTkDqNen+dUSEKRITzY11zi5wmE9rp1tum2HF3GAW2F7r3+pCkZWcp?=
 =?us-ascii?Q?klQc5GTpOvz+ZKco5/TQ5MpIcZudCxY38PsmnaHbS5ml0zfw6gk/m91cE4Dv?=
 =?us-ascii?Q?PApABnUEEybtWmvkDO08fnMjtu2bd2n1YLKFr8u+PK0LTaUoUHZiuW/OcJ23?=
 =?us-ascii?Q?I2PXhjokrmIAFF+c4T6lBETVnkqbDcJY4km9jRyFcJqDgVzRLi0eaEyAjKwH?=
 =?us-ascii?Q?8hEJGCYfgmmZnGWH7E0dHM9JrrXFzEZr/I4gEoOaXpThC1dqVBlozJ5vuUdc?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e65c10-a66d-4dcd-c67e-08dab7a898f4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:19:57.6632 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uP3K0yTq/h7G/A7c0BzmmVEO3c2GW3z1XXonxLFR3ddW1qiT1z+TNX/me1v/qV/7YlboftG299ZnKmf/Li7xNe2KHpqueaUO57A2YR0F66o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: bCfK1Uw-eqSyB0xW1iBvE9DYX7_Ze5zl
X-Proofpoint-ORIG-GUID: bCfK1Uw-eqSyB0xW1iBvE9DYX7_Ze5zl
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: [dm-devel] [PATCH v3 06/19] nvme: Fix reservation status related
 structs
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This fixes the following issues with the reservation status structs:

1. resv10 is bytes 23:10 so it should be 14 bytes.
2. regctl_ds only supports 64 bit host IDs.

These are not currently used, but will be in this patchset which adds
support for the reservation report command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/linux/nvme.h | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 050d7d0cd81b..3ab141d982d1 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -757,20 +757,37 @@ enum {
 	NVME_LBART_ATTRIB_HIDE	= 1 << 1,
 };
 
+struct nvme_registered_ctrl {
+	__le16	cntlid;
+	__u8	rcsts;
+	__u8	rsvd3[5];
+	__le64	hostid;
+	__le64	rkey;
+};
+
+struct nvme_registered_ctrl_ext {
+	__le16	cntlid;
+	__u8	rcsts;
+	__u8	rsvd3[5];
+	__le64	rkey;
+	__u8	hostid[16];
+	__u8	rsvd32[32];
+};
+
 struct nvme_reservation_status {
 	__le32	gen;
 	__u8	rtype;
 	__u8	regctl[2];
 	__u8	resv5[2];
 	__u8	ptpls;
-	__u8	resv10[13];
-	struct {
-		__le16	cntlid;
-		__u8	rcsts;
-		__u8	resv3[5];
-		__le64	hostid;
-		__le64	rkey;
-	} regctl_ds[];
+	__u8	resv10[14];
+	union {
+		struct {
+			__u8	rsvd24[40];
+			struct nvme_registered_ctrl_ext regctl_eds[0];
+		};
+		struct nvme_registered_ctrl regctl_ds[0];
+	};
 };
 
 enum nvme_async_event_type {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

