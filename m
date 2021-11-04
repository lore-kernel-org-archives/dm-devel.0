Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4FEC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 22:01:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6A0D61260
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 22:01:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C6A0D61260
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-Vz20OP0sO9GMlZDwUNfqAg-1; Thu, 04 Nov 2021 18:01:26 -0400
X-MC-Unique: Vz20OP0sO9GMlZDwUNfqAg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68E6880668C;
	Thu,  4 Nov 2021 22:01:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ABECE18351;
	Thu,  4 Nov 2021 22:01:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0AB3F1806D03;
	Thu,  4 Nov 2021 22:01:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4M0HNY031230 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 18:00:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3C78940C1252; Thu,  4 Nov 2021 22:00:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 377A6400F3C6
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 22:00:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19BFC8007B1
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 22:00:17 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-203-4iifmTfgO_CNk1IJMHrJYg-1;
	Thu, 04 Nov 2021 18:00:15 -0400
X-MC-Unique: 4iifmTfgO_CNk1IJMHrJYg-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2058.outbound.protection.outlook.com [104.47.13.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-5-DgiQ5KGLPuSNh2-xA7Ii4Q-1; Thu, 04 Nov 2021 23:00:13 +0100
X-MC-Unique: DgiQ5KGLPuSNh2-xA7Ii4Q-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5386.eurprd04.prod.outlook.com (2603:10a6:10:81::15) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17;
	Thu, 4 Nov 2021 22:00:11 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 22:00:11 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 0/7] multipathd: remove udev settle dependency
