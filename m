Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F30C25B08
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 00:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660003626;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TMLWT/71B1+2SHTnhe+lTgjU7oC15mQny2m3dLN0+Bg=;
	b=f97XA9E0R0LMFGA9FiybUUHLWESCZW79scb3bgREyL60dvNiDgf7lTZCgYk0mpNSwbT1k0
	ESKY65fQQNCpp10XnGA2HxXDd/q/BnwzUcQ6r1RgAJrqXe70Y53JXJAN5lZYFkWNPLSiUw
	e9i4TCxhLWcXIEGVGQsYMliP69boPgc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-ePr03g5wPHup8WqB4jD0Kw-1; Mon, 08 Aug 2022 20:07:03 -0400
X-MC-Unique: ePr03g5wPHup8WqB4jD0Kw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E139C80A0B9;
	Tue,  9 Aug 2022 00:07:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CCE4C2166B26;
	Tue,  9 Aug 2022 00:07:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 88A3A1946A50;
	Tue,  9 Aug 2022 00:07:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3C09A1946A4F
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 00:07:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2166F492CA2; Tue,  9 Aug 2022 00:07:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CB76492C3B
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:07:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F39428001EA
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:06:59 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-93ahaJ6KNNmZwHXZnRpcHw-1; Mon, 08 Aug 2022 20:06:58 -0400
X-MC-Unique: 93ahaJ6KNNmZwHXZnRpcHw-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278Nwhfj031116;
 Tue, 9 Aug 2022 00:04:47 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsew155hk-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:47 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 278M0wOA034454; Tue, 9 Aug 2022 00:04:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3hser2da0q-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:45 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4907.namprd10.prod.outlook.com (2603:10b6:610:db::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:44 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:44 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Date: Mon,  8 Aug 2022 19:04:14 -0500
Message-Id: <20220809000419.10674-16-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH2PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:610:59::23) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e026638-f8f5-4c3d-d4c7-08da799ac3e2
X-MS-TrafficTypeDiagnostic: CH0PR10MB4907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: l6dQiQk4CJoci2YIlEjENFhiBDEKX3oQjnb2kgzxP2k35S/lQnH5PL+33AdcGYiEB+g7UnxM94Gj4T+nigZbYI4L5tPvp3MCQ2bK/16eWKttWpzyCi5kL3W/zlJs8QtH/PxlsUv1s45LQcHzbcYKo7rtH5VofIi9I55m7HLUhbcEDX+Pe0snxi3IqGghu7LO88Ylvb+5wRsyC3gc/aIRHxj5dD+BFOnwqxPBjnOU2n8UwPA3Wu4psOAxzzWbBSn6gDkcLDs3qs2FauxLk3m/3uSpfYDNaUYyZpphKnXelLTPGY/910PAZuC6XAck5uXRuKGULyzEMofX3M5dpFo2A/ua15OITHW/UsMWOUzkszNxusqSAESJMPoXApFlkdBgB1olo4wXlavrWAfzew02fMFTllOuGzw0cPWM9pzdvhRia4Lx620JLctYZ9yDXoBdHOAX3/t5ECx8STM4JcY2bSwpRfQJetj5M/lDKpqxP/Zou4zDuDBY4z9oDuEfMqtZ6N/UepVn+fEBg9B3fZn5v1Gu+MvhqBkPqWhf+Skh9i2W6KSC+ho6DnfUpfzSOdUJp96+AVzBu4Ho7vNZ6Ksjbjbanen5SZqfYPcQlSzuWPR/ssT9/3gqb6K8Wuyf+OoLU7voqzY1tBrkxaravLIb2hsBo65i7tI9wi0JVMDEnSjzwLIDGvp5c6/GLuwyXJjtu47SzOigq8EoD8cpta78xky0qfQEKaMUVxhiG67tJuUd8jm9lC6uupKk49TxpMYMGFDUZfrEQJhMj1VZThxH5e1Ya/h2Ib3vWE4I/WXCovE=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(366004)(136003)(346002)(376002)(39860400002)(921005)(6666004)(41300700001)(6512007)(26005)(2906002)(6506007)(83380400001)(2616005)(107886003)(38100700002)(86362001)(186003)(6486002)(1076003)(316002)(66476007)(66556008)(36756003)(8676002)(66946007)(4326008)(8936002)(478600001)(5660300002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VGPAvg+HVdIYIMtlW4dZZ5GVmcftTne/n8BcwXIreyXVNPzLRyZmgGzN4NhX?=
 =?us-ascii?Q?I4WtFS/2p/Evim1j92/BFYNz6U4EGtzhtxMetWvgpBP12Thqqvu3s+CXcOwe?=
 =?us-ascii?Q?pQM14PdgEKcaLiVIaREQ21/kg6EU7ezyX8+F4Wwyvy5zezgTz0l5taMINHM2?=
 =?us-ascii?Q?xHXmd/riYw+aP8fronCI4hQUOdXrnT2JbjyqEuGTcyTF9+JR2QFxfrlr0rp3?=
 =?us-ascii?Q?+BtZin4srhw029dy3d5mKMrNmNzshBcs6SByuulgJvbHNyVjjPHPuJ6B1PKR?=
 =?us-ascii?Q?ZctXpBwiaDDWEECrhP36/kCrTSpugPS03Xx3kKgzxQwaGIirbxV2tu0fn5pp?=
 =?us-ascii?Q?m9yVcgFmguYgkdQmiJpcbOAKZiTjhkCeUAsEo+adIFzKOSBRfpqNbL6uv2YD?=
 =?us-ascii?Q?X/A4BWSPW5F1pnPdaFVSy8X097gLySeaULFDM6HnRaoEXFDhSIcEA6bRaRn8?=
 =?us-ascii?Q?Ek9dF6ezM/LbLmUBSSQHtKT6h576zu59o7G3XmzUNOUHxV4VpXHeLiwefT+W?=
 =?us-ascii?Q?cITTbRUrjMxyaDYknjjiTpg+Izl4Z0ifwXuudBOGb27gHE4Ibc/vLlBkpZcV?=
 =?us-ascii?Q?+Rg+50/lQYjnqAIK5oWoMRNfsQsIGP9PmgRKoJkOxl6p0nhU+sMm5Zj9EEUq?=
 =?us-ascii?Q?QUt/B1TCqJbcyp7kD6y8INhV2pggisMq+hb26ihv/BemefrzU3iySVi8Tb4R?=
 =?us-ascii?Q?7q2u5f7irC82uW9yWvbtjLg29EDEoPN21pahddtUGnXR7WYMsk0qQB+p9GWJ?=
 =?us-ascii?Q?0ZAk/LcVzUgw5thHIIfyDYdFeNEWSVGsOVXGX2aHPYn+7tNY/fbPxE5TfsHM?=
 =?us-ascii?Q?KFaWLwXjK+1d+FFckxoLPgDlm1bshunZeKB+pM+T+E2Bj3HwoMANBQgD/Dlx?=
 =?us-ascii?Q?/P1nSbFJxTnFatxoovlJmpyZRzoMKnhZQ7ivRFedDI5Uj2KRY+5ZeBPEl1b/?=
 =?us-ascii?Q?Aq25ODg6ipmHtPCbm8kgg17ApeaINKYSsBBVtVoMat7QjOaXwU0M1moOjDuf?=
 =?us-ascii?Q?e7EPN8S0RnTNPUuFgEGk+VGHfe8bV4EXyRhRgPVZnnNIwqTELjpKWUpYEh4/?=
 =?us-ascii?Q?jIoMHniT/+fv/UFvzLHnbPbf/UnIN/38sJVjUaGeLPNz1L7FFJvKAix4GZCR?=
 =?us-ascii?Q?xWexbCOBJ1M8OLZQKXkyTI9vOXMRWrib+Vo+JeJqFTMT7i3qSWcUbi2aflnF?=
 =?us-ascii?Q?hrlymMOK/I4AFxI/VAIE2SF+d9BnNsAJ3Q0b7qyG9Fx289MP86ZvGK92pTNq?=
 =?us-ascii?Q?nNIAHgSajOicpLfYDbxyetGDz5F/2Qm8jSrzI5QjLJoUwtNSqadvWI3FGQ0q?=
 =?us-ascii?Q?fuTJpDlrrnthZCdm+BfVb5TMX4ytPKyArFfWru5NloTK+GFp18lkLQfFQYmm?=
 =?us-ascii?Q?4W/nSOlJ/twowW4w4IqGUJ4EpUMat7uehOVqexRzGXMCLhi9eIRawN5DfBM3?=
 =?us-ascii?Q?9qkmh26MajBqHw8M4PE/PXEquU0nEnA3ano5bG36C1puhAFiinQNy2lAIjJ2?=
 =?us-ascii?Q?DgGMglJ1j+x9THJQTmItsKMZmzo+NrCcS23Wi0f65odTNKIMM4Nujawoh1Qw?=
 =?us-ascii?Q?lwtQxLh1QgwHBS85ERy9UxhIj5IJss/p90TgfNk6F2y9gJiejif6wyIWda6L?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e026638-f8f5-4c3d-d4c7-08da799ac3e2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:44.5787 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAsYdiRwxLGLg14hxrHoLUiG3ly5vj2SlFqjKBsEMG6ubq6wVOD1Qy2IslUsrsBEZky7hAOP3m6jYOJsriWIP7HN4eKHL0aLMuDB2A6NUiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=999 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: eGr85Xv6ZWE4f5jBH31vF5JyTyVnOliB
X-Proofpoint-GUID: eGr85Xv6ZWE4f5jBH31vF5JyTyVnOliB
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v2 15/20] scsi: Export scsi_result_to_blk_status.
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

