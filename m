Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1710C77B73
	for <dm-devel@archiver.kernel.org>; Sun,  4 Jun 2023 22:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685916172;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RJBSU96mlW8ijB7L4Dln9H7lLj4DPgkHZzkULMUs7fo=;
	b=T2Scsxt2g35L4nZWkQtqxOYF+QSGCfZGYgdzcN/AgEtfOcuUIh4VTKJ/XnTMLoCim72bZv
	yIW5gKqTF1Pzcp2bkK1WO2STKej8hKNvmOTR2BrrYBqeYkrGb/x7jeiS57Ug2B8WSdALy3
	/HR3OBxQLe/UDEqheN5TzHi8iI9/9KI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-lAEMOfeOP8WMf7IiqqPIgA-1; Sun, 04 Jun 2023 18:02:51 -0400
X-MC-Unique: lAEMOfeOP8WMf7IiqqPIgA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06A3E85A5A8;
	Sun,  4 Jun 2023 22:02:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D4AF11121314;
	Sun,  4 Jun 2023 22:02:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 63F9B19465A0;
	Sun,  4 Jun 2023 22:02:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9CE551946595
 for <dm-devel@listman.corp.redhat.com>; Sun,  4 Jun 2023 22:02:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 858131121315; Sun,  4 Jun 2023 22:02:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CDD71121314
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 22:02:44 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 420613803517
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 22:02:44 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-kiQeZpm7NmutciT3O_NvGQ-1; Sun, 04 Jun 2023 18:02:42 -0400
X-MC-Unique: kiQeZpm7NmutciT3O_NvGQ-1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="358679137"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; d="scan'208";a="358679137"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 04 Jun 2023 15:02:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="798194741"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; d="scan'208";a="798194741"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
 by FMSMGA003.fm.intel.com with ESMTP; 04 Jun 2023 15:02:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 4 Jun 2023 15:02:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 4 Jun 2023 15:02:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 4 Jun 2023 15:02:39 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by CY5PR11MB6485.namprd11.prod.outlook.com (2603:10b6:930:33::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Sun, 4 Jun
 2023 22:02:37 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::a41b:1b6c:8306:7644]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::a41b:1b6c:8306:7644%6]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 22:02:37 +0000
Message-ID: <0925dd9e-3588-38da-8dfb-0ac2ff568655@intel.com>
Date: Sun, 4 Jun 2023 15:02:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Eric Biggers <ebiggers@kernel.org>
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230603152227.12335-1-chang.seok.bae@intel.com>
 <20230603152227.12335-11-chang.seok.bae@intel.com>
 <20230604153434.GA1212@quark.localdomain>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20230604153434.GA1212@quark.localdomain>
