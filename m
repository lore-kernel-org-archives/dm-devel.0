Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA0AFECAAD8
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 06:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663656345;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VOwiNUMGh7uUlt2o1VXpCpgD0xGyVRb8OIISLfv0f20=;
	b=TP0fYXfAqEMD+sFLL6i5Yg+sMJ9q/wz58S5k7fSgoe5p2zFpii4CPoeAH732hUPWxUtF/B
	CIVbDHsIxgyLSeVU/M/VlZn5WvZsV7gFQw7dB9tGxbjebzp7yZb3yo/EtaQpizs9Mevj0p
	Y8AlVJPN9grjm6RU1AswiB0VCbpeNsM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-2wJUTH2YMdiP7Shby32_cw-1; Tue, 20 Sep 2022 02:45:42 -0400
X-MC-Unique: 2wJUTH2YMdiP7Shby32_cw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E20F811E67;
	Tue, 20 Sep 2022 06:45:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B534C1759F;
	Tue, 20 Sep 2022 06:45:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8EA4419465A3;
	Tue, 20 Sep 2022 06:45:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9E62219465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 06:45:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6DABF492CA2; Tue, 20 Sep 2022 06:45:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6545D49BB60
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 06:45:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 456AE1C14B61
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 06:45:35 +0000 (UTC)
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr50053.outbound.protection.outlook.com [40.107.5.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-EPQSFyw3OYaJ0LWVPmce8w-1; Tue, 20 Sep 2022 02:45:31 -0400
X-MC-Unique: EPQSFyw3OYaJ0LWVPmce8w-1
Received: from AS8SPR01MB0004.eurprd04.prod.outlook.com (2603:10a6:20b:23c::6)
 by AS8PR04MB8676.eurprd04.prod.outlook.com (2603:10a6:20b:42b::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 06:45:28 +0000
Received: from AS8SPR01MB0004.eurprd04.prod.outlook.com
 ([fe80::a0b1:c562:699:f596]) by AS8SPR01MB0004.eurprd04.prod.outlook.com
 ([fe80::a0b1:c562:699:f596%7]) with mapi id 15.20.5632.021; Tue, 20 Sep 2022
 06:45:28 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "wuguanghao3@huawei.com"
 <wuguanghao3@huawei.com>
Thread-Topic: [PATCH V2 0/6] allowing path checking to be interrupted.
Thread-Index: AQHYsnrAkzfxuiza40OWfVEqVIMyra3gO6IAgAfYjAA=
Date: Tue, 20 Sep 2022 06:45:28 +0000
Message-ID: <e09d95c08103a8a21c8d2ce7ba32d63625d18570.camel@suse.com>
References: <1660769316-5302-1-git-send-email-bmarzins@redhat.com>
 <44f7c759-943d-23c9-bcd0-b20b0457e329@huawei.com>
In-Reply-To: <44f7c759-943d-23c9-bcd0-b20b0457e329@huawei.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8SPR01MB0004:EE_|AS8PR04MB8676:EE_
x-ms-office365-filtering-correlation-id: ce9cb16c-fc3f-4df6-dbfc-08da9ad3b4aa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ewdroddAf4UuVx/FD2btI2uTXqXEc3mOBO8FLVkbycD8w6a46XS2/7M++nY0leVzQSngu/XZV4DS877mPTfYUJOpWmgmPmIdfN64qnt+P4t2Z+9Jj+c62qgOalWYL/YdliB9tF2jYgDC6/RSWsOQXi2bzXXHtsYtjNCj8BjIZ0ztOMHuoP3R+ibQ4+yDn1B5QGBLvEviD20G9Dd5DtTVdVI7JbZ6jCxjXkESLGSv/kUF8RIyS/lER0Dz4DweeL4Jf3c/VEKMeQHc91FAesfHUzth19Q4fahDD8ghev30qGzTpkSEBKyKa3B0navIQofXADDoTuRNGy/H8aYYMdJmVttIUMfDB0qScksd6+Z+gAL5i4DfU0qIMTL48du6sAM9O8na02K5UpuVYiXNJj/zWFP/owROBpY302FuOI0eVx/sw11CawCvGq8Yw7nCf4B5jw7tPmqjX1h1PmpFd/WviS/7SZIysiiHQu6P19FFLve1a6LNi1gSmp4SmW7gUqVEBX24ULmoltfS5y+88v8i7VwJ7vefxnV0aLAitRXdP2zmtM3tqHyIRyC2CHpFmkANh3gdmx9cHEzZK6kszaYr966/J3NrHYdgnMSO3cbxrAYDMJUxL5gK+xBVY2dn3UbkoCahcx0qYMFMBTAL2g8TT0dI7V/YKKJ4lKBIIej5EU0h7OoDYIkhiOQc1BvN1HHiCPY75xh2ithHL0TC7rw4zO0B333MoHcsQ1DLiMXfPcNWSXMmvjibtUzW7ZurUHP20k9dEs+8Z95ncZHiefc67w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8SPR01MB0004.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(136003)(366004)(39860400002)(346002)(396003)(376002)(451199015)(66556008)(5660300002)(66946007)(64756008)(66476007)(4326008)(76116006)(66446008)(110136005)(86362001)(8936002)(316002)(54906003)(122000001)(8676002)(38100700002)(41300700001)(6506007)(6486002)(71200400001)(478600001)(2616005)(186003)(6512007)(26005)(38070700005)(2906002)(36756003)(4744005)(44832011);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?loqRhQPPKOJo6aCEjfogxoAAAvILTM3luOwNAXtKqgkdIeKixFzb6WpX4?=
 =?iso-8859-15?Q?kQL96GRsXauyPjQepdWv4ZFPJi5/yBEkMa8aqfaU1eS5eWL3or/CPC/TJ?=
 =?iso-8859-15?Q?z6vcTb4LnN3IPyJVnot8ximM36LiQZlL4BSF7B5bUB7RnRdqeqdzIuDX7?=
 =?iso-8859-15?Q?T0tbpyNtNSRcyQJE9obPlasMLs7V3ee+mIvzZr1y25kLdLG+kXclXIchO?=
 =?iso-8859-15?Q?I53QzpLF+ldx4ix3xdhXE/t0cg0Jw9vnIFr3pw0l0my4qtlivUlkdJ3QG?=
 =?iso-8859-15?Q?/WgP4GwHVlpuA9mUQCcTVbg/kQZEQXvNkU5bxsAwVKHmHXTx+sJUPIDoP?=
 =?iso-8859-15?Q?EzMv5TnyHfEKaNWZfgKeyumzEOXDFksoOtvzgwjO7DDXHHiHRf2yqRs8b?=
 =?iso-8859-15?Q?H2N8rMvHt2ikgchOyZAX/3hTb04Euu+Ax2t61CTJ2AlhpeWch9jl2O9yJ?=
 =?iso-8859-15?Q?3UhREPTjfigTOPqWOrViquYCZfzGQEHEMsKOEhM2/V9L5pMnerMIfc6Z4?=
 =?iso-8859-15?Q?SWppMOQ9ikJJ2487u+gcTCVPLFBFtXi5A2V2IyXnabw8CGq+OwXcIG0/p?=
 =?iso-8859-15?Q?OwUNTY8hNwRIn82L5QWz9c6ylWnY8FZ/xcZrY1iK6w9T1DPigcaS4/wdS?=
 =?iso-8859-15?Q?rA4RpyQYdgsW94bUHF3ToPgav4o6Z2GwVQd9lQo/rDJ3NSZPnHPMpElAO?=
 =?iso-8859-15?Q?XKiGoHaPv0mjSr67MrH2HAQ9Hb+6ld1giptWhLXG3d3lx6Z/ZXD2HlFEL?=
 =?iso-8859-15?Q?P+uA+pNrNvpSU5noKheIJjWLsBNDtRzZxC8ptiaEJ1+zfPcufskAde3Ip?=
 =?iso-8859-15?Q?Vnozn57EvH/nugmsxSP/GCxt67oewKL9YIe14MP6hZvK0iozw0aYloUSB?=
 =?iso-8859-15?Q?iTT4ilDy7Fwpz0Wcua6VvL/st20pJdPPjzHYDB8z+P/9jvtO2vjFVOyBn?=
 =?iso-8859-15?Q?igT/fhMMCjcTiDczHD5eVzzfLk+2QNiq+Sa+Squ6ZOcXzkpCgSrziYAgR?=
 =?iso-8859-15?Q?sRybLXaQ32rZO4wT1cN/AfZd5lKatlBueiZNyVrkQcVd3NphHFso7SmoF?=
 =?iso-8859-15?Q?Dggbqv7fXAXsL8pOzEXZk1tUTQid38tALMglVXTJwPrsgfa5sZJD0P56I?=
 =?iso-8859-15?Q?KlOtsyg/eO4GOdrRsDE5qUz74lh+RqcvjdYuDVqXELTIAgULyKfYPmTpQ?=
 =?iso-8859-15?Q?4p1F1AcpXjwCgwIU1KuJlIVIJbkT1L7Ff/BLA/HWA9N4XBU7jkFp6DQIu?=
 =?iso-8859-15?Q?Cj/OZ52fddWNp/kJFeKG+DlpsOFLecHbSr5BBnk2/ysDw0LvPyZg8Hfxi?=
 =?iso-8859-15?Q?5JtNUYpFewLCE909JjeuwVmtzHIWAwYT0MQv1gVs6p3muQJOMGq9BcqeF?=
 =?iso-8859-15?Q?k2vLpYvsITtZuGzVSzXlWAysAnsMgYKvmH2v5S7+oi9lYw4nQ8kLMhqU3?=
 =?iso-8859-15?Q?E5rh9XHWFa5eucH6Qvc/LpfXpQIdDey04TgMMNUxTn/5oRjtMpl6o8IKQ?=
 =?iso-8859-15?Q?Sk4K/xf4+mFzS3XgQbDYxDxRzqkjtwAqopnS1fmNM50DS+LPCYvoRUJJz?=
 =?iso-8859-15?Q?SzCz2TiiuL5mo7NWK71NvnwuPnNlV5ZvEuubpS5CXAsMFVWtvb8t8LRX2?=
 =?iso-8859-15?Q?OwffCsSNyJzqSuTPHHmGg0+u8NexW/bv0ywLxpIPcgX1reEzA1NtVy3Ma?=
 =?iso-8859-15?Q?0VGf/hNyyDLHpzduMNdRKkod3w=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8SPR01MB0004.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce9cb16c-fc3f-4df6-dbfc-08da9ad3b4aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 06:45:28.5907 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VV7oftlUjE8ne6WmYqhDs2CERZvv55AWeZFuz0GbPDUSUmsxyvR10eZ+hGJbweZtdR4+VmwI/8RT9M+XDUQOUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8676
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH V2 0/6] allowing path checking to be
 interrupted.
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
Cc: "linfeilong@huawei.com" <linfeilong@huawei.com>,
 "lixiaokeng@huawei.com" <lixiaokeng@huawei.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <1EC128C0E1DAF64CA41F216781CF1CA4@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2022-09-15 at 14:56 +0800, Wu Guanghao wrote:
> Sorry for the late feedback.
> 
> The version we are currently testing is 0.8.4, so we only merge the
> first 3 patches in this series of patches. Then after the actual
> test,
> it was found that the effect improvement is not very obvious.
> 

Which path checker are you using? 
If it's TUR, could you try to simply change the sync wait time?

static void tur_timeout(struct timespec *tsp)
{
	get_monotonic_time(tsp);
	tsp->tv_nsec += 1000 * 1000; /* 1 millisecond */
	normalize_timespec(tsp);
}

Change the 1 millisecond above to e.g. one microsecond. That should
speed up the checker significantly. You will get a higher rate of
"pending" path states, but that shouldn't matter much.

Regards
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

