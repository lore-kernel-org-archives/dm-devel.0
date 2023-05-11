Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51E6EC7EE22
	for <dm-devel@archiver.kernel.org>; Thu, 11 May 2023 23:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683847228;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nR0kfGvyQGUFLlYlMVflNxvnnhnytBTwd5y/cCweOKw=;
	b=eg5sNAQXLJ+DgDk4gJFMYnM3tOJGzLOglArGtrXcThETzCPu2r3nU2stU54Efb7ZGQ0h/n
	yFDaCbgPxX72rqmQWnhzNYwJ0hSOMNOEiq85IdgFylarZ5xkTdqT3+AER5D0p78P3sjHcV
	dAoByp3BcGWk8cvl4uGjDbaUuNTatSY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-dhwyMaKRNTGNW5WWS4XuNw-1; Thu, 11 May 2023 19:20:24 -0400
X-MC-Unique: dhwyMaKRNTGNW5WWS4XuNw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B939C85A5B1;
	Thu, 11 May 2023 23:20:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CCE9A492B07;
	Thu, 11 May 2023 23:20:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8209A19451E4;
	Thu, 11 May 2023 23:20:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B1CD019451E3
 for <dm-devel@listman.corp.redhat.com>; Thu, 11 May 2023 23:20:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6720148FB11; Thu, 11 May 2023 23:20:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E91A492B00
 for <dm-devel@redhat.com>; Thu, 11 May 2023 23:20:18 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 265DA1C05AA7
 for <dm-devel@redhat.com>; Thu, 11 May 2023 23:20:18 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-jTwCwXZaNvKcHHGx_Q5Zyg-1; Thu, 11 May 2023 19:20:14 -0400
X-MC-Unique: jTwCwXZaNvKcHHGx_Q5Zyg-1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="416278868"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; d="scan'208";a="416278868"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 11 May 2023 16:20:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="769568653"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; d="scan'208";a="769568653"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
 by fmsmga004.fm.intel.com with ESMTP; 11 May 2023 16:20:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 16:20:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 16:20:11 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 16:20:10 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by SA0PR11MB4733.namprd11.prod.outlook.com (2603:10b6:806:9a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 23:19:44 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::cfb2:e73:907d:cb77]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::cfb2:e73:907d:cb77%5]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 23:19:44 +0000
Message-ID: <76fb5763-c765-b3cf-9eec-1ac344cf49a9@intel.com>
Date: Thu, 11 May 2023 16:19:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Eric Biggers <ebiggers@kernel.org>
References: <08da7a0a-6b66-2c0e-eb56-96b5ee8faa30@intel.com>
 <20230511190517.10149-1-chang.seok.bae@intel.com>
 <20230511213948.GA838@quark.localdomain>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20230511213948.GA838@quark.localdomain>
