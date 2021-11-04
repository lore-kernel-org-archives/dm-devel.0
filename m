Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D036EC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:54:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 61D0861106
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:54:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 61D0861106
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-PzqZJeIjOdeGjV_IKUMFPQ-1; Thu, 04 Nov 2021 16:54:23 -0400
X-MC-Unique: PzqZJeIjOdeGjV_IKUMFPQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC51F800053;
	Thu,  4 Nov 2021 20:54:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 64F1D5D9D3;
	Thu,  4 Nov 2021 20:54:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D5B291806D03;
	Thu,  4 Nov 2021 20:54:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4KsHns024546 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 16:54:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E9E12400F3E6; Thu,  4 Nov 2021 20:54:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E4E00400F3C6
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:54:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8F75899EC3
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:54:16 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-238-ROjm5P_mNtmZKSKfmnB7Zw-1;
	Thu, 04 Nov 2021 16:54:15 -0400
X-MC-Unique: ROjm5P_mNtmZKSKfmnB7Zw-1
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur03lp2055.outbound.protection.outlook.com [104.47.9.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-13-ecwQo3O-O5C-DIytvhP_yA-1; Thu, 04 Nov 2021 21:54:13 +0100
X-MC-Unique: ecwQo3O-O5C-DIytvhP_yA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5227.eurprd04.prod.outlook.com (2603:10a6:10:17::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Thu, 4 Nov 2021 20:54:12 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 20:54:12 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 7/8] libmultipath: split set_int to enable reuse
Thread-Index: AQHXuu1mU4ueBiHTrUieST8shQsUFqv0BmGA
Date: Thu, 4 Nov 2021 20:54:11 +0000
Message-ID: <da5d538c2d1493e31d8604c9af183a1b5a531a45.camel@suse.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-8-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633550663-25571-8-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c234a8d7-0a67-4f73-f259-08d99fd54142
x-ms-traffictypediagnostic: DB7PR04MB5227:
x-microsoft-antispam-prvs: <DB7PR04MB522774E9B0F6AC4B46D5010DFC8D9@DB7PR04MB5227.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:159
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 1RjSytaza6qHwpOBaD60lgKSTnGgN9crIP9R6Wme5+Qe3os1eN6gNZV/XyCJLYPyYY7Bv4oq4PWTD5nnbuwzPn1z9fLNYxGllAAVMbgYdfn+BH7QPLyyy260GLcjipHBnQcCWXqbTYIQaNoW0jOUy47n5/iNTcBj2GiCukAjoNNUmqpzp1VwrQDOpVb2I2Kn5C0Lkiud7L1AmxTsk3eptbfTMbSC1RQCO/8ZR2HlCNeMTbPdV8IKlTXCgNQImpBtuan3maVlqTxNGjqnSaq3rjxF+CjALDt4M6ymAOWfhvrbwegtgg3jPIdkfaQWRPh6h68MFAt8PwYQiq2StoCUyGJk/KzRGBOnrpUj1byLaOxIyo8Ge4iL4DtjjQ25zX6JDT7ZlFII/xbOA3/PiZVT/ijv46WJbNzkDLxbBAnx3WN0acEOAx+UmIL307xYNwkelZVTrWEQ8FBsyKeN8vcI8alI5NW5fgd/SBjVye+f7dO5oRuFSJawyDCky58qFwffFhq/tdIvgCn6hCI+vTTgsb5N4gty4MlXgry1SUsZzOtStKKhDVnQtk1ICOxj1aiUOMuSVdXk/NFYcrHv78cm8fEbPk6iORPjYEEu+N3zmaR0Ui8pi58nPov72R7pj2KXws/wcWrVvwbRt/UyJG8OeshFUwXcLOT5/bCCtGvATrvLYfhR2zTjpKeW6yvZ7cnBwRWTlb8Z1X2DwUHWvfr7nA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(316002)(71200400001)(6486002)(66946007)(86362001)(8676002)(5660300002)(91956017)(38100700002)(6506007)(2906002)(186003)(2616005)(38070700005)(110136005)(508600001)(4326008)(122000001)(76116006)(64756008)(83380400001)(66476007)(66556008)(6512007)(44832011)(66446008)(26005)(8936002)(36756003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?wjx8ESHqgpTD7HgC/C4tQesW+Z7IsWbV1+G757MNsBRblb84VJnP59ujb?=
	=?iso-8859-15?Q?D7VRBQMwn6w1eqQL4KN1MIZAKaTpgTtmh+W2L+pdygLbHahkDiSX/e2Bt?=
	=?iso-8859-15?Q?HkNlmKoBSdRMMudS0GWhx9m8eYtBMCoMh/kpgMv4gQdPJrGqQTVYTtSyZ?=
	=?iso-8859-15?Q?pOJ3jDiO4CNx/pr1nwEFLjjorqX8Hnl7hEI9qDYSCWHGF3a9EK2mkElDl?=
	=?iso-8859-15?Q?+Rl74pRfeNwsAca3c7iXSfcJuWpfyhvughIV2WS2DluYLhwJMqg4apomg?=
	=?iso-8859-15?Q?73Pjs90cg00uETZm1Vz2tAO/J2xt+/CmHrsLhOvXAUsVAzZtM3gg1J0/I?=
	=?iso-8859-15?Q?MUyscOFhLccS8Bkb+kiIx0cJH7dnN+w6vHv3qaDRLbse8PHL7XPgebtJx?=
	=?iso-8859-15?Q?GH+L0KbubWYRrDHyq+xR8N3CrlNFX5B73Zl4Drgp+vMTZzPt7u9yb8GPh?=
	=?iso-8859-15?Q?/zLo0FXmBKxkOLfZx50E4tijitydk/cRvQko+XvuOHlpP9t49iWEzQXqC?=
	=?iso-8859-15?Q?nZHYXNqxZYjp+pWOaJwOJJkmIICpmoFWV0V7o2mjPMpmzj+LmJApLxxh6?=
	=?iso-8859-15?Q?DSJNWoEPgsVN9jgvIJQROfAn9ti1Xh8WnJc7+fHdTmoPKyXUcglvGSUXb?=
	=?iso-8859-15?Q?iIJ0TKZW3YnM4SCXQpzaIZRu9eedmOPIgJJQUx6lN6D3cmZ13euDOCkyU?=
	=?iso-8859-15?Q?0yqusgqsP7CszFGZyxW6vrjiRk4wB8RmHnag2HNoGaq6R8bRLpbRCokMY?=
	=?iso-8859-15?Q?DBY08c/ZRO6MdxS+9ru47zrJ6nUJCMS8yZW2VkrZ+Er95lUvTw9j+v3Mm?=
	=?iso-8859-15?Q?exmOtk6leWHSjYlNc5562XAuF6+ysiz/L7ClEk4+Fivn48QN6PsJLFJmE?=
	=?iso-8859-15?Q?3e/2Nu4VEqS8EziNGsXqF0Gpj9887cQJ+GP4UcYU4Ksmcdbfz483CUUHh?=
	=?iso-8859-15?Q?cpCp+6UgGs2JTn4r5Y1ADUdOxOGHcwTBH0d4quFaeLBBHQQzv/dKlKc6T?=
	=?iso-8859-15?Q?JBx3AHl0V/o9BPl3iCmRXnv/9WgwPtDUIhAsFEMMsYCJhx7gPBtNoNRdc?=
	=?iso-8859-15?Q?e0UQspXOPFc3JF6ib9nNL4h7qa9xjO3ERu0w7T6i7oFo/IgXHUBeYlkyb?=
	=?iso-8859-15?Q?HHwAACubj3b8YQnBUXcwW0HcOBBLImHMSDmd7e6Kyy9lFaBHFWPqlMG2D?=
	=?iso-8859-15?Q?7fqmfRbna8AllQuAMUVNpxDKdY+fX3Qw1izY+Nxura2LE6+Dmg9CTULT8?=
	=?iso-8859-15?Q?sCIsHkH+FSVL8y9pqmJkT087CKuakDLYqLZnYZSFvQb2ibbiDGgX5K7Yc?=
	=?iso-8859-15?Q?qu97iAioHVKnTpHJ+gMw7yrx6Nd1AIviem4V5wglmyS7Qn4odJOvxRCMC?=
	=?iso-8859-15?Q?fbVs0UnZsNBK8U2WM+LofQ2rfIY30OK5RtO0TU9w2alYvmcJ1LQhiFf0Y?=
	=?iso-8859-15?Q?Xz8wweFYZoT5RXUQ/LlA9cXWSJUg+aC0e2fOcypND4cl3tUhgO5czdAV+?=
	=?iso-8859-15?Q?4XXMrb1jmWjZqcbrfikW1rD0nn2AZ6o2gai6NFkhO66hXUxQfbiJw4vAb?=
	=?iso-8859-15?Q?EzaoTxjuXriYaq2mQKkAhQGuBhQLbUQ3T9ihye/OOSGop++EWOtgy+AWC?=
	=?iso-8859-15?Q?IXei/wmQxT0PUvTYMEEC5VLh4zp/zdAqRu3j3iKIxBoAb4IljqkcS+KHh?=
	=?iso-8859-15?Q?lERLLcNOiHMncaOY2Uqkwq/tWgazNzdeNYjIv9TCadEdGqw=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c234a8d7-0a67-4f73-f259-08d99fd54142
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 20:54:12.0243 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P8JUqmLz5FMP0wLMDTbRKQPge2RuZizd4IbLGxooPyGRD5hj0UO/zqHgFOOcU/PwZt1dTfajbx5OYD+Ge49RxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5227
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4KsHns024546
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
Content-ID: <51695B871A666F4E97C94419306922B7@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> Split the code that does the actual value parsing out of set_int(),
> into
> a helper function, do_set_int(), so that it can be used by other
> handlers. These functions no longer set the config value at all, when
> they have invalid input.

Not sure about that, do_set_int() sets the value to the cap (see below)

>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/dict.c | 82 +++++++++++++++++++++++++------------------
> --
> =A01 file changed, 46 insertions(+), 36 deletions(-)
>=20
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 91333068..e79fcdd7 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -31,17 +31,12 @@
> =A0#include "strbuf.h"
> =A0
> =A0static int
> -set_int(vector strvec, void *ptr, int min, int max, const char
> *file,
> -=A0=A0=A0=A0=A0=A0=A0int line_nr)
> +do_set_int(vector strvec, void *ptr, int min, int max, const char
> *file,
> +=A0=A0=A0=A0=A0=A0=A0int line_nr, char *buff)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> -=A0=A0=A0=A0=A0=A0=A0char *buff, *eptr;
> +=A0=A0=A0=A0=A0=A0=A0char *eptr;
> =A0=A0=A0=A0=A0=A0=A0=A0long res;
> -=A0=A0=A0=A0=A0=A0=A0int rc;
> -
> -=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> -=A0=A0=A0=A0=A0=A0=A0if (!buff)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0res =3D strtol(buff, &eptr, 10);
> =A0=A0=A0=A0=A0=A0=A0=A0if (eptr > buff)
> @@ -50,17 +45,30 @@ set_int(vector strvec, void *ptr, int min, int
> max, const char *file,
> =A0=A0=A0=A0=A0=A0=A0=A0if (*buff =3D=3D '\0' || *eptr !=3D '\0') {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, i=
nvalid value for %s:
> \"%s\"",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, (char*)VECTOR_SLOT(strvec, 0),
> buff);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D 1;
> -=A0=A0=A0=A0=A0=A0=A0} else {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (res > max || res < min)=
 {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0res=
 =3D (res > max) ? max : min;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(1, "%s line %d, value for %s too %s,
> capping at %ld",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0if (res > max || res < min) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0res =3D (res > max) ? max :=
 min;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, val=
ue for %s too %s, capping
> at %ld",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, (char*)VECTOR_SLOT(strvec, 0),
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(re=
s =3D=3D max)? "large" : "small", res);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D 0;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D res;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(res =3D=3D max)? "large" :=
 "small", res);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D res;
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> +}
> +
> +static int
> +set_int(vector strvec, void *ptr, int min, int max, const char
> *file,
> +=A0=A0=A0=A0=A0=A0=A0int line_nr)
> +{
> +=A0=A0=A0=A0=A0=A0=A0char *buff;
> +=A0=A0=A0=A0=A0=A0=A0int rc;
> +
> +=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> +=A0=A0=A0=A0=A0=A0=A0if (!buff)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +
> +=A0=A0=A0=A0=A0=A0=A0rc =3D do_set_int(strvec, ptr, min, max, file, line=
_nr, buff);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> =A0=A0=A0=A0=A0=A0=A0=A0return rc;
> @@ -918,6 +926,7 @@ declare_mp_attr_snprint(gid, print_gid)
> =A0static int
> =A0set_undef_off_zero(vector strvec, void *ptr, const char *file, int
> line_nr)
> =A0{
> +=A0=A0=A0=A0=A0=A0=A0int rc =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> =A0
> @@ -927,10 +936,10 @@ set_undef_off_zero(vector strvec, void *ptr,
> const char *file, int line_nr)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (strcmp(buff, "off") =3D=3D 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D UOZ_OFF;
> -=A0=A0=A0=A0=A0=A0=A0else if (sscanf(buff, "%d", int_ptr) !=3D 1 ||
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *int_ptr < UOZ_ZERO)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D UOZ_UNDEF;
> -=A0=A0=A0=A0=A0=A0=A0else if (*int_ptr =3D=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D do_set_int(strvec, i=
nt_ptr, 0, INT_MAX, file,
> line_nr,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0buff);
> +=A0=A0=A0=A0=A0=A0=A0if (rc =3D=3D 0 && *int_ptr =3D=3D 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D UOZ_ZERO;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> @@ -1082,14 +1091,12 @@ max_fds_handler(struct config *conf, vector
> strvec, const char *file,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Assume safe limit */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0max_fds =3D 4096;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0if (strlen(buff) =3D=3D 3 &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !strcmp(buff, "max"))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->max_fds =3D max_fds;
> -=A0=A0=A0=A0=A0=A0=A0else
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->max_fds =3D atoi(buff=
);
> -
> -=A0=A0=A0=A0=A0=A0=A0if (conf->max_fds > max_fds)
> +=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "max")) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->max_fds =3D max_fds=
;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D do_set_int(strvec, &c=
onf->max_fds, 0, max_fds,
> file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 line_nr, buff);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> =A0
> @@ -1158,6 +1165,7 @@ declare_mp_snprint(rr_weight, print_rr_weight)
> =A0static int
> =A0set_pgfailback(vector strvec, void *ptr, const char *file, int
> line_nr)
> =A0{
> +=A0=A0=A0=A0=A0=A0=A0int rc =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0
> @@ -1172,11 +1180,11 @@ set_pgfailback(vector strvec, void *ptr,
> const char *file, int line_nr)
> =A0=A0=A0=A0=A0=A0=A0=A0else if (strlen(buff) =3D=3D 10 && !strcmp(buff, =
"followover"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D -FAILBACK_FO=
LLOWOVER;
> =A0=A0=A0=A0=A0=A0=A0=A0else
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D atoi(buff);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D do_set_int(strvec, p=
tr, 0, INT_MAX, file,
> line_nr, buff);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> =A0
> -=A0=A0=A0=A0=A0=A0=A0return 0;
> +=A0=A0=A0=A0=A0=A0=A0return rc;
> =A0}
> =A0
> =A0int
> @@ -1208,6 +1216,7 @@ declare_mp_snprint(pgfailback,
> print_pgfailback)
> =A0static int
> =A0no_path_retry_helper(vector strvec, void *ptr, const char *file, int
> line_nr)
> =A0{
> +=A0=A0=A0=A0=A0=A0=A0int rc =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0
> @@ -1219,11 +1228,11 @@ no_path_retry_helper(vector strvec, void
> *ptr, const char *file, int line_nr)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NO_PATH_RETR=
Y_FAIL;
> =A0=A0=A0=A0=A0=A0=A0=A0else if (!strcmp(buff, "queue"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NO_PATH_RETR=
Y_QUEUE;
> -=A0=A0=A0=A0=A0=A0=A0else if ((*int_ptr =3D atoi(buff)) < 1)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NO_PATH_RETRY_=
UNDEF;
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D do_set_int(strvec, p=
tr, 1, INT_MAX, file,
> line_nr, buff);

This will set no_path_retry to 1 if the input was something like "0  "
or a negative value. The previous code would have set
NO_PATH_RETRY_UNDEF (=3D=3D 0). That's a semantic change, as the code
checks for NO_PATH_RETRY_UNDEF in various places. Was this intentional?


> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> -=A0=A0=A0=A0=A0=A0=A0return 0;
> +=A0=A0=A0=A0=A0=A0=A0return rc;
> =A0}
> =A0
> =A0int
> @@ -1365,6 +1374,7 @@ snprint_mp_reservation_key (struct config
> *conf, struct strbuf *buff,
> =A0static int
> =A0set_off_int_undef(vector strvec, void *ptr, const char *file, int
> line_nr)
> =A0{
> +=A0=A0=A0=A0=A0=A0=A0int rc =3D0;
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0
> @@ -1374,11 +1384,11 @@ set_off_int_undef(vector strvec, void *ptr,
> const char *file, int line_nr)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "no") || !strcmp(buff, "0"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NU_NO;
> -=A0=A0=A0=A0=A0=A0=A0else if ((*int_ptr =3D atoi(buff)) < 1)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NU_UNDEF;
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D do_set_int(strvec, p=
tr, 1, INT_MAX, file,
> line_nr, buff);

Likewise, you'd set 1 here for negative input or "0  ", while
previously the result would be NU_UNDEF =3D=3D 0.=20

Negative values are of course garbage and I'm unsure if trailing spaces
can occur at this point in the code, but do_set_int() handles them.

Regards,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

