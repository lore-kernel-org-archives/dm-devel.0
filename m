Return-Path: <SRS0=iWw/=NJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F04EC432BE
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 18:36:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EA2E060F39
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 18:36:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EA2E060F39
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-SRk9JGlDPACq9MwFgKRY_A-1; Wed, 18 Aug 2021 14:36:16 -0400
X-MC-Unique: SRk9JGlDPACq9MwFgKRY_A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D8DC190B2A0;
	Wed, 18 Aug 2021 18:36:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B5DA1036D33;
	Wed, 18 Aug 2021 18:36:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 499114BB7C;
	Wed, 18 Aug 2021 18:36:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17IIa58B001581 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Aug 2021 14:36:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CD67F21EE590; Wed, 18 Aug 2021 18:36:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6E6C21EE592
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 18:36:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F5E089C7DC
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 18:36:02 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-359-FtJ5cPYiMyWpYOzA3F3J5w-1; Wed, 18 Aug 2021 14:35:58 -0400
X-MC-Unique: FtJ5cPYiMyWpYOzA3F3J5w-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17IIXHtC005472; Wed, 18 Aug 2021 18:35:31 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3agykmhaua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Aug 2021 18:35:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17IIV8v3143978; Wed, 18 Aug 2021 18:35:30 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam08lp2046.outbound.protection.outlook.com [104.47.74.46])
	by userp3030.oracle.com with ESMTP id 3ae2y2q9y1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Aug 2021 18:35:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by PH0PR10MB5596.namprd10.prod.outlook.com (2603:10b6:510:f8::6) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19;
	Wed, 18 Aug 2021 18:35:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::c0ed:36a0:7bc8:f2dc]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.024;
	Wed, 18 Aug 2021 18:35:26 +0000
To: SelvaKumar S <selvakuma.s1@samsung.com>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfz6loh9.fsf@ca-mkp.ca.oracle.com>
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
	<CGME20210817101758epcas5p1ec353b3838d64654e69488229256d9eb@epcas5p1.samsung.com>
	<20210817101423.12367-4-selvakuma.s1@samsung.com>
