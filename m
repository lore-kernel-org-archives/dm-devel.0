Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32390C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:55:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 807B961220
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:55:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 807B961220
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-gGBPXVd1PqCjxSmHWQNNqg-1; Thu, 04 Nov 2021 16:55:17 -0400
X-MC-Unique: gGBPXVd1PqCjxSmHWQNNqg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D477E362FA;
	Thu,  4 Nov 2021 20:55:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B677F5BB06;
	Thu,  4 Nov 2021 20:55:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8E90A1806D04;
	Thu,  4 Nov 2021 20:55:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4KtBvh024645 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 16:55:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F1C022026D64; Thu,  4 Nov 2021 20:55:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB4C72026D46
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:55:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 156B518A0160
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:55:08 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-504-1Ed6J25yMDanrib0J5W_Gg-1;
	Thu, 04 Nov 2021 16:55:06 -0400
X-MC-Unique: 1Ed6J25yMDanrib0J5W_Gg-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2055.outbound.protection.outlook.com [104.47.12.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-26-OoET5ROBMx6GxqQCMPORtw-1; Thu, 04 Nov 2021 21:55:04 +0100
X-MC-Unique: OoET5ROBMx6GxqQCMPORtw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5227.eurprd04.prod.outlook.com (2603:10a6:10:17::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Thu, 4 Nov 2021 20:55:02 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 20:55:02 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 4/8] libmultipath: pass file and line number to keyword
	handlers
Thread-Index: AQHXuu1nGl8ud2vnREW/qHUOGN/pR6v0Bp4A
Date: Thu, 4 Nov 2021 20:55:02 +0000
Message-ID: <e03bf2dd8395f3d809f3edecfb108c79b85f64a9.camel@suse.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633550663-25571-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2d03a22-007d-4a09-9361-08d99fd55f85
x-ms-traffictypediagnostic: DB7PR04MB5227:
x-microsoft-antispam-prvs: <DB7PR04MB52271B2175B748BCBB5B76CBFC8D9@DB7PR04MB5227.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:519
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: L3RQ4Bdg4VR5WLDO17hbG+tkTTHWv8yr6GS4LWPa/B9QMrM5ow6jgUGpbX+LjmzF1iapSz3covVSTq4A1A+b5ub9dUsuCZaXNqXDmHseQ0u4vIw+WgurMCaApLAovnzm6bcPm8WCzm14XxV/8mWMIfAe/8EO9kyyxn/TDo4qRPJ1OwV33EMy+limGGb7NRNYxE7/IguOKggFkb1Tptdgl1BfANhE+5y6ydnsPapxdNT6C71dC1BY4CycbjjP89RRC3PjPaqFlE1vAwHICtO/KtLQNjC/pRGvEwpLg0CPPCYsfdKY77RoreWNtux/tfWzbca8y/iXfxoJlSkxJqVjQNDkNkJTOR00BbilAUVQSyEolZg8dxbkmmOnAHyE9y8LToMefRvE775UNnzVaWY278aMXCwIRVCsLNSHGGnUjFzqRa1t9+Oz8pfDqx+Iv0bOe8RjIuiFvHSZilHtmy6yEerLSFesNiw03qTxd0hnKEs8eHa6dp2P6ZTzVSqxDtONkjaRSwgvgzyasScgaqYpysJLrAf4UxVK73lgVilKOoJBgGifc6a4IQGy+DSGt0IrgjfrrbG2qh4zS2RajuZiJB6uI0fQZEH+Y2gOcP1jMxYTHbITCLru2eIQ3rcMZS+GE7Fye3opTiXk4Ua/TkOY3VKn/DbiKJn0O6b3esrSloSi82+A/DSw5OdjDdRN2AM6NnNZnVHgcKgD0sv07uZVEw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(30864003)(316002)(71200400001)(6486002)(66946007)(86362001)(8676002)(5660300002)(91956017)(38100700002)(6506007)(2906002)(186003)(2616005)(38070700005)(110136005)(508600001)(4326008)(122000001)(76116006)(64756008)(83380400001)(66476007)(66556008)(6512007)(44832011)(66446008)(26005)(8936002)(36756003)(579004);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?6Fh1wnKJyK0Gu1DvCV+rOsqgnm+VFzEALOITisY5ZtyO9qnmr7b8lmL2F?=
	=?iso-8859-15?Q?pgayr2RVtfHul0Po0Q3Yeqii6t3QeH8KksuPrtTaB1tomxIlk7f6nHu0V?=
	=?iso-8859-15?Q?zk6V95137Y3qabvfHapUxyud6ST6b8o0fnN7JK/4V2VNsXcuzz57eHt1k?=
	=?iso-8859-15?Q?Zr8/Fh0nJiDYX0SiqQK2sIrKPDg3n+BZIamiX/Aar30a6ZRkM0aiztq/f?=
	=?iso-8859-15?Q?BJ6ruWSoBzYDG9IfXfJanbadG5hCB/Lfafp7vAZ6mEdjRJ41XqKVxIxlb?=
	=?iso-8859-15?Q?82YVMQB+CzU8lJz9b8n4kNrgeGFBhk6TKkibljOtUQq0y0WENxjxz4zSX?=
	=?iso-8859-15?Q?zM+XytD/vGyExWpOI90JGOWqRAmh/gKGMpf2jGYiBoATiZPX4kC7IIcRC?=
	=?iso-8859-15?Q?gSL8JKPJk/+JZ++2nSYw/jT6itUZGtIHTcHBdhJQVh5DnSvS4GR1I/7NT?=
	=?iso-8859-15?Q?AQimIellhUfVUXcROab0sKVo1AWuQbQ+Ublf4yNbcCyJZ7PETZM5NJntH?=
	=?iso-8859-15?Q?nH2YRgbZEJNsadeW+JNLwK8kz2fwJfzelJ+Wt/IrYAfTdH1PM06CAN+Y2?=
	=?iso-8859-15?Q?Dxv3qkQ/ZX0Erbon3NcsjQUWl9abP+lJSSShotkKs65n6YQ7g+4CrTlxD?=
	=?iso-8859-15?Q?U+MP/VOJHnOryj1OePFczfaZ3pDte2NApBIg8zCBryoiF9NzexYiwCOIe?=
	=?iso-8859-15?Q?1FTg41COZ3olklZJTXmoAK9CAOpZV8dIwdji4PVEesR4iEFzAf8R+lCDc?=
	=?iso-8859-15?Q?FRUiJvWPu+2H0uFU8tI/79eGokjMeJvFcBeXvF8N9LMWGEYgY4bQIZ3bP?=
	=?iso-8859-15?Q?7i6ox3IcKnkMthhCN4dGgV48t94HeNwiNdY6yfO3OsoWm3gCvTjCRyNQr?=
	=?iso-8859-15?Q?HeJfsbSVlTn035rId8U2yGLTMCWhbAhqKgBdcpPc9h8/1aEYYIAbqf7zi?=
	=?iso-8859-15?Q?+ozUPka7PskBN6otYAqQML5zmzh1dtYlQqigwtI0CUZRsWpqENrpB0E3J?=
	=?iso-8859-15?Q?/AFnoXzZMqfIPLiIguT3MoLVQvrXw/DE94m8NjkGFRMMPUiArCwD3kKMc?=
	=?iso-8859-15?Q?JWHaFd9Jw13Uch+pLEzz+4ZUu226pJFdxpPT86nIsyKhN7jwRoxa7CZXW?=
	=?iso-8859-15?Q?r0+214dIsntOfH6h0HzSrlUVjcXr1VNCMm3fz8iiTqt5n+n/5PLZzclCm?=
	=?iso-8859-15?Q?r3pqjEOurFfbTWhstymHJ5X5WMum9VjaV68Tx03uahw1+zQddFx9nj55P?=
	=?iso-8859-15?Q?0gjRnHXwAXsdhJFLksBuW2fLeI61Qx9A64opZ0BrO4aSsxlqRgmljPiiV?=
	=?iso-8859-15?Q?SXKvaaWMZntGnnWlomp57POWOqkzCocnurttgvdGiYMis9pW6sOk3uQyz?=
	=?iso-8859-15?Q?0DWEq+dEEPqnKWifWo30mzftn7a3SSr9cXhM74nlVDXrq/FG3J2N+b9tW?=
	=?iso-8859-15?Q?BVkokwsgV1GvpPuq37bWW5lf36IcGRrdfaKm6H5r02VGF347MzYqP++BK?=
	=?iso-8859-15?Q?3j+syc64ybSAvpFgkJILZFVfkL/mXZPlUGjYuC0eTstSKkeUtHA2F26de?=
	=?iso-8859-15?Q?0mvkXBTGAzpaAl5CtxhPf3kGplTFPtOx3oYAPxh6dP0FXQbGF8VX6pU1w?=
	=?iso-8859-15?Q?a5HeP4ttzRz6h8E+raMxsHpj8AmsRMwraMHjhApwnzhuzUFBJt5bnkhqz?=
	=?iso-8859-15?Q?kMEN+YBU4A0td4lLc+B3mNcQva2QaFSahkdSoJzxzyXVAbA=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d03a22-007d-4a09-9361-08d99fd55f85
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 20:55:02.8006 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V/+X9m83FqjplCzzaTTch9jp+v8rxm8tmDuYIx/rGW8nkGqimtGvSqBTsy6Wi+rwGJXid6royQfP0nfZI7cx9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5227
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4KtBvh024645
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/8] libmultipath: pass file and line number
 to keyword handlers
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
Content-ID: <3407DD241214F446849AC77C513BEF14@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> This will make it possible for the keyword handlers to print more
> useful
> warning messages. It will be used by future patches.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Nit: There's one very long line (349).

