Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE59C7EE22
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 00:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683592316;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aU5F1hyKUiwQ0TcqMVpamMmSKzZePMoZNHtMWpFzt3E=;
	b=RpIKBTFKjAzZmXVgJumWUt1wm9RiwEuSPeWDleWr2lzEGu7N5LJNGad+VTznXdK7CBgsrE
	6NYVNuvbkY1fuuvzr61kPaaz4OY393Mkj9pp5cQCUFMc36HEHsnPw43TOwRSSaeq7IB7rH
	0jrGJcDbTO7Hb6kBcg/2Qk9ZyVw3GTE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-lIjN4hSLMjy6c9Ns5Wa6kA-1; Mon, 08 May 2023 20:31:55 -0400
X-MC-Unique: lIjN4hSLMjy6c9Ns5Wa6kA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCA532814259;
	Tue,  9 May 2023 00:31:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A93821121315;
	Tue,  9 May 2023 00:31:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7BD5E19452C5;
	Tue,  9 May 2023 00:31:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3931419452C4
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 May 2023 00:31:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 224E51417202; Tue,  9 May 2023 00:31:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1917C14171FF
 for <dm-devel@redhat.com>; Tue,  9 May 2023 00:31:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB83B86BF46
 for <dm-devel@redhat.com>; Tue,  9 May 2023 00:31:51 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-aQhmwL9_MdC3chD4Frfu9w-1; Mon, 08 May 2023 20:31:48 -0400
X-MC-Unique: aQhmwL9_MdC3chD4Frfu9w-1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="436100469"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; d="scan'208";a="436100469"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 08 May 2023 17:31:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="692775031"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; d="scan'208";a="692775031"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
 by orsmga007.jf.intel.com with ESMTP; 08 May 2023 17:31:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 17:31:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 17:31:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 17:31:46 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 17:31:45 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by BN9PR11MB5242.namprd11.prod.outlook.com (2603:10b6:408:133::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 00:31:43 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::cfb2:e73:907d:cb77]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::cfb2:e73:907d:cb77%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 00:31:43 +0000
Message-ID: <e9508862-1fdb-d27f-8138-3b7691671405@intel.com>
Date: Mon, 8 May 2023 17:31:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
To: Dave Hansen <dave.hansen@intel.com>, Eric Biggers <ebiggers@kernel.org>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-8-chang.seok.bae@intel.com> <ZFWLoOZZTnBrid+7@gmail.com>
 <1b2eb485-2320-b33b-a0ac-53f7cb170adc@intel.com>
 <8748511c-cf9a-f3ce-e560-d0646dc3d108@intel.com>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <8748511c-cf9a-f3ce-e560-d0646dc3d108@intel.com>
X-ClientProxiedBy: SJ0PR05CA0170.namprd05.prod.outlook.com
 (2603:10b6:a03:339::25) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|BN9PR11MB5242:EE_
