Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F0D4C04A68
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 22:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658959454;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7e0PSkRgXFrHoKOQrW4sFpccFpD82tI4KgD68A8R1XI=;
	b=UJ6nXlWTZpMjxBr2bcJJTduZ+9AGiyzD4D9c68aysCImHYgfX+34uy1hj13+zaDOEmu9zY
	/Ce9znXHv+yLNh056tdPMgHJbfVF5peSfn925xzpEOz+GcdDS1BIKSOh8qt/GPI7RfDM4x
	RhFq06ioNtn7GZot8cqIwMRVK/DNWEs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-s15GjLgGMTSW4PxRzrGHrQ-1; Wed, 27 Jul 2022 18:04:10 -0400
X-MC-Unique: s15GjLgGMTSW4PxRzrGHrQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4983D185A7B2;
	Wed, 27 Jul 2022 22:04:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 35CA090A04;
	Wed, 27 Jul 2022 22:04:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B257D1945DAC;
	Wed, 27 Jul 2022 22:04:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BF0041945DAB
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 21:59:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B13381415121; Wed, 27 Jul 2022 21:59:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACB2A141511F
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 21:59:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91E34185A7A4
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 21:59:55 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-XaxuEvvoPXmxvPLIIRU1qQ-1; Wed, 27 Jul 2022 17:59:53 -0400
X-MC-Unique: XaxuEvvoPXmxvPLIIRU1qQ-1
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by MN0PR12MB6080.namprd12.prod.outlook.com (2603:10b6:208:3c8::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 21:59:51 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::21eb:6424:fbf6:a189]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::21eb:6424:fbf6:a189%6]) with mapi id 15.20.5458.024; Wed, 27 Jul 2022
 21:59:50 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Thread-Topic: [PATCH v8 05/11] null_blk: allow non power of 2 zoned devices
Thread-Index: AQHYodViv/Y7J0eqK0KIahJ7h6pcpK2SxLgA
Date: Wed, 27 Jul 2022 21:59:50 +0000
Message-ID: <bbcfe218-5bae-266c-5712-3489b2eeaaba@nvidia.com>
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162251eucas1p12939ac3864fd8705ae139eb2d1087d8f@eucas1p1.samsung.com>
 <20220727162245.209794-6-p.raghav@samsung.com>
