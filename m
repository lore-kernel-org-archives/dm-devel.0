Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60E8C7EE2E
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 00:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683590614;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XY6iaN39Us5IB0RaG5O95nHMl0obHgXikKOVoHS8L80=;
	b=HcbdZKAkGydNQ9akmjytgJtu6l3Ridso/1XysNDbPLYaQkgspO9wHnBlh/4WATPdgNFny1
	aeniI+Jis2AD40wl7ICRIxp+0nqAyq4X1wqfbcK0/owe4zH8NrnFrmDhQ9W/7G7FnzkILo
	Etxa7crsQ2bCnIzdKFEenSZahu29Z2I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-PDArvu8xOXmOH7C9QL6XcA-1; Mon, 08 May 2023 20:03:29 -0400
X-MC-Unique: PDArvu8xOXmOH7C9QL6XcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE81180269A;
	Tue,  9 May 2023 00:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 04E1840C2070;
	Tue,  9 May 2023 00:03:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8C45D19451FC;
	Tue,  9 May 2023 00:03:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B97F21946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  8 May 2023 20:00:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6541D492B01; Mon,  8 May 2023 20:00:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C3DF492B00
 for <dm-devel@redhat.com>; Mon,  8 May 2023 20:00:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32BCD885620
 for <dm-devel@redhat.com>; Mon,  8 May 2023 20:00:26 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-KyGrqjZxNPWhydSet3x-sQ-2; Mon, 08 May 2023 16:00:24 -0400
X-MC-Unique: KyGrqjZxNPWhydSet3x-sQ-2
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="352803323"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; d="scan'208";a="352803323"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
 by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 08 May 2023 13:00:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="701549156"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; d="scan'208";a="701549156"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
 by fmsmga007.fm.intel.com with ESMTP; 08 May 2023 13:00:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 13:00:16 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 13:00:16 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 13:00:15 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by MW3PR11MB4716.namprd11.prod.outlook.com (2603:10b6:303:53::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 20:00:12 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::cfb2:e73:907d:cb77]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::cfb2:e73:907d:cb77%5]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 20:00:12 +0000
Message-ID: <db6965d9-e3d2-8119-03f8-0ad57bdacb67@intel.com>
Date: Mon, 8 May 2023 13:00:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
To: "Elliott, Robert (Servers)" <elliott@hpe.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-12-chang.seok.bae@intel.com>
 <MW5PR84MB1842D5D264A5B067934F30CEAB719@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <MW5PR84MB18427DC1BA5C09778A0A057DAB719@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <MW5PR84MB18427DC1BA5C09778A0A057DAB719@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
X-ClientProxiedBy: BYAPR08CA0060.namprd08.prod.outlook.com
 (2603:10b6:a03:117::37) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|MW3PR11MB4716:EE_