X-MS-Office365-Filtering-Correlation-Id: cd45822c-d526-4518-029d-08db5024c370
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: fTNElw/6lvRMvc0B08EnyO96sfAY8paHYUvmL0khEHdrfFlPcxBtyOzuSt/zwCP5VXXjKlcPB+lEfCltIZjiGXO7P1WMgoQuUyuvNDWNTQFQD1K7JkUy2rMxgelBHMEtazHgm4llfhl/9SYBt8DJtWc4f/WVAAWmCtx9nYTQZBe6InLi3Z2U4MOTuxmlkd2tUFnKZOVsc4biJ2gom14qexw2Xq26HFRylZsZnA2hvLFfEGVQQ/ZjrH8N72rUgBa+YwdN7d0nrRbaoPpKYGtFGfGvpdYcr5jR3fGpNhCgx7T9GFy4ST4EkiIIOZKotrfq08oC0d/zVE4R5lCcLp0jzNp/TgUyAA4v7+nqKatAnsshzBaKs9OK9WFrzMIo2UWPJuugn5Pe99X+n2ttMJBeNxnKsrdFInkwmbYatql7EphVr034CksX7its5r+31VGf9JWqsPNRD0ZrvqNBP6nYb0JaK/ciZJT4MGV0AeYCdkMB5aVZQxR2yA9jODP0p1Is4963VCkQ9hRsbXR8BDk4l6SdsRZEbTtWBYrVXzKeMIsfJmzS6FIQ47NaNr+5TC/4U+nDN+jEvvDaD7C55V9iA+qzn9sLPmaEGmZEZ22U0ciQvGsBpfi8HTMFgF6pPFaqr8Y27oMb4B0SK1YMtz7gFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199021)(31686004)(66556008)(66476007)(478600001)(4326008)(110136005)(6486002)(66946007)(316002)(54906003)(86362001)(36756003)(31696002)(83380400001)(53546011)(26005)(6512007)(6506007)(2616005)(7416002)(8936002)(41300700001)(2906002)(5660300002)(8676002)(82960400001)(186003)(38100700002)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGU1TjRkM2hBR21xSElNSkJLUnpDcmpXWitSVHF0TTV6ZkhsSmFKeDJBNnk0?=
 =?utf-8?B?VFhpVmZVMlBTZHZITUNIeFRXR0tFem9nRHBkajc3bTNhc2IvYXh6SE5jRE5r?=
 =?utf-8?B?aWpYWmpHZG5IS2I4MTNBbmZJcDRNKy8rbnl5bHA2TXJEbDFDOVpVdzRKNkc0?=
 =?utf-8?B?QkpxQVVUOTRKREUvR29UMHFYSlBDcFRkcXBsLzluVW56QzNOZmhVaElWQnRH?=
 =?utf-8?B?aTJ1b2d5NEkvL0xvUjNmbm5LRGRONGd0aldoNlJMRXRyYVFLSUlDVzNGVW1K?=
 =?utf-8?B?TE1RWXNiTEs0ZGJ5cjRQRFJ4b2ZaM2QzTUdJK3R2eXVsTWlXTXd0TkdpY0xY?=
 =?utf-8?B?SU03TGx2VzM2dEFqYk90MUNmaG9LNlh6WDdpSEFXbmVJbnlLTHcvQ0FzSUhy?=
 =?utf-8?B?MnIrTjk0R3V0dGluNDlpZjZsN3I2Q0M5N3Z0aVltU3h0MGc1b204YWFBTkVv?=
 =?utf-8?B?bFlEd0g5UTdwR2JVM2NHRXZwNUNpSTM2YVZOQ0RmTWorRk53WlFFcWxjN1I5?=
 =?utf-8?B?Y3NWZDRoQjRGNExJWlFjRXJFdnVVUlV0cThKYkhINDBNenNmSWpXby9DODVy?=
 =?utf-8?B?YmZ3NURYZUIxUnhnTFNETE1FYUpybXZvbEdxSmhkRkVCZGlBN1gyOHVqSFpw?=
 =?utf-8?B?L2o2ZmVLUFJFUWlIYSttb1ZCdStaL2Q5aE5Fem41MTM2NFM4SGIvZW5tZXFZ?=
 =?utf-8?B?dFNXd3FYOGk5cHNFb1BNSjBUdi90cWUvYTFCTzBYTjdISmMvaU10Wi9DOENz?=
 =?utf-8?B?MU1hTHoyQjhXdm85OWxRZEJSS1c4Z3lHT3NDMGNCc0wzSVhEc2hXc0s4aWZk?=
 =?utf-8?B?QjIra3JMYTRrNEx1cTlwV29NdlMvZnFURmVmVk9UejdYR1FSTVBHU1ZMQWxR?=
 =?utf-8?B?VlVvcnc0M3NHSGx0NEhjUVAxSjE2OVVCUWZyQUR6WldUSFpjcm42emRDZnpk?=
 =?utf-8?B?S3J6akZSTVB6eHltbDFkRUx1QzlFYnYvVmtiTnd1eEZyUEJRd2cvelBqdEVz?=
 =?utf-8?B?ZTdZakNyemZtSVc3RDhNNG8vZ2VlektlcVgvdjdoNHlyUEdUcWJsSC85Z1Av?=
 =?utf-8?B?QUlENXorQUQ3NGdSV1lING1kVTZVNUVQRTBENDdYSEhHSzFVbnZrejAxaEpl?=
 =?utf-8?B?TUtKbC91UDhmTE51NFh6b295dmY2cEwzUE1LMmZPanovdlJNc2FKK21zdXF3?=
 =?utf-8?B?bXVPbTZ0TVppRFpRTkFGazd4OG9uSnp6S2RsbHJOYXdIblNySFFPQ2J6cnJD?=
 =?utf-8?B?VE5abEFwTjNFZytaQTh5Zi9RYjR6bVR1dDRpaEc2UFJqMGhISkdSTmpqNjZO?=
 =?utf-8?B?cks5NDdlWUwzYTlUaVVlQmd4YzFDaGNVcVcvZUN6UHlZTlppMDFCejNKQTFa?=
 =?utf-8?B?Y0RMOFdMVnZXU0NtU1Zod3FDY1hZMlBaL01wTTVnWkw4NVJDVXVnbXdkOTJq?=
 =?utf-8?B?RmJFblhPRFM2MGJUTzJOc2xTSFZyTmRhbnFjWUUza1RXbDdOOU80TWMvbHF3?=
 =?utf-8?B?ZjE0ckg4Z29MNGJHM1pmZkNYNHNLSnNTSmZaL1ZWaGROZ2FBUjF5RVRMSlRs?=
 =?utf-8?B?QjAvY2NEblFhc0FIc29LQytaVWVtTzhlaE52UklhNnV5UmxmNjErZy8vV1lK?=
 =?utf-8?B?NHRJWW1WZXlYV3BrZHJncjRyRHZRd2pScWR2N1dOUVIzS2lJcmh3WlloZXhM?=
 =?utf-8?B?cUVPMDFINTBJWTFGNytWZ0NlMndLOHRCbFk0c0NnbUZpMWRQWHpnUEFFS3ZH?=
 =?utf-8?B?eTRrc240ODgyYjB0MW9rZWF5cW9IdzM4MTRYRnpkZlhwcE1Vang2UmYxM0oz?=
 =?utf-8?B?NUl4c0hjdGJGZnNNNUNKK0NyUE9SdHJZSTFyeDM1TG0yelF4bnlTMXBQU1NK?=
 =?utf-8?B?MnRwTkNtaXZaVUgxL0xwKytPQWNaNGQ2RHk4bHRRTStXNzd1ZnY2TVVLU0Nv?=
 =?utf-8?B?RWhWZnk1NU1RSkpsNnFNL2gyKzJiL2hpdUo2bW50V3ljdjZpR0o0VEd0WVFB?=
 =?utf-8?B?NDVxSUdOWFE3cFduOEw4NFJtaWtYbjVtYVE0WWNTR010K1ZmYXhqUFR5NGs1?=
 =?utf-8?B?SXdYeE1qd05LMFB2aXdwa0lGNXBDSlpZcHZubjVyYU5hSkQ3L0c0WnplRmpT?=
 =?utf-8?B?QkZtMUo4RERDeDVEVGZyNmVJQWh5TStSM3BEN1lKTys4eklidmgxUExxZmYw?=
 =?utf-8?B?Rnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd45822c-d526-4518-029d-08db5024c370
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 00:31:43.3789 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6nRd8Fq355H87Ez+6piZv2qJ/TKfMUcrai9G8ouzUXsAjdgKtuobNwogdoAbp7bIUvB+BDiQe/RVsS1m7WB/mk0oCnOXt4VF1I4vYVskBh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5242
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v6 07/12] x86/cpu/keylocker: Load an internal
 wrapping key at boot-time
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
Cc: x86@kernel.org, herbert@gondor.apana.org.au, ardb@kernel.org,
 dave.hansen@linux.intel.com, dan.j.williams@intel.com,
 linux-kernel@vger.kernel.org, mingo@kernel.org,
 lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 linux-crypto@vger.kernel.org, luto@kernel.org, "H. Peter
 Anvin" <hpa@zytor.com>, bernie.keany@intel.com, tglx@linutronix.de,
 gmazyland@gmail.com, charishma1.gairuboyina@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS84LzIwMjMgMjo1NiBQTSwgRGF2ZSBIYW5zZW4gd3JvdGU6Cj4gT24gNS84LzIzIDExOjE4
