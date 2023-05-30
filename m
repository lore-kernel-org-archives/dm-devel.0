Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A69E1C7EE24
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685479823;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GdwO4XWH968H/ogZbOuwVyx9YTom4J1A6ZaRixEIfQM=;
	b=Gi844TdQ2rOiFhvLuPx0Ur2nhK0tN9U4Adfh+3OVvCjBUDeXsf5M4ylP9u/IgWXL7az95n
	IthzpmEBEHfOx4o6KYnucK+bhZKOGRzcFUT8DUA8EnmMz5IdbuyOFC4wRpjttiu6uEjC3q
	IH1ra9LUQEvPGJZSGIvFMawB08PSffI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-IE1NZIHGPo-_Gu0VsRm-qw-1; Tue, 30 May 2023 16:50:21 -0400
X-MC-Unique: IE1NZIHGPo-_Gu0VsRm-qw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9771F811E93;
	Tue, 30 May 2023 20:50:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D8EB6140E955;
	Tue, 30 May 2023 20:50:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A04DC19465A2;
	Tue, 30 May 2023 20:50:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 538631946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:50:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E78BFC154D1; Tue, 30 May 2023 20:50:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DDF0DC15612
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:50:10 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B688C8032FE
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:50:10 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-y0jFM6aKPGuh49BJIGWcDw-1; Tue, 30 May 2023 16:50:08 -0400
X-MC-Unique: y0jFM6aKPGuh49BJIGWcDw-1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="353886398"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; d="scan'208";a="353886398"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 30 May 2023 13:50:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="796420262"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; d="scan'208";a="796420262"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
 by FMSMGA003.fm.intel.com with ESMTP; 30 May 2023 13:50:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 13:50:02 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 13:50:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 13:50:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 13:50:01 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB7168.namprd11.prod.outlook.com (2603:10b6:510:1e9::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 20:49:59 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::bad1:92a2:fa0a:1850]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::bad1:92a2:fa0a:1850%7]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 20:49:59 +0000
Message-ID: <7a45b479-4732-21d8-8fff-64142f86cab0@intel.com>
Date: Tue, 30 May 2023 13:49:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Eric Biggers <ebiggers@kernel.org>
References: <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230524165717.14062-13-chang.seok.bae@intel.com>
 <20230526072301.GC875@sol.localdomain>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20230526072301.GC875@sol.localdomain>
