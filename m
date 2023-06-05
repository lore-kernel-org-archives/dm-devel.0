Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E66C77B73
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 04:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685940112;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XQtMbuNWO3gK+jqXdy9Den+kS+YYpoQp8LdkTC0BMA4=;
	b=MRTUULzyM77IK5ZmoQwvJrEZSCru0bFFEailhxkYMfUyOxtibd5Dz+C8oORfAK8Vbs2zwI
	QDbz1ovIk3xzkCmU+rJpsZtaAPpTdT6snkjIRaYOEjTQEGQcgPUQ6CtNEIJyIayBhaxJcn
	ef455KoWxkvyes82p/SJ17EVJcJPA0A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-xgg-WsXzPB-fA-UdRO6NvA-1; Mon, 05 Jun 2023 00:41:48 -0400
X-MC-Unique: xgg-WsXzPB-fA-UdRO6NvA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 508993C02B9D;
	Mon,  5 Jun 2023 04:41:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BAF5A40CFD46;
	Mon,  5 Jun 2023 04:41:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 82F6A19465A0;
	Mon,  5 Jun 2023 04:41:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 579F61946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 04:41:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 600152166B27; Mon,  5 Jun 2023 04:41:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 56D862166B25
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 04:41:41 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34CF529A9D4D
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 04:41:41 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-m756q_q4OienIw5syWOeag-1; Mon, 05 Jun 2023 00:41:37 -0400
X-MC-Unique: m756q_q4OienIw5syWOeag-1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="384578252"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; d="scan'208";a="384578252"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 04 Jun 2023 21:41:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="711665423"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; d="scan'208";a="711665423"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
 by fmsmga007.fm.intel.com with ESMTP; 04 Jun 2023 21:41:35 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 4 Jun 2023 21:41:35 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 4 Jun 2023 21:41:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 4 Jun 2023 21:41:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 4 Jun 2023 21:41:35 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by CY8PR11MB7731.namprd11.prod.outlook.com (2603:10b6:930:75::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 04:41:28 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::a41b:1b6c:8306:7644]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::a41b:1b6c:8306:7644%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 04:41:27 +0000
Message-ID: <f1093780-cdda-35ec-3ef1-e5fab4139bef@intel.com>
Date: Sun, 4 Jun 2023 21:41:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Eric Biggers <ebiggers@kernel.org>
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230603152227.12335-1-chang.seok.bae@intel.com>
 <20230603152227.12335-11-chang.seok.bae@intel.com>
 <20230604153434.GA1212@quark.localdomain>
 <0925dd9e-3588-38da-8dfb-0ac2ff568655@intel.com>
 <20230605024623.GA4653@quark.localdomain>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20230605024623.GA4653@quark.localdomain>
