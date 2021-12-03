Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 871F6C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  3 Dec 2021 08:29:22 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-9-l-qq64MU-ZjRPBaRS2bA-1; Fri, 03 Dec 2021 03:29:17 -0500
X-MC-Unique: 9-l-qq64MU-ZjRPBaRS2bA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19BC383DD20;
	Fri,  3 Dec 2021 08:29:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A7A35DF2B;
	Fri,  3 Dec 2021 08:29:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8DF2D4BB7C;
	Fri,  3 Dec 2021 08:29:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B38P88k025951 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 3 Dec 2021 03:25:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 243252166B25; Fri,  3 Dec 2021 08:25:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DEE92166B26
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 08:25:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30C41811E78
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 08:25:05 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-330-JPPPjO0xMTO-08sHfJQXJw-1; Fri, 03 Dec 2021 03:25:03 -0500
X-MC-Unique: JPPPjO0xMTO-08sHfJQXJw-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2169.outbound.protection.outlook.com [104.47.17.169])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-27-Acq2HyVWNLGmFMPg9onRbQ-1; Fri, 03 Dec 2021 09:25:01 +0100
X-MC-Unique: Acq2HyVWNLGmFMPg9onRbQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB3PR0402MB3900.eurprd04.prod.outlook.com (2603:10a6:8:e::14) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23;
	Fri, 3 Dec 2021 08:25:00 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%5]) with mapi id 15.20.4734.028;
	Fri, 3 Dec 2021 08:25:00 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] multipathd: avoid unnecessary path read-only reloads
