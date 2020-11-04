Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48583C2D0A3
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 23:34:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B1FD32074B
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 23:34:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1FD32074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-ZWm14-X6PqKxHzObPQPNfA-1; Wed, 04 Nov 2020 18:34:46 -0500
X-MC-Unique: ZWm14-X6PqKxHzObPQPNfA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C15F1087D8B;
	Wed,  4 Nov 2020 23:34:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A78E7512C;
	Wed,  4 Nov 2020 23:34:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 07B311833001;
	Wed,  4 Nov 2020 23:34:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A4NYcog017367 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 18:34:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8B7CE2028E91; Wed,  4 Nov 2020 23:34:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85512205F395
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 23:34:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20395185A78B
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 23:34:36 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-476-E4-CPrYwPXyELnkri3UWnA-1;
	Wed, 04 Nov 2020 18:34:33 -0500
X-MC-Unique: E4-CPrYwPXyELnkri3UWnA-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2058.outbound.protection.outlook.com [104.47.13.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-36-d47dgLZmO2e2GuppBkUStA-1; Thu, 05 Nov 2020 00:34:30 +0100
X-MC-Unique: d47dgLZmO2e2GuppBkUStA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0402MB2920.eurprd04.prod.outlook.com (2603:10a6:4:9d::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29;
	Wed, 4 Nov 2020 23:34:29 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2%4]) with mapi id 15.20.3499.032;
	Wed, 4 Nov 2020 23:34:29 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH 5/5] libmultipath: don't dlclose tur checker
	DSO
Thread-Index: AQHWqYGhMjFC8lt10kOGjZ1zvJEYX6mwsJ0AgASH7oCAA2sxgIAAD1MA
Date: Wed, 4 Nov 2020 23:34:29 +0000
Message-ID: <fb03c671e227d2f7f20070ffd4a2082b387ab146.camel@suse.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-6-git-send-email-bmarzins@redhat.com>
	<095833a0bcbc5f1bb792555b43ebf526553d0c99.camel@suse.com>
	<20201102182711.GP3384@octiron.msp.redhat.com>
	<589710d08d286f358a97044834550b7f9db47e67.camel@suse.com>
