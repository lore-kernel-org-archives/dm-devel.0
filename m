Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF21C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:34:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 261F6611EE
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 261F6611EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-cyd_JQabOASDl-VJG1BesQ-1; Thu, 04 Nov 2021 16:34:37 -0400
X-MC-Unique: cyd_JQabOASDl-VJG1BesQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F65D100C664;
	Thu,  4 Nov 2021 20:34:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D66B5DD68;
	Thu,  4 Nov 2021 20:34:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9BD141806D03;
	Thu,  4 Nov 2021 20:34:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4KYUVX022148 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 16:34:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 78D572026D65; Thu,  4 Nov 2021 20:34:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 725BC2026D64
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:34:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7096B1064FAD
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:34:25 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-593-l_RFYCwFO9Geh9FfX72Vtw-1;
	Thu, 04 Nov 2021 16:34:24 -0400
X-MC-Unique: l_RFYCwFO9Geh9FfX72Vtw-1
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur02lp2051.outbound.protection.outlook.com [104.47.4.51])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-29-zzg-tNeYMP-f8Oh3KqtNKA-1; Thu, 04 Nov 2021 21:34:22 +0100
X-MC-Unique: zzg-tNeYMP-f8Oh3KqtNKA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5228.eurprd04.prod.outlook.com (2603:10a6:10:1b::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10;
	Thu, 4 Nov 2021 20:34:20 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 20:34:20 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 6/8] libmultipath: improve checks for set_str
