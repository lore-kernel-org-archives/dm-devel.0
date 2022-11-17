Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 907EAC4332F
	for <dm-devel@archiver.kernel.org>; Fri, 18 Nov 2022 08:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668759592;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=q1pNgikHqohv4tlHWJiBuu4uUSkZ4qnhBhZxWJLxKTI=;
	b=RlMPzSrJ930JMbhK1dn+B00jTH+i/3RCABvypaxSzrESTLC1LpaZvKpLuryvSeYkj0N9ta
	X8cdkVPfZDap7Ta8Ls+gaJqMUjSTyKeTWeMF/PIO7x/csFks9MlMJkcioX31IBG6ZFOP8w
	N70eIFTk9JLNewxP20poTQfA8a0XHDk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-kIjFcCVhPcqBxNw8iwiclg-1; Fri, 18 Nov 2022 03:19:48 -0500
X-MC-Unique: kIjFcCVhPcqBxNw8iwiclg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74FD7802C16;
	Fri, 18 Nov 2022 08:19:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1CC01121325;
	Fri, 18 Nov 2022 08:19:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BBA8919465B7;
	Fri, 18 Nov 2022 08:19:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E60131946595
 for <dm-devel@listman.corp.redhat.com>; Thu, 17 Nov 2022 14:51:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CA76D492B0C; Thu, 17 Nov 2022 14:51:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C1B7D492B04
 for <dm-devel@redhat.com>; Thu, 17 Nov 2022 14:51:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E70D29DD981
 for <dm-devel@redhat.com>; Thu, 17 Nov 2022 14:51:57 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
 [67.231.153.30]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-VeQFJrg1OJeek0sBJD-_aQ-1; Thu, 17 Nov 2022 09:51:55 -0500
X-MC-Unique: VeQFJrg1OJeek0sBJD-_aQ-1
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
 by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 2AHEpBuZ017087; Thu, 17 Nov 2022 06:51:47 -0800
Received: from nam02-sn1-obe.outbound.protection.outlook.com
 (mail-sn1nam02lp2045.outbound.protection.outlook.com [104.47.57.45])
 by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kwq34g03w-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 17 Nov 2022 06:51:47 -0800
