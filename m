Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC1AC7618E
	for <dm-devel@archiver.kernel.org>; Wed, 26 Apr 2023 08:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682498557;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kSnUsHkq0HOruvnqioQI0PpPqMU9+ikCZ0yXz7XQ114=;
	b=aCH7KDZcxFPBP4lHokFGQAlDvxzwu7o2MIdAS6814b2vP0vddsERc2QNGaZ9jDBs7M+NiR
	4K8FMJNrCTJHo95sHLcmDH8o3wr5gFTkSzFsi/X8+vNjrHmPcCRCwexIlghQ6EqDZpBbgR
	onim/9a3QUfBcQsaiLUZCJ0IQMGsujo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-bwPpPcEiM9SGA1jfSeMVmA-1; Wed, 26 Apr 2023 04:42:36 -0400
X-MC-Unique: bwPpPcEiM9SGA1jfSeMVmA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC21A185A791;
	Wed, 26 Apr 2023 08:42:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E97C492B03;
	Wed, 26 Apr 2023 08:42:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2C0F81946597;
	Wed, 26 Apr 2023 08:42:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E8C6D1946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Apr 2023 08:42:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C7DA4492B03; Wed, 26 Apr 2023 08:42:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BF54B492B0F
 for <dm-devel@redhat.com>; Wed, 26 Apr 2023 08:42:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FEA1858F09
 for <dm-devel@redhat.com>; Wed, 26 Apr 2023 08:42:31 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-U97VCTiQONuF8rzYO1e1QA-1; Wed, 26 Apr 2023 04:42:29 -0400
X-MC-Unique: U97VCTiQONuF8rzYO1e1QA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH0PR12MB5314.namprd12.prod.outlook.com (2603:10b6:610:d5::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 08:42:27 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6922:cae7:b3cc:4c2a]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6922:cae7:b3cc:4c2a%6]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 08:42:26 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Snitzer <snitzer@kernel.org>, Shin'ichiro Kawasaki
 <shinichiro@fastmail.com>
Thread-Topic: [PATCH blktests] dm: add a regression test
Thread-Index: AQHZHBi8eATZiCTOIkK8kukyngKzOK6aC9mAgKJaAACAAEEnAIAAVkwAgAEAkAA=
Date: Wed, 26 Apr 2023 08:42:26 +0000
Message-ID: <a8f2ca5c-0ae8-47af-d6c8-f9430c19ff64@nvidia.com>
References: <20221230065424.19998-1-yukuai1@huaweicloud.com>
 <20230112010554.qmjuqtjoai3qqaj7@shindev>
 <6ccff2ec-b4bd-a1a6-5340-b9380adc1fff@huaweicloud.com>
 <oklvotdaxnncrugr2v7yqadzyfa5vvzrumrfv46vrzowjw3njo@tlvhd4eo5spl>
 <ZEgMuvNCud3fNdl4@redhat.com>
