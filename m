Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E016BC47089
	for <dm-devel@archiver.kernel.org>; Mon,  5 Dec 2022 22:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670279299;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RbzbG5sTk+kmjXz3QGR7Qkj4BMXyZCiuYXQK/QkmvsE=;
	b=faScNR7kFWKbJIBYw7xuCukAhegZmgPvZC9WOU3joK+0B/NaAtQKNKFrJyUOieGYnQn7ae
	oF+MagBXsAPzBQYvF3XkWxOzgYXIpWTAcHQVk4BZMm1W+pu2JJpyajTIcYgDHwuWOQPK3p
	30DEHgaQPKQ4oGQN3TsOxT/hIGtaneU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-Y_AlUikgMvG3q20DI-Rj3g-1; Mon, 05 Dec 2022 17:28:16 -0500
X-MC-Unique: Y_AlUikgMvG3q20DI-Rj3g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2A6886EB23;
	Mon,  5 Dec 2022 22:28:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C4826492B07;
	Mon,  5 Dec 2022 22:28:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 725821946589;
	Mon,  5 Dec 2022 22:28:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BC9791946588
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Dec 2022 22:28:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5881B141511A; Mon,  5 Dec 2022 22:28:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 20C531415100
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 22:28:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00F803810785
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 22:28:10 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-L8WUoiY2Ml6hS2JFte3piw-1; Mon, 05 Dec 2022 17:28:06 -0500
X-MC-Unique: L8WUoiY2Ml6hS2JFte3piw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB7628.namprd12.prod.outlook.com (2603:10b6:208:436::6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 22:28:03 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 22:28:02 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>, Alvaro Karsz <alvaro.karsz@solid-run.com>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>
Thread-Topic: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Thread-Index: AQHZCMWIE493Nhwph0Wuxc84G3ju4K5fm/IAgABELwA=
Date: Mon, 5 Dec 2022 22:28:02 +0000
Message-ID: <8de86bbf-b6dc-7945-2004-f41b05055dd9@nvidia.com>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk>
In-Reply-To: <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|IA0PR12MB7628:EE_
x-ms-office365-filtering-correlation-id: 9ef777b8-c930-4e61-be24-08dad70ff90a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: QAAq4HvDYMX5PQrzZ9riDk5R+mJ3LYBlvV67f98TJ1c4mQDZoi0whTLwb6LYaq2piv6w2aCj9fZ7OS4fPZ3rsRoRHXHgEjSIpx6UEyZUDUJcyq0Vv7vSSErFHyJMMxLlTKwyfAHE3qPqotq/9EBNqgQSsX/Hr6Bqf7nztlYcpfSZYelCOTk1mG/C1J3DPwhQNuqKe4mteyVPSusvbQBekTXY1V/jpa9mnn//5gM9eT0icJtPFoPTrMJ9Dofw0pmIE3UXvuCWl6N4cNGWe+LBepxWZB6zlPn7I3L2JwQG9jBa78LaNkZaSGt/B5sGB/c+wZFJm7YIcc/2YBYZeLihE5CJxs2LS2HJzE4awfiiBVQMNU6cU4L1Tb84IA4EtWYRZ6feEhgU0QzO9Mfg0y+L1J8cR5VWZp2azoKF+uEy2Nz7F+oF0+Mg/nxFIf1nnnzR6c1LH8W8/ywxoPVpFQTbNecoSvghAb4MXyknIy6e9SC+DnZ4Da1HRNORirMSCTadp/kUMqgGrEwG4njQl++2eAx9qlqiVzjDPJ3lkckc1KZbdPMKba0wx0cwahN1xdCp8U4m2Uhs0yPeTjXaQaN13QzeqvILLdUj8lv4sA7SXP8xRkcp40xVd5o6sbdzoqv0PMsW8C0o+efRQVgtF4xph0o3RsQVZMOvK14KF1vXirQxFWpWfSuovuZdfjs9tf/Pi7idX68jhS+jGAp4nnClU0IkoNLlhwBAFEo93/Rv/RaCeMOnKU0noDTaK5EiQ3HXRTEGfj46gHU5cx3/dVkixQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199015)(38070700005)(2906002)(7416002)(5660300002)(38100700002)(122000001)(31686004)(31696002)(86362001)(83380400001)(53546011)(478600001)(6512007)(186003)(6506007)(110136005)(71200400001)(54906003)(6486002)(64756008)(8676002)(66446008)(76116006)(4326008)(91956017)(66476007)(316002)(8936002)(41300700001)(66556008)(2616005)(36756003)(66946007)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWJOTGh2a3VJOUNqTnIxNnYxcklCS2s1MUZyODR0U1B1MlJzU2pDcUpuSDhp?=
 =?utf-8?B?VHlSZFJxMlJRdldUYnR5RFRoZzliL3EyYklKQlZHd1RpN1MyYlNtTU5sOHE2?=
 =?utf-8?B?c1VoYWRkM3dhc2JOSU9VRzZYYTFWVHpwazVNb3JmMUsvdkY2ZzczbUdTVGs2?=
 =?utf-8?B?d1FseHJFVExvaDFkdUdaQnlrd2NBdllrRGZheWh1cVhCWW5jUk05UjFYQUFy?=
 =?utf-8?B?OGZYai9ENk1iR01xc1ZuWVNWNXB4R1BaSjhmaTI2UlZUNjY4NUI1SFhKNWU2?=
 =?utf-8?B?ay9ucGVhRVlxSy9icFNEbkpLWG83ejBXMlZLcTAyRERsMWFaV2w1ZXkwNVY2?=
 =?utf-8?B?RFBHSTNzckhXM1dkeENsVGt2cWJtSHhLVC9ZK25wVGFFa0JNZm91blRNeHJ0?=
 =?utf-8?B?WTRYVmdpckhiRlEvTEVheHAya1NsTG1pRWRESDFqdXgvNm0zZ3VnRmd6MmpT?=
 =?utf-8?B?cEdmUjdEdG93QXkxelNoU3RmaVlRV0ZHL2RlelhhWm5ESm9kL3RsK2JjUnZn?=
 =?utf-8?B?cktYVG5aVWtwTnRWeVFJTVhTOG5rRFprd1pRcnVKalgvdHdMUTdJZm9CdjJU?=
 =?utf-8?B?NlBJVXkzeWRBeTdTOHRwTHNXS0hoWlpKLzBkVHgrUXFjcDltNjB0aGVSdXhw?=
 =?utf-8?B?UGQrRmRGWldDMVF4LzBLaXRSZDZCbmZnR25TRk4vbWRMbUhiOWo5WU1hSWVO?=
 =?utf-8?B?TlNGakVzTzRIL0dJRmp4aEZHZG51a3dpdEhYdm1NT3JQT1BIT2xTTkVzeWtp?=
 =?utf-8?B?QXhtazNyY0NBUzdndTNXMGtvdUw1VWU2b2srMFR4eEdIUmJRWWFxQmMvU3dN?=
 =?utf-8?B?YjZncHdiT3VTcXNDRjFydEF6eXZHNkpSV3IrSlB3VDdnZTFpcGpqUnhCbm91?=
 =?utf-8?B?b0NQc3BPaWNGTUc0YlkxQlVWZ3V6amFyOHJqTnJ6ZVdDZGxCSkxUc2hjRGQ4?=
 =?utf-8?B?bXJaZHRNWlZReFZ6QS91ZlVieGs4NjJ6SmhFV1c3Vkk0cFhHSTJSR0JXQTRJ?=
 =?utf-8?B?NjU5T295SEJ1cHJST2dQbjNKUWprY0pPZURBU0VoVWRNYVB2cWxBMld4akpB?=
 =?utf-8?B?bjF3aFdaRTVMSGJWK1VFSlBCbklrU2gvdU1HWXliano3OXQ1T3RzSXZDZmF6?=
 =?utf-8?B?YWNUVFRjbXJkNXB2VHhuRHNqWEZYWUo0d01KQ3NlTXJzdDdLZ2ZydStsNDA2?=
 =?utf-8?B?Qk82aVh2cFNNVERudVdma0V2M1MvQ01BbFEwd3ZmQVdoaDNYcnlSOHR2TmpO?=
 =?utf-8?B?MmRXWGF3M2wxd0hhbE5UaHRzeGJVODdGNjlDNUhGcDZLZVh6MXNweFdIaEdi?=
 =?utf-8?B?dDExSWE3b0RVL0F0cWhqQ3VFckJ5ajg2OVk2NkI5ZXpiMks4Y1FKTUVha0kw?=
 =?utf-8?B?bVF5emkvTEFhUEFkbmRaWERwdlJSY05UNWg5SFNGUFBERWl0OU9FZ0lab2Vw?=
 =?utf-8?B?dVFvTFVGNndLcDB6anNiMEpySG5ybzVabGNLOFdxeW85R2FtM2JqN05wTmRa?=
 =?utf-8?B?dmUyM2dqSlV2WitONGQyWit0MTNvMUprZ2pwS3RPYTQzYkU1TldnMm1IZjNW?=
 =?utf-8?B?Z0RGazkvWWF4RURlbnR1Y3R5Wk1NSUxxQ20wSmdvMmtsaVFZQzBzRC82VVkr?=
 =?utf-8?B?UE42UmZjQk5DMmpYZE9SZitFdzlydHY1T3VSc3QzWElVSnoxajdBWUdZUE5h?=
 =?utf-8?B?QzNqd0E0Z2pUME9Ub1VSTDFhd2pIc0J5RUpESmdxUGY3eXB4NXBabklqQ3R6?=
 =?utf-8?B?V0VTendmaDAraVBWMEdiZUpicjl2bVdEdk5wVEZKazF0MFl1UThXZVRhZllG?=
 =?utf-8?B?Yk9yVFVhQTNGY0NybTA3bXhhQzgzQkxSUk8xT2tWeTZhSnR2WjV5K003TWtN?=
 =?utf-8?B?K0dOMzJDb1NGMXpRSHdFdXJpV21lYUhuQmNHRU92Y2RieGdKYWl0V3lNczlr?=
 =?utf-8?B?V1lVTGpsUHN2ZG05am8zVm9RS3dxR1h5di9RckJLdUJzdUVjZHJMRGxwY3c5?=
 =?utf-8?B?YzFOUDNiTUtWOS8yNTdFZnF1cVlqZktVVHZJdDlOSWEveWQyTWpYNE93c3Zn?=
 =?utf-8?B?c0pXQklQNXhpODBrYlY0ODM5LzVXenVYVkpxU0N1cHFwZUc1dFJPZnFwSmlV?=
 =?utf-8?B?Ukhwd2M5LzhSZk9SbzNpOCtadHF1UVJjV2k1WW9yQWFPTkQwS3lmcXJPVW4w?=
 =?utf-8?B?YVE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef777b8-c930-4e61-be24-08dad70ff90a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2022 22:28:02.8433 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dvs66/jF72orQxdUgfmn6X1xOnYTqPvMe0Jrap9ODfEIUqD4GxceBnQdrzrvoqecUHiTi1dH/cWBLId6CF89IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7628
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <ADF4CE53BDD37F45B159F10C49F434D9@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMTIvNS8yMiAxMDoyNCwgSmVucyBBeGJvZSB3cm90ZToNCj4gT24gMTIvNS8yMiA5OjIw4oCv
QU0sIEFsdmFybyBLYXJzeiB3cm90ZToNCj4+IEltcGxlbWVudCB0aGUgVklSVElPX0JMS19GX0xJ
RkVUSU1FIGZlYXR1cmUgZm9yIFZpcnRJTyBibG9jayBkZXZpY2VzLg0KPj4NCj4+IFRoaXMgY29t
bWl0IGludHJvZHVjZXMgYSBuZXcgaW9jdGwgY29tbWFuZCwgVkJMS19MSUZFVElNRS4NCj4+DQo+
PiBWQkxLX0xJRkVUSU1FIGlvY3RsIGFza3MgZm9yIHRoZSBibG9jayBkZXZpY2UgdG8gcHJvdmlk
ZSBsaWZldGltZQ0KPj4gaW5mb3JtYXRpb24gYnkgc2VuZGluZyBhIFZJUlRJT19CTEtfVF9HRVRf
TElGRVRJTUUgY29tbWFuZCB0byB0aGUgZGV2aWNlLg0KPj4NCj4+IGxpZmV0aW1lIGluZm9ybWF0
aW9uIGZpZWxkczoNCj4+DQo+PiAtIHByZV9lb2xfaW5mbzogc3BlY2lmaWVzIHRoZSBwZXJjZW50
YWdlIG9mIHJlc2VydmVkIGJsb2NrcyB0aGF0IGFyZQ0KPj4gCQljb25zdW1lZC4NCj4+IAkJb3B0
aW9uYWwgdmFsdWVzIGZvbGxvd2luZyB2aXJ0aW8gc3BlYzoNCj4+IAkJKikgMCAtIHVuZGVmaW5l
ZC4NCj4+IAkJKikgMSAtIG5vcm1hbCwgPCA4MCUgb2YgcmVzZXJ2ZWQgYmxvY2tzIGFyZSBjb25z
dW1lZC4NCj4+IAkJKikgMiAtIHdhcm5pbmcsIDgwJSBvZiByZXNlcnZlZCBibG9ja3MgYXJlIGNv
bnN1bWVkLg0KPj4gCQkqKSAzIC0gdXJnZW50LCA5MCUgb2YgcmVzZXJ2ZWQgYmxvY2tzIGFyZSBj
b25zdW1lZC4NCj4+DQo+PiAtIGRldmljZV9saWZldGltZV9lc3RfdHlwX2E6IHRoaXMgZmllbGQg
cmVmZXJzIHRvIHdlYXIgb2YgU0xDIGNlbGxzIGFuZA0KPj4gCQkJICAgICBpcyBwcm92aWRlZCBp
biBpbmNyZW1lbnRzIG9mIDEwdXNlZCwgYW5kIHNvDQo+PiAJCQkgICAgIG9uLCB0aHJ1IHRvIDEx
IG1lYW5pbmcgZXN0aW1hdGVkIGxpZmV0aW1lDQo+PiAJCQkgICAgIGV4Y2VlZGVkLiBBbGwgdmFs
dWVzIGFib3ZlIDExIGFyZSByZXNlcnZlZC4NCj4+DQo+PiAtIGRldmljZV9saWZldGltZV9lc3Rf
dHlwX2I6IHRoaXMgZmllbGQgcmVmZXJzIHRvIHdlYXIgb2YgTUxDIGNlbGxzIGFuZCBpcw0KPj4g
CQkJICAgICBwcm92aWRlZCB3aXRoIHRoZSBzYW1lIHNlbWFudGljcyBhcw0KPj4gCQkJICAgICBk
ZXZpY2VfbGlmZXRpbWVfZXN0X3R5cF9hLg0KPj4NCj4+IFRoZSBkYXRhIHJlY2VpdmVkIGZyb20g
dGhlIGRldmljZSB3aWxsIGJlIHNlbnQgYXMgaXMgdG8gdGhlIHVzZXIuDQo+PiBObyBkYXRhIGNo
ZWNrL2RlY29kZSBpcyBkb25lIGJ5IHZpcnRibGsuDQo+IA0KPiBJcyB0aGlzIGJhc2VkIG9uIHNv
bWUgc3BlYz8gQmVjYXVzZSBpdCBsb29rcyBwcmV0dHkgb2RkIHRvIG1lLiBUaGVyZQ0KPiBjYW4g
YmUgYSBwcmV0dHkgd2lkZSByYW5nZSBvZiB0d28vdGhyZWUvZXRjIGxldmVsIGNlbGxzIHdpdGgg
d2lsZGx5DQo+IGRpZmZlcmVudCByYW5nZXMgb2YgZHVyYWJpbGl0eS4gQW5kIHRoZXJlJ3MgcmVh
bGx5IG5vdCBhIGxvdCBvZiBzbGMNCj4gZm9yIGdlbmVyaWMgZGV2aWNlcyB0aGVzZSBkYXlzLCBp
ZiBhbnkuDQo+IA0KDQpUaGlzIGlzIGV4YWN0bHkgd2hhdCBJIHNhaWQgb24gaW5pdGlhbCB2ZXJz
aW9uIGFib3V0IG5ldyB0eXBlcyAuLi4NCg0KLWNrDQoNCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWwK

