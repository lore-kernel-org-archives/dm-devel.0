Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E320C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 19:57:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7826761157
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 19:57:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7826761157
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-qZdL7t-NNN66J7pcgeaWMQ-1; Fri, 05 Nov 2021 15:56:55 -0400
X-MC-Unique: qZdL7t-NNN66J7pcgeaWMQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 765C4801B0C;
	Fri,  5 Nov 2021 19:56:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E73D5D9DE;
	Fri,  5 Nov 2021 19:56:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4B12A1806D03;
	Fri,  5 Nov 2021 19:56:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A5JueFh019705 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 15:56:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id ECD962026D6B; Fri,  5 Nov 2021 19:56:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6BA02026D67
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 19:56:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2E8485A5B5
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 19:56:36 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-414-OXYttyNLOKiOCI6aVZYa-g-1;
	Fri, 05 Nov 2021 15:56:35 -0400
X-MC-Unique: OXYttyNLOKiOCI6aVZYa-g-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2108.outbound.protection.outlook.com [104.47.18.108])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-40-eZwT7pdIPZqtZEKAQ1VOIw-1; Fri, 05 Nov 2021 20:56:33 +0100
X-MC-Unique: eZwT7pdIPZqtZEKAQ1VOIw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB9PR04MB8105.eurprd04.prod.outlook.com (2603:10a6:10:24a::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Fri, 5 Nov 2021 19:56:31 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.013;
	Fri, 5 Nov 2021 19:56:31 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 7/8] libmultipath: split set_int to enable reuse
Thread-Index: AQHXuu1mU4ueBiHTrUieST8shQsUFqv0BmGAgAFj9oCAAB5CgA==
Date: Fri, 5 Nov 2021 19:56:31 +0000
Message-ID: <d996bb2a0acfd7973bdf4db919b34e2759a3ff24.camel@suse.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-8-git-send-email-bmarzins@redhat.com>
	<da5d538c2d1493e31d8604c9af183a1b5a531a45.camel@suse.com>
	<20211105180813.GK19591@octiron.msp.redhat.com>
