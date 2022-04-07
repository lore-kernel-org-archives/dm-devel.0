Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16C3C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:18:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-WHqfmamCPQqNVUPwTLYIQw-1; Wed, 06 Apr 2022 23:18:17 -0400
X-MC-Unique: WHqfmamCPQqNVUPwTLYIQw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62556299E757;
	Thu,  7 Apr 2022 03:18:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4AD0A40CF910;
	Thu,  7 Apr 2022 03:18:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CFC3E194034C;
	Thu,  7 Apr 2022 03:18:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1F1F41949763
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 03:18:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F4151428F1B; Thu,  7 Apr 2022 03:18:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF557428F16
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:18:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D35303C13936
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:18:13 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-fz5qS3gxPyeg30ozGQPE5w-1; Wed, 06 Apr 2022 23:18:12 -0400
X-MC-Unique: fz5qS3gxPyeg30ozGQPE5w-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237165Gk014690; 
 Thu, 7 Apr 2022 03:17:48 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9tcwa-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:17:47 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 2373Famr004015; Thu, 7 Apr 2022 03:17:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3f97tststf-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:17:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 03:17:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 03:17:45 +0000
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfqpinuh.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-13-hch@lst.de>
Date: Wed, 06 Apr 2022 23:17:43 -0400
In-Reply-To: <20220406060516.409838-13-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:01 +0200")
X-ClientProxiedBy: SA9PR13CA0129.namprd13.prod.outlook.com
 (2603:10b6:806:27::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d6f5c4f-09ce-4dca-6516-08da18452f3c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4408F5BE300B85FD77766A158EE69@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: QymSv9kMr0E9rJMwIJ8INrKljArbWusrbyf7l9t4lmaxc1FRl+w1EfUM2Jfud/kNMfQLZSvqHiSvaDiIDZg9gLyzgebXWi1+J65UVejET0aJlAMILKRCl+o9FiIuxHQHfQg7ci07KSlskXWOPg0Agq+UgLC7VJQXm3/Rxmh84rXhrV9d0l1ehFFl/TlpmZGRdYFQD8/0WK8oMaVpZ3qpQcE96fbI5rJKMOFTv0UsvVFEe7QS7640dcZ/iW1acCopHPfgH/pZ/El2lWGEpocpAT4cq/9KM9EF40Y06lIlHU//gelZs7sc4aUFxMdQLnPCCDi0EGlFyL3TJbK+SLqX4Hm8Cb9mkoRirqZm71yKGicbPVGs2vNWqRygXn2y0w+V3BZk6Dyw0H7A86prrnnfGOjrzDpMunSh6y5pHAftUb+8icS0FSu2HdgXJpjsXqjxD74HZe2Cg0yZ9bWUK2h/pU05tKhx+EcPgMEZKn3JfP6JgCL1z4F8Mqqt67cmNNrd8olDc4JgCqIfQ4LzyfxuNaNvVC8RTMRegLOzsojHJ1EnC4xeBfZv5ONcjvqiG695lo8GUdSKvaoOnw15D5CgyY0ItPi32muuJTc1urnldMoqDln5l5GXorNEx2ZE4ml+MxNn1h6KHa80SFSp6/batgoxoFbs/O8ISJB45Jztujfb3vvZKjAO7MAGRLiagpwlsAcAVD11x0iKvR1JjdQCCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(508600001)(6512007)(26005)(6506007)(36916002)(52116002)(7416002)(83380400001)(186003)(5660300002)(2906002)(8936002)(54906003)(316002)(66946007)(38350700002)(38100700002)(6486002)(6862004)(66556008)(4326008)(8676002)(66476007)(86362001)(558084003);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lMDH6ktrhG4WjULAJWCzTSBpUEGRbnI+XkWo+m+dUdXtk1wTAvYoERSa5BxF?=
 =?us-ascii?Q?QebEe8wVngoVb1TXBZuSXZoKaHkPW6stsOLDSBQuHbHQ2BnpV7PbNsb0vMwN?=
 =?us-ascii?Q?AM4GPRAlh/zejuQNGfr5ieAm6dnWlwKlr++8LdPyF8XMjkhH86nON60X2xQs?=
 =?us-ascii?Q?CwaF3RV3c4Nyy3P8T/9Jy4K98AF5HuLIY4Uz69rGT0yVc7NaTFEjIrGXk2TF?=
 =?us-ascii?Q?bkFT98C7NVZFlTU7ds7oE0SJawz8yS1M/1Sunx1XiVQ3rbdjEWXoBQ5D0LZx?=
 =?us-ascii?Q?Xo8qfSQAFOeE9CeUAL5VcPn9guzR3bg6rAXI1JGV5M6+YeGPAbGBLONQmDrX?=
 =?us-ascii?Q?TJtxF7BuutkODths9sUCawLxH2UiJGdWnv6JRXVTd/6AzBtFLWq8F2I/ScpC?=
 =?us-ascii?Q?6jtiE2o8EL8iPFxv1FsLym+PXLCHoohT9lMzmRHgtiBincSPwE70KeOOAB/8?=
 =?us-ascii?Q?a2iGaXz0UM6gciEW6bV7mRC6wAMOYiR3wp7Spudu+FyHc/1oj058KT8b74Wn?=
 =?us-ascii?Q?qVk0B4CURAfRS2dGuv1r0RCg4hKuQtkTdQk3m98IZp4SLgWGeC4xqhKxin/M?=
 =?us-ascii?Q?ROJKiORW++3T1xbzjiXuaCNMbMTyEbmVY5xj1mvPHC20jMvr/dVoQKGCHhLX?=
 =?us-ascii?Q?EYhrQfpvn54xuQwMvNAy0oKtZcn4A8WvmSuGAuWdNtKWQmCAgpL3sy/Vbinn?=
 =?us-ascii?Q?hQ1PzWlS9++zlwsaiw/7rJ123mOzopAiMlpHW8kGBTjanL0E2S50L98YINT8?=
 =?us-ascii?Q?G7DrBvWBybWQOR+08b2Xdaau+qtSetk7vQkDX6wz7uUHDDU214kuL2PTrGgC?=
 =?us-ascii?Q?Pz+2lwbvnh4Mk9jA4I94DE266ZWBDP6WpClUadblwq92xgZegMyu7TfypwsI?=
 =?us-ascii?Q?R16JfkCqk8qR3Ki69Z0yBPB+Gn3wO6zhB5C5TvDZ+/7wxKuSBqCGicaZR7l3?=
 =?us-ascii?Q?sxNXPGzRSxLs0h+qvGRNazcrCFCGnfhXIRDwlpGfUcAfkcxrQL7RLCPUanT1?=
 =?us-ascii?Q?97IFx0A9UjVlqjzakdrokgrXWZz1qC0bCvyg0+xiAt+d24eP0gjt1z7MOjBI?=
 =?us-ascii?Q?ZpEzTSLaH373UJKpBPF57mmjaUj/+5NsUeRrIF5oAjMWSECeq6Eeh3gGwNCF?=
 =?us-ascii?Q?3q2VCRygT77j7dcY5qatGkCTHvl84Uey6Hb9zixADDIxcjVeEnwJssUc3CCB?=
 =?us-ascii?Q?Xg+XxNjFAlq7d8TZQoT+P3aDAP9FSVkB1zqeJNx8sbcjmfGmRnKl4p+dhs6Q?=
 =?us-ascii?Q?j8rV4ZT0SWk4AXMf1BHYNDHoE+jpMdyQR2/PuZ9wB69Tm4jz5Gewt9S9EGj3?=
 =?us-ascii?Q?WlhylvcE5dp8mTSVEh1cGxrhzb+f8ObqfzGo0RV54V8WL/+gWxdQNexhZUvM?=
 =?us-ascii?Q?afmpmpIXJoQMSdFoHQYpel/stXwpAgYj/J5aVn+Irt7qOMUiFSWKnabuj0Na?=
 =?us-ascii?Q?HdfyK/yCzi4mNeRPYvtJPTSsUcq4m0lliV5bSCu5QS00TjZWO/CFWjB0VZUe?=
 =?us-ascii?Q?GEC/2X8sH3x7grRoV+rCWwvilIMfdMAE1uE55eHaeWkqElY3P4QqgVU9XQ6w?=
 =?us-ascii?Q?rUtUn9sScEkAPqgFBBg7oGHFfBRfhHEi2uPFSz5CKE0u+JB6tBczLcdPTyuU?=
 =?us-ascii?Q?+k5VaoJzbZSC6/tFQ+GbEH3m5GGwCzBouSG1ws0XO0k1cLL0Iuf9PCjX0OAt?=
 =?us-ascii?Q?y+Ss13cHXOzUhwIkoYECHYxUr/dAspnaYRBUDrf/fMqbVYnMToPBZUfrhJmf?=
 =?us-ascii?Q?Hi/NKuIrK2eWfje3rgQEdgUGrvRhu7U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6f5c4f-09ce-4dca-6516-08da18452f3c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:17:45.2049 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aBJZRnTe5Kx0LzLVx81GItdPKiCUwqUPHtBHkFL4z2+UkdDsGENVRb/GxmKjyxCvUy2HemVTsPNJYKyuHK3cHqYGwBsE2ihiVcqQWJbOMKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-06_13:2022-04-06,
 2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070017
X-Proofpoint-GUID: ltKuv-mLVXiJy_PpAHZUvxU_1hIMo61V
X-Proofpoint-ORIG-GUID: ltKuv-mLVXiJy_PpAHZUvxU_1hIMo61V
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [Ocfs2-devel] [PATCH 12/27] block: add a bdev_fua
 helper
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
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
 drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org,
 linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
 cluster-devel@redhat.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> Add a helper to check the FUA flag based on the block_device instead
> of having to poke into the block layer internal request_queue.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

