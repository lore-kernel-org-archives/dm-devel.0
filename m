Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE760C77B7F
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 00:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683590610;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g7+p+ZoipY5zQmvPi4T9rm0Rtn+QIyCoBQW6HaoeTZE=;
	b=WOQorSw8l51HMXuZnIEMp/pS0V+QvYNLmSnoR7neUlNiP+0E4bCfB7aoCIOhJpsstExClS
	2HbujwChveqJfa0IqFqv1MmTjbWqr1IFfdw5icOkkftYZ9NivQVovhYiR/iNn30b/hfph8
	0q2WYmOyrZfK1z/HI3oNcaqFRGPEUow=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-YnbD15HwMaaB4Trrk3-o7w-1; Mon, 08 May 2023 20:03:29 -0400
X-MC-Unique: YnbD15HwMaaB4Trrk3-o7w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E05091C0878D;
	Tue,  9 May 2023 00:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 68B82492B02;
	Tue,  9 May 2023 00:03:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 166CD19451D3;
	Tue,  9 May 2023 00:03:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A69FE1946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  8 May 2023 18:19:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8561540C6F64; Mon,  8 May 2023 18:19:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A62640BC783
 for <dm-devel@redhat.com>; Mon,  8 May 2023 18:19:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C86E100F65C
 for <dm-devel@redhat.com>; Mon,  8 May 2023 18:19:27 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-swrPGgY9OnmLQ3nlL_DGWg-2; Mon, 08 May 2023 14:19:25 -0400
X-MC-Unique: swrPGgY9OnmLQ3nlL_DGWg-2
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="352780895"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; d="scan'208";a="352780895"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
 by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 08 May 2023 11:18:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="1028498065"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; d="scan'208";a="1028498065"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
 by fmsmga005.fm.intel.com with ESMTP; 08 May 2023 11:18:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 11:18:19 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 11:18:19 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 11:18:19 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by DS0PR11MB7997.namprd11.prod.outlook.com (2603:10b6:8:125::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 18:18:10 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::cfb2:e73:907d:cb77]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::cfb2:e73:907d:cb77%5]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 18:18:09 +0000
Message-ID: <288de217-f0ff-658c-5490-6fbf5f57f5a7@intel.com>
Date: Mon, 8 May 2023 11:18:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To: Eric Biggers <ebiggers@kernel.org>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-12-chang.seok.bae@intel.com>
 <ZFWY6/VelArVYy1F@gmail.com>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <ZFWY6/VelArVYy1F@gmail.com>
X-ClientProxiedBy: BY3PR10CA0027.namprd10.prod.outlook.com
 (2603:10b6:a03:255::32) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|DS0PR11MB7997:EE_