Date: Wed, 18 Aug 2021 14:35:22 -0400
In-Reply-To: <20210817101423.12367-4-selvakuma.s1@samsung.com> (SelvaKumar
	S.'s message of "Tue, 17 Aug 2021 15:44:19 +0530")
X-ClientProxiedBy: SA0PR11CA0037.namprd11.prod.outlook.com
	(2603:10b6:806:d0::12) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by
	SA0PR11CA0037.namprd11.prod.outlook.com (2603:10b6:806:d0::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19
	via Frontend Transport; Wed, 18 Aug 2021 18:35:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21382182-2547-4135-b6a1-08d96276f229
X-MS-TrafficTypeDiagnostic: PH0PR10MB5596:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB559692EBC6B94420CF645D318EFF9@PH0PR10MB5596.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 2BGYh6qIQriDldauWLY68jn7Z351Qu1YIrT6esraEf5ehwLYscyk1nFrwtbsPWI70QV16i8gGFuMrNONB74W3JiaOBSjhTD6nynBIhE2VuLE+xXNdWQHGEFkqgBSUTx8ycMAX3dV+MJxA3UG0BBTwPIKyOg+2vI16Sk0X+Ih9jYynrtIlPtJU8CMw4CMVr4FQOqfstBGL/0msySmfCJ0DP1VzWOKUJr/IsTh2HZlbDLxfBJQ/Hf+D4HxKwoFPFgYJ4eB69ov0HyWvcy1f0LS5lqtoeAZbsDNWciT63OJVqcPGZMKWlNH8ViQj8dHzyBD/Qlfrfp88GIqTTwGHJi55CV2E2mW8Co6l9RIbiqRHTLQ+BXTDeRH1tABG+3nQ9QR2jkFSiZ2K0YGoyX4X38GsFh1XyhxPDE0SXNHmAN5k93cwo5CUxVU1aHF7iJ6tttXME7ZL2qlnmCQBKwx06WU0dEH5kAMxdxQvaHKTV6ysdFX9no38q4917DK5zFbUDx+oYZX6ZQeNScwnJiWHZYdoTYxNgdYHPSpI6gTu5I3JMLxVpk4OeBbgUVLJd6pMHWqZVQrrw3E5h3QLsUBucoMIpIbsTEE4uPh/cvNYq/mcUdq13ON9ipAeG6UFy7QhLgzk7Z2cDFMCU0f2a+JAnCwv6ifw2vlLg2a1eAOAvVPLQAJPe8RIIvl8ZoKONx3xQzqdiilmLjP3CosUf57m5Y8Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(39860400002)(366004)(376002)(136003)(346002)(5660300002)(8676002)(956004)(478600001)(8936002)(6916009)(316002)(83380400001)(36916002)(55016002)(38350700002)(4326008)(7696005)(38100700002)(52116002)(86362001)(66946007)(66476007)(186003)(66556008)(26005)(6666004)(2906002)(7416002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mSBNHsRPLAWUjMfUvinAyt2Mo/LFD4pwqpequnVfpH4z+aneMKLobh5a0DSH?=
	=?us-ascii?Q?sweoGK7btq7HFQCJH7NnL1/YDg+b1bbUDhnIvcjR8maTNohvfEV9kd3LKT12?=
	=?us-ascii?Q?dg6FDrSkRutxSkLOHeOs7RL1DztJyG/OMC0Hyurkpkz4cq2O2yP4/r016wXD?=
	=?us-ascii?Q?iP1l90U542/mU8pc8Uiya4ZBVJlG7wITR2YCbLDqwuafaf67jreOgHlcnydC?=
	=?us-ascii?Q?kzCoag10anTUbF7ZwSR6xeI7iFd/M06JN08vjVx98rnx3RPVZsltzc+8jqAK?=
	=?us-ascii?Q?47/Us+IDhYY7uf99aGUYdNRxN+RzZHkjuO1VrPC8snbJ6H3xHKAglJ3nUSHU?=
	=?us-ascii?Q?Cw7QJD1gYI4rz9UeAs4OnFBJM8S0n2A8gy6W/JR4PVTtDMzmjMkoXjzDZy9q?=
	=?us-ascii?Q?t7609kz7yT8+XcLaVkXIbzxyC6ExLuqY9tPswVV2R/hUGStc/QPhWIEU8ESh?=
	=?us-ascii?Q?z5MQSYoJulZ9GJju9CZjxNGjx9Hy91RNs3ZFoeQZvoxwVRalSA1YGXFsMeCv?=
	=?us-ascii?Q?5u2zrw3wP7Q3Zw0N+HmqAEiAI0fECYNEWBp690bIJng+HSjqaBR0/L/zU/0a?=
	=?us-ascii?Q?Cj8E2IZWGTjOpl/dr6DfC10VZRn4+DoOPUNMN+QeEjEhjh2F26W6B0aFij+H?=
	=?us-ascii?Q?pjate4YsBF78z0ro05cApQldALNwmxFHmYIIzda4aGnQJS0MPaGIhK3VvQCj?=
	=?us-ascii?Q?8ldJ6V2hQbahMdlgWTnKCitE5sTsY6v2U2a6I3k6bMGgkj0JJQ/K9ykMF8Xg?=
	=?us-ascii?Q?fLTf+jmOuQ7I5ymaPFomPQ3qi1yndkLPULj+IqjqHXcJN7WdWvijA8gl8mrf?=
	=?us-ascii?Q?c0vjTl1FzsEn44Y9oyonv+qFzFuPAXUmRqseItzv8+e16k0kUhn+vytdxCUX?=
	=?us-ascii?Q?n79WzEIyRTh0LpSfxARWFQrsk+zaRCleldoUK/AeWxW3cTkI4pNEJccv7M7+?=
	=?us-ascii?Q?E46dlttx2AgqH6TbXwu9dHACXDEXDdNYDulGQaiHDy6O+UVhFn7ovMQmI/OD?=
	=?us-ascii?Q?3WN1lG1JS3bC7JhcmBbtJmtzUlx01A92NXuf3eODYFKxXNQr6Va/u4fNmph4?=
	=?us-ascii?Q?I8JXJhhclvk7UmdQSKQFJ308Xe8KMO/Eep8AXJjP/n56R9Fbiu0Yx9rhcAD+?=
	=?us-ascii?Q?+IwtVoJ8QGgLXjiFZzhJtHw32yfeQaZ1uNa1lv4rpKjiBaQw/WnkAqznCkmL?=
	=?us-ascii?Q?XJiP2F70aSf9yQY0eBocgtaH5OIPHK3dyaWPHtXsRUyv8rv7VxKyExksFqb7?=
	=?us-ascii?Q?QcI3XVVQnoV1xYYmUiAt57QyJCyAb9JYZ879s+n1jkF+QgRCsZMY0zU76w3R?=
	=?us-ascii?Q?6RIHzmGJ6t0N5X82qsaACFE2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21382182-2547-4135-b6a1-08d96276f229
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 18:35:25.9353 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHc7u94W/QHGM8lD5GSzUg8LnI23KY3HOiVOsjEunBzshuYSU/MokY1lkrBxRTCzHwZ4yYrobeVN1Lh49WdsnHRcvmUFnpSqLMKXSC/V+ng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5596
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	spamscore=0 adultscore=0
	suspectscore=0 phishscore=0 mlxlogscore=780 malwarescore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108180116
X-Proofpoint-ORIG-GUID: Gyd2TjD4-4FMg1vGcvo3PBu7--Qoh0SD
X-Proofpoint-GUID: Gyd2TjD4-4FMg1vGcvo3PBu7--Qoh0SD
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
Cc: snitzer@redhat.com, djwong@kernel.org, linux-nvme@lists.infradead.org,
	dm-devel@redhat.com, hch@lst.de, agk@redhat.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, willy@infradead.org,
	nj.shetty@samsung.com, kch@kernel.org, selvajove@gmail.com,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	javier.gonz@samsung.com, kbusch@kernel.org, axboe@kernel.dk,
	damien.lemoal@wdc.com, joshi.k@samsung.com,
	martin.petersen@oracle.com, linux-api@vger.kernel.org,
	johannes.thumshirn@wdc.com, linux-fsdevel@vger.kernel.org,
	joshiiitr@gmail.com, asml.silence@gmail.com
Subject: Re: [dm-devel] [PATCH 3/7] block: copy offload support
	infrastructure
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


> Native copy offload is not supported for stacked devices.

One of the main reasons that the historic attempts at supporting copy
offload did not get merged was that the ubiquitous deployment scenario,
stacked block devices, was not handled well.

Pitfalls surrounding stacking has been brought up several times in
response to your series. It is critically important that both kernel
plumbing and user-facing interfaces are defined in a way that works for
the most common use cases. This includes copying between block devices
and handling block device stacking. Stacking being one of the most
fundamental operating principles of the Linux block layer!

Proposing a brand new interface that out of the gate is incompatible
with both stacking and the copy offload capability widely implemented in
shipping hardware makes little sense. While NVMe currently only supports
copy operations inside a single namespace, it is surely only a matter of
time before that restriction is lifted.

Changing existing interfaces is painful, especially when these are
exposed to userland. We obviously can't predict every field or feature
that may be needed in the future. But we should at the very least build
the infrastructure around what already exists. And that's where the
proposed design falls short...

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