X-MS-Office365-Filtering-Correlation-Id: d36dda16-f522-4520-b74e-08db4ffed50b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: dlsQ94ee5VflYpwX3vWG+6X6H+abiQc+U7uAShB9t33V8/76Z9An7ln0wTpYV6LDGv998DmtkcmjyL26NBXMd9/qm9/JUY9/8Nm13YI7RUbwWA7ERkTFnu+gNkbcgULauhOOO4pl4bwOg++F7VuCHnwmtz3b/3wyygA3cIu8Z3r/L0gP+D+jO5Oa+EPxBZl9dpNyfB7qpXA+buTT6pvIFMlF6Ak8tcYZJvfO8QOiZrgINOwpDw2TY66shfaapUia4S+3d6nPb2mAAGazS3q3P2LpmB0cgY1urUWTqGpPZnO3UlEmAa69aG2B8ZpvkGCx4DiwTSiEEsaCk09NOIOAnqOQFG44MJkZmd6pn21DGognNSutWEPhnOIawYS0kNX7gnovoTFRcAT5vawnRp7SjBI5HK4D7AaWokXQ5EvIYWwmA2wLvpyb3QVaUXcI8bTuxc08+1/6uZA2U7guSdi/xdO7pbItBkJ/bGMD4rh1oXb8bXOucECC6hWZS9a9Q2JA0XxZykmJcaZulUhVozFOSdUC7p0O5+1Ft/qzeYub8Zb3qPJcUw6/xVcmiICLO3yk5ODanpuG4cMONOg23xjjUWvPPSQkDbUzqG1W1NFqYxOJ3fPe8ql6J32B2c/SYYp2Lcy7DulGIe1O5pkRswd8aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(39860400002)(376002)(346002)(396003)(366004)(136003)(451199021)(53546011)(36756003)(31696002)(66476007)(110136005)(54906003)(4326008)(66946007)(316002)(66556008)(6486002)(86362001)(478600001)(296002)(5660300002)(2906002)(4744005)(8676002)(8936002)(41300700001)(7416002)(186003)(38100700002)(82960400001)(2616005)(26005)(6512007)(6506007)(6666004)(31686004)(45980500001)(43740500002);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzZ5b0Y3MkRPSDVaSFE2N2RPTWpSMUhwaGlhSjMrazJMUm1ObjRlUFFzZUlK?=
 =?utf-8?B?VFpWTGprejZITlZ6WTJndHcxbzkvVzNISzF3R2RxaU13Vko3UkYra1pQR05M?=
 =?utf-8?B?NytIbEk4a1g4RURRVEVUWTFLUm5UNzJhT2ZSVFRQUjlvc3hITUdqTWs0dzZU?=
 =?utf-8?B?cTI4RDNiLzRDd1hBM0s5eDFDNnJIVzVpYjAzMUp5WWdaYkY5N21RTWZId1RW?=
 =?utf-8?B?V3ZpNGdXZVVwek5MWHB2ckRjM2ViRlZzMVdkcmQ3LzFicFRrOHFsaFlPekJY?=
 =?utf-8?B?Z0x4QmQrdUpSWTFmUS9YUWlUT2NsaWRpbk1ZVEt1TFh4U1JSUXJXcDZjRWZy?=
 =?utf-8?B?Mnc0WW94R21kMkFJUjU4Y1MzVXdqdnY3bVBaUEY3a29MSVJPL0hnRUE0UjVX?=
 =?utf-8?B?QXdEcXgzZzZEeC9SaGU4ZEZhUjZnNFpQeGJoRzVaWXBscTFxeUpmejFlRG5D?=
 =?utf-8?B?N013bTF4a0YyZE1hNEthRVVKb2pDR3dXbmV2MmNVamJIM093Q01QRkJzczNR?=
 =?utf-8?B?VWJjRzhxMXZpTFlTK2ZPQzlJdm5rOFZIdTBWUTRjTjYxVFg4NUZZOGlqcGw4?=
 =?utf-8?B?V1dmUzVlaXVPcko0N2dBNXd1RjNmaHRtNkJEd3pLM1ZiV0dudnM4REF1ZG9U?=
 =?utf-8?B?bXJWUjFzTk5Pc2FBMm05czFCYlE0dFZJQVhMWVQ4RTBUVlJ4YTFrQ3FLY2hJ?=
 =?utf-8?B?L2RPS0E4dThTU1NzWWlKSmdZdzA4UHpHdWhjeFE1aFlPeTNRZWJTVm45TEtY?=
 =?utf-8?B?N2pyMTA5MVZJYis0UnVML1E5SHo3YkxlS25aR1RBUWJSTEtsdW9kclNkelJN?=
 =?utf-8?B?R1B6VTI3VFlORzZwc1kwOTQycDZJQUdrcHlmZzlJVnI5ZkF5ZW9QMjlmVzk4?=
 =?utf-8?B?b0hVaTE0bTJhYnE2Q29VRktSVHRUTXp3clAreWxpWk1QTGNnVFJOOEwxalYw?=
 =?utf-8?B?LzBsS3FzTno3YlFqMTZ1TjF4cExTSEpDMGd5UHNiTWs5bCtJWC9yRkI4bWU4?=
 =?utf-8?B?ZkhuZGpsM000T0tZaUlyUzc5S3BQa3dSakw0bVpVOFVtNjlVK0FENmMvd0Z1?=
 =?utf-8?B?Uk1EK3BINlUxeDEybjBuUUhFUDNkT2Q5RC9iUS94MjhVVG1BZWEzcDhKa2U4?=
 =?utf-8?B?WjJUMVBiU3RKejd1cFBFNDlYR2dJV0V2VFFoSXMyN2pSUHVGem5YMXVNc2p6?=
 =?utf-8?B?K2c4Y0xXWE5EejJwK2V3R2RqV0JkS3RSMDlKS2lmWUtwNk4xL2lUVTZ5dnc5?=
 =?utf-8?B?aW5HQmNpMStnRnRXL0dJa29yeVNBQXFibnhoUjY3MGtEeXgyVU1iLzhUU1Jt?=
 =?utf-8?B?UldGMThhbVBDQXk2OXk2VCtQTkhjMTdpK3pyOGZseWIybDlabWFqZzhYL3I5?=
 =?utf-8?B?V2FSUEIyeGlsaDVJTFRrd3EvdWtOWWVXNmt3WVZ1M2dENWVyQ1FlZnFySk80?=
 =?utf-8?B?YW9WOGNrR3hyZkRxWllGM0tkckFkbW44TDM4RmN1djQwODhQWHdZQ0R1RjF3?=
 =?utf-8?B?TkI0UGVNTmlkSUxFS1lUTXp0Qmtmbm1IMzRiaEJpaVQ5VmhodVcwWUdtQkQ0?=
 =?utf-8?B?SEhRQlZ6NERxY2FSc1lJbWJ0Y0gzTFBKbVFIOWRoUHpIaStISURzOC9WaVpa?=
 =?utf-8?B?YVZITVF6VXlhUkNVMUJoSUwvaGwyRkxHcGZ2Y3Q3NUsyeHBOaExISHdrMVBC?=
 =?utf-8?B?YWFDSytqZUkxOG5LSXY0WlpxVk5mQUpTdWtMaE04eWdFMjFvMEplZmJtT1Z6?=
 =?utf-8?B?V05xWTdsZ3hSYjRPOGU3WEptVGI4WVE2VTkzTUlFeFkvbmQ4bnBzM3psVUVZ?=
 =?utf-8?B?bWRwT1FmOUNRcW5WVmEwNXBCUW5mSVEvaGszSHRjZzBrNU9RM3RaSG04RWtD?=
 =?utf-8?B?RTJtK2FtNEZjZGZPbE9zaWEvVWJrU0lHNnZIMHc4Qk8wY293bndJbXNUK3NX?=
 =?utf-8?B?aGxEWUFmcVlpMGJUd0hUTG5sN2VlTlUrWDN4cWh2YTJSQVpmOG1rbzByWldK?=
 =?utf-8?B?bGlmc2dXRk1BQW5pa2Qrc0RCQ1lHZnJiYTgxUHdQTWFuaWlBYUluWjR4YUph?=
 =?utf-8?B?Vy9QdStJOUdnL081WlUvRCtFdFo5RXBWVVVGUGR1QmxKRzBiamxYa3hIN1ho?=
 =?utf-8?B?OVhBM0NKN1I5VlMzK1NINGg0QjluOCtXNXBkdVptK3lFdDNiV3FXZVYwUGhH?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d36dda16-f522-4520-b74e-08db4ffed50b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 20:00:12.0443 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g2YLIUAbB0w5JWGprrjfhK6KACmu7tEGZnGW5ZYNXQMALuoYqh3uuvQqUYvbBLNxUbzpRxFIAozhFk0UAzMyhxhYPjxG2M38MoirP7knhfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4716
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
Cc: Nathan Chancellor <nathan@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, "ardb@kernel.org" <ardb@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Williams,
 Dan J" <dan.j.williams@intel.com>, "mingo@kernel.org" <mingo@kernel.org>,
 "ebiggers@kernel.org" <ebiggers@kernel.org>, "Krishnakumar, 
 Lalithambika" <lalithambika.krishnakumar@intel.com>, "Rix,
 Tom" <trix@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "Lutomirski, Andy" <luto@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Keany, Bernie" <bernie.keany@intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "bp@suse.de" <bp@suse.de>,
 "gmazyland@gmail.com" <gmazyland@gmail.com>, "Gairuboyina,
 Charishma1" <charishma1.gairuboyina@intel.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/8/2023 12:24 PM, Elliott, Robert (Servers) wrote:
> ...
>> This material belongs in arch/x86/Kconfig now (which didn't exist when
>> this patch series began).
> 
> 
> Sorry, omitted one level:
>          arch/x86/crypto/Kconfig

Thanks for pointing this out! Otherwise, it might happen to be based on 
the old mess before 28a936ef44e1 ("crypto: Kconfig - move x86 entries to 
a submenu")

Thanks,
Chang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