Thread-Index: AQHXxebbEvFewrGj9kuWWVVGk08+Pav0At4A
Date: Thu, 4 Nov 2021 22:00:11 +0000
Message-ID: <340a1d0da9921f1d7f334395b4986be904a2517e.camel@suse.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d74e8aa2-3a9e-4823-b2ed-08d99fde7922
x-ms-traffictypediagnostic: DB7PR04MB5386:
x-microsoft-antispam-prvs: <DB7PR04MB5386A815AB41DDDB44C6F2EBFC8D9@DB7PR04MB5386.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: FP4w9q+K7w9yFo/16RuxxH8f1JwwzBvgvFvFwYbxRiEO5rJFu8GggbMjRkmBYtqEFN6qEf4McAvdzfNeiyJbcr35hPH8VtnuEPNv2p9fbR7kSADG8VuLbHa6DgOjebl9JCeCOtGYztWLdYqa8aj3va9OQCv7ZWrqCzujDIvjm74aaPNrS0F0/hjkR8AAjaDcf/EFxfYGmlfF9kOsaSPJOQr3pwOB1NtqhWW4+Jh4D6A7AdXnRd5ZKqtmHD0jCpV9vG2SZL3astt8jL4Q0ufqVjWWk9wOec0qnKrGEPIA0jleeNFGDZaYmKmQFkvCoAfoQdRf3xkWKxPrSAPY34hu4TPjQn1fXroTaJR6QM7dqI37OP4BKJvkClAIxkx34vtT31B+2Nw3B/G3SLlALTtgzsXzJKmD9D5inwGsRkNw9o3UgHe9WMcMcMEzhSTOkz9lG7BhXDsHG7YWPo5yJB05YsOZqkYZwi8E7OA6+LVTDCFhNdmW2ECUo8Jk5o3/jqlaNfI900dUbvJjszh05dyQ4klLC+wFoEr01HGO569WYOLXFm7vCY0KF3qbsHQUalVF/TSpQjfYC73GMpkjyLj1fcXm8ii48FmjXvJ7++trECxLPsRcCNEHSsXODLAC9JcEf+2cFtGVunHhQXoql9tq/uL1F4lEnH7+u34IWOjPKsYcCz31Yyl9juAEK47/O3RaDVakWCSzbrs5wUv2HOM/9w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(4001150100001)(66476007)(316002)(4326008)(66946007)(38070700005)(64756008)(508600001)(8676002)(5660300002)(6506007)(36756003)(8936002)(110136005)(86362001)(66446008)(38100700002)(76116006)(6486002)(83380400001)(6512007)(91956017)(2616005)(2906002)(71200400001)(26005)(44832011)(66556008)(186003)(122000001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?17JjzMINRVyWXZIifNLaqQ676qGRD8B2eXGY9390Ji8T9D0G+hxRbsikR?=
	=?iso-8859-15?Q?gbzf6cezaMItKH3YDGCYNiccRvZFtgcShJvcjpY1obJQ8SisEFUbGYNiV?=
	=?iso-8859-15?Q?leeAYjxwd5QEhQnDywdxWxQSCxLvLXF8DXLWNriR1HWddqx6yryVYIh7Y?=
	=?iso-8859-15?Q?65bZmL/qZAqsMXMA/7FY01oLcxVvjXQTJVozPUNYWBD6HpTJif6CYFjYW?=
	=?iso-8859-15?Q?Hr+TiAz1x3UfxjXzPfmRFc4KBen34+ZrpPbBSnZNjLLc1/v5XhW/GU+rQ?=
	=?iso-8859-15?Q?D6oQXd0/9Y0EWQSc043shjDtyCtH2bkbYw8d74lgkHCjbsDxls2Hi77D1?=
	=?iso-8859-15?Q?rHFWYK7gWmRIj9CmkRWG4KarYO8gwysyuSunEcrm3hc/PO9Op/qg62Hah?=
	=?iso-8859-15?Q?aQfIntZNgZq7eAodeWECfobv9ACiqVRtaTII4+p20p62hlC8Y3r/IhZB/?=
	=?iso-8859-15?Q?h6G2Glzudb09/1d94Cii4I8Nwc/2piwbiibii/TRVptPOlxsfCnQYzgSg?=
	=?iso-8859-15?Q?FuHbupRZUSwZS7SGTjGbkCq1D8t9CqN1WCdeeNthUMXn8hTxqh9GJVkkF?=
	=?iso-8859-15?Q?TBQHIYiRCd6ERE2eZvbDwRgT6CTIywV81FS6BJ5IgXzPBkDjVuQEZWG82?=
	=?iso-8859-15?Q?jvRDBuS4MWhChojdyuO+fX4iYFHspY3mMcUzcpfVRQcuGssUdtw5qF6pB?=
	=?iso-8859-15?Q?fDiHdtgM71zG77X24VOnn0sJ1j1KzYN3hg0/7tdXPxpslUIMpes4rK+BY?=
	=?iso-8859-15?Q?Q4iVNHR85rN+V/Mpv0re/8k5fJEtUd98oauhPGY9C6BjqS9qq5Wod9Cva?=
	=?iso-8859-15?Q?znSwupuzLGUzQRrTrOpe2ej2aayRsEKLvLR74ZcCey8qjal2MqXm6dleW?=
	=?iso-8859-15?Q?pUVNeZXpNsY844OoZ/MZz1/n+NTVJuAxMkq9epZOlMWM1l+RAZ3iWqIRb?=
	=?iso-8859-15?Q?8dQtxuLTxt3FK3eY+x70nvlBCiDyTBRFgRxkzqYu79mk4bbL96SysiUCd?=
	=?iso-8859-15?Q?JuRRrp2kFA5YPuSGVTdm6tLHqfU6HVGNmZiPLTMkxEusDKlVScFI/I598?=
	=?iso-8859-15?Q?gOlwoMaxp4bnkHVZgsQKuy9httLV1NKy8eYmq1J9SAGNXY3eEmRWQ2efs?=
	=?iso-8859-15?Q?RWrflAtf63uo1DHNRiZQg8+fNsEfrVIrHRFkm+0eF9k6wUQhpTAWR/Lgp?=
	=?iso-8859-15?Q?5SA8xBvVifWU0Iuw+vNPxXMbQofgQOYh6ofeG2A+n5MHrtR/sbJVRuxjr?=
	=?iso-8859-15?Q?MxfsUkpkl3HLEXNM+o+v+yqM6e5mYAYKnUHm4v7DLae7FXYdGu26OE/XM?=
	=?iso-8859-15?Q?rtYjxM97jT/WUs7GfyRBrK+oy6dLrBl2g/eWYiv0PcMRRQiiOr9aZg/zQ?=
	=?iso-8859-15?Q?6/nc4tMDbLNnEYKFyod7UEvFlLsumCUx3IZq4zlXVvY+IrtRLCwwBwdOQ?=
	=?iso-8859-15?Q?XgNt89AawxKarTYkVC/wMCaWA8sMdqaJSW9GDG9ZYDirO+J1zKZVo3vnX?=
	=?iso-8859-15?Q?6VF2eM4p6mz5MDT6ZKeb2eLoX5zqZws/XGiLO3Wl65R/0izvDFIM2Jdh4?=
	=?iso-8859-15?Q?MqDITXvp4FvCJ1XMBNFY2+M48vt/8CTKvoatyIQWUmxDFT5g+FIvsek+y?=
	=?iso-8859-15?Q?NQgKk3EAcnkF6LtOt7LLSH4sT+eMXN4HtktLiY7go7t6Slybzvgj9BdK1?=
	=?iso-8859-15?Q?neL/zFSzjL9geNi0ka0AxOv2TsLZWKOe/WKRrNNztB2XduA=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d74e8aa2-3a9e-4823-b2ed-08d99fde7922
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 22:00:11.1820 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D+NOwhQfT/UE8+lahqX49Hx305y1dNJOraWaDLPW6A1rm6sOALIv7ywxK1LJH8dXBH7dVqVWhQ4o3H7Kle6ffw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5386
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4M0HNY031230
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/7] multipathd: remove udev settle dependency
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
Content-ID: <BD1DBD325D403D4A8AE2D3ACE8FF1CB9@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-10-20 at 14:15 -0500, Benjamin Marzinski wrote:
> So, it turns out that commit 4ef67017 "libmultipath: add
> update_pathvec_from_dm()" already does most of the hard work of making
> multipath handle the uninitialized paths that exist during boot, after
> the switch root, but before the all the coldplug uevents have been
> processed. The only problem is that this code leaves the paths in a
> partially initialized state, which doesn't completely get corrected
> until
> a reconfigure happens.=20
>=20
> This patchset makes multipath track these partially initailized paths,
> and makes sure that they get fully initialized, or removed, as
> necessary.
>=20
> The first patch is a tangentially related bug I found when trying
> (unsuccessfully) to recreate multipathd's problem with dropping
> uninitialized paths. Multipathd was not removing completely missing
> paths from maps that it found while starting up. The solution I chose
> was just to make sure that a full reload will happen on these maps,
> even
> if a weak reconfigure was requested. However, this means that multipath
> still completely ignores these missing paths. A side effect of this is
> that "multipath -l" does not show these paths, even though they exist
> as
> part of the multipath table. The full reloads are necessary, to take
> care of issues that update_pathvec_from_dm() can run into, but we might
> also want to think about marking these missing paths as INIT_REMOVED,
> instead of not adding them at all. This would make "multipath -l" still
> show them, until they actually get removed from the table.