Thread-Index: AQHXuu1p2RKByrtZakKWNdsnipSlz6v0ANUA
Date: Thu, 4 Nov 2021 20:34:20 +0000
Message-ID: <5424c4163d1fee71af3f1126adc2a59d3069b09f.camel@suse.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633550663-25571-7-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1429210-09f4-46ca-38ef-08d99fd27b28
x-ms-traffictypediagnostic: DB7PR04MB5228:
x-microsoft-antispam-prvs: <DB7PR04MB522894BB67C03F28C96F0BEAFC8D9@DB7PR04MB5228.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: g1WjVA61vNmye6lL8LAG6C9Jg+THsTIvK/kQtLzLzKF8KdWiEp41opG8EK4qdCb3kEnTRyRnDMEnVgdgDZ7f/8pEQKmOVI8hf6E5xO6cN8lIAmZRlSgrjFx+Cr+RKz/QOPn02fo9vKDxmK2QMbNLhHxYSlE78/5mmeeTFsrb5P818s1VYmJ26LWDNLLMpNxbDH/DYQ8hlm+yCZ0vw76TKwbD6BqGFn5esjCbT0cAeGkOJW5BhRXgI1LVTVsJ6aQHHEwPJSt2OAT7tivKTmQg9iUpel3PKc5EeWe5zBKphvBIj3qvAMi4c6FtsD8ngS75jzTpCSTsRc44xMQGSyHuHH8VzHzYVA5ACd2VC8r0YgJtuqvMvYukKLJkOUt+WDnn4jdU78ynlBWIDmawHVuzjCk0CMCRzrfN52EMflk7MVrtL+V77jpV0qdYhDujRpCB7528mFiyHPsBj3pCrCOSFAQuATCKykvGJBnQ8DL0aO1At/vx8nxLtKGsmV0U5vS83ZiWVk2oQlDdkkYyukKVdXmfDw6Rg+9wfT50wvkOznOrYVPx/P98VELOjK4YJ7yyTJARF4e+mpAw8CRSBX6tnMKzr50zaLhzG3o2q/DDtQfpdLO/g7Fbe5J2aBBNuNtuFD8KaHPdxCQvN7v1EqwUd6QSD6Gtx/ILZKUKt5lkpNh7EU/JFb/4sZ9/reMZL1gJEZOH60QwGDJXQ8GfhV/MbA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(5660300002)(6506007)(6486002)(316002)(4326008)(83380400001)(508600001)(66556008)(66476007)(64756008)(66946007)(91956017)(76116006)(6512007)(66446008)(86362001)(8676002)(38100700002)(36756003)(8936002)(122000001)(26005)(2616005)(38070700005)(71200400001)(2906002)(186003)(44832011)(110136005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?ZuvDnAr2/y9rXLdgXA/3EUrJqxxuDEssHwO0rQXsp2JO5tooW3nKhTDCt?=
	=?iso-8859-15?Q?5ZXhLdyO8YVcKDXHYpZ54TKfhnpsk136LTGq+pi2s9wD9Xv2+n0l7Roix?=
	=?iso-8859-15?Q?Bp+bvivEaXWVr/xiX7NjxwQI6Nrf69E/oZm6ot4UU+VCl4KnK6RTcfcNC?=
	=?iso-8859-15?Q?Ep6Oyxsy1MonOBQRLy1yd7Xz60eVDwlEFT9z8dH/vH5nJm7qcuEgtq+sw?=
	=?iso-8859-15?Q?/kYCsFnhznV2cVBmWLzJqi6fW02Xn8ec3mv5Ter16JrbdjaXGiUvChTmd?=
	=?iso-8859-15?Q?3Ye6GktCsTBklcI9nIkFZIRBL5uJ3Bh/Ub7SHybDX86sbtU/8F92SC1FC?=
	=?iso-8859-15?Q?occnZUJXP0wYuqFFrbR4fxSqOhxXWabCF5H1SrCsG70k7fXu0/oas6ktT?=
	=?iso-8859-15?Q?i2f2ZoIHnv2MJ2LQm/ih4PQikXQ+YlOb+UBi0xeQ7OFgLt5ryZ+gSMrq0?=
	=?iso-8859-15?Q?vsP0HWYH0BZgMVtIPJSEp5lox6bYsWK4zA+hE1RXfRPu0QS8H1Bvhrlxs?=
	=?iso-8859-15?Q?ORgotm24Vg5vjJuVts8kVlC7AJ8sIPfnPyJIaQUL4ZZwHJXGdEWImaXHz?=
	=?iso-8859-15?Q?qLPindEov/8VbGWkCv+2YGjPKgJYOmP0R6TVKVss1RstsOGIEaVrsxMkH?=
	=?iso-8859-15?Q?DDTDiVqtjcT1RoDsm+qWdMaaZqo/GgPKrQpO+t8PvTlcCblI7T2eyOjWl?=
	=?iso-8859-15?Q?FnSi8GdlsVpzWI+iD40RezFsu4fro7+on9rjOZRUsqnYSMOMaJfjvq5u3?=
	=?iso-8859-15?Q?90H9TEpPydOhJyrWKhH5uAWCnzYlWOwhjS9hhq6qb5/begdfOongInvR6?=
	=?iso-8859-15?Q?OnEGghwG3VfpOoQgAf23Bzr/D3ZOvqAcZKSham9zU2sZ5VY8zm5jqaiK2?=
	=?iso-8859-15?Q?P14JkW+kBqQkaVs5XFN4XsHgYO+1MB4ffW0j1sMx3CUeoBR8BbJKlSdav?=
	=?iso-8859-15?Q?c8RgAyhhZS97hZ/XD0Va9FgNbH6iWR5m8aMmJMx9bzM42d32bt1/G1je1?=
	=?iso-8859-15?Q?H3tjLErrQgUzOOqhvkhMljpufoyVyJUE7YWsHS7Z98ruXa//0/AZ8JnJy?=
	=?iso-8859-15?Q?wWSzvCmKeXSeSnglXD7R4KZRkqbUadIhcAZ7rPUR+KFKJj2A2cvDQzKwF?=
	=?iso-8859-15?Q?OMFahJfHL36HC4PcYJF02pu4GUv7Qsbid/5A4FJeHWKLahnzVD3H9ctn1?=
	=?iso-8859-15?Q?k8SwP5Mx2NwhRNCTHVQKLezOycdPm9IFxY/FAxTQrO7NfW5hMrBMvzwyj?=
	=?iso-8859-15?Q?KNuhgjwwNjATd2dEqyhDm7/QEEzmgbHyCA/abx+jiELAR/4KGzlPt8x/l?=
	=?iso-8859-15?Q?rICTCgp5QG8aZgAakUyY8kXLktGBM3KVnbkF7jHNALp8lT7dIvdk0XplA?=
	=?iso-8859-15?Q?qG7OQAD2ufzoK7k6+5KuStsNLU6lKKRU5YgWqmu1ijtWldgsM1+veBlv0?=
	=?iso-8859-15?Q?4CH7HoqdI9IRs+UkGwluyomTn8POfOnOEOBk6OD6H65rmJVoNomQXKmnt?=
	=?iso-8859-15?Q?Ejj2KmY52qI4t0/Gk8tS4oPwlDHyl9mkdiSvVkEgXR5NB+yoIyN4AWFHh?=
	=?iso-8859-15?Q?DZKSifAZ9uGIpL57I/85r/gZ3TRQ7EvSbgWrRKDUdj5DoxLnmqeaMBruG?=
	=?iso-8859-15?Q?6uIaSiLWCfq4knSIKWAFmZ7u3XTd/3mjtZtWHj58VVWaqR5sicCezlJeB?=
	=?iso-8859-15?Q?KNjuWfUOCghZUQ0Z55bMhCb4ez1UGoBALFd1KeoyAjupC68=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1429210-09f4-46ca-38ef-08d99fd27b28
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 20:34:20.6788 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wt1bXsktqgchZCyfhxctqfyTbIAQrDc3iquPQ47iGSu2AHgdXujnMm+7bknJDFn8YsNG+4EWtdp0PZiQFHSviA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5228
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4KYUVX022148
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 6/8] libmultipath: improve checks for set_str
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
Content-ID: <6CF204625672814294B96C200632F07C@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> multipath always requires absolute pathnames, so make sure all file
> and
> directory names start with a slash.=A0 Also check that the directories
> exist.=A0 Finally, some strings, like the alias, will be used in paths.
> These must not contain the slash character '/', since it is a
> forbidden
> character in file/directory names. This patch adds seperate handlers
> for
> these three cases. If a config line is invalid, these handlers retain
> the existing config string, if any.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Mostly OK, see remarks below. I'm a bit wary that when we start this,
we might need to do other checks as well. For example, as multipathd is
running as root, we may want to check that the paths to files it writes
to (bindings_file etc.) don't contain symlinks and have proper
permissions... But that'd be another patch.