X-MS-Office365-Filtering-Correlation-Id: 187f2476-5eaa-41cb-021b-08db4ff09399
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: gOtUHWmTgPaeB72D03dBqvNG2TVfyt3Y/XJL7JZP09Pw2ATSPpCPvNaYcKa4g2/ZxYsEUzatpp22K/9QbOiHnlRp9VVgVhUvrmN9XU4SVWFgOzcVHfvDuk9knTuqiQJjBUIbxGDV8r9lZqHz9gRuKINfjw4YtTxFAzfjS0SPQtdrwB90+i5/OZa0eFaBEbr8DJe6XhlnPW6cwokiY43EXA8ADZT4zWqxjGbQ4YNNZGqzaQg0JHnz0/DZzJdc/76y6m9cPh2cZ3oRS/wgOBCVj/lsKA7Ze8RWqhE4ZHpZolO13c5d5lMbq0ACLAz7VvXvgvlbApcyI1iFsENz5mu2RaGaK66Yb2Dym3E4XI/dHc0Rax1ah5Q051hnA9kseq/+gcecdgRJ7E4rYzBku06VgyGElkwopkV38WXQeKxMPWeH6n6t49JBH0/kztN0M5N38w1pXZ8j7RWIq3XbfB8ux5JRXeZqNohcvJFgo01fKj8dsQFQv3p4AQtiskldz/bAHRUuOFb3eAjucAC3w0QyUze1LLLVsRww5TIAzsuSRaV6MAltM8sIbMFI50wvHhsGCm1HP9/vAV7Ne/CFwACkm4PFadfZ/LNI7O7oktg27sWQM1ni7sRNoVHqDOBFePvNmasHYDrhAzOncxbTy/Gb6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199021)(8676002)(8936002)(5660300002)(2906002)(7416002)(82960400001)(36756003)(38100700002)(478600001)(6486002)(6666004)(54906003)(31686004)(83380400001)(2616005)(53546011)(186003)(26005)(6512007)(86362001)(6916009)(4326008)(31696002)(66946007)(6506007)(316002)(66476007)(66556008)(41300700001)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHZ5eW9NY29DK3ErNzBaNmNwOHgzT040eTk1dG1MOHgvMzRhcTY1ZzhJVWZt?=
 =?utf-8?B?WFF5RjVuY0xqZ08rWjhqMExGZ3dCZlRTZmpkVk45Y0lVRTZ2QUYzUFRFRUFQ?=
 =?utf-8?B?NzVMdW16UkNMU0NCMmZRdC9QZE9jWjFlbkhTbDd2aGFTeHZmMlR2Wmg4ZEE4?=
 =?utf-8?B?ZW9Wc08yS1UveHVYVk13Ritjc0Y3Q3BYS21IbFFvUCtWSWNYWDk5KzNGSk1z?=
 =?utf-8?B?NUJPMnlKYk1zbkltSFFVVVpuanF0ODg0SmNuNmFxbkIxNGFZVVdnWk4wTE0v?=
 =?utf-8?B?NDlrL1lOT3JhZ1N2OEw1WlpIRmZaT1ZHMWFDaGxEQktUd0E3c2k2SDRjaXR4?=
 =?utf-8?B?K01odGV6V1FRbTRmNzZTOU1udTVkN215OUlGWDZyNi9VeUtMbjhOM2kwN3dt?=
 =?utf-8?B?YTNqQ3BTLzFSWHN1RDVKZHZzdmRhRk9VZFpYUE0yUFdxQmt1U2hFRG5wMElL?=
 =?utf-8?B?a3YyYW54SjJpeHc3U0lzRVQ1NVQrNXEwREdIL0h4VWtPYVEzUDRaL2RVcU1P?=
 =?utf-8?B?aUU1c1Z3QVdhcTJidWROWEcwVmtONzJySktPSW5EUVB6QU9mUlRyekRTNGxJ?=
 =?utf-8?B?Sk1leG01KzUrUmwvbWdLcWd1RjNpY0lqRGZqaVNWZDFOUWlPd2tzcldJcjBn?=
 =?utf-8?B?K0pMZUo5cUFINmtWTmk0UkN3UW84cCtZcHM3S3RlWWpIUGMwVWFXalU4Q09a?=
 =?utf-8?B?cXhJNWhaVWdkbXZ5NHR1QitnZDl0d2RzZmg1WHdKQ2hoRVlZM1V6T1lGbjJO?=
 =?utf-8?B?Nkl4U0cyTjZjRzdSTWFlMGV2TjI5RjhJdjhSazZJNmVxV0RXa1hrZW5wWEhC?=
 =?utf-8?B?OE9OYkU2a1N6ODFUWUEwT08zWlB2NmJ3R0NQMjV6RTFmN1l2dGdraWV5VFRL?=
 =?utf-8?B?TEV3Q3J2bjBnTEZrUld2cTdFYWhsbno0NzdibVBXaUF2a0V3M0dZbkN4eTM4?=
 =?utf-8?B?ZS9zcTUxRHovQ1FyM1FaYW1SV1RqazA4WUlacDd1Rm9Mc0xGclFmNGV1UHcx?=
 =?utf-8?B?SzI5RlV2UzlNbVhrWW9MTGZYZ3ZJL0hHbDQwTWJVQ21NMzJUZjdaMWFZVWdH?=
 =?utf-8?B?by9waUFFVnp4eHZVdWN4QlRvT1AzazNwVHl5RHl0dWpXVjlxb2Fudk9XclhH?=
 =?utf-8?B?aXBjeDYxYlVXOWZ4LzZKdGROaEl2QkJxMjR3VkIrWFo5THBObExTRElVL3Bt?=
 =?utf-8?B?YXlmemlBUzVRWUVCV0ZuMXhLbWxhanhFVm12cXJVTHY2d2x2aGxkTnJsYUky?=
 =?utf-8?B?eVh5c3pHeUVRaHUwZVRJYTRxZTJsNUFDaHVPNFpxclNSTW9SUU9VK2psaFJD?=
 =?utf-8?B?UTJseUtNdEZhTDF6T3JqcG5YUGhGWnNzNmQ1RHhuNVNRQ2hXbTgwZ1NBeDNk?=
 =?utf-8?B?Q2p1WnJyQUh2S0V0RFN3WXNPRVpVZTlEc3RUVm55RGEzSjZQWXBqVmptdHJk?=
 =?utf-8?B?OWVZRzZVVzB4ZUFzN2p1eE05M3Z2eVVpay9JSFVOR2tsKzMwOHRHdlRzMGVZ?=
 =?utf-8?B?WDg3Mml3ZnlKMk9JSGZFS25aMzkwWnRyaTdGRGNJMnpPMW4yQkpHRXc5N2l5?=
 =?utf-8?B?TkN6NFBBMmNpKzR2SWZFZ3FHbXhNL3FMeThJdGNMV005UldaYitaOFBXZ2Jp?=
 =?utf-8?B?Zjc5aEl0N3dvZFFLRUI1dEROYTRDSzc1QmpFMTJWczQyL3AwK3ZXNE02NVJB?=
 =?utf-8?B?M0ZLSVNtSjNSWkJNbFBPaW83ck5HMmFMQXdmTktVYW91MDQwZXhQdXU3TnRJ?=
 =?utf-8?B?dTZCTUdhMzVNL0NDSi82Zi8zeUhpd2YzenpuSVoxbnA2OEprQTNhSHhYUVN3?=
 =?utf-8?B?QjVGQWxycDYvR2xoZk5DMFJCcHFwa0lZQlVmbmpBeXdjYVFzU2FhUnNTd1Jz?=
 =?utf-8?B?L0c4WXg0aDJzMWZQaGgwRDRoaEtndGhMd3JKNktqa2lLa1V5NU90MEZ6VW9M?=
 =?utf-8?B?LzdMci94UThzR3l6QzF2aGtRRXZCTXFKaU4wTlVvU0RQa1VrUVRFWVgvSFBn?=
 =?utf-8?B?Ujd3YkY5aWN2SlJ0WFVhR3JhS0JGY2xlZVdYc0grUk1VTHh3bDJrSGxZZmp2?=
 =?utf-8?B?NEV0YXBnT01tb1JSQ01ld2gyY1crRlpLRTkrdUVsUVJyUnlsTWN3SWNzZ1BZ?=
 =?utf-8?B?UnNqOEJENkh4aVh6QmlpOFFvbWUzTVVIaTN5K25rSC9hNHJobnFZTkh2TFBy?=
 =?utf-8?B?bmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 187f2476-5eaa-41cb-021b-08db4ff09399
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 18:18:09.4905 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ba+qxSn2xaUjN+a7njumKkKil/6ZxHlTfFZnRCBiR3ia/NY1e9kjU8LCMKiLGzpbuPnln8YJYM6Xaqe1A5c8X4Tr0IqqtDN2oHKgD6QE9q4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7997
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 09 May 2023 00:03:21 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/5/2023 5:01 PM, Eric Biggers wrote:
> On Mon, Apr 10, 2023 at 03:59:35PM -0700, Chang S. Bae wrote:
>> [PATCH v6 11/12] crypto: x86/aes-kl - Support AES algorithm using Key Locker instructions
> 
> Thanks for dropping the unnecessary modes of operation (CBC, ECB, CTR).  It
> simplified the patchset quite a bit!

