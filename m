Return-Path: <SRS0=/P3g=KH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DCFC43460
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 12:37:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 32FF561108
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 12:37:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32FF561108
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-5mZwnU6oOI-lDzz69BX5aQ-1; Wed, 12 May 2021 08:36:59 -0400
X-MC-Unique: 5mZwnU6oOI-lDzz69BX5aQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 511DC106BB24;
	Wed, 12 May 2021 12:36:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11AF190A9;
	Wed, 12 May 2021 12:36:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73C363CAA;
	Wed, 12 May 2021 12:36:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14CCapBa025104 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 08:36:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CD4761000DAA; Wed, 12 May 2021 12:36:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C7EE3112D403
	for <dm-devel@redhat.com>; Wed, 12 May 2021 12:36:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C27B80D0E4
	for <dm-devel@redhat.com>; Wed, 12 May 2021 12:36:48 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-571-3VcOV2u5NLG5R0HfJJVaPA-1;
	Wed, 12 May 2021 08:36:46 -0400
X-MC-Unique: 3VcOV2u5NLG5R0HfJJVaPA-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-37-XDRkO_pzM3G6PVadgkDxlQ-1; Wed, 12 May 2021 14:36:43 +0200
X-MC-Unique: XDRkO_pzM3G6PVadgkDxlQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB6475.eurprd04.prod.outlook.com (2603:10a6:10:103::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27;
	Wed, 12 May 2021 12:36:42 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4108.031;
	Wed, 12 May 2021 12:36:42 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 4/5] multipath: free vectors in configure
Thread-Index: AQHXRryCSyPTHaMUMUOR565GPy8N46rfyXMA
Date: Wed, 12 May 2021 12:36:42 +0000
Message-ID: <f186788dcb161fd44859a0c8908c2eb83d3bee0d.camel@suse.com>
References: <1620775324-23984-1-git-send-email-bmarzins@redhat.com>
	<1620775324-23984-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1620775324-23984-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aadb0867-d945-404c-b802-08d9154298ec
