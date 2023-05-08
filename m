Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 130DFC7EE25
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 00:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683590611;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PAx7MZDvmTHrdWQ4lqBtImQJPropHOZ9W5cqf3LQ8Ag=;
	b=EzMtGvWnD8/yfDG6IVhRFwgBcGmMwl/nnkBr5fdRyDUb5ZEzy/miTT9j/c0Wm25M2g9oFZ
	/3CwK+kfdUgKxeMD+QVvGiWYYGBHZTo0E+4ntMjc4ctITYttV4LUEkQImPqvqC51aVjJIN
	PsQkZOoa2aZcr5vcmJhanwJTXQjU0/I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-ENruc8sLPQeT3SSjVLuKig-1; Mon, 08 May 2023 20:03:29 -0400
X-MC-Unique: ENruc8sLPQeT3SSjVLuKig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC6883813F34;
	Tue,  9 May 2023 00:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5284A2166B40;
	Tue,  9 May 2023 00:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C234C19452D3;
	Tue,  9 May 2023 00:03:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1144219465A0
 for <dm-devel@listman.corp.redhat.com>; Mon,  8 May 2023 18:21:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E3A5014171C0; Mon,  8 May 2023 18:21:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D890314171BC
 for <dm-devel@redhat.com>; Mon,  8 May 2023 18:19:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 969BB1C06908
 for <dm-devel@redhat.com>; Mon,  8 May 2023 18:19:28 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-FVvdhLQlMZit3uWi_CveIg-1; Mon, 08 May 2023 14:19:26 -0400
X-MC-Unique: FVvdhLQlMZit3uWi_CveIg-1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="415283496"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; d="scan'208";a="415283496"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 08 May 2023 11:18:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="788205487"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; d="scan'208";a="788205487"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
 by FMSMGA003.fm.intel.com with ESMTP; 08 May 2023 11:18:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 11:18:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 11:18:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 11:18:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 11:18:20 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by DS0PR11MB7997.namprd11.prod.outlook.com (2603:10b6:8:125::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 18:18:17 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::cfb2:e73:907d:cb77]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::cfb2:e73:907d:cb77%5]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 18:18:17 +0000
Message-ID: <90ce2028-dfdb-9b9a-24a6-9f9210cedbcb@intel.com>
Date: Mon, 8 May 2023 11:18:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To: Eric Biggers <ebiggers@kernel.org>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-9-chang.seok.bae@intel.com> <ZFWMwQc4NKg7ueqG@gmail.com>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <ZFWMwQc4NKg7ueqG@gmail.com>
X-ClientProxiedBy: BY3PR10CA0010.namprd10.prod.outlook.com
 (2603:10b6:a03:255::15) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|DS0PR11MB7997:EE_