X-ClientProxiedBy: SJ0PR03CA0220.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::15) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|SA0PR11MB4733:EE_
X-MS-Office365-Filtering-Correlation-Id: eaa752b0-72c9-48d8-8a92-08db52763417
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 880stWe/nHrHxoQ0WkHwLcyHi6Qqj2g+fvl/XDBREvbbqNEti70lwPtlUSrkmfvK7wsD0VB40STOFIHg6QMD8E+Ywmfvw5nCE1ukYECb6ntSt6Ui+m7sOZUndoWrc922pb0ThORLI9ZsoVCbW6N0SBHC7iYA28FUz2gmBgvPPkYwpPv7hCwAICL7wak292erKQCnUdc7/AX2Y7H97n0tS0sNTrM/vsJG9XDsf/NI1z8v2wyql8V3yyJ1FxJmEBjiV2Gld5SUFB0vaWePlhumTeApdAMZyHDZqETRDMU3ctfyDqrQdF0mEZldxxIlsxf/2YanyRQW3zkL3nvgfCz5YDBjgvwv/NYNzkASmeNKRwkSp7GiVlGKUe8QpQs0hMGZMDBgUI7z9FGQXKs+QgWVJgYZeVGWHsu0RNNVNhMUaKL/wqf/CATCiOz5LAalNE2uU2pDUFW8z3/dpROmo6J17Gy53EUCM2EiUlo6XdH5EiVeqA5H/DgG25fVSXhtWSfCYn4GVRoxFtTafB4vnMEY9b2t2PUzK4Q66tvPSgcqY5idIJ+PO0ccaVMA/U7pcjEbyIhL2caY6Ttlu6BP+G1gx8OMpGnPjO1W2xAd46BBgVlbErCeX/Hi+u0bbdcn7XwLv5HVEPrfC/ntUBh6t/0xCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199021)(31686004)(66899021)(83380400001)(2616005)(4326008)(82960400001)(41300700001)(38100700002)(6916009)(8676002)(316002)(8936002)(6506007)(36756003)(5660300002)(26005)(6512007)(478600001)(86362001)(66946007)(66476007)(66556008)(186003)(31696002)(2906002)(7416002)(54906003)(53546011)(6666004)(6486002)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QS9aQlNjdjFuUHFjb0dYSU1OV1dxaFBCeHBOYTdldjdGUjNUQ0dXSDVvUE5K?=
 =?utf-8?B?WVBGYUpQUzlienVSeTYyYkJhZzcwTzJML2lYSG1keVNNaTd4eitGeGsyWHll?=
 =?utf-8?B?YzFkRDdIRlRTWm8xZmxiaGhhbnY0a0J4OCs4VVJ5clpEamhWdHJQNitzVG82?=
 =?utf-8?B?Ymhtc1hLdGlvTGx6dG9PbnNTbWEwdGdrbFBia1BGSE55dHZYZW5xOTJST2xB?=
 =?utf-8?B?azNHL0YvMmF0VFIyQXcwWVQ1Ukp2WkQ3ckNrZERLbG9paXU4QXBoblZMWXFw?=
 =?utf-8?B?Vy9jQUVudkltOXhuZDZkQjdHU1RscGdBczU3MXVjbU04OE4zVU1Hb3Y1UWVK?=
 =?utf-8?B?MDJVM2tkYXRhU1BidEQ1TzIvZXd0RDMyVnRPZXlIUndpdFRxbnZNd3VjQkFO?=
 =?utf-8?B?d3E5b0FyNmlCRzVRT2JWUlRZZEVaTFlubmFrSlRTK1JuRllwRTh4Tm5jVGRv?=
 =?utf-8?B?T25LS1RPaEx4QlZDUmZmdkVjdk02d1Awcld3czhWUVdYUlZYMmNUY3dnWkRS?=
 =?utf-8?B?UkpFK2p5c3NFNnRYSWl4dXZVWGgxZkNOVjg4a2J4RlBsWm1WeGQxbnRGTU1t?=
 =?utf-8?B?eUVWNUtzU1MvazZ4d1B3blI2NGN3Z2NxczFPak9mck9TeUc4SHFVTy83cXlt?=
 =?utf-8?B?ZTE4L2V4aU5PRk9GUUk3bGM5dDY3c2w4bEg0VXZ4VU1yK1lmbk1lM1JFTnZK?=
 =?utf-8?B?VzRJenJMQVJHempxaXg0VHo5K1lzV2VQQmtUV1IyWmpFN2pCMUpqWWVTU21x?=
 =?utf-8?B?MnNmODVkWEtsTmxBcG04SWd5c0l5SjN2bWF6WkI2NXdaam0vbXNROE5CVG91?=
 =?utf-8?B?ZEM2RFNGSWhuRTZKYWNRS3IxK2tXdXRMNjZld0ZnVHdlS0RyTUFYTnRzUVBQ?=
 =?utf-8?B?TjBTOElQWENrUmNuMDc0UzU1OEwyNHM0MmxFdEdmbWtwMkJ4dzhDQUJicFl2?=
 =?utf-8?B?OHlNcm41d1RtSVNPckU5R0RuQ0JVak82bHRjNUpNUHhhZmZkNnRJU3Bhd3ZD?=
 =?utf-8?B?ZGhOT0hCcDAzd0REMkNDOVR1dzZ6OXlqemxkU3VqWmxRWkdHb1FyekMwMTdp?=
 =?utf-8?B?VHdhcnQxZ2liMWJPWWdxMmF4bDBxMnFMKzZveHQrNG0yUldzWHgrOU5zOTJK?=
 =?utf-8?B?S1BWK2h3UVQ5bnp0aHA5TjRwVDNNWmRWVW5wOW92VjlFa201QUdqVEVaeG53?=
 =?utf-8?B?VS9mWmF1YzRHK2FLWVNycFZkbGhKNW1aUjVyY3d4VTZYZ3JYeWNUSmkzcE5L?=
 =?utf-8?B?NWZHeS9WQnJHWjZBV2RwM2NYM051K2FSNmN3aEpuYWszQmRqZkQrRzM5TC8w?=
 =?utf-8?B?MG9Ndm9PWEdTTTRzQzMwNmdJbVp5eXl6RGNMSC9vQkM2ZTcvSjVydjU5aW5x?=
 =?utf-8?B?SysvdVgveXN3R0t3djk1RkdvN0hPY2dsak1BSTR1WkREL3d4eFh1Z3dObklV?=
 =?utf-8?B?S0FFZ0FyNHlDY3VITjNZOXF2SlBoWmZLekc1cjIybW54QXhvSkhpVW1FTUpP?=
 =?utf-8?B?VFUrTS96NlMvOWYrNXRWU0pxc3Q1c1ZMVzZOcnlnc3BsYzJoVUUxTTIxOU9m?=
 =?utf-8?B?U1J1ZmV3QXQ1d2lJUVpxTVl4U2tweDFyZWh0MHFWQ3dubUNKZnkwMjMraXRN?=
 =?utf-8?B?YTJyVGpFZWNranF5WGdVSVFHQjluTUFYZTZ0cGRLNjJUcXREYXFoS3A2Ukww?=
 =?utf-8?B?UmFOVUxiVS9ydjFjVkplT2JEVEtFNzJvWTJCbWF3TTZqQ2NmVVd3bHR1dlNU?=
 =?utf-8?B?WjR0eVRjTWJZV3ZMSElZYkFNM1Mrd0pwZmN5SE5zZDVZNW5FOEU0S0UyYkpv?=
 =?utf-8?B?UkZiLzdrSFBVSzg0WVNPTithM29NaS9RZFNrdi9QaDdONXlhVzhzSGlWaXZV?=
 =?utf-8?B?MDc0OVFoenZxa0s1WlpuT29nV09VeTZ4ZUFkODVTRXIxSm5FK1dYMTdrQUdu?=
 =?utf-8?B?UGswQUFMc014SDJWU2xtbEJnRmw4YmFOcWpjQndybkVtK0tKc2Z5NnM5N0k1?=
 =?utf-8?B?TkVLbVB4MnJSMEtrakV0UUlVU1N4T0RFRlBSemsvR093YnROL2xna1ljbDZJ?=
 =?utf-8?B?ZjgwUTMxb2FmaUEyWjB1a1l0NkhVM1NZajJHNWtjMG1Ua0tEYXI2M3BCUFJr?=
 =?utf-8?B?bjdBQWZJWmYrU0ttYzN5NDlIMUswWHExS01ONGlXVmdGZXQxc0FhZ2laMWRv?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eaa752b0-72c9-48d8-8a92-08db52763417
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 23:19:43.9083 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: slQd/2qIOD06BWRUx2ePTkaPED//lWq3VC8gmCdcUqEla/JGe1eV+13UojHCCPGhKJYuz/I68OZNf7NFg0aDWBbewkfWntWtOut0v2tGhyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4733
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v6 10/12] crypto: x86/aes - Prepare for a new
 AES implementation
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
Cc: x86@kernel.org, herbert@gondor.apana.org.au,
 "David S. Miller" <davem@davemloft.net>, ardb@kernel.org,
 dave.hansen@linux.intel.com, dan.j.williams@intel.com,
 linux-kernel@vger.kernel.org, mingo@kernel.org,
 lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 Ingo Molnar <mingo@redhat.com>, bp@alien8.de, linux-crypto@vger.kernel.org,
 luto@kernel.org, "H.
 Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com, tglx@linutronix.de,
 gmazyland@gmail.com, charishma1.gairuboyina@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/11/2023 2:39 PM, Eric Biggers wrote:
