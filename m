Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E753C77B73
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685479826;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Xji0uO0zBLRCVbAeNJItH/GQETzMfW+OCqyjA5FclKw=;
	b=KkG+IGoKHQxQljodVkXOCzE4AWPHLGxBBLul2mCRQ23vb1/VriZYJ0ZnxLnjUVASOX0XO5
	HexacI/Jyiv5HAdyL5RDHkGOU/TQpoVCmRFuOpgg4eHvuW28juXKAtWmZIquxWq5hy82GN
	cjtrFwCGvBcY71Myxz6IZrbl8yXm1a4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-nus88PU7NgKvM5qCoZiYPA-1; Tue, 30 May 2023 16:50:22 -0400
X-MC-Unique: nus88PU7NgKvM5qCoZiYPA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97849858F14;
	Tue, 30 May 2023 20:50:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B1ED3492B00;
	Tue, 30 May 2023 20:50:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7071B19465A0;
	Tue, 30 May 2023 20:50:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 55C5619465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:50:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0AC82140EBB8; Tue, 30 May 2023 20:50:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 02244140E955
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:50:11 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D76A48032FE
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:50:11 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-MXZpfMQXPn-584VlyzpJdg-1; Tue, 30 May 2023 16:50:09 -0400
X-MC-Unique: MXZpfMQXPn-584VlyzpJdg-1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="353886425"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; d="scan'208";a="353886425"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 30 May 2023 13:50:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="796420297"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; d="scan'208";a="796420297"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
 by FMSMGA003.fm.intel.com with ESMTP; 30 May 2023 13:50:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 13:50:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 13:50:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 13:50:06 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB7168.namprd11.prod.outlook.com (2603:10b6:510:1e9::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 20:50:04 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::bad1:92a2:fa0a:1850]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::bad1:92a2:fa0a:1850%7]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 20:50:04 +0000
Message-ID: <de7e577a-b01f-cf93-7f77-288d2d04b4b1@intel.com>
Date: Tue, 30 May 2023 13:50:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Eric Biggers <ebiggers@kernel.org>
References: <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230524165717.14062-11-chang.seok.bae@intel.com>
 <20230526065414.GB875@sol.localdomain>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20230526065414.GB875@sol.localdomain>
