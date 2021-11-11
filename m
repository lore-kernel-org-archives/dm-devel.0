Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013F9C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:53:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 909F36124C
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:53:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 909F36124C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-I3mAPuflMaS41gT7Cfl2Dg-1; Thu, 11 Nov 2021 06:52:57 -0500
X-MC-Unique: I3mAPuflMaS41gT7Cfl2Dg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E67508799E0;
	Thu, 11 Nov 2021 11:52:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE0175D6D7;
	Thu, 11 Nov 2021 11:52:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 06AD11800FDD;
	Thu, 11 Nov 2021 11:52:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABBqo8E011029 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 06:52:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0D091404727C; Thu, 11 Nov 2021 11:52:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 085AC4047279
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:52:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0A781066558
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:52:49 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-564-Okjo6S_lPVuXiF7UQJ3fqw-1;
	Thu, 11 Nov 2021 06:52:48 -0500
X-MC-Unique: Okjo6S_lPVuXiF7UQJ3fqw-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-19-mFlLkwTjPzuiBRJSQqamxQ-1; Thu, 11 Nov 2021 12:52:46 +0100
X-MC-Unique: mFlLkwTjPzuiBRJSQqamxQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4217.eurprd04.prod.outlook.com (2603:10a6:5:19::31) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Thu, 11 Nov 2021 11:52:44 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 11:52:44 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 8/9] libmultipath: split set_int to enable reuse
Thread-Index: AQHX1phlWCUF1IpWQUyKVE8Ed8JNaKv+OBSA
Date: Thu, 11 Nov 2021 11:52:44 +0000
Message-ID: <d5be9e4c085f585a781d403367071bd3868a71a5.camel@suse.com>
References: <1636592780-20391-1-git-send-email-bmarzins@redhat.com>
	<1636592780-20391-9-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636592780-20391-9-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2294304-b1ad-455c-8a82-08d9a509c5f6
