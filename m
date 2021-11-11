Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C40C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:45:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 768156128E
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 768156128E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-HWGGSYdhPnyzkeCsYUCz4A-1; Thu, 11 Nov 2021 06:44:57 -0500
X-MC-Unique: HWGGSYdhPnyzkeCsYUCz4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDC1F81C85E;
	Thu, 11 Nov 2021 11:44:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7C2E19C59;
	Thu, 11 Nov 2021 11:44:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 295C01800FDD;
	Thu, 11 Nov 2021 11:44:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABBioc0010436 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 06:44:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5FC2F404727C; Thu, 11 Nov 2021 11:44:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5ACE14047279
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:44:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EAB485A5B9
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:44:50 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-372-4k5PdLFIPBW79pM-Ma9uRg-1;
	Thu, 11 Nov 2021 06:44:48 -0500
X-MC-Unique: 4k5PdLFIPBW79pM-Ma9uRg-1
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur03lp2059.outbound.protection.outlook.com [104.47.10.59])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-9-DdrWLDqXOq6lFe4ofjkRTQ-1; Thu, 11 Nov 2021 12:44:46 +0100
X-MC-Unique: DdrWLDqXOq6lFe4ofjkRTQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR04MB2998.eurprd04.prod.outlook.com (2603:10a6:6:4::22) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4669.11; Thu, 11 Nov 2021 11:44:44 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 11:44:44 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 7/9] libmultipath: deprecate file and directory config
	options
Thread-Index: AQHX1phm8ROwZ6mVb0GTS7Wl3ouE9av+NdiA
Date: Thu, 11 Nov 2021 11:44:44 +0000
Message-ID: <71d89b6eb201dd69cf8a6a209fa0fc12b8ebe918.camel@suse.com>
References: <1636592780-20391-1-git-send-email-bmarzins@redhat.com>
	<1636592780-20391-8-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636592780-20391-8-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aee9698b-274c-4ec8-9cf7-08d9a508a7e2
