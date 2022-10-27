Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E0C1FA3740
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198350;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=53edqRvhE8eA/UPL7Kw6LId0LenEUzYFztbyf2swJoA=;
	b=Js5lZUN6DjAXhXQ+HJXmFvY0Tg6yTEWga3mdQfskflhwtnJtfG6BDINGjXrEAgZqM06Mp2
	ty/+3xiuO7J6IydWFnMdhlbXPynD8sniZKA432g14C01PGz/ZkkMODeBbfQ39ArSHBErRS
	vIutwoBhRx+QC9PNsLb/AyJaCZDh09U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-CX4TuKprPyeZpN4vEYiLiQ-1; Mon, 31 Oct 2022 02:39:01 -0400
X-MC-Unique: CX4TuKprPyeZpN4vEYiLiQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 442751881292;
	Mon, 31 Oct 2022 06:38:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC89140C94EF;
	Mon, 31 Oct 2022 06:38:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E0FD8194658D;
	Mon, 31 Oct 2022 06:38:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 53C2719465A4
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Oct 2022 17:07:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 478BAC2C7D9; Thu, 27 Oct 2022 17:07:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F9BBC15BA8
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 17:07:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1ECCD3811F46
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 17:07:26 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-BHFS_RhcNJyYdQ0L0s9BHg-1; Thu, 27 Oct 2022 13:07:24 -0400
X-MC-Unique: BHFS_RhcNJyYdQ0L0s9BHg-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RGDvqi014958;
 Thu, 27 Oct 2022 17:07:03 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfax7tktk-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 27 Oct 2022 17:07:03 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29RGEwie012294; Thu, 27 Oct 2022 17:07:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3kfagr6ngt-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 27 Oct 2022 17:07:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB4253.namprd10.prod.outlook.com (2603:10b6:208:1d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 17:07:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 17:07:00 +0000
Message-ID: <a74266ce-3839-5d2f-abc4-cb30045d811c@oracle.com>
Date: Thu, 27 Oct 2022 12:06:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
From: Mike Christie <michael.christie@oracle.com>
To: Keith Busch <kbusch@kernel.org>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-11-michael.christie@oracle.com>
 <Y1qhXQYOpEUk2uqF@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <Y1qhXQYOpEUk2uqF@kbusch-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: CH0P223CA0028.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN2PR10MB4253:EE_
X-MS-Office365-Filtering-Correlation-Id: b8ee6fef-a1ac-4e64-2f56-08dab83da99f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: TFg7RGoS5dnbX8EoSZwuweerl4w1jTtCYkDJ6Z7NK/iQYFZMYXohhId5UFa7ezBj1WPU0CbQbVZK7hwMM/lpr9eT0cCufWBlYvkHiFMLK2D4gKC6pXaPuft0Shc4c2rIACSwA4NVmOJc/p69X8tvWbxmwVmgrEzIgH7BB+4FxIu/vgojypWOMqhjsVCtheINGo+VXYTV0VvCvBKcKihtHMjBv3mNVBLlOed1gjsWVTZ8Vi00VShVJlJF2wkBV93DpM/1PgcQ/9sHND1Ua/3inDMm4ef4ZBv/Sb8xFvqziC08trQs/k9zGfET3qPJvY10GmhQwGYP4GTw3xoY0DS3aLPyJDEEqWlgeJdThw11ZS4s7FR+QVP4Rl1S2KIzu1FKtAG01THeJJhxpS/V+RjaPG1aVUachVoyS+G4htVwsF/IQ4d9eqoIiu+f1uShk9WF/hosZr8xpG/9O0+Uf1uW+AHfjffsOJw7TFaRBBd607EeIpL2wiB3M8RDXPORieLAoJ8km4ABFyVgo5+YM3T/MVqSFr+MHkBFg3rV8Bs0b9HI6lQ2gMFpxTmztVseEh8qBtc4E2Ak8RW9Lg9HJ+GLfI/7HFZMlMZ5tnivHgQ6Maw6Xj7bG9QNwiIH4kh7bFo7zXvj9PvRaXEZhdddej0hw/JeBbjnx2OoFfMHMv/HaduxpxESSW3S6WsnLQCkPM7EQjkNIpahZD5pup9MAmT54CFsGFmP24wkqshJFvhBVj/WrmF/dTtuMpU3UjvF8KS/Qc4WMU/wJaXVIn22JLOrU89o1Pw5SK1/CdaiqZ/OczQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199015)(31696002)(86362001)(36756003)(31686004)(38100700002)(6506007)(2906002)(2616005)(6916009)(53546011)(6512007)(186003)(26005)(478600001)(83380400001)(66556008)(8936002)(316002)(4326008)(66476007)(5660300002)(8676002)(7416002)(41300700001)(66946007)(6486002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3dGL1ZGK3B1bEh6TWhrbk5Mb3Z3cTRnRjlmU0t1V2hON0lsak5waGVsWTFH?=
 =?utf-8?B?ZU1UVE5lZzlna0NscjdtUmJxam54dStzMFdTWngyL20zQVo1N1k5VHhJZkgy?=
 =?utf-8?B?b0RMRDBlSHZmMTl6RlpMVHZrTklSSGJEeXRubkRVeDAyOHVqSlZDZ1hCRDVZ?=
 =?utf-8?B?OHRDR2ZQNXN0cGlWZ1ZOMEZlQlk4aHRkUm9ZTWZyQjJTQlVDTElzb1JpZ0dv?=
 =?utf-8?B?RDBPT0szOWV4YjJCWWd6bmJ1cDFXVFc1U2xWWnFSRDhtZkliYVMxdWJoN2tI?=
 =?utf-8?B?Qm1Cc0lSZ2IyWTBQbXcrVk1KMmpDM1FKcFJiL2hCYjVVV1lkL3NnRS85Wk03?=
 =?utf-8?B?NmEzd2lrQ0lscXRtRVhRTzh2T0ZCb1ZJTHhQSTRlSkpEdHZuRkg4RkhLeThz?=
 =?utf-8?B?U2JUeTZaUVpKQkZvanpNRnVOTVE2dkJkU21XM2NLakdkRU5scTlJTTMyblA1?=
 =?utf-8?B?bTU0VCtlN1oyRmM5c0h4NXZZWGVWa2dsM2VPMldSaFdYRkZMUHF3STlaUm5P?=
 =?utf-8?B?SldYVmZtenFiZFhQS25zenc1SzQ2N0VvcU5XMTgweVZjc0ZrZE0wS09tL2ky?=
 =?utf-8?B?L24rTkVOb3FDNS9qZ1VPSEhDK1lhdVZGM0dlR2dXSHYrVjJPZmFFTERZQkdh?=
 =?utf-8?B?UlNWV09lNFZ3Q1RQYk80U3ZaZUxONzZhemt1RkI0OEZVcFZ1YmpGL1Nsdjhn?=
 =?utf-8?B?MnduaDJGckxoTVNpWm8xdTA5VkNObVJMcVhHSkF2OUwyVVJNRFk2OVowWGp2?=
 =?utf-8?B?Y2dNdVlGZzFVaFRHeUtSSGR3Q3liZnFTQ0NSZWRma0k0VlZVZFFZZ1hOS1Zv?=
 =?utf-8?B?RUtoUDhIbi9yOXVCUUNTOU1wcnlpU3hzckYxMG0zZ05UOEFtcmRzTnFWb2dn?=
 =?utf-8?B?T1cvemZsd25wdUJqWXQ2aFd4ZGYrTjE3UWlJMTVZYXpUa0RiVUVJbmVVQVhR?=
 =?utf-8?B?SmwyKyszTVNSWFFnZlVhSGJXSnRSRTJqWm9lRkVYcjdTR2NSNGVvWnpoQW9t?=
 =?utf-8?B?MEh6MngzRHEvbGlybENhV3hsWmlhakZ2TXhxZ0cvbzBoc1k4QXhHM2dBTHNl?=
 =?utf-8?B?Y1VDd1FxZkNaYmZ5OGE3amJRcllHS3EydDFicWJ1djlrNWRldklzQm1aQ3hJ?=
 =?utf-8?B?ZUcrTmx0cWJzYlVzQ2VQQXdacGJnOVhZOFVRajFLaTVMQ01SazJVVVVLUG9V?=
 =?utf-8?B?YnhiZEpNN0JKK0FpUXNrczhtamZpZzZ1ZGd4V1dXV2crNzA1UlBsSFhuN2Z0?=
 =?utf-8?B?OE5GbzI0YmRyRHR3SngxNmFNZFZmN2M5UUlTT2I2ZUVkTkVrVk1PSmVCMHM5?=
 =?utf-8?B?cm4xVlZiNjVlL000Q2ZzanNiSXZrelFqK09FeW0xMjQxcEdhNmNHL3BKSTlZ?=
 =?utf-8?B?djRFVWtJMGVCUjR5VStsdXNYcThMSCtaaXZsN00rcituRmRkSTJJUDNZT1p3?=
 =?utf-8?B?M1VzV2RScFprM3ZFaVpNL2JOdWY1WXNxQ3Z6Y3ZkMm93TFpvSXN4cTExNFhU?=
 =?utf-8?B?MkFZZEgxa2dyQWpwcE1mTVpqYzNSMW9HUkJTYUpvcFUxenBsb1lDYU42VlpB?=
 =?utf-8?B?YzBtaW1HRVRPdk40SC9oREo4a2g1R3pMZFZzRmhCZndZb2NCMkRZMy9HUTda?=
 =?utf-8?B?cHJiRncyTmZWalNFOWQzcWNXOEgrR2pWdWtkVisrNG9sNTNvNkZsQzJHUnY1?=
 =?utf-8?B?dGc4bnVDSy9sUVhzTkc2TSsvSnZnQUl4T0pUYytwb0FSMVcvRjVpdlRMQUtP?=
 =?utf-8?B?T3FMeCtwK2VEWTV5T0VNcFVQZExQRTk5Q0EvSE1iYjhld1pEL3JLN2RHUW9w?=
 =?utf-8?B?N2N3S3VidXE3dE1LanRYTWx3WnEzN1FmSlFMVjR3WERWdW1jR0NBMjF2bGR0?=
 =?utf-8?B?TUZJU1UvajJwRHhqZTltZlkwWE5hbFo1NDg1STFZRWdnZVptblJLYWlkNW1j?=
 =?utf-8?B?NFdlZmx4RDJYVFhBbURFelBiLzBFVUFwVkRGZkEzdzFJTWxMQmxwYU9YOFhL?=
 =?utf-8?B?OE9tUHcvMGNSSE9iZ3RjTFZQUzVTWEcvY0U3czhSTnBBdTQ3ak1BaHkrbmo2?=
 =?utf-8?B?TUpYblFXZ1JHdGpMdHZnYSsxd0pWeDVwTmFQckZNZXBFS2RRNThELy9PcEE0?=
 =?utf-8?B?cnN2QS91U2pUcXFBSTJPZUtST3BrVEo1SUlZczhhSm9Hc0NSQlRDQmMxYUY5?=
 =?utf-8?B?SHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ee6fef-a1ac-4e64-2f56-08dab83da99f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 17:07:00.6362 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3nblroOM37cvJZ/dttA1utyIrmIet+N3WrEXdLoFg9B7lmve3CKCRdbqSGsCQesq9oZBX13YhLOax+Zdgvg/R9TCvdVEE1/hrsmeyzHSBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4253
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270095
X-Proofpoint-GUID: w2zmSZo30J2kBCIz4qjrznCMegGFye1p
X-Proofpoint-ORIG-GUID: w2zmSZo30J2kBCIz4qjrznCMegGFye1p
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: Re: [dm-devel] [PATCH v3 10/19] nvme: Move NVMe and Block PR types
 to an array
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, chaitanyak@nvidia.com,
 bvanassche@acm.org, linux-scsi@vger.kernel.org, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 dm-devel@redhat.com, target-devel@vger.kernel.org, martin.petersen@oracle.com,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/27/22 10:18 AM, Keith Busch wrote:
> On Wed, Oct 26, 2022 at 06:19:36PM -0500, Mike Christie wrote:
>> For Reservation Report support we need to also convert from the NVMe spec
>> PR type back to the block PR definition. This moves us to an array, so in
>> the next patch we can add another helper to do the conversion without
>> having to manage 2 switches.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/nvme/host/pr.c | 42 +++++++++++++++++++++++-------------------
>>  include/linux/nvme.h   |  9 +++++++++
>>  2 files changed, 32 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
>> index df7eb2440c67..5c4611d15d9c 100644
>> --- a/drivers/nvme/host/pr.c
>> +++ b/drivers/nvme/host/pr.c
>> @@ -6,24 +6,28 @@
>>  
>>  #include "nvme.h"
>>  
>> -static char nvme_pr_type(enum pr_type type)
>> +static const struct {
>> +	enum nvme_pr_type	nvme_type;
>> +	enum pr_type		blk_type;
>> +} nvme_pr_types[] = {
>> +	{ NVME_PR_WRITE_EXCLUSIVE, PR_WRITE_EXCLUSIVE },
>> +	{ NVME_PR_EXCLUSIVE_ACCESS, PR_EXCLUSIVE_ACCESS },
>> +	{ NVME_PR_WRITE_EXCLUSIVE_REG_ONLY, PR_WRITE_EXCLUSIVE_REG_ONLY },
>> +	{ NVME_PR_EXCLUSIVE_ACCESS_REG_ONLY, PR_EXCLUSIVE_ACCESS_REG_ONLY },
>> +	{ NVME_PR_WRITE_EXCLUSIVE_ALL_REGS, PR_WRITE_EXCLUSIVE_ALL_REGS },
>> +	{ NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS, PR_EXCLUSIVE_ACCESS_ALL_REGS },
>> +};
> 
> Wouldn't it be easier to use the block type as the array index to avoid
> the whole looped lookup?
> 
>   enum nvme_pr_type types[] = {
> 	.PR_WRITE_EXCLUSIVE = NVME_PR_WRITE_EXCLUSIVE,
> 	.PR_EXCLUSIVE_ACCESS  = NVME_PR_EXCLUSIVE_ACCESS,
>         ...
>   };

It would be. However,

1. I wasn't sure how future proof we wanted it and I might have
misinterpreted Chaitanya's original review comment. The part of
the comment about handling "every new nvme_type" made me think that
we were worried there would be new types in the future. So I thought
we wanted it to be really generic and be able to handle cases where
the values could be funky like -1 in the future.

2. I also need to go from NVME_PR type to PR type, so we need a
second array. So we can either have 2 arrays or 1 array and 2
loops (the next patch in this set added the second loop).
If we don't care about #1 then I can I see 2 arrays is nicer.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