X-ClientProxiedBy: BYAPR07CA0092.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::33) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|PH0PR11MB7168:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b3140f6-e2af-4b1f-f6a4-08db614f7199
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: mUYpKV4PDi3YCwy2El2xUe5A8jEptizWmyQFARtnqMpsgwLFr2W6TS6U7V3lBJjw9ZMd4Zwy0sJKJW4H6t3yj1CoqzSMlRFZSUuvZo/EDyzKQFeN1aM0h9eKyaJypKjVtsKi4XADQcMsKVhs/PSfmzpFBgQd/QHD4Hi3nKwLcYEuYvYVgLMovVTbriC+SSYVpeqK7YiWrerGwBf16mrZYQVHN/r3JKoFfM+vUQl/zy1qEW93HMVNWvBGEorxqchkSwIE5KNlO8z6wCI9I6WzrxFfgBEZ86a3d7apkf+cuNZ6Ynwu8rmFIxoC2ugACr+EPesqi44MRKtMXGnovHafG/2GzbZ7rSOEEiO21R0FOc4BObpH0FGIhZTZ0uXUwIUS2T5Js7eXtaGAqe78ftITIa2lZBsjC+6xlu2VlWKzH+5oVq5bModRY3FcJdxaYPPmNIQnmRGISdBnaadofyfS73UMz4hkkajMjPcKyJ+M3xwpGEzHlvSnQiE4Ut7zh8V+LXo/KRJ57Um7JMaHKFs0IU2FrIlajOsbyQVOGeXUNYb+P7dc4IIRza8amUgtUPnT5dtd7fs86k+sAGENrkNaRplaefadP6SQV/dBVwMAO2srLXyYW5jGTcv6qQq+UdOIc+e+t+Zwxr4XuH2NR9KmiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199021)(6486002)(41300700001)(86362001)(6916009)(316002)(4326008)(31696002)(4744005)(66556008)(66476007)(66946007)(36756003)(2906002)(186003)(2616005)(6512007)(5660300002)(82960400001)(54906003)(8936002)(6506007)(8676002)(53546011)(31686004)(7416002)(26005)(478600001)(38100700002)(45980500001)(43740500002);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUF4U2FSQUYwMzBKbzhvZVFTcUVsK3poUkw3WkU4WlpTeWZESjlhazBzLzJy?=
 =?utf-8?B?Q3RFN0ppWjdmVzVPUGFjY2RQRWZrT2hsdVBoRUgzRlVSRFY0YmJqUWp2L1Rw?=
 =?utf-8?B?Tnl0U1U2MmlPTWQ4aHJtdlVTQnp5TmR5MjQ3WG91YzFVUW1xWkVTUGw3Z1lh?=
 =?utf-8?B?MXh5Wm1mMm5EQlpCSFFsblY3MGlMR0c1NFZKS3pkRFNSVE5IZFJvMUxlNW9s?=
 =?utf-8?B?Y1BFek9QejNuMkIyWXNtcHFXUy92MDlDMTZsZ2JwMzNOVVFYeU9sQlBZd25J?=
 =?utf-8?B?Y2I5SFFYT3YwTXhLR2h5VnQvcUg4RzRWenI1MWFEbkdaTlhyNG1JVDl5ZXNy?=
 =?utf-8?B?Vk94WVBsNWZSNEZUamhoUkJreXRHbUxvRUExNkQzNlBDUlRkZEcxcmZkOVQ4?=
 =?utf-8?B?bnY4cks3ZWFqSnBSWFc2ZWMzNDVMa0JoZW5PNzQ4aUswaWVydUdPV00xQ0NU?=
 =?utf-8?B?QjJBblVqaTU5ZGdxak90ZGgwVy9taWdVc21IY1d2UEZCeVBOL01PckFjc0lJ?=
 =?utf-8?B?SkZnQnZZSXBVNCsxenpieTNOMDVUdld5RDNveitvWDNxRFJxYk4xaFZYR1RU?=
 =?utf-8?B?SXFlcnVhU09PcWwyaU9RUEhiNkF1eUZpRUhKV0pGRytiZzR1RW84cSt4ZGN6?=
 =?utf-8?B?Q1QrS0VpVExWZ2ZpRHorN3BGZko3a01td1o1MmhmYUdmdk5jaVExYTA5a2Ft?=
 =?utf-8?B?TlJhalRyVU9wdGswS3ArblQ5bVVvMW85Y0J5R3NaUkxWdkdYSCt4YXExWWdS?=
 =?utf-8?B?WDNNSUJiMnA0a096WENCbkVMTS85RHlnTXBhd0piLzkxTjlQU0NGR2VFMEhj?=
 =?utf-8?B?RVh4RHNYcjJ2VUVucldndk1BWTNFcW9EUjM4TDRiVmlBbFAwN0o3Tm40UDdn?=
 =?utf-8?B?NVN3VnExNE8zWVE5ZVB5UDdNcW1LZmZsNzhmcXBtbk5qZEtPZ3dFcVV6VGpU?=
 =?utf-8?B?QWpTVXdoUDVNdURTRkplRnlVSlNzVDgxa3p4WkhJdjBGYzNvRzdHeUlHZ2xG?=
 =?utf-8?B?dGZ2SzNDQXpqeHl0bFIxeXFpaVp4eWt5RWN6SGR4SG5GblhuVnpuaDM1a1lC?=
 =?utf-8?B?cTZKTmkwa3c1U0VvWk1YTzRscUNMT25naXd4UG5rNjBjNTdqcW9UYlN4NkdW?=
 =?utf-8?B?ZlpvQjhtZUJ1SC83dmVKRitYemN5aEJWbVBFcHdNRXc1SitUWkRta2JpcVlv?=
 =?utf-8?B?QUpHRGtLOEl4WG1xQUJIeGFXdTB5eUxlUExxT3hhR1gwTXhUNHZYK0c0VElD?=
 =?utf-8?B?QjN0Qm9TTTFXQU5oZ0o0QUxnK1JTUGF0TFFRMGFCSzVIdzR0MS9xdStqUDN1?=
 =?utf-8?B?TTRZbkRKNFJFZFh5ZGZQSUdwSm5QcDNsVDBnbERET0tyc0V3T1ZLblgrUFF6?=
 =?utf-8?B?em56c2Y0aTZOOXNqUGRRUU5tSGdsNGplRWJtbmpKR09DRWhPRm9xbnVGbHlH?=
 =?utf-8?B?M2NmbUtOVVRvckFUOEwvZ1JJSUZqLzQzTHBPZUF3cXlXa3FmUGpZYmtudGhL?=
 =?utf-8?B?WDIwQzFTaWF5S2M0bm9EZ2NSMlQ5T1cxeEt2c0JQZzhHNkdxaWszQUJIL09J?=
 =?utf-8?B?d3hGS0RPblFzcnBTSC95STU5UUt0M0ZtWGN2TDZQanh3Nno3NzJwMlkybE0w?=
 =?utf-8?B?TW1hVWVySEFOdlZtVjlQeFVwd0FuaEJGdnY3QU9WRjIyeEhzT0hVS1IrNTZk?=
 =?utf-8?B?UHJ3bWVtZlRWWHpTdTBlQWJqaUowNlNXVXgrb2U0WEc3dVlkeGV0QnNKck1O?=
 =?utf-8?B?ejJwa0RoZEM0akN1dFM1ZXZ6dVIrOUU2cjlwSngwQVNYa3U0TkZTZVlNdXds?=
 =?utf-8?B?VFNZY25mSmdlR2hmY1dwblE4VkNNUzBrY3pMS0tLWCtSUmRieDdENFB4TW1O?=
 =?utf-8?B?cWFTSE5hbk0wRFFHVVBLdlNoTFFFbU1CT3JIOFNMUjNZdUJJeXh5RzU1WmxS?=
 =?utf-8?B?Tjk0VGNNdk5hKzFMWnNGaWxvcUFqL2lleStnc0o5YnF2YmZwbHlTV0FGV3Fz?=
 =?utf-8?B?NnVmYi9pbHdPOUc3MHpid3F6L0RtR21XdHhoZ3VSMVBtZzFFaGgrbjg0ZElT?=
 =?utf-8?B?RlR1cUppU3Awb0p1UytaN2tvN3lic2ZoOE1ldVdVeVRNVFdGeWc1dU10cHpK?=
 =?utf-8?B?N3ZGcDBDbWdhY3ZsMFp0SkNaNzMxOXphcG5aWjdxSmorVC9QdEMzSEtxMXRG?=
 =?utf-8?B?VlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3140f6-e2af-4b1f-f6a4-08db614f7199
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 20:50:04.1876 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F3FrHt79uNMtyimBYsZocgP8KUN1cd583fZP/2FIEb9YOgl55F7M4I5GiYhZAUn8tA3KIhXBTbIPlM5tbRY8efN1GJTvCdMS4YNTm3FkXZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7168
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v7 10/12] crypto: x86/aesni - Use the proper
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/25/2023 11:54 PM, Eric Biggers wrote:
> On Wed, May 24, 2023 at 09:57:15AM -0700, Chang S. Bae wrote:
>> +static inline unsigned long aes_align_addr(unsigned long addr)
>> +{
>> +	return (crypto_tfm_ctx_alignment() >= AESNI_ALIGN) ?
>> +	       ALIGN(addr, 1) : ALIGN(addr, AESNI_ALIGN);
>> +}
> 
> Wouldn't it be simpler to make this take and return 'void *'?  Then the callers
> wouldn't need to cast to/from 'unsigned long'.
> 
> Also, aligning to a 1-byte boundary is a no-op.
> 
> So, please consider the following:
> 
> static inline void *aes_align_addr(void *addr)
> {
> 	if (crypto_tfm_ctx_alignment() >= AES_ALIGN)
> 		return addr;
> 	return PTR_ALIGN(addr, AES_ALIGN);
> }
> 
> Also, aesni_rfc4106_gcm_ctx_get() and generic_gcmaes_ctx_get() should call this
> too, rather than duplicating similar code.

Indeed, your suggestion can improve the overall code there.

Thanks!
Chang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

