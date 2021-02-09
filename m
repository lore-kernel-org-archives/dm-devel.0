Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C3DDC433DB
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 22:20:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E4A3864DDF
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 22:20:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4A3864DDF
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-eYwKe0tDNHCoFLAQVsTz9w-1; Tue, 09 Feb 2021 17:20:12 -0500
X-MC-Unique: eYwKe0tDNHCoFLAQVsTz9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FD73107ACF4;
	Tue,  9 Feb 2021 22:20:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 48A3B5D745;
	Tue,  9 Feb 2021 22:20:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 67BAF4E58D;
	Tue,  9 Feb 2021 22:20:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 119MJwB3026382 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 17:19:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2C074A9F15; Tue,  9 Feb 2021 22:19:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 249FCA9F19
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 22:19:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E053A800B2A
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 22:19:55 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-479-mk9rCZa5N3uVSyFvAIZh-g-1;
	Tue, 09 Feb 2021 17:19:51 -0500
X-MC-Unique: mk9rCZa5N3uVSyFvAIZh-g-1
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur02lp2055.outbound.protection.outlook.com [104.47.5.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-32-AjMDInVAPO-gsRKDxiTAsg-1; Tue, 09 Feb 2021 23:19:48 +0100
X-MC-Unique: AjMDInVAPO-gsRKDxiTAsg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB3PR0402MB3898.eurprd04.prod.outlook.com (2603:10a6:8:3::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25;
	Tue, 9 Feb 2021 22:19:46 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3825.030;
	Tue, 9 Feb 2021 22:19:46 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/2] multipathd: add recheck_wwid_time option to verify
	the path wwid
Thread-Index: AQHW/qMuQs93dFGIW0CwQCKCag2SdapQZg8A
Date: Tue, 9 Feb 2021 22:19:45 +0000
Message-ID: <e8131e361f84ef1caee140183a26c9f60b172f24.camel@suse.com>
References: <1612847967-8813-1-git-send-email-bmarzins@redhat.com>
	<1612847967-8813-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1612847967-8813-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [84.58.19.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31dd242d-2453-4aab-009a-08d8cd48cecb
x-ms-traffictypediagnostic: DB3PR0402MB3898:
x-microsoft-antispam-prvs: <DB3PR0402MB3898DBA8774DCA991EF75B8BFC8E9@DB3PR0402MB3898.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:155
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: TR+uccBQviTW/QtFxiJQsNj1awDxQGsUau0FF2aF7eqKTFJYSsrXCMCQaB9LtBGsagZro5O/nAuY2CMkpABCAeE/GMWPAt3QwQLvjsx6eMbOapK0/U/gEUty241SQ0PbyqTlrWkGF21fblqJd8kthc8A4VtR3Q1bdrAS3JjwoBhTo2CEEMuxrU9kLqr7iPDY/GlVI3uObh7RLITJRPu1d4Uu/ZGxV8acuJIKtTRBWhvXnmbCXL8L2gIf0AJzJPm0pToZvQVrZ3f3LT9YYM2MNcC0v9q0iqLprsp7Vjm8j2cJIFiupcCxpwM9s+EtN330OkK0Q/LQFZdfV7CfAn9MbA8joRF+JNC4mL/XVtZq1u1xSczAbZ0HM8NSrqyEh+PxaHBvasWBO7j1NmXKCpU5fflIsXBwc/brNWlKQmATIxPeyXbFTNlHs8577jKb/CyQMmEuKX2GaeXJC8FkN8n7PBXabGqmP5aIShIRZITDEp43ZNKnzTcl8rJ8L98PXAr4XD5UzZjPogmwuWkIrBH9fA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(39860400002)(346002)(136003)(376002)(366004)(64756008)(66556008)(66476007)(66446008)(76116006)(91956017)(15650500001)(44832011)(4326008)(66946007)(8936002)(8676002)(478600001)(110136005)(6486002)(6506007)(71200400001)(54906003)(36756003)(5660300002)(186003)(2616005)(2906002)(66574015)(316002)(86362001)(26005)(6512007)(30864003)(83380400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?yiSPZNtCNgYWGofozYd9jBt/F8mx12P3ktb8MRp1Q2GyK4A5wLq2xLVqQ?=
	=?iso-8859-15?Q?SfchogOSaBl+qZ0Jfd21EN/7MXaruME/aFJnFS7gec5IpKvwf70QE+3wB?=
	=?iso-8859-15?Q?WByueQ5rhGJ8i24Ux46/vId1iTpL4CTqqEa7CHjB9BhLoGAbPmsM8K767?=
	=?iso-8859-15?Q?XBNT34ZQvHbuRxDh7jge8efeQm0KkFzLxSZ3MyX+3j1Mf7hLg3iGQjFkI?=
	=?iso-8859-15?Q?U6xuwoCL2BVXJCQNNC7L/RhVKsvsYj4fSATeAZKSSPXXZ4QUirY1RwXUP?=
	=?iso-8859-15?Q?gA0Q/2J9kE3jPGYN1RvJVA6Lbk8IhnjL6AMBjeLYAMDbNqgCQvBQrJjFX?=
	=?iso-8859-15?Q?iHZtwec3Uzb0NkwLP/BtbhwB3sQ1mVBEN7N7ldXpToFE+aZ63xoYzpKeX?=
	=?iso-8859-15?Q?uiVPavJJXy12OoZSaw1X+BMn1aXS820DWk/Iu+yyF2eUV9QV6bAM10rCI?=
	=?iso-8859-15?Q?xihk25QQr/KrB8efkN+VoDRkHDB9YUlNdm3umLpfTKOekIXSZNycE4SW2?=
	=?iso-8859-15?Q?ZxHD8PbugsmvBiQxuqdlU4gtimyA4OScCcsbOigF1hVOiYemt0Tq1Y1/A?=
	=?iso-8859-15?Q?bbwVZEYu1zf5gjRA9m6nYtyaBvYeoMk3nuXCrR1rU3HJHYJPIMya8ENPB?=
	=?iso-8859-15?Q?zg7rw7aMOZfL4TT2CN3+kOwNiRUV5xAjuC66cVa2d0ZQOybe6hcSzx8sO?=
	=?iso-8859-15?Q?ncDthgcpqqRE/uHM5IhR/0KZOpqenAYCXZMiWxAHEkci8iiuTyCNEyR+h?=
	=?iso-8859-15?Q?pa0wV14dxtLOjnURDBosuYY4zEdvNbekNFvZmpOwu7gk7WRPL1pBb6fbG?=
	=?iso-8859-15?Q?DfiS3uKYuy4hmNmaiIQX14EZuGLFH92oWhXGT8m+TY9u6PhKulHozlFHS?=
	=?iso-8859-15?Q?eonAhg58Nc3qI6Bqeo/6zFh4o7OdSxBvmt63s8woUJSU3LHkP00dWjrR+?=
	=?iso-8859-15?Q?pmduhFC5WWa5Z/UI41WB28WCKWQ6/4o+Mt405uji6/FmJDYXi2HozDxQY?=
	=?iso-8859-15?Q?DceSDH5PJ26eCptexHhnkS5lVLHRLUQcty42BB2cXlppuzqQxiazw2uWa?=
	=?iso-8859-15?Q?41reGnhk3QIchvLTMgXcVny17kaCbOhzU/yKV5HPICHXjAZaM1QTNhJeI?=
	=?iso-8859-15?Q?qUDz6r5J17plkx/WOtW6dcMzp9t97JShRCToZ+DjroNmbXjzOW3NuQTvO?=
	=?iso-8859-15?Q?/4fYlvf3yumsVdpjbbRCEsz0DEpGuH0nRvvjr6ZBVN/r1eYxcu2uCO+o7?=
	=?iso-8859-15?Q?1fxepz11gwLrFoovowww7hxWDQff6zwn/+B5PhTd8Btrn4QlojSYnXZMn?=
	=?iso-8859-15?Q?HNqPJlZIUX1ax2Jjs7XoCQUYobOsZrA6tFp3wuyRRFsxlFs47+MhMERYq?=
	=?iso-8859-15?Q?RKT96t2xqhyDeSD5klevHQRXROTR2XfCy?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31dd242d-2453-4aab-009a-08d8cd48cecb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2021 22:19:46.1956 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GBedYg5SfAIBv81D20wXJtOGsSRDmvHy8KKc7KTyQYA8b73vZ3pnn/OKpzj02BGd1llC4ROkxzUHzg7rKpB9lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3898
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 119MJwB3026382
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"wucy11@chinatelecom.cn" <wucy11@chinatelecom.cn>
Subject: Re: [dm-devel] [PATCH 2/2] multipathd: add recheck_wwid_time option
 to verify the path wwid
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <3E92C35F0BDC0441B1AB70567DCCC94C@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-02-08 at 23:19 -0600, Benjamin Marzinski wrote:
> There are cases where the wwid of a path changes due to LUN remapping
> without triggering uevent for the changed path. Multipathd has no
> method
> for trying to catch these cases, and corruption has resulted because
> of
> it.
>=20
> In order to have a better chance at catching these cases, multipath
> now
> has a recheck_wwid_time option, which can either be set to "off" or a
> number of seconds. If a path is failed for equal to or greater than
> the
> configured number of seconds, multipathd will recheck its wwid before
> restoring it, when the path checker sees that it has come back up.

Can't the WWID change also happen without the path going offline, or
at least without being offline long enough that multipathd would
notice?

>  If
> multipathd notices that a path's wwid has changed it will remove and
> re-add the path, just like the existing wwid checking code for change
> events does.=A0 In cases where the no uevent occurs, both the udev
> database entry and sysfs will have the old wwid, so the only way to
> get
> a current wwid is to ask the device directly.=A0

sysfs is wrong too, really? In that case I fear triggering an uevent
won't fix the situation. You need to force the kernel to rescan the
device, otherwise udev will fetch the WWID from sysfs again, which
still has the wrong ID... or what am I missing here?

> > Currently multipath only
> has code to directly get the wwid for scsi devices, so this option
> only
> effects scsi devices. Also, since it's possible the the udev wwid
> won't
> match the wwid from get_vpd_sgio(), if multipathd doesn't initially
> see
> the two values matching for a device, it will disable this option for
> that device.
>=20
> If recheck_wwid_time is not turned off, multipathd will also
> automatically recheck the wwid whenever an existing path gets a add
> event, or is manually re-added with cli_add_path().
>=20
> Co-developed-by: Chongyun Wu <wucy11@chinatelecom.cn>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I am uncertain about this.

We get one more configuration option that defaults to off and that only
the truly inaugurated will understand and use. And even those will not
know how to set the recheck time. Should it be 1s, 10, or 100? We
already have too many of these options in multipath-tools. We shy away
from giving users reasonable defaults, with the result that most people
won't bother.

I generally don't understand what the UP/DOWN state has to do with
this. If the WWID can change without any events seen by either the
kernel or user space, why would the path go down and up again? And even
if so, why would it matter how long the device remained down?

But foremost, do we really have to try to deal with configuration
mistakes as blatant as this? What if a user sets the same WWID for
different devices, or re-uses the same WWID on different storage
servers? I already hesitated about the code I added myself for catching
user errors in the WWIDs file, but this seems even more far-fetched.

Please convince me.

This said, I'd like to understand why there are no events in these
cases. I'd have thought we'd at least get a UNIT ATTENTION (REPORTED
LUNS DATA HAS CHANGED), which would have caused a uevent.=A0If there was
no UNIT ATTENTION, I'd blame the storage side.=A0

Maybe we need to monitor scsi_device uevents.

Technical remarks below.


> ---
> =A0libmultipath/config.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/config.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 4 +-
> =A0libmultipath/configure.h=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 +
> =A0libmultipath/defaults.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 36 +++=
+++++++++
> =A0libmultipath/libmultipath.version |=A0 6 ++
> =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 10 ++++
> =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0=A0=A0 | 18 ++++++
> =A0multipathd/cli_handlers.c=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 9 +++
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 92
> +++++++++++++++++++++++++++++++
> =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=
 2 +
> =A012 files changed, 180 insertions(+), 2 deletions(-)
> =A0.
> =A0.\" ----------------------------------------------------------------
> ------------
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 54635738..970d5e21 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -715,6 +715,15 @@ cli_add_path (void * v, char ** reply, int *
> len, void * data)
> =A0=A0=A0=A0=A0=A0=A0=A0pp =3D find_path_by_dev(vecs->pathvec, param);
> =A0=A0=A0=A0=A0=A0=A0=A0if (pp && pp->initialized !=3D INIT_REMOVED) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: path alre=
ady in pathvec", param);
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->allow_wwid_recheck =
=3D=3D ALLOW_WWID_RECHECK_ON
> &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 check_path_wwid_c=
hange(pp)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "%s: wwid changed. Removing
> device",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pp->dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0han=
dle_path_wwid_change(pp, vecs);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn 1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->mpp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 0;
> =A0=A0=A0=A0=A0=A0=A0=A0} else if (pp) {
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 19679848..17eef3a4 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -823,6 +823,59 @@ ev_remove_map (char * devname, char * alias, int
> minor, struct vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0return flush_map(mpp, vecs, 0);
> =A0}
> =A0
> +void
> +handle_path_wwid_change(struct path *pp, struct vectors *vecs)
> +{
> +=A0=A0=A0=A0=A0=A0=A0const char *action =3D "add";
> +=A0=A0=A0=A0=A0=A0=A0if (!pp || !pp->udev)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> +
> +=A0=A0=A0=A0=A0=A0=A0sysfs_attr_set_value(pp->udev, "uevent", action,
> strlen(action));
> +=A0=A0=A0=A0=A0=A0=A0trigger_partitions_udev_change(pp->udev, action,
> strlen(action));

Nit: it looks a bit weird to use a const char * variable for "action"
and a constant for "uevent".

> +=A0=A0=A0=A0=A0=A0=A0if (ev_remove_path(pp, vecs, 1) !=3D 0 && pp->mpp) =
{
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dmstate =3D PSTATE_FAIL=
ED;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_fail_path(pp->mpp->alias=
, pp->dev_t);
> +=A0=A0=A0=A0=A0=A0=A0}

I suggest taking a ref on pp->udev, calling ev_remove_path(), and
triggering the uevent after that.

> +}
> +
> +bool
> +check_path_wwid_change(struct path *pp)
> +{
> +=A0=A0=A0=A0=A0=A0=A0char wwid[WWID_SIZE];
> +=A0=A0=A0=A0=A0=A0=A0int len =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0char *c;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!strlen(pp->wwid) || pp->bus !=3D SYSFS_BUS_SCS=
I)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;

Maybe you should look at uid_attribute here, to be consistent with
has_uid_fallback()?

> +
> +=A0=A0=A0=A0=A0=A0=A0/* Get the real fresh device wwid by sgio. sysfs st=
ill has
> old
> +=A0=A0=A0=A0=A0=A0=A0 * data, so only get_vpd_sgio will work to get the =
new wwid
> */
> +=A0=A0=A0=A0=A0=A0=A0len =3D get_vpd_sgio(pp->fd, 0x83, 0, wwid, WWID_SI=
ZE);
> +
> +=A0=A0=A0=A0=A0=A0=A0if (len <=3D 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: failed to c=
heck wwid by sgio: len =3D
> %d",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp-=
>dev, len);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0/*Strip any trailing blanks */
> +=A0=A0=A0=A0=A0=A0=A0c =3D strchr(wwid, '\0');

Quite unusual, why not use strlen() or strnlen()?

> +=A0=A0=A0=A0=A0=A0=A0c--;
> +=A0=A0=A0=A0=A0=A0=A0while (c && c >=3D wwid && *c =3D=3D ' ') {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*c =3D '\0';
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c--;
> +=A0=A0=A0=A0=A0=A0=A0}

Nit: You don't have to nullify every space. Just the first one.


> +=A0=A0=A0=A0=A0=A0=A0condlog(4, "%s: Got wwid %s by sgio", pp->dev, wwid=
);
> +
> +=A0=A0=A0=A0=A0=A0=A0if (strncmp(wwid, pp->wwid, WWID_SIZE)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: wwid '%s' d=
oesn't match wwid '%s'
> from device",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp-=
>dev, pp->wwid, wwid);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0return false;
> +}
> +
> =A0static int
> =A0uev_add_path (struct uevent *uev, struct vectors * vecs, int
> need_do_map)
> =A0{
> @@ -919,6 +972,21 @@ uev_add_path (struct uevent *uev, struct vectors
> * vecs, int need_do_map)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uev->kernel);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0ret =3D 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (pp->allow_wwid_r=
echeck =3D=3D
> ALLOW_WWID_RECHECK_ON &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 check_path_wwid_change(pp)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(2, "%s wwid change detected when
> processing add uevent. removing path", pp->dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
don't use handle_path_wwid_change here,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
since that would just trigger another add
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
uevent
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
 =3D ev_remove_path(pp, vecs, true);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(ret =3D=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pp =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
e if (pp->mpp) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pp->dmstate =3D PSTATE_FAILED;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0dm_fail_path(pp->mpp->alias, pp-
> >dev_t);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}

What's the purpose of this code? Are you handling your own artificial
"add" event here, which you triggered before in
handle_path_wwid_change()? Or are there real cases where the kernel
would send an "add" event without sending a "remove" event first?

> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0if (pp)
> @@ -2049,6 +2117,7 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int checkint, max_checkint;
> =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> =A0=A0=A0=A0=A0=A0=A0=A0int marginal_pathgroups, marginal_changed =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0int recheck_wwid_time;
> =A0=A0=A0=A0=A0=A0=A0=A0int ret;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (((pp->initialized =3D=3D INIT_OK ||
> @@ -2066,6 +2135,7 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =A0=A0=A0=A0=A0=A0=A0=A0checkint =3D conf->checkint;
> =A0=A0=A0=A0=A0=A0=A0=A0max_checkint =3D conf->max_checkint;
> =A0=A0=A0=A0=A0=A0=A0=A0marginal_pathgroups =3D conf->marginal_pathgroups=
;
> +=A0=A0=A0=A0=A0=A0=A0recheck_wwid_time =3D conf->recheck_wwid_time;
> =A0=A0=A0=A0=A0=A0=A0=A0put_multipath_config(conf);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (pp->checkint =3D=3D CHECKINT_UNDEF) {
> @@ -2197,6 +2267,26 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0=A0=A0=A0=A0=A0=A0=A0set_no_path_retry(pp->mpp);
> =A0
> +=A0=A0=A0=A0=A0=A0=A0if (recheck_wwid_time !=3D RECHECK_WWID_OFF &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (newstate =3D=3D PATH_UP || newstate =3D=
=3D PATH_GHOST)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->allow_wwid_recheck =
=3D=3D
> ALLOW_WWID_RECHECK_UNSET) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(check_path_wwid_change(pp))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pp->allow_wwid_recheck =3D
> ALLOW_WWID_RECHECK_OFF;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
e
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pp->allow_wwid_recheck =3D
> ALLOW_WWID_RECHECK_ON;

This is confusing. I pulled my hair over this code before I read your
man page hunk: "When the path is originally added, if the path's
configured wwid doesn't match the wwid retrieved directly
from the scsi device, rechecks will be disabled for the device."

So, I gather this is an alternative to the has_uid_fallback() logic
mentioned above. It deserves at least a comment here. Please consider
if using the same logic as has_uid_falback() isn't just as good as
this.

Btw, as we're already pretty much on corner-case ground here, if the
path fails quickly after being detected, a WWID change could have
occured already when it comes UP first, and this code is run for the
first time.


> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (((pp->state !=3D=
 PATH_UP && pp->state !=3D
> PATH_GHOST) ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 pp->dmstate =3D=3D PSTATE_FAILED) &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 pp->failed_time >=3D recheck_wwid_time &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 pp->allow_wwid_recheck =3D=3D
> ALLOW_WWID_RECHECK_ON &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 check_path_wwid_change(pp)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "%s: path wwid change detected.
> Removing",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pp->dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0han=
dle_path_wwid_change(pp, vecs);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn 0;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->failed_time =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> =A0=A0=A0=A0=A0=A0=A0=A0if ((newstate =3D=3D PATH_UP || newstate =3D=3D P=
ATH_GHOST) &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (san_path_check_enabled(pp->mpp) ||
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 marginal_path_check_enabled(pp->mpp)=
)) {
> @@ -2330,6 +2420,8 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (newstate =3D=3D PATH_=
DOWN) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
nt log_checker_err;
> =A0
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(recheck_wwid_time !=3D RECHECK_WWID_OFF)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pp->failed_time +=3D pp->checkint;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
onf =3D get_multipath_config();
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0l=
og_checker_err =3D conf->log_checker_err;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
ut_multipath_config(conf);
> diff --git a/multipathd/main.h b/multipathd/main.h
> index 5abbe97b..ddd953f9 100644
> --- a/multipathd/main.h
> +++ b/multipathd/main.h
> @@ -50,4 +50,6 @@ int update_multipath (struct vectors *vecs, char
> *mapname, int reset);
> =A0int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
nt refresh);
> =A0
> +void handle_path_wwid_change(struct path *pp, struct vectors *vecs);
> +bool check_path_wwid_change(struct path *pp);
> =A0#endif /* MAIN_H */

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

