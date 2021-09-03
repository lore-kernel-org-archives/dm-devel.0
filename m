Return-Path: <SRS0=d4ru=NZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AD9C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  3 Sep 2021 09:33:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A1E7B6101A
	for <dm-devel@archiver.kernel.org>; Fri,  3 Sep 2021 09:33:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A1E7B6101A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-dA5gcD18N7qiImwaWCMWRA-1; Fri, 03 Sep 2021 05:33:25 -0400
X-MC-Unique: dA5gcD18N7qiImwaWCMWRA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21CD71854E20;
	Fri,  3 Sep 2021 09:33:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0669F10016F4;
	Fri,  3 Sep 2021 09:33:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 850AD1809C98;
	Fri,  3 Sep 2021 09:33:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1839SIQJ003734 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 3 Sep 2021 05:28:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1AF7E1993F9; Fri,  3 Sep 2021 09:28:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D81041993FB
	for <dm-devel@redhat.com>; Fri,  3 Sep 2021 09:28:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 365FF811E7A
	for <dm-devel@redhat.com>; Fri,  3 Sep 2021 09:28:15 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-550-lGvrl1-_M1Sf4FQ8C2Jbgg-1;
	Fri, 03 Sep 2021 05:28:04 -0400
X-MC-Unique: lGvrl1-_M1Sf4FQ8C2Jbgg-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2056.outbound.protection.outlook.com [104.47.14.56])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-11-SXvNwHT1PW-6w0avDj3Ymg-1; Fri, 03 Sep 2021 11:28:02 +0200
X-MC-Unique: SXvNwHT1PW-6w0avDj3Ymg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB6554.eurprd04.prod.outlook.com (2603:10a6:10:10a::28)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19;
	Fri, 3 Sep 2021 09:28:01 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1%5]) with mapi id 15.20.4478.020;
	Fri, 3 Sep 2021 09:28:01 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 6/6] libmultipath: drop unnecessary parameter from
	remove_map()
Thread-Index: AQHXoEWfj707kmXBdUqpXVEY8gUhB6uSC24A
Date: Fri, 3 Sep 2021 09:28:01 +0000
Message-ID: <933d61399192f5e5064054d29488680de0dc7970.camel@suse.com>
References: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
	<1630619869-12251-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1630619869-12251-7-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b975fe13-6cc4-4a57-7e7f-08d96ebd200c
