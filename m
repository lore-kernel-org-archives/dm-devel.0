Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55B4AC38A02
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198359;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aENcMqwECFNwemdLUHT3vVWTP0RZ1q2G7AdI6vHgOCU=;
	b=FyRs63aALPPbfOExtcDLAOsxBrUb7RUFINZYkwvM5h+CysInZW391rO9HGxKBddKdzXTML
	NCzMgc1TUbRFfyqzp+0sGKX04b2anWS+FhVe2Wo+vCksKip17g8lbd9ALameUZ1v8gX3UF
	UoiB6RwY+x7hiiOa9YQejnpu+YadAQk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-uJeork1gPvWLVuOr8xi_6Q-1; Mon, 31 Oct 2022 02:39:00 -0400
X-MC-Unique: uJeork1gPvWLVuOr8xi_6Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 550B4101036E;
	Mon, 31 Oct 2022 06:38:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4398B207B344;
	Mon, 31 Oct 2022 06:38:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2910E194658F;
	Mon, 31 Oct 2022 06:38:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 779C51946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 28 Oct 2022 16:06:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 498E440C958D; Fri, 28 Oct 2022 16:06:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 40DFC40C6EC3
 for <dm-devel@redhat.com>; Fri, 28 Oct 2022 16:06:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EEBE85A59D
 for <dm-devel@redhat.com>; Fri, 28 Oct 2022 16:06:47 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-sFb12W9fOISztVLcJh_4iA-1; Fri, 28 Oct 2022 12:06:44 -0400