X-ClientProxiedBy: BYAPR07CA0074.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::15) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|PH0PR11MB7168:EE_
X-MS-Office365-Filtering-Correlation-Id: e87eb511-c255-4d96-169b-08db614f6eab
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: YZmAjQW7ayQ+GoceZdU5CcKiK7ge0GXvHilQ/G3HqGMSphe3qNqer00kdAS1xbVKe886c/C4qc23phJiaOOuD5fBv7KF2B/FXltH16eRtTpqcr5s8MGWwzxLZTETtnLFakPqatzkEitzfbcsBRkZTAiCByUQ11H7SNBSTeyagoazaxxQOtBQF3sh40OGdiYrlWXpctCT6nj4U61ItlZv5dOgWZ7jAgnStv6U1H0iU7eXBeJsQFgNIZkqRXk7HV4iyH+NAuK6fa3GBfBuh4DNkdWm1fFLh/qyXZSnb3k0E6u+bH1Xbw1DGnQFVNCMmitEzJbLekpLGvRiDn4BBo6pn42FdtDjUj5lH7azpSJcTos8m8CP55/nP+sIBW1fNwtLqF2ooZUR4KdTLCVNqxU5TCXfG3NDHWhrNKuLM+62lfdyLnU1/rNT1GhFQAyBury6kseAXdFxi3Pqs8I7pSTZPFAW0J1NIiD99ZEWWPlpXSxzegyqjPsWb6EtM6+1kTc2TPz6A0bo/Kxtd10ZUZOhw+KAn7CW64hyMitelA0gpN88AAY+VBmnr6vl36vEoFB7Zm7x50B/Gjikx6lD3YXzY5VprdjY4qPf5XpHaCSOX9LaciQNlEFpHoL3jwiek48c0DzQBD9Jn2O2p6+lOf/Zew==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199021)(6486002)(41300700001)(86362001)(6916009)(6666004)(316002)(4326008)(31696002)(966005)(66556008)(66476007)(66946007)(36756003)(2906002)(186003)(2616005)(6512007)(5660300002)(82960400001)(54906003)(8936002)(83380400001)(6506007)(8676002)(53546011)(31686004)(7416002)(26005)(478600001)(38100700002)(45980500001)(43740500002);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVozek51bFpJUkpGb2R1cnJqQlgyQUloN1JMUjBKUVBNQ29pZ1NOQ28xeG5s?=
 =?utf-8?B?dWllTFo5Q3JNanByelpuMGdIdUdyd3BOa3orKzUwb0VvRW9vTUUyajhQVkNl?=
 =?utf-8?B?Qjc1ekZSbno2L3NlU2FEeng4cWZsMkdzb0I1dDNCMy9iclJGOVlseTh5VE1Z?=
 =?utf-8?B?TU8yOFoxbnZpNkhPTnBCNU01U0Y3Ui9hNGtxZks5TTZNdHpxNzFSN1BMWmti?=
 =?utf-8?B?cXlnL3BEK3ovYUJFUGdDNnZ1d3B3SGNualNoVXpqdlBPWGw1TUNZUXZpenl3?=
 =?utf-8?B?WGhxSFFBeVN3SUppSVlSRXQwaW9UUFQ1ZlZPOThZTVZKV1VvY0hvaXd6QXRn?=
 =?utf-8?B?enU4Mk81Vi9QQzNSandpM1NXaE1rOHlkQStiVmFqTWFWWXBuYVM2dXVtK1Jl?=
 =?utf-8?B?QkR0TVpPNFk3aXlTQjQ1SGRlVGN6ZlloTllvUlZVem80K1hoY3Q4UWJaYzZE?=
 =?utf-8?B?eUcyelAydUM2RDI0SEJwcmdUUVZidURBV1VJR3EzYXhDSHYxay9WZ0RXeUtH?=
 =?utf-8?B?OXRSTllkUVFRV2t3WWt3NVoxZDdDYlF3c2hJMHYrOTBsVXVNZFZQQXorRVh5?=
 =?utf-8?B?L1R2NFpTTUErNW9rZjFRaFRWcE53aGJ3dU5pUlFWelpYMXZrMCtwcEFrMlFs?=
 =?utf-8?B?RTU5L0UwWVVPWi9hNXQzNWptbWF0UlFkUERBNUhyVkJKYWJ1K05qeVY0VFdp?=
 =?utf-8?B?c1RRd1dCNWk3RVFCemg1endLbCtHQncwVzArV2laWlArOVJsVXN3QXJCUmhE?=
 =?utf-8?B?RThKWkJBMVkwS0ZOcXlDbDY1Sno2ZG8wVlBCR2xlRUxTRGtoUlA5SkVrcksv?=
 =?utf-8?B?K3FZeE81SnRRTkp4WW45K0FBbXRHMFRVUFA5dENlZUcwMm80V3M1YTdybDJD?=
 =?utf-8?B?ZVA1dm5vL0plQThvUnhabTdFL0I1ZGdlQVh3WHdtaVV1K2lIY3dEK0RCanBy?=
 =?utf-8?B?TXpZckZaUVZUL1p3amt6NjhhbFpXR0lwZnRmVUkwakZ6MjB3SERjVEpRMGhG?=
 =?utf-8?B?cnpJZ2txcUNSa2dCajlOcjFaSnFUTytXMnYxUDVUWVpBcnRNQytlT3RWVDE3?=
 =?utf-8?B?S1JmMlJnRmRWVXpSazNCeTFZU1dxbHNxdkdqTEdINjlMZTUrSDZJYUkvZ0cy?=
 =?utf-8?B?Nm5IWnFrOEg4OURPczRBQTdpd3JzTkN1WitSSEJkYWtzZG55M1Bza20zTDFE?=
 =?utf-8?B?TTN2dDY3YzYxQU9oRXhjM0x0MElSVW4vazVGREhoNXBYakRLU2tFTFZtOFV6?=
 =?utf-8?B?emhQMmlEdlplaG5VR1hNZFNCdXREV2tMb0RHY3RQbXJia0UxeTdCZHIzTFRv?=
 =?utf-8?B?cWd6SDVpTUdPZ3Vod2d1Z3ZmejM4MGc2TUp0cFNvV3ZMb3FiaDByeElJYjMy?=
 =?utf-8?B?Mm4yVTFja1VWODBkdm9UUHR1S1VLZG80cXI1akN4eS9FSEt0RU5ob2ptYWhG?=
 =?utf-8?B?eUtvOGlERDV5NU9GSElzM2dTdjJZMmkxUFZHeDcxdHNPSGdKVGI1UzJUYnJU?=
 =?utf-8?B?UzFTSDVCMGJqNFkyaHVkSTdmckNheEtoSGx2N051R2duanNIU1gzZExGY1JH?=
 =?utf-8?B?WnBhblQrcE5HWWZPV2g4VnY4SVFHTnAzRkVybldoZlBoVTFtR0g2elBmWno3?=
 =?utf-8?B?azdQbnVOQnJYdnYxMmI4Y214TWQrSFRxWUJOSU1wVU10VFhHbVBZbGFIYnd4?=
 =?utf-8?B?eG9sWWlQYTVyckVpSGg5WXBSb1ltWTFBN3J0SUZBbkY5ZVBxU0RGRi9jMVpv?=
 =?utf-8?B?bjd5czJ1Q2dCZDVDWnNCRlNGdm5MaU9RektZdFZacmFvWnRaSkRzVjR1dTRm?=
 =?utf-8?B?R3h2alFlNnIvT2YvWjhLNWczUnVtb25EQWhRRWpFelhtbVFYeEJrT1hMaGtZ?=
 =?utf-8?B?SGRmNGI4blNQRGV1S25RQ2REZllFVHFkRksyRFk1dENNVE1WWWNHZ1JpbmNF?=
 =?utf-8?B?cUE0dmtSQlQrcnZJeGIvSkp0a3NQRkJaYjM3ZlZtb0ZvT1NEa1hvcjEvU29R?=
 =?utf-8?B?S2hOUTYyL3c4OEpzVVpOR0JZZThINGRnd0xaV2VHekFJc2dyRnVaNFV0ampi?=
 =?utf-8?B?TkR1RHJmcmd0NXdhcWgvMXg4WHZvdmcvcWN2UlprRUYxeGh1a0xjQnNLVEFj?=
 =?utf-8?B?THBhWG9hNlIyeFRwS05NbEMxT01rUnBBZHBjQm9UcEx1Sk9GV3JVWFpvMHlZ?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e87eb511-c255-4d96-169b-08db614f6eab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 20:49:59.2894 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hb79g3OYYAkwD8qTsgSfOwMXTK7R2pgwN8GgcZT0AIExFH5RA+A41q5O7Ho6vpYAnnjSsmokze7m5HG5Jb1nYhSCIielTpOTpiPu8rD1SkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7168
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v7 12/12] crypto: x86/aes-kl - Implement the
 AES-XTS algorithm
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
 linux-kernel@vger.kernel.org, charishma1.gairuboyina@intel.com,
 mingo@kernel.org, lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 Ingo Molnar <mingo@redhat.com>, bp@alien8.de, linux-crypto@vger.kernel.org,
 luto@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com,
 tglx@linutronix.de, nhuck@google.com, gmazyland@gmail.com, elliott@hpe.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/26/2023 12:23 AM, Eric Biggers wrote:
