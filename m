Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECFF3C77B73
	for <dm-devel@archiver.kernel.org>; Sun,  4 Jun 2023 22:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685916857;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=q1cUfLulvrsRE7Igc7QsfIXM4vPFClKETcwQQPPZcj0=;
	b=QFUYiybbMPwf2lXVcAvsBECF75q1Y+lrUI2u3ICm8OEWhCCsm+KsRrU17dAghgksVMgFr3
	GUC73Z6/RouROVCYWonhRG9y1CaloBd/Uc2Fq0FHFA/ffMdkzxhZugY+0xzCAP1xWfAnyr
	yQQFMGhCJ9JhY/7YpIYgSnjT23DBlak=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-85VrfB73OU2wv8g6ZvC3dg-1; Sun, 04 Jun 2023 18:14:15 -0400
X-MC-Unique: 85VrfB73OU2wv8g6ZvC3dg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EC6D8007D9;
	Sun,  4 Jun 2023 22:14:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4BE62492B00;
	Sun,  4 Jun 2023 22:14:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 19AED19465A0;
	Sun,  4 Jun 2023 22:14:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B066E1946595
 for <dm-devel@listman.corp.redhat.com>; Sun,  4 Jun 2023 22:14:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9A1D9401029; Sun,  4 Jun 2023 22:14:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 90FC8492B00
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 22:14:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7219B101A52C
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 22:14:03 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-lRQ0505ZNkqd3gWlDPC6gQ-1; Sun, 04 Jun 2023 18:14:01 -0400
X-MC-Unique: lRQ0505ZNkqd3gWlDPC6gQ-1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="335854612"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; d="scan'208";a="335854612"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 04 Jun 2023 15:13:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="711586224"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; d="scan'208";a="711586224"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
 by fmsmga007.fm.intel.com with ESMTP; 04 Jun 2023 15:13:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 4 Jun 2023 15:13:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 4 Jun 2023 15:13:59 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 4 Jun 2023 15:13:59 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by CO6PR11MB5651.namprd11.prod.outlook.com (2603:10b6:5:356::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Sun, 4 Jun
 2023 22:13:56 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::a41b:1b6c:8306:7644]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::a41b:1b6c:8306:7644%6]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 22:13:56 +0000
Message-ID: <5300deff-9967-d67b-91f4-6f47cf9f12ce@intel.com>
Date: Sun, 4 Jun 2023 15:13:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Borislav Petkov <bp@alien8.de>
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230603152227.12335-1-chang.seok.bae@intel.com>
 <20230603152227.12335-10-chang.seok.bae@intel.com>
 <20230603163751.GBZHtsXwW5UUnsSbKX@fat_crate.local>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20230603163751.GBZHtsXwW5UUnsSbKX@fat_crate.local>
