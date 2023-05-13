Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F376AC77B7F
	for <dm-devel@archiver.kernel.org>; Sat, 13 May 2023 01:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683940165;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+xmhyZModoQWrHb5NFwRS8U+xNYe+mrcgtXJsG9s35k=;
	b=W+c6AkfdfbeK1o8SKm6CSLreXhi12i3Oat6YfZs2bmnIX6f0KhBexm3jHV3SFBLUB7exqf
	m+aSC7bn6WmWMadgrc6s+v1WGEIus4+G6AhZMojS5l2cV22+18zZoczrw6fAC+BP1/ZgAL
	DCORv15fodlla1NIf99M9pEndL8srgw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-iNV7uNqUMietbOktX1kwgw-1; Fri, 12 May 2023 21:09:22 -0400
X-MC-Unique: iNV7uNqUMietbOktX1kwgw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBB9138060FE;
	Sat, 13 May 2023 01:09:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EEFE22026D16;
	Sat, 13 May 2023 01:09:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B01FA19451E4;
	Sat, 13 May 2023 01:09:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BA0A819451E3
 for <dm-devel@listman.corp.redhat.com>; Sat, 13 May 2023 01:09:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9891A40C2077; Sat, 13 May 2023 01:09:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 90AB040C2076
 for <dm-devel@redhat.com>; Sat, 13 May 2023 01:09:16 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (unknown [170.10.128.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7353D85A588
 for <dm-devel@redhat.com>; Sat, 13 May 2023 01:09:16 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-YHtINouRP0CoNwlRJCrLwQ-1; Fri, 12 May 2023 21:09:14 -0400
X-MC-Unique: YHtINouRP0CoNwlRJCrLwQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH0PR12MB5044.namprd12.prod.outlook.com (2603:10b6:610:e3::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24; Sat, 13 May
 2023 01:09:12 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc%4]) with mapi id 15.20.6387.021; Sat, 13 May 2023
 01:09:11 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Chaitanya Kulkarni <chaitanyak@nvidia.com>
Thread-Topic: [RFC PATCH] block: add meaningful macro for flush op flags
Thread-Index: AQHZhKjuJTefUUOpAkGElu0wVddDH69WmjEAgADLioA=
Date: Sat, 13 May 2023 01:09:11 +0000
Message-ID: <67376534-ac4a-3cd9-fab6-fd3a062f5e48@nvidia.com>
References: <20230512080757.387523-1-kch@nvidia.com>
 <20230512130042.GA29078@lst.de>
In-Reply-To: <20230512130042.GA29078@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|CH0PR12MB5044:EE_
x-ms-office365-filtering-correlation-id: 06da0f20-0d2f-4f15-7a7f-08db534ea945
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: SBzOp/GJtiU8F85vDkiTc3zfq/tTiPy23x8C1FOZ9Ir5TDxsoT4TwPd452NoA9vWLVgCvw/a5bKUiUqrP9QErPswf/urJLihOj/iqYKWbiMDRggJ5opVW39ntJkhtwbmFYCi7/4QoYwWSNXwQvqfbOpINxUVMAFUVOuOFRbfbPIHbUs/5rqSTF/gPj6as01mQMMo2earDejFo5henVkktUgw/0IFrTztz6sO5L4aa853+faEf/Pb/NhTOnH3ITpqizcARF94ZP14MKHeOaTJurlOgVL14J7NvgPD11YXxHbmDJpZ+7PWTFaq3PkHQ24A32SxEtXgu+58RmbHjO9KRZ2xt+rh+FeG5P07i1JT0Pbd/32YZph+br2jyTMf+36zKTddsXCmLNsFcj4E9lZSf8NT4NpDlOrEgY9JsOXvWoBoyNQTlsM+vyxIgy3SOcJCwGsF8mOLvRRFlR8v7Wy+EEflEnbfTrWud/6Y87yFg29vJAZQGqrOfURvMI+PY8WSo+2ZtOV/6OTC8W4rxCrL3rDnPl1lC1fY7VjE8rPWXkYHEQ1J8WOextj0GCO72BSR9YXBNZuBkm9xxpGsPSTuuyf/m4FZ0KGFKURRjghTjmeBi3QtbIKW7jB9fXHD9C8tdTLyVSittuHDj8QePrturKKaeBsaJQAcmgMQ1crNSOGt32chrt1MbEz4Hl70zz8j
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199021)(6486002)(38100700002)(38070700005)(4326008)(122000001)(53546011)(6512007)(6506007)(2616005)(186003)(4744005)(2906002)(8676002)(5660300002)(8936002)(7416002)(478600001)(36756003)(54906003)(110136005)(31696002)(41300700001)(71200400001)(316002)(66476007)(86362001)(66446008)(76116006)(66556008)(66946007)(64756008)(91956017)(31686004)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uk5oRnFrbTBWMmhSTjB0WjFhYnViZTM5eG9nY1ZhejVwZ1cwNVBTbmoxZ1R0?=
 =?utf-8?B?MHJkTW43TkxVSnpwc0I5Slh2Mi9XYnRlUVZyTDMxZEs0aDY5NkxtSnVNckVQ?=
 =?utf-8?B?cUFoN285V2o1blV6cTFBY2lhNWphbFdzNDNwclhyQ3dDRTR3OGRZUE56TXZC?=
 =?utf-8?B?ZmprcEE4ZFlnWFFLbWhWeUVBS2c2TE10VzBLV1RaUXpYTnRZRDZMZGVTMTEw?=
 =?utf-8?B?U21xV3hyWUkrRjQ1Q3FqNkVTeDN1NTBrNHd2OFhsKzJTNU55bzIxUnJnN2E4?=
 =?utf-8?B?TG43VU1qUXRQNHJPTVJiK2ZGamkxTWprNGluRWZZTy96bVdLYkcxaEwzY01K?=
 =?utf-8?B?R283Q3BXZUx0QTBiOXRsZlZ6cjFYYkhqdERMemdLRTVqR0tkaXl6cUlrUmd1?=
 =?utf-8?B?UDNkRW1QTlU5Y2tyUFBiSXc2aG13YTR0UjhEZE91QSthM2JCK2hyQVViY0Vj?=
 =?utf-8?B?eXczdUQ5MUZDb2Vuby81NVFNQzZrYThMVnY2bEtpSjVJZnlTam9qWmhwYzhO?=
 =?utf-8?B?VUFkTlNhZWJyaUN3TXBoSUowekQrQ2JISG9SVTRnSXJDRzlsRWVPd1JDOXNl?=
 =?utf-8?B?RUZZeC9ZTHZ3ejFvOXI5cjAwZFY4TW9heEx6aE1JRmkvQU1tUk1BTzU0SFpZ?=
 =?utf-8?B?cVBMN2d2Qlc0K1VaU2Q2Q1J4OXZReU1HaXVnd2V1dHA2ZVo2MmFXbGt4TzB3?=
 =?utf-8?B?bkRPT0h5ci94MzJiQWdpZEJ2L1dpNnRzemMzNngvNHJTL2hUdTFBS3p4N0lD?=
 =?utf-8?B?SjFJSzJUSENjd3pCejhpUUNndHJybmhMVS9LaFdraUl1UG0zV2I4SHhpbzN3?=
 =?utf-8?B?d1AzRFNrdGNaS2RqdGxlWVRJQmFBYitQQURmMlBIYUI2eEFac2Q5ODB3UXd1?=
 =?utf-8?B?Zk1lNEVBTE5sbjNnemtYcW5uYmk5VG9mSUE5ODl5N1VSQ3M4WXZIUDNpNlI0?=
 =?utf-8?B?Q3NVSWJKaHZFaldpMzg0dE1SWTZZbDhVVVJpTmpEeEJ4cEFSbXR6U1BiVjV0?=
 =?utf-8?B?Um5CUjZiTWFoWFVSWWYrMEc5Rlo2YlZBa01WRlFGb055dCtxOVduNXV1YUo4?=
 =?utf-8?B?NEZuMEtFZmJ2cHNOdHhLV1BMODYvcUlxSHpUU1RTbkY3U0hvUTBveE9kd3or?=
 =?utf-8?B?c0ZNOW9KbFJFUm15QkdweXN3akFkS0U3YjdnbC91RkdBUE9yRjFHemMwRFR3?=
 =?utf-8?B?MFdrOW5udUdaeWZiUTB3bUxReFRleW5icnRGT001OXYvN0pPRmtvWU4rT3hY?=
 =?utf-8?B?TU9uVTdnVFNLYTVFOExRanVrTW16c3Y2K1gySmNsS0Z0bXJFRHVCR21PTXFl?=
 =?utf-8?B?S2IxTGdreHpnaE9hTU0xSkxMRGgyd2ZUaE1IRXluTGI3dUNTRWc5bkM3ZVhG?=
 =?utf-8?B?UjBGVFgrZzZyVHlMcXpvSy8wVldoWTBQVEs3RnM4cEovQkIveXZUZTJTQ2NF?=
 =?utf-8?B?YnZURjN4U0k2RmN2TFFSUDVyNmhNRUlLdkxXOGFXNTBZU2lIMWhWeUJ1M3Vs?=
 =?utf-8?B?UXFUSzVhYXJwRC9JWFFpaU9PU0tVNXpQV0FBcXhUeUZhQSsyVjVUOFMzWGdi?=
 =?utf-8?B?NDM0WjdyMjk5NlNHdWhPZVp2WTQxcVpQQ0dqWWhsSEJldnRRRnRTeWhpeHdo?=
 =?utf-8?B?L3ByKytJcDVZVW90VmdHMXR2K0JscTEvbDlFVlpNMDYvVHQ2WnQzN3F0WDk5?=
 =?utf-8?B?UWVDdGNHR0E1ekJWYTNaVDVVYldPRTY1TzlQOHJmU1JhbjZ5aUNhbFo1Z1Z0?=
 =?utf-8?B?QURIUGphUHJrZkFtRUZNbHlMb0dsUldGZDhjZkhvaERJaTZQSHBqR0JJaGVm?=
 =?utf-8?B?U012U3o1cTdzbGdndzJ2aGRMRE9vS25CSmg2OS96enJYT0Jud1o4Y2hGRkFs?=
 =?utf-8?B?d2dTU2J4clJHQmNhYWJBbzdpemVYbVhpQkZYZFEwTkNMKzZiTmNHR01WY0pH?=
 =?utf-8?B?VWt4Y0djYTRzVVlXTnl5aFFHNVRNMmFwWUlGYlFLbTQ3b3BCT2txWlpycXlN?=
 =?utf-8?B?cnZvTVF4bjBhM0RXWVpZdDcvRjZneHgzR3UvcVN0MTIwMWg5dXFXc1RzN3E5?=
 =?utf-8?B?TnNFbU5sWGlPSGx5ZU0wTVJuTTlRZmdPNjQ5TnZjcVdnWEFjbS9EbVprQm5S?=
 =?utf-8?B?Mk1OVEEvV1NLNEdTVG1SMzJvWnhsVEtvU0RlUXIzUGdXL3N3YVY1TDBaZFhl?=
 =?utf-8?Q?zEUBaCMSXwtzNzF2fFcxg5bkDA8QQQWU/vAJjsogeQux?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06da0f20-0d2f-4f15-7a7f-08db534ea945
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2023 01:09:11.5038 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ImhtPkay8Jgpum5FOFmitrbma2hkPOo6moo2T9vA7u5WKSq62UDaliLIjjp6PCBiBOGKoVXZk3mg9eaqaTLbGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5044
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [RFC PATCH] block: add meaningful macro for flush op
 flags
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
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "sagi@grimberg.me" <sagi@grimberg.me>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "colyli@suse.de" <colyli@suse.de>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "song@kernel.org" <song@kernel.org>,
 "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
 "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: nvidia.com
Content-Language: en-US
Content-ID: <750E4C657651274B839324D156D21A23@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/12/23 06:00, Christoph Hellwig wrote:
> Hell no.  This is just obsfucation.  We can look into actually exposing
> REQ_OP_FLUSH at the bio level, but not something like this.
>

and that's why I made it RFC, thanks for the can you please elaborate
on "exposing REQ_OP_FLUSH at the bio level" ?

I'd really like work that ...

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