In-Reply-To: <20220727162245.209794-6-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bfd20fb2-4f0f-4a90-be1d-08da701b5470
x-ms-traffictypediagnostic: MN0PR12MB6080:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 5Vi0donuo2Yr+6seP/Sg2eAUDPnyKlxoMdf31OT9WtUezLKoq3xI6reu6OgVvhEp3h0QQNK8BdOTRp+HLB5QoWrJXSZjXmS4tP96C3MJ3MhrJr20J9l/ETSTk4yjYNEEEZzZY8/SGTtESPT/tXT7bNc7EFdzE/z5Os9fnpVwDdtWfVJQOhviyeJIIiK0NtcSXNx714A4G9bC6roHwX/zhQ/Fvhr8bwfwVJOnBoPEM/cqyvC1RD2k6nRsFS1il+2NMQKHT0jGmwiCeKv/YVq+M72XztAxL/iEQ/raaMskND76f+NUyueXjTN/tRFdT6MFAuP9BsfC3ym3588VIjZ7U5Hq1qjXaS0Clshj11zJslwcpr3JdqlP1p3r1gYd1FAyOfF7SMVIr6lGe+tAO9OZefyikouafiZYK8Ptmst7btbTa5bkELxmF2qLsPvSxilXZlnyQjyHZmbMjLgz/giQIk4ULq3GtA8emOGwuOtsVcZQ5bh/eU4wMkpZizfNHPAxRjRVHSm1ZdQglwhm2tKkGpo+Lnia/pp1npZwPfGpLv/B26b279Fo/p8ZKnwG29SLi0pQBk97YBFAvOGYlG2CrpLDJ+vQJwj32mf0bHCVwq653yEc4w6qE1seYKaEHQSvu97Tc0wX0Q+c2u4su4okyO/m5Flj/AjQMSXBaynQWwFhtdM5AYI/zxfWhlrDH48kWeNL+mu44xYDttuEWEbRUU7sBCy0Ip+h2coloV4wSTt18AqJB3rA6polQCMDqKG/kOVJAhTlupFTug/b6iD79oh9lIFxkm63MqZkRfCYUZtWbr5LtMFzh7NWQEaAp0Kv1jEy5Aszi1f7sX8+Ig+wJMoqy+OPlIVTLb45qS6uMyKK0ETRNgU+65Rp27T1tBAn
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL0PR12MB4659.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(5660300002)(2906002)(7416002)(2616005)(6486002)(86362001)(54906003)(41300700001)(71200400001)(31696002)(26005)(36756003)(38070700005)(91956017)(6506007)(6512007)(186003)(66446008)(8936002)(478600001)(122000001)(8676002)(76116006)(83380400001)(38100700002)(316002)(31686004)(6916009)(66946007)(64756008)(66476007)(4326008)(66556008)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eldWK29pZlFqQnFpLzhKRk85TUUzaTVabTN2RlYvRzRvVEVXOUxOM2xMZWM0?=
 =?utf-8?B?Y0dzT1lGcGx6dlFJbk9iWTArWlEzRzY2dUxMZHQwN2FCTlJZN011QTU1QTNE?=
 =?utf-8?B?N2RBNk95NDYrVWozOEN1RWt4WUgzQ3pvdXZYbkNQeTJrZ3pFaXcrL1RPclIw?=
 =?utf-8?B?dlh5bTM1Ykg3YUtETi9lU0lBYmJxTmdQRUN1ZlJoQjM1SUdTd2xtbVo3c01O?=
 =?utf-8?B?aXk2V2kyYXR3Y2FQM0RaMnBUOW5QSUZtQmZqVWFGNm5XSDNWeFJXN1lIbHdB?=
 =?utf-8?B?UHpydXRxa1ZBdmFqMVQ4Uk95YUIzK2RsWkQ3RjQ3VllSYThlNld2cjVXaU91?=
 =?utf-8?B?Z3Y1UGU4THlRTVNDRUNkV3Q0L0hTcVFuNWF3YjNZMnlUOElack1yUjN4eTZp?=
 =?utf-8?B?SkJoMUtEcllicHBScHA2UmZCby82SVV0Z3luV1FnOExzRGxvRGRqeVhydS91?=
 =?utf-8?B?V092dUFEVnVnQ0UxL0JBTDNuYkdySC9CbzhjNmdBamRCZE4xVm4zRFJ3TEdw?=
 =?utf-8?B?bnJTUGtDZS9jTTE2Wmd3Mm95NkRVdHpSY1NlR1dYRjJPd0V1T1JUUUNCWFI4?=
 =?utf-8?B?TWRJK0JOc2syOExyZjZaWGVFWU9YekNtczkzWkZZNFJYNHZpQzZlVVdZMC9J?=
 =?utf-8?B?SVViSkE5MTFuMFRzSURSZW8vVmpEay9YOTJuVDZPaXNrUVg3K21RdjRQdFRY?=
 =?utf-8?B?Y0srNlRyaHcwWnBqYzFDTG0xaXZRWjRrUm13V09CZnhMN3dBS3ZpOEtPdXlt?=
 =?utf-8?B?S0dOUjNmNmdyVm5OSzAyNG8zQXVWS1BMdDBHUkpJNnd4WXJZcHNCRW12OWJu?=
 =?utf-8?B?aVQwNzYydjl4bFFacHhEdklEVEV0ZDNxUW1QaldWaHdTRGo2WU43TVN4eDRk?=
 =?utf-8?B?Uk41eWwrdE9BMDZLK09qcUt0ZE8rMkRKbitlOG03MWdCUnltZEpVYXdxRXlE?=
 =?utf-8?B?MHJiZVovNit5b1dHRmRsdnRaWnQ2d2JORVBwT2Rzd1YrQ1JGY3ZVOFJiUnpy?=
 =?utf-8?B?TzdtODJTRXJqUGRGNU9Nb0JCTVpSU2NFU2NTZWJYQ2FiMytjdjFHZDgxK3RY?=
 =?utf-8?B?RDMxRmVoRVh0U1BEZVdDN2dEL0tSZmlHRWJIMytFRmw5eGRlWkZ6RkFLcmxq?=
 =?utf-8?B?UVhXNDN0UFk0WHZyZFZHSlkwU1U1RnIvaVpuZ0hIT1A2c0I5eUdCY0lKUkdL?=
 =?utf-8?B?QlVjUWhnMEJsdEx1UUVrYWtJdFdxRWF3dW9LMUsvSDhjVUtmWGZIeHplOThk?=
 =?utf-8?B?aVRMbGlGOWJoaWh1SWpvOFNrUGFUTFJrcERwOVRnOFQzdmxTVyttdFhoQ1lv?=
 =?utf-8?B?UTdhQzFNRlRsS2JTdnpUaENxMjRkak1UemZwQ1VHZk4zU0tsM2ZHdWV1S0ps?=
 =?utf-8?B?c3ZTdExoTWRVOTNBditIOXdUQzBxWTJWYWl3SjR4SlVvRUxKYnpGb0ZYRmk5?=
 =?utf-8?B?RThLKzNvaXJrNEQ0ZFV2bFpaRUNydzMrNHd1KzcyNUtHMGYxcWJTNlpLVmxu?=
 =?utf-8?B?dHZDZ285Vy9YdHhqMUM1STdXcS9FajlyblZKUjdFeG5iZmhpeXpPVHVoTXNB?=
 =?utf-8?B?SGR0dzd0ejlUdG9VVkd5cVluNHBpVjBtTGlKeXRKeGhIKzVuOGt4TEZOYWxS?=
 =?utf-8?B?MFRFaDhtZXRqemliSGwrQlJZNUg5czhKNlArdENBUFVQYlM3bHBicUlwMjgz?=
 =?utf-8?B?ZHhFUjJQTVZrYWMrQjFhTFhsTmp6Z3ZDdFZCbm56eG96b0QvWjJSZmZjcE01?=
 =?utf-8?B?eENlRDF6c1ExZmNhSlptZnVDalBqM095Vlp2dzNKK2R2b2FlV3hJWW5Rd2pi?=
 =?utf-8?B?M0h6dG5manNvL1dKdnJDNVlqbTRobGZuU2JrQlZ3T2o0bWh1ZXRRZ2F6ekhy?=
 =?utf-8?B?bmJ1MVlHSUZtemVkN1FMQUpWZEdqWTNhNkVxU05URjdZQTd0VXUxQWV2ZnBn?=
 =?utf-8?B?bTRJeWw0VVh1bmNLWjY2WGlQUkFicU1XdnFZRmFxRmZwK1NGcnQvVy92cUVo?=
 =?utf-8?B?SGx3a3ZkMm1HS2hWZ282dmdXRTlhN2ZnNUR3S2hwaWZwSUI1R3d2UWFFMkRr?=
 =?utf-8?B?NjF4bCs0bnNQREJnL05qZnR3V0VBQzhTVDdNam1Yc2lGYUFjSW8zTlU3T25G?=
 =?utf-8?Q?lc0Zrcy3e4A02OEL2xb1jnTsX?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd20fb2-4f0f-4a90-be1d-08da701b5470
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2022 21:59:50.9293 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 81MggmUGkafdNaiHSSql/3OGl12QEFNwvZipHrdssrIDSW4JzYhoCIFhW9auT5YJgdKckzgibBo6O0xC0UevVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6080
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v8 05/11] null_blk: allow non power of 2
 zoned devices
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
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "Johannes.Thumshirn@wdc.com" <Johannes.Thumshirn@wdc.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "hch@lst.de" <hch@lst.de>,
 "matias.bjorling@wdc.com" <matias.bjorling@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <5AA1B5F7B2C29A40A04790AB8C373DFF@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