x-ms-traffictypediagnostic: DB8PR04MB6475:
x-microsoft-antispam-prvs: <DB8PR04MB6475405E51C60C2D0DCC1809FC529@DB8PR04MB6475.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: gE2r8yEK8ZGpup0QcP7gH02XYKtC/MguUEdRbNjpKn5aslezODDR186LguKn0I8KiO2x1CLoHXAm+CaQPs3vWzIPdDf/i4Qsp3fxpPx5ztatJZaBublyEWenLJXYIFjVTcus5L7wTroTy2a7ASe/44zc4rLeAFqwIz23bJHYLLlbw6Ueq+wOFcqrAscbyqF1UB6uCzI41pVPWkzzJpRJlth7x0kuwgTTcSQ+RV+s7O078BZ86iqs7RZgRrr6KE42PuIqhOGTCzSE1NmCGkflBS4y+uhUUxjc3LEi8+Pll04MjstFIFXk+xPHzZV6cu6WtW8Pl/QhvaIFFQMYQ7Qt/N1808ZcCzaZxw/99RxBeOLEqujCNCbDU1O9ti6gF/KzQ+lurdQUg0oBFh2Rp+PDuSLIgqyK6yESN+zLFk/bLAxVoqhGH++092eXEIJ62JdiHal+h6lZgqDtP0Vcem8iXhD380czJywEAPlzgIWGNTNxJOwmcpMJm7gxwmQ+5RftLLoOWNT2ZUF8uqoE+edAhhpneJyJSXmNeTvui018N57PztUFV+SS/jtrFrtxpxMTpwbEw3uxNY0KYtbGjgMymuPnsOWMotuIHhEQPer1iME=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(39860400002)(366004)(376002)(396003)(136003)(5660300002)(6506007)(83380400001)(2906002)(4326008)(8936002)(8676002)(38100700002)(71200400001)(76116006)(186003)(2616005)(316002)(110136005)(66946007)(26005)(86362001)(36756003)(478600001)(66476007)(66556008)(122000001)(6486002)(44832011)(91956017)(66446008)(64756008)(6512007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?cquecQR2Xngh9oDKueeSy5B5XNLbBzfnp4NPmmpu4SrNh+OzLhzeptK6W?=
	=?iso-8859-15?Q?sgL9utRb6AkovXneALDvtrEulorgs2zvF3JoJrhT3MmsRQP0blpU13Zo8?=
	=?iso-8859-15?Q?zMNWoR0cQGwVvuVpSSUhxCXKPl3SPl15kyYhaF6CHWSglQY78Kh5qlOab?=
	=?iso-8859-15?Q?ChS5NQieehjOb2ginQRdrut6rqsKW3n2QiUCm7Wdfpob3wMR0qkEsh6CM?=
	=?iso-8859-15?Q?cmndvWgRm94uRTEuicKTpaEgmB5/Vz9xjzDfYFWhSRoW34cmg4nWNQ+YZ?=
	=?iso-8859-15?Q?lpOAzVd+r2iSxJ+TNdYiWeexAFUlcbHsEBwBZ3iQK/qis7RhOvjdHeoK8?=
	=?iso-8859-15?Q?atlLGQ5Zl2qEw9Sr7KnFOYumxCnUeFxVSDpmzeFoRFuNR8jWdhmp7pIUd?=
	=?iso-8859-15?Q?OnX3z/lYq3MrxM1+hfpRgEq9wjtR0fA/SnV+PMpK6wC6R6YYqKO11QiCB?=
	=?iso-8859-15?Q?PU7D3fN3UVyWjx5qSeIfHvbKkjnl1+21pC+i0IIEV7tK+dfmNFuHVDgVj?=
	=?iso-8859-15?Q?NsnYK21Fb5KsSE2fOSe/Udd5iMJqqEl4IbVOyvmWndXCrgJtYU0H63QVJ?=
	=?iso-8859-15?Q?d+CNmIi34uHPKX2par08usD1lW5fI+NvxlMHkXitrL30Upfyr15jJbE3p?=
	=?iso-8859-15?Q?Lzld3usk0NfAViJ36xinCdaIwOoX1f5kglRFUiaYezmVFf1z7BfiOvqr0?=
	=?iso-8859-15?Q?xFxB7w62ted4Co5RwCy8nUhJyEUdy8pECUDZhBo2eDty4DGFU3fxpvtyF?=
	=?iso-8859-15?Q?ydhdIoRCVUmZexhhY6scu0hOnG+jv9CVjsDakvoxargbXcBNvgR1TugAd?=
	=?iso-8859-15?Q?fJoz3KB60LFiRwEJSLdFAEnKhpCviiZrllAKvH+rLk/pHAahgdXBl6QGH?=
	=?iso-8859-15?Q?z1yb+FS4/X+9K37rnbw2PXls5jNOsUgkeZS0J1SzmjHaSv3kBrdyH21ri?=
	=?iso-8859-15?Q?u7QcNI36ZZqCtxxb9Kbn7gMl6KK/yJ9ATm18rISppD8NUARv9OIthERXk?=
	=?iso-8859-15?Q?CLEM1W1RD86XDzAq1noIiujBcCgA5SxR+cr+FifiJcEFm1KAnw0X0ywt4?=
	=?iso-8859-15?Q?lLL1aOb7ogCTMTUCtNlWncYMjkSoyUuwyUrAfZXJIWaFR0JdBMnHpCIfK?=
	=?iso-8859-15?Q?K03hd/HJejFtbFx68B4DX2VPlZM4PlasAcnulv1K/w1rPgGwrY2bWUHc2?=
	=?iso-8859-15?Q?LA5ovlBr1HO/lnnyeYdASEmNg+ZGWX5EW1Mz7yLwKmJ5TuFqu90OMmfRQ?=
	=?iso-8859-15?Q?wLIMXgR0VRx0gbDy/peJo3l7jgemRHXtTpor4vhhNDCK9gosWg3xhjSxd?=
	=?iso-8859-15?Q?3HPQIJlJlE5a9Qe7QxSpsv0sozi2QFOEvMXNqJ622H2IsBywEc9Dt0o96?=
	=?iso-8859-15?Q?iVz0KA+l3Hb0w57/JsesEF1xsBNb8YDYn?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aadb0867-d945-404c-b802-08d9154298ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 12:36:42.6601 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HXuBRRO5WzVAs9AZAkgJ0j36cecFwDNyLPqxJ8x0ebiFZHnDVXsMfO8xWOvlIUFddTW7+q6PJvMD47tDxNrRNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6475
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14CCapBa025104
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/5] multipath: free vectors in configure
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <950235089ADC814B94EF09D8C2D3BCAC@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-05-11 at 18:22 -0500, Benjamin Marzinski wrote:
> configure() can retry multiple times, each time reallocing a maps and
> paths vector, and leaking the previous ones. Fix this by always
> freeing
> the vectors before configure() exits. Found by coverity.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0multipath/main.c | 7 ++++++-
> =A01 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/multipath/main.c b/multipath/main.c
> index ef89c7cf..25c5dbfd 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -466,7 +466,6 @@ configure (struct config *conf, enum mpath_cmds
> cmd,
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0curmp =3D vector_alloc();
> =A0=A0=A0=A0=A0=A0=A0=A0pathvec =3D vector_alloc();
> -=A0=A0=A0=A0=A0=A0=A0atexit(cleanup_vecs);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (!curmp || !pathvec) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "can not alloc=
ate memory");
> @@ -578,6 +577,11 @@ out:
> =A0=A0=A0=A0=A0=A0=A0=A0if (refwwid)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0FREE(refwwid);
> =A0
> +=A0=A0=A0=A0=A0=A0=A0free_multipathvec(curmp, KEEP_PATHS);
> +=A0=A0=A0=A0=A0=A0=A0vecs.mpvec =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0free_pathvec(pathvec, FREE_PATHS);
> +=A0=A0=A0=A0=A0=A0=A0vecs.pathvec =3D NULL;
> +
> =A0=A0=A0=A0=A0=A0=A0=A0return r;
> =A0}
> =A0
> @@ -1053,6 +1057,7 @@ main (int argc, char *argv[])
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D dm_flush_maps(1, re=
tries) ? RTVL_FAIL : RTVL_OK;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0atexit(cleanup_vecs);
> =A0=A0=A0=A0=A0=A0=A0=A0while ((r =3D configure(conf, cmd, dev_type, dev)=
) =3D=3D
> RTVL_RETRY)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "restart multi=
path configuration
> process");
> =A0


Nit: I'd rather move this atexit() call towards the beginning of
main(), after the other atexit() calls.

Apart from that, ACK.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