In-Reply-To: <ZEgMuvNCud3fNdl4@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|CH0PR12MB5314:EE_
x-ms-office365-filtering-correlation-id: 012424a7-da70-4c1e-be43-08db463229f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: MrmmUa/HD6S68Ij9KHynXEdRukgQdwANchLefIL5uPLNkJqIYLWpJ/T6poQWW0UtEhC7S2MFxGtLFvE1qXOvlpKpG8kcHMmYgQTt65kpduleDs9BsUSPP+Kf4Gqru0Y1P525IWdwdY2W3u8fnblbk4fYdq/N07nPOR36eu+yjmxqJTrhSXskzAmyf5j1P+ekx/VkL+Ffbq+8PmBdHeeU27tWqe6CqdMyHBI6fL4lZdWBu+FM56q0vCsGxs0HHMl/lV05NInyJs3bFvwfxv5hTEaKrsup/uBvS65XyEG2yfDaCcl46U4bWabTeNnYN0GeurkvHmUa1BzTHfBp5ACSjkGkYQgOH+qjDzBjnNUfrTnJh3fDFInbAGorLVE9NLlhLgS83LGbB7vWB+x77yXDfET+W3eBpUOJYR8DD61i7wpuGjQM6JPC/09cqAPrHjEHVtWUqJWpiCFBmK5MZDNlCtAxXS6dhRKVBcWHmwvJ7PJf7Po97ktmuFCctqHKc3zyFz/jXv4W5gW81gRDdDM+Eb1kZ5cOPuZqG/iu2oueJUIMzT5ZRZwep4Oy2tCUftadCSkuofld1BmjLZAWkXmdnMvhmuO98w7hjEAD1ljBuOk+BBwTph5iYioZBgECZc021UVCAW0ePOMEzptwyaV5iuvjMGkz/Nd5hsv6GEWvpqFreVFpu7oqTAD0gtAVIL+emgdV8lDDr7vHrqfEuQoUoglLtz2RKQ5TxSqq91aWVzI=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(376002)(396003)(366004)(346002)(136003)(39860400002)(451199021)(36756003)(478600001)(54906003)(6486002)(71200400001)(38100700002)(122000001)(41300700001)(8936002)(8676002)(110136005)(91956017)(66476007)(316002)(66556008)(76116006)(66446008)(64756008)(4326008)(66946007)(2616005)(83380400001)(966005)(31686004)(6506007)(6512007)(53546011)(186003)(86362001)(31696002)(38070700005)(2906002)(7416002)(5660300002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHAwNzU0WVg0SVBqeXZnaUdGd1RsYUNZMk5yanhGZThkeEJ2Uk9hbFpMZWlh?=
 =?utf-8?B?VE94MFFSU25kd2FNOEhGUjFyUHVJTVhLR0FlRHVtMlBpdGVFQjZzdFlhREFv?=
 =?utf-8?B?SWxWdEdVd3I2WHZrL0RqdDh1ZE9tNThGbjQ3YUR6azhPVUlXSmx5UDdQcTNv?=
 =?utf-8?B?djBxV05yU1ZRc2p6ZUJKZ0lRcFRXR0N2VnJPVW9mYWJ0d2ZPamUyY2lUVUhX?=
 =?utf-8?B?SSsybFBuVU1qb1piTHBiNloxVUcxQy90Z1NaS3FNblR2dFMvbEplMmVyYm9Z?=
 =?utf-8?B?RUNWM2tYV1NXTWkxdGZJdGd3aXNhWGtGQmdueEhDSDJFSCtEbDhwQmttcXJK?=
 =?utf-8?B?dzYrZEtGY2pwSFY1K1V1c0lHOWVDUDJIVE9HTlU4cGI5VzN5QlZrcjNxZ3Vj?=
 =?utf-8?B?OGErbnh6Zlc1VWEyRlFuQ0dZT0pwL1BUSlpQanlucXlvT2RqaWhPTWRCUVl6?=
 =?utf-8?B?dFNDMHcvZ0JtK1EwS2cvYUtUUW1idGtSUjRpbWg4bS9uck1GMlFHeERUVkVz?=
 =?utf-8?B?WU9aeGhndGc4QzBkeERvb0NOeVZWN052U05OYi96ZW1IOTNNQjE4MWJ1NkZ6?=
 =?utf-8?B?UExFQXFlb01OVDRieFBiTDBDUm9SUzZVNzR1ajVrc1hIbHRXNFdwQ0hHL2NC?=
 =?utf-8?B?TlZsc0I4aXF3c0hUSWxRcHp0S0Vtczlyelhqbm5xaWtXUU54UHpmWUUvNWZF?=
 =?utf-8?B?N0FLbm9TN0ZXcnJrYTgyalFKTDYxbkRoRmRqZVIvZXdzWFJQU3ZCY0VpMlMy?=
 =?utf-8?B?OEhnckt3dTkzdHpmYys0MFh2VkNyeis4ekZZVTJLWlorWjJHK0NpTjc1Tk1I?=
 =?utf-8?B?cWZtRDN1MktRVFZ4VlNQVmpWKzk2NlVHU3ByQ20wbDd3ZHZIRjF6R2d0WS96?=
 =?utf-8?B?WXZKQjBJdkpQY1pGTm04cHkwY3FyTG9MbGJ4MDBiMzltVjh3VERmdjl6dXV1?=
 =?utf-8?B?blptb3lVaEtjK0o2amxHVU0yME1rZWhlelVOa3FiUm9zR1M1UHlXVVF2ZHVh?=
 =?utf-8?B?bldISllWMm0xYmVoS1FUSnlFTTJWTFBiRFdOYmErYzlSZHdCdnB2OG9UQ0tX?=
 =?utf-8?B?Yldaalozak5qd1N6dUFSVS9SRERuOUpFYXkwYnQ2K1pxSzFBbnVsa25HYzZI?=
 =?utf-8?B?OU82TktsMjZGdU94SlJEQTJKbXhXVjVkU3dqOTF1eEZlM2Mvb0QvM3UrdEVY?=
 =?utf-8?B?MmVqL0REaUc2M3M3WG5Gc09POTg3Y3RCS2VhT3k0Ym5ISTBKWGZLU1BzUW1W?=
 =?utf-8?B?ZTdLOWJqZXdodUxQYk1oNU9wZVRFbTlPdG5FWFAwemNFeWFOSWNiU0xybUNP?=
 =?utf-8?B?bHU4U1NrZ2xBV1hGSCtLaFJNVUJFYzlYT1MyUVhDa1dMMVVnVUhMUUIrNGg5?=
 =?utf-8?B?dWk5b0h4c2tCNm1zb052UGsrUHBBNnd2Q3Y3bElTUVZVVU5iTXZvM1BQcmR5?=
 =?utf-8?B?Ny9Mb01NdUcrZmovZzNnR1RuWVk2TGV1RUFCVG1QOG5lbEVaUGQ5V0JlQ2pH?=
 =?utf-8?B?RnZrOWdaWllGVFlnamxDR3JZK3FqMFdQV3huV2dGVk5KNjgycnBOTklNM0N0?=
 =?utf-8?B?UStiS0FQaG1JdUFTMG8zdXdCVHg4ZlZtOG8wbUxxN1RhMFRuNVNJNnFYLzBC?=
 =?utf-8?B?UnJEdDNzRWNXUUFpNkduVnZLOUhKYytEaEVZY1MzWmJaRXdQS0Zab1JDWm9s?=
 =?utf-8?B?cjRoNGcvYWxYVHA1cTEwc2k3dE1OWXVoL2JSazdQRFJOajJjWlNkdmRIS0tO?=
 =?utf-8?B?UnA2NytnVU9WVzlPazFuN1hPZHlIcjVoQkswMFZvT2IzVHVsY1FRY0xadVNX?=
 =?utf-8?B?dEVhTTJLc1lCdU1ndUdxWnExN2svMnZXdzBOY2lDaXJFc2ZqekpkSEkzOE14?=
 =?utf-8?B?RXMvSjVJTFdkc2lEaHVNS0s0VkRNcmQzaHU4clNNb004YzJ0cTNONUMrT1Ns?=
 =?utf-8?B?UHhLQ25Ub3J2R2JMQ2lTUDdtdmNRVk5pRHdKNFpBNzM3aUV6QlB5c3hKcndu?=
 =?utf-8?B?WGgrUzBIaXdGUEtwUjcyRGl3MHRtcjdsWlhBZDhuL3NwcVFIb2FMZTFKaGNI?=
 =?utf-8?B?V2JLNmZpL2FOeXNlWkZQc1NCUklxVU5XSVBIUlJOVHlyYUx2UFNjcnQrOXhr?=
 =?utf-8?B?R1RNL29IM2dTL044b3puS3N1OHc3bUxKOVFkNytEanEzcllFMVdWMWphQ3BG?=
 =?utf-8?Q?waQJJeQEYWX04OnSNL/ZX3Hu2dSaGRtFPgAmXtrmDKQA?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 012424a7-da70-4c1e-be43-08db463229f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 08:42:26.8689 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R/qCc91NE2iqDRnxFYi7Qi7L6Z/4sOu66ZROSZbLxukMEI9xsjhCGQDds9LYeQO30TDRVE5bq5ytj52vYuqpww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5314
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH blktests] dm: add a regression test
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
Cc: "hch@infradead.org" <hch@infradead.org>,
 "yi.zhang@huawei.com" <yi.zhang@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>, Joe Thornber <ejt@redhat.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Yu Kuai <yukuai1@huaweicloud.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "shinichiro.kawasaki@wdc.com" <shinichiro.kawasaki@wdc.com>, "yukuai
 \(C\)" <yukuai3@huawei.com>, Li Lingfeng <lilingfeng3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: nvidia.com