Regards,
Martin


> ---
> =A0libmultipath/dict.c | 88 +++++++++++++++++++++++++++++++++++++++----
> --
> =A01 file changed, 78 insertions(+), 10 deletions(-)
>=20
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 1758bd26..91333068 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -5,6 +5,8 @@
> =A0 * Copyright (c) 2005 Kiyoshi Ueda, NEC
> =A0 */
> =A0#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> =A0#include <pwd.h>
> =A0#include <string.h>
> =A0#include "checkers.h"
> @@ -111,6 +113,72 @@ set_str(vector strvec, void *ptr, const char
> *file, int line_nr)
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0
> +static int
> +set_dir(vector strvec, void *ptr, const char *file, int line_nr)
> +{
> +=A0=A0=A0=A0=A0=A0=A0char **str_ptr =3D (char **)ptr;
> +=A0=A0=A0=A0=A0=A0=A0char *old_str =3D *str_ptr;
> +=A0=A0=A0=A0=A0=A0=A0struct stat sb;
> +
> +=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D set_value(strvec);
> +=A0=A0=A0=A0=A0=A0=A0if (!*str_ptr) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0if ((*str_ptr)[0] !=3D '/'){
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, %s =
is not an absolute
> directory path. Ignoring", file, line_nr, *str_ptr);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D old_str;
> +=A0=A0=A0=A0=A0=A0=A0} else {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (stat(*str_ptr, &sb) =3D=
=3D 0 && S_ISDIR(sb.st_mode))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fre=
e(old_str);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(1, "%s line %d, %s is not an existing
> directory. Ignoring", file, line_nr, *str_ptr);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*st=
r_ptr =3D old_str;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> +}
> +
> +static int
> +set_path(vector strvec, void *ptr, const char *file, int line_nr)
> +{
> +=A0=A0=A0=A0=A0=A0=A0char **str_ptr =3D (char **)ptr;
> +=A0=A0=A0=A0=A0=A0=A0char *old_str =3D *str_ptr;
> +
> +=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D set_value(strvec);
> +=A0=A0=A0=A0=A0=A0=A0if (!*str_ptr) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0if ((*str_ptr)[0] !=3D '/'){
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, %s =
is not an absolute path.
> Ignoring",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, *str_ptr);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D old_str;
> +=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> +}

Once you go down this route, you might as well test that the dirname of
the path is an existing directory.



> +
> +static int
> +set_str_noslash(vector strvec, void *ptr, const char *file, int
> line_nr)
> +{
> +=A0=A0=A0=A0=A0=A0=A0char **str_ptr =3D (char **)ptr;
> +=A0=A0=A0=A0=A0=A0=A0char *old_str =3D *str_ptr;
> +
> +=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D set_value(strvec);
> +=A0=A0=A0=A0=A0=A0=A0if (!*str_ptr) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0if (strchr(*str_ptr, '/')) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, %s =
cannot contain a slash.
> Ignoring",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, *str_ptr);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D old_str;
> +=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> +}
> +
> =A0static int
> =A0set_yes_no(vector strvec, void *ptr, const char *file, int line_nr)
> =A0{
> @@ -353,13 +421,13 @@ declare_def_snprint(verbosity, print_int)
> =A0declare_def_handler(reassign_maps, set_yes_no)
> =A0declare_def_snprint(reassign_maps, print_yes_no)
> =A0
> -declare_def_handler(multipath_dir, set_str)
> +declare_def_handler(multipath_dir, set_dir)
> =A0declare_def_snprint(multipath_dir, print_str)
> =A0
> =A0static int def_partition_delim_handler(struct config *conf, vector
> strvec,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *file, int line_nr)
> =A0{
> -=A0=A0=A0=A0=A0=A0=A0int rc =3D set_str(strvec, &conf->partition_delim, =
file,
> line_nr);
> +=A0=A0=A0=A0=A0=A0=A0int rc =3D set_str_noslash(strvec, &conf->partition=
_delim,
> file, line_nr);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (rc !=3D 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return rc;
> @@ -490,11 +558,11 @@ declare_hw_snprint(prio_name, print_str)
> =A0declare_mp_handler(prio_name, set_str)
> =A0declare_mp_snprint(prio_name, print_str)
> =A0
> -declare_def_handler(alias_prefix, set_str)
> +declare_def_handler(alias_prefix, set_str_noslash)
> =A0declare_def_snprint_defstr(alias_prefix, print_str,
> DEFAULT_ALIAS_PREFIX)
> -declare_ovr_handler(alias_prefix, set_str)
> +declare_ovr_handler(alias_prefix, set_str_noslash)
> =A0declare_ovr_snprint(alias_prefix, print_str)
> -declare_hw_handler(alias_prefix, set_str)
> +declare_hw_handler(alias_prefix, set_str_noslash)
> =A0declare_hw_snprint(alias_prefix, print_str)
> =A0
> =A0declare_def_handler(prio_args, set_str)
> @@ -586,13 +654,13 @@ declare_hw_snprint(user_friendly_names,
> print_yes_no_undef)
> =A0declare_mp_handler(user_friendly_names, set_yes_no_undef)
> =A0declare_mp_snprint(user_friendly_names, print_yes_no_undef)
> =A0
> -declare_def_handler(bindings_file, set_str)
> +declare_def_handler(bindings_file, set_path)
> =A0declare_def_snprint(bindings_file, print_str)
> =A0
> -declare_def_handler(wwids_file, set_str)
> +declare_def_handler(wwids_file, set_path)
> =A0declare_def_snprint(wwids_file, print_str)
> =A0
> -declare_def_handler(prkeys_file, set_str)
> +declare_def_handler(prkeys_file, set_path)
> =A0declare_def_snprint(prkeys_file, print_str)
> =A0
> =A0declare_def_handler(retain_hwhandler, set_yes_no_undef)
> @@ -692,7 +760,7 @@ def_config_dir_handler(struct config *conf,
> vector strvec, const char *file,
> =A0=A0=A0=A0=A0=A0=A0=A0/* this is only valid in the main config file */
> =A0=A0=A0=A0=A0=A0=A0=A0if (conf->processed_main_config)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> -=A0=A0=A0=A0=A0=A0=A0return set_str(strvec, &conf->config_dir, file, lin=
e_nr);
> +=A0=A0=A0=A0=A0=A0=A0return set_path(strvec, &conf->config_dir, file, li=
ne_nr);
> =A0}

Why not set_dir() here?

> =A0declare_def_snprint(config_dir, print_str)
> =A0
> @@ -1732,7 +1800,7 @@ multipath_handler(struct config *conf, vector
> strvec, const char *file,
> =A0declare_mp_handler(wwid, set_str)
> =A0declare_mp_snprint(wwid, print_str)
> =A0
> -declare_mp_handler(alias, set_str)
> +declare_mp_handler(alias, set_str_noslash)
> =A0declare_mp_snprint(alias, print_str)
> =A0
> =A0/*


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