X-MS-Office365-Filtering-Correlation-Id: ed718c69-7605-49d8-9f41-08db4ff09883
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 7DrBZnYs+qp2unAhOBMmdr4D1jWBo2YkCjfxaZHwHHDxP8Y6ccsMc4aErUcEIiYlwQF9WEchInPUG85DD7sWAxsP1bxlbATgYQ65YGaZ87xWAacJyPRuYdCoxG+4DwsihTsZPhCAbnJ1mrH92vR2Z1TUhskqnum8A9V83CZTbp87WUQ7bgcBr7tRtvCye3Qxi5OjblMp3wLcnYbcUsDBDYCAiwgE/ZlzILwmyuv9oR8Z0eh3fM71TzHJ3RMc6NBiXABYVuZbyXIXk9uPzYZark5LYZuTaVrpe4gKo4Ie2CFYDrtCU/OcjnLBW2EwlsT15x08z9MuZ2h7xJF4ZL9w8btC/Vn7kfUwU6yKrobwFZ1Wls/JyMRYcUk2qPM7KYriNY7iuykvzT8LncGkNNWqnAeG9nnAfwRxXp8MCGqXOG/bBeyvrIMgtKaFHr4eD60F1dz3ao/zIPnAAfP7wQXpS2eYWCLBgCJxs4ssMloyjadSCm3PqEQbhGOM1eDWrIIP25e8EesW5C8Ns+2ZzXKyarhAhk6gmynk42QCk48jDIrMwckB2wXLzDzIxLm7VSVbIbe3R5FeJkwKN1X4OZWiuXMSt54qqPy3hTnmN2zpWCk2M80nXA9Uye/NJXRI4ARwZapNT3b7nB322mMms1GlrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199021)(8676002)(8936002)(5660300002)(2906002)(7416002)(82960400001)(36756003)(38100700002)(478600001)(6486002)(6666004)(54906003)(31686004)(83380400001)(2616005)(53546011)(186003)(26005)(6512007)(86362001)(6916009)(4326008)(31696002)(66946007)(6506007)(316002)(66476007)(66556008)(41300700001)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlhNeTBicnd3dXdidXdtWEdqK09HUkpJWkIvM0FwSWVIUzM1M2xUNWY5UUZF?=
 =?utf-8?B?bmw2aGlpcGVpbnpJVU1VVEp5WFIwWEF0d2tBaERObWpXS1lEMmk2Z2gxNWk2?=
 =?utf-8?B?WHJXVTZ1QWt4SU1JdUg2OEZ0cHhsN25pVVNQc1dFbEFMTkdUeEtDOUluaFFr?=
 =?utf-8?B?cjZYUUlLUjMwaWhpdkZSRzVOU0QxMXJPVEdSNHN3anNhUkowR0pKU3Q0Ri9T?=
 =?utf-8?B?L0RCdTB1WDFuTThHWFBPS3VEdDdORHpjMlBxWmUzWXFTclRhbGZwcXZOYlJV?=
 =?utf-8?B?djBqcWxwcnhEQXlQMWxScXlkeGRlM0NTbS9nMXNJQUZBb2wrZmx0QmFadVVB?=
 =?utf-8?B?L0hEVUgrZElISG9MMlR6bE52YkJtWGp4clB4OUh1YlhlYzYwN3gxbjUwNm5w?=
 =?utf-8?B?VDlWSjVoYm50UlE1SzlqaVVNcThPTytNc0lPTHBNeHExcTRSODVjYnQydEpx?=
 =?utf-8?B?b1F4UzBWREgxelc1OHhKdmRIK0xHNXZMYWJJWWU1djR2NERjYmtlODJZV1Ft?=
 =?utf-8?B?NTZWSHdBQmMwOS9od0k5a3llRi9tbzFxYXpEVkxzUVFLOHJlQmFTUmNobngw?=
 =?utf-8?B?UzFPZkkxNVoxcy9oL1lKdnUxRkpQa1hyb09GNVJTMVFPcEpLWHkvbnNZU28z?=
 =?utf-8?B?RlV6OTgxcDhiYW43UG5mR1F4SUV5N1RCKzBQdmlocjA0VmlTWktoSnRSdGlW?=
 =?utf-8?B?Y3pTaTZ4Q0wxdE9Qb1I1TUFHNXpxaWFTZHV4NFI1TTBVKytDbnVseDExUGVD?=
 =?utf-8?B?Z1hqYTFsOVRCYlQ1Mk9DbDVDMUZ2TFo3WTNlTmhMRFNZTEkxdDl6YXUzOEZ5?=
 =?utf-8?B?WEhHNmpIWW5ac2NMWEdmc0dGeldGMUdJbytTS0RBYXBjWGRzQi9ZQjA5UHQ2?=
 =?utf-8?B?S1lCdGdQOWR5aDNyUWJ4NkE4QlJ6UUwyYUVNQkEzbXdCSmVNNVN4ZHZwZEhI?=
 =?utf-8?B?SmlheTBVaFRkemdlbmdjcUFCZkdzN1BOdkFzemhzcFhLbjkvQ2djY2cyRG1v?=
 =?utf-8?B?UjhJM0pRaXhlTVQ0elBNK0xoUEZnQlk0Nks2Mnpuc1k3SWFPLzFPMHlWWVJv?=
 =?utf-8?B?SGxoK3k0VXEzRTZabHMvQUdtTlptZ1NWZk15Y3h0TlBkK0ova3RxRlhSOFJq?=
 =?utf-8?B?ZUtMUUwrN0d4TENoaDc5RlRWSzJoK2lwQmRRcnV6Q1JNeDFqczFMaG5jOE9N?=
 =?utf-8?B?QjY3cE9QWms1TitkQ2ZMVjZ4S05LOXVmNUFhWmNMZGYrVlpsaStheEs2MmRH?=
 =?utf-8?B?bEx2L2x5bnFDeTA3UGdHcDZPRlNZRTA0L3RhM2tGSUFTYngvTE1UZGt2RWFo?=
 =?utf-8?B?K29UdEk4YTFEbnJzS256WXJWOHZiMk81c0pETlJLYzQ5dVJTRS9XYnY4Qm5x?=
 =?utf-8?B?eFRyTWh2ZnpvUUhYUDNwb3I4dHFsengyQzVoRlVZQ1lDdWhHZm9JVy80RWJP?=
 =?utf-8?B?bStMQzhhT3Q1ZUU0Qks5U3dPeXU1SmVYOG9yMnlyMVdFQy9ra05ISmlKR1JS?=
 =?utf-8?B?UVJkRjBzemJuVVdLS2VJYm9jaDVGOVdUeUxMQXl2cHU0U0FuNTBya1V4WUFo?=
 =?utf-8?B?MGt4REJEZElhMFpMOURzd0o1SGY4RVdMSmhkMWxLakpHWEVmSEtZeUI1bVNk?=
 =?utf-8?B?SVVlSnVnZlEzZjBXMWtaOXd1OTBKY1VYeVE0TjdRSDZCVnlGdUwzcTZqTUZ5?=
 =?utf-8?B?TS9vRk9WSXIvUDRkbDh6dEE4TWRycWxtcmdTTDd5Mko5bFFVR2dvYlhqM0x4?=
 =?utf-8?B?bERZMlBhdUMvOUxFbkUzeWpJZ2ZhLzNwM0NWZjRUTE9EbngzbTd2OFhIL1B3?=
 =?utf-8?B?bHdEb0ZQdFYydks3YlcrZm5semErTWFtVW5Kdy9BSFRpS3pNaFlHMFZlUUxx?=
 =?utf-8?B?VkYyNFovVVdqdGw0SGsxbEN2ZktmeTNYczdjbkRFazVlRi92NDRDNUx2VFZR?=
 =?utf-8?B?VnkyTmhOOTA0ZkU0NnhFQjVTd0JJdHM3ZlhmSFV2bUoxeXlmazB0ekJRMkM0?=
 =?utf-8?B?YmpacTc2VnE1dEZrNmt1Yk5ZUTdkVGY3cGhFb0tSREpsbm9JT2hMMUQ1blFm?=
 =?utf-8?B?MXRwaTVEVEpoVzJpaTRUMnpSbFZxUVNZeEMrUGw4Ynl1dEVXY0ZOZnUvNzFL?=
 =?utf-8?B?SUdUQlpmbVpiVTNKWTJkSVllUDk5NzhXMy9jNGJ5VGh3VnNHZklYblU0cDE2?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed718c69-7605-49d8-9f41-08db4ff09883
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 18:18:17.5017 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qf0vl5voZ3upq7glWWubEEZaC6H3/fZrTIMGNdm+Lx2Ta6M7pBZDdml3Aeib6B3RDy9XeFcCQa3Rfnc7NxZASy4fGdp7OvH9H1DCY7Vi+dE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7997
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Tue, 09 May 2023 00:03:21 +0000
Subject: Re: [dm-devel] [PATCH v6 08/12] x86/PM/keylocker: Restore internal
 wrapping key on resume from ACPI S3/4
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
 "Rafael J. Wysocki" <rafael@kernel.org>, ardb@kernel.org,
 linux-pm@vger.kernel.org, dave.hansen@linux.intel.com,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
 lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 linux-crypto@vger.kernel.org, luto@kernel.org, "H. Peter
 Anvin" <hpa@zytor.com>, bernie.keany@intel.com, tglx@linutronix.de, bp@suse.de,
 gmazyland@gmail.com, charishma1.gairuboyina@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/5/2023 4:09 PM, Eric Biggers wrote:
