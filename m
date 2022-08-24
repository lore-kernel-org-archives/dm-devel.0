Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49DB7C32774
	for <dm-devel@archiver.kernel.org>; Thu, 25 Aug 2022 08:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661415882;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kLfqaR/DSCdwW2G08NhsYVaNcd0olkD1md6xZQTvnkM=;
	b=O/LOMyBLXO2yWrzg/SnVBnh1lKOQrVM/TzdnvxDSmXMlhnPXIYFsSv2MRA0YJwJj0CuZe8
	s9ug70AFaQJAYu9UZqLGLV/8o7ravi8VeN7l32l+eima482bYj+pXbvWn8vAhAkT+VbzZo
	YzfAdK3f25q59qHlwd+BG9EnYzNsK1U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-mEiYTEaxMOeA1VI0QCbD3A-1; Thu, 25 Aug 2022 04:24:38 -0400
X-MC-Unique: mEiYTEaxMOeA1VI0QCbD3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C312B1C1394E;
	Thu, 25 Aug 2022 08:24:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF2C92166B26;
	Thu, 25 Aug 2022 08:24:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A24521946A5A;
	Thu, 25 Aug 2022 08:24:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 841E41946A43
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 22:22:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 55A2F18ECC; Wed, 24 Aug 2022 22:22:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 50F17945DF
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 22:22:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30C678032F6
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 22:22:19 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-NePewGrAOP-6XznOMlOiMA-1; Wed, 24 Aug 2022 18:22:17 -0400
X-MC-Unique: NePewGrAOP-6XznOMlOiMA-1
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="355815352"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; d="scan'208";a="355815352"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 24 Aug 2022 15:21:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; d="scan'208";a="678217634"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
 by fmsmga004.fm.intel.com with ESMTP; 24 Aug 2022 15:21:04 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 15:21:04 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 15:21:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 24 Aug 2022 15:21:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 24 Aug 2022 15:21:03 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by DM5PR11MB2025.namprd11.prod.outlook.com (2603:10b6:3:8::17) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.21; Wed, 24 Aug 2022 22:21:01 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::5d13:99ae:8dfe:1f01]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::5d13:99ae:8dfe:1f01%3]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 22:21:01 +0000
Message-ID: <763bddd2-2fc3-a857-0dff-a5ae4ae1f298@intel.com>
Date: Wed, 24 Aug 2022 15:20:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
To: Evan Green <evgreen@chromium.org>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20220112211258.21115-8-chang.seok.bae@intel.com>
 <CAE=gft4P2iGJDiYJccZFR1VnNomQB7Uo522r2gvrfNY9oKz5jg@mail.gmail.com>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <CAE=gft4P2iGJDiYJccZFR1VnNomQB7Uo522r2gvrfNY9oKz5jg@mail.gmail.com>
X-ClientProxiedBy: BY5PR17CA0052.namprd17.prod.outlook.com
 (2603:10b6:a03:167::29) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3cb0346-b3a8-445e-8472-08da861eed45