x-ms-traffictypediagnostic: DB7PR04MB4217:
x-microsoft-antispam-prvs: <DB7PR04MB4217AA454BFA706DD768F584FC949@DB7PR04MB4217.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: djYZwuJ7TW+y8haDY3wn1LGVim2IPiiNXHjBFMk/0j6NoBtB61UnYDIHgGhDbOBvFKf57Vy6aqohFHxZeP2si8hyzL6AKrI4GyFNML6vUZJWClNzYCugSZ3d7YOZXkvhmV+6osdAoQh9jlS17G5l24DGg6N/clLDK4Trt9Oofi37y1Fi6fmxcGyhAjGeZwidOI0uKlwIJ2fFBtMRU2tG8DZu44RmkIJY29wZHTyLPTBe8JTMXlGByJq+b06TVTSK8PN/AJnA74zZdKSk0hyNJBeXaQhIxgQZnpVxWoaiXMk3jt5s077ZkHjMNELsCW15oL2XbIpQRabv72CzqTxUXiksAQi0hSrCjIzGdeof8meyPsrVK0sq5J9yMjerf2INChKS9kdQyaO2IZujp50F25UI9FV+tj0Pbg7MRQ+PR2WJSKKFpy/S55VOewP/v9IjKDuCdMY8m3OQga1YCAtkCfkbhNoaALv3qv/3+0Ff4fU1N372M6OxIXGjBI5XxVZJD7slIo+amgLGyI3ovZkfDyOrisrpJTPO5nXDNmUmN8CYeKrImkn6EejLQppqJhAWRgso/MYexNwib4oAsaDJdsBcR1uLoGtgiCp1nBJyDcHqIDE/eDoDZ4zvO5/x4fvni9js00AuDbNBV3C+s/DVtFCHvTov9bn1MG2zs9p7qLF6zNM1XmXoDLvmfMZbeJIMVrHjaMNRhxyVEldNd1KXGA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(83380400001)(6512007)(6506007)(8676002)(86362001)(2616005)(508600001)(5660300002)(36756003)(38100700002)(44832011)(122000001)(26005)(4001150100001)(71200400001)(186003)(66476007)(76116006)(91956017)(38070700005)(64756008)(4326008)(2906002)(66446008)(6486002)(316002)(110136005)(66556008)(66946007)(8936002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?IstEoJ6ZdXFbhlQHKP20n1OLrAPt1/6xXGUb4T/iXEz173zrfFesGqdTZ?=
	=?iso-8859-15?Q?LJiU1qxVMY+v/2wMRcMb7MTb1/ERt+F9mdtasEkEcpQnUueCryD3USagR?=
	=?iso-8859-15?Q?L28gqxN0cvA9mDUfRHnowr8SFoRYjhoyR5ZIkJyc/4/QpNVqG3AD6ptIP?=
	=?iso-8859-15?Q?ixQzbjUJ4/Qg0Xo9p1IK+iBStfQAGG6AikD1kAKQPMkaK5HPHVvBKqx2q?=
	=?iso-8859-15?Q?bCVFYSevYKxv3WESxsJIspKh7bAJDLB9yFbuyBjCQGhIZQa55WhjlZsyc?=
	=?iso-8859-15?Q?yfbEZUnO1SHCrshEz7rriV7vHP2lCOb6TF6kpy7LrqfW6+oVSl/L57h0/?=
	=?iso-8859-15?Q?VhiAapBbTgsfTex1PJgkLNzs8s1rxvyjYR+qLLGMovYHi7G6YindjqUa2?=
	=?iso-8859-15?Q?XXnSHqOlQPulrH8GOMgM7kN1qJIOw+B8x2sZn509pwVj7gUFLFUc5udvn?=
	=?iso-8859-15?Q?LV1vVG8nUn6PKw4pp1+iaCqHqCYqrLXm9JR7Iemkvb5JC3dLvVkDII9pU?=
	=?iso-8859-15?Q?xhE72VKbt7GObYa+Lc4mrMzLyUhv5LkxgnflT5SZWKMBtdoKgV8JdNd8N?=
	=?iso-8859-15?Q?Qg/Uv43rlOI0qHGnS2KDfQArKJT/hSTV2Xc9XDME04PkV+/Y4hlFKAe1h?=
	=?iso-8859-15?Q?xIm9iyTFm1zq0UtP9G4L0WhodO2HAnzLRUEPuA6hZ+pTrNUwEYgUnoVfG?=
	=?iso-8859-15?Q?6EV5UeTrPu0tTWafNidf8QknailuBaywslQHfSs7k1o4FNkeo7AaKYuMT?=
	=?iso-8859-15?Q?FXN/YP2M2K2xAOqoC3JA7Lnb6a5EYrzwmB6tJ2K9OYHdR6uwafn0wMZAs?=
	=?iso-8859-15?Q?Hl1HiXZZluw8frJWPq3ft3ubqxqmTnWFLBVRaewujO1YB23MkQdus6/Dj?=
	=?iso-8859-15?Q?rMzNpUITApmZt7dIWgTS0zh6MyD8IbQcKVX6J1QDmC4a+SMCxivZYbPnG?=
	=?iso-8859-15?Q?ZatWHYEIHbTUDdOS2FIK4CLARsZeTwf93/5Eui2eCTbwLMckb03a7p1yz?=
	=?iso-8859-15?Q?TRbsXr/X9r3kDrLhNGmFGe9XRlzCVMtNCA3LZiEiBQoL12aBJSv50CNiD?=
	=?iso-8859-15?Q?yUHv0spLpFFmC+laRR9KPZd5h1AZzwj6ZJdyOoqbth7DsQfEgfgyKWJXX?=
	=?iso-8859-15?Q?Md75mAUOshiePGWkhVYM6DBCeeNtKC0d3SHYbYyj/q/S2Elb7luExwRiF?=
	=?iso-8859-15?Q?6m0qEW18iXKhiEdeUs5TdG2zYKcCdialuYQprYZ6Jik2+vgy+smZdtXEH?=
	=?iso-8859-15?Q?eZ7eVuGIJ5SC7rVpt3ZxRWiSrYQI0hD+9L6Kuvz4nRAWx6KqrW35na/gz?=
	=?iso-8859-15?Q?N50WS9KJJmV9rux9rkjtNz81ZcwLbyxsjWBf/JuigXkVGtakQZHjsyVuw?=
	=?iso-8859-15?Q?gcdUvk9IL/oe2/Oe+nmVB6Yg/1uq+zWSW38rGulR6D4Qw56WqocWfy7p3?=
	=?iso-8859-15?Q?5BShHD+IbsZ5CnkUYEMATMlOfZCgdUNLouaSpBdIkqBgwcb1D0CPiQ+FN?=
	=?iso-8859-15?Q?8AN5NZ3UgzKsF2k8rKbA2kN3BxqeopxVRwfe8lobK56rG0/DJyznkn5T4?=
	=?iso-8859-15?Q?cMYskcplQ6wlC5Buu8xN1NmRa3QrW7kTN3QxOHRLVoUeuytiKBvMvErfp?=
	=?iso-8859-15?Q?vrTMeX26mU73RxHZkY5DcEPfWbzIfuER/l4d6cpssd1QsoJmdEQjsHEXU?=
	=?iso-8859-15?Q?r/SENhfvCY03vkuhhH8W23/7blhliTtVkdyhWeZ38VTyHvw=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2294304-b1ad-455c-8a82-08d9a509c5f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 11:52:44.2814 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jOSKjqu9mpAB3+SEVNHs1Ryf27Y9JFDG0n/Sn2vj518PnS4GPbW8WsW5SUFa5doCaAt7IyCE4dYR3rLgT3qagA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4217
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ABBqo8E011029
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 8/9] libmultipath: split set_int to enable
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <0926796A3D66D345886C8140C3572C8D@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-11-10 at 19:06 -0600, Benjamin Marzinski wrote:
> Split the code that does the actual value parsing out of set_int(),
> into
> a helper function, do_set_int(), so that it can be used by other
> handlers. These functions no longer set the config value at all, when
> they have invalid input.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I have to apologize.=A0