In-Reply-To: <20211105180813.GK19591@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95973973-9c8d-43a3-c0bb-08d9a0965d36
x-ms-traffictypediagnostic: DB9PR04MB8105:
x-microsoft-antispam-prvs: <DB9PR04MB8105CE674CF221006189F4BDFC8E9@DB9PR04MB8105.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: iCtB6jPEVqxH18yiW3YPyV941cndYs87YqrJLygvIWA+8EasVGtUVG6sEXS2CAOKWbjK/jewDW2lbVf2+brZXQz0HKnQfAQKXo2pv443oJZ72aiaQnacxZYKgwKJNg/XlESCH2Bu2qJ/+5aTd6eatfei4BlR/zkOWAwPJ3fNJEWafNZ3d0ehDUkFhUk97m/4LE4YOMZZPulqb1FwME4Fyrn1KHUAcmgwtAt4pcEkiDyEJ0oSlrYPa3S6tjokXY0uKSEuVpjCTS1ci8hD4vVWQz/bUcn3Ej13Jyo9kvG2rRPUUcZzAThxEKnikfSKa9nAqA9PzJ3DQ8fUofZ+hBX4YR06Q4INEhY20OQuvqChCklDoGBJuLouOYUBWMm/A2QBmuxy/WVvdsIsKeWGZZ0eqAPIDOxuBFWivGnUjbo+PQMty+jIFVpe3BH+5Fb7Nhttk0/107a1dPu9qhF5oJPSbOpJhqWpj6gx2p+NHQswfC2McLhxKxfuEOBMJm6o3ZQn8O5/PPpW/RmdCGKKyL8o4dbdaXbUalBfoPUcnZNofByNoDm07tHoixUdWVOFXTZO7PflgXn639XawcHkNdx3jGSfkcWfm7/GPjHdMKDZee8poPnwdYCARMUI+kjVa9LPR+Xek0kJH5Ce+5O3OuWJiLjIHyWHv3Ea0LUxqwNM2QyEKAWLinQeWlLjdyJCgDY4lpMf61H7Z1BRlUi9m8Y0PA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(86362001)(44832011)(8936002)(66446008)(2906002)(83380400001)(66946007)(64756008)(66476007)(6512007)(2616005)(38070700005)(5660300002)(71200400001)(4326008)(66556008)(6916009)(6506007)(36756003)(122000001)(316002)(8676002)(38100700002)(91956017)(508600001)(54906003)(26005)(186003)(76116006)(6486002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?7RPzrxJ1Bg5oVM+wFiVtlqR9ypnhm84AvoFunfVEUrWc+AyYtb4X5jLw5?=
	=?iso-8859-15?Q?yEan1AKYKii9/gMX3TA/GGrtRFDTUolDFWKuldxYKtk1nzm3mkbI5JJSK?=
	=?iso-8859-15?Q?O8Jc7GbYYSGsv5xUR1fD2jl3nMb6jEDLv8lPeZ5Mq8+jb1s/4KAquWm+1?=
	=?iso-8859-15?Q?DpSme5BG/V8lMAcKOADOW6ryN/iCnqA1QexFCYnILqqQ5rGrDyrz8f3wv?=
	=?iso-8859-15?Q?b1H1eVMfO02DF8IQ5ZqP6Ws/Bd4J2XmaPAbpEuu26sMR/d08nK9FrEd6j?=
	=?iso-8859-15?Q?VTd7/0xG7ejxyKk50W8Eztbv7KmfrIg1GB0Jjxs8CgmWNZzJtvBx2XcaL?=
	=?iso-8859-15?Q?85jy5h7j0V9z+RoDe4BQIK+1jEKx6t11L+rrv7a3dfWgRKftTxMKyaUsn?=
	=?iso-8859-15?Q?HkLXn1HVq5LY+3T//2enLp3NKbHuci2nT5pIsuPiJGsuqMewyWKdFt/oH?=
	=?iso-8859-15?Q?XF3p+UXeO8ZWIzqVggQY6rjyuGnwKBNGBTbgGE3NBOH/KGhIXtYwnKEbo?=
	=?iso-8859-15?Q?uhIrM7QNAYW0TNC2Pn1MBDMtZ2J6B0HBmoM0qr1ashgFWCbZVIFpPM2d4?=
	=?iso-8859-15?Q?O20JAqrekxvhW32FDQXObG0mS0D29X6OUCOqVkIoPhe3oyXZHlEny3qyl?=
	=?iso-8859-15?Q?W+B2xfiVHfiEG9HMPdxFwru87Dxnt9b9gKl62pIGXBL0OrESzDVj3TkSr?=
	=?iso-8859-15?Q?2GNtlnH/o2jgXr126cLyodc07G4o+VNoW0T3+EtJnPTXHDQlyjBXNHaIk?=
	=?iso-8859-15?Q?enbnZ+VBrOkbr7/fvuBTORByxZvkNfMGK89WUhB11BWFxlmpLFIj0WXAZ?=
	=?iso-8859-15?Q?aa7kbkUucWkPhhYyeCTYOr2aHl7x5f3L7hHutQU2TiihJi3MTJwOCTUET?=
	=?iso-8859-15?Q?9SFq/OO/kEtyYexKIaDi90wN25ygPoDBQmzMO2TzqTJx66p0K60oR7qTe?=
	=?iso-8859-15?Q?sUSp+BRIP3LdeoE84L0EVVl7c910vKrBGjUJV1Yg+1vxFjxjEbdN9YBdo?=
	=?iso-8859-15?Q?L9I4a45kcARIJ53rLTZ+wwGycrrqc6FFcTIubjfzZXd+auBB0hG8RLqZx?=
	=?iso-8859-15?Q?JHmVQtkNL1WyuUguhvZmM+oCZ7fDYJHEc9H7nnK7ZoxyPqdGpQwWoD9jc?=
	=?iso-8859-15?Q?wgTWzKxOBfbIUomvOteTISoyXlrUa/OJpWwoc1ODVMTB1vpyxOpxkVMEk?=
	=?iso-8859-15?Q?webYkeKPpJ0/USw4fim/FmWBA1diLWOtzdNgmjhEmO5pNJvGD/zCT9kfA?=
	=?iso-8859-15?Q?Qc0FuNl5czqNK1ICBfcE1IG3b8SsjQmD9ETTtMjyQ73pcIiokS+LpZcu8?=
	=?iso-8859-15?Q?z4/lcTwV6eaShn/+/pw42Jj7D66K3Y9R/pDgyFXqD4lVTeduLGTrTJxsu?=
	=?iso-8859-15?Q?NKBm7PoA5d5VWRhHG5FHgDx3Lnz+hvZGFbEC+SCiVXc1caWgfM3rrMOTX?=
	=?iso-8859-15?Q?XSH+aaJXJkQUvueTblSs/msuBK0U3zCiIpYpt4uaP3QFalrz1HyWxRI3H?=
	=?iso-8859-15?Q?ZbZCTSpuVQR9/g1k4sRPrftBg11EfcrJRzKg9/BG+qVpSFWppgPRxi4kG?=
	=?iso-8859-15?Q?siYvWhfaiSZhCEkMJ9ZdU2DN20Cms5j+rKWZNgPQ1vYsXsZVXhQgZjCoJ?=
	=?iso-8859-15?Q?0txh7KxP3RDTluhE0vi0amez8KRon4mtowwFNzVEZRSIRvyD8uRIIQCkY?=
	=?iso-8859-15?Q?8BkviqEt+cZ5gaSv1jk1p9mLdxZKKic/yedScip52FFlWbo=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95973973-9c8d-43a3-c0bb-08d9a0965d36
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 19:56:31.7594 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5BM0xvJY4JId1oKpOu6+OKsl/bIIb8bTeki4u8LhzTx04dUX+Kt7kwHVvVW1BZghKwk/2PEOQd9lCzAXpFqM5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8105
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A5JueFh019705
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 7/8] libmultipath: split set_int to enable
	reuse
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <E8FB95BFECC2194AA33BE3C13C1A8F01@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-11-05 at 13:08 -0500, Benjamin Marzinski wrote:
> On Thu, Nov 04, 2021 at 08:54:11PM +0000, Martin Wilck wrote:
> > On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> > > Split the code that does the actual value parsing out of
> > > set_int(),
> > > into
> > > a helper function, do_set_int(), so that it can be used by other
> > > handlers. These functions no longer set the config value at all,
> > > when
> > > they have invalid input.
> >=20
> > Not sure about that, do_set_int() sets the value to the cap (see
> > below)
>=20
> Sorry for the confustion. That's not what I meant.=A0 I meant that if
> do_set_int() returns failure, we won't override the existing value in
> the config.
>=20
> >=20
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > > =A0libmultipath/dict.c | 82 +++++++++++++++++++++++++--------------
> > > ----
> > > --
> > > =A01 file changed, 46 insertions(+), 36 deletions(-)
> > >=20
> > > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > > index 91333068..e79fcdd7 100644
> > > --- a/libmultipath/dict.c
> > > +++ b/libmultipath/dict.c
> > > @@ -31,17 +31,12 @@
> > >=20
> > > =A0
> > > @@ -1219,11 +1228,11 @@ no_path_retry_helper(vector strvec, void
> > > *ptr, const char *file, int line_nr)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NO_PATH_=
RETRY_FAIL;
> > > =A0=A0=A0=A0=A0=A0=A0=A0else if (!strcmp(buff, "queue"))
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NO_PATH_=
RETRY_QUEUE;
> > > -=A0=A0=A0=A0=A0=A0=A0else if ((*int_ptr =3D atoi(buff)) < 1)
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NO_PATH_RE=
TRY_UNDEF;
> > > +=A0=A0=A0=A0=A0=A0=A0else
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D do_set_int(strve=
c, ptr, 1, INT_MAX, file,
> > > line_nr, buff);
> >=20
> > This will set no_path_retry to 1 if the input was something like
> > "0=A0 "
> > or a negative value. The previous code would have set
> > NO_PATH_RETRY_UNDEF (=3D=3D 0). That's a semantic change, as the code
> > checks for NO_PATH_RETRY_UNDEF in various places. Was this
> > intentional?
> >=20
>=20
> Not completely. I do think that is makes sense not to change the
> existing value if the input is invalid. I admit that I didn't think
> about the fact that "0=A0 " wouldn't be the same as "0". It certainly
> makes sense to change this so that do_set_int() accepts 0, and then
> we
> can handle 0 afterwards.
>=20
> It might also make sense in some cases to simply treat values outside
> the range as invalid, instead of capping them. Thoughts?

I don't think it matters much for users. After all, we're talking about
corner cases, which are most likely configuration errors or typos.

For us and for other future code readers and maintainers, it's
important to easily understand what value the code will fall back to if
it receives invalid input, without having to search through the code
base.

In general I agree that not doing anything in this case is a good
strategy. I _think_ that it actually comes down to the same thing, as=20
NO_PATH_RETRY_UNDEF is the default setting, which will have been set in
_init_config() beforehand. But although I know the code quite well, I
wasn't 100% positive if this is always guaranteed.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

