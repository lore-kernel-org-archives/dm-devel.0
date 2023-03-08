Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97303C64EC4
	for <dm-devel@archiver.kernel.org>; Wed,  8 Mar 2023 18:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678299442;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Q+MalFxa6Rdvm4jeU5pbXzh12FSdb6nVdYLCQ5HxvL0=;
	b=KSLnCqDXEP2wnnwVtzHjVjZltvp0jive+jzWKaAFvzxAGB3tYTKtb9uc6b8DCM5qrIQgvh
	Ccw7WIsQjZzj3M+sQP8HhRFTZeiAJBOfmEeeXaB4jjeo8b4sgw0K7hTN1s48uRQFFnYi3O
	hK92g/9UBfAp7IDT/zz2OaXI2Y6Ceyk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-sjWFUXSuPqa9S0jmQujw3A-1; Wed, 08 Mar 2023 13:17:20 -0500
X-MC-Unique: sjWFUXSuPqa9S0jmQujw3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 162B838221C5;
	Wed,  8 Mar 2023 18:17:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B348E2166B26;
	Wed,  8 Mar 2023 18:17:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 75C8C19465BD;
	Wed,  8 Mar 2023 18:17:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1BABB19465B5
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Mar 2023 18:17:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EFF88440DE; Wed,  8 Mar 2023 18:17:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E7172440D9
 for <dm-devel@redhat.com>; Wed,  8 Mar 2023 18:17:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C31B4800B23
 for <dm-devel@redhat.com>; Wed,  8 Mar 2023 18:17:11 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2045.outbound.protection.outlook.com [40.107.22.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-wHQ13tWLOg23cUO18C7cPQ-1; Wed, 08 Mar 2023 13:17:08 -0500
X-MC-Unique: wHQ13tWLOg23cUO18C7cPQ-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS4PR04MB9624.eurprd04.prod.outlook.com (2603:10a6:20b:4ce::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 18:17:06 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408%4]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 18:17:06 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/3] libmultipath: reset nr_timeouts if we freed the
 context
Thread-Index: AQHZUeowgde67js6S0iOgyARHr8Vsg==
Date: Wed, 8 Mar 2023 18:17:05 +0000
Message-ID: <9c92591f721abdb9451280b865930b4a16693ed7.camel@suse.com>
References: <1678229374-18788-1-git-send-email-bmarzins@redhat.com>
 <1678229374-18788-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1678229374-18788-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS4PR04MB9624:EE_