> On Mon, Apr 10, 2023 at 03:59:32PM -0700, Chang S. Bae wrote:
>> +/*
>> + * This flag is set with IWKey load. When the key restore fails, it is
>> + * reset. This restore state is exported to the crypto library, then AES-KL
>> + * will not be used there. So, the feature is soft-disabled with this flag.
>> + */
>> +static bool valid_kl;
>> +
>> +bool valid_keylocker(void)
>> +{
>> +	return valid_kl;
>> +}
>> +EXPORT_SYMBOL_GPL(valid_keylocker);
> 
> It would be simpler to export this bool directly.

Yeah, but this wrapper is for code encapsulation. The code outside of 
the core code is not allowed to overwrite the value.

Perhaps, it is better to export it only with the AES-KL module:

#if IS_MODULE(CONFIG_CRYPTO_AES_KL)
EXPORT_SYMBOL_GPL(valid_keylocker);
#endif


>> +	if (status & BIT(0))
>> +		return 0;
>> +	else
>> +		return -EBUSY;
> [...]
>> +		pr_info("x86/keylocker: Enabled.\n");
>> +		return;
>> +	} else {
>> +		int rc;
> 
> The kernel coding style usually doesn't use 'else' after a return.

Yeah, right. Will fix up.

Thanks,
Chang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

