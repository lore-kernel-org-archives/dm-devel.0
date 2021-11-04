Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829D2C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 22:01:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 15EA761269
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 22:01:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 15EA761269
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-H8wVzqhbN8W2F96uvEBtFA-1; Thu, 04 Nov 2021 18:01:40 -0400
X-MC-Unique: H8wVzqhbN8W2F96uvEBtFA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F37299126B;
	Thu,  4 Nov 2021 22:01:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D9D0C7086D;
	Thu,  4 Nov 2021 22:01:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6EE15180BAD2;
	Thu,  4 Nov 2021 22:01:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4M1TYP031336 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 18:01:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 702922156729; Thu,  4 Nov 2021 22:01:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 692262156728
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 22:01:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9D311064FB2
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 22:01:22 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-301-TBWoIjbuMqOeXhC3h7nfKA-1;
	Thu, 04 Nov 2021 18:01:20 -0400
X-MC-Unique: TBWoIjbuMqOeXhC3h7nfKA-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2054.outbound.protection.outlook.com [104.47.13.54])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-33-neZHenDyPxWLiu2yVrpfjA-1; Thu, 04 Nov 2021 23:01:17 +0100
X-MC-Unique: neZHenDyPxWLiu2yVrpfjA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15;
	Thu, 4 Nov 2021 22:01:16 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 22:01:16 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 6/7] multipathd: remove INIT_PARTIAL paths that aren't in
	a multipath device
