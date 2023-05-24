Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D076FC77B73
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 17:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684948739;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6KkPYFaqYVJt+77Ojv6PJXINxiQ2yByI1AVmABwm244=;
	b=cjJE9AacIlELofykXUggH+SqY20JrYZyh5/WoPucrZ6wMTgkKZyViwbYyzhQgYFP4+huK2
	WFh0X1ZnfBfs+PsZQds9i7/eflh+p5ib2roTgc2s0iRhb/L2o9nPqMB/rbb6qE/4yOHqFk
	AkyDReztq1vJjUaEeQHnrDQv1NQ1Hk4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-lPozG67uOT2gOnMW9Fyldw-1; Wed, 24 May 2023 13:18:56 -0400
X-MC-Unique: lPozG67uOT2gOnMW9Fyldw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 980733C10223;
	Wed, 24 May 2023 17:18:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 314E31121315;
	Wed, 24 May 2023 17:18:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F417D19465A8;
	Wed, 24 May 2023 17:18:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8445919465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 17:18:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 795E9492B0B; Wed, 24 May 2023 17:18:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7040C492B0A
 for <dm-devel@redhat.com>; Wed, 24 May 2023 17:18:46 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 509E0800B2A
 for <dm-devel@redhat.com>; Wed, 24 May 2023 17:18:46 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-ZGGmT48lO4-pLkoL4c4hNA-1; Wed, 24 May 2023 13:18:44 -0400
X-MC-Unique: ZGGmT48lO4-pLkoL4c4hNA-1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="351144282"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; d="scan'208";a="351144282"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 24 May 2023 10:18:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="769531203"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; d="scan'208";a="769531203"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
 by fmsmga008.fm.intel.com with ESMTP; 24 May 2023 10:18:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 10:18:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 10:18:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 10:18:26 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 17:18:23 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::bad1:92a2:fa0a:1850]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::bad1:92a2:fa0a:1850%7]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 17:18:23 +0000
Message-ID: <fce772b2-29e1-7daf-0a61-7e8e78f7331a@intel.com>
Date: Wed, 24 May 2023 10:18:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: Eric Biggers <ebiggers@kernel.org>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-12-chang.seok.bae@intel.com>
 <ZFWY6/VelArVYy1F@gmail.com> <288de217-f0ff-658c-5490-6fbf5f57f5a7@intel.com>