Yes, that might be a good thing. Completely missing paths (not existing
in sysfs) in a map represent a dangerous condition; it would be good if
multipath -l was able to tell the user about it.

>=20
> Patch 0005 makes sure to fully initialize the paths when their coldplug
> event occurs, but if the path is already fully initialized in udev, but
> multipathd finds out about it from update_pathvec_from_dm(), multipath
> doesn't do anything to finish initializing the path and moving it to
> INIT_OK, besides waiting for a uevent or a reconfigure. This is
> probably
> fine, since the only way I can see for a path to be in this state is
> for
> someone to manually remove the path from multipathd monitoring. But if
> I'm missing some other way that paths could end up in this state, we
> could try proactively finishing the initalization of INIT_PARTIAL paths
> that have all their udev information.

One option would be to try finishing the initialization in the path
checker.

What about the checker, in general?  Should we take some care that
partially initialized paths aren't mistakenly set as failed? I'm not
sure if libudev is able to return a proper fd from
udev_device_get_devnode() if the device isn't yet initialized in the
udev db. Without a proper fd, the checker is doomed to fail. And other
failure modes are possible too without proper udev initialization, I
suppose?


>=20
> I'm also kind of on the fence about patch 0006. There is no reason
> why
> we have to remove INIT_PARTIAL paths if the multipath device goes
> away.
> But if a path is in INIT_PARTIAL for long enough that the multipath
> device gets removed, then it's likely not a path we want to be
> monitoring, and if a uevent occurs, we'll add it back, anyway. Also,
> knowing that INIT_PARTIAL paths are always part of multipath devices
> does make the code simpler.
>=20
> I've tested these patches both by rebooting with necessary and
> unnecessary multipath devices in the initramfs and multipathd.service
> set to make multipathd start up at various points after the switch
> root,
> and by manually sending remove uevents to unintialize some paths, and
> then starting multipathd to test specific combinations of path
> states.
> But more testing is always welcome.

I'll try to give this code a test shortly.

Cheers,
Martin


>=20
> Benjamin Marzinski (7):
> =A0 multipathd: remove missing paths on startup
> =A0 libmultipath: skip unneeded steps to get path name
> =A0 libmultipath: don't use fallback wwid in update_pathvec_from_dm
> =A0 libmultipath: always set INIT_REMOVED in set_path_removed
> =A0 multipathd: fully initialize paths added by update_pathvec_from_dm
> =A0 multipathd: remove INIT_PARTIAL paths that aren't in a multipath
> =A0=A0=A0 device
> =A0 multipathd: Remove dependency on systemd-udev-settle.service
>=20
> =A0libmultipath/configure.c=A0=A0=A0=A0=A0 |=A0 2 ++
> =A0libmultipath/devmapper.c=A0=A0=A0=A0=A0 |=A0 2 ++
> =A0libmultipath/discovery.c=A0=A0=A0=A0=A0 |=A0 7 ++---
> =A0libmultipath/discovery.h=A0=A0=A0=A0=A0 |=A0 2 ++
> =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0 |=A0 7 +++++
> =A0libmultipath/structs_vec.c=A0=A0=A0 | 40 ++++++++++++++++-------------
> =A0multipathd/cli_handlers.c=A0=A0=A0=A0 |=A0 4 +++
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 48 +++++++++++=
+++++++++++++++++++++-
> --
> =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0multipathd/multipathd.service |=A0 3 +--
> =A010 files changed, 90 insertions(+), 26 deletions(-)
>=20


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