Thread-Index: AQHXxebem6OoMDXg1kujqOwK3QUxMav0AywA
Date: Thu, 4 Nov 2021 22:01:16 +0000
Message-ID: <1405dce90b82bcd4c37d7a1490e76debb6721824.camel@suse.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<1634757322-6015-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1634757322-6015-7-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58887c8a-a956-49f5-23a0-08d99fde9fed
x-ms-traffictypediagnostic: DB9PR04MB8107:
x-microsoft-antispam-prvs: <DB9PR04MB8107B57392C5512DB595238FFC8D9@DB9PR04MB8107.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2uLBPWvp38MJ2IlS5QkM2acQRDEpD56rNqxAB769MjqRxZfiOSDZVkVNePqO/sHkY/TxAyPtj9Wl3PSlKni0FKFlA0TxvaWyejfMDBVVuZECUi7Lz66TDfa8BzjMhvLs1RvGawqhjY+El6wkqaIW7kmyfsm2jarBF/SethmAjtFwiYslBrBTCFTDcmE8vqpRDbWb/x8b/k8SlRORdgkEeYXacpJyEvVdjvXLnRqXuZF8FyaajeNlbQO7qc+dlry4Vizd4TM5D9Uu0B7dA9ZyRriOlGpdy7I5/5iib1NPe/9noU0UpnSoztml2EflSMGxtOHFSiQEbw51pNX5JTXltTLLQqjS68YmLZSBV7XwSqMHDvPbalpw1ELStqD25Lygt2+1TmSFxdy5xKZbcjxHrVf60KBoPFO8c4kHXfYqq3TusvhLJfE5pt4r7/WGfWK9SK1cWtPB9sERy/BOUc1KgPKBj51Xjx5L8S8jd1KfsN6CXmLUMKk6mkeesXuTU2tNOYcm3/at2PjkX4/X+sMh8wLHJ4vKHJN91KmSFjGyKrDh5d8XGhFSMrO12TMUqRXaV2Rs1Q5GtxRgo8kG14TM1kxI7Pe/vS1mUFm76i+AYG8LNSnT4m0fqIE8Gy7qr9sZwkMQv6vCWqyVGQKkR25xuldCf0hkyO3++OmUzE6/R3pMQcHOM8mXXoTSIc3dWrPNxdSZnBa/yR7rpN6FlpykQw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(4744005)(38070700005)(2616005)(8936002)(6512007)(66476007)(4001150100001)(66446008)(71200400001)(6486002)(64756008)(5660300002)(44832011)(76116006)(66556008)(2906002)(66946007)(4326008)(91956017)(8676002)(110136005)(26005)(86362001)(316002)(186003)(6506007)(508600001)(122000001)(36756003)(38100700002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?fJQydTe5CnOgOW0xERXn+oc2aGZ+QrZDYAa/vf7yfYMKCfz192OgrzqWD?=
	=?iso-8859-15?Q?JUkzY9Bvb4vIAhWsSZEi0QiPKedXXRY18r4/smcz+YVTESwRdDnrOOpoM?=
	=?iso-8859-15?Q?YL6Ytjo+NGUCwcLfFeHtw4A1y2qTufBL3K0XSt39OZIgTX+euxkD57YcK?=
	=?iso-8859-15?Q?L+RWA4sFZ+x+2jfSfum7H68V4n2uWLUfk5goNJ3WaV5A41FxPRmbwQfS0?=
	=?iso-8859-15?Q?5LgTmU5ickiTKQHaReCc8DvEXUmg+zS9zUKT925TKw12C3F6HZ3TBGcXl?=
	=?iso-8859-15?Q?6m+BNHqB/mdWnFvGIx/HXE1mYdBaWGDs3AnOd98zVM2s5Q6xYf2C/EovH?=
	=?iso-8859-15?Q?S11SNHiU+xqVm93uk6YtIe2gp1vbGoQLLv/lEAA7PLVBsZbLpiTourusc?=
	=?iso-8859-15?Q?siem7gs73p53KCQnyFOtwg3sO6Z8TsPG8HXt1BKsuHk+4H6DcDw/uG1Cv?=
	=?iso-8859-15?Q?/URXqCdiBWyRdIFEuPRGex+P+gg9lm1J++fUn43gUAJXheSsccpDKycgL?=
	=?iso-8859-15?Q?prISZ+kKKUxEeL6uVeHmcGvfK2LgJ6etjK8HbKAJ4GuyairHe3mfwzPo/?=
	=?iso-8859-15?Q?7q2JGB6N7iRKiyESUZjVz7bRXFHOdTB6naAKPkKIduWONMr+zjolpWmGN?=
	=?iso-8859-15?Q?8pv7HaJ1SVBdstpTMkLf3gl1Dk+P75tb2PMhrUUymja1uDFBB3mZSWa9E?=
	=?iso-8859-15?Q?62I3HAqiEaNDTZdN3RMU30eNiHaWvfWk1h/zy4gykmVhtLtwnaUGiYwFi?=
	=?iso-8859-15?Q?05k01eUIeI7q5MSDh4mTVMNPj5WOXUeBAxhUV9elBM8f0ze0pAwrGha4e?=
	=?iso-8859-15?Q?JXzu/24KsNGO/cjfijTg72kNoRqIBk7ynaJzMC1YD2etoOWDYLuOBuBvQ?=
	=?iso-8859-15?Q?TPUEhS7NGdnB0tSJBkL/v+iHqYoGbNryXghmx9zGsHCgZnOX1AAnwpbXx?=
	=?iso-8859-15?Q?BphicsBPYouJapbd4+y8y+wWKrICoQeXWs8guupuHmt3ojMIPMhDdOkfd?=
	=?iso-8859-15?Q?HLCqWsDKJpl3H5JAZ9shjWK50rAjYQdAmGmvjsiTyg9Luq39V6FTsp7fa?=
	=?iso-8859-15?Q?Qy3yzT6nLOtbPITsC+CUFih4TGCMwLKbb0TjvVgBtF1NCuF13d0uabMl+?=
	=?iso-8859-15?Q?YWEm82fxRjCVaOHXI02kqPbuy0237X6oQUcLTNvGvWTqhiaUeJf/540pJ?=
	=?iso-8859-15?Q?3RZh/KqGbEIHjc6f1WUSwnV96a525NMHlmv8wWEgeMhpNOBKNOZLLQUNn?=
	=?iso-8859-15?Q?6JM1QSYxwmZGmRCjtq004mWGwMKMuUgL5cuY7bGlpump0/cgTU7Dnlgwl?=
	=?iso-8859-15?Q?txrjyAbnF7NCnx7nW4dJa+t/jx/lyrCv6Rllje6mKBHya4fuWW/jsvzLy?=
	=?iso-8859-15?Q?ikt+9MuHG2p84YdN5dJJ0t4pz9lOxIvaj7gTtM9UVsfG6rEzhpAbbZFvp?=
	=?iso-8859-15?Q?iCPwZC5tHEFz40CBIjdWLJMOh8spWie2sRkEFr/6XTy+W3XUpC5hzS09O?=
	=?iso-8859-15?Q?WakBgrpAqoExtcCYhdudj6VixWkUnsii5a4t3Mh+llJf9YmaT9+CDvPpo?=
	=?iso-8859-15?Q?jSDgBAdzlNnCd+mV+DeqbyPMIcCCHZgru90UZysqWN5+xj28HfQ17NiI+?=
	=?iso-8859-15?Q?TCmVvjK/muSd1ZNy81Y17rarndKdBqsrmXKe9WjsYNeryQ8e7qVFi16uL?=
	=?iso-8859-15?Q?8W20N72eUQCzaRx9cPSgCVn/0zR3/9niyjgMvm9d13aq2yA=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58887c8a-a956-49f5-23a0-08d99fde9fed
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 22:01:16.3830 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eHIXEUZ88otLvzbZ5e5Yh+RxwwMZl8D4RMvkbIiaZ29rMn8u6OqdfUqwxLKdA6uJO2BjhqGwovxs7WO6kYxAhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8107
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4M1TYP031336
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 6/7] multipathd: remove INIT_PARTIAL paths
 that aren't in a multipath device
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <5649903B9D80C845BAAEC8D4CF3D5EE3@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-10-20 at 14:15 -0500, Benjamin Marzinski wrote:
> The only reason multipath is monitoring an INIT_PARTIAL path is
> because
> it was discovered in a multipath device table. If it stops being part
> of a multipath device before it gets fully initialized, drop it.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