Received: from PH0PR15MB5103.namprd15.prod.outlook.com (2603:10b6:510:c0::21)
 by DM6PR15MB3051.namprd15.prod.outlook.com (2603:10b6:5:141::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Thu, 17 Nov
 2022 14:51:40 +0000
Received: from PH0PR15MB5103.namprd15.prod.outlook.com
 ([fe80::b200:202d:12f2:2c27]) by PH0PR15MB5103.namprd15.prod.outlook.com
 ([fe80::b200:202d:12f2:2c27%9]) with mapi id 15.20.5813.020; Thu, 17 Nov 2022
 14:51:40 +0000
Message-ID: <91bba138-8713-eb8a-015c-2bc6ba9b5dc2@meta.com>
Date: Thu, 17 Nov 2022 09:51:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <alpine.LRH.2.21.2211040957470.19553@file01.intranet.prod.int.rdu2.redhat.com>
 <20221117152843.00002f30@linux.intel.com>
From: Jes Sorensen <jsorensen@meta.com>
In-Reply-To: <20221117152843.00002f30@linux.intel.com>
X-ClientProxiedBy: BLAPR03CA0134.namprd03.prod.outlook.com
 (2603:10b6:208:32e::19) To PH0PR15MB5103.namprd15.prod.outlook.com
 (2603:10b6:510:c0::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR15MB5103:EE_|DM6PR15MB3051:EE_
X-MS-Office365-Filtering-Correlation-Id: fd4ece1a-7faf-48c3-30bc-08dac8ab3c2e
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: wksIvE+1VTH6HVVLF+9/5WpztL9SKTOfqoUYZ7N7fIJArVMd9rH6g73jIYMAU85/7wW/KV5RMJC5Y/ivibebeYfhA7rbyrznJd+Bu6THgTWO9Oj38leiiQfvTkg7YRWZPcWQLqReKH47Zu6j4oJ8wB85739fsVjnNapH8oUXHD+jSRb1BUwvLE+Cj/2Tmtk0glZQQ226oxYeTz483ugzg5QJllyCiEHKfd57+lY9Rt3UGmNRZk3XJMR2E4W/PiST9HkXcsRf95Pc4AdIrUqDYI6gGF0SMGFu9WkVxgdfB6fpcGfHpIlghnDgVuZ5jPE+6kmc8dfePpQOI+t9L0ZvKQ9ectXkIpd0GEgeD1WAbcG2Z9ER3mLqh5pImH6QI9tONqBXPqTlLy7Z5lYN0zEBnOVOBprbF9LzVx01Lvl54oLfyZ/48fCArVVkWMmA5r0dQDkXQfB1GjFx/ELKEZTQbz+pIamCdJmmWsmKcx7T4Bn6adjLmSkw4siX3TdBQ4CTfbSF3lTBkaWWYJNih6CXUV9IBCZy7LLgaiFQql8FDhCw1Cy2VlZeYjUxHJ2mse5uE0292ruoGYznj/192QJjsXpWvBc4tbMqcAy0qr53np0NQgtNdYc2pxfzRJpWH2LKGZHDi1jQajmafI2HUUN2AxPmwBhzYcoaMg6PaoWtTv4OznYGc9X6OC56mdNMI5UL9uBjrUR+UcVnaJTUsf7T3PzTV53kooyoEqrEHpKibDszzb27Ai5PvXmEsA10EWxx
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR15MB5103.namprd15.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199015)(38100700002)(83380400001)(86362001)(66946007)(66476007)(5660300002)(4326008)(66556008)(31696002)(8676002)(41300700001)(110136005)(316002)(53546011)(8936002)(2906002)(6512007)(2616005)(6666004)(6486002)(54906003)(6506007)(478600001)(186003)(31686004)(36756003)(84970400001)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emxXTGpjOTVpKzFRRmFYUEM1NW5ZcGVVYXFHcGpYQjVPNU1xZmozNmtoM3ho?=
 =?utf-8?B?MjNoZkRsblVrdi8yVDd5c1lnejdVR1ZnemdNZ01SMUJFdE9VNFM3c1NiU0JX?=
 =?utf-8?B?NXd1a0l4aTBlWG9Ga2RZT09Ib0hHbXZmWlhWdmVSN1FKenlqNzMvZnNaRnA3?=
 =?utf-8?B?TUVWUzNuaDYvUVk2Q3dSWnJoN3l4Q2ZwOXFxUGtsSW1ZT0RlbklramtyOXEy?=
 =?utf-8?B?MjdFT3VLWFQ5MkxZSUlBbitndVJUR3pWZ2ZyVE1DVE1lMFpONW55NklISkUw?=
 =?utf-8?B?Q3lLUkNDczZPMTd4VTJTQmlBQVdtQ0NiQ2h1Q0hSTTFyb1c4QmJCbEdmZFJl?=
 =?utf-8?B?c0gxdlRYNVIyS0t3b1d4SWE1SlQzR0h6VmhEbVFIVERTMUtmSVNZbVZwUVlp?=
 =?utf-8?B?Ti8xZkVSR0NNZGJxVjJYazFxai9DZER0TTliRzZ5b3FGQ3J0T3hEUzFIcG9w?=
 =?utf-8?B?T0RkaWlFbmM4TkpWSEJUTnI5OFEzeEpOVGE2RzI4KzR0a1ZNdTRpbGZiZlNQ?=
 =?utf-8?B?M0FZY0dhWjFWNklKNmR0ZngyN2NYcWpuVC9IWDlMYko4b1QvTCtUN0FBRWZI?=
 =?utf-8?B?QkxqNXVOUUx6RUVhWVZWdDVKL2ZpRmtBTXJjTzArRlhLWlo4L2xmSWtza3p5?=
 =?utf-8?B?SFFNUldvODJsWDYveHdwWkJ4U014WXFCVUdIUGFaVGtMQm5FaGdmajVDWmkz?=
 =?utf-8?B?LzJLUnVYZlhQajJZMk1JZG1mcy80MWdwSm1OUzcvclpLWURRcXJkNnBVZkY5?=
 =?utf-8?B?NVRvaFF0bUxSZWk1WHdaallZY3N3VDNsVDNsakVDdVFEUy94bGFUK3JHcW5k?=
 =?utf-8?B?RXZ2SGxESEJGMlFWdjFMOG9ldWlRSzZNZnA0bkY4aHdyRnFIYWpQbEM0aG8x?=
 =?utf-8?B?dzcrMGJsN3hScFo5WHZFYUI5bTJPS0ticDFpcXBYamZwK3o1TlB4SmYvUjdS?=
 =?utf-8?B?VS9zMWo4UU8zMEppY25TUHBydVdtVWVHZGU2UXRRNHJ3TlZwQ1Rscjl2UTQ3?=
 =?utf-8?B?ZkFFbDdoQ1I5amhVTkN3MTM1SzhlbnZPZlNxeGVuQ1ZTeVBaSGlmRDg1U21T?=
 =?utf-8?B?d2FWdk90VlVTT0VQQVVleWtPek9WMVkzM0Yxbnkxdi96TlFrRXRBYjJ1WU1F?=
 =?utf-8?B?NTJlajhyTWlHRFgyMm1TYmQydUJMaFNhc25BVmxFVHV4bFdXUUlhc2JSb0cr?=
 =?utf-8?B?em1IL2UxZzFTVEk3VTc0TE5ENHNqdGtnWXFWdFNMcU5TZ1B5K0dpTm1XS3lq?=
 =?utf-8?B?dXUrTWZMaXU4QkRqRHdpbGtOR0RPa09pU3pPMzRIN2h5U3VScVUweGhpYXgz?=
 =?utf-8?B?N09PYXh3R0dmaVpmMWNZTTlrVTFzZ1ltOUUrVGNWalhrYTJ0ZDRBT0k5eDJl?=
 =?utf-8?B?SnV3TXduRWVvUUJ6VDJScW9WUVl1ektob2xtWGpxSzdhaVFzcTVjbUVON0V4?=
 =?utf-8?B?MHB5RVFaNytEb01udit1L0J1Z2pqVDdic1pkWHRPZVlSVmtFZzJ2bk1wRE5F?=
 =?utf-8?B?VXJqR3Y5azRxemhIUjNDQXB3UkdJeVB0MjZrY1Z2U24vRkx0VUppblI0bGNN?=
 =?utf-8?B?ZXA3UG9DcnV6eG1qT0lWSUtrbmZoTFYwV2JKVzFoRUZxWTJvZXJ5R2FrVW9k?=
 =?utf-8?B?K05SbzNoUkFUMWFhOXdZM1RPWitKRWNHWW5VMGJjWHlyRWNOYzRTWDdxSjBt?=
 =?utf-8?B?OWRSMXRkN21FWlUxMzZhZ3BPRm9zRG9NQmZySFJKQmNmcGNGbmM3Z0dpRDJh?=
 =?utf-8?B?UUhDQWlOTXVjRXVrcVd6dytqdmxBTlZSejRJSE8zdUd2Ty9sT3VzTTNhV21X?=
 =?utf-8?B?aC9PR25vSXoyak4vZXpsc1NGMUhnVFY5WHhuQkY2anNWanU4K2Mwd2hJcnB6?=
 =?utf-8?B?U1RIWkZCb3ljUFVrRFp4S1NKdXEwQTBUbUxXN0JUSkZkY1VYcFkyMnA0bXFj?=
 =?utf-8?B?Zk9RQTdYeGdVL0s5Z3VaL0Q2azNVbm1HVHlFSG9xcHo2bFExQXBKZ204alI1?=
 =?utf-8?B?bElMK2V6TlMwR0hKZXcwN2FLY3d3QVBwL2huRU85OHVUMFFaaVBwUk1qb0pZ?=
 =?utf-8?B?eWxnaUQ1Ky8yVFVoQVJhMmJ5REp5Szdkb2tpTmU0RTA4TXJJUGJiR0FXKzl1?=
 =?utf-8?B?QVBDZmp0N1RFc3VHYTZMbXFoa2RHMHlEWkpPQ1lLSG8xVTJjczJhaG1kUndV?=
 =?utf-8?B?dWc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd4ece1a-7faf-48c3-30bc-08dac8ab3c2e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5103.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 14:51:40.3468 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Es02O5zJb6173Q2DGGpLV+uHY61uj46fHqzQlUHlBTZzCWMnfF2e6fof3dmNS0qjNMZHlBlqdO9AAqrHXd0mKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3051
X-Proofpoint-ORIG-GUID: b6G08ryf3o08-ibyUS-pPxFbWC8hvmIQ
X-Proofpoint-GUID: b6G08ryf3o08-ibyUS-pPxFbWC8hvmIQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Fri, 18 Nov 2022 08:19:43 +0000
Subject: Re: [dm-devel] [PATCH] mdadm: fix compilation failure on the x32 ABI
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
Cc: Jes Sorensen <jsorensen@fb.com>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Guoqing Jiang <guoqing.jiang@linux.dev>, Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/17/22 09:28, Mariusz Tkaczyk wrote:
> On Fri, 4 Nov 2022 10:01:22 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
>> Hi
>>
>> Here I'm sending a patch for the mdadm utility. It fixes compile failure 
>> on the x32 ABI.
>>
>> Mikulas
>>
>>
>> From: Mikulas Patocka <mpatocka@redhat.com>
>>
>> The x32 ABI has 32-bit long and 64-bit time_t. Consequently, it reports 
>> printf arguments mismatch when attempting to print time using the "%ld" 
>> format specifier.
>>
>> Fix this by converting times to long long and using %lld when printing
>> them.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>
>> ---
>>  monitor.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: mdadm/monitor.c
>> ===================================================================
>> --- mdadm.orig/monitor.c	2022-11-04 14:25:52.000000000 +0100
>> +++ mdadm/monitor.c	2022-11-04 14:28:05.000000000 +0100
>> @@ -449,9 +449,9 @@ static int read_and_act(struct active_ar
>>  	}
>>  
>>  	gettimeofday(&tv, NULL);
>> -	dprintf("(%d): %ld.%06ld state:%s prev:%s action:%s prev: %s
>> start:%llu\n",
>> +	dprintf("(%d): %lld.%06lld state:%s prev:%s action:%s prev: %s
>> start:%llu\n", a->info.container_member,
>> -		tv.tv_sec, tv.tv_usec,
>> +		(long long)tv.tv_sec, (long long)tv.tv_usec,
>>  		array_states[a->curr_state],
>>  		array_states[a->prev_state],
>>  		sync_actions[a->curr_action],
>>
> Hi Mikulas,
> This is just a debug log in mdmon, feel free to remove the time totally.

I second this! :)

Jes


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