LCBDaGFuZyBTLiBCYWUgd3JvdGU6Cj4+IE9uIDUvNS8yMDIzIDQ6MDUgUE0sIEVyaWMgQmlnZ2Vy
cyB3cm90ZToKPj4+IE9uIE1vbiwgQXByIDEwLCAyMDIzIGF0IDAzOjU5OjMxUE0gLTA3MDAsIENo
YW5nIFMuIEJhZSB3cm90ZToKPj4+PiAgwqAgKyNpZmRlZiBDT05GSUdfWDg2X0tFWUxPQ0tFUgo+
Pj4+ICt2b2lkIHNldHVwX2tleWxvY2tlcihzdHJ1Y3QgY3B1aW5mb194ODYgKmMpOwo+Pj4+ICt2
b2lkIGRlc3Ryb3lfa2V5bG9ja2VyX2RhdGEodm9pZCk7Cj4+Pj4gKyNlbHNlCj4+Pj4gKyNkZWZp
bmUgc2V0dXBfa2V5bG9ja2VyKGMpIGRvIHsgfSB3aGlsZSAoMCkKPj4+PiArI2RlZmluZSBkZXN0
cm95X2tleWxvY2tlcl9kYXRhKCkgZG8geyB9IHdoaWxlICgwKQo+Pj4+ICsjZW5kaWYKPj4+Cj4+
PiBTaG91bGRuJ3QgdGhlICFDT05GSUdfWDg2X0tFWUxPQ0tFUiBzdHVicyBiZSBzdGF0aWMgaW5s
aW5lIGZ1bmN0aW9ucwo+Pj4gaW5zdGVhZCBvZgo+Pj4gbWFjcm9zLCBzbyB0aGF0IHR5cGUgY2hl
Y2tpbmcgd29ya3M/Cj4+Cj4+IEkgdGhpbmsgZWl0aGVyIHdheSB3b3JrcyBoZXJlLiBUaGlzIG1h
Y3JvIGlzIGp1c3QgZm9yIG5vdGhpbmcuCj4gCj4gQ2hhbmcsIEkgZG8gcHJlZmVyIHRoZSAnc3Rh
dGljIGlubGluZScgYXMgYSBnZW5lcmFsIHJ1bGUuICBUaGluayBvZiB0aGlzOgo+IAo+IHN0YXRp
YyBpbmxpbmUgdm9pZCBzZXR1cF9rZXlsb2NrZXIoc3RydWN0IGNwdWluZm9feDg2ICpjKSB7fQo+
IAo+IHZlcnN1czoKPiAKPiAjZGVmaW5lIHNldHVwX2tleWxvY2tlcihjKSBkbyB7IH0gd2hpbGUg
KDApCj4gCj4gSW1hZ2luZSBzb21lIGRvcGUgZG9lczoKPiAKPiAJY2hhciBjOwo+IAkuLi4KPiAJ
c2V0dXBfa2V5bG9ja2VyKGMpOwo+IAo+IFdpdGggdGhlIG1hY3JvLCB0aGV5J2xsIGdldCBubyB0
eXBlIHdhcm5pbmcuICBUaGUgaW5saW5lIGFjdHVhbGx5IG1ha2VzCj4gaXQgZWFzaWVyIHRvIGZp
bmQgYnVncyBiZWNhdXNlIGZvbGtzIHdpbGwgZ2V0IF9zb21lXyB0eXBlIGNoZWNraW5nIG5vCj4g
bWF0dGVyIGhvdyB0aGV5IGNvbXBpbGUgdGhlIGNvZGUuCgpBaCwgd2hlbiB0aGUgcHJvdG90eXBl
IHdpdGggb25lIG9yIG1vcmUgYXJndW1lbnRzLCAnc3RhdGljIGlubGluZScgCmFsbG93cyB0aGUg
Y2hlY2suIFRoZW4gaXQgaXMgbm90IGFuICdlaXRoZXItd2F5JyB0aGluZy4KCkxvb2tpbmcgYXQg
dGhlIHg4NiBjb2RlLCB0aGVyZSBhcmUgc29tZSBzZWVtaW5nbHkgcmVsYXRlZDoKCiQgZ2l0IGdy
ZXAgImRvIHsgfSB3aGlsZSAoMCkiIGFyY2gveDg2IHwgZ3JlcCAtdiAiKCkiCmFyY2gveDg2L2lu
Y2x1ZGUvYXNtL2twcm9iZXMuaDojZGVmaW5lIGZsdXNoX2luc25fc2xvdChwKSAgICAgICBkbyB7
IH0gCndoaWxlICgwKQphcmNoL3g4Ni9pbmNsdWRlL2FzbS9tYzE0NjgxOHJ0Yy5oOiNkZWZpbmUg
bG9ja19jbW9zKHJlZykgZG8geyB9IHdoaWxlICgwKQphcmNoL3g4Ni9pbmNsdWRlL2FzbS9wZ3Rh
YmxlLmg6I2RlZmluZSBmbHVzaF90bGJfZml4X3NwdXJpb3VzX2ZhdWx0KHZtYSwgCmFkZHJlc3Ms
IHB0ZXApIGRvIHsgfSB3aGlsZSAoMCkKYXJjaC94ODYvaW5jbHVkZS9hc20vcHJlZW1wdC5oOiNk
ZWZpbmUgaW5pdF90YXNrX3ByZWVtcHRfY291bnQocCkgZG8geyB9IAp3aGlsZSAoMCkKYXJjaC94
ODYva3ZtL2lvYXBpYy5oOiNkZWZpbmUgQVNTRVJUKHgpIGRvIHsgfSB3aGlsZSAoMCkKYXJjaC94
ODYva3ZtL21tdS9tbXVfaW50ZXJuYWwuaDojZGVmaW5lIHBncHJpbnRrKHguLi4pIGRvIHsgfSB3
aGlsZSAoMCkKYXJjaC94ODYva3ZtL21tdS9tbXVfaW50ZXJuYWwuaDojZGVmaW5lIHJtYXBfcHJp
bnRrKHguLi4pIGRvIHsgfSB3aGlsZSAoMCkKYXJjaC94ODYva3ZtL21tdS9tbXVfaW50ZXJuYWwu
aDojZGVmaW5lIE1NVV9XQVJOX09OKHgpIGRvIHsgfSB3aGlsZSAoMCkKCk5vdyBJIGZlZWwgb3dl
ZCBmb3Igc29tZSBwb3RlbnRpYWwgY2xlYW51cCB3b3JrLgoKVGhhbmtzLApDaGFuZwoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

