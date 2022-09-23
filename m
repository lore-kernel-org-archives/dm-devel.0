Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE1CC6FA82
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 06:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663915076;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7UTmPR4CaJH465nmaBPaWZcRf8UKlMQtuVyIvMWGwqs=;
	b=Q6qYgUI809PvgEuK9yOzPlg97FP2RK4VoVyF6zp5jBls9s+rGbaLxk07oHL0Qu9DENIX0B
	MkRRLq34mzZaP3cw2/9EszYgJwyGM1kAI2JX9MUmKRRgLMlHWWpRLkPo89AVY0FYb3ucP2
	FbPapyR+Gj/0BU01QCJE1FrgwRuFKaE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-C9N9xfhkPhm4LFIhgzydeA-1; Fri, 23 Sep 2022 02:37:53 -0400
X-MC-Unique: C9N9xfhkPhm4LFIhgzydeA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7083C858F13;
	Fri, 23 Sep 2022 06:37:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4F73F53AA;
	Fri, 23 Sep 2022 06:37:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 08DEF1946A67;
	Fri, 23 Sep 2022 06:37:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D7C3719465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 06:30:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B3DD917595; Fri, 23 Sep 2022 06:30:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AB5AE53AA
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 06:30:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86C2D801231
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 06:30:53 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-qmXVX39vNwKJYrmiWHAEYA-1; Fri, 23 Sep 2022 02:30:49 -0400
X-MC-Unique: qmXVX39vNwKJYrmiWHAEYA-1
X-IronPort-AV: E=Sophos;i="5.93,337,1654531200"; d="scan'208";a="212093524"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO
 NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
 by ob1.hgst.iphmx.com with ESMTP; 23 Sep 2022 14:29:43 +0800
Received: from BYAPR04MB4968.namprd04.prod.outlook.com (2603:10b6:a03:42::29)
 by DM5PR04MB0395.namprd04.prod.outlook.com (2603:10b6:3:a7::7) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.18; Fri, 23 Sep 2022 06:29:42 +0000
Received: from BYAPR04MB4968.namprd04.prod.outlook.com
 ([fe80::971b:edb2:b548:362e]) by BYAPR04MB4968.namprd04.prod.outlook.com
 ([fe80::971b:edb2:b548:362e%5]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 06:29:42 +0000
From: =?utf-8?B?TWF0aWFzIEJqw7hybGluZw==?= <Matias.Bjorling@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, Damien Le Moal
 <damien.lemoal@opensource.wdc.com>, Mike Snitzer <snitzer@redhat.com>, Pankaj
 Raghav <p.raghav@samsung.com>
Thread-Topic: Please further explain Linux's "zoned storage" roadmap [was: Re:
 [PATCH v14 00/13] support zoned block devices with
 non-power-of-2 zone sizes]
Thread-Index: AQHYzhW1Mb/B0wZcH0CBE49f2UQ9X63sIZgAgABnTfA=
Date: Fri, 23 Sep 2022 06:29:41 +0000
Message-ID: <BYAPR04MB4968EB5E341049DFF973B9B1F1519@BYAPR04MB4968.namprd04.prod.outlook.com>
References: <CGME20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc@eucas1p2.samsung.com>
 <20220920091119.115879-1-p.raghav@samsung.com> <YytJhEywBhqcr7MX@redhat.com>
 <7dd9dbc0-b08b-fa47-5452-d448d86ca56b@opensource.wdc.com>
 <8fd1d8b1-9f43-eb03-4a7f-187723d1c483@acm.org>