In-Reply-To: <589710d08d286f358a97044834550b7f9db47e67.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [88.73.133.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 847ab6de-d3df-4032-4a85-08d8811a2ce0
x-ms-traffictypediagnostic: DB6PR0402MB2920:
x-microsoft-antispam-prvs: <DB6PR0402MB2920C873CAE01BF198A67C6AFCEF0@DB6PR0402MB2920.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: uUJxzwf467OuEfUNBm7Ej69xNMHUJdIb00zmLRI67WlkNO+TT/I7ufonB4rn0OsSIK8YSa7+Wyng6LGV+Le0c6x1wV2gHFJy6UCxQShPbZ5Jd/H/ulFDHxZauoYQjbHFuTqW4FFpAhFlcfcITj5M9WqVBKtisqnZ3m7cU1DxBGeYcuy8F18vNb7DWymktsDeYEr61TBimXjBafbnknjTkrEYgT15fxSTWoMV8Kni6YNKhapScicWBHbtYydL6yt6139z8GiHXmhSS68VDcTTHymjjI/AUPmwmU5cN7DpXZsw05pn24x51P0misxSr2u7PRbUPg3UkTFlKRq/aDGDeQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(396003)(376002)(366004)(39850400004)(346002)(316002)(71200400001)(83380400001)(6486002)(5660300002)(6916009)(36756003)(6512007)(86362001)(76116006)(26005)(91956017)(6506007)(44832011)(186003)(66476007)(66556008)(66446008)(478600001)(66946007)(2906002)(4326008)(8936002)(8676002)(4001150100001)(450100002)(64756008)(2616005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: QKJSmLpefpXU/JeQaxxlUkcjK7B4lhhld1M4D3drbE1fUtwo87wUzZWL3Uba8OD9en/xXN4XHH/klVFTuSS33TwZbzHIOF7Og4pSTSqP8AgBXIWrZwpLswX9VyHBOeZwyilJXVKFu11402eC+q85VV+6CcOHL/Ylw+6P2zrMjAzObcQRhb+Rn4HJPMeaT0hcDUSv1JfT/feqC04AkFQS8f+YN4xMnEXdM/DQW9rBFA9hJPwQWf8jJCWKfGDJJGtkrlba7SBcT9EG0eL2HSOAqOU8PpKIvra7o3ZK0V+6H7V2BNmYjxCs6RUyaLUEL2UmdMrBgeZ49HiuLUQKfzxAirx96FZFP1hUV29Fhf+GhI5XyjNn7RY3xrq6h6ZBvXsNR6CNwzONRutlooRnuYuKECi+RuiNwARlxliwWlQzNDu4gvnTdkbIa310p97gAr5m5GATajuCdXOOhhlFDbEhB89IlQdCgyRm6+ap5XNBp5H/kFmhw+bGNcVtbSSxNDD+riFA3f0inXUVFUWRiUnzh4KwgrXrOJTZVtUNtpkxB4RYzQpgJy2rpHunogxtL6lhacxaTAP0wyI2WMlk/uiM3r45bdafchV+r6gIsx3QonKXEvcmVv5Q+pSghPykpLDzV0LQeBf1zRmcZit/zHbNVg==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 847ab6de-d3df-4032-4a85-08d8811a2ce0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 23:34:29.3635 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FNmnbEMBbV4XnRqPGwU+GYvdiNHw1SZxmBgXEJItLfUa/P7NoK5f2+Sen1J8Ht0QAxpyxugRYUfAtAPKgdpSXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2920
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A4NYcog017367
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/5] libmultipath: don't dlclose tur checker
 DSO
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <528E9D072DB161489D88EEA7B1AAC29F@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-11-04 at 22:39 +0000, Martin Wilck wrote:
> On Mon, 2020-11-02 at 12:27 -0600, Benjamin Marzinski wrote:
> > On Fri, Oct 30, 2020 at 09:15:39PM +0000, Martin Wilck wrote:
> > > On Fri, 2020-10-23 at 16:15 -0500, Benjamin Marzinski wrote:
> > > > The multipathd tur checker thread is designed to be able to
> > > > finish at
> > > > any time, even after the tur checker itself has been freed. The
> > > > multipathd shutdown code makes sure all the checkers have been
> > > > freed
> > > > before freeing the checker_class and calling dlclose() to
> > > > unload
> > > > the
> > > > DSO, but this doesn't guarantee that the checker threads have
> > > > finished.
> > > > If one hasn't, the DSO will get unloaded while the thread still
> > > > running
> > > > code from it, causing a segfault. Unfortunately, it's not
> > > > possible to
> > > > be
> > > > sure that all tur checker threads have ended during shutdown,
> > > > without
> > > > making them joinable.
> > > >=20
> > > > However, since libmultipath will never be reinitialized after
> > > > it
> > > > has
> > > > been uninitialzed, not dlclosing the tur checker DSO once a
> > > > thread is
> > > > started has minimal cost (keeping the DSO code around until the
> > > > program
> > > > exits, which usually happens right after freeing the checkers).
> > >=20
> > > I'm not against this, but have you considered using an
> > > atomic  refcount
> > > for the DSO? With every tur thread starting, we could increase
> > > it,
> > > and
> > > decrease it in the cleanup function of the thread when it exits.
> > > That
> > > should be safe. If the refcount was positive when we exit, we
> > > could
> > > refrain from unloading the DSO.
> >=20
> > I tried exactly that, and I would still get crashes, even if it put
> > the
> > code that decrements the atomic variable in a function that's not
> > part
> > of the DSO, and put a pthread_exit() before the final
> > pthread_cleanup_pop() that would decrement it in tur_thread, so
> > that
> > after the cleanup code is called the thread should never return to
> > code
> > that is in the DSO. I had to add sleeps in code to force various
> > orderings, but I couldn't find any way that worked for all possible
> > orderings.  I would love it if this worked, and you're free to try,
> > but
> > I could not get this method to work.
>=20
> I've experimented a bit with a trivial test program, and I found that
> it worked stably if decrementing the refcount is really the last
> thing
> thread's cleanup function does. Could you provide some details about
> the sleeps that you'd put in that made this approach fail?

I've made some more experiments and if I repeat my test enough, I could
see SIGSEGV.

I was able to make it work by using a thread entrypoint outside the DSO
(calling the DSO's thread function), and decrementing the refcount in
the outermost cleanup function (which is also not in the DSO),
all using proper atomics and barriers.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

