Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3038FC43217
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 05:23:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B7C5760FDC
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 05:23:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B7C5760FDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-mstTBZqbPtSr5g_sH9v94w-1; Wed, 13 Oct 2021 01:23:14 -0400
X-MC-Unique: mstTBZqbPtSr5g_sH9v94w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBE291006AA2;
	Wed, 13 Oct 2021 05:23:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AAD812AF99;
	Wed, 13 Oct 2021 05:23:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7B85E1803B30;
	Wed, 13 Oct 2021 05:23:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19D5N8bp023571 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 01:23:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EA05C2166B2F; Wed, 13 Oct 2021 05:23:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E351C2166B2D
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 05:23:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00FB1800182
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 05:23:05 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-539-UrbDYvV_NMmIyR4ZFfBfxw-1; Wed, 13 Oct 2021 01:23:03 -0400
X-MC-Unique: UrbDYvV_NMmIyR4ZFfBfxw-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19D0ZVeY028779; Wed, 13 Oct 2021 02:39:50 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbh0txh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Oct 2021 02:39:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19D2UkDR170221;
	Wed, 13 Oct 2021 02:39:49 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com
	(mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
	by aserp3020.oracle.com with ESMTP id 3bmae01t1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Oct 2021 02:39:48 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
	by CO6PR10MB5411.namprd10.prod.outlook.com (2603:10b6:5:35e::5) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20;
	Wed, 13 Oct 2021 02:39:47 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
	([fe80::7c3a:acce:d3fc:a654]) by
	CO1PR10MB4754.namprd10.prod.outlook.com
	([fe80::7c3a:acce:d3fc:a654%6]) with mapi id 15.20.4587.026;
	Wed, 13 Oct 2021 02:39:47 +0000
To: Eric Biggers <ebiggers@kernel.org>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7dlps38.fsf@ca-mkp.ca.oracle.com>
References: <20211012214330.40470-1-ebiggers@kernel.org>
Date: Tue, 12 Oct 2021 22:39:44 -0400
In-Reply-To: <20211012214330.40470-1-ebiggers@kernel.org> (Eric Biggers's
	message of "Tue, 12 Oct 2021 14:43:26 -0700")
X-ClientProxiedBy: SN7PR04CA0078.namprd04.prod.outlook.com
	(2603:10b6:806:121::23) To CO1PR10MB4754.namprd10.prod.outlook.com
	(2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.12) by
	SN7PR04CA0078.namprd04.prod.outlook.com (2603:10b6:806:121::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14
	via Frontend Transport; Wed, 13 Oct 2021 02:39:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: def6faad-742d-45c7-1ebd-08d98df2b8e2
X-MS-TrafficTypeDiagnostic: CO6PR10MB5411:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB5411E51F502BD9A9ED9A63808EB79@CO6PR10MB5411.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: kdKBApzz4XdzJYpg5Q6ahClm6OWqTJmLOITqSNq2Gc+G01g5xXO32kslt01a7l2R2rfp+lsXELDZYvg341z2ubGfjk+c6Bi8XUoDL2PBJZk3euM6Kx7m69g97vW7ExWcP2LV0ePeijRn3s4Lff/mVrVPaxXfbJeigQnP8GCzeIwMGWWM4nWmO9CDORtfyV9ucjCmo9lFL+kCfm90T8lbyfgYzMwrNOpK8+BPkkm6WZ7hs69Vzw/dausX/FUh2WoRKbRZOYLFS3j2wZ4leSBmAeSuel3d7JGSeBG4kvYNz4bk2AogmO/ismaHuvIMZ0JcnBZBab/Qc4/Yva6qS44PX1wy90fjlQ7ZjtUdJlOm1F6E72CvhMvHrf4MTTD3oa1iWJwgUqZDfpgHzXETvKe0/dFjNLuLAgB2kUDo2mvG1sPm7m7miqdGs9MTzcvxs2b9OLY0kjXIF2ubQ9pFkgi9ttI2L4CgYZq89zGvjsovSb1Ob+JnadgVe52aZ2XrLx9ASsjCKoXbcdPgGW9QL9wOqE8xHomJdKz7xmU0SbW4Kt+BlDDT/gRzI4sFS82eZMIl/RbPTDzVpyjiprR5Yk9EZ8Iwrf9tw1/LaOh4qkcbo1oqHSdazRgg/ut2SaOCCpl0fBfJ+x1WGAwneHYyTXVy59hoGAdg0vo52HSrGYilP4fux7+sJZzk6xwx76ZfkCGKdUZ12C+vAH8nhAa7DeSj2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CO1PR10MB4754.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(66556008)(316002)(186003)(8676002)(4744005)(508600001)(66946007)(7696005)(5660300002)(55016002)(66476007)(38350700002)(956004)(86362001)(6666004)(36916002)(54906003)(52116002)(38100700002)(8936002)(6916009)(4326008)(26005)(2906002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K/90f0YuCD304c7hT2Q2s32/CqsN1lAO9+EbbCKEIy1IaOh1Gqmb0b4PKPFM?=
	=?us-ascii?Q?L78Jo+lx93SeI5/G8maijP3ZclZPSGfO0cD5WOKte+yPgOC6iqz8jX+uNZ9J?=
	=?us-ascii?Q?wUyfsmSEHjzrzTx3BJePKjJMsXZ2sajzW/rQI1zJFG3V13DmdoGsTah1UAMn?=
	=?us-ascii?Q?tEmzDT/Y7ilAOGT+RGAiVMNmG86p65/W7vPzhx1BZlQj46DgflfUHmFQaxZA?=
	=?us-ascii?Q?uMMipOKEVYclrVqOb/sFE5L/WI2fbSAtmwdMVASNBYah9fosd8dZaG4OVfUS?=
	=?us-ascii?Q?Kycen8oAPzuYEHiUI7y40X+lgDkTdgYP4aiSm3r28H0Pox048RFx9dl11jJp?=
	=?us-ascii?Q?kWUha8qAEIzh1q+BnpGKc48eQcIoFj3eXBBIhQlc+BWgsfxHJAzMOnSKTxEw?=
	=?us-ascii?Q?qnBBgRXFVFoF8DXCiIRJyLJUPo+PZGhFNI754tyd2HKG2q/X7ChthFpvDS3D?=
	=?us-ascii?Q?LVNK28oL2WcY2JFOZ5NnlYgPcoV9v8lmmowW0YnFFNS5KOpCzEqb26A8U4dS?=
	=?us-ascii?Q?1OWz2ZeLPjNSZnbiK7xNA5XyT245L/ScOMClJkdiEX1FaLLULxu/bSWxbMew?=
	=?us-ascii?Q?Mq2jO/mBHyy8iI8JOCQlg7qfymURGKJxwsq5fzYQh5IUC3MzVSutrSngZz5i?=
	=?us-ascii?Q?pE/qwHCbet3SSEyf6JXhut2J6NinXfj/EpXRbgJr2CXABJJoLAXiqOJJIym+?=
	=?us-ascii?Q?MtSUCj/4Pr5XQwbo1UxAhej15+exoQVYmMF3GLAZ7r2ehIlTl2cjaG67plmM?=
	=?us-ascii?Q?A1sHfjwUDzDBjfgFqGQ8nx7jnohEN/goVqzTzxfpHO7EfI3DKNV+t+cGpHL6?=
	=?us-ascii?Q?q+KEgB1MySD7JoojnYtBnyNBsETJSxbeeGEh/bjfQqJ2tiX88Yvoqm9fIojU?=
	=?us-ascii?Q?XdKNRxguykL6JaobowHg1onQnSQZhhE1Lp93SK2p/jEr1L5iuk9mvrFC1tm/?=
	=?us-ascii?Q?cItW2O5EIIdNF57Tu8mxsakzewo9N7o+eHUwN5gmA/dFExsle8ZchlY9o268?=
	=?us-ascii?Q?Wrgqhxs9KvyJV1VnmZm32dwODt6F2A7XvCrVQLl+WGlJPwvOM01pyoib4ths?=
	=?us-ascii?Q?E/WZ0H4j5IupohnOuomSrla1kKG2b7iUC9N5pKt5F4gYG3NXx8QeY/lHCth9?=
	=?us-ascii?Q?2IVWmsCoVT/W+VLlrAEaByje/W4dnFUwNoqi0rah5aQksJgmwEcK8E6hpZBE?=
	=?us-ascii?Q?chNL7coUw2K/BQHLhjx8TLYWOtvsdgxrpVL4iHhNPR1xh8pemspz4KIrrPv4?=
	=?us-ascii?Q?f0x/so6bTUmbyF8FRkAnFhyTFVCIMhFnAOe3qg1PT/nbLijhB9V8oFWXsiSE?=
	=?us-ascii?Q?lFlMSi3rEpEh/fTpumJgZnAv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: def6faad-742d-45c7-1ebd-08d98df2b8e2
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 02:39:47.3900 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5DKqZlQILGMYDNBGtuawAZLl8goBso206I5gV/hGpLnj6smuDYZZ2Z35nwnb3uXMXaIIOMTf+8O8V73Rxmk64lWqlhZIKAEKDqVS0NCCu8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5411
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	phishscore=0
	suspectscore=0 mlxlogscore=994 bulkscore=0 mlxscore=0 malwarescore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110130013
X-Proofpoint-GUID: QNXjq9eFW7lVqOXyPdF0ark14z9raHL3
X-Proofpoint-ORIG-GUID: QNXjq9eFW7lVqOXyPdF0ark14z9raHL3
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Tangirala <satyaprateek2357@gmail.com>, Satya,
	linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v5 0/4] blk-crypto cleanups
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Eric,

> This series renames struct blk_keyslot_manager to struct
> blk_crypto_profile, as it is misnamed; it doesn't always manage
> keyslots.  It's much more logical to think of it as the "blk-crypto
> profile" of a device, similar to blk_integrity_profile.

Looks good to me, easier to follow.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