X-ClientProxiedBy: SJ0P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::33) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|CY5PR11MB6485:EE_
X-MS-Office365-Filtering-Correlation-Id: bd29dd8b-c05f-43bb-6783-08db654767e7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: loz69B3Zf9z2E4FOKyx4hG9YGpOcLFjyFCHJJvsdHI0obVohIP/OJ1StOqevSkS8RGn1gC+WL3QeJ1vah4RT80mqMnssaSyyBPvZuVVsP8pqQ7O0gM3moBpH8V77i2UKVDbnhHOfuQ+WlLXiqfrk+FVazsbHrea++5wGqvCG/GnG3lxlg8m4aDW0/+7KLBqsHuYFatQUfcfncpOKMzwtsavhNI840H9F0nB/Ys3MSPigRlAVlw/2YEBNGoqg3CW7zDSuuFtAl4GRVfpBlR6yzEiT1g1ziGPZ0K/hef8S/W9MTKN/1uAKzpz93AitupXTqGMrnstW6RCet7E9y2aZJKq28b4XxKjln7/jmL8M1k13u79QiFLwPGEMvvxaC0rloromVvszlAHLtUH39MI+yroT+4W0uO+LkihxcTuo+4rD7cCwy+avJpqphDK5N7T8niolpo+QxsvXp7CMfeHG7adp9RhAVfkdMWb6wod/4nVjIrFAZeenpgojHD28VsaP5ajVpfWe4t8w2THUCzRkuVMiAjD9d6ONN3Jq/Xr746/hWZTUeGRzPpZM9bd72M3LNwMARRhEdfIpiAlHxJ+vRQqEqz+CF1gyFZQ/CZiNM5qU94ADVZ+9H35iusDYguurVxQXG5iQch3w+cuicKFV/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(346002)(136003)(39860400002)(376002)(396003)(451199021)(8936002)(8676002)(478600001)(54906003)(41300700001)(5660300002)(6666004)(316002)(6486002)(26005)(7416002)(186003)(4326008)(31686004)(66556008)(66946007)(66476007)(6916009)(66899021)(6512007)(53546011)(6506007)(2616005)(83380400001)(2906002)(38100700002)(82960400001)(31696002)(86362001)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGlrQU1seVNLQnIyS3ZXeExUNHhDdXR5ZHB2NHIzQkh0anFhYm8xNVRmWHRa?=
 =?utf-8?B?eGw2TU9RU1BFeDlTanNCdDlEdVRWeWFOMDJEM2F0ekVEU084MFUza0RTUHVJ?=
 =?utf-8?B?MFNFVnpURExON2kvTCtZUEdWc2N4NklNRDN4U0tkNkgrYUE0TlptZG9VanFM?=
 =?utf-8?B?ekpkeWRGYmhncnpQaUV3amNwRzZURm5PTzVwd3U0WkgxZjdZL2tPSno4WkU1?=
 =?utf-8?B?cUJoRDEwUEErSjhZc05UUlhMTVAzcjd2QnNVTTNoanpjZWdpcG5aQ2ovQlBj?=
 =?utf-8?B?WUloYzRXMTRvZm01Qmw1NEVCNmNENTBqb2hyQ2ZMUjdJOC9ydW5TOHBtZWRD?=
 =?utf-8?B?V2xSV2xGRno2R1I3QzdtTkF1dFEvdkFnamJoTmJFYVIyaUlnMEtZQ21KVFZ2?=
 =?utf-8?B?c0FwNGpBRWJqb3c0ZnZMSFR5TkNUbTFGVC85U2FnZTlYdExJbUFGejJoLzJr?=
 =?utf-8?B?V2dqQ0E1dUI1Q3A1VVZWVHVBZ3VMRUZtWDF3aGNLWTRIRS95RGtzTzRUaEoy?=
 =?utf-8?B?Lzd3cWtkSlZYQkU1OUVkb2JsWUtUb09BSFp2enlIUkdHQVB4Z2MwMXpSRXNC?=
 =?utf-8?B?a2hxamFTczVndlJqWFRzMGlwME93VHlxVEZJMzdJbHhNL0UwejJvMC83VHpQ?=
 =?utf-8?B?ZHhKS21SZzBkZC9uZ2tRV0VJU2dEbWZzbityc3lrNmhaZ2pOR2s4NlFVeEpM?=
 =?utf-8?B?eEV2azZaaEM3U3hVRzlYL0hpc1R5bElxRkdua2xjVzNzWnN5cktsd203THhm?=
 =?utf-8?B?N1JXUUpoQVRMWndNNXdUME1lOUlYVVg1aWNlbitMdjE0WDdMZzZ1Ry9mY2p6?=
 =?utf-8?B?YWV4Q0Fpd2cvSWVtVElISHRId1QrNGhaZWxjZWRBbGl1VTdoaS8ycUgrWGlh?=
 =?utf-8?B?ai9xWVJhZVN5UTRGd0NtbjdUN0p5YnJIbGMvVFh3bWFQK1l1OWQ2OURacjBX?=
 =?utf-8?B?cmdJT0xQaWN5b09kVFJJNWZNVCtGYWZQOGJEZXp5WHVSNGZBTjFqejFKVXdD?=
 =?utf-8?B?V2xpV0Q1T2JaejMyd2xaUFVsaXBFYVByRWZrVE9OSUpPNTNhRi9HL3BrUnlN?=
 =?utf-8?B?QzNLenMvSHcwWTA3YzUyNFFraFVNdlNEa3NMRTVYYUZsZlVHQkFsQ3FETHhi?=
 =?utf-8?B?TUxkcGk5ZVB1QmRybHJ1YTlZdmdleno5V0dxOGp3N0d6M2ZiK1N1T2gybEpP?=
 =?utf-8?B?RHZzNWhobXdhUVZTKysreDkyS3lqcjc5Y25PNCtra0hSSUxITGhDbHFPZnU5?=
 =?utf-8?B?WEY1WEdJb01zbUhlUmJFM2xWbU11bEgrYkF1YjUrVDdTdDJ5bDdoZ0d0T2VN?=
 =?utf-8?B?TkFkVmFkbFc3alRFNUJldWlRLzBIelpzczhGR1lwWGRNMUpPUW5NOW82RUdV?=
 =?utf-8?B?bTNpbHJCWktuRDF3NGFhZk9WRFJwdUxxeWhqUUZkY2xFT3UyNTNGMWdjempw?=
 =?utf-8?B?RkRaVjZQYzNtVTg5TS9kTURROXYySGxqd012L3FKWmExWTFNZUhZb1BFODBZ?=
 =?utf-8?B?UWJtYXhFVndGYWdpL011cS96ZGdNK3cvY29ISXZyQVBvSlZ3MmZ3anQ5M2ZS?=
 =?utf-8?B?bWFOQnhTKzNwYlFaZURkNmRINWVxai9EbmEzd1NqelV6V2diM3FhNmtCd2M0?=
 =?utf-8?B?WEw3ZDVVRlRvRVJWSm8wODBlQ3RaZTk3ejRrWlVTWFJWQmwxbTRlYk9EOUxu?=
 =?utf-8?B?Y3JQY21zU21lKzNTL0xHUGk1M1Q3UVhtY1oxWGRVK3N5WUwyN2M3RUF5bENq?=
 =?utf-8?B?REVlcHFPekJkZGVNc1FiVlZoTGNrWUthVVFkMjZhcFZORjl4bFJBZjNzcjVC?=
 =?utf-8?B?TmQ0N2xWaFVCRWJQcUtoWGJOcnNSSWp2cVRncmJaTmJhMC9kUXFKUXRIek5y?=
 =?utf-8?B?WXFZTnY1Y0JoTWs4VCtnUVc1ZzU3Q1BNMStBdmFNRkNzeitYVmxwY2ptV0g4?=
 =?utf-8?B?TlJSaFZwR3pKQ0J0MmZDMEZjckZ1RWdqdXRTZGtFQUZKd2lxQnc2bWJIWlB1?=
 =?utf-8?B?dnQ5RVhhcmFBUkEwZ3dta05rMDZuM0w3d3pabVBOeGVjSTZkZTVGOVJuR284?=
 =?utf-8?B?ZXFFcVpBeWR2emN3anE1dFpMTUlUQ08zQk45K2RBNDhYOWR1ZFdvbnErQnpX?=
 =?utf-8?B?b3ZNZ21JVS9VcGRMSlJPdUpzTThyK0hsbmpmMTh6QmRMdmloQ2xnL0RVc05T?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd29dd8b-c05f-43bb-6783-08db654767e7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 22:02:36.6341 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fo+B/aRvxooAKI0Qt8PsLojdE6az4x2y7xRWsWS271kO7F1Fgc9hVxZT4OhIjQzHW7EzRIyFMrrqgr12zaswZCZivCeDqzoiAdejJu5tQoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6485
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/4/2023 8:34 AM, Eric Biggers wrote:
> 
> To re-iterate what I said on v6, the runtime alignment to a 16-byte boundary
> should happen when translating the raw crypto_skcipher_ctx() into the pointer to
> the aes_xts_ctx.  It should not happen when accessing each individual field in
> the aes_xts_ctx.
> 
> Yet, this code is still doing runtime alignment when accessing each individual
> field, as the second argument to aes_set_key_common() is 'void *raw_ctx' which
> aes_set_key_common() runtime-aligns to crypto_aes_ctx.
> 
> We should keep everything consistent, which means making aes_set_key_common()
> take a pointer to crypto_aes_ctx and not do the runtime alignment.

Let me clarify what is the problem this patch tried to solve here. The 
current struct aesni_xts_ctx is ugly. So, the main story is let's fix it 
before using the code for AES-KL.

Then, the rework part may be applicable for code re-usability. That 
seems to be okay to do here.

Fixing the runtime alignment entirely seems to be touching other code 
than AES-XTS. Yes, that's ideal cleanup for consistency. But, it seems 
to be less relevant in this series.  I'd be happy to follow up on that 
improvement though.

Thanks,
Chang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

