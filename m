Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0B2C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 07:02:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F0B8F60F5A
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 07:02:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F0B8F60F5A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-zD-EV_baN1WZWZB-KlovCQ-1; Fri, 05 Nov 2021 03:02:22 -0400
X-MC-Unique: zD-EV_baN1WZWZB-KlovCQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D564910A8E00;
	Fri,  5 Nov 2021 07:02:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AA585D9D3;
	Fri,  5 Nov 2021 07:02:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B76204A703;
	Fri,  5 Nov 2021 07:02:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A56xMLT013073 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 02:59:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1BBD72166B26; Fri,  5 Nov 2021 06:59:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 14C822166B25
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 06:59:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27B7E801E6E
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 06:59:19 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-446-ZuxqyfekOCCh4d27FSJoCw-1;
	Fri, 05 Nov 2021 02:59:15 -0400
X-MC-Unique: ZuxqyfekOCCh4d27FSJoCw-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2175.outbound.protection.outlook.com [104.47.17.175])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-3-kNu_YJ0gMe2lH2RrFU_g1g-2; Fri, 05 Nov 2021 07:59:13 +0100
X-MC-Unique: kNu_YJ0gMe2lH2RrFU_g1g-2
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
	by VI1PR0401MB2525.eurprd04.prod.outlook.com (2603:10a6:800:4f::21)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.19;
	Fri, 5 Nov 2021 06:59:11 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
	([fe80::94cc:cd3e:e473:4e45]) by
	VE1PR04MB6560.eurprd04.prod.outlook.com
	([fe80::94cc:cd3e:e473:4e45%4]) with mapi id 15.20.4669.011;
	Fri, 5 Nov 2021 06:59:11 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 6/8] libmultipath: improve checks for set_str
Thread-Index: AQHXuu1p2RKByrtZakKWNdsnipSlz6v0ANUAgACulAA=
Date: Fri, 5 Nov 2021 06:59:11 +0000
Message-ID: <05b1d72f805515947ea21b9afd43446de6a2c7d6.camel@suse.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-7-git-send-email-bmarzins@redhat.com>
	<5424c4163d1fee71af3f1126adc2a59d3069b09f.camel@suse.com>
