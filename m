Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 786D2FA3749
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198332;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SfeKTfMYhmXPiqDUvzyNTr2+Vn4B4v3a1MgL8Qj6ddY=;
	b=hvQr+Y5QRrQAIyDMHJUKOzikl7fkJIEqeRji8JnhJtHEMq1sA3cLEy3U5Lt8RW+BFzDTp0
	/VEtscfaPcLwp1aFcvg2MwJ3kBzT55oCTMyEItUrvAPn9tojC+UQHnpztn7fYpk9BD+CP8
	o/RxuUCRtHOWhAnSG45uyao4R7JmW9U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-6IFVpuQaPkiTzS5ZaSA3yg-1; Mon, 31 Oct 2022 02:38:48 -0400
X-MC-Unique: 6IFVpuQaPkiTzS5ZaSA3yg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F9CE3C0F680;
	Mon, 31 Oct 2022 06:38:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE814C2C8C5;
	Mon, 31 Oct 2022 06:38:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EE1D019465A2;
	Mon, 31 Oct 2022 06:38:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CC0F01946597
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Oct 2022 17:13:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AC687C15BA8; Thu, 27 Oct 2022 17:13:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A4484C15BAB
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 17:13:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A737101AA47
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 17:13:33 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-KnFys9eeO2uDBXbMnxseEg-1; Thu, 27 Oct 2022 13:13:29 -0400
X-MC-Unique: KnFys9eeO2uDBXbMnxseEg-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RGDdgX026506;
 Thu, 27 Oct 2022 17:13:11 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfawrtrwx-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 27 Oct 2022 17:13:11 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29RExqfN033387; Thu, 27 Oct 2022 17:13:10 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com
 (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3kfagn71mb-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 27 Oct 2022 17:13:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4524.namprd10.prod.outlook.com (2603:10b6:806:118::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.27; Thu, 27 Oct 2022 17:13:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 17:13:09 +0000
Message-ID: <75564e1d-3169-cd50-ea17-53ef96a3a35e@oracle.com>
Date: Thu, 27 Oct 2022 12:13:06 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
From: michael.christie@oracle.com
To: Keith Busch <kbusch@kernel.org>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-11-michael.christie@oracle.com>
 <Y1qhXQYOpEUk2uqF@kbusch-mbp.dhcp.thefacebook.com>
 <a74266ce-3839-5d2f-abc4-cb30045d811c@oracle.com>
In-Reply-To: <a74266ce-3839-5d2f-abc4-cb30045d811c@oracle.com>
X-ClientProxiedBy: CH2PR14CA0046.namprd14.prod.outlook.com
 (2603:10b6:610:56::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4524:EE_
X-MS-Office365-Filtering-Correlation-Id: 93d4b9e6-a502-4f4b-5254-08dab83e8533
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: rO7Ft28J9yi5yqwSOFtYxuc8Z5KLwj5deVmhQwIIngWERvbROHYME9IBZ/+nJQusLQzYBN2BnxPZtYE80G/8OfnPsZOU9bnFW0ya8RJJ/EINBPpANgRl5iBsTqocARiH5a+nYV8SpVuqXbcB+ahtkkUyzDqtpWjbpuf7/huzVWXkqwhMbKYxeLeG7/bZ9KGrwO+NQez2B7VkMojmLililo/wtaX98u6biUEPIaZcGDv30ZXwIz2zCY+jYOif0HmKnr+1RBXacXbuJAviKsF679vpvBclWpXBA7MWcEEIs8Y2JyM1xyjQy8OVO6ZweE49MLrDosVQUI5IfIbhOP6PauboJymJxOf7zqR7+GdJwoTQvUJGaQnO+LYQ0cG5Gq8bjDrIVco6zDG/jixFUHX4Zm5KdBZi5GafXF9KXM6R5VCLY8mEJ2S5pbKG1Oe0epqukoRhCD5wu2xNnT9WEGKdFrdu+Y40BR/jKlUUzm3/ImLCfRiOOkLCMTVz37BJYBB+//jtehscTZyDXJ1bSeAiUCym2fTCecyUdDgRPbOXdFXnyy0Z4t20+N4mAypNsDTgCBLi1fXJR57mwtZJBo+gcHHBwBfldAvFPJsuIKmuvGtoZKE7xYKwoBt+pVl30n8zg4tMwBvfV8dXFXoU8MRQSngD+DvW50fX9PYeIUPRtCe1paBpEmU1BDJD2YyjhMCK3MUjd7s6lhozc8mugH5scF6dX3bh2YWQQkb/s8toqzATSooqb29xS6x8KkGecgi9q1muyHtW54Uy6UZmSYQoTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199015)(31686004)(6512007)(5660300002)(66946007)(8936002)(66476007)(66556008)(7416002)(31696002)(86362001)(83380400001)(6916009)(2616005)(26005)(9686003)(478600001)(8676002)(316002)(41300700001)(38100700002)(2906002)(36756003)(4326008)(186003)(6486002)(6666004)(6506007)(53546011)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXJobkMyTHRBYUVPTlJ4dVR1bzlQcEJWb2UyVkZJZEtJTDkzcUtDUVpRSHo1?=
 =?utf-8?B?cnNaZ0h0L2N2MnVwVmpVQnJhM1RwNEVmWHk4UlFGSkNPRVQzc3FsV2hNRHV1?=
 =?utf-8?B?WTlsVXVBbEJBZ2VDL0xFelIxbDA0dnlQdmFuSDJJTWpldlpNb3duckdwMEs5?=
 =?utf-8?B?UnFjY2Rzam5PSkVQQkRETDhEdXhCSTZMZEhqamlGcXk0OE9vYjRiYTVSV1M2?=
 =?utf-8?B?ajkyT2tWVlJCZ0hoNFU4N0VzOUxhV21RWVNVaWprYXM1TFVLNHc4VzhiK3NL?=
 =?utf-8?B?UXI5UVkrQVlka0VDQ3JjUlAxRkFmOXQzSmpJelhpSG5yZzVjbUJVOU0vMWF4?=
 =?utf-8?B?QXI5aHdPZU53WnFBY2tKMGhpYzJUVnp6SUtJWHF0UVJVd2pnVGp6c2pkWW1F?=
 =?utf-8?B?VEtDM2o5THdwOUt1UFB4dm1DQU1YdldGbytDMnNweW4yaDUrWGwxSkxicU1F?=
 =?utf-8?B?SjVhUTRHS210L1hPbWRlZ1l6RFBIM2tFNzBHTi9jWmYwZW05WXc4RVdQSWt5?=
 =?utf-8?B?Zk9pcy8wVGh0YllZcy9iL3JMR0FVeE5LUW8xSS9IcDVFT0cwajBpWXhWaFp0?=
 =?utf-8?B?Y2ZpQWVhOVoxdHJzNHBCVTRSLzhML0VRZUZhRzBnQVZGbnJnYmw5OUxtRldw?=
 =?utf-8?B?YURMOGxsQ3grNXVMN05YQ0Mvbzdra0dVMkNkSTJqdi96VnNkMmQzNWNtOHk1?=
 =?utf-8?B?ODN3UjlrU3FXUEY4bkFud0Jpc2JSTFFjd2VtVGZIRDBwZ3drQ1VQb2xDaGdm?=
 =?utf-8?B?QnBGSkp5NGhDaTIza1JPTzBybXhqU241ODUxd1NsTWpsN1ZuWkJHRVNOQ1JS?=
 =?utf-8?B?bUxtZ2x0QUFEMVB0Wlhmc2g1WDFBbjA3NE5vanRXNWJvRlNXSDQxVGNySjdl?=
 =?utf-8?B?b2Z1elhpYkJ0VzZlSDJVUm0rRGNCc0dOeTRkeTVGc0hYZkdjeWl4aEZGcmFt?=
 =?utf-8?B?R3g4YlEzcFpFdGZhQjRMMlhyS3lqRjJ2SFh5WEZsZysxSytXeFcxeTgyNXhs?=
 =?utf-8?B?S084V3FPU0pYOGVwU3AvVzhXL3JMdUYvRmhFb240U1J4NDIwUGMzRTJib0xI?=
 =?utf-8?B?SExwZ2tlaEdUeWtuU05iWlpmVUNaVGdSY0h0ZWVvQ05HQVlkMFQ0bFpUbWNv?=
 =?utf-8?B?NGl5RDBvcmZsd0N4S25MbE1lKzkzMlp3bDU1UDljV3FqR1Jub08xRGFsTy9W?=
 =?utf-8?B?MmkrQjdwVitXM056dUk3dlBKRkZaNS84MkF0VEdxNkxYQXdVM01RSnpNM2p3?=
 =?utf-8?B?dU4wVGxDV01ldHpLUHdsMEhzVWVRK0RzUjl2bWEwdE5raVQwS1l5b1U0a011?=
 =?utf-8?B?Q29TMW4vME5MUEx1d0RnbHNJOExRUVh0dUk0MVNVQ2JwZXlJblkvMmluMjNt?=
 =?utf-8?B?QnkzYXZpMjh6MmJ2U0w5NkdRQUJQaDlrWHRhbnZQR296ZVlSeXNscERIdzY1?=
 =?utf-8?B?c3NIY1p3ZG1kNGFTcy9PQkpjZGdOK1lZZk03eG1Oa3I1cUJYcWZJOTZDU25q?=
 =?utf-8?B?Nzk4TG1Lc3NxZjNENE9uVExndXhWbXhPa244R2crZnNHQnBlRHZMZWI5R243?=
 =?utf-8?B?azlwUTJnZVVOS2NkdVlnSWZ5L2M2akZVOHNmQVpOc3BQYUY0OW5MSTZvampl?=
 =?utf-8?B?dUxtSko4ZzV1cGp4MlU0Z3hBN24xTi8zampyTm1BaTZOYko2K2cza0J5QThZ?=
 =?utf-8?B?VzlVSy9MdHllZ3pCMTlWTUxpbVV0ZVBzMXp0aEJmSm1FR3ZIREMwbU82S3Fj?=
 =?utf-8?B?ZnUrL2dlYW8xVEJEdFRiRWZWSUxHUTFoQTFYa2dBcHVFY3hNZXpTYlpmNU5k?=
 =?utf-8?B?TmI2NW11RTU2dXliL0JDVlNEVzNHa25RcDl3dFF4SkxwajFTYmdlTmxiczNM?=
 =?utf-8?B?cUg2SkYvZm5TblFzdi9CRnJoWjNONDNBV3B0djM5RkkvZmFNODhEcXoxa0Jo?=
 =?utf-8?B?T1BuYTNwQS9nUEtCRmV5czZvclBQUTAwY3d2VWtMNjA3dHNTOVNwODgwS21O?=
 =?utf-8?B?Ti9QNm9iNlhIc0NjL0lYNTRiaVh4K0MzQnpRZ2R3cEFuQ1lROTBkQkppQW8v?=
 =?utf-8?B?UFRQY2o3NnFScFJzcTgvbytaZzJ2c21qNHJMOWpmT1R4U2E0VTQ1b2VZdDdz?=
 =?utf-8?B?cHpsN3NlYkxTYTgzb0RsYWNGdjhXa1FtNHIyNzVwMVdaWVkzT1BQZHQ3SzF6?=
 =?utf-8?B?YkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d4b9e6-a502-4f4b-5254-08dab83e8533
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 17:13:09.0125 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpFZcKqtdxujhUHxTTtsa/ab2bAXMwwLKqUxV0bGYjDMqAxjetuDNIbHh6QYWMp7gM4BZVVNKaYNjNgvxreheVybDtywd37NG6LA7XoH6xE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4524
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270096
X-Proofpoint-ORIG-GUID: rDf-ucVrUMDIN176zHZGTlalFUhWoEq_
X-Proofpoint-GUID: rDf-ucVrUMDIN176zHZGTlalFUhWoEq_
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/27/22 12:06 PM, Mike Christie wrote:
> On 10/27/22 10:18 AM, Keith Busch wrote:
>> On Wed, Oct 26, 2022 at 06:19:36PM -0500, Mike Christie wrote:
>>> For Reservation Report support we need to also convert from the NVMe spec
>>> PR type back to the block PR definition. This moves us to an array, so in
>>> the next patch we can add another helper to do the conversion without
>>> having to manage 2 switches.
>>>
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>> ---
>>>  drivers/nvme/host/pr.c | 42 +++++++++++++++++++++++-------------------
>>>  include/linux/nvme.h   |  9 +++++++++
>>>  2 files changed, 32 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
>>> index df7eb2440c67..5c4611d15d9c 100644
>>> --- a/drivers/nvme/host/pr.c
>>> +++ b/drivers/nvme/host/pr.c
>>> @@ -6,24 +6,28 @@
>>>  
>>>  #include "nvme.h"
>>>  
>>> -static char nvme_pr_type(enum pr_type type)
>>> +static const struct {
>>> +	enum nvme_pr_type	nvme_type;
>>> +	enum pr_type		blk_type;
>>> +} nvme_pr_types[] = {
>>> +	{ NVME_PR_WRITE_EXCLUSIVE, PR_WRITE_EXCLUSIVE },
>>> +	{ NVME_PR_EXCLUSIVE_ACCESS, PR_EXCLUSIVE_ACCESS },
>>> +	{ NVME_PR_WRITE_EXCLUSIVE_REG_ONLY, PR_WRITE_EXCLUSIVE_REG_ONLY },
>>> +	{ NVME_PR_EXCLUSIVE_ACCESS_REG_ONLY, PR_EXCLUSIVE_ACCESS_REG_ONLY },
>>> +	{ NVME_PR_WRITE_EXCLUSIVE_ALL_REGS, PR_WRITE_EXCLUSIVE_ALL_REGS },
>>> +	{ NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS, PR_EXCLUSIVE_ACCESS_ALL_REGS },
>>> +};
>>
>> Wouldn't it be easier to use the block type as the array index to avoid
>> the whole looped lookup?
>>
>>   enum nvme_pr_type types[] = {
>> 	.PR_WRITE_EXCLUSIVE = NVME_PR_WRITE_EXCLUSIVE,
>> 	.PR_EXCLUSIVE_ACCESS  = NVME_PR_EXCLUSIVE_ACCESS,
>>         ...
>>   };
> 
> It would be. However,
> 
> 1. I wasn't sure how future proof we wanted it and I might have
> misinterpreted Chaitanya's original review comment. The part of
> the comment about handling "every new nvme_type" made me think that
> we were worried there would be new types in the future. So I thought
> we wanted it to be really generic and be able to handle cases where
> the values could be funky like -1 in the future.
> 
> 2. I also need to go from NVME_PR type to PR type, so we need a
> second array. So we can either have 2 arrays or 1 array and 2
> loops (the next patch in this set added the second loop).
> If we don't care about #1 then I can I see 2 arrays is nicer.

Oh wait there was also a

3. The pr_types come from userspace so if it passes us 10
and we just do:

types[pr_type]

then we would crash due an out of bounds error.

Similarly I thought there could be a bad target that does the
same thing.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