Yeah. But, there are more things to go away here as you pointed out here.

I thought some generic establishment (patch10) then introduce some 
mode-specific code (patch11). Considerably, this incremental change was 
expected to help reviewers.

Now I realize this introduces dead code on its hindsight. And this 
approach seems not helping that much.

> Now that only AES-XTS is included, can you please also merge this patch with the
> following patch?  As-is, this patch is misleading since it doesn't actually add
> "support" for anything at all.  It actually just adds an unfinished AES-XTS
> implementation, which patch 12 then finishes.  I assume that the current
> patchset organization is left over from when you were trying to support multiple
> modes of operation.  IMO, it would be much easier to review if patches 11-12
> were merged into one patch that adds the new AES-XTS implementation.

Yes, I agree to merge them.

>> For disk encryption, storage bandwidth may be the bottleneck
>> before encryption bandwidth, but the potential performance difference is
>> why AES-KL is advertised as a distinct cipher in /proc/crypto rather than
>> the kernel transparently replacing AES-NI usage with AES-KL.
> 
> This does not correctly describe what is going on.  Actually, this patchset
> registers the AES-KL XTS algorithm with the usual name "xts(aes)".  So, it can
> potentially be used by any AES-XTS user.  It seems that you're actually relying
> on the algorithm priorities to prioritize AES-NI, as you've assigned priority
> 200 to AES-KL, whereas AES-NI has priority 401.  Is that what you intend, and if
> so can you please update your explanation to properly explain this?