In-Reply-To: <288de217-f0ff-658c-5490-6fbf5f57f5a7@intel.com>
X-ClientProxiedBy: BY5PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:a03:180::36) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|PH0PR11MB5013:EE_
X-MS-Office365-Filtering-Correlation-Id: 393f1cee-0e98-4997-0f5a-08db5c7ae0ea
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: dDbMrULwgrIbAASEWmtW+W9YQ2WqB4Xt21WZ2LqoTiPmNsnnI7q7Wrdwn5/jUruEjBpc6vyjectaeTjbqgW2rCdsk+RK/0SMCUOj6f3jYVU0FK937lDc81SFhVRzsrE0ZGipqLwIOMjHrvz7u0koF0Ac+JMntMVXY3MT4lV0H2ASvIX/0jjJeDr68HKzjrTpmTBDrVcefpCtAh2sGuLsqI7tXc5bWLonQ4gOibxGE3r/Tp9rUqQXFJnbYSywEJmuXeU91IOHkm4TBxLVnJkEiFk49Rtys1Oibdc/+BBD/Bw0HYjr5AmAZwgzgLN2wf5EX1fKtVHVK5NqRfdsbpjJmTH+p9zX7TW9uQwreylVrqZgkydmpvMVs6Ss+8an3Xh/E1IBqCbw4eNPb8x8Nm7j/PE/KZByvdJjG1EuBjhvCBPlMGKATTWOLI9bCKjgVdVLsmvAZToi4AJiWzvvvFE/Wbw/Oh6RMpIYmKzkpLZqSKsMBxw3y2gAclPaPcA/7xqCUzxoqx7zvKq5bBMaEHSQbV6F7Uem0VbmfReHBfcG02j36OJjX5zcRly8J+zjvzz14V/4nbKw/7cLoYraKTQMS4eh1WiL6mPtBvMreKb0xgX9sBlI4Xz2047cRIJBZpGkGPUPJ2ryWfSVm2ssAIC+Ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199021)(66556008)(8936002)(5660300002)(54906003)(83380400001)(53546011)(31696002)(6512007)(6506007)(86362001)(26005)(186003)(82960400001)(2616005)(38100700002)(8676002)(478600001)(6486002)(66476007)(6916009)(316002)(36756003)(4326008)(41300700001)(7416002)(2906002)(4744005)(66946007)(31686004)(45980500001)(43740500002);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3FkN1p3alBzSHVidVpqQmJ0Z2J2eDBNOWJ6SlJJU2c1c1MrR2dtRDIyd1JL?=
 =?utf-8?B?d2xYdFI2aXRkR2RvdjZmay9VcVphay9FYU01d2t1UzFBNjk0OXBtS3Y5YkdG?=
 =?utf-8?B?YkNFakUyclZrT2g5MENLWnVOMHNJY1M0eGJMOVJsYjd2aDVMTHVwM3U5NDN6?=
 =?utf-8?B?M2Zwd2htb1dSUExoN1o5RFZtQlBQdmQ1RnlEY1pucXFLUGdKRTlTTmlmMk1H?=
 =?utf-8?B?VFprQ21ISW5uanRieFdJNTdkeFpyV25oWWhHSnVkQXZUYUlrMUdXYVdFU1VP?=
 =?utf-8?B?WHVYTi9jd1YzSVVzYyt1bk9PMDlBaXMxQ2xMM2k1ZXlqSGxGZ2p1MCtqeXFP?=
 =?utf-8?B?aWJoRkRVSERBeWVtN0E2cE9ZdTNuU093Z2VwdWhBVmRDNFJUclV5dDVpR2xJ?=
 =?utf-8?B?NGpjejBFQ2pxRHJpbnhKanQ2Tm4wZFdSdHNzaVZGZDltL1REMnhvZTFNTFp3?=
 =?utf-8?B?ZzUvN3VKT3htbUE4eTNBUVJpRHdySkd3S1FCalRuZzVYSW1qanNYVE5qMUo3?=
 =?utf-8?B?Rkk2Z1NOc2RuL1ZoMjZ2dFBRMnozVm9ieHB4QThYTkdOZUorYUtDcmpXSnJu?=
 =?utf-8?B?citTdUpVUmg4dXRpblJrZlcwMmNqaVpEcysydjE4RGpxRnMrN2dnSDIzVHM0?=
 =?utf-8?B?RDR2VGRJUlc5Mjh1bXVMQTRualB3Z3FxWC9ZbEwrc1hwR2F0N2lORlVBajhj?=
 =?utf-8?B?UzZRNUZlalRmMDNFUW9RNHJFSWJ1VE53d3ZvcEp4RWNyWE5qclBXVjBNQ0tI?=
 =?utf-8?B?aENUeU40MUpIYlBITXhHaEgrbVV3QVhMSDJZRmlJTGNhRk4xaU9oRjlUdDZQ?=
 =?utf-8?B?dzNpWFZmK3lkQnlJcUdkVlQvRHBTa1R5ZDU0NnZsWkt5Q25YaUhEMURxZjZV?=
 =?utf-8?B?RzB2U09PT0p1TVhUU2VlQnIvbklYMVNLaFBWS1RHSGhRUXJ6a0UybEtTS3g3?=
 =?utf-8?B?YTZ2Y3ZZUE5XVTFralJvQ0t4ZnpFREpaSXpkTTd3dk43eEEyZE13K3RSR0pQ?=
 =?utf-8?B?bG01NzRuWmVJQ1RWR3RQbmdhcHpSeGtSc2dUdDdyb2o1cStONEhHZXdJTkc1?=
 =?utf-8?B?ejNhck1QaWJSYmhSdUpDSXFtenNsQ2Fsd2laVFNRQm9yMG1nZXFRSEVwR3pr?=
 =?utf-8?B?Z2FLeXhQanlTZGJQNU9INHZMeElvSnduTVNHblNpMlJyYTg5d0hFQ2FLVDVT?=
 =?utf-8?B?NVNka2JpMXN3RXVBVzdaaGpOYnlxTE5Ea0tFeDJFZWd4RzNHb2xxUEl0Y3JL?=
 =?utf-8?B?cDVwUFZ4a3g3bWtYQ2VtWDNMTWg3YXhTYmM3MUxaalhpK2p6S3JqOVhnb2xr?=
 =?utf-8?B?R1NVZUEra3ZzcUEvWExwU25VcEY3WHEycXJ3N0ZhMzFLeW5IU0NVSnEwTWVG?=
 =?utf-8?B?MC84R0wvdUVHZUhqQUJSYlZoT2pOelhzZEN2b1FGdnZXQjVaT2xFcEFodXlr?=
 =?utf-8?B?QTAyKzZ4K3NwbGlGOWFFSW5GWXg1Qm40K25yTmcxeUVnQUtaMHlNY0pRTllG?=
 =?utf-8?B?bHVzbXRmNmMrS0F5RTk2Ulg4eTI0OUVQTm1sQ1E2RWdEYm5LdURNbTVYZ2Fl?=
 =?utf-8?B?SkZ6MVJXdllLVnRzdUxjN0IySEpzVTZsQ2dVd1EvOGFNSlRCckhjUnp6a2Vt?=
 =?utf-8?B?TnpHKzZBVEF2SkhNcEVoOUVTc1dkRmF5VHNMVFE5dTNBZlJoS0JrWEp1SFZP?=
 =?utf-8?B?K0lXWXNoNWFIV01ydHN5Y3dCVDRLc29HdmR6dTUyWFBVSUJtUXhDbExkcCtD?=
 =?utf-8?B?N0VqU0xjWTh1WlBHVGlSU3F3d000TnpKWEpjd1hqdEtXeUZQb3hCb05McllO?=
 =?utf-8?B?OHpTWG9JVVRCSjdmMC9rYmowNitFQU9xall3SVMzQUpOMHJUNFpMSHg5d2RT?=
 =?utf-8?B?OHpTbXFjcFZFZ012OGQxSmRMTHlpUUQ4Y3pITEtIOW1oblZFQUs2ZXBNd1p5?=
 =?utf-8?B?MVorUGpmckZrTURnTGduUXM0WUNOemU4bjJKOFFGRURHeXNabTY4d2JjT2x1?=
 =?utf-8?B?RGgxVnBjZ1pNRXRjaVYwdzBwcVoxWXlYekhjVFVHTXVzZDA3cmhPQnQxMGJH?=
 =?utf-8?B?MndsSytLZjNZMlVYSXRwcnJXWDl6aDNhbUZoRnp0ZnI1Nno0ZGN6MFZOVWl5?=
 =?utf-8?B?SXJCU3lrRGlTWmF3QXNib0RqKzlDWXlPUzRLQkRYVEhrTk5Kc2tPQVcrQ1dm?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 393f1cee-0e98-4997-0f5a-08db5c7ae0ea
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 17:18:23.4338 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZZmXvfs2R4qSq+Q4WK2PEkOrSz+A1/oarfpSDX+9likOBMs9PD/frH7DF13NLtU9SKeTdQbGzPUZXDHeV8b8qEXVJVAyxxSzcBpApEDInI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5013
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v6 11/12] crypto: x86/aes-kl - Support AES
 algorithm using Key Locker instructions
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
Cc: Tom Rix <trix@redhat.com>, dave.hansen@linux.intel.com,
 lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 "H. Peter Anvin" <hpa@zytor.com>, ardb@kernel.org, herbert@gondor.apana.org.au,
 x86@kernel.org, mingo@kernel.org, Ingo Molnar <mingo@redhat.com>, bp@suse.de,
 gmazyland@gmail.com, Nathan
 Chancellor <nathan@kernel.org>, Borislav Petkov <bp@alien8.de>, luto@kernel.org,
 dan.j.williams@intel.com, charishma1.gairuboyina@intel.com,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, linux-crypto@vger.kernel.org, bernie.keany@intel.com,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/8/2023 11:18 AM, Chang S. Bae wrote:
> 
> I thought this is something benign to stay here. But, yes, I agree that 
> it is better to simplify the code.

After staring at this a bit, I realized that at least the feature flag 
check needs to stay there. This can populate a proper error code when 
the feature abruptly gets disabled (most likely due to the backup failure).

Thanks,
Chang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