Export scsi_result_to_blk_status so the sd pr_ops can get a BLK_STS error
that can be returned to other kernel pr ops users.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c  | 3 ++-
 include/scsi/scsi_cmnd.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a2a3a9bd5ba1..d7825ff8915d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -587,7 +587,7 @@ static inline u8 get_scsi_ml_byte(int result)
  *
  * Translate a SCSI result code into a blk_status_t value.
  */
-static blk_status_t scsi_result_to_blk_status(int result)
+blk_status_t scsi_result_to_blk_status(int result)
 {
 	/*
 	 * Check the scsi-ml byte first in case we converted a host or status
@@ -618,6 +618,7 @@ static blk_status_t scsi_result_to_blk_status(int result)
 		return BLK_STS_IOERR;
 	}
 }
+EXPORT_SYMBOL_GPL(scsi_result_to_blk_status);
 
 /**
  * scsi_rq_err_bytes - determine number of bytes till the next failure boundary
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index bac55decf900..c4de69ba859f 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -155,6 +155,7 @@ static inline void *scsi_cmd_priv(struct scsi_cmnd *cmd)
 void scsi_done(struct scsi_cmnd *cmd);
 void scsi_done_direct(struct scsi_cmnd *cmd);
 
+blk_status_t scsi_result_to_blk_status(int result);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
-- 
2.18.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