X-MS-TrafficTypeDiagnostic: DM5PR11MB2025:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: yw5Hplt1riAcImspqjqyWRzTECF2A3TDED+ouTPfOjRbZ/fj9gsI0JDrVvSMgR8VIEdH3M7SqXuc065ZYWeRAlEexJ4apG5RnruSAymBkbiSg+uWwLoAQNiFn34W+BFn2puChmFtmvT2I7st7x3qJM37R3qwKDyFS6fGsjFa/2T+QrtQp+LIhq8MSrzkCB/aWDTr37ghptUq344w0AFYYhmSJM8fTJ9/ZFASIeIlti4EejIkHae94i3VovgqhrbIU+i6YGbQfiThxetGWaxY+JCXbj0Yq0portvTPz80Cl3Il8loxDCnSjH7+yDEFmWf/ltjJivzPrsltqSCnMjGZdeEAr8KoPmhD0+vM9AfI+9MQ+ufVoIpjnzW1TPdbJGnDqikDh6FCQ+i4ovpCOXD4S2Oh+I3qX7rjB6FKZ1SxESF+ZWPjpmsv33oLmSbak+G1GP47kzxUNTjPRSykQML+hYiSsRaVz/+gBaDw/YIii5G9QU77yDwZk92+20j3mCgZKe3bFzDRtkur+mNj0fhKuZrjsRU58wJkNovj6960WxXI7nUXLNXWu8joqtc/NMRn6SLAlktX6ZpiJzqBIFB9/QhG/KKiyyc03tlrRSwcxFdzZNFVZYzT33vg5doCRlBwMF+7IXzNSuInkmb6qz/0TOkb0BNyIby/5HZA6R9ky/uM98zePGPfhhqhwrGLpbwFtVdJsDy9dTNrmRz/kHdI7LkY/8Je4O38JhyxuXtyczGv+4H2W6Fz5wt78ZFw1+AT3m1YeJr6glDkjFGbaI1z5Ry1lObHS0UOx7vclzJFGdwgpPUtsLCnxY5aRnfZcI4
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(136003)(39860400002)(346002)(366004)(396003)(376002)(4326008)(2906002)(8936002)(7416002)(5660300002)(36756003)(41300700001)(478600001)(6512007)(31686004)(86362001)(26005)(31696002)(6506007)(6486002)(2616005)(186003)(966005)(38100700002)(83380400001)(53546011)(82960400001)(8676002)(66946007)(54906003)(66556008)(66476007)(316002)(6916009)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3RqUVRMSEVEeVdlNi9BRnBPa1U0bFd5YTN5MlY4T2JXaU1jMWZKQ01LN2c5?=
 =?utf-8?B?Sm1QdXBEN2x5bDBlRUJZSnE5NXl0LzIxd0c2VitMcWlaSWNaRUhCUDMrS3Bk?=
 =?utf-8?B?ZlQzWi80VXl5bjRrRDVnWmsxMG95dlVwUjNUdTk2Rm93MGFGdjg1MmdrQ3ZL?=
 =?utf-8?B?WnNuWjY5ZDZKMGZmNUppaUVNSnYyN2QwU0ZQNXp1a2NvTDdxZXpVQmk5a3cx?=
 =?utf-8?B?M01NSlNDSGJOc25jY0dLVmRUZlpBbVRPcy9KQVpZNjI1TTVHbTVxSFYzL1hi?=
 =?utf-8?B?L1hDTXNza2pLaVIyTFlDS0hBR3ZFZDdNNlJ3VHVhSlFzZGxDU1FvNHBwRjRK?=
 =?utf-8?B?TEMwcXE2bzQ2cEU3L2RkWVN5SXRUSk1NdjZGVFh0QWtwQUpERkNFZ3JoV1Fw?=
 =?utf-8?B?V3dHSCtDM25IeFFnRTFXQlYzM2YveGVheXcxaTB1MkpaazV4VlVwRUJkeTg4?=
 =?utf-8?B?cm1XZVp2cXVmMTFFaTg4WXM5SDRzMU5VMlFMcVB2cG52MTMyLzM4d1A3c3JQ?=
 =?utf-8?B?OXJsaWVnUDlhYzJGNzYvUVI0b1VRRk5IbEw5TkxHMzRCR2ltajNmNjRlakRx?=
 =?utf-8?B?NDVoNmR2cDE0eGhERjc0THA4MUJaalhvVGNULzlsbTRESFFjMVpDWHhGR2hU?=
 =?utf-8?B?L3JubXVxaExjTDNiSEQzb0FGamZ0Z2ZTaVUxNzNwcjdvai9CYmwwSHFkb09H?=
 =?utf-8?B?aEdQVmNoKzZ5dEZ3VGVRMHdMOGV2ZDdwa2xOZFFMVy8wVXIvQkg4cEJ2RVVr?=
 =?utf-8?B?Wk1jZzZwcjgvL3pTUlZkUzh6bkd5bS9na3VKeTdLTFBIVnVsZ1htck5VVDVx?=
 =?utf-8?B?ejJzVEltcUVzNVEzeEZlMHE1MmV2TXFOdzhENGtsTTBObGpTYStUUi96Y0oy?=
 =?utf-8?B?TzVIeHo2MzBKVVJ4cVNKUWo3SVIrWG4xdmkxUFd2NHloTFJSRUE0b01mRkVY?=
 =?utf-8?B?bVRzYTc3ODlkZHEvTStncGNYRGFZYUU1TGlVblhzYmQvUTZSdjRwMGNmNUZq?=
 =?utf-8?B?S3I5MVM0elkxK0RxTG1MMWU5SVQ5VjBEMVhzK01kbTVlckhLWE1NeWpLa3Bk?=
 =?utf-8?B?VUlJSmhwTTErdmZkRGVWWStneEJmRTFqMm53SlN3dEJ1S2hlRlBObHlia1ZZ?=
 =?utf-8?B?Nkt0NmtHb282L2wvaEVBa0lGOTRESWdjTGFWQ05xN2E2WU1MWFg2WlM4c2Rx?=
 =?utf-8?B?T0VRNkhnaXlGOTEwWllrTi80cEdONURka3NJOHR3aDhCTU8xRkh3Tlh6aURy?=
 =?utf-8?B?NE5DRTdPSjZzQm9OdENCQmY3b3ZPeTZEcW4yY01MYmxxRG9jUWtvTGM5Yk9O?=
 =?utf-8?B?T3hSWGJHVXF6M3Z4Yk9qUjc1Z1dkUE00d0sycjZ0Y0puZ2d2d1M1Y0pGTjZl?=
 =?utf-8?B?VGFvdXRodTBGc29XTWF0aWo1aVY2V2h2bm5ZekFVeUNTeElMTDYxL3RXc0RF?=
 =?utf-8?B?WUZzOXp0eHVLM3dxZVhCVCtHQTlGVWNYSEUvbkNJWmIvVzZYZEZ1MitxNmdQ?=
 =?utf-8?B?T2o2V01XSjZtTXp0OVZvcFhqSkdsbWFnSEx0UGxzeWZtS1QwelpCVFNZK254?=
 =?utf-8?B?cS9YR1dzVmtBNWlCZ0ZlcFQ5SWwwK3lOOU94N2U1U2tPY3kxT1g3RTk0RHdT?=
 =?utf-8?B?Z1lrZFVLZkpWUmdVVVZVTVFJK0tZTnp4bjY1MjFXdG8vZ3ZBWjFHa0Q1ZC9G?=
 =?utf-8?B?UVFnNzJqdHNKckNLUFpVd3RYdlBBTmFTRC94SmhIL1d3Z2hDdnBzbnc3S0lt?=
 =?utf-8?B?Q21HR25WdHlXZTVmak9iQUpPQjkvTmVNeklERXloa2oxdEhvS2RKb2d5eGZX?=
 =?utf-8?B?TXNkbGNXa3FiUUhBYit1MWRwdVdRQXU3SHRjbWd0V3pZZHVUNWN4cFFXRmF5?=
 =?utf-8?B?alU1dUJ4bXlrSXVPQzl3ck9XamJMOWl4R3R4dDJVdkR4YlU3RkpRcnU4cXhM?=
 =?utf-8?B?MEN6OHlMNW4ySHJ3a0swUWRZVUd6WWlxOTh0azQvM1JBMWxWWVBZQTlMWlRR?=
 =?utf-8?B?WDVFMmdhY1UxYWVpUjNTYzVoVVZJS2hKcHlzVE9FclhHbFB0dnEzemoyYTd5?=
 =?utf-8?B?N0tsSkpVU3VjWmF5ZHFHVmF0K09uZXI1WGNaSDRXY2pQWUM2TGRzT1lOc29U?=
 =?utf-8?B?dU5QcFNpaTV6VC8xM1dtVHVia2RVNmIwd2xCeXMvL3JQcFkrUXhhN0lkUVFW?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3cb0346-b3a8-445e-8472-08da861eed45
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 22:21:01.6118 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vcCcTEI7cMUws4TlHhO74zZOltu5KUbRvZeQqHmorTsD7cjaP3g7DT7kkXLgO1Q7INPEBEUH3bT5QG2095GV3NnWC/4TF3VJP+XkbobV0nM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2025
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Thu, 25 Aug 2022 08:24:35 +0000
Subject: Re: [dm-devel] [PATCH v5 07/12] x86/cpu/keylocker: Load an internal
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
Cc: ravi.v.shankar@intel.com, dave.hansen@linux.intel.com,
 herbert@gondor.apana.org.au, x86@kernel.org,
 Dan Williams <dan.j.williams@intel.com>, LKML <linux-kernel@vger.kernel.org>,
 mingo@kernel.org, Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 linux-crypto@vger.kernel.org, luto@kernel.org, Thomas
 Gleixner <tglx@linutronix.de>, bp@suse.de, Ard
 Biesheuvel <ardb@kernel.org>, charishma1.gairuboyina@intel.com,
 kumar.n.dwarakanath@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/23/2022 8:49 AM, Evan Green wrote:
> On Wed, Jan 12, 2022 at 1:21 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
>>
<snip>
>> +
>> +static void __init load_keylocker(void)
> 
> I am late to this party by 6 months, but:
> load_keylocker() cannot be __init, as it gets called during SMP core onlining.

Yeah, it looks like the case with this patch only.

But the next patch [1] limits the call during boot time only:

	if (c == &boot_cpu_data) {
		...
		load_keylocker();
		...
	} else {
		...
		if (!kl_setup.initialized) {
			load_keylocker();
		} else if (valid_kl) {
			rc = copy_keylocker();
			...
		}
	}

kl_setup.initialized is set by native_smp_cpus_done() -> 
destroy_keylocker_data() when CPUs are booted. Then load_keylocker() is 
not called because the root key (aka IWKey) is no longer available in 
memory.

Now this 'valid_kl' flag should be always on unless the root key backup 
is corrupted. Then copy_keylocker() loads the root key from the backup 
in the platform state.

So I think the onlining CPU won't call it.

Maybe this bit can be much clarified in a separate (new) patch, instead 
of being part of another like [1].

Thanks,
Chang

[1]: 
https://lore.kernel.org/lkml/20220112211258.21115-9-chang.seok.bae@intel.com/

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