x-ms-traffictypediagnostic: DB6PR04MB2998:
x-microsoft-antispam-prvs: <DB6PR04MB2998F689E50612CC4E907FADFC949@DB6PR04MB2998.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: wb2WGIKadRkG+laawKjJ8Hq6oelqnTwny0RPkFOYgajRtVcTBZvt9h7uvjvbE7IpYIHIgcdwHne4YB5IoNS5M14G1w0EKHfgxSlDdBxrPd0Q2v4wNHJeHG7umyR2HKOsK9Gd2nW7if5DxA04tNJFL6V+ClLdignaaops94vZ3PiFYKRuXf9LTVbonQVSTxKU/p9+4mwf2CdFRO8f302vNUwhd8AONVXDpdwdLrUrccf8RjTtWA5/otTk8LpfVinIJnhxIiq9lKBlmCEYb8Qdmc1bgsLc/9Rw8dbcroJH/VyXS8Sx0EU9wkv0l6SUAZSMNirca5mgVp7nqE0SUl+a9F1Jsn4DlALYrY/OStaPLAbHBQqTcvZkYwWMDYU84H6AGpePoPPYMhV9kY5ICBYVCxThEi/VgGzEXX4/QByeVnXA9PnBwGK8jMQ1rTyy7HlgypnswoKh/TQmkLCNvL+mGVrJ8vHJy8UDqMC7Ip5cQD8FZ+4ISyKREJdm7H6d7gSrwf4yNDTooBywtZEb1j7MXhHjiY5eIr+oteAyjDQeQXF27EkZl7l3upWM8AbFus4MeYhCQfZ6T0Dv2NeuAs1L+ycwy7PtQNI2vvT3Kcdj2+jzNHHyruoPZY88mpwwcHo6en8g7y0gX8ejqIEMuU33dCmEurC3lKaWSAgxBd9Qf0f3ZMqTEiwGYcRaii2draIzIZwLmxv2eQ4GjvSyIO9XZw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8936002)(8676002)(66946007)(66556008)(66476007)(64756008)(508600001)(6512007)(5660300002)(91956017)(76116006)(6486002)(26005)(71200400001)(186003)(38070700005)(122000001)(66446008)(44832011)(86362001)(2616005)(38100700002)(83380400001)(316002)(4001150100001)(110136005)(6506007)(36756003)(2906002)(4326008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?J7iT8gWoIvu9YADdwxpoLYcAGLzR9ArIoXObcOshDrEWWtyLXd2lyj92Z?=
	=?iso-8859-15?Q?YO5tUP47pviDLOA+VpSwd9+iiHVUTA7xr4drHoT/dHqNG7iu31Y3web4t?=
	=?iso-8859-15?Q?hdfvZuMFEepr5gXpaMRwPqQF6dnPv6nbRocL0IHkzBqWGGPUX/qqkUC1+?=
	=?iso-8859-15?Q?+LV7dc6p94O6+EvhIZnLGplE4mzbdYrKn4WvQKdGTQ8JRWfJ2jkL7C7zw?=
	=?iso-8859-15?Q?pSBpQ8hbJFlO8dKJ7wyc2frQRKxThTSnBnZ2OfXMXG5HSTn0mgllNqikm?=
	=?iso-8859-15?Q?z9vkB3aVz0s2ZNnBjc7ABH3dxZ+ph00BR/7/2F52ASWVolML5S2sshl1j?=
	=?iso-8859-15?Q?4leK/NmQFPi3gn4U+U9nGIqcQ22TZ7O064O5F4eZvLxBe4KcReIJUSJeI?=
	=?iso-8859-15?Q?8rM0xPncE3EOK5Sx39yR0nR/Xyx6dTZtffzcNNbzB5KBnVvaE2rF51vlL?=
	=?iso-8859-15?Q?MMon3MLGhKnoCCLezRpc+z4fJO95op0R48JiRMKp/lF+8j7dCGqwk1Xia?=
	=?iso-8859-15?Q?eMf/rGiDC5T7hUjojomVcgDNuqEg4nnpKHrc8GdKWxyZgbknGJckHbgm7?=
	=?iso-8859-15?Q?vMqX5hueuvIbQGGl7tgScIMqStuGlDVas2HVqs2MtClgMFmpuK5IJylz0?=
	=?iso-8859-15?Q?8FUIo1kBy0YFcwm42dvi1WIOMN4CVVpdfMcggW41jWp582it4QInLlsRf?=
	=?iso-8859-15?Q?18Vc3MgGTHh6atRHNiaoKQHZ/G3nVORf9b0W7xBQrm5YeY9UzLNtzTNsj?=
	=?iso-8859-15?Q?GfkgVJ6teSykZiDro4z7TNofy88C7iGNyjxf79/EIP+6NBkmCoO03e/fz?=
	=?iso-8859-15?Q?LI5/GDC9v4TT0ZsjP3Lay0biY24IK927K2d039d6OnPn9qoJ6AWtK/nfQ?=
	=?iso-8859-15?Q?TLBbUhnEguISrjYB9NzBwPLGADvdGkFp8E5CsWbID11+8a+6Am34Omxvb?=
	=?iso-8859-15?Q?ZIlvH4toBvLNdU18MEUS9lTLMPf5jzqeVSPkE1yhB8dftY7UmnBGXlnUS?=
	=?iso-8859-15?Q?PeIEByNiGJVLyC4H05Pp/ILKBezPTRAVGuv0UZPHVoReHa8PsktLGWvx+?=
	=?iso-8859-15?Q?hDnM9emLoToQpl3yTOk68kWiQ5VY95edoz3xdj5o65zFiP6Mpamrwqq1i?=
	=?iso-8859-15?Q?YB9NTs3BDOT5lGbYhrHmetujTEgjNMqPcQhdUBhXVDw/A1vLxARqjZx5t?=
	=?iso-8859-15?Q?V+lB3BHH1m2RVoYuV6W8uPslLAtWCF9/AYq8dMyqgxq2BQqnY2fHzQSRF?=
	=?iso-8859-15?Q?n5WlQmsCXwGQyQYiDiS+eBcC1FantWvqeEJ/7ePkbwH0q2oegSVcKlDsZ?=
	=?iso-8859-15?Q?ElAetR1WOKyvVhENv9qq7UQjfH7XvHEHuWuXKGxPyQcG6WcKH1SFgqVPk?=
	=?iso-8859-15?Q?p+UqgZ+ttEMOD4GsPXM4EtdWPUtFFMtpjiItnyjmmn9g4pMiu5/6MVenQ?=
	=?iso-8859-15?Q?6+br/HR8OYjQ1ezgRyAZ8RbVFwc4g8Z3sXsME5/fs9fUi5LmJ7lb8niwu?=
	=?iso-8859-15?Q?NjqekFlsEV6lMjF85HPTeU/3wwzV6j1cGrTIGTxDAAUN/hx7ASyIw59AP?=
	=?iso-8859-15?Q?mXN4BVI8yKrGQ5TcmSojqWzRNIbg36NdDLdNz5pg0NDvf6O8fDn+0Z4H5?=
	=?iso-8859-15?Q?qR/xq8tRj+D8bJKBXExYOPUooW9e8XeaC4tS4YnLh0aeHhb6EYarL7eR3?=
	=?iso-8859-15?Q?N2hLlHZYPB7uz5LsWSmdpLoDC89K8bwIFddap5E2ueA+/j0=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aee9698b-274c-4ec8-9cf7-08d9a508a7e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 11:44:44.3044 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zlz62err1MaOX10RjxsriupeLIcBBRxZsdFHd1EWuznwvnF+rSznbVA2QWjtWuSzxMl/wgSC3O+P/dc36j74zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB2998
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ABBioc0010436
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 7/9] libmultipath: deprecate file and
 directory config options
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
Content-ID: <AADFA44268AEEB488F9F71622A10DCFF@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-11-10 at 19:06 -0600, Benjamin Marzinski wrote:
> Having multipath able to select pathnames for the files and
> directories
> it needs causes unnecessary maintainer headaches. Mark these as
> deprecated, but still support them for now.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I would have preferred to start ignoring these options right away
(spitting out warnings). After all, this is upstream, we don't have to=20
take care of long-term-support users (distros can keep the old behavior
if they want), and experience shows that depreciation warnings are
ignored until the deprecated feature is actually removed. But if you
prefer doing it this way, fine.