My review on the v1 of this patch suggested that a value like "0   "
was possible in the setter functions in dict.c. I double-checked the
parser code, and that was wrong. The parser already strips trailing
whitespace. We actually have a test for that in tests/parser.c
(test04).

So, I have to say I actually prefer the v1, which was leaner and worked
just as well as this one. My concern was that you didn't set any value
(relying on the previously-set default), but you've convinced me that
that was ok.

So, if you don't mind, I'll put my "Reviewed-by" on the v1 of this
patch.

Regards,
Martin

> ---
> =A0libmultipath/dict.c | 92 ++++++++++++++++++++++++++-----------------
> --
> =A01 file changed, 54 insertions(+), 38 deletions(-)
>=20
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 1b4e1106..3212d14c 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
>=20
> ...
> =A0int
> @@ -1230,6 +1238,7 @@ declare_mp_snprint(pgfailback,
> print_pgfailback)
> =A0static int
> =A0no_path_retry_helper(vector strvec, void *ptr, const char *file, int
> line_nr)
> =A0{
> +=A0=A0=A0=A0=A0=A0=A0int rc =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0
> @@ -1237,15 +1246,18 @@ no_path_retry_helper(vector strvec, void
> *ptr, const char *file, int line_nr)
> =A0=A0=A0=A0=A0=A0=A0=A0if (!buff)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "fail") || !strcmp(buff, "0"))
> +=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "fail"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NO_PATH_RETR=
Y_FAIL;
> =A0=A0=A0=A0=A0=A0=A0=A0else if (!strcmp(buff, "queue"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NO_PATH_RETR=
Y_QUEUE;
> -=A0=A0=A0=A0=A0=A0=A0else if ((*int_ptr =3D atoi(buff)) < 1)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NO_PATH_RETRY_=
UNDEF;
> +=A0=A0=A0=A0=A0=A0=A0else {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D do_set_int(strvec, p=
tr, 0, INT_MAX, file,
> line_nr, buff);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (rc =3D=3D 0 && *int_ptr=
 =3D=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*in=
t_ptr =3D NO_PATH_RETRY_FAIL;
> +=A0=A0=A0=A0=A0=A0=A0}
> =A0




> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> -=A0=A0=A0=A0=A0=A0=A0return 0;
> +=A0=A0=A0=A0=A0=A0=A0return rc;
> =A0}
> =A0
> =A0int
> @@ -1387,6 +1399,7 @@ snprint_mp_reservation_key (struct config
> *conf, struct strbuf *buff,
> =A0static int
> =A0set_off_int_undef(vector strvec, void *ptr, const char *file, int
> line_nr)
> =A0{
> +=A0=A0=A0=A0=A0=A0=A0int rc =3D0;
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> =A0
> @@ -1394,13 +1407,16 @@ set_off_int_undef(vector strvec, void *ptr,
> const char *file, int line_nr)
> =A0=A0=A0=A0=A0=A0=A0=A0if (!buff)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "no") || !strcmp(buff, "0"))
> +=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "no"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NU_NO;
> -=A0=A0=A0=A0=A0=A0=A0else if ((*int_ptr =3D atoi(buff)) < 1)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NU_UNDEF;
> +=A0=A0=A0=A0=A0=A0=A0else {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D do_set_int(strvec, p=
tr, 0, INT_MAX, file,
> line_nr, buff);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (rc =3D=3D 0 && *int_ptr=
 =3D=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*in=
t_ptr =3D NU_NO;
> +=A0=A0=A0=A0=A0=A0=A0}
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> -=A0=A0=A0=A0=A0=A0=A0return 0;
> +=A0=A0=A0=A0=A0=A0=A0return rc;
> =A0}
> =A0
> =A0int


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