X-ClientProxiedBy: SJ0PR03CA0192.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::17) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|CO6PR11MB5651:EE_
X-MS-Office365-Filtering-Correlation-Id: 0762f9f6-b156-4927-a8bd-08db6548fd09
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: GTiKNywK1GL7TGDd+5W6oJ9n8vWvxFtn24WKh/fXXGR9tzXRiZ3cbNCyRZxlB7pziR7QVIWbY/YnDYEzlAOcq+d9VYETM/WxJYg7eqnqx4neh6xajYOWIeNqZppmmJvbH3FdcjuXKvb2hsCZaTtYQJ/TCqGGlaYR1hQHEVbDQ3WB9FWkT6zkPwe5emPKUZAAxzaoc97KIy1nITlKaTWPvMTe4DKGmSNqrSk3u8Jz5xErqglRnxIDijaE4tfFLYwXlbhu40lcontDX9dnEYX7oOU77nnoykUr/IINR4lbhtDzO2tpJYIgTXBHgXU8t2S0lk8SgaF5u1fyQWh0u3Vdb2FcA87aomYGOXXeJaTeWudJbzL7mAmV8TaN25AHQhA9PNPlAGQ+VUTCqg/XO0uxOUjWliziWALdRV/SFS+4js0wIGvOMfAqj81n7wh83RsN0vRgRln71+zgDKAOppMnrQSxYrD1UgX2ub4iRoXoLG6Jas5xmjKYojdpexspqCPyp0GfOPDjXKMp5j41B9xfw3I03RLZeTDLCFFAX0FDCN4d2NU5EEfWT9hFrhAFOCFrE027EoGI5rSI6AVccLxIABM6KpvvNPppD4wWT+bGVOla8F++oK1Xm0h3A10f1RoNqS7QinQbieTpotyFYVlrIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199021)(7416002)(26005)(6506007)(6512007)(31686004)(53546011)(83380400001)(2906002)(36756003)(186003)(2616005)(5660300002)(31696002)(86362001)(8676002)(8936002)(316002)(4744005)(41300700001)(6666004)(6916009)(38100700002)(66476007)(66946007)(66556008)(82960400001)(54906003)(4326008)(478600001)(6486002)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWx2UnlmbmpsZ0VSdHk5eWQ2OUMyYW5pQ0JnNStYSHdUSUtpcUhHRUo4Q1Mx?=
 =?utf-8?B?WXRTcXhmaW9jOUwyUEREdnlzRzhVcjl1Z0xaRU5BWCtqc0Rkc2Z4K05VQzJ1?=
 =?utf-8?B?bEY5RDV6S1AvN3dtSW1GVnNITWUxb2gzYzhSV2dNdW1BZyszR2lXbSs2OWhw?=
 =?utf-8?B?OWd5M2N5emljYzMxbDNIQUdwb3BZK0lWVzRYeVRFanNRYTZ0bFZDNVd4MTdE?=
 =?utf-8?B?T1poZVFnai9yTVBrWXBiR1RvWkdhUmFhZFRrNVBrcGRXU3pFTWJQU24weURZ?=
 =?utf-8?B?ODUyTjdQNEFkeXlRbXZWamtyTzErc2RHcFB6R0g3RHlYQmE4cjJKYlZYOHdM?=
 =?utf-8?B?WHlQUFo4ZklXQnFFeGZMek9pS0RNOStSVXB4SytLQjVhSUN0SGwraGdDOUZn?=
 =?utf-8?B?d01IMUhsVFlpdXA5Z20wTmZtNnZxVmJtRDY3VDYzR2xTTHJpbGRBYy92VlJ6?=
 =?utf-8?B?d2FZT0lDNXVjSHVpZWFxZmRpSlhCUHljZDVmVnhZY2xoUXhYMm1ULzBrZHFC?=
 =?utf-8?B?dlhPQkVnTUZCMmRQcldIMUhJYnBYT1J6VEk3bUhvenNSNDJVbGlsMnl0UWg2?=
 =?utf-8?B?dFdBSWNHVmdXUC9lOHVMZlh3Vm5pemVXeFlYenhXR2xHZjdhblNxQ3lxR2FI?=
 =?utf-8?B?c0FIZVZuLythYVpMNzlZdmVyK1pWTStacTZ0dEloZmw3S2ZlZnZxbEtEWlFF?=
 =?utf-8?B?eGxSY25OWTBiNDVkRjNOcFN3STlkTWtLTWlIYzhFT1VRUlRKL0VvNU8yNktN?=
 =?utf-8?B?Qmx2ejZObVZsVGo4djNrUXhVM2dSRDlZaU1FN0NLRzVVd3dWMEFEOUJiTlJZ?=
 =?utf-8?B?eXZScVB2V1dQOWpDczdNUFViNjRMSXViZmpmcDlmZ1J4NGtZM2FLRTl4eDlS?=
 =?utf-8?B?VHhaYml6R1pLUytxT0pNTWhQb3hUN1k1VTgxMDJaSDRxTld4UUQ2YnFVRGF5?=
 =?utf-8?B?Z05UaDRTekw4U1JoTFh6a2I0S2xUMlBLR1VuNWZHUFBHeXZ1Ui8xQVVGcW9N?=
 =?utf-8?B?K2IreWNEYytQTTBvakpPODFWMGVoQk9ieWNMR014SzZtK2hTY0xOemlkMHdW?=
 =?utf-8?B?NnEyR1BxWjBGTjdWNitSVG5ybk5DS3Y0NTdNTXJPblE5MjI2Z3AxbmtZWGxY?=
 =?utf-8?B?dStFUTNnMzZENGp5WmlkQkF5TTg0dDBLQU1uVEZUb1RCSTV1SG5QM21MUXU0?=
 =?utf-8?B?RU9pRUdNbkpHS1FaSDRSQ25GWE9hQzhFUFZTOTg4QS8xZTBqSXB5ZEkyVzV3?=
 =?utf-8?B?R2x2Zm5XUEN1NjIxcHFaQmltNHptRGhSUG4vTitpb29kNzRWckU0RlhLOXNq?=
 =?utf-8?B?Vm4vQkt5aTNYQnNHWFJISlJCbnZlbnY3UFhtOG1uKzZ1UG5vR2d5NHlHYzhm?=
 =?utf-8?B?R3RWYnJoZmxCZjlqRWVKNFcyWmFZU1lBMHlOemhkcG8ycDhQdjlYMk1EY050?=
 =?utf-8?B?dTI1dFhBbk9Vc1p6aHN3MzJ5dWRHODhPcHhMUGhMWm41eWNvdkxWbmZyOTVH?=
 =?utf-8?B?SzFlQW1XeWlqK1FVWVd4SWtRdlRNWmg4M0pFVEp2YkNaWitmWXVYUmxqcDRN?=
 =?utf-8?B?TE05cnJRM29RL2Z2MHVmZ1ByYk1xRTZ1VEh1YUYyTm4zWHpkbjBtbHBoWE4y?=
 =?utf-8?B?Z1MzaXdCaTNKNGdZbkxFNWFvdWFzRnBYOW45OHBvZlZUamppYkRtVE82MWJU?=
 =?utf-8?B?OWxWek4xQWZURWRhR3FqWVJ0TzREckRkYmZ6Q3hkQW9mQkFJb2dEeHpIS1FU?=
 =?utf-8?B?SHdOc09ISllJT1VvMXZXRjlxdk5OV1RwaVhqSE1TeS9qQnJOTlJwN0hyZFNC?=
 =?utf-8?B?NzYyTnlVMElYcjRMQkJqV2ltNVYyTm9NOUYvWTdaeGxOSklObTNLYjE2UlJS?=
 =?utf-8?B?UlZEWFg0bm5oTEx5eC84L3BwdVdqOEErVEJtRzFvWnlhblNVNTRsMS9WeEZM?=
 =?utf-8?B?dDBkOVZuMEo5VFA1ZExERndwZWdSbkNqejBTOEg3eDNaOUVBbUxHS1ExMDVl?=
 =?utf-8?B?N1FYamJnOVorVUVXS040MFRYNldMRDcwQzl3UTBWRmNyZURPNzNVSXlkZVd5?=
 =?utf-8?B?MEdRaVBNU2tzNllFR1BtZlZqZWI5RFoxdGdNbjJ3MkVENlNVQkw1S0dhNzFq?=
 =?utf-8?B?RldzT3d4MUo1V0MyM1dsRGE3alVTeFpPdnpaOXhzTkdiN0VBZG1vWW1WQVFW?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0762f9f6-b156-4927-a8bd-08db6548fd09
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 22:13:56.4737 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: STmxYR3VzmkUXnGyIOSggcAIEHK51in5eVBWRfnneZ97uCvzVIivimCXZG5pqNYrkNsEGV83kv8TYeq7aAI2BRGrsYfIJAqWccsRdcJM3J4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5651
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v8 09/12] x86/cpu: Add a configuration and
 command line option for Key Locker
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
Cc: linux-doc@vger.kernel.org, dave.hansen@linux.intel.com,
 lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 "H. Peter Anvin" <hpa@zytor.com>, nhuck@google.com, ardb@kernel.org,
 herbert@gondor.apana.org.au, Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
 mingo@kernel.org, ebiggers@kernel.org, Ingo Molnar <mingo@redhat.com>,
 gmazyland@gmail.com, elliott@hpe.com, luto@kernel.org,
 dan.j.williams@intel.com, charishma1.gairuboyina@intel.com,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, linux-crypto@vger.kernel.org,
 bernie.keany@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/3/2023 9:37 AM, Borislav Petkov wrote:
> On Sat, Jun 03, 2023 at 08:22:24AM -0700, Chang S. Bae wrote:
>> +static __init int x86_nokeylocker_setup(char *arg)
>> +{
>> +	/* Expect an exact match without trailing characters. */
>> +	if (strlen(arg))
>> +		return 0;
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_KEYLOCKER))
>> +		return 1;
>> +
>> +	setup_clear_cpu_cap(X86_FEATURE_KEYLOCKER);
>> +	pr_info("x86/keylocker: Disabled by kernel command line.\n");
>> +	return 1;
>> +}
>> +__setup("nokeylocker", x86_nokeylocker_setup);
> 
> Can we stop adding those just to remove them at some point later but
> simply do:
> 
> clearcpuid=keylocker
> 
> ?

Oh, I was not sure about this policy. Thanks, now I'm glad that I have 
confidence in removing this.

Chang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

