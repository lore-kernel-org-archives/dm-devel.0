Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E738D15ACC
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xy3Q4Wm8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697524327;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7LZFNykvZGAD9jx0CNP+spbQIL+ivZj+YhKO6XKDAPs=;
	b=Xy3Q4Wm8i4Ac2OkMVfrU5hhYd0ZfBCoi80ugBo9VVwZtI0ET31AkBIm+v+geAuix3K7sNv
	1U2gxRojIO4uiOImjmMd6FTVIODTpODke//Wx/FuX5yt/WnKYX8fptRVOGoNJZ7VRYznXP
	9DDMXODj10EepZYPA/m4HaPD4pBEqmA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-UQzrsliONg21JmiT_-QD-w-1; Tue, 17 Oct 2023 02:31:55 -0400
X-MC-Unique: UQzrsliONg21JmiT_-QD-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E701E1C0BB4A
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DCD281C060AE
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA3CB19466EC
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DE4EA1946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 11 Oct 2023 07:28:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A786A20807F4; Wed, 11 Oct 2023 07:28:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F00C20807E4
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 07:28:32 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7526C85A5BD
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 07:28:32 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-94-leU623FLO2SmJW4lWLhVcA-1; Wed, 11 Oct 2023 03:28:25 -0400
X-MC-Unique: leU623FLO2SmJW4lWLhVcA-1
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="383461884"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; d="scan'208";a="383461884"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 11 Oct 2023 00:27:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="783157193"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; d="scan'208";a="783157193"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
 by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384;
 11 Oct 2023 00:27:09 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 11 Oct 2023 00:27:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 11 Oct 2023 00:27:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 11 Oct 2023 00:27:08 -0700
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA1PR11MB6489.namprd11.prod.outlook.com (2603:10b6:208:3a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Wed, 11 Oct
 2023 07:27:06 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::36be:aaee:c5fe:2b80]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::36be:aaee:c5fe:2b80%6]) with mapi id 15.20.6863.032; Wed, 11 Oct 2023
 07:27:05 +0000
Message-ID: <2924b09c-bf19-4de2-aae4-55752dab24a6@intel.com>
Date: Wed, 11 Oct 2023 09:25:50 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/14] bitops: let the compiler optimize __assign_bit()
To: Yury Norov <yury.norov@gmail.com>
References: <20231009151026.66145-1-aleksander.lobakin@intel.com>
 <20231009151026.66145-4-aleksander.lobakin@intel.com>
 <ZSQn4Mppz9aJgFib@yury-ThinkPad>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZSQn4Mppz9aJgFib@yury-ThinkPad>