x-ms-office365-filtering-correlation-id: 6302663c-8118-4d68-e5d5-08db200152d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 6nbyhuacHXyt5OC5oOFhGJi/tyVRxYiPwWwNdIR2A4jAyuPFQkWBTUMVS5ddpKkQxw0GHdJte4BzAo/1tTGRGrloKX+8Qz3ErtMLkGEFQ+deSsHBR4CgmjLzOiPah9d5qVdVv59IjApa79BuHYVal2Q6PPdEyjKXOyT0vxjlrwMz7OSGIacdwEnUrfnjmIPBch4yp9RglCM6vTET0lPNj4Ro20eOuYhjnpQ/3mFAv0kbzSw/C6SoWrXYdQpIy/0bimDRdMXtX9wZqIWkO9utt55xviWiXdGglmOwyAQUW9oF4uXWK4ADEec57mjBAFaTubbIXgHjqIQ66yvIOgkcnN9vHrdO6l4O3SIUinuL7WcjGzlAqmCbfFsXY6ft8ABV3vihBFFVpqThcEd9dYn8FNr59gSuwfBTpbJRa7QUK4aK9VhHZPVOTJCTX886FujKLYWjm90oWiABWfst/bL1DvLfVe68cuR6W7Drk1ITmQmq/S2sQS5B0GOa7vTUFjNPsyD9/moHYcj9XlAklHsvusEEr5xpvFy7c4AK9EtCPdSmfAt52JxkCI91TN6+tt52D9XQiK1PDJhwjx/0DxgCxADkAfuENQknUIOmGjrYebklp/xkGEJOI+n3oPwDR3ju19YnYizWs25IVhBMLDhb4zKWAwbMpbK+1YlB2X9+G9kUUCwhrGWIqZHfKzMrD54Ejgaq4Ry4JWVJqj4VqjJ76g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199018)(2616005)(54906003)(110136005)(36756003)(38100700002)(86362001)(122000001)(38070700005)(6506007)(6512007)(83380400001)(26005)(186003)(6486002)(5660300002)(316002)(478600001)(71200400001)(8936002)(66946007)(4326008)(41300700001)(44832011)(66476007)(2906002)(76116006)(91956017)(66446008)(64756008)(66556008)(8676002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?Azhq5VEdx1KLkEziddYtmUJmWV6fdmNHhudHqZB30nGMLy+pK267DwlFS?=
 =?iso-8859-15?Q?mGOJQ9KelQLl4Ijk2MKmkgwypT5ida93mVBVRaCTu9dkM49LtBAFUaNeH?=
 =?iso-8859-15?Q?DNdKl262W9Mb1GKA0r7qCj29hKzIOS3RcdHO/Pf2X0vTFyf84qIU6mDn0?=
 =?iso-8859-15?Q?YQEfI/hPl/3Efv8vLnl9+jS+JqJYkGpDQF2qTbrSsNBusfRuhh3Xh6VDr?=
 =?iso-8859-15?Q?AoZWJrYP/m4plTJS1BIT76cJaclHIpM85WKaTPa4G+k/wPHWSpFoLNeJJ?=
 =?iso-8859-15?Q?fdSKB9AXx3gGEwcWaC1wRwgBV3SggRVzrV35BMGDsisAE2vkJsgv70XQz?=
 =?iso-8859-15?Q?n9BIwqxz+8x7ALxOlUKh5jvzH+zAcsdNuo6UPcT7IiW4O7E2/XWKTIcDn?=
 =?iso-8859-15?Q?jYkNfv8zW4LqjiE1H4enSrfhKoGayIEdSTYBeENcnXNKtrjJEo501k+P3?=
 =?iso-8859-15?Q?cH81j9cwq0MBSXkEvkf3h4dscuT3pPxihExkP6OCw05Ty6D5/zLV/cuxY?=
 =?iso-8859-15?Q?JSYj5fk9Ej/t46EaF2GG5aC9xVPkOkgLOxKu8S8V9JU3hlKWoTVpz9Zuq?=
 =?iso-8859-15?Q?oalwccAQnaZG7dSSreEAmGFUo4xOhzxlvONXI+qpvKA2rDvAIAQ7M/Uxo?=
 =?iso-8859-15?Q?n6EUEXs64BPR/ZNLs54M3V205s7SK5sPvNxaO8q0gkO69cjoSUZidnM3G?=
 =?iso-8859-15?Q?PIEZW1FwNwwe+sU8y6P1N+oq5Jj88+NQMEiDZG6Y7Nrfyi1BGpRwW0YjE?=
 =?iso-8859-15?Q?2H9qj+VlJBL5C0g/LaTn7fNARHJoYEVssazotCrBiQxwkQWP8Xhce9KH9?=
 =?iso-8859-15?Q?FzEJ/u2tXcxymL//PxPQVTldqjX/S0r+6qBTShLAxtIXM4fE7anqptm5N?=
 =?iso-8859-15?Q?FQ+PNSjT2cVLlLMhwAqqkvpe+eTdQdAQUIsItEBAM7srQnUOxyQL/FM6P?=
 =?iso-8859-15?Q?kgK0SCe1nFynWdvZboEdSLVQqiz4lxLxcvuepGXYZn03b8EiPvZmpIGnd?=
 =?iso-8859-15?Q?v5v+1kWxN/gG1FqCCDrGARkypyQiHtDnvkACvtXg6/m0S+jNj++UiVImi?=
 =?iso-8859-15?Q?XcNdCi85/hWZQRxvuKU7jggIFrCFClV/Vt9sSrbTbLYdGjE4XBQnqj0s+?=
 =?iso-8859-15?Q?BWGKY1BzuLz8MTLLfVBhK5N9dYTPCbUTkMFyLDfDQ+sKtZVQ5E9lxZ/Wl?=
 =?iso-8859-15?Q?fiK5F7poL5e/MiSU0IwNlsVnugsFMxd7Rlx5xvOpTdvD7R8bWCOTwzGNh?=
 =?iso-8859-15?Q?2ihQGRpbfAhph2Av/qwhxqCwdZfMf7X28LtRPVEESyvZxK6Yd+fVwclnm?=
 =?iso-8859-15?Q?mSdFZoxtYNlyC24QhA610NSu5gNPtWy7HT+fAKop8Jzr88o+LoZmF4YbU?=
 =?iso-8859-15?Q?hPJF586jO9Xx5GCqFqbOBwiwiqITk2Zj/yzRCYe0l6EhaKsHkRBuxJ89/?=
 =?iso-8859-15?Q?F6AOTwpyPpk39WgPNnmOOfYRYafTDSYDkk2CJtNcyg8GhUFoAt3SIqBlV?=
 =?iso-8859-15?Q?xDrOtU7JHrn4hEDxFSU1RlQnsMZHKO+cGIC7o8C6J3qAv3lkkNEnBbK5W?=
 =?iso-8859-15?Q?OuFAeUefUo4Ndv9lZGHsWITkJffOTS4V7E8bX95dO5JUhZzO9id2uh0oN?=
 =?iso-8859-15?Q?OV/MASD4KISdnjYFZnScVdrWdYLjU6ndbR3f9K9apnPjmeqErel5zSoFa?=
 =?iso-8859-15?Q?evJYCa9sfGqxkr5Xpe1K/tPjUg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6302663c-8118-4d68-e5d5-08db200152d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 18:17:05.9132 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YefuS4DQto3nz4DCSdKn39PxCyLll1CM+T12HovcPjXYou3v/wE28KN57eMwn/eFYV4PVQ6fsSb4Qp/6XvepqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9624
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 3/3] libmultipath: reset nr_timeouts if we
 freed the context
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "brian@purestorage.com" <brian@purestorage.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <0788666C936492489E21738B36A2BB26@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-03-07 at 16:49 -0600, Benjamin Marzinski wrote:
> If a the tur checker creates a new context because an old thread is
> still running, but the old thread finishes before the checker drops
> the old context, the checker should reset nr_timeouts to 0, since
> the old thread did complete in time.

This looks strange to me. First of all, the old thread _did_ timeout,
otherwise we wouldn't be in this code path at all. And even if you say
this timeout shouldn't count, as the thread isn't in stalled state any
more, shouldn't you just decrease nr_timeouts by 1? The fact that
_this_ thread terminated doesn't tell us anything about other hanging
threads.

Martin




>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/checkers/tur.c | 4 +++-
> =A01 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/checkers/tur.c
> b/libmultipath/checkers/tur.c
> index a19becf5..fe6a2f14 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -406,9 +406,11 @@ int libcheck_check(struct checker * c)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(=
(struct tur_checker_context *)c->context)-
> >nr_timeouts =3D ct->nr_timeouts;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(!uatomic_sub_return(&ct->holders, 1))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(!uatomic_sub_return(&ct->holders, 1)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0/* It did terminate, eventually */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0cleanup_context(ct);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0((struct tur_checker_context *)c-
> >context)->nr_timeouts =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
t =3D c->context;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

