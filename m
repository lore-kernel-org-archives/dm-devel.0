Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A17B7C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119102;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nGdcQdupu7Q2XsL06HSyo1RjNd96L4sL+bzObvmGUaA=;
	b=XpwfvLNFWH3PW4M1HJbsFmbsyI/fODB/V9k3rmBFWqghGVLo4hCN+1ZUMItZmhcN3wNZGl
	LteeHEMxBcE/36u+rrd9VsVWb59IBUj8J3yYxkceWHad99CJp8+nlIGxrDmzc0V7BM1/K7
	aMnjb3TTa143ZwcKuhJC2HnvMFIrLJ4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134--MjiDNGrO9Wa-G2YE4vKhw-1; Wed, 06 Jul 2022 10:51:33 -0400
X-MC-Unique: -MjiDNGrO9Wa-G2YE4vKhw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9501C801590;
	Wed,  6 Jul 2022 14:51:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7EAB2C33AE9;
	Wed,  6 Jul 2022 14:51:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF15119452D8;
	Wed,  6 Jul 2022 14:51:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 14AF7194704A
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 06:23:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E297D492CA4; Tue,  5 Jul 2022 06:23:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DDCD9492CA3
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:23:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5C34811E81
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:23:30 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam04on2047.outbound.protection.outlook.com [40.107.100.47]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-tmo2s-kUMc28IPnZdM876A-1; Tue, 05 Jul 2022 02:23:21 -0400
X-MC-Unique: tmo2s-kUMc28IPnZdM876A-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW3PR12MB4523.namprd12.prod.outlook.com (2603:10b6:303:5b::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 06:23:19 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:23:19 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 02/17] block: call blk_queue_free_zone_bitmaps from
 disk_release