x-ms-traffictypediagnostic: DB8PR04MB6554:
x-microsoft-antispam-prvs: <DB8PR04MB6554D1CE3D6184EA49307EDFFCCF9@DB8PR04MB6554.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: OzZ/umZuITmeK3AszIbmU8pm2pVKdQKRo9aDf6OpWX7REjPFjFk7sPxGMKSa4Mr+g6wkYGb9+SkVV6+gtKkKontvOviB1nLoWZ3lq6xCxdjzusEdsUS6ooHYPGo6zCM70zpUxF7kySYImdxYl+KfQ2mVXQX6yom1XV/69g/utuKo39/oXJbBpcA7z7NCfa0DFY9h0okuy+MDs1QPtTI1Dv2ihRge0QkgOb+IjIfnxxpv9iNhHivffsMBtjN9uj357h1VVe2u5WNibtyw7oZP9XLMwTSyCMBdmv6fBaGTI7Bksg5Ok8TqwJVLHsHp79l002hND1XOeXMb6fWTf1a94Ynmdj0OojFo0Mrt0siDie7lj4pKMRy/ngpF+EhYiDy6Nd1mjoYkqb7eqTprpLqghW6vOZXiPdY4SGrVrOdIoiTWTcmk0Bp0z3o99T9sux2wfCOTVKRUsO3SQqsrOWCAzTdfNkQvH93okN4NavBx92imjQmp5zVJxy/WZrZ8sbNTq5TBqo1o/v2tFAZEKHxFA56UyL2XJ/hkNsCrMjUrY04cz4+uwpW5xrzeqiy/o3kF4t9dEdY4eZlmi9aVxiGiQE2nkR0W4KEsc8Y7vwUFavTEbCi0Rk6BkYMUDv/TwW8U3/DWB0H46xhhWFDBZXUpJ+o6xvjh6008VnpckccmTUPtIeeVcpFeJsetrZlgIdWR47DDwMet9zMrhepOBFTcrw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(366004)(136003)(396003)(39860400002)(346002)(186003)(6512007)(478600001)(2906002)(26005)(5660300002)(4744005)(6506007)(86362001)(38100700002)(8936002)(110136005)(38070700005)(44832011)(8676002)(6486002)(316002)(66446008)(66556008)(66476007)(71200400001)(122000001)(64756008)(91956017)(66946007)(4326008)(2616005)(76116006)(36756003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?IpTuJLEHuAZ2fRCwBqzkaSV9rYpcKwhxHFIx2fFVyL9PrbNJyvAFK62gn?=
	=?iso-8859-15?Q?5O7k0XynFO7GJeOMBkXrhRHzaB7inu4aeiErWRGr3Kjjg+QwE340pDPit?=
	=?iso-8859-15?Q?QJ9ZZwkckqzhEjvxYjIQFm+ZTggGmkKHwhnJL0hLZq9HwVIlu0fTMZ5Sc?=
	=?iso-8859-15?Q?mWDC/YWc3KE/kJwETfsqy26wW4GiRkx4j6j2s1d8b49x9VSqaI0jd4Cdm?=
	=?iso-8859-15?Q?rirwaRdhs1odFy5sxwb5+mF+bS2PHcS0KzD9w6XDx35OmjhS0fXyOKkMt?=
	=?iso-8859-15?Q?ePqj6mfvQ4S1iNfWzQZhQEaJ1ExIfHbEue57IqHI70n6OTL7CQXObL/vz?=
	=?iso-8859-15?Q?k3jc8LkHDn0DhtHCrLViq69J0GrtLRcTfjPSDDF1CphOVS5TH9lg7WyjU?=
	=?iso-8859-15?Q?9Yeqz3eo5pkxxNjEYEowMOXJZMmhD5j8HiPx0N4tUSUN0/lRw+ZUlFAmc?=
	=?iso-8859-15?Q?sYfM8+WHvPlG2Y2d1Ezq8fHAYR9u8XG8YRB6Q+zHWTBrn1aHPWf/93Mhw?=
	=?iso-8859-15?Q?42wNz2SHL3R3CHH9enGwcyxYnNSl5ahp+01rgauk9mrzarqPYagB/yy3Z?=
	=?iso-8859-15?Q?mr9bLq4XPvMNZ47sBq3ged3HgQpkaktEaJlSSumQ8IGHF79z3pJ702Au9?=
	=?iso-8859-15?Q?z6BQCqib0HjYH90IYH06OccytCCOIAK5MoOP61jNnSo2aSU2dwfvfZRwm?=
	=?iso-8859-15?Q?2JB5CCTwuY+0bhSG7ac9OYTam7GPxeldMeaxf43JEEAOh6OPGH3geLuME?=
	=?iso-8859-15?Q?ZQ2qRTe0cvuu2pDGSjRlvmkpb4xHtgdIjZ0dSCbu+XjUQUp6YmWy/NyDd?=
	=?iso-8859-15?Q?ZYIrbUztRzSXibuc9l2aLuu5LphFNK3cZ2EFC5T5BgldL/fV98JfUNKv/?=
	=?iso-8859-15?Q?j/uWwBYNQoM0HecHzxfxIQiRtnsRKzvfFDocDY0twde6TO/9BPHnxqg4p?=
	=?iso-8859-15?Q?d5dL/jSEWX162qYpJWP6VniJfrz5JTx5+3aPa/Nh7UrbRd3KrKuLrVgbS?=
	=?iso-8859-15?Q?8SMXUJNsoEubJ+hcY89hy1tsOhE9g3+8S0WLe9Fj0pMI09zEBKPbybVen?=
	=?iso-8859-15?Q?lJjY3bfYHZVVvEUB8nEwcXCt5AC3yLBNK7PdxDKEv3z/1cGDZ0wp3Q8/L?=
	=?iso-8859-15?Q?O6j3ywM/kw9vjP+/kyCUu0o4ealirE8GD1UUIoYmJcUNum1a1xBbPhVEe?=
	=?iso-8859-15?Q?TTOkw+3zlnopSKC0woZft+rana6lDdXheBKczdrXQvbv6gJzF4aG0Rtjv?=
	=?iso-8859-15?Q?coqNex6/8CyzkKQmNAcvKWYsfaOyZ9HUFME8eLW85Y//M8wCQI4FMs6aY?=
	=?iso-8859-15?Q?Buk3yr6Us4Sw6BnY/ryrFOxY1mQqR0hCgzj21DvmEAGK1O4XD53uxmOyp?=
	=?iso-8859-15?Q?pDIlu+DL3cq5CyaGO+NfsdCW6AIyRr4aG?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b975fe13-6cc4-4a57-7e7f-08d96ebd200c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2021 09:28:01.4080 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 62v1peoyyRb8WQqmEVMPHaiNB/GJSQ9fFOMWHfct3ulTAo+nwTuHXyi+/50h0d2O90s/0qzTE/EdKWcl6N5pJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6554
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1839SIQJ003734
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 6/6] libmultipath: drop unnecessary
 parameter from remove_map()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <00B17D77AAF06A4DA9DC1A6399353499@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-09-02 at 16:57 -0500, Benjamin Marzinski wrote:
> When remove_map() is called, if the multipath device is in a mpvec,
> it
> must be removed from it, because the device will be freed. Now that
> the
> mpvec is passed as a separate parameter to remove_map(), the
> purge_vec
> parameter is redundant.=A0 It was only used by coalesce_paths(), since
> the
> multipath device isn't on any vector when remove_map() is called
> there.
> Instead, remove_map() can just be called with a NULL mpvec, when
> there
> is no mpvec to remove the device from.
>=20
> remove_map_by_alias() also has a redundant purge_vec parameter.=A0
> Since
> it only removes a map if it finds in on vec->mpvec, calling it with
> KEEP_VEC would be a bug, since it would leave a pointer to the freed
> device in the vector.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Good catch. But we need to adapt libmultipath.version. I'll send a fix
to be added on top.

Reviewed-by: Martin Wilck <mwilck@suse.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