X-MC-Unique: sFb12W9fOISztVLcJh_4iA-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SEgNPd011144;
 Fri, 28 Oct 2022 16:06:33 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahedspt-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 28 Oct 2022 16:06:33 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29SEv67k017633; Fri, 28 Oct 2022 16:06:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kfaghq8kf-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 28 Oct 2022 16:06:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB4272.namprd10.prod.outlook.com (2603:10b6:208:1dc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 16:06:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 16:06:30 +0000
Message-ID: <370e66bd-81d0-5451-850e-50a4172ed64f@oracle.com>
Date: Fri, 28 Oct 2022 11:06:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
To: Keith Busch <kbusch@kernel.org>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-9-michael.christie@oracle.com>
 <Y1q6so/3Hx9GZmTz@kbusch-mbp.dhcp.thefacebook.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <Y1q6so/3Hx9GZmTz@kbusch-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: CH2PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:610:20::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN2PR10MB4272:EE_
X-MS-Office365-Filtering-Correlation-Id: 125cdb2f-26e4-46b7-280a-08dab8fe6090
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: zyPv/XsAv/XB9Nr+PO3sf3mROBuw/S6SXz8DsC/LjRgV6k1usXHUjnPoMBc7G/lvRrtFu/10vnQZ6YL2pi+Vde7x2zFg4gazhEUNrgY8ExT+uJ6ah8oZO7odTQg/BUGM5MLCkOToTbv1EXUasuwwo2yI/tWcKoF8Q/+08339fNniefqFEPg9AH9Rr2PhKqUYN1mdzDRyAQMVoxzRD7XnCaJJCQzrdCS+E8mu9xXvezkEiiBAeTDZhbS2KAlD/ALyyvHLe1V+muoThWg98rd0dw9tkUGrrvtIhAKFkGxZLkanURmunp+KpIAaC38CkS4XdPDmghXA6thrPpb76MJadaXL2UB+uMBESgEu6gaOmWT8mK/ks7LZxz6lAK2MZC01u6vJvt5ks1edMOSW7QJNmou0BeFYHRA5XmQjHtWvzlD05/+/egvkTMge8afyqOypK7Za8bhSKsQ9ymm4rHCEkFZ41/RBRXQ9/Qbme4DR4Pbp3QC/Ft0Vx/J39XPYYeTwX7tp7zE5go0F7089NtWBDPylPQeAWV5bF/DcHxadmG7RRYmW1hQ1b7RhqUpwmg2r4VVcF4jJXJlL34AXIUoEIpysibajuYSnRzeDUgdjEj+bVB3QI7sIlz9NXy4cYxkx5cIwuXEmU/xT0dUkfz0mcrk3cuxx7Y9POY4ZP2DtTM5NrTtRKQ++Q3L11WRkRkjYw+IgQgomYIXqyLN4vgyDRG8/6c7BMy/0+5I0e38dAJhvydhL5y9zy/ApVPe1HLq0UyEWaz0Q6zaqxtCJmeajirKdWxJa3jtwTctmeMuOdA4=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199015)(31686004)(36756003)(4744005)(7416002)(5660300002)(2906002)(38100700002)(86362001)(31696002)(2616005)(186003)(6512007)(53546011)(26005)(6486002)(478600001)(316002)(6916009)(41300700001)(8936002)(66946007)(4326008)(8676002)(66476007)(66556008)(6506007)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVpSR2sxQjdnU20vSEZnKyttMlFmcTUzUkdwSDhWcVpyQkhQWXUyTkZKTmNw?=
 =?utf-8?B?Rnk3TDRqM29PNDhHSXRPVFIzeGVzVExoL1cvS3VoRzFBcnd1aXh0SmM3Wlds?=
 =?utf-8?B?SzBxNlVJbC91S1lFa1JMZzN0NUxWY0NpY2JIQkd3REtGKzdnVU9kc2RhZkxM?=
 =?utf-8?B?a1EwWXNqaUE4QnRRN1pta0JJOXhFSkRrdHd5R3JHK3VHOHVmUFlQUEpTZG1O?=
 =?utf-8?B?bVVqc1Y1Y1FKUEtlcDlUdHdydHRlYTd4QTZ0YzlZWHJwcmJBaHJHM0dJcUZI?=
 =?utf-8?B?M2svK1NYM1lZNnhyUkM1YkFpRy81Q2NtY1F3SERrZnZhL0drelkzZUNoU2Nm?=
 =?utf-8?B?TUI1NzZ6S0J2TUs2YVhDOGZibjhRQ0ZzUVZkZk1WSG55TkN4dU1SdVpabW1M?=
 =?utf-8?B?alZQTW80TlVvUVVTczJOMnZ3L2kxSUh1a1FUc0Z0YzFGaVZiZEFKY2tYVXA2?=
 =?utf-8?B?bEdDNFJtYUg4L3N0Zy96bmVxanZEWXVBUlpsMU9peEZDYXhJek1iNCtmcVp0?=
 =?utf-8?B?NkVIN0R1ZnptRHJnN2daWGxOSmIyOExPWU9NMlI5UDZzUGl5ZnUxaDhHU2Fp?=
 =?utf-8?B?c1EyNjFpNTVCTzV1dk1hTCtuNEZYMjFOT0RaMTBObFVERzJtLzBSemd0WEtq?=
 =?utf-8?B?ejM1Y2tjcS8rM3MycFJaS05ZTWlqZDFVcW1oV3VmL2wyK2lsOGR6RWcyQVl4?=
 =?utf-8?B?ejh2bnpkZkxNVGRpZGdKVStyeTdNRXpTQUg0V2tEZVVRNGgyOGZqdSsrL2ZF?=
 =?utf-8?B?ZHAyT0kvWm1KOGhUaSt3K25XdTlmMkpuL2Z5YlpXRE5xSDdvY3c0M2hSaFpm?=
 =?utf-8?B?aTJhVFBNc1hlZitINWF4S1ZZNlJ5cFE1NlBicHQ5UWlrR1d1b2FqOHRvejBn?=
 =?utf-8?B?ZE8rSFBlZWNtOVVwcTRKc0owaHdidE4yTTVYQ0VvT3F2cTk0bnFYN3daYWZQ?=
 =?utf-8?B?RmxkbkYyaFVmSGFQdlR2dFVPclJuZUtkUnhqbDM1SThUaEIrVmFtTWh0OWtm?=
 =?utf-8?B?R2JFcnNuY0VCT3BWeWlSeWhkbzlEQWpSNDVJZjcvZFltdEsxbVlpRXJhb1Fh?=
 =?utf-8?B?MHFHSklNd0pBYTE4cVZuTlFTYkVuM2U4S2dwVjRRNS9hWThuMFB1cEY4dnVW?=
 =?utf-8?B?QWMwSVJhYXVyRndWMXJ6OHl1ZXc5dFh0S25UQmc2NTh6USt4cUIrUEk4bXlo?=
 =?utf-8?B?bytSOUdxaGJEOG5pTEw4NXpLYkRDK0xIWStaUUFrYlBRWWN0cVljbEVJMXBI?=
 =?utf-8?B?ZG0zaVZaN3E4MVRHUW5SNzNoWFBvTlJ2cWFZdEFzR1ZSYVVPTVNNcUVVNHpW?=
 =?utf-8?B?all6c01nZnRBdk5jV0ZBSXNuanZGSG9jdFlwV2prRGI2SVJLSWFJVWV1UC8r?=
 =?utf-8?B?OWdBVkcwaS8zazRTL1ZBbTZrMmlNK2ptaEU2d24xc0sxWWJmSEYvTDFhdEps?=
 =?utf-8?B?bkgvTXAxM3gzQU1tUEJWSzFXa0JPM2QrYXpFRHVHeWNDbldGQ2JoTFRLbEJ2?=
 =?utf-8?B?cEhCTnN3Y1R1dHZYY2pIczZxNUJXVjg5MFhsODBkaXlINEFjVFhRSndUbFBP?=
 =?utf-8?B?ZlBQM3RLazhPcEZ6d1pJcjcwblhwNks5YUZoV1IwbU80MWNMaHZMU0QvbFBx?=
 =?utf-8?B?MVZmbWF0M0NrYkRMQjlxZVZ2T2UrRnhSYVgvazNiSWhMNUdOd3J6SnZMbmFn?=
 =?utf-8?B?LzFrMGVRaWtzTk9SY29nRHVrUEszVjhHelhYSzZiWm9jc2NYTmlsbGdNUmlu?=
 =?utf-8?B?L3dCWlBGWkh5YVI1NWQraTVNZVVIdnQycXIvcnQ0cE15Ykg4UExBajNBSGo1?=
 =?utf-8?B?UHBKcUppcWFsSFpXWUhXQnJnM1BIRVRnNDdjaDI5VUF0ZTI1S1NxNnJicy9j?=
 =?utf-8?B?cjJDeC93eWI5QW83QUFTbDZCcEFNWWVCSHhkS0hBRWkyUjdiS1VmM3Zac2x4?=
 =?utf-8?B?eXZkTWVFVHNTRS9QYnJNYy9LZ0tyK1VGVmlEMThrNkhGS285bUNBSkVKKzhH?=
 =?utf-8?B?K0VPL2FJTHQra0REUll6elVnWVptaUFBMUtGK2pkeHFGZ29TSXBMYkhGSUov?=
 =?utf-8?B?NVUvWHFoeWt3elR0blJkemtUaCsvbDM1SzRKQUpUcEdqUzJVWW50bzBFdFdL?=
 =?utf-8?B?RkZkWXVEQUJ3NHNOYlJJaS80S0w2NzY4OVNhdHJ6c1VhWUVoSnMxVHF5Y2Fs?=
 =?utf-8?B?bUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 125cdb2f-26e4-46b7-280a-08dab8fe6090
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 16:06:30.9016 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sLph7N4dnZP85qZG9cDz4afNwiNkroC63W4TL+bMnnTvrHMUq6id1oplO7LxySSI2yBAPFIY5ySIA8HXrvhi2JoarOxxInxT5Q1CWJ7RTwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4272
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280101
X-Proofpoint-GUID: N1nlvLLMKpHmPw-5ZBCnwNaYdgwQ7URQ
X-Proofpoint-ORIG-GUID: N1nlvLLMKpHmPw-5ZBCnwNaYdgwQ7URQ
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: Re: [dm-devel] [PATCH v3 08/19] nvme: Move pr code to it's own file
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/27/22 12:06 PM, Keith Busch wrote:
> On Wed, Oct 26, 2022 at 06:19:34PM -0500, Mike Christie wrote:
>> This patch moves the pr code to it's own file because I'm going to be
>> adding more functions and core.c is getting bigger.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> 
> Good idea.

Credit goes to Chaitanya.

One question for you. I wasn't sure about the copyright. I saw
you added the pr_ops code in 2015 when you were at Intel. Do you
want me to add:

Copyright (c) 2015, Intel Corporation.

to the new pr.c file?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