X-ClientProxiedBy: FR4P281CA0150.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA1PR11MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: aa5167bc-1fa1-45be-b3b3-08dbca2b7813
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: I6xHHUCUkeW/YM4py9cbJBsk1lqSzZufftsUjAtPzQGEvZ540+xWvuyfsqxs26ms4bTS7XOFco6q7oXOZzuuUDtgO9J0ZHu3l/FMZcUHtoPx3BNGyxzQZCf6086AvP/fR6u9y2IcfK/fOYN97Xv+Cif4i2VEz6nxh1C546dea7zQPsOgqpWtJdeaNNDEqMOpLhquo0AZahrx/I9ghWCgOKFeN3cm83TvxBDcnGnB9CraX51+TGEG52X8tYKoFWFm8nt8WZJaaKBMG6NQRNSojH1evGfEm2oYVtL7GiNr+XBylOwhcvOogGhMgie6bt3IXoyajtFU9Pvx9wDedigGms5ygbPnMrrSo/ql/fDpc5mpXviZa4O6jW/G9ncyjOd7+xynbuhJFyaXD1bCqE9HKCxzD2OE4XaaDasIeQBe8pDF8yAS2jUXAh9MJIe/SQodkZP08ra06Ghvj+YL0wQLIyb33Sk+1xOYmlFE7Lwzwc4Pvb1Svy2GIAV+jfXhToqQIoZ+OOkzDy0ibTbzChqgS9e8oEcp75VTY+yFq13vuEtrkh1eJWHbhBm0G3eZ3Qsitda8WKE3SZUIK6wYLEPW2Nd53g/64orBzJNvFL7cdf5OpyUX19LPgyA7cP3L36UZWUhk0CCPq85nSeCKexPajA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM6PR11MB3625.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(376002)(39860400002)(136003)(396003)(346002)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(31686004)(2616005)(26005)(66476007)(7416002)(316002)(54906003)(66946007)(6916009)(4744005)(41300700001)(66556008)(38100700002)(8936002)(8676002)(4326008)(82960400001)(5660300002)(2906002)(6666004)(86362001)(31696002)(6512007)(6506007)(36756003)(6486002)(478600001)(45980500001)(43740500002);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmpiRmtqUkt3MXpHMEtrM2kyZktHclRzVFRLNHdtME5Jbk1vNkhhbEFrcTIz?=
 =?utf-8?B?amNnRmNIYXRtcHVmM1VxaGJDeTZOWW1lcXk0MWdFZmpYc3NEVkVpaThXd0tN?=
 =?utf-8?B?cHQ0Q2VaaXNYWGx0d3k1M1ZYWk90TmFjMmdTMXpneHByRW1LQk5YUTZBbjBE?=
 =?utf-8?B?UUxLK1R1UTYxSlVpRGlzUDgyZUhkVGplai95cmxtZmpPQnRqdjM3TGkrNnpH?=
 =?utf-8?B?VEhxUnNlSS92VUNPM3c0ZzNWTGhFa0EzQlNhcVJBQUE4cU1rWWRpZzliT2d1?=
 =?utf-8?B?ZkZJdFptOGEwYkR6cWxOVy9LYWNDZno5WnpuMEJJUjhEbmpjYVR1N3J4ZTBX?=
 =?utf-8?B?citWSjFNbUdmZ3FFak43UG1tcHlzWkZHanU1azNmOXJiZ1NubWV2YzB1RGZa?=
 =?utf-8?B?L2JqclFTdU9EYnNVckkyTUp4WERSZlQwODUzSGY4ZFpCZXFlVDlvM2RhWGIz?=
 =?utf-8?B?ZTFsU0ZhNkFualRRbVlmbm1Tdkp5OEhQOHFkTmpOUU5PVXVwVEVPNmRaQ0g1?=
 =?utf-8?B?bnh4QkY3alpWa2l3amZWV1dHREl3MnVpOGd6OVNjaVdOZjU0emYzMU9Sdzgz?=
 =?utf-8?B?U2FQcDlUVnFFdkt5MVdTT2d2eTltNWJHZ3JFQzFMMHBzamFoU1Fpb2hIS2dm?=
 =?utf-8?B?K1pyT0hMUGcyOFB3Y2ZJRVlGWWdzRjV6amdiSDVTYnQ2VXRFUjByYStTaEwz?=
 =?utf-8?B?a3ozOGxZcjNMcnZnMmtlKzhkRVdCRHppKzNRWWFFSXVTaHMydXFwQjM1SS8w?=
 =?utf-8?B?SjdOaUJJWUYwYTlNS3F3Z1F6K3pzakd2aXVBMW43V1VWb0dMZnFqVFNpdXY5?=
 =?utf-8?B?ckU4bEk0ZURyWDhDK1JkSWxBN3gyUEFxVVNhY0diZ0Vob1ZqdGRGRmpiZWZE?=
 =?utf-8?B?clBpZkozcTZHalk0cVpSV09WWWtGVDNMbmxoU3M5OVQrRW5oVXY2ZTQrUmJm?=
 =?utf-8?B?WnVuY2dQRTNvM2ZXSlJRV0VWS3dkblMyL2VOYzdmQjVqSHFjK3EwRWU3OFBx?=
 =?utf-8?B?bXdvRS9Qc0dXZzZYZGFyUnJZU0VwaUEvVmh6MmF3aFU2cCtDUUpkK0Uzemx0?=
 =?utf-8?B?TW55K2dqbVZiNHJmRElZRmJjRHpDK3VFSW1DSVpVZkZOdmc5Z3A1TThCanFq?=
 =?utf-8?B?YnlQS3c0S2pNWWpFekZCMXhvd2NNWEJJY3ZJZnVYOWRUU1BlcW9taFpMdS9G?=
 =?utf-8?B?bEZOSjVzblpXL0hzUHYxenI5cVhKL1ROckR0WGVyeWVzNkljUkYvQTgzcWdW?=
 =?utf-8?B?UVBEUlIwOVIwOE5SblFWOTRxMVhTOWNRWmVpTXRZUWdoREJvamI4TVVlTEtw?=
 =?utf-8?B?Zkt6amEzMTZZVTVVYTZBZWUrWFh1RVdnQUs0K2lpVmF5WnYxK2tYR1ZYcFRJ?=
 =?utf-8?B?ai9yaHlIcUlndW5yT0xORlUyZ3p3QkhpY3FHL2h4ajc0OWQ5ejRGZk5MODhF?=
 =?utf-8?B?RE16Z3cvaWUxUmVUN3ZTM0YzQ21iT2NBUzhaVVBjbFNGbkczVjk4QjVaRVpW?=
 =?utf-8?B?VDduZXZrVEZqWXR5c3lqNWg1VWR4MGdOS0pUZ3FXS0ZlN0ZEdGVOR2dPTVM0?=
 =?utf-8?B?TXp5NzJaczJEbFRnSzJhZE5VUFhFV3hZcHdUSWIyMkZSM1hEMWZDZkZwZi9h?=
 =?utf-8?B?eGtleDVqdW5OL1dmWnpEV3k4bFN3SzRjSWovNjUvb21NVEtLRURiQXQxdGg3?=
 =?utf-8?B?SnhGL1lRc2QrSGc0VEhITUt4dlNoR3JpOGJUUXR4bXJuaXBGUXBTWFMzNStH?=
 =?utf-8?B?TlMrRUUwWWo3RHBXUUM0QkE2bE54QTNCekNURkQwWUJpODhCTFZiM1AvY1py?=
 =?utf-8?B?NnBJRFVwWmJxeW5KMzFTcUpmUmNVMlRXdUZGMWtZRy9NVHNCOXg0cVJJSFA5?=
 =?utf-8?B?VENDeEpqNmljT0p4dkE2a0NPSVJPd3pSSEorLzQwS1BGZk5KeWtxSXNFSWtW?=
 =?utf-8?B?QjljeVByZGlsYVFydkQ1YzlpTXcxUVFwcDlXZUhpeC9LaUdzckZjNGZCSDEz?=
 =?utf-8?B?L0U0Skg4ZEVJZktxeG1rNmRERGJVRzM5Zjk2dDJMdFF4WXZnNEFPU0pQOTB3?=
 =?utf-8?B?MW0xTDJnUXB3b1JxbW5iM3ZYNUY5ZTB5NnlGUHZ2dTJ5bGdnait6aW81akFH?=
 =?utf-8?B?UlhmdFZnM3JPSHNMZUZDSDhhcHliMlA0Mkd5UjRnSG1oRmIyU09ON1BVZXhH?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5167bc-1fa1-45be-b3b3-08dbca2b7813
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 07:27:05.2661 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ct/F3ureqZIh0WVYcXzq8ApUio2uiZv2O1II2eCbO+TureHBkoH6quA3lCI9MV7kH80p0dFV78ZgBk9pRfelhiMtAZd1MxukpiiG5Tknehk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6489
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Tue, 17 Oct 2023 06:31:30 +0000
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
Cc: linux-s390@vger.kernel.org, ntfs3@lists.linux.dev,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 David Ahern <dsahern@kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
 Alexander Potapenko <glider@google.com>, Simon
 Horman <simon.horman@corigine.com>, Jakub
 Kicinski <kuba@kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

From: Yury Norov <yury.norov@gmail.com>
Date: Mon, 9 Oct 2023 09:18:40 -0700

> On Mon, Oct 09, 2023 at 05:10:15PM +0200, Alexander Lobakin wrote:

[...]

>> -static __always_inline void __assign_bit(long nr, volatile unsigned long *addr,
>> -					 bool value)
>> -{
>> -	if (value)
>> -		__set_bit(nr, addr);
>> -	else
>> -		__clear_bit(nr, addr);
>> -}
>> +#define __assign_bit(nr, addr, value)				\
>> +	((value) ? __set_bit(nr, addr) : __clear_bit(nr, addr))
> 
> Can you protect nr and addr with braces just as well?
> Can you convert the atomic version too, to keep them synchronized ?

+ for both. I didn't convert assign_bit() as I thought it wouldn't give
any optimization improvements, but yeah, let the compiler decide.

> 
>>  
>>  /**
>>   * __ptr_set_bit - Set bit in a pointer's value
>> -- 
>> 2.41.0

Thanks,
Olek

