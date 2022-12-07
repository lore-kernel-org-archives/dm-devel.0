Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 111DFC47089
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 03:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670383971;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=efjeKgdaEMHYjpgJlPyazB96QkCozw/S4VF+S/SnWok=;
	b=dSax3HMeLhf7GFcu8YDqQUBl3DX5wPp0CWBMyWkaHa3Etdy0GVsz4zQwmv3Tmv4jBfZ2++
	l1KvlqDgLVA6FcDal2dHlieJcDf2Lv3ckUtDRlGGLAKCZjA39xYoA6NzgWVSxrC4J7oK/7
	D3+L6bNFTl5aU5IuHraNSkYFa6oNY0o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-1WIzDmoRMaqa6nDhdRMleQ-1; Tue, 06 Dec 2022 22:32:47 -0500
X-MC-Unique: 1WIzDmoRMaqa6nDhdRMleQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A23C1C05ACE;
	Wed,  7 Dec 2022 03:32:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3A65440C6EC3;
	Wed,  7 Dec 2022 03:32:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 053D019465A0;
	Wed,  7 Dec 2022 03:32:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 728C41946586
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Dec 2022 03:32:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 60D3F492CA5; Wed,  7 Dec 2022 03:32:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5830F492CA4
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 03:32:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38B7138123A6
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 03:32:42 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-uAoDSaKgOxq7wit3jEOAQQ-1; Tue, 06 Dec 2022 22:32:38 -0500
X-MC-Unique: uAoDSaKgOxq7wit3jEOAQQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 7 Dec
 2022 03:32:36 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 03:32:36 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Bart Van Assche <bvanassche@acm.org>