I think AES-KL could be a drop-in replacement for AES-NI IF it performs 
well -- something on par with AES-NI or better, AND it also supports all 
the key sizes. But, it can't be the default because that's not the case 
(at least for now).

> The alternative would be to use a unique algorithm name, such as
> "keylocker-xts(aes)".  I'm not sure that would be better, given that the
> algorithms are compatible.  However, that actually would seem to match the
> explanation you gave more closely, so perhaps that's what you actually intended?

I think those AES implementations are functionally the same to end 
users. The key envelopment is not something user-visible to my 
understanding. So, I thought that same name makes sense.

Now looking at the changelog, this text in the 'performance' section 
appears to be relevant:

  > the potential performance difference is why AES-KL is advertised as
  > a distinct cipher in /proc/crypto rather than the kernel
  > transparently replacing AES-NI usage with AES-KL.

But, this does not seem to be clear enough. Maybe, this exposition story 
can go under a new section. The changelog is already tl;dr...

> I strongly recommend skipping the 32-bit support, as it's unlikely to be worth
> the effort.
> 
> And actually, aeskl-intel_glue.c only registers the algorithm for 64-bit
> anyway...  So the 32-bit code paths are untested dead code.

Yeah, will do. Also, I'd make the module available only with X86-64. 
Then, a bit of comments for the reason should come along.

>> +static inline int aeskl_enc(const void *ctx, u8 *out, const u8 *in)
>> +{
>> +	if (unlikely(keylength(ctx) == AES_KEYSIZE_192))
>> +		return -EINVAL;
>> +	else if (!valid_keylocker())
>> +		return -ENODEV;
>> +	else if (_aeskl_enc(ctx, out, in))
>> +		return -EINVAL;
>> +	else
>> +		return 0;
>> +}
>> +
>> +static inline int aeskl_dec(const void *ctx, u8 *out, const u8 *in)
>> +{
>> +	if (unlikely(keylength(ctx) == AES_KEYSIZE_192))
>> +		return -EINVAL;
>> +	else if (!valid_keylocker())
>> +		return -ENODEV;
>> +	else if (_aeskl_dec(ctx, out, in))
>> +		return -EINVAL;
>> +	else
>> +		return 0;
>> +}
> 
> I don't think the above two functions should exist.  keylength() and
> valid_keylocker() should be checked before calling xts_crypt_common(), and the
> assembly functions should just return the correct error code (-EINVAL,
> apparently) instead of an unspecified nonzero value.  That would leave nothing
> for a wrapper function to do.
> 
> Note: if you take this suggestion, the assembly functions would need to use
> SYM_TYPED_FUNC_START instead of SYM_FUNC_START.

I thought this is something benign to stay here. But, yes, I agree that 
it is better to simplify the code.

Thanks,
Chang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