Let's agree to remove these options soon, i.e. with the official
release after the next one (0.8.9, presumably).

> ---
> =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0 | 40 ++++++++++++++++++++++++=
+++++-------
> --
> =A0multipath/multipath.conf.5 |=A0 5 +++++
> =A02 files changed, 36 insertions(+), 9 deletions(-)
>=20
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 149d3348..1b4e1106 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -268,6 +268,15 @@ def_ ## option ## _handler (struct config *conf,
> vector strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->option, file,
> line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0}
> =A0
> +#define declare_def_warn_handler(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +def_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int
> line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s line %d, \"" #option "\" is deprecat=
ed and
> will be disabled in a future release", file,
> line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->option, file,
> line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +}
> +
> =A0#define declare_def_range_handler(option, minval,
> maxval)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
\
> =A0static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0def_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0 \
> @@ -284,6 +293,17 @@ snprint_def_ ## option (struct config *conf,
> struct strbuf *buff,=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0return function(buff, conf-
> >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0\
> =A0}
> =A0
> +#define declare_def_snprint_non_defstr(option, function,
> value)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +snprint_def_ ## option (struct config *conf, struct strbuf
> *buff,=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
st void
> *data)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0static const char *s =3D
> value;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0if (!conf->option || strcmp(conf->option, s) =3D=3D
> 0)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> 0;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0return function(buff, conf-
> >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0\
> +}

I'd actually print the value here, even if it's empty or equal to the
default. That would be helpful in the future too, when these options
are removed. This way customers can verify the settings multipathd is
using by default.

Regards,
Martin




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