Thread-Index: AQHX3M5WUEb/bxOK1E+H6voh4CAkfawghOiA
Date: Fri, 3 Dec 2021 08:25:00 +0000
Message-ID: <e66c48b73da8481f7f2365aa90f8a90624972255.camel@suse.com>
References: <1637275667-13436-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637275667-13436-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd180af3-2f6a-426c-b058-08d9b6366606
x-ms-traffictypediagnostic: DB3PR0402MB3900:
x-microsoft-antispam-prvs: <DB3PR0402MB3900B1CCB189BED3CC1AFE3EFC6A9@DB3PR0402MB3900.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: CkALvhayS1evKoA4ioCMPipwQvHxQjMpI6s/5zeIskNru/o3SNR91ILElJrqsBVucGKHSnhxNhWMIHOxRwvsScJgW2S/zTNBAr6YdlklHWvidoK5HEii4hoAaRDKLrf7+UR6eV2TLqaVQxRMsadvRKTUbaw28ooB2U90WW/IILZyqr+QcemfRs40PWeu2LZsrstn5HDCtCI+UIiAumk+CmUtHbKcWST6ExLpLMuA5rlt08Reis3ixZFiGfghP7nvCbiqBF1b0tzrXVFb9E+8YSTNLoAB2PT+RsS1ZMxoaX473npe0roK4zqrHtjr/MAB1/14dbwyi4bZCqhoy8xUaqeh66h4sPnS/JjXm8uXIs5nfWeEpCljspEh2xVU9DHOmjvBv/hgZq+5S6urBeUtikx3Tz/WrYsysfQB1ma7v9dUOwkf80Upo6d3quWlIl8Yk/0oTIpnqEnFhEiE1JsrujNPOFyOd5DPffLKplcjWPY8s2UB6/jU6y+wc3oF1KVF1HAUoAZ8jYg7usC1a/E4UFXbGWQ0/nTYB2gvo4ScMSxTImf72cAR83xJ7rbPGEhDNiHAyeqImE8Xg4ZRXyC3dgBtq4GT//NI4unyK44EVxQqhB+kFmzvDk7iJBySAKZYXuqzxwBc8QEZnak1imvdPCA4w0Ew5GLsY4NFXMkPMOPfKe6m9bOtglI88Sxwk3SpB66rlZXBFrUQWC26BmAWFQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(38070700005)(26005)(6486002)(110136005)(71200400001)(122000001)(36756003)(8936002)(6506007)(8676002)(2906002)(38100700002)(44832011)(86362001)(6512007)(316002)(66476007)(66556008)(66446008)(66946007)(64756008)(2616005)(5660300002)(508600001)(83380400001)(4326008)(4001150100001)(91956017)(76116006)(186003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?WPo7l34RHLFDZ/eWz1gKnceFAAw4Oi9V6YK8RNTQZ3DuUpMVJaxUVCmPa?=
	=?iso-8859-15?Q?riLljpEXxbZr/2FeM+tuz9+/+Emh/BGgPtgYoGhc0n7q5RSm+F4qBj9h3?=
	=?iso-8859-15?Q?LBFjNY3FrJx8mnfn0SfGzyYNh5RER6fskt0s7QBy4DPZCCMllbCUxiTZR?=
	=?iso-8859-15?Q?/Vwl/g9hUlOB0/lQDMlt8srEe7+30BPiqB8cXV43AhYHRxIUYYElDBTub?=
	=?iso-8859-15?Q?h0f3dqOe2K8k8E+VobnWIBz/RTh7zHbCoWcx2f9aBXuQrx0D1yAepZT2f?=
	=?iso-8859-15?Q?PqI8ZFDOnn3EbzCk8v1ChdR5Rz/TZIivLEBklu2kavhRTkf6puB2I920E?=
	=?iso-8859-15?Q?Dro4ElZT+pllXrxkEfXymRSiZl0a8Qv4RIG6u2s2+UajqhBDwHxbu3fob?=
	=?iso-8859-15?Q?q/Rv1VWfA79/+9zuDoRvjGBdnjZrNJEFtzjpLnN/qtwXekMGVwTKkj8UR?=
	=?iso-8859-15?Q?mgUPpoqRRH6CtYs3c6Vhk6qpLuNHoi68iAptCmAgUPle3ArPtwvrGVqSJ?=
	=?iso-8859-15?Q?i4gy5IexGtEwVAQP1ILmpc14YPTjQa20yVdbAI+6W2FI1/hEvxANtQBER?=
	=?iso-8859-15?Q?CVI6ITCwyGUSPrxenG7CgruAF+qaQj33BGOOB1wJelLDluaJLQ108TISP?=
	=?iso-8859-15?Q?OD++p5vwtDh/cr9a/WAtaJTB61fIbrfrA+SXmHdDFFdLcYqP4/mhpccFx?=
	=?iso-8859-15?Q?CJeNJRthM5XR94hTfn5u9mUv7bQO2FTxI+kOUs31eFNzHtWHo1JOMca83?=
	=?iso-8859-15?Q?tAo0Tm3yA1tvVU5Kso4/Ytmt/kYNmD9gswqHNPdn7wtDicp7lhRC4B5VP?=
	=?iso-8859-15?Q?+GlN6UVoKYw7hkXO0WcBaOqSg6sSJdHTJGJrVwZylTf/bDY0o3FDndy7m?=
	=?iso-8859-15?Q?/LER1kGPwLinSZo31foAhDAxk230UJlJcTzqA6PAKUCl8IwTu+MIHtKhB?=
	=?iso-8859-15?Q?6K463EljXTck5VWTrLNdRVfrgi/97/IYwFhWqnI9Nq9lkgiJftunZrowe?=
	=?iso-8859-15?Q?onCfsj3Ig06d42B46zPusRZ5rSexb/CdAHjfhmrxAn+2RMP94CQEERz02?=
	=?iso-8859-15?Q?aMn5cWaCmrot8sDAldIvp8a1lXD4kHBpRGF8d9wwLRWG3gkvkFkmoPqAn?=
	=?iso-8859-15?Q?6yOsIkOH3cZjLi5MI2bLRawWgFf2YlwXgiDysYwseGKncp7gZrtRKzcPm?=
	=?iso-8859-15?Q?4qdDxxmAhNm7bIE4zbdeCyCOQIJiRt5tOxYVIe3wav2OOc+iLk9HQLfac?=
	=?iso-8859-15?Q?qLBjIkCTzOxuDTdZmjqp669YszqF1dyseibSiwb5QwJXngF/ZaUeDca6j?=
	=?iso-8859-15?Q?ihQM13sZu3y1DzukXaThAjjpJh1mlWQ0eWqi/GeAj/rUjDGu+PapNwoUs?=
	=?iso-8859-15?Q?DLGfVULp4gPqjRM0/6KBrxwzv4KSakW7rV6bnLZCnN6gcpz68tnUTFeii?=
	=?iso-8859-15?Q?1AOcpgBJiWZ9WI8S9Xt7qHdehonrVvJNGzEWOSoO1WlYB5EShg25aiViN?=
	=?iso-8859-15?Q?GAFxwOTgvyfzXTJgChN8fq1kOXRlqFVFoULHcmdUMAL7HG/LFIAdI6ldV?=
	=?iso-8859-15?Q?tqT3yHPiyE4r9P9kzTxzR3S+FAaD9IMsWnTEJgK5GjWnOZMzYicu1OS/p?=
	=?iso-8859-15?Q?EjFhb7a/G2NnS+g4AlSeUOZz8L+tkHwKKJzmDPOjVKztH86nCnYozmvtL?=
	=?iso-8859-15?Q?v6DTitHPnydUQh3IGvOd3UGYwU22imirgp09hikyp9/8do4=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd180af3-2f6a-426c-b058-08d9b6366606
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2021 08:25:00.5349 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1GfXG6GbLsuDtvq+fMccaB8eikR7K9JxvPelTkdmpssIk8OWTiTS9cAf4gnI/NP6H4oPSd4QWnss73cvpnm2fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3900
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B38P88k025951
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: avoid unnecessary path read-only
	reloads
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
Content-ID: <520341EE426F294DADEBBDDF895E1BB8@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-11-18 at 16:47 -0600, Benjamin Marzinski wrote:
> A mulitpath device can only be reloaded read/write when all paths are
> read/write. Also, whenever a read-only device is rescanned, the scsi
> subsystem will first unconditionally issue a uevent with DISK_RO=3D0
> before checking the read-only status, and if it the device is still
> read-only, issuing another uevent with DISK_RO=3D1. These uevents cause
> pointless reloads when read-only paths are rescanned. To avoid this,
> check to see if all paths are read/write before changing a multipath
> device from read-only to read/write.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/libmultipath.version |=A0 5 +++++
> =A0libmultipath/sysfs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 22 +++++=
+++++++++++++++++
> =A0libmultipath/sysfs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 31
> ++++++++++++++++++++++++++++++-
> =A04 files changed, 58 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index 58a7d1be..ab4c7e30 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -296,3 +296,8 @@ global:
> =A0local:
> =A0=A0=A0=A0=A0=A0=A0=A0*;
> =A0};
> +
> +LIBMULTIPATH_11.1.0 {
> +global:
> +=A0=A0=A0=A0=A0=A0=A0sysfs_get_ro;
> +} LIBMULTIPATH_11.0.0;
> diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
> index 9ff145f2..24c12b6a 100644
> --- a/libmultipath/sysfs.c
> +++ b/libmultipath/sysfs.c
> @@ -236,6 +236,28 @@ sysfs_get_size (struct path *pp, unsigned long
> long * size)
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0
> +int
> +sysfs_get_ro (struct path *pp)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int ro;
> +=A0=A0=A0=A0=A0=A0=A0char buff[3]; /* Either "0\n\0" or "1\n\0" */
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!pp->udev)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (sysfs_attr_get_value(pp->udev, "ro", buff, size=
of(buff))
> <=3D 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: Cannot read=
 ro attribute in sysfs",
> pp->dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0if (sscanf(buff, "%d\n", &ro) !=3D 1 || ro < 0 || r=
o > 1) {

This is ok, but for self-evidently correct code in multipath-tools,
it'd be better to read just 2 bytes and set buff[2] =3D '\0' explicitly.
I haven't checked, but coverity might stumble on this.

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: Cannot pars=
e ro attribute", pp->dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0return ro;
> +}
> +

Does this function need to be in libmultipath? We could avoid extending
the ABI  by adding it as a static function to multipathd. After all,
it's just sysfs_attr_get_value() + sscanf().


> =A0int sysfs_check_holders(char * check_devt, char * new_devt)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int major, new_minor, table_minor;
> diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
> index 72b39ab2..c948c467 100644
> --- a/libmultipath/sysfs.h
> +++ b/libmultipath/sysfs.h
> @@ -13,6 +13,7 @@ ssize_t sysfs_attr_get_value(struct udev_device
> *dev, const char *attr_name,
> =A0ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char
> *attr_name,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 unsigned char * value, size_t
> value_len);
> =A0int sysfs_get_size (struct path *pp, unsigned long long * size);
> +int sysfs_get_ro(struct path *pp);
> =A0int sysfs_check_holders(char * check_devt, char * new_devt);
> =A0bool sysfs_is_multipathed(struct path *pp, bool set_wwid);
> =A0#endif
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 08a8a592..a1665494 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1440,6 +1440,35 @@ finish_path_init(struct path *pp, struct
> vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0return -1;
> =A0}
> =A0
> +static bool
> +needs_ro_update(struct multipath *mpp, int ro)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> +=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> +=A0=A0=A0=A0=A0=A0=A0unsigned int i, j;
> +=A0=A0=A0=A0=A0=A0=A0struct dm_info *dmi =3D NULL;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!mpp || ro < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> +=A0=A0=A0=A0=A0=A0=A0dm_get_info(mpp->alias, &dmi);

I'm still not convinced that we need this call, in particular as you
have added a call to dm_get_info() in the uev_update_map() call, and it
was called in the dmevent handler, too.

In general, I think that multipath-tools could rely more on the kernel
to send events for status changes than it currently does.=20
This is particularly true for dm properties, where we have not only one
event mechanism but two (uevent + dmevent).

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