In-Reply-To: <8fd1d8b1-9f43-eb03-4a7f-187723d1c483@acm.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR04MB4968:EE_|DM5PR04MB0395:EE_
x-ms-office365-filtering-correlation-id: 6a1f9abb-662d-4ee6-9807-08da9d2cffbf
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: StPIXNNFIg6qZ95lEXTtcJubeIvZaRaJuS6JhEZlkTzRrOQdjhxnGZBDdvrcL7EpV7igHp90jzZKPeIXpp2ubG/cFxzK0FGDdHot3kHCXOs8PDJK9nnPL1DCCGCdMGlwoupg21oJYLkm3vzLQk2JdajXAjCnWSm0pMZf1mLt09JqQbE+pQ5CufAab0mETwH6d7lEgYk5qOVOIefBAwBmAqCXPOihgDfeSyb8h1zwkvnmsoNbrAZXvXtBJju2qLByr7ESzB/RlY8oaTohnnOCohX2JnFCgv4p6PeY355yl3OafRjfKbyqHndGQeWCRm9nXfd68afaS9h4dBR03sSchrq7mTffd5BA2UIZyg66vaHNQpM9QWVqiDaRVhnFGLLeQc86zov1UtGKgLnOeRZuWeTrRmtiCaln736dYoUnLiIeTMbmAMw8DoE+l0rhEI/tKgDI+XGcXfUqgnIX3ti271otTCE23DpatxPt3d6iPyjfuMsR4lW/n36V9xxSjzBq3cd6Cq7mz44FevnkunuYuTqk2cFjUfi2xDYqeSwY2/e2p3F6pDpjwJ75QUakRg3HjfNGke2puWgj0D/TC5DcnobeYqMgVA+RtAjGnjMLx4ml/GLnE8K+C4qv49AkwS6MudaL0gUMJe+0HR7NnSjbVY3t3jE3jqMSHn1r+W1sW0vvdoke5lI+w8BHEjDI8N+KWGIoxssCVX2R5kyil8Zcke5/uRtVkwH7eNhCLmDZUduPtLxVE6KhtuhKY67CspzVJ5OwlZ8CZwpBIuYVGxLkDQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BYAPR04MB4968.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(55016003)(54906003)(71200400001)(82960400001)(110136005)(186003)(86362001)(38100700002)(2906002)(53546011)(5660300002)(7416002)(66556008)(66574015)(316002)(33656002)(66446008)(8936002)(66946007)(6506007)(7696005)(85202003)(9686003)(478600001)(83380400001)(76116006)(52536014)(38070700005)(66476007)(41300700001)(26005)(122000001)(4326008)(64756008)(8676002)(85182001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGVFbnAyU09mdUpBNWhXclNjWDduUUw4T0YrNFBEQjYrL1VhN24xSDBZUW1C?=
 =?utf-8?B?QUVFYUl0R1gxSnF4T1JIb1JpQVhhdERRSWZCUTJscVdia0s1aE9ENWpNcGJm?=
 =?utf-8?B?dDEzN2FjbHVuVit1Z21MVTRvY0E4NkU5Q0l0WXBuZllsSWxVVzNOTzh3eEFB?=
 =?utf-8?B?UE1DRlJJUWNVYThMV2FqN2xkOWNiVVFiMjRza0JESU9JcDYrSVhUZEorZzRu?=
 =?utf-8?B?SldNcmZUendtVkNTcGcyRmN5YWNpdmlHOW9NUTVNV2lDUmtBVE1Xa2s0Wkhs?=
 =?utf-8?B?U3l5YWozaUdjR25SS0Ivd0FHWnI4SlF5Vy9TUUljeWt5dVliMzRpVEkzV3RZ?=
 =?utf-8?B?dFdWZkcrZzZyUWRPVDFBNE1wUDg2TW5uV0hXanY0bERGZ1haeDU0VHd6N0hw?=
 =?utf-8?B?NmV6NFhiSkIxUjJnZGR2LzNremNtb1o4Y2U1TmIvUUVJSkxlYkRNeVhOZjRF?=
 =?utf-8?B?MVdiOEI5M3I3dUJlM0h2RHpVVzZNK0duNlNaeVRNdlF5L3Vsb28xMnE5bzZ1?=
 =?utf-8?B?U01wV1Q5Ymc3b0VzK2lvaENBdFNCOCtrRXpBNlFhcE5BYUgzdkpjUnVuL2lB?=
 =?utf-8?B?THZaZllIZjNHZlVSOVlOT1ZZUjZ6c0FHTDFua3BPWC9oby9mN3pudURvcVF0?=
 =?utf-8?B?ZjNsaXNWZFBEdE54NFM5YUtVZU12dWh6Z3ZlRkdyN2psYWhmNjVNQlJHVGdy?=
 =?utf-8?B?SGY0RzFiVzlQdXlsKzBmMmtwY2FyWGV0TkJlVXJwMWlDRWdRZ1o0U3dxTysr?=
 =?utf-8?B?Um9SMzhTcmhTdEpRamZZMnJxM0tlODA3SHBwODYzNG1iMkZoTk1ickIwcTVS?=
 =?utf-8?B?SFNIKzhVdnN2alR0R1VEaHRweGxJVU9haHh3c0FwMGpTTTVOUEhDQ2VaQ3N5?=
 =?utf-8?B?ZTFmVGlWZWhNT2lKZXh5SUI2cmxpa1BSRkRVMXhvR01ld3ZvS05QaUg2Y21V?=
 =?utf-8?B?a3FNQXlUY2NoU1JHQWszWEowZUxnRVI2UVBRWVJSU1NJUmdQOWVuK2kzblJ6?=
 =?utf-8?B?WGcyZGJrNzF4VFRWV04xTm5RYzhseDNaQ0xOZFMxUExEb2E2OXF2MG9zNC9H?=
 =?utf-8?B?cFBPRVAwbE5VVFF2OHVGcnNSemppd0h6QXZXRUIyd0tRcEFrUUo3MzlSeFI4?=
 =?utf-8?B?dXFtMzZPUUtXRUdUbjJPOVBpQUxLUndpc2haNjl5ZnVKL0dSOTJSRlk4VGV6?=
 =?utf-8?B?dW51SVh3bWV0bTF6L2Q2WjE5R2EwZlNzR095R3FjWFNHdXUxYjdBYXlId1FP?=
 =?utf-8?B?dkYrMU5jNFVzSnFLdDY0cENTMFMxRStPNVdPNTI5a2pBemtRVHFoVzhxdnkx?=
 =?utf-8?B?c3BQMWJKUktHUndBLzQwTjEvRHowVld4VzkvMjk0SVpnKzRXdHdhWDg0QlJ4?=
 =?utf-8?B?cStSRlkyaGR2Y1pYVXR4NHY5MHdDV2g2d3BjSDdIc3FlZ3poWUJ0UG9tSUFr?=
 =?utf-8?B?NEs2ZUVwa2l2dEt1WEtjZ3pUbDEzaTVYTWVBaUJRc2lkYjN0NDJPUDExcGxX?=
 =?utf-8?B?dk12TVVsSTVlakY2QkY5QkFBb0R4TXlaQ1FlL3FDRlhSdzZURURGVmR3UUFx?=
 =?utf-8?B?ZDdwdDFFcVFGMnhrNCtuN0dQMkY3QUlycmRDOVV4MHZHajFVT3B3T3MwendJ?=
 =?utf-8?B?NkxPNUJ3Y01QZHYydGp4YlBSQmRSSXo1MVVQR25sY3J5eGNVZGtod1RGS3JN?=
 =?utf-8?B?NGQrS2ZWbU1BVkwyZGRxcVR3elQyWFIrY1VLaXV6N0FRN1hON2R2aTNaQXVq?=
 =?utf-8?B?Z1EvLzQzVFNlSTVrSDFaTGt5R21mMEJTUW9EM29QNVBxb3RPbDhWVzN4bHpx?=
 =?utf-8?B?NHBwdnl4OSs2WGdOUm9BZWI5Rkp1ajBHTmpXTjErTXVHKzc5YUpycmpaQkJr?=
 =?utf-8?B?V081WFY3V1BxdEo0YnM5RXUySHQ0YkFKVGZxNXpuaU1ub1hVL3BrVlMvN09w?=
 =?utf-8?B?ck1pd244T1BqRUVpRHRDT25QcTBPanQ2eTdVWGJPUit3QnFPRFBxZFhUTytr?=
 =?utf-8?B?WS82dGRvaGFwVmw3MHVkSlZvR2cwMnk5cjViekhQaHdITFJ6ejdqem9uU2VE?=
 =?utf-8?B?QlVsZVh2WkxqQVhIV0Zzc0xEcGpSamcrWmduUWZFNXErWUJLTDU1UU5RWnZO?=
 =?utf-8?Q?sCdG2WAEJtxCMU3x3nKa2WE67?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4968.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a1f9abb-662d-4ee6-9807-08da9d2cffbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 06:29:42.0902 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g5aRRx3fXll3UuhnKrMRjWxmp1RoQWZrmGWzhiXrU1pNbImagaRgDZ58IcdBgAKhUMDTzahV3RONbCavmRmKIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0395
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Fri, 23 Sep 2022 06:37:48 +0000
Subject: Re: [dm-devel] Please further explain Linux's "zoned storage"
 roadmap [was: Re: [PATCH v14 00/13] support zoned block devices with
 non-power-of-2 zone sizes]
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
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgPGJ2
YW5hc3NjaGVAYWNtLm9yZz4NCj4gU2VudDogRnJpZGF5LCAyMyBTZXB0ZW1iZXIgMjAyMiAwMS41
Ng0KPiBUbzogRGFtaWVuIExlIE1vYWwgPGRhbWllbi5sZW1vYWxAb3BlbnNvdXJjZS53ZGMuY29t
PjsgTWlrZSBTbml0emVyDQo+IDxzbml0emVyQHJlZGhhdC5jb20+OyBQYW5rYWogUmFnaGF2IDxw
LnJhZ2hhdkBzYW1zdW5nLmNvbT4NCj4gQ2M6IGFna0ByZWRoYXQuY29tOyBzbml0emVyQGtlcm5l
bC5vcmc7IGF4Ym9lQGtlcm5lbC5kazsgaGNoQGxzdC5kZTsNCj4gcGFua3lkZXY4QGdtYWlsLmNv
bTsgZ29zdC5kZXZAc2Ftc3VuZy5jb207IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+
IGxpbnV4LW52bWVAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgtYmxvY2tAdmdlci5rZXJuZWwu
b3JnOyBkbS0NCj4gZGV2ZWxAcmVkaGF0LmNvbTsgSm9oYW5uZXMgVGh1bXNoaXJuIDxKb2hhbm5l
cy5UaHVtc2hpcm5Ad2RjLmNvbT47DQo+IGphZWdldWtAa2VybmVsLm9yZzsgTWF0aWFzIEJqw7hy
bGluZyA8TWF0aWFzLkJqb3JsaW5nQHdkYy5jb20+DQo+IFN1YmplY3Q6IFJlOiBQbGVhc2UgZnVy
dGhlciBleHBsYWluIExpbnV4J3MgInpvbmVkIHN0b3JhZ2UiIHJvYWRtYXAgW3dhczogUmU6DQo+
IFtQQVRDSCB2MTQgMDAvMTNdIHN1cHBvcnQgem9uZWQgYmxvY2sgZGV2aWNlcyB3aXRoIG5vbi1w
b3dlci1vZi0yIHpvbmUNCj4gc2l6ZXNdDQo+IA0KPiBPbiA5LzIxLzIyIDE2OjU1LCBEYW1pZW4g
TGUgTW9hbCB3cm90ZToNCj4gPiBCdXQgYWdhaW4sIHRoYXQgYWxsIGRlcGVuZHMgb24gaWYgUGFu
a2FqIHBhdGNoIHNlcmllcyBpcyBhY2NlcHRlZCwNCj4gPiB0aGF0IGlzLCBvbiBldmVyeWJvZHkg
YWNjZXB0aW5nIHRoYXQgd2UgbGlmdCB0aGUgcG93ZXItb2YtMiB6b25lIHNpemUNCj4gY29uc3Ry
YWludC4NCj4gDQo+IFRoZSBjb21wYW5pZXMgdGhhdCBhcmUgYnVzeSB3aXRoIGltcGxlbWVudGlu
ZyB6b25lZCBzdG9yYWdlIGZvciBVRlMgZGV2aWNlcw0KPiBhcmUgYXNraW5nIGZvciBrZXJuZWwg
c3VwcG9ydCBmb3Igbm9uLXBvd2VyLW9mLTIgem9uZSBzaXplcy4NCj4gDQo+IFRoYW5rcywNCj4g
DQo+IEJhcnQuDQoNCkhpIEJhcnQsDQoNCldpdGggVUZTLCBpbiB0aGUgcHJvcG9zZWQgY29weSBJ
IGhhdmUgKG1heSBiZWVuIGNoYW5nZWQpIC0gdGhlcmUncyB0aGUgY29uY2VwdCBvZiBnYXAgem9u
ZXMsIHdoaWNoIGlzIHpvbmVzIHRoYXQgY2Fubm90IGJlIGFjY2Vzc2VkIGJ5IHRoZSBob3N0LiBU
aGUgZ2FwIHpvbmVzIGFyZSBlc3NlbnRpYWxseSAiTEJBIGZpbGxlcnMiLCBlbmFibGluZyB0aGUg
bmV4dCB3cml0ZWFibGUgem9uZSB0byBzdGFydCBhdCBhIFggKiBwb3cyIHNpemUgb2Zmc2V0LiBN
eSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQgdGhpcyBzcGVjaWZpYyBhcHByb2FjaCB3YXMgY2hvc2Vu
IHRvIHNpbXBsaWZ5IHN0YW5kYXJkaXphdGlvbiBpbiBVRlMgYW5kIGF2b2lkIHVwZGF0aW5nIFQx
MCdzIFpCQyB3aXRoIHpvbmUgY2FwYWNpdHkgc3VwcG9ydC4gDQoNCldoaWxlIFVGUyB3b3VsZCB0
ZWNobmljYWxseSBleHBvc2Ugbm9uLXBvd2VyIG9mIDIgem9uZSBzaXplcywgdGhleSdyZSBhbHNv
LCBkdWUgdG8gdGhlIGdhcCB6b25lcywgY291bGQgYWxzbyBiZSBjb25zaWRlcmVkIHBvd2VyIG9m
IDIgem9uZXMgaWYgb25lIGNvbnNpZGVycyB0aGUgc2VxLiB3cml0ZSB6b25lICsgdGhlIGdhcCB6
b25lIGFzIGEgc2luZ2xlIHVuaXQuIA0KDQpXaGVuIEkgdGhpbmsgYWJvdXQgaGF2aW5nIFVGUyBz
dXBwb3J0IGluIHRoZSBrZXJuZWwsIHRoZSBTV1IgYW5kIHRoZSBnYXAgem9uZSBjb3VsZCBiZSBy
ZXByZXNlbnRlZCBhcyBhIHNpbmdsZSB1bml0LiBGb3IgZXhhbXBsZToNCg0KVUZTIC0gWm9uZSBS
ZXBvcnQNCiAgWm9uZSAwOiBTV1IsIExCQSAwLTExDQogIFpvbmUgMTogR2FwLCBMQkEgMTItMTUN
CiAgWm9uZSAyOiBTV1IsIExCQSAxNi0yNw0KICBab25lIDM6IEdhcCwgTEJBIDI4LTMxDQogIC4u
Lg0KDQpLZXJuZWwgcmVwcmVzZW50YXRpb24gLSBab25lIFJlcG9ydCAoYXMgc3VwcG9ydGVkIHRv
ZGF5KQ0KICBab25lIDA6IFNXUiwgTEJBIDAtMTUsIFpvbmUgQ2FwYWNpdHkgMTINCiAgWm9uZSAx
OiBTV1IsIExCQSAxNi0zMSwgWm9uZSBDYXBhY2l0eSAxMg0KICAuLi4NCg0KSWYgZG9pbmcgaXQg
dGhpcyB3YXksIGl0IHJlbW92ZXMgdGhlIG5lZWQgZm9yIGZpbGVzeXN0ZW1zLCBkZXZpY2UtbWFw
cGVycywgdXNlci1zcGFjZSBhcHBsaWNhdGlvbnMgaGF2aW5nIHRvIHVuZGVyc3RhbmQgZ2FwIHpv
bmVzLCBhbmQgYWxsb3dzIFVGUyB0byB3b3JrIG91dCBvZiB0aGUgYm94IHdpdGggbm8gY2hhbmdl
cyB0byB0aGUgcmVzdCBvZiB0aGUgem9uZWQgc3RvcmFnZSBlY28tc3lzdGVtLiANCg0KSGFzIHRo
ZSBhYm92ZSByZXByZXNlbnRhdGlvbiBiZWVuIGNvbnNpZGVyZWQ/DQoNCkJlc3QsIE1hdGlhcw0K
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0
bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