> On Thu, May 11, 2023 at 12:05:17PM -0700, Chang S. Bae wrote:
>> +
>> +struct aes_xts_ctx {
>> +	struct crypto_aes_ctx tweak_ctx AES_ALIGN_ATTR;
>> +	struct crypto_aes_ctx crypt_ctx AES_ALIGN_ATTR;
>> +};
>> +
>> +static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
>> +{
>> +	unsigned long addr = (unsigned long)raw_ctx;
>> +	unsigned long align = AES_ALIGN;
>> +
>> +	if (align <= crypto_tfm_ctx_alignment())
>> +		align = 1;
>> +
>> +	return (struct crypto_aes_ctx *)ALIGN(addr, align);
>> +}
> 
> It seems you took my suggestion to fix the definition of struct aes_xts_ctx, but
> you didn't make the corresponding change to the runtime alignment code.  

Sigh. This particular change was unintentionally leaked here from my WIP 
code. Yes, I'm aware of your comment:

 > The runtime alignment to a 16-byte boundary should happen when 
translating the
 > raw crypto_skcipher_ctx() into the pointer to the aes_xts_ctx.  It 
should not
 > happen when accessing each individual field in the aes_xts_ctx.

> There should be a helper function aes_xts_ctx() that is used like:
> 
>      struct aes_xts_ctx *ctx = aes_xts_ctx(tfm);
> 
> It would do the runtime alignment.  Then, aes_ctx() should be removed.