> On Wed, May 24, 2023 at 09:57:17AM -0700, Chang S. Bae wrote:
>> == API Limitation ==
>>
>> The setkey() function transforms an AES key into a handle. But, an
>> extended key is a usual outcome of setkey() in other AES cipher
>> implementations. For this reason, a setkey() failure does not fall
>> back to the other. So, expose AES-KL methods via synchronous
>> interfaces only.
> 
> I don't understand what this paragraph is trying to say.

This text comes with this particular comment as I look back:

 > This basically implies that we cannot expose the cipher interface at
 > all, and so AES-KL can only be used by callers that use the
 > asynchronous interface, which rules out 802.11, s/w kTLS, macsec and
 > kerberos.

https://lore.kernel.org/lkml/CAMj1kXGa4f21eH0mdxd1pQsZMUjUr1Btq+Dgw-gC=O-yYft7xw@mail.gmail.com/

Then, I realize that at that moment the dm-crypt use model was not 
clearly out yet.

This seems to be carried over the versions. But, now, it has XTS only. 
Then, this becomes less relevant which makes confusion I guess.

I think this can go away as claiming the usage clearly now.

> 
>> +/*
>> + * The below wrappers for the encryption/decryption functions
>> + * incorporate the feature availability check:
>> + *
>> + * In the rare event of hardware failure, the wrapping key can be lost
>> + * after wake-up from a deep sleep state. Then, this check helps to
>> + * avoid any subsequent misuse with populating a proper error code.
>> + */
>> +
>> +static inline int aeskl_enc(const void *ctx, u8 *out, const u8 *in)
>> +{
>> +	if (!valid_keylocker())
>> +		return -ENODEV;
>> +
>> +	return __aeskl_enc(ctx, out, in);
>> +}
> 
> Is it not sufficient for the valid_keylocker() check to occur at the top level
> (in xts_encrypt() and xts_decrypt()), which would seem to be a better place to
> do it?  Is this because valid_keylocker() needs to be checked in every
> kernel_fpu_begin() section separately, to avoid a race condition?  If that's
> indeed the reason, can you explain that in the comment?

Maybe something like this:

/*
  * In the event of hardware failure, the wrapping key can be lost
  * from a sleep state. Then, the feature is not usable anymore. This
  * feature state can be found via valid_keylocker().
  *
  * Such disabling could be anywhere preemptible, outside
  * kernel_fpu_begin()/end(). So, to avoid the race condition, check
  * the feature availability on every use in the below wrappers.
  */

> 
>> +static inline int xts_keylen(struct skcipher_request *req, u32 *keylen)
>> +{
>> +	struct aes_xts_ctx *ctx = aes_xts_ctx(crypto_skcipher_reqtfm(req));
>> +
>> +	if (ctx->crypt_ctx.key_length != ctx->tweak_ctx.key_length)
>> +		return -EINVAL;
>> +
>> +	*keylen = ctx->crypt_ctx.key_length;
>> +	return 0;
>> +}
> 
> This is odd.  Why would the key lengths be different here?

I thought it was logical to do such sanity check. But, in practice, they 
are the same.

Looks like this entire crypto code is treated as performance-critical or so.

> 
>> +	err = simd_register_skciphers_compat(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
>> +					     aeskl_simd_skciphers);
>> +	if (err)
>> +		return err;
>> +
>> +	return 0;
> 
> This can be simplified to:
> 
> 	return simd_register_skciphers_compat(aeskl_skciphers,
> 					      ARRAY_SIZE(aeskl_skciphers),
> 					      aeskl_simd_skciphers);

Oh, obviously!

Thanks,
Chang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