Apart from that, ack.



> ---
> =A0libmultipath/dict.c=A0=A0 | 143 +++++++++++++++++++++++++-------------=
----
> =A0libmultipath/parser.c |=A0=A0 3 +-
> =A0libmultipath/parser.h |=A0=A0 2 +-
> =A03 files changed, 90 insertions(+), 58 deletions(-)
>=20
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 7a727389..eb2c44c0 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -29,7 +29,7 @@
> =A0#include "strbuf.h"
> =A0
> =A0static int
> -set_int(vector strvec, void *ptr)
> +set_int(vector strvec, void *ptr, const char *file, int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> =A0=A0=A0=A0=A0=A0=A0=A0char *buff, *eptr;
> @@ -58,7 +58,7 @@ set_int(vector strvec, void *ptr)
> =A0}
> =A0
> =A0static int
> -set_uint(vector strvec, void *ptr)
> +set_uint(vector strvec, void *ptr, const char *file, int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int *uint_ptr =3D (unsigned int *)ptr;
> =A0=A0=A0=A0=A0=A0=A0=A0char *buff, *eptr, *p;
> @@ -90,7 +90,7 @@ set_uint(vector strvec, void *ptr)
> =A0}
> =A0
> =A0static int
> -set_str(vector strvec, void *ptr)
> +set_str(vector strvec, void *ptr, const char *file, int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char **str_ptr =3D (char **)ptr;
> =A0
> @@ -105,7 +105,7 @@ set_str(vector strvec, void *ptr)
> =A0}
> =A0
> =A0static int
> -set_yes_no(vector strvec, void *ptr)
> +set_yes_no(vector strvec, void *ptr, const char *file, int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> @@ -124,7 +124,7 @@ set_yes_no(vector strvec, void *ptr)
> =A0}
> =A0
> =A0static int
> -set_yes_no_undef(vector strvec, void *ptr)
> +set_yes_no_undef(vector strvec, void *ptr, const char *file, int
> line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> @@ -187,9 +187,10 @@ static int print_yes_no_undef(struct strbuf *buff,
> long v)
> =A0
> =A0#define declare_def_handler(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0\
> =A0static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> -def_ ## option ## _handler (struct config *conf, vector
> strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +def_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int
> line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0\
> -=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf-
> >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->option, file,
> line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0}
> =A0
> =A0#define declare_def_snprint(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0\
> @@ -224,12 +225,13 @@ snprint_def_ ## option (struct config *conf,
> struct strbuf *buff,=A0\
> =A0
> =A0#define declare_hw_handler(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> =A0static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> -hw_ ## option ## _handler (struct config *conf, vector
> strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +hw_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 const char *file, int
> line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0\
> =A0=A0=A0=A0=A0=A0=A0=A0struct hwentry * hwe =3D VECTOR_LAST_SLOT(conf-
> >hwtable);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0if
> (!hwe)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> -=A0=A0=A0=A0=A0=A0=A0return function (strvec, &hwe-
> >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &hwe->option, file,
> line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0}
> =A0
> =A0#define declare_hw_snprint(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> @@ -243,11 +245,12 @@ snprint_hw_ ## option (struct config *conf,
> struct strbuf *buff,=A0=A0\
> =A0
> =A0#define declare_ovr_handler(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0\
> =A0static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> -ovr_ ## option ## _handler (struct config *conf, vector
> strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +ovr_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int
> line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0\
> =A0=A0=A0=A0=A0=A0=A0=A0if (!conf-
> >overrides)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> -=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->overrides-
> >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->overrides->option, =
file,
> line_nr); \
> =A0}
> =A0
> =A0#define declare_ovr_snprint(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0\
> @@ -260,12 +263,13 @@ snprint_ovr_ ## option (struct config *conf,
> struct strbuf *buff,=A0\
> =A0
> =A0#define declare_mp_handler(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> =A0static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> -mp_ ## option ## _handler (struct config *conf, vector
> strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +mp_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 const char *file, int
> line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0\
> =A0=A0=A0=A0=A0=A0=A0=A0struct mpentry * mpe =3D VECTOR_LAST_SLOT(conf-
> >mptable);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0if
> (!mpe)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> -=A0=A0=A0=A0=A0=A0=A0return function (strvec, &mpe-
> >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &mpe->option, file,
> line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0}
> =A0
> =A0#define declare_mp_snprint(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> @@ -277,9 +281,10 @@ snprint_mp_ ## option (struct config *conf, struct
> strbuf *buff,=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0return function(buff, mpe-
> >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0}
> =A0
> -static int checkint_handler(struct config *conf, vector strvec)
> +static int checkint_handler(struct config *conf, vector strvec,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int line_nr)
> =A0{
> -=A0=A0=A0=A0=A0=A0=A0int rc =3D set_uint(strvec, &conf->checkint);
> +=A0=A0=A0=A0=A0=A0=A0int rc =3D set_uint(strvec, &conf->checkint, file, =
line_nr);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (rc)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return rc;
> @@ -302,9 +307,10 @@ declare_def_snprint(reassign_maps, print_yes_no)
> =A0declare_def_handler(multipath_dir, set_str)
> =A0declare_def_snprint(multipath_dir, print_str)
> =A0
> -static int def_partition_delim_handler(struct config *conf, vector
> strvec)
> +static int def_partition_delim_handler(struct config *conf, vector
> strvec,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *file, int line_nr)
> =A0{
> -=A0=A0=A0=A0=A0=A0=A0int rc =3D set_str(strvec, &conf->partition_delim);
> +=A0=A0=A0=A0=A0=A0=A0int rc =3D set_str(strvec, &conf->partition_delim, =
file,
> line_nr);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (rc !=3D 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return rc;
> @@ -334,13 +340,13 @@ static const char * const
> find_multipaths_optvals[] =3D {
> =A0};
> =A0
> =A0static int
> -def_find_multipaths_handler(struct config *conf, vector strvec)
> +def_find_multipaths_handler(struct config *conf, vector strvec,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char *buff;
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (set_yes_no_undef(strvec, &conf->find_multipaths=
) =3D=3D 0 &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 conf->find_multipaths !=3D FIND_MULTIPATH=
S_UNDEF)
> +=A0=A0=A0=A0=A0=A0=A0if (set_yes_no_undef(strvec, &conf->find_multipaths=
, file,
> line_nr) =3D=3D 0 && conf->find_multipaths !=3D FIND_MULTIPATHS_UNDEF)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> @@ -396,7 +402,8 @@ static int snprint_uid_attrs(struct config *conf,
> struct strbuf *buff,
> =A0=A0=A0=A0=A0=A0=A0=A0return total;
> =A0}
> =A0
> -static int uid_attrs_handler(struct config *conf, vector strvec)
> +static int uid_attrs_handler(struct config *conf, vector strvec,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char *val;
> =A0
> @@ -597,7 +604,8 @@ declare_hw_handler(skip_kpartx, set_yes_no_undef)
> =A0declare_hw_snprint(skip_kpartx, print_yes_no_undef)
> =A0declare_mp_handler(skip_kpartx, set_yes_no_undef)
> =A0declare_mp_snprint(skip_kpartx, print_yes_no_undef)
> -static int def_disable_changed_wwids_handler(struct config *conf,
> vector strvec)
> +static int def_disable_changed_wwids_handler(struct config *conf,
> vector strvec,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *file,=
 int
> line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> @@ -629,20 +637,23 @@ declare_def_snprint_defstr(enable_foreign,
> print_str,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 DEFAULT_ENABLE_FOREIGN)
> =A0
> =A0static int
> -def_config_dir_handler(struct config *conf, vector strvec)
> +def_config_dir_handler(struct config *conf, vector strvec, const char
> *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line=
_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0/* this is only valid in the main config file */
> =A0=A0=A0=A0=A0=A0=A0=A0if (conf->processed_main_config)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> -=A0=A0=A0=A0=A0=A0=A0return set_str(strvec, &conf->config_dir);
> +=A0=A0=A0=A0=A0=A0=A0return set_str(strvec, &conf->config_dir, file, lin=
e_nr);
> =A0}
> =A0declare_def_snprint(config_dir, print_str)
> =A0
> =A0#define declare_def_attr_handler(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> -def_ ## option ## _handler (struct config *conf, vector
> strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +def_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int
> line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0\
> -=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->option, &conf-
> >attribute_flags);\
> +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->option, &conf->attr=
ibute_flags,
> \
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fi=
le,
> line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0}
> =A0
> =A0#define declare_def_attr_snprint(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> @@ -655,12 +666,14 @@ snprint_def_ ## option (struct config *conf,
> struct strbuf *buff,=A0\
> =A0
> =A0#define declare_mp_attr_handler(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0\
> =A0static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> -mp_ ## option ## _handler (struct config *conf, vector
> strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +mp_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 const char *file, int
> line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0\
> =A0=A0=A0=A0=A0=A0=A0=A0struct mpentry * mpe =3D VECTOR_LAST_SLOT(conf-
> >mptable);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0if
> (!mpe)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> -=A0=A0=A0=A0=A0=A0=A0return function (strvec, &mpe->option, &mpe-
> >attribute_flags);=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &mpe->option, &mpe-
> >attribute_flags,=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fi=
le,
> line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0}
> =A0
> =A0#define declare_mp_attr_snprint(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0\
> @@ -673,7 +686,7 @@ snprint_mp_ ## option (struct config *conf, struct
> strbuf *buff,=A0=A0=A0=A0\
> =A0}
> =A0
> =A0static int
> -set_mode(vector strvec, void *ptr, int *flags)
> +set_mode(vector strvec, void *ptr, int *flags, const char *file, int
> line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0mode_t mode;
> =A0=A0=A0=A0=A0=A0=A0=A0mode_t *mode_ptr =3D (mode_t *)ptr;
> @@ -694,7 +707,7 @@ set_mode(vector strvec, void *ptr, int *flags)
> =A0}
> =A0
> =A0static int
> -set_uid(vector strvec, void *ptr, int *flags)
> +set_uid(vector strvec, void *ptr, int *flags, const char *file, int
> line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0uid_t uid;
> =A0=A0=A0=A0=A0=A0=A0=A0uid_t *uid_ptr =3D (uid_t *)ptr;
> @@ -719,7 +732,7 @@ set_uid(vector strvec, void *ptr, int *flags)
> =A0}
> =A0
> =A0static int
> -set_gid(vector strvec, void *ptr, int *flags)
> +set_gid(vector strvec, void *ptr, int *flags, const char *file, int
> line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0gid_t gid;
> =A0=A0=A0=A0=A0=A0=A0=A0gid_t *gid_ptr =3D (gid_t *)ptr;
> @@ -786,7 +799,7 @@ declare_mp_attr_handler(gid, set_gid)
> =A0declare_mp_attr_snprint(gid, print_gid)
> =A0
> =A0static int
> -set_undef_off_zero(vector strvec, void *ptr)
> +set_undef_off_zero(vector strvec, void *ptr, const char *file, int
> line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> @@ -827,7 +840,7 @@ declare_hw_handler(fast_io_fail,
> set_undef_off_zero)
> =A0declare_hw_snprint(fast_io_fail, print_undef_off_zero)
> =A0
> =A0static int
> -set_dev_loss(vector strvec, void *ptr)
> +set_dev_loss(vector strvec, void *ptr, const char *file, int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int *uint_ptr =3D (unsigned int *)ptr;
> @@ -870,7 +883,7 @@ declare_hw_handler(eh_deadline, set_undef_off_zero)
> =A0declare_hw_snprint(eh_deadline, print_undef_off_zero)
> =A0
> =A0static int
> -set_pgpolicy(vector strvec, void *ptr)
> +set_pgpolicy(vector strvec, void *ptr, const char *file, int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> @@ -936,7 +949,8 @@ get_sys_max_fds(int *max_fds)
> =A0
> =A0
> =A0static int
> -max_fds_handler(struct config *conf, vector strvec)
> +max_fds_handler(struct config *conf, vector strvec, const char *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0=A0=A0=A0=A0=A0=A0=A0int r =3D 0, max_fds;
> @@ -981,7 +995,7 @@ snprint_max_fds (struct config *conf, struct strbuf
> *buff, const void *data)
> =A0}
> =A0
> =A0static int
> -set_rr_weight(vector strvec, void *ptr)
> +set_rr_weight(vector strvec, void *ptr, const char *file, int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> @@ -1025,7 +1039,7 @@ declare_mp_handler(rr_weight, set_rr_weight)
> =A0declare_mp_snprint(rr_weight, print_rr_weight)
> =A0
> =A0static int
> -set_pgfailback(vector strvec, void *ptr)
> +set_pgfailback(vector strvec, void *ptr, const char *file, int
> line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> @@ -1075,7 +1089,7 @@ declare_mp_handler(pgfailback, set_pgfailback)
> =A0declare_mp_snprint(pgfailback, print_pgfailback)
> =A0
> =A0static int
> -no_path_retry_helper(vector strvec, void *ptr)
> +no_path_retry_helper(vector strvec, void *ptr, const char *file, int
> line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> @@ -1120,7 +1134,8 @@ declare_mp_handler(no_path_retry,
> no_path_retry_helper)
> =A0declare_mp_snprint(no_path_retry, print_no_path_retry)
> =A0
> =A0static int
> -def_log_checker_err_handler(struct config *conf, vector strvec)
> +def_log_checker_err_handler(struct config *conf, vector strvec,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0
> @@ -1193,7 +1208,8 @@ print_reservation_key(struct strbuf *buff,
> =A0}
> =A0
> =A0static int
> -def_reservation_key_handler(struct config *conf, vector strvec)
> +def_reservation_key_handler(struct config *conf, vector strvec,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0return set_reservation_key(strvec, &conf->reserva=
tion_key,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &conf->sa_flags,
> @@ -1209,7 +1225,8 @@ snprint_def_reservation_key (struct config *conf,
> struct strbuf *buff,
> =A0}
> =A0
> =A0static int
> -mp_reservation_key_handler(struct config *conf, vector strvec)
> +mp_reservation_key_handler(struct config *conf, vector strvec, const
> char *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct mpentry * mpe =3D VECTOR_LAST_SLOT(conf->m=
ptable);
> =A0=A0=A0=A0=A0=A0=A0=A0if (!mpe)
> @@ -1229,7 +1246,7 @@ snprint_mp_reservation_key (struct config *conf,
> struct strbuf *buff,
> =A0}
> =A0
> =A0static int
> -set_off_int_undef(vector strvec, void *ptr)
> +set_off_int_undef(vector strvec, void *ptr, const char *file, int
> line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> @@ -1370,7 +1387,8 @@ declare_hw_snprint(recheck_wwid,
> print_yes_no_undef)
> =A0
> =A0
> =A0static int
> -def_uxsock_timeout_handler(struct config *conf, vector strvec)
> +def_uxsock_timeout_handler(struct config *conf, vector strvec, const
> char *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int uxsock_timeout;
> =A0=A0=A0=A0=A0=A0=A0=A0char *buff;
> @@ -1390,7 +1408,8 @@ def_uxsock_timeout_handler(struct config *conf,
> vector strvec)
> =A0}
> =A0
> =A0static int
> -hw_vpd_vendor_handler(struct config *conf, vector strvec)
> +hw_vpd_vendor_handler(struct config *conf, vector strvec, const char
> *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr=
)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> =A0=A0=A0=A0=A0=A0=A0=A0char *buff;
> @@ -1430,7 +1449,8 @@ snprint_hw_vpd_vendor(struct config *conf, struct
> strbuf *buff,
> =A0 * blacklist block handlers
> =A0 */
> =A0static int
> -blacklist_handler(struct config *conf, vector strvec)
> +blacklist_handler(struct config *conf, vector strvec, const char*file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0if (!conf->blist_devnode)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->blist_devnode =3D v=
ector_alloc();
> @@ -1452,7 +1472,8 @@ blacklist_handler(struct config *conf, vector
> strvec)
> =A0}
> =A0
> =A0static int
> -blacklist_exceptions_handler(struct config *conf, vector strvec)
> +blacklist_exceptions_handler(struct config *conf, vector strvec,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0if (!conf->elist_devnode)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->elist_devnode =3D v=
ector_alloc();
> @@ -1475,7 +1496,8 @@ blacklist_exceptions_handler(struct config *conf,
> vector strvec)
> =A0
> =A0#define
> declare_ble_handler(option)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> -ble_ ## option ## _handler (struct config *conf, vector
> strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +ble_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int
> line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0\
> =A0=A0=A0=A0=A0=A0=A0=A0char
> *buff;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0int
> rc;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> @@ -1494,7 +1516,8 @@ ble_ ## option ## _handler (struct config *conf,
> vector strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0
> =A0#define declare_ble_device_handler(name, option, vend,
> prod)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> -ble_ ## option ## _ ## name ## _handler (struct config *conf, vector
> strvec) \
> +ble_ ## option ## _ ## name ## _handler (struct config *conf, vector
> strvec, \
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *file, int
> line_nr)=A0\
> =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0\
> =A0=A0=A0=A0=A0=A0=A0=A0char *
> buff;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0int
> rc;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> @@ -1536,13 +1559,15 @@ snprint_ble_simple (struct config *conf, struct
> strbuf *buff, const void *data)
> =A0}
> =A0
> =A0static int
> -ble_device_handler(struct config *conf, vector strvec)
> +ble_device_handler(struct config *conf, vector strvec, const char
> *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0return alloc_ble_device(conf->blist_device);
> =A0}
> =A0
> =A0static int
> -ble_except_device_handler(struct config *conf, vector strvec)
> +ble_except_device_handler(struct config *conf, vector strvec, const
> char *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0return alloc_ble_device(conf->elist_device);
> =A0}
> @@ -1574,7 +1599,8 @@ static int snprint_bled_product(struct config
> *conf, struct strbuf *buff,
> =A0 * devices block handlers
> =A0 */
> =A0static int
> -devices_handler(struct config *conf, vector strvec)
> +devices_handler(struct config *conf, vector strvec, const char *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0if (!conf->hwtable)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->hwtable =3D vector_=
alloc();
> @@ -1586,7 +1612,8 @@ devices_handler(struct config *conf, vector
> strvec)
> =A0}
> =A0
> =A0static int
> -device_handler(struct config *conf, vector strvec)
> +device_handler(struct config *conf, vector strvec, const char *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct hwentry * hwe;
> =A0
> @@ -1623,7 +1650,8 @@ declare_hw_snprint(hwhandler, print_str)
> =A0 * overrides handlers
> =A0 */
> =A0static int
> -overrides_handler(struct config *conf, vector strvec)
> +overrides_handler(struct config *conf, vector strvec, const char
> *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0if (!conf->overrides)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->overrides =3D alloc=
_hwe();
> @@ -1640,7 +1668,8 @@ overrides_handler(struct config *conf, vector
> strvec)
> =A0 * multipaths block handlers
> =A0 */
> =A0static int
> -multipaths_handler(struct config *conf, vector strvec)
> +multipaths_handler(struct config *conf, vector strvec, const char
> *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0if (!conf->mptable)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->mptable =3D vector_=
alloc();
> @@ -1652,7 +1681,8 @@ multipaths_handler(struct config *conf, vector
> strvec)
> =A0}
> =A0
> =A0static int
> -multipath_handler(struct config *conf, vector strvec)
> +multipath_handler(struct config *conf, vector strvec, const char
> *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct mpentry * mpe;
> =A0
> @@ -1681,7 +1711,8 @@ declare_mp_snprint(alias, print_str)
> =A0 */
> =A0
> =A0static int
> -deprecated_handler(struct config *conf, vector strvec)
> +deprecated_handler(struct config *conf, vector strvec, const char
> *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0
> diff --git a/libmultipath/parser.c b/libmultipath/parser.c
> index d5595fb0..68262d0e 100644
> --- a/libmultipath/parser.c
> +++ b/libmultipath/parser.c
> @@ -558,7 +558,8 @@ process_stream(struct config *conf, FILE *stream,
> vector keywords,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0got=
o out;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (keyword->handler) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 t =3D keyword->handler(conf, strvec);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 t =3D keyword->handler(conf, strvec,
> file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 line_nr);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r +=3D t;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (t)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(1, "%s line %d,
> parsing failed: %s",
> diff --git a/libmultipath/parser.h b/libmultipath/parser.h
> index 3452bde1..11ea2278 100644
> --- a/libmultipath/parser.h
> +++ b/libmultipath/parser.h
> @@ -43,7 +43,7 @@ struct strbuf;
> =A0
> =A0/* keyword definition */
> =A0typedef int print_fn(struct config *, struct strbuf *, const void *);
> -typedef int handler_fn(struct config *, vector);
> +typedef int handler_fn(struct config *, vector, const char *file, int
> line_nr);
> =A0
> =A0struct keyword {
> =A0=A0=A0=A0=A0=A0=A0=A0char *string;




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