Content-Language: en-US
Content-ID: <A8715AFB5FD6374DA2749D5E597AF137@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8yNS8yMyAxMDoyNCwgTWlrZSBTbml0emVyIHdyb3RlOg0KPiBPbiBUdWUsIEFwciAyNSAy
MDIzIGF0ICA4OjE1UCAtMDQwMCwNCj4gU2hpbidpY2hpcm8gS2F3YXNha2kgPHNoaW5pY2hpcm9A
ZmFzdG1haWwuY29tPiB3cm90ZToNCj4NCj4+IE9uIEFwciAyNSwgMjAyMyAvIDE2OjIyLCBZdSBL
dWFpIHdyb3RlOg0KPj4+IEhpLA0KPj4+DQo+Pj4g5ZyoIDIwMjMvMDEvMTIgOTowNSwgU2hpbmlj
aGlybyBLYXdhc2FraSDlhpnpgZM6DQo+Pj4+IEhlbGxvIFl1LCB0aGFua3MgZm9yIHRoZSBwYXRj
aC4gSSB0aGluayBpdCBpcyBnb29kIHRvIGhhdmUgdGhpcyB0ZXN0IGNhc2UgdG8NCj4+Pj4gYXZv
aWQgcmVwZWF0aW5nIHRoZSBzYW1lIHJlZ3Jlc3Npb24uIFBsZWFzZSBmaW5kIG15IGNvbW1lbnRz
IGluIGxpbmUuDQo+Pj4+DQo+Pj4+IENDKzogTWlrZSwgZG0tZGV2ZWwsDQo+Pj4+DQo+Pj4+IE1p
a2UsIGNvdWxkIHlvdSB0YWtlIGEgbG9vayBpbiB0aGlzIG5ldyB0ZXN0IGNhc2U/IEl0IGFkZHMg
ImRtIiB0ZXN0IGdyb3VwIHRvDQo+Pj4+IGJsa3Rlc3RzLiBJZiB5b3UgaGF2ZSB0aG91Z2h0cyBv
biBob3cgdG8gYWRkIGRldmljZS1tYXBwZXIgcmVsYXRlZCB0ZXN0IGNhc2VzDQo+Pj4+IHRvIGJs
a3Rlc3RzLCBwbGVhc2Ugc2hhcmUgKE9yIHdlIG1heSBiZSBhYmxlIHRvIGRpc2N1c3MgbGF0ZXIg
YXQgTFNGIDIwMjMpLg0KPj4+IENhbiB3ZSBhZGQgImRtIiB0ZXN0IGdyb3VwIHRvIGJsa3Rlc3Rz
PyBJJ2xsIHNlbmQgYSBuZXcgdmVyc2lvbiBpZiB3ZQ0KPj4+IGNhbi4NCj4+IEkgc3VnZ2VzdCB0
byB3YWl0IGZvciBMU0YgZGlzY3Vzc2lvbiBpbiBNYXksIHdoaWNoIGNvdWxkIGJlIGEgZ29vZCBj
aGFuY2UgdG8NCj4+IGhlYXIgb3BpbmlvbnMgb2YgZG0gZXhwZXJ0cy4gSSB0aGluayB5b3VyIG5l
dyB0ZXN0IGNhc2UgaXMgdmFsdWFibGUsIHNvIElNTyBpdA0KPj4gc2hvdWxkIGJlIGFkZGVkIHRv
IHRoZSBuZXcgImRtIiBncm91cCwgb3IgYXQgbGVhc3QgdG8gdGhlIGV4aXN0aW5nICJibG9jayIN
Cj4+IGdyb3VwLiBMZXQncyBkZWNpZGUgdGhlIHRhcmdldCBncm91cCBhZnRlciBMU0YuDQo+Pg0K
PiBJdCdzIG9idmlvdXNseSBmaW5lIHRvIGFkZCBhIG5ldyAiZG0iIHRlc3QgZ3JvdXAgdG8gYmxr
dGVzdHMuDQo+DQo+IEJ1dCBqdXN0IHNvIG90aGVycyBhcmUgYXdhcmU6IG1vcmUgZWxhYm9yYXRl
IGRtIHRlc3RpbmcgaXMgY3VycmVudGx5DQo+IHNwcmVhZCBhY3Jvc3MgbXVsdGlwbGUgdGVzdHN1
aXRlcyAoZS5nLiBsdm0yLCBjcnlwdHNldHVwLCBtcHRlc3QsDQo+IGRldmljZS1tYXBwZXItdGVz
dC1zdWl0ZSwgZXRjKS4NCj4NCj4gVGhlcmUgaXMgbmV3IGVmZm9ydCB0byBwb3J0IGRldmljZS1t
YXBwZXItdGVzdC1zdWl0ZSB0ZXN0cyAod2hpY2ggdXNlDQo+IHJ1YnkpIHRvIGEgbmV3IHB5dGhv
biBoYXJuZXNzIGN1cnJlbnRseSBuYW1lZCAiZG10ZXN0LXB5dGhvbiIsIEpvZQ0KPiBUaG9ybmJl
ciBpcyBsZWFkaW5nIHRoaXMgZWZmb3J0ICh3aXRoIHRoZSBhc3Npc3RhbmNlIG9mDQo+IENoYXRH
UFQuLiBhcHBhcmVudGx5IGl0IGhhcyBiZWVuIHdvbmRlcmZ1bCBpbiBoZWxwaW5nIEpvZSBnbHVl
IHB5dGhvbg0KPiBjb2RlIHRvZ2V0aGVyIHRvIGFjY29tcGxpc2ggYW55dGhpbmcgaGUncyBuZWVk
ZWQpOg0KPiBodHRwczovL2dpdGh1Yi5jb20vanRob3JuYmVyL2RtdGVzdC1weXRob24NCj4NCj4g
KHdlJ3ZlIGRpc2N1c3NlZCByZW5hbWluZyAiZG10ZXN0LXB5dGhvbiIgdG8gImRtdGVzdHMiKQ0K
Pg0KPiBJJ3ZlIGFsc28gZGlzY3Vzc2VkIHdpdGggSm9lIHRoZSBwbGFuIHRvIHdyYXAgdGhlIG90
aGVyIGRpc3BhcmF0ZQ0KPiB0ZXN0c3VpdGVzIHdpdGggRE0gY292ZXJhZ2UgaW4gdGVybXMgb2Yg
dGhlIG5ldyBkbXRlc3QtcHl0aG9uLg0KPiBibGt0ZXN0cyBjYW4gYmUgbWFkZSB0byBiZSBvbmUg
b2YgdGhlIHRlc3RzdWl0ZXMgd2UgYWRkIHN1cHBvcnQgZm9yDQo+IChzbyB0aGF0IGFsbCBibGt0
ZXN0cyBydW4gb24gdmFyaW91cyB0eXBlcyBvZiBETSB0YXJnZXRzKS4NCj4NCj4gUmVhbGx5IGFs
bCB3ZSBuZWVkIGlzIGEgbWVhbnMgdG86DQo+IDEpIGxpc3QgYWxsIHRlc3RzIGluIGEgdGVzdHN1
aXRlDQo+IDIpIGluaXRpYXRlIHJ1bm5pbmcgZWFjaCB0ZXN0IGluZGl2aWR1YWxseQ0KPg0KPiBN
aWtlDQoNClRoYW5rcyBNaWtlIGZvciB0aGUgZGV0YWlsZWQgaW5mb3JtYXRpb24sIHdlIGRpZCB0
YWxrIGFib3V0IERNIHRlc3RjYXNlcw0KaW4gbGFzdCBMU0ZNTSwgdGhpcyBpcyByZWFsbHkgaW1w
b3J0YW50IHBpZWNlIG9mIGJsa3Rlc3QgdGhhdCBpcyBtaXNzaW5nDQphbmQgbmVlZCB0byBiZSBk
aXNjdXNzZWQgdGhpcyB5ZWFyJ3MgTFNGTU0gc28gd2UgY2FuIGludGVncmF0ZSBhYm92ZQ0Kd29y
ayBpbiBibGt0ZXN0cyBhcyByaWdodCBub3cgd2UgYXJlIG5vdCBhYmxlIHRvIGVzdGFibGlzaCBj
b21wbGV0ZQ0Kc3RhYmlsaXR5IGR1ZSB0byBsYWNrIG9mIG9mIHRoZSBkbSB0ZXN0cyBhcyB3ZSBh
cmUgZG9pbmcgaXQgZm9yIGJsb2NrDQpsYXllciBjb2RlIG9yIG52bWUgZm9yIGV4YW1wbGUuDQoN
Ci1jaw0KDQoNCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0
dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