Thread-Topic: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Thread-Index: AQHZCMWIE493Nhwph0Wuxc84G3ju4K5hM9QAgACTugA=
Date: Wed, 7 Dec 2022 03:32:36 +0000
Message-ID: <765645ed-3508-7092-133f-727f5910497f@nvidia.com>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <1d1c946d-2739-6347-f453-8ccf92c6a0cc@acm.org>
In-Reply-To: <1d1c946d-2739-6347-f453-8ccf92c6a0cc@acm.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|IA1PR12MB6650:EE_
x-ms-office365-filtering-correlation-id: be25d126-e474-4548-a189-08dad803af78
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Nc/QYMzpVRuTomfwt3Ni3FHmF53RHZf/EPlZC0KZ4eAR2ru71xl3ELhDO3vzSZeBm3WXqajqU6H0qraOu5pOYt+ir/LP/+wcvGdvWg424Aff8oXRQUR7TZrUQkXPBF3Q0KnT3FAQIg3c+Zi6F1jtRveXJKEwPAie1+kuCxVAs4Ax+ktWB1LHxNAPqSeTK/3slICFlerZ3IZnssjATCPnQ+oxuoiLm2fcndVPURJ2nhzhmBmNfIYMzbgP38tFaY1XIc+ZoMOJAD+3O9ntFshrAORWqnFh/845ReCBrYG425AgOU7csX1JzD7S3NVyB94CqDOP1B9m7fbV/MW/yzE1sloQxoQfj63FWgJ2SVmr86OlVMcU5actdHQYbqDgL/97tGtKfcS/un8FFDO9TiBrSwTLN6Zt7fzfsYcfbLrXB7DCrYWJB/TS7wIEWz7kPRhX2cy2lHp0SSfKL0f140FLma6PHwROZeHKaya/uHn5erLqT3mb2+CA1dbXWsxXjKzKuCrbpKinktyMkHq5uUUg75oew8grkkwx56UDLatNufgg2rOdkggOuBaPfDQvcr45ZRhu/A/aK+eIZTgFAN7y9ruWf/erGkyn62Pq04WW2q9ucYJjmsU+qEpreT1j3cgU47Fqc4YyEQ01yVzRIh/8Mwp1S/JmqTHoTff+rtWOJiqd4y9lSQkWICVSCa02Nu2fRBj4UpUUKFyAO2DvtSY1sFTLpZ0RsrM7du2EoOHrT4c99sdD4EC3ZekgXId+26C2izpg/YG/zpkjeGfRvYL5clB3NKSc5pfgQfEYdEVevojnZ7w94pE70XjX3DVehOcjdOGZIEWov7gIDoqlnSIRCg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199015)(8936002)(122000001)(6916009)(38100700002)(31686004)(53546011)(66446008)(64756008)(38070700005)(31696002)(7416002)(54906003)(478600001)(66556008)(66946007)(6486002)(66476007)(6506007)(8676002)(966005)(2906002)(316002)(41300700001)(83380400001)(91956017)(36756003)(4326008)(71200400001)(5660300002)(6512007)(76116006)(86362001)(186003)(2616005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWpNN2ZJU0RmWEorQlVvbkg2Z0pBV05JalBnTjMvYXpvOUxicTFPQVdWaDl0?=
 =?utf-8?B?SkppelF0NXlVd29XTkJucFkrNkVvdG80VzlOMW40TmUza2huNUJWYUxDYTlz?=
 =?utf-8?B?Y0ExSmljem1SNm8ya3JSeGtKTytPNkg2MjRyMjN6WHJ1a044aGFBTXIycDdG?=
 =?utf-8?B?cW04QlBSa2M5V0NRRWE3NHF6WVhFcGhDYkRSVG4vNzBqZndMUTZpQXZqcm1G?=
 =?utf-8?B?N0xlWjBZVlBLRyswYlpFMEg5Q0psb1g2OEROTjBpYVZFamV3ZENIT0tuR2Y0?=
 =?utf-8?B?d2VhdkNWc1pzVWk3WXBQK05zQUJ6V05kcG5JZ0ttNU16YUplT1pzelZCai9S?=
 =?utf-8?B?RkRrT3BGdWk2enhHYkhVcFREOUZDUk5aUFB4UnYvWHFjUGtqN2NidmJJakRF?=
 =?utf-8?B?N1cwQncyREJyM21Qd1AzSVJsVzhTcWZ1eWRTWmNIbzFtTTRacm92aWNjWUdu?=
 =?utf-8?B?dk1NOUI3VTVyMG5FVkMrc24zeXh5a0djTFJzYmpma21xK3NDMzRQOWRJeTQr?=
 =?utf-8?B?VTg2UFV0ZUpzd0NkbTV0THNJdXcyd2tDQU9rZmpUbUtNVWxNak5tT1JWTnNT?=
 =?utf-8?B?bEpVUHVaeG10d01mTEJ2Z1hvZ1pTTEkxdFhxMFh4QmhSRzRiVWdoRXlQdVpp?=
 =?utf-8?B?ZWZDMGRUc09UbVpoSUZzbkVqak1BUzVKV1Y3dG4vaHJSSDZxSkkxV1dtUHd2?=
 =?utf-8?B?VTE2OHZmMGMvTWcvSDdhT0FrRHFyZ2RjS3lGTCtDVW42QU1EcXFaMnRKWXV5?=
 =?utf-8?B?eU0yc0ZyMWlnWndFdW10V0dvbGxSUnNkYm1RaVpxa0ZDeXlCdmVheGpRMjhl?=
 =?utf-8?B?cFpjLzZlcjVyMURWczExVDhuMkUrNk44RjByWWJLckVXL2NDS0Q3ZEFlR0hz?=
 =?utf-8?B?dFNnbGpCdmdOTEE1Z2tycDVQblc2NFd3K2dBTkJWUHZvK1dMM1orU0hZbFVa?=
 =?utf-8?B?M0FRenpMRTN5TkI5UnlPRGFMK2g0dDN4OWQwRkwvWHUxa2RRaDFhMzJMa3F4?=
 =?utf-8?B?ZkZnQkxZU0tNVjFXRHo5WlAvTS9lcHAvdHpISFQ0L3NxVmRudndPWnBlc0pj?=
 =?utf-8?B?SlI0OWFQMzlVNGNkWE00OVN3cFVEaVBXckozMlR2RU5DSVJsRUF4UDYwRWNp?=
 =?utf-8?B?WEJGN3ZwYU55UHJwZTNPSlZoT0hjcmJEQ09Kc3A4TFBrSy9OM25sdVdOYVRo?=
 =?utf-8?B?MW1BYkV4WmVpTDVQbHF3ZDdwMmdyQkJZYnpGdzZEeU43OXNvamxQbDBuWEdH?=
 =?utf-8?B?ZG9MVlkrOVVTYmltTEdkS3FIVFQ2bUNBTGs3TkQ2TmJhVDBwWWNHU1loZnRD?=
 =?utf-8?B?Um9iZVlpeVpUVWk5MDMySjJ4cDNPVEZ0RjlpNFVHOE8ydklXSkIzRjZYQ0tV?=
 =?utf-8?B?cE5OSi9ZeVNvSkhkdG5NektZYTNmMTBUMkZJWHVmMEt4bkJWaHdXOUVuZHN1?=
 =?utf-8?B?RlBFc3hvRXE1REMybUdiMHg2SnVwME1WSllWakhJekpJQmRSYnRCQzdlczM5?=
 =?utf-8?B?azF6SWxCZzlGaUFrL2ZrWWN2em9ZakVOT0llN2MrS1psM1d6eHdhMDN5cHlk?=
 =?utf-8?B?QkMvMlVnYmZhRng2dXRheFQrZi9mZU5DTjBXOFNRRTA1K3hHUzQ0N2FNdGo2?=
 =?utf-8?B?OFRpQzMwdVZvdnAyaUVDZzFQUnBic2cwOGtxaFNXZTAxWHpPRFpPVGFJWE12?=
 =?utf-8?B?dlhKMmZKYzc4Wk1tdVIyTEhWYmYxeUlOUHFibjQvRzdXNG9GRE5CYzNiOFNu?=
 =?utf-8?B?d2JUUVN4ZXY5M25ZbzhpRTRmMko4VWtzajh5Z1QrcENhTmMyNVNOOHNkaENO?=
 =?utf-8?B?TXF2Rm9OVVFXeGZzYXhkcld1SVJmRGo5eHo0cFB2NkFVM1VHall2cVFyb244?=
 =?utf-8?B?a2MvejAzYkl6NlFtd3F4NS9uZmRLMU55NnFIeWJvZ0c4Rm5mRVBoZEY5YWl6?=
 =?utf-8?B?OWVrNnppZVBWYmtVZ3ZQMHhqRG54aEZTRjZWYmZtQXJmME96d0N4TFM5eGRF?=
 =?utf-8?B?YXF2SEpOSmd0TWcvenhKa2RXRm5nNXZCZUpEc2h3dXJGdHFINTRoMitjSkRS?=
 =?utf-8?B?UWQ3WjJwdEttZmtSanMzak1zVVFIeHlKM3hVdWQ3SnVEMHVkWFpxWjV3VStI?=
 =?utf-8?B?aWhjbHRtelpMU3pSTkYvdUllT053M011akJvUEF3MzViK0FvelFrTFdnY3B6?=
 =?utf-8?B?anc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be25d126-e474-4548-a189-08dad803af78
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 03:32:36.6141 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YLgEcpH5j4glEeRDNISV53WFyQQLhvy7apoJ0zxO2ffCU+l/rXwQn5kwfrqVVe10lVgK2AzDTcGmufpxHV/vfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Michael S.
 Tsirkin" <mst@redhat.com>, Alvaro Karsz <alvaro.karsz@solid-run.com>,
 Jason Wang <jasowang@redhat.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <6346D3E1CAF68A4396A33ECD0BE9072C@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

QmFydCwNCg0KT24gMTIvNi8yMiAxMDo0MywgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiBPbiAx
Mi81LzIyIDA4OjIwLCBBbHZhcm8gS2Fyc3ogd3JvdGU6DQo+PiArLyogR2V0IGxpZmV0aW1lIGlu
Zm9ybWF0aW9uIHN0cnVjdCBmb3IgZWFjaCByZXF1ZXN0ICovDQo+PiArc3RydWN0IHZpcnRpb19i
bGtfbGlmZXRpbWUgew0KPj4gK8KgwqDCoCAvKg0KPj4gK8KgwqDCoMKgICogc3BlY2lmaWVzIHRo
ZSBwZXJjZW50YWdlIG9mIHJlc2VydmVkIGJsb2NrcyB0aGF0IGFyZSBjb25zdW1lZC4NCj4+ICvC
oMKgwqDCoCAqIG9wdGlvbmFsIHZhbHVlcyBmb2xsb3dpbmcgdmlydGlvIHNwZWM6DQo+PiArwqDC
oMKgwqAgKiAwIC0gdW5kZWZpbmVkDQo+PiArwqDCoMKgwqAgKiAxIC0gbm9ybWFsLCA8IDgwJSBv
ZiByZXNlcnZlZCBibG9ja3MgYXJlIGNvbnN1bWVkDQo+PiArwqDCoMKgwqAgKiAyIC0gd2Fybmlu
ZywgODAlIG9mIHJlc2VydmVkIGJsb2NrcyBhcmUgY29uc3VtZWQNCj4+ICvCoMKgwqDCoCAqIDMg
LSB1cmdlbnQsIDkwJSBvZiByZXNlcnZlZCBibG9ja3MgYXJlIGNvbnN1bWVkDQo+PiArwqDCoMKg
wqAgKi8NCj4+ICvCoMKgwqAgX19sZTE2IHByZV9lb2xfaW5mbzsNCj4+ICvCoMKgwqAgLyoNCj4+
ICvCoMKgwqDCoCAqIHRoaXMgZmllbGQgcmVmZXJzIHRvIHdlYXIgb2YgU0xDIGNlbGxzIGFuZCBp
cyBwcm92aWRlZCBpbiANCj4+IGluY3JlbWVudHMgb2YgMTB1c2VkLA0KPj4gK8KgwqDCoMKgICog
YW5kIHNvIG9uLCB0aHJ1IHRvIDExIG1lYW5pbmcgZXN0aW1hdGVkIGxpZmV0aW1lIGV4Y2VlZGVk
LiBBbGwgDQo+PiB2YWx1ZXMgYWJvdmUgMTENCj4+ICvCoMKgwqDCoCAqIGFyZSByZXNlcnZlZA0K
Pj4gK8KgwqDCoMKgICovDQo+PiArwqDCoMKgIF9fbGUxNiBkZXZpY2VfbGlmZXRpbWVfZXN0X3R5
cF9hOw0KPj4gK8KgwqDCoCAvKg0KPj4gK8KgwqDCoMKgICogdGhpcyBmaWVsZCByZWZlcnMgdG8g
d2VhciBvZiBNTEMgY2VsbHMgYW5kIGlzIHByb3ZpZGVkIHdpdGggDQo+PiB0aGUgc2FtZSBzZW1h
bnRpY3MgYXMNCj4+ICvCoMKgwqDCoCAqIGRldmljZV9saWZldGltZV9lc3RfdHlwX2ENCj4+ICvC
oMKgwqDCoCAqLw0KPj4gK8KgwqDCoCBfX2xlMTYgZGV2aWNlX2xpZmV0aW1lX2VzdF90eXBfYjsN
Cj4+ICt9Ow0KPiANCj4gV2h5IGRvZXMgdGhlIGFib3ZlIGRhdGEgc3RydWN0dXJlIG9ubHkgcmVm
ZXIgdG8gU0xDIGFuZCBNTEMgYnV0IG5vdCB0bw0KPiBUTEMgb3IgUUxDPw0KPiANCj4gSG93IHdp
bGwgdGhpcyBkYXRhIHN0cnVjdHVyZSBiZSBleHRlbmRlZCB3aXRob3V0IGhhdmluZyB0byBpbnRy
b2R1Y2UgYQ0KPiBuZXcgaW9jdGw/DQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KPiANCg0K
V2UgYWxyZWFkeSBkaXNjdXNzZWQgdGhhdCBzZWUgOi0NCg0KaHR0cHM6Ly9saXN0cy5saW51eGZv
dW5kYXRpb24ub3JnL3BpcGVybWFpbC92aXJ0dWFsaXphdGlvbi8yMDIyLU5vdmVtYmVyLzA2Mzc0
Mi5odG1sDQoNCi1jaw0KDQoNCg0KLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbAo=