X-ClientProxiedBy: BY5PR17CA0027.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::40) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|CY8PR11MB7731:EE_
X-MS-Office365-Filtering-Correlation-Id: b7071bed-3015-48af-8b51-08db657f1fe3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Lp5gunYTerocIdJTvTnjHIUEPsL6s0dpmCq11AG2HlQbqcjffncEVqf2lNiACDbuLJa3vEs+o2xGxc0/MY+nqbcR9IokQ3mQIpdZHqe5mhnqe0cN6YUqQMbKRXOR6waI7Io2yqGkWNjr7Mu7ef2K7ITaU8GzDbphKGznVVnZBL75YZBez9zvV9rVIOhGcGsdL1kGZ86bXLpY9Cd2DailrED/MOpMUQkCsq6KRhp4XE1xHw1W7kS2p+1WLM79f6tXl9J4otYYv1+dfZBo8q5pUwAz8VFghGkGrR4/ep17S4hxedERTDQsjzRqa9J4fyNrSM/cClIdbzm5fzEoVclxpRD0p4qsbTER54ezJn+/acmUSnPPCZAyQe6Fu8zwc9CWtJqkZLPUwT8r96gV2+rVHEZzkK9becXjBCzzZpscqTnU6wOvaUJWAE8I1vjkPuKkMGOU3rH1ifwJfNWR0altwFT76hMAdEcwvwmh2yo+vz8+SniEd24BUer+j29eAww5NL75CpB2n/I3/afN8A8Dt5lIAf3HIxus3uG2x0Wb+jXjDV5ld/atYos223w9N9+ezqV7yU1j2TjMmbQluWnIy/Q3khXts5lZsaDlh9rMWFPvaAZHTHQ3FasJ/biODDNsiZmoXUZ0ya3j/GQt8gKuJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199021)(8936002)(8676002)(478600001)(54906003)(41300700001)(5660300002)(316002)(6486002)(26005)(7416002)(186003)(31686004)(4326008)(66556008)(66946007)(66476007)(6916009)(6512007)(53546011)(6506007)(2616005)(2906002)(4744005)(38100700002)(82960400001)(31696002)(86362001)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXNwQmI2eHorVnM4NlhDenNkVExxYkVSK3ZMVEtXS0VFSS8wMEtyMk5ndDJO?=
 =?utf-8?B?UnJXaUdFSTBJL2greFFzdkwwV2ttWWh6QjNodHZvRk91UkRIZEVGbU9paXZO?=
 =?utf-8?B?VmJlYXlHemRaRUhWSXZBSGt0VlVOTmc3L1dqeGk5QTZRUS9hNE8zN0tDWXhT?=
 =?utf-8?B?eUNrSytDcDNGcWg4c3hneEtGa0pWUCtZZ2ZKV0FkMVZJU2NOajhzbXRBVnNW?=
 =?utf-8?B?dkpvRE8rUDNUYXhPYi8wZDNDa0lxR2YycWRjL3JZeW4vWkhlVFI1SFdXQ0pT?=
 =?utf-8?B?ZmVhOVVsUEpjZHlDdytGYlpUSEZtak9KcWtsSk5PamVjc0Z2a0UrdVpDRXJz?=
 =?utf-8?B?UDdlWUdkM090aE1LOGxnUnM4eWw1akFGOE1SRXkvM0ZxZ2N3S0FjSW5VaGFs?=
 =?utf-8?B?VlhzWUhka3oxL3FUOFdZK21USjlvVHA5L0twOTBLWW9BMlpBeXFIeUNiYzEy?=
 =?utf-8?B?UG9ra2NGa211UEU0azl3ZlQ4NUVqcklVVnV1YUE0QVFwVzZmYS91L1c1L1N2?=
 =?utf-8?B?Q0M0TWZ1U3piUEd0Z3lKelZsSWluYmpuQnVjVzJaSWp6cnZ1Q0plSG9kMTNi?=
 =?utf-8?B?YTAvZlBsOFZiZ1E0ZDBTZ1VrY1dFcFpINjVsRWcxRDR3RVFpcHoxdFZGTmk5?=
 =?utf-8?B?SXFNYjNLUkRzYlZuQVNnK3hnaWRCNWt3NkUzY3F4R1REMFNpWHJpNTJvWExF?=
 =?utf-8?B?RDVNYm5CbEwwbTRjSUtvWEtId2Fma2hjWnY5aXNvQVVnZ0RrZEFZd080U1Ez?=
 =?utf-8?B?dzFkaTRaTTNlQ1VTd2s3QUFVcmdtVlFIWStYNDhZMWVMRHFZdjV4SjJBc3pp?=
 =?utf-8?B?eFZQc1JtZnRvZjZKeitIelkwMjBvdUlKK05JTzBaRUhVQzNvN3YrRVV1c01w?=
 =?utf-8?B?ZW0vU1FJelBTbXgrZmM4RVQzRU9ucVQ0d1cxakhXRXVjakloRTRvakFnNVhM?=
 =?utf-8?B?SDY5MGVLaTRTQ3Q2cmVXanAxZ2hEcmYvL1dOV0paYXlIajJRM2VHbHBQdmhB?=
 =?utf-8?B?anpUR2hTMnNrKzdhdVRzRFhEaUFqZ1lGdjdaOUpLd2xobkJVNGhhalhTTGUz?=
 =?utf-8?B?UFJhdDNidWl4U0JjeUVGMm52Y2ZhOTlhZnU4VkVmOGtyTEora3A4R29HdHpw?=
 =?utf-8?B?NFBVWmxKandENGgvWlhBeHl6U0lKL2twZm9LekJXL3ZYOHdrblp1ZkFFMWRO?=
 =?utf-8?B?MjlpQjFOdURZZ0E1RWdlckI4bFc5aUQvbHdFWTZhbXVOQkdydFFQYmk4VUF3?=
 =?utf-8?B?dmNzdFUwaHJNWXlpVURmS3AvRDRYZGw0UEUvbXIvSm9waFRNK1VJUnZOaStB?=
 =?utf-8?B?djZFTitiMGRYbzRSeTdyaFVFbngzeWQ5dENWTStGTEltdzYwZ01jZklOTUM2?=
 =?utf-8?B?bDFlUTVERlpsVXpSVVNrYUZsWHJnOXg1dWlXWXZKa01EY2NPTjZrOTduTmR3?=
 =?utf-8?B?SlhyTzB0Z2k3alR4d0l3UFZsczU3YkNZT053Um0wSml2UXptd1ltMlY0TFVk?=
 =?utf-8?B?RmpjVDY4SHQvQWp2WGNsWlFtVC9GSC91NzNoUWFra20rYnJKSGhFRnlDeEpZ?=
 =?utf-8?B?cmlpanRuYW5Tc0hOZDdSSGcwMitMeTJuNzBzRTAzVFpVcitoNU9PbzZyTXdN?=
 =?utf-8?B?UlBEY1AwdWFTMDNxYmxmRHlQeHdhRTJjSngrK3RsS0pmSnlqaWRkYmxocHVr?=
 =?utf-8?B?MDdVai9SVm1Jb3ptdWYrMFBzZWo2ZXlIZEJhMTJ3dmgvQ3AzeCt5bEdHS1A0?=
 =?utf-8?B?cTFSSUxDeXBMMkovZzBENXdXUE5rLzQ2R2RPd1RIOTFFQlFUM0lhTEY1TEZ4?=
 =?utf-8?B?eGRTVGZoUmd2RWdma3BVZmtlTzhxMWNGS2phRk5QWnhvZXk2WnVITEJoT3VN?=
 =?utf-8?B?RnVOTGpLNllqK0d2ZG1JMjJ1U1hxQURaN0hVV0l5djA5bDZubWI4UXBuZmF2?=
 =?utf-8?B?U3VjSnB3eUwwSG5WZlJDbERwMFcrNDhaK0NTeTkxczAzU2IxMjRMYlJnbUFk?=
 =?utf-8?B?S2dIMXNhMHpEZk03ZGhmNWhLbW5uWENCVTZzSjNLVURUS21mdVpMN1NxVXhP?=
 =?utf-8?B?bjJLc25XTVhlSU5Bb2pybzdLRDdpd28wVVQ2bnpQdHlodTRMTjZJZW1hdm43?=
 =?utf-8?B?NDQyNVRrYkRNdjVOK0NqQ3NzU0RCK0RsQXNwL2VOeU4rVnBpUTM3WDNpQ1lX?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7071bed-3015-48af-8b51-08db657f1fe3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 04:41:27.7072 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VOwrTsNyYStPKItGk08MSpF5TMHgSGSbWn1cO7UEdPEGJXButayGnEslWuxJrAB1ZZhvnr+hoh7LS/1WCDomgzRxK+2n0VcEBMxIegqZyG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7731
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v8 10/12] crypto: x86/aesni - Use the proper
 data type in struct aesni_xts_ctx
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/4/2023 7:46 PM, Eric Biggers wrote:
> 
> IMO the issue is that your patch makes the code (including the XTS code)
> inconsistent because it makes it use a mix of both approaches: it aligns each
> field individually, *and* it aligns the ctx up-front. 

But, the code did this already:

common_rfc4106_set_key()
-> aesni_rfc4106_gcm_ctx_get(aead) 	// align ->ctx
-> aes_set_key_common()
    -> aes_ctx()				// here, this aligns again

And generic_gcmaes_set_key() as well.

Hmm, maybe a separate patch can spell out this issue more clearly for 
the record, no?

Thanks,
Chang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