> Performance Measurement:
> 
> Device:
> zone size = 128M, blocksize=4k
> 
> FIO cmd:
> 
> fio --name=zbc --filename=/dev/nullb0 --direct=1 --zonemode=zbd  --size=23G
> --io_size=<iosize> --ioengine=io_uring --iodepth=<iod> --rw=<mode> --bs=4k
> --loops=4
> 
> The following results are an average of 4 runs on AMD Ryzen 5 5600X with
> 32GB of RAM:
> 
> Sequential Write:
> 
> x-----------------x---------------------------------x---------------------------------x
> |     IOdepth     |            8                    |            16                   |
> x-----------------x---------------------------------x---------------------------------x
> |                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
> x-----------------x---------------------------------x---------------------------------x
> | Without patch   |  578     |  2257    |   12.80   |  576     |  2248    |   25.78   |
> x-----------------x---------------------------------x---------------------------------x
> |  With patch     |  581     |  2268    |   12.74   |  576     |  2248    |   25.85   |
> x-----------------x---------------------------------x---------------------------------x
> 
> Sequential read:
> 
> x-----------------x---------------------------------x---------------------------------x
> | IOdepth         |            8                    |            16                   |
> x-----------------x---------------------------------x---------------------------------x
> |                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
> x-----------------x---------------------------------x---------------------------------x
> | Without patch   |  667     |  2605    |   11.79   |  675     |  2637    |   23.49   |
> x-----------------x---------------------------------x---------------------------------x
> |  With patch     |  667     |  2605    |   11.79   |  675     |  2638    |   23.48   |
> x-----------------x---------------------------------x---------------------------------x
> 
> Random read:
> 
> x-----------------x---------------------------------x---------------------------------x
> | IOdepth         |            8                    |            16                   |
> x-----------------x---------------------------------x---------------------------------x
> |                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
> x-----------------x---------------------------------x---------------------------------x
> | Without patch   |  522     |  2038    |   15.05   |  514     |  2006    |   30.87   |
> x-----------------x---------------------------------x---------------------------------x
> |  With patch     |  522     |  2039    |   15.04   |  523     |  2042    |   30.33   |
> x-----------------x---------------------------------x---------------------------------x
> 
> Minor variations are noticed in Sequential write with io depth 8 and
> in random read with io depth 16. But overall no noticeable differences
> were noticed

minor variations in with aspect of the performance ?
are these documented somewhere ?

move the large table of performance numbers to the cover letter it looks 
ugly in the git log...


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

