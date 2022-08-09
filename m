Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5879FC19F2D
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 11:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660043550;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=I8umW2bldv4o63+NHsfnjr0KfN3AcUOISYISSQdERYw=;
	b=WW0ydyg+ULAoJnThU0pEVv7GRelfsP3O9pt0Nl5t95N/9gnuqt7Ps5azOk932zaVlnGYhX
	rqBuZB1hz/RRLaZnys7ue1hRBvM5PGkcnh0rBQM5bCkpaazDIqCCgfXSLhG8Ky8Kb0JGo7
	PQ3j2CID1RWsGAlX1+mM6pMOLH/D+8U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-x1PmO1ioOAO3DiKnSJL4_A-1; Tue, 09 Aug 2022 07:12:27 -0400
X-MC-Unique: x1PmO1ioOAO3DiKnSJL4_A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A67548032F0;
	Tue,  9 Aug 2022 11:12:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 90866492CA4;
	Tue,  9 Aug 2022 11:12:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5F3B21946A41;
	Tue,  9 Aug 2022 11:12:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 701AC1946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 11:12:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4B39EC15BA3; Tue,  9 Aug 2022 11:12:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 46AFCC15BA1
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 11:12:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29E0B29324AD
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 11:12:24 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com
 (mail-bn1nam07on2067.outbound.protection.outlook.com [40.107.212.67]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-9QQH4tGeMku6EytvHMz1Rg-1; Tue, 09 Aug 2022 07:12:13 -0400
X-MC-Unique: 9QQH4tGeMku6EytvHMz1Rg-1
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by SN6PR12MB4704.namprd12.prod.outlook.com (2603:10b6:805:e8::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 11:12:10 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Tue, 9 Aug 2022
 11:12:10 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>
Thread-Topic: [PATCH v2 08/20] nvme: Add helper to convert to a pr_ops PR type
Thread-Index: AQHYq4PvpAt1heJFb0KT8DNjDUVZra2marOA
Date: Tue, 9 Aug 2022 11:12:09 +0000
Message-ID: <483733f3-bda3-7ea7-7975-7394388b756d@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-9-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-9-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 177731a6-667b-4d45-0d02-08da79f800df
x-ms-traffictypediagnostic: SN6PR12MB4704:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: RHO7KF79ZZQeN5rgzMs0b91f5pePPGcX3v/hDfBNd4fD0eyLo53Wtuh24y/QmKLLn6kodPlqn3rSnBB4oAqbDSHq0L8VOAwS5qkz7Ar8lZPBI2Cd4E19ctviCMk2y7TK7XfKsXERa2/Duxx0Bod/t2JOPXlFSUaIQdDhbFepyeP/qYWtk53bsxK3B0y+q/gLOJkcqKL4zq7zi1Oz4yBiD2iNEvlmIPEe6c+UAbN6FetKkBCBc+/+DrSAYPuoguttiWI93RceGXMpGjk7WmEODcI0HsZzHMSeG2DsyCTeaIFqVcLYeoeqTjkAe4UZe2h/17cm3TVyrZr1uIeDiAy+dVDGrGrawdqMag08MhyOFMqHUBAfD/PlyPfi922RsGgWuv3h+CWxvrlsHtW4EA7Gzne71LLZ2L9tu1ijDeu6P2ZsNkhDgdMy9kuPxnJJdqqle8aql/iXWOtOvh9ePzkUGNLhI0Eu8DKAxwGkSfOYj6bfg7Q+A1N3F7ODj9Su+NUMkUMCZK2IVwG1egcu5nHGlguuclrrEYwqPviU3l9xUiUFbxkFT8USl6MCYF0/o1FasI6PrY4CmRxiFtZ2OuKmUbGgAJ9OAuS1NCPAKLJl23Pt31hXWES7kjKtbAP4buZrf+71eZ0xIcehOfUcrxUXr5DVOtOJnC2kmWx49Nnoxit0KFIE/7GeL+B2FQSnh50u+P9/ZIro2G6nnZPyt0dKZKv2qnsGp2qgv2lJRxM98bgN8XGhIqTL4vbUk/LWliNu8yRtw59PGyCSjQuUoQjJBFCTfmehCINaGsXKHPtXxai//cD8q35DoCMdWSn8uu5U0NCuZ0yrp4tt1neq8KPIoEWPDbClPiBCguHwd9rOo4Zc7e+dKxoY0lBNxiPW5FVa
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL0PR12MB4659.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(316002)(2616005)(478600001)(2906002)(54906003)(76116006)(64756008)(66946007)(66476007)(66556008)(41300700001)(91956017)(4326008)(31686004)(36756003)(6916009)(66446008)(8676002)(5660300002)(71200400001)(6486002)(38100700002)(7416002)(6512007)(38070700005)(83380400001)(86362001)(53546011)(8936002)(31696002)(122000001)(6506007)(186003)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnFBakNSM3E4NmdPOTkxU3d3SS8xUnJObWtod3lCV3JFUkxkY0g4UDhjcDZM?=
 =?utf-8?B?YjFueEFoZXVQcCtZVW9LNmNXWisrenJ2R2hrcFpjbTE2VEdHOGZhY08yY2lz?=
 =?utf-8?B?RmlLT3JIT2RwMTFOVWEzc2tDZ1hJQlVaTXJQZXM4cnBnTHZPWERwSFcxYXE3?=
 =?utf-8?B?bU9DN3VwWHBEcXUrZjZ2eDJZbWJPakZCdGxlVzNOMDR5MEtZdVZUVFY2TWRL?=
 =?utf-8?B?MDczRk5WWmg0VDRIMnRYbWQ2OTRYdTdXN0xEc1hycjFiQ25WRk5KVjdnQW5v?=
 =?utf-8?B?U0w4NnUraythdm9obE5ha1NZazM4cFhvR09lQk9tVDRybGE0L1JRb2o4cnNC?=
 =?utf-8?B?ZzYxU0UzOXUzMk1ENTVaZklRL040ZDU4Rm5EVllYZGRrREJGWDlvaDlxbWxx?=
 =?utf-8?B?VXRET2VwUEJxdGhNYkdTVkw4aXErNk5JUWxFc1JoVEkyejgxMHJXbzRHaW1S?=
 =?utf-8?B?THRSZUNoYTNHRm1xM21UL0wrSFJJS29ibzZhZk9NWHZUaG1SUEhlRTFra0xQ?=
 =?utf-8?B?N01jTldpOW8ySVUwaFhBWm1RTHhQakNYMFdnVjlVWmt5a3ppdnRrdWpsa3Z3?=
 =?utf-8?B?ei9yV3JEdmlMVXduVFc2cWJ0N21XRWlDWjNRd3JiZEJ0bHJPSE9MSlRlQTk0?=
 =?utf-8?B?cWlGTlBkTDJLM0JLQmhMMGkrYXRkNDdaa3FWVnc3OU5rTHZZdHV6U2h6Y2Q0?=
 =?utf-8?B?K2RYMGtGalFuSnpVQWFoeGVWekdsNStRZ1pjNlJuZ2pRcU1NYnJVcVJXTE9v?=
 =?utf-8?B?QkxnSWdqT2Q5V0JnTUlwRi9XdkpvZnVGdUk4ZHBtVDYxeUJvY3BheStSa0Va?=
 =?utf-8?B?dEpyY2Q4RGQ3K2xoNGVJK0FzUVI0TjFtU2ZCdG9qUlNlTnV1WlFoTFpaSFN2?=
 =?utf-8?B?a3NVREZ4T3VzNU4reGlacTRJZXIvakNFRHRDR0VtNjlOelJIWlVXWnh3YytP?=
 =?utf-8?B?NDZJNlh4eW5PVXlZdEd2ZlZaUnJqWGUxUm1iOVVXbnJXQnhNUUxEWnlNRkFq?=
 =?utf-8?B?N0R1YTZJN3BRL1BNeEM3T2tmV0dPV3NnTklrZHdqWTRlK0NYWlhCVUY4TTQ1?=
 =?utf-8?B?VVV3amNzemNDQkZHdUFMZWhKZ3YzK09HYW5hWHZsc0lLZG5nS3d2TE4yK2NY?=
 =?utf-8?B?cXUwTEVGaEJxRlBOdWNUOGJja21wYVhKdEwzNVgrQjl4TlNjak5PQU9TcGdw?=
 =?utf-8?B?aGs0UmtHYlNMNE50VmFvOXdRMUt1RU82WnlOcnRBS1RVMitheEZTa0VXM0Yx?=
 =?utf-8?B?eTFGT3M5Y2cwK0lQVytXWmswY0llV2EzOUdySUpFSUZxTTJmTEtTNUFyRXNX?=
 =?utf-8?B?RldwSWt6MVIvd2RzbFVIMWlRcW9hNnVBdjNCczlxSFFHMS93eWk4NzJyV3RI?=
 =?utf-8?B?VVlTcVZrZ01LWnFFMHZNWnViS2hrVW9IL21BZFBqRTN4aktYcEk5KzJpL2RM?=
 =?utf-8?B?eUR1Yk9ia2ZtMHdYNS85WUZ5ZjRLaldRL1JJZE5wR2toanpkNW9iVWVudWxu?=
 =?utf-8?B?TVZjdGdmWGgrdldEYXVNQXBTKzNONVUyUFRQRkJKSDBNVE9sdkliQ29oOFJv?=
 =?utf-8?B?dzRrYm8vbVQwbEI5Vk5FbGw3NWxLUUUvTjhla0Z4OUN0cFJSV0QwT0JXU3R2?=
 =?utf-8?B?VjF0VkJTMzZJQUFiTWYvY0NtaVVBaktNYUM0ZnZ4UUlWcmNDd0ZzVlpQR1pi?=
 =?utf-8?B?NVhCMDVyT2k0cDJLUHRMdjJMNmIwU291YlFkd0UvcklpS1NoOGh6dDcycG5h?=
 =?utf-8?B?dTZEME5yV29GNyt1MXF3cVUwWWk5R2ppSUw1VHpqak81bkFjcWxROFlycXQ4?=
 =?utf-8?B?ZEplbkdnYjFyTVZHYjBWOUNGYzlLOG9GL3J2MTBISXlGN1NGOHUwc1JrVDUr?=
 =?utf-8?B?dHdCUTQ0R1NSOGVkbHV5M1QrczZUUTNla0twaDVZZmNVVmt3ZDY2UmRCS1JU?=
 =?utf-8?B?eW9DdUVjVDBsOEIxL2lmNDVMN3EzTmJvY0RsaDlYd0VLZDZxOTJnaHRWWEZv?=
 =?utf-8?B?L0E0OEdvUGZ4NlVheGVEMVFGT0V3UGpzS1I0RFJBQWlSVGNWOGdWdHUyNmg3?=
 =?utf-8?B?c1oxR0hhSnl6WWFXRVVERG1VQjlBOG1hMDB6MkhJRDNkVXR4UVRiMTlFVEZp?=
 =?utf-8?B?aGZ6TjBBR2RkTTlZaDdaUWFrWTh5aEN0SStjWHR1VXhBMjdITGxOR0pjOXRt?=
 =?utf-8?B?WlE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 177731a6-667b-4d45-0d02-08da79f800df
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 11:12:09.9658 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0+mXZ6iPJewi4jAFeX2MC7F8r1CJC0mzXYyRftz95QRQgX9WPDCAO9kTbxhr5VGoa1BSTev8MDTh41Skg0qgcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4704
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 08/20] nvme: Add helper to convert to a
 pr_ops PR type
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
 "james.bottomley@hansenpartnership.com"
 <james.bottomley@hansenpartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "hch@lst.de" <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <3BB043579E4CC44BA3A6610FEDAC49EF@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 8/8/22 17:04, Mike Christie wrote:
> This adds a helper to go from the NVMe spec PR type value to the block
> layer pr_type, so for Reservation Report support we can convert from its
> value.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/nvme/host/core.c | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 3f223641f321..0dc768ae0c16 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -2064,6 +2064,26 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
>   	}
>   }
>   
> +static enum pr_type block_pr_type(u8 nvme_type)
> +{
> +	switch (nvme_type) {
> +	case 1:
> +		return PR_WRITE_EXCLUSIVE;
> +	case 2:
> +		return PR_EXCLUSIVE_ACCESS;
> +	case 3:
> +		return PR_WRITE_EXCLUSIVE_REG_ONLY;
> +	case 4:
> +		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
> +	case 5:
> +		return PR_WRITE_EXCLUSIVE_ALL_REGS;
> +	case 6:
> +		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
> +	default:
> +		return 0;
> +	}
> +}
> +

missing caller for this one ? and we can use a sparse array
to remove the switch case for every new nvme_type.

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