Yes, I could think of some changes like the one below. I guess the aeskl 
code can live with it. The aesni glue code still wants aes_cts() as it 
deals with other modes. Then, that can be left there as it is.

diff --git a/arch/x86/crypto/aes-intel_glue.h 
b/arch/x86/crypto/aes-intel_glue.h
index 5877d0988e36..b22de77594fe 100644
--- a/arch/x86/crypto/aes-intel_glue.h
+++ b/arch/x86/crypto/aes-intel_glue.h
@@ -31,15 +31,15 @@ struct aes_xts_ctx {
         struct crypto_aes_ctx crypt_ctx AES_ALIGN_ATTR;
  };

-static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
+static inline struct aes_xts_ctx *aes_xts_ctx(struct crypto_skcipher *tfm)
  {
-       unsigned long addr = (unsigned long)raw_ctx;
+       unsigned long addr = (unsigned long)crypto_skcipher_ctx(tfm);
         unsigned long align = AES_ALIGN;

         if (align <= crypto_tfm_ctx_alignment())
                 align = 1;

-       return (struct crypto_aes_ctx *)ALIGN(addr, align);
+       return (struct aes_xts_ctx *)ALIGN(addr, align);
  }

  static inline int
@@ -47,7 +47,7 @@ xts_setkey_common(struct crypto_skcipher *tfm, const 
u8 *key, unsigned int keyle
                   int (*fn)(struct crypto_tfm *tfm, void *ctx, const u8 
*in_key,
                             unsigned int key_len))
  {
-       struct aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+       struct aes_xts_ctx *ctx = aes_xts_ctx(tfm);
         int err;

         err = xts_verify_key(tfm, key, keylen);
@@ -72,7 +72,7 @@ xts_crypt_common(struct skcipher_request *req,
                  int (*crypt1_fn)(const void *ctx, u8 *out, const u8 *in))
  {
         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-       struct aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+       struct aes_xts_ctx *ctx = aes_xts_ctx(tfm);
         int tail = req->cryptlen % AES_BLOCK_SIZE;
         struct skcipher_request subreq;
         struct skcipher_walk walk;
@@ -108,7 +108,7 @@ xts_crypt_common(struct skcipher_request *req,
         kernel_fpu_begin();

         /* calculate first value of T */
-       err = crypt1_fn(aes_ctx(&ctx->tweak_ctx), walk.iv, walk.iv);
+       err = crypt1_fn(&ctx->tweak_ctx, walk.iv, walk.iv);
         if (err) {
                 kernel_fpu_end();
                 return err;
@@ -120,7 +120,7 @@ xts_crypt_common(struct skcipher_request *req,
                 if (nbytes < walk.total)
                         nbytes &= ~(AES_BLOCK_SIZE - 1);

-               err = crypt_fn(aes_ctx(&ctx->crypt_ctx), 
walk.dst.virt.addr, walk.src.virt.addr,
+               err = crypt_fn(&ctx->crypt_ctx, walk.dst.virt.addr, 
walk.src.virt.addr,
                                nbytes, walk.iv);
                 kernel_fpu_end();
                 if (err)
@@ -148,7 +148,7 @@ xts_crypt_common(struct skcipher_request *req,
                         return err;

                 kernel_fpu_begin();
-               err = crypt_fn(aes_ctx(&ctx->crypt_ctx), 
walk.dst.virt.addr, walk.src.virt.addr,
+               err = crypt_fn(&ctx->crypt_ctx, walk.dst.virt.addr, 
walk.src.virt.addr,
                                walk.nbytes, walk.iv);
                 kernel_fpu_end();
                 if (err)

Thanks,
Chang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