Thread-Index: AQHYj6PtM+gQ+/kDg06GOymLpmqeQq1vUCkA
Date: Tue, 5 Jul 2022 06:23:19 +0000
Message-ID: <48dfd9a9-ea31-a783-0153-f989e9e47384@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-3-hch@lst.de>
In-Reply-To: <20220704124500.155247-3-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ddc8a980-75c4-4728-4bb5-08da5e4eda6d
x-ms-traffictypediagnostic: MW3PR12MB4523:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: a4Xv7034Le7j9qb7fepXEz8lWvQhXbUd2FuprmjdnuLd8obIYVl6BCOc7lbkb5V0O+FZ7JLIc8FyxjGZyhaNqxfJpoJ7/pnQLttHhhOJ5/6tsSgl6uwn1e5YmLf+UfTt9Ohhx/fAILo6Mp/YzlaQ+iWJYGZwx543xNaF9znQzidZPne24CNELgHYNal5uuNTrNmeiQadit55zvQOX5ZaQ4hlFxwzVQ3x71PmBFPQ/JjHNLRJHKmgGbgip1ykS0Ex83Jxu0owlVBiJUUeEWhnuL97Ceb8EFBTtiVjLAwxGmVWlu1fQwPwjP6qO3bkw3zpq/t+0Qe+ib8A6gpe1VZDXl9NlKfmuaFLefSQ6FSngLU72ZpEZoI5KorA9qHy8WDsm+ljC2aZjXM6DVrYP82jJL2fW2xPObZ2rdJILuT73ENxem77VvO0J+WOAmHZPV9/KBJWsc3Q+BMLof7lf4misx7YL0CDRrnfvkM4I2OfrgubDzX2wSGn4iBIWo1LVm/RzmsPwZyrDHhMxxCKWr4NUgV5cJnUTP+S4TZ5HiC85QxU3F2/+ATm036JdTJQOeRg1JR1oPMAEA9q1brZw5j2H3IxL1t2smPLi/4fQQBVTq6VGuDPh0s+tGKVgoXtsx4zAHiyikA3flgC488DGMFpSBkWjKEC5l1YTMfCYIXTbvCsGWq+NtuEKy4T5epoLIp2LWUuofl6i2ug0J3Xsy1fcOX0O2BItKYkQtUJh+WPJiJ/gWHmQHZuevWe9tOjFPxArMVHuVexvcorbXY7NltE3VfoPqFs7L1GiTOWwOFCu06mgPn5EMDWdXCXPhuCrjdFbQq0lQFFr0fLwJvGGpbdsEk05Y1kySOK/CMNW173sbBKV7ghzRC3Fs1FJDuGlv6f
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(6486002)(91956017)(76116006)(110136005)(31686004)(8936002)(54906003)(66446008)(66946007)(8676002)(66476007)(71200400001)(66556008)(36756003)(64756008)(5660300002)(478600001)(316002)(4326008)(38100700002)(2906002)(6512007)(2616005)(41300700001)(186003)(53546011)(31696002)(86362001)(122000001)(38070700005)(558084003)(6506007)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dHVqeGRxVjYrbmdBM3FoYWhtelhYWEdwN0RXUU5WZ3VFemdxUGJGSDNaY2ZF?=
 =?utf-8?B?N3hSamJ4YnBxdVdRSDVTMjkxU0xrQTNLZ2llU0hJd0NVYTJYY1RJZEcxTjZC?=
 =?utf-8?B?c2NTK2lBY21ZTUJCV1pNNmgzRHZlemptc1N2TXcxakhNZ0JlTVhjRDcrRDB6?=
 =?utf-8?B?RUlqY1VlOFJTalNCOEhTZWR5ZkJKSC8xYnByWjFVNFkzWXdFcEt3enBhTkwv?=
 =?utf-8?B?RHY1dm5VRkFGRGgwbkpYU0V2RDJyTVpiOFRTMXl2SmRHL1Z6NUNHWWFCUE5p?=
 =?utf-8?B?Q2IxUkJ2VFQ2NVhNM0lSaklmSWMvNXJhS2crSThjN0tORXFZUm9MdzVWTWt2?=
 =?utf-8?B?QmFhL1hGajBNaEtsZGg3Y09zUmRpNVdHeWJ4U1FmY2xpdU40Z0xiNTJTdkpJ?=
 =?utf-8?B?VjdGbG1GMVVpS2w2Zy9iMlR5aGNDYVBHT1A0b1ZneUUrR3o3cHp6WVN4aEE1?=
 =?utf-8?B?TEdTWUw5R0dvSmlVd1lsY3VoaXVra1RmS2lmMk5vU1RRZGhNam8yVzBWLzM4?=
 =?utf-8?B?R3NTWnJTSGNDTjZ3anFuK09sZVYrcmVJRGIvKzF0RUowNzVGUlZHWXNjUThL?=
 =?utf-8?B?M2dmcHBnNU9kbzB4dmR6Q2ltZGhZdCt4cWo1R1N1dEQ0MlJRRllqVkp6UGdz?=
 =?utf-8?B?NU9pQmQ3YkxKQmNHK2xQQklFZVY3R0V1dndUUXF3M0dFQXg5RWVyYjFWU29n?=
 =?utf-8?B?ZXZ3MkMvR292cTgzTE9LSU1tY2oyaTRHU21nZ0ttZUlmZUt2NjVPWWJ3K3dw?=
 =?utf-8?B?aEk2WVdESEpXTExpcWhSRllPRnFZYlduaU9BRk05YnhzSGlFMElsR1RKV3kx?=
 =?utf-8?B?ZXhMNzQ2Z2ZtMmZ6eDB3T1FWMlVuSEg1OHduL1doYzdjQkpTUTNUVUV5TmFy?=
 =?utf-8?B?dlFpSjJwT1g0ckFwVnJ1V2RXbjl2RXcyZ29ZcU1od05wZmJJRk9VQklCL3J0?=
 =?utf-8?B?dXVYT3J2a3V0VUx2cDJZYWthSnJyYnNHN1g0UW5MaDNhM0hGc2lRQWhWRW9Z?=
 =?utf-8?B?ODFDVDk1R2p6MHZtUTZtRGx5bU9NTEp6a2ZnMTltWGsya0RXbEtCTGNjazli?=
 =?utf-8?B?RGhVWmlIMXptN0lDRDJWbXhKQzNrWkFFNi8vS0VCYzBVemJLWXkySC9ydytr?=
 =?utf-8?B?VTZ5eFhKTnJQR3pvd3VJSUtvL0hFcDZpOFJ3eCtJdHIyZUtsbk1UZWlwbzZu?=
 =?utf-8?B?OE4rK0NiU2dhdGlDNEhJbi9FQnJoSjYvOVM4dG5tSFJXdXV2NVJDTUZWUzUz?=
 =?utf-8?B?MXBoVFdkenZyblBGZkFVUmFUZmJCL25ReWh0V0lNb0JYR2xteEpkRzdITkh4?=
 =?utf-8?B?UFpJanJiV3BjOG9oNG4rWGU1NmJWTC8zWFJVb0Z3Mlg2Ti95UnF5VlRSdnZh?=
 =?utf-8?B?RHJma0tja2xkeVlJUW1Na2xPdXNDTkZPT3FlQ2FlTEFLRUk3RFNNZm8zbFRJ?=
 =?utf-8?B?dHlEZm4yK2c3K09mU09hME0rL1NISWVxdnoyMVQzVk0zQVVQTlA1dnBhRlhV?=
 =?utf-8?B?bEFQWlVpckNTRUdsZDJpaUIyTDNFTGQ1SHdGMFBTdUNmK3lBTUJ3bm8yNmlu?=
 =?utf-8?B?TVRhOS9TWVh6eXpsMjRMeUFPMXhaN3BXcmFnUDNyMU9BKzA0NjFXNVlWb3ZE?=
 =?utf-8?B?VGthbEQyZnpVOC94cnR4VDhqbTV4SG41a3RUZjlESmFpMFN5WmpYRG1VRnRR?=
 =?utf-8?B?R0JpWFpLM2RKV0NBb1duVFQ1VXBNNEkzWU41UTlybFBpbit2V2kyOXUzRkxZ?=
 =?utf-8?B?NTVUZHdaMGpSUjdnWWtxTDFtdWRpcHM3NEFnYndIMDBrWXUwN2tiQ2J5Wjhp?=
 =?utf-8?B?b1ZKemxFU01SWHY4R1hMdmwvU29xeWdNSExUeStEM2w2ZlgvWmtIck13dTJI?=
 =?utf-8?B?NmFQNXdjVWpEdnpCYkErOGRYNmpzTU80MVVDVkZOb3hsK3pzT2NoZmlucmVh?=
 =?utf-8?B?dUFXRFpDMHFGT1lXZmZBc08vT3lhZW5GVjBvSTdtVTZTZVIrYytvcVBzVGpx?=
 =?utf-8?B?elBIYmhpd2x2aytqMVJuN2R6UWY3dk9xUW56OHFXODA4TDNYdElEUGswT3VF?=
 =?utf-8?B?U2NwMExvS0s4eUpRMXZEK0h4NlhzeUF1emppZk1Fb3hOeTI4OGxxQ2JoaUtH?=
 =?utf-8?B?Q0VzdDVKWkc4elR4T2V4SkVEQUwyNjJ3MUFjTEdVVWVtYVA3bFhlTENZL2li?=
 =?utf-8?Q?7tPmq7T50woDIlNoAqEwrSHSrlBOJd+u5PxBEYcJSVoB?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddc8a980-75c4-4728-4bb5-08da5e4eda6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:23:19.0933 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fDyeLeTjyZSTB5qP7/RbwlwkRvD5d+1aA17MUnGMTJkpO6NpkOmO9+L2dSQSGtv3Hq4ktEPNXp4OGE1P50UJtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4523
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 02/17] block: call
 blk_queue_free_zone_bitmaps from disk_release
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <47E3B745C5D0E34D93AFD5645399256C@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/2022 5:44 AM, Christoph Hellwig wrote:
> The zone bitmaps are only used for non-passthrough I/O, so free them as
> soon as the disk is released.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---


Reviewed-by : Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