In-Reply-To: <5424c4163d1fee71af3f1126adc2a59d3069b09f.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0bca96a-9247-411a-776c-08d9a029c570
x-ms-traffictypediagnostic: VI1PR0401MB2525:
x-microsoft-antispam-prvs: <VI1PR0401MB2525A9BB36E0805E174651ABFC8E9@VI1PR0401MB2525.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: NqzuVVXgjdXZAosYnGeF55vXd6KkOmxFWMR5Lwzu3ISYZZdu7HhUZacj7xcb47GON4d/v+JIy3Nx7Y1HTuD0YnB02gsPyHabPMXlTXZrShYUG2/1HNvOuqaexlOnoB6aAjiIwl/5oBXlcfHII004uAb3z65UVBODFWthmLVFDJJbhahXFMjdLJRri+vGKH39EKiY6IT49DYmIcdF+n0XEFM/cmiZj9U93zLj9reXVke3QWPZH/6TnGqriKfv+9A0ex8gpA2fOcU7j3k+XXjdbx6VZKiNTXu64GyG0pFjQ2PLPW0PzeKXEVbdPNgpQieDWBpd5JbRUmF8OztHDeaZWKuFLQTxIMKzv9D0izL1EhBPWB381cEiWzYOaTi3kWsQV6kx/cJLQ2uPgMbO5kMb2E+MtvE7fptmHPXY2vkCznE3UHpXjAWvy9RGdb6F5H1m8cQAAcsakIDefH36CbSvBYtKvricelVKC41iizvDhwVHtsdmjtQ1aBKaxmtGPxSlKiIugShM+1N1igtM7M+wtj2SSDb9eMy0KAGFaWFadOCiysrlsgeD6uXNxtGVJaRzyLcNIa679SB0IS9aZqKkLXr4C+ebM7ZxEYGQa3kNKkZz/sIJCtCsfCmXO7oza8BLwDXtrhqnZRgrOBXllIVOBEo3RadtFtV2KokXFMCikoO4+wrmucXgKmYTz6gJLPu1RahM74kxlLkay1Y90ma9Lw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:VE1PR04MB6560.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(316002)(38100700002)(5660300002)(122000001)(110136005)(508600001)(4326008)(36756003)(76116006)(2906002)(91956017)(6512007)(8676002)(44832011)(83380400001)(86362001)(66476007)(2616005)(66946007)(71200400001)(66556008)(38070700005)(64756008)(8936002)(26005)(66446008)(6486002)(186003)(6506007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?nn0VR4t/Q42RBPhmRpuLEnxsh0sHiH0jY/lZ3A6l8p2OPB4tVLn36ov7x?=
	=?iso-8859-15?Q?AHbZ01hgG5JPpGc2LRm2rz5iDRmXeggUBh3P2P42c0g3U6yL2MOOMs2PJ?=
	=?iso-8859-15?Q?KZ2EV2caoPH2S9fEKPtK6Z+NtK4g/D1ZDvkTYi/8nIN2u5tzcp6tWSN/5?=
	=?iso-8859-15?Q?iHLc3hq+G8cP+ntTpf77ex6av4tdHkilLmvddjqyYt2ftcGz6bPQFBIrn?=
	=?iso-8859-15?Q?t9S52IhdLUJrCfVxyTUl7Fb8fWDyajU8HwguHfwAEn7nhKLCvdbZjiGoH?=
	=?iso-8859-15?Q?kFolrB982SeMXKfp/gfeTAe2cEz+s2wLGdiabtHqndNO/qhwMfxaH5k0L?=
	=?iso-8859-15?Q?gSljmeAl1Jo9/IDyLldT/ndVyePv6vKGewkog7wkP4GsFR7lSiysbEqu9?=
	=?iso-8859-15?Q?HW6p01Q5cx7zby4ms86gnJP/B4Yunaq28JXX7fZt8Gxf2it4Hq7YLe75R?=
	=?iso-8859-15?Q?xFP5c4rBIskBph1OMC4D0Y7X7HrOKLlaCNNw8XkIFS1w+VsGRIQFsBK0w?=
	=?iso-8859-15?Q?iGzrrwM3Ivsf1pIhuJskzP5fMk83G77uQDDqPcl0FXfjXIS717MWuDn31?=
	=?iso-8859-15?Q?9ATa9IehNlMng4/jJO0QFMv3TbPomU+C3qdsG3VP8Eu7lIHskaYZbVwHE?=
	=?iso-8859-15?Q?QOUnvky52ZElWqdJ9WUBQyV4j3BT0dz089DP+r/xYHOuQWYcI/J1fH77k?=
	=?iso-8859-15?Q?Jtvy9bEjy0QYpY7Z2ZikqUDXNO0QIGYAKt9vW0UJbxQiTIAb8g77/lkhW?=
	=?iso-8859-15?Q?oDgvvo8uSoHwVe9y3KBUtUSsfmDFQf/T2ZlpPBZn1a2zx4MMVGaJXWfC7?=
	=?iso-8859-15?Q?mAO3Dp3T2+hALPswd3zSJwn5cChZ9xiPxU3KiEwGuBAd6JJyl90ryx5+q?=
	=?iso-8859-15?Q?JmNb0V4lUic5+Hc2LCEguBbwmLqz3n4qjoZoWPguzKmIXFpDkruD/xZD4?=
	=?iso-8859-15?Q?tI/CG4RflPwpdgntBLaay19f1D9dwqHaF0R4bNw+Pdg0zNr++iYVIc+ou?=
	=?iso-8859-15?Q?sPX24lqAqnFxI+55LaqSTdutfYh12k7znpbTBmeZNmkqTcmb12+gjGAbK?=
	=?iso-8859-15?Q?pTrHeBPdcb+c6hhe5jFHq8eJ8WtmzmiVDqsriTAO+0nzL3DuOT3LvjfbK?=
	=?iso-8859-15?Q?Y78cqU9qhAu1vVqsG46yuFBvMxfVlmezdmHdyKx1HX7Vk2Q5Qu8tLdU9s?=
	=?iso-8859-15?Q?ovkuyPVhgQEJ3KTRLOnMQ0ojyXBlT/fHyPjoPtiPbHsrAIKKxwJosR0SH?=
	=?iso-8859-15?Q?takYEtmi3CRBZwUVBbPiHG1MtP2/U5DDbEQDpzvYUUA3SoKY/Gwz43NAh?=
	=?iso-8859-15?Q?6wUmvYYusReiADKzthrI6+ISThrwJnOFQ5vQ/zMh94+9Xeo4urW/8zZUJ?=
	=?iso-8859-15?Q?uBhjSGPQOX6Zuud+HagItK/bGiQwAdKVnHqQTwKB0gi9wsyURlIjgoUCU?=
	=?iso-8859-15?Q?/CVM9FaW47GlQRtVZVPnKVdm9MYOU5mlN2eC40SkTkS+/3OZcJSTK++ND?=
	=?iso-8859-15?Q?FvFLeX6+jTIVczCJb0U+F1hCrM3cVV8O9sCuvJdamTMvHrlnjFCvO0XvP?=
	=?iso-8859-15?Q?1uT4OubodM2Ct631J9IIIblpXqnitdO/ruRQoNqv9Xnoj1RqMD159ILwS?=
	=?iso-8859-15?Q?27PxSys1veqVdY7fpKU9807vUIEQqmCANiNBfZ6hhTrxPLUUPczsy7Z/s?=
	=?iso-8859-15?Q?6gOzDIfy/ePrPS0Ctdu64WthLWmRwth7M2Ujt9Z2bmqJ9SU=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0bca96a-9247-411a-776c-08d9a029c570
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 06:59:11.4572 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AG+mMbOoSslx4HqagFt0Vs+HxCeu3Sx6YEg5hjRUUYhQGzqK4VCSx/qh7jGk4UJWmCqS3CsLQJN8CaTpuQxd9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2525
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A56xMLT013073
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
Content-ID: <8AABFBEDE02A5143AA435889ACE2BDDC@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Thu, 2021-11-04 at 21:34 +0100, Martin Wilck wrote:
> On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> > multipath always requires absolute pathnames, so make sure all file
> > and
> > directory names start with a slash.=A0 Also check that the
> > directories
> > exist.=A0 Finally, some strings, like the alias, will be used in
> > paths.
> > These must not contain the slash character '/', since it is a
> > forbidden
> > character in file/directory names. This patch adds seperate
> > handlers
> > for
> > these three cases. If a config line is invalid, these handlers
> > retain
> > the existing config string, if any.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I've changed my mind on this one. The options for directories and paths
should be turned into buildtime options instead. If we do that, we
don't need this sort of checks any more, except the "noslash" part.

Regards,
Martin

>=20
> Mostly OK, see remarks below. I'm a bit wary that when we start this,
> we might need to do other checks as well. For example, as multipathd
> is
> running as root, we may want to check that the paths to files it
> writes
> to (bindings_file etc.) don't contain symlinks and have proper
> permissions... But that'd be another patch.
>=20
> Regards,
> Martin
>=20
>=20
> > ---
> > =A0libmultipath/dict.c | 88 +++++++++++++++++++++++++++++++++++++++--
> > --
> > --
> > =A01 file changed, 78 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index 1758bd26..91333068 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -5,6 +5,8 @@
> > =A0 * Copyright (c) 2005 Kiyoshi Ueda, NEC
> > =A0 */
> > =A0#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <unistd.h>
> > =A0#include <pwd.h>
> > =A0#include <string.h>
> > =A0#include "checkers.h"
> > @@ -111,6 +113,72 @@ set_str(vector strvec, void *ptr, const char
> > *file, int line_nr)
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > =A0
> > +static int
> > +set_dir(vector strvec, void *ptr, const char *file, int line_nr)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0char **str_ptr =3D (char **)ptr;
> > +=A0=A0=A0=A0=A0=A0=A0char *old_str =3D *str_ptr;
> > +=A0=A0=A0=A0=A0=A0=A0struct stat sb;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D set_value(strvec);
> > +=A0=A0=A0=A0=A0=A0=A0if (!*str_ptr) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if ((*str_ptr)[0] !=3D '/'){
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, %=
s is not an absolute
> > directory path. Ignoring", file, line_nr, *str_ptr);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D old_str;
> > +=A0=A0=A0=A0=A0=A0=A0} else {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (stat(*str_ptr, &sb) =
=3D=3D 0 &&
> > S_ISDIR(sb.st_mode))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ree(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(1, "%s line %d, %s is not an
> > existing
> > directory. Ignoring", file, line_nr, *str_ptr);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*=
str_ptr =3D old_str;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +}
> > +
> > +static int
> > +set_path(vector strvec, void *ptr, const char *file, int line_nr)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0char **str_ptr =3D (char **)ptr;
> > +=A0=A0=A0=A0=A0=A0=A0char *old_str =3D *str_ptr;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D set_value(strvec);
> > +=A0=A0=A0=A0=A0=A0=A0if (!*str_ptr) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if ((*str_ptr)[0] !=3D '/'){
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, %=
s is not an absolute path.
> > Ignoring",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, *str_ptr);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D old_str;
> > +=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +}
>=20
> Once you go down this route, you might as well test that the dirname
> of
> the path is an existing directory.
>=20
>=20
>=20
> > +
> > +static int
> > +set_str_noslash(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0char **str_ptr =3D (char **)ptr;
> > +=A0=A0=A0=A0=A0=A0=A0char *old_str =3D *str_ptr;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D set_value(strvec);
> > +=A0=A0=A0=A0=A0=A0=A0if (!*str_ptr) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if (strchr(*str_ptr, '/')) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, %=
s cannot contain a slash.
> > Ignoring",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, *str_ptr);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D old_str;
> > +=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +}
> > +
> > =A0static int
> > =A0set_yes_no(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > =A0{
> > @@ -353,13 +421,13 @@ declare_def_snprint(verbosity, print_int)
> > =A0declare_def_handler(reassign_maps, set_yes_no)
> > =A0declare_def_snprint(reassign_maps, print_yes_no)
> > =A0
> > -declare_def_handler(multipath_dir, set_str)
> > +declare_def_handler(multipath_dir, set_dir)
> > =A0declare_def_snprint(multipath_dir, print_str)
> > =A0
> > =A0static int def_partition_delim_handler(struct config *conf, vector
> > strvec,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *file, int
> > line_nr)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0int rc =3D set_str(strvec, &conf->partition_delim=
, file,
> > line_nr);
> > +=A0=A0=A0=A0=A0=A0=A0int rc =3D set_str_noslash(strvec, &conf->partiti=
on_delim,
> > file, line_nr);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (rc !=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return rc;
> > @@ -490,11 +558,11 @@ declare_hw_snprint(prio_name, print_str)
> > =A0declare_mp_handler(prio_name, set_str)
> > =A0declare_mp_snprint(prio_name, print_str)
> > =A0
> > -declare_def_handler(alias_prefix, set_str)
> > +declare_def_handler(alias_prefix, set_str_noslash)
> > =A0declare_def_snprint_defstr(alias_prefix, print_str,
> > DEFAULT_ALIAS_PREFIX)
> > -declare_ovr_handler(alias_prefix, set_str)
> > +declare_ovr_handler(alias_prefix, set_str_noslash)
> > =A0declare_ovr_snprint(alias_prefix, print_str)
> > -declare_hw_handler(alias_prefix, set_str)
> > +declare_hw_handler(alias_prefix, set_str_noslash)
> > =A0declare_hw_snprint(alias_prefix, print_str)
> > =A0
> > =A0declare_def_handler(prio_args, set_str)
> > @@ -586,13 +654,13 @@ declare_hw_snprint(user_friendly_names,
> > print_yes_no_undef)
> > =A0declare_mp_handler(user_friendly_names, set_yes_no_undef)
> > =A0declare_mp_snprint(user_friendly_names, print_yes_no_undef)
> > =A0
> > -declare_def_handler(bindings_file, set_str)
> > +declare_def_handler(bindings_file, set_path)
> > =A0declare_def_snprint(bindings_file, print_str)
> > =A0
> > -declare_def_handler(wwids_file, set_str)
> > +declare_def_handler(wwids_file, set_path)
> > =A0declare_def_snprint(wwids_file, print_str)
> > =A0
> > -declare_def_handler(prkeys_file, set_str)
> > +declare_def_handler(prkeys_file, set_path)
> > =A0declare_def_snprint(prkeys_file, print_str)
> > =A0
> > =A0declare_def_handler(retain_hwhandler, set_yes_no_undef)
> > @@ -692,7 +760,7 @@ def_config_dir_handler(struct config *conf,
> > vector strvec, const char *file,
> > =A0=A0=A0=A0=A0=A0=A0=A0/* this is only valid in the main config file *=
/
> > =A0=A0=A0=A0=A0=A0=A0=A0if (conf->processed_main_config)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > -=A0=A0=A0=A0=A0=A0=A0return set_str(strvec, &conf->config_dir, file, l=
ine_nr);
> > +=A0=A0=A0=A0=A0=A0=A0return set_path(strvec, &conf->config_dir, file, =
line_nr);
> > =A0}
>=20
> Why not set_dir() here?
>=20
> > =A0declare_def_snprint(config_dir, print_str)
> > =A0
> > @@ -1732,7 +1800,7 @@ multipath_handler(struct config *conf, vector
> > strvec, const char *file,
> > =A0declare_mp_handler(wwid, set_str)
> > =A0declare_mp_snprint(wwid, print_str)
> > =A0
> > -declare_mp_handler(alias, set_str)
> > +declare_mp_handler(alias, set_str_noslash)
> > =A0declare_mp_snprint(alias, print_str)
> > =A0
> > =A0/*
>=20


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

