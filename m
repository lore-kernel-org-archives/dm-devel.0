Return-Path: <SRS0=XTDI=IK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D293CC433E0
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 09:36:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5786064F2C
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 09:36:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5786064F2C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-GVI87jFUM0WrbvxHDZnqtg-1; Fri, 12 Mar 2021 04:36:48 -0500
X-MC-Unique: GVI87jFUM0WrbvxHDZnqtg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26BFA192FDAB;
	Fri, 12 Mar 2021 09:36:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22E6460C9B;
	Fri, 12 Mar 2021 09:36:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D67FC1800232;
	Fri, 12 Mar 2021 09:36:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12C9aZDW014578 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Mar 2021 04:36:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 39178103F286; Fri, 12 Mar 2021 09:36:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 31E07103D239
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 09:36:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5A43101A531
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 09:36:32 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-516-NVc0n5drO7WLPJlfCqOhow-1;
	Fri, 12 Mar 2021 04:36:30 -0500
X-MC-Unique: NVc0n5drO7WLPJlfCqOhow-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2050.outbound.protection.outlook.com [104.47.13.50])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-3-f5I8qVUBOoqVyCw9_nPQCA-1; Fri, 12 Mar 2021 10:36:27 +0100
X-MC-Unique: f5I8qVUBOoqVyCw9_nPQCA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0401MB2358.eurprd04.prod.outlook.com (2603:10a6:4:51::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29;
	Fri, 12 Mar 2021 09:36:26 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3912.029;
	Fri, 12 Mar 2021 09:36:26 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH v2 3/3] multipathd: add recheck_wwid option to
	verify the path wwid
Thread-Index: AQHXCnb/povonI3prku1VaMnRVGuJap/VesAgAARl4CAAMnmgA==
Date: Fri, 12 Mar 2021 09:36:26 +0000
Message-ID: <dd9b31f1c6c72b14f7ad1ae57e753f3c571a7c68.camel@suse.com>
References: <1614148402-19847-1-git-send-email-bmarzins@redhat.com>
	<1614148402-19847-4-git-send-email-bmarzins@redhat.com>
	<8f500bcd5d5a683edcfa4d59567a50cc794cb085.camel@suse.com>
	<20210311213347.GU15006@octiron.msp.redhat.com>
In-Reply-To: <20210311213347.GU15006@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e034b3af-9a14-4baf-3824-08d8e53a4ea9
x-ms-traffictypediagnostic: DB6PR0401MB2358:
x-microsoft-antispam-prvs: <DB6PR0401MB2358150121FB5F8BC2E1D0DDFC6F9@DB6PR0401MB2358.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: PAJuJEQy08swD6SyJzXr1dBTmNIy1bxKg8MNvXNOJma+xzZsh7qgiZRlhNKQOFIUd4FTwXTrXRDZJEw9tiy8d+btIoXGTe3zWIqiw1xH9B8CUtT/NVKJ7oajwgc4pU+hRgpiTgQShdt0oCZNBeslQC7wvp5CslQ8IqDpoXT914KsTOJBoDENz+jS0wtbH5GSmK928vV8cfgOBDg+UxIeEeemprjRbE0EQj4TnXvIzS/RvhPHVNVBipCr3PQ4yEzAo5n1Xp35bC5DXmK9FME3sBSExGD8C4vZBmsJIxKLSEHydAeuJrxBb7bqB3NSWomMRXCgbdVOV7YjrhVbPa3NlVvYTmxoM6U7ekrY2s9XG+WiprMlyLhiHzuZKkEGKoSRHBJN4CceuE8Z3B9heo7yso0I5fnKl32+oMamhFbShivhVVHBZaEvgEqy+r3BQdZYktGXicGSsipqO/B1EWMZhQatov2OlcKeF7mY9eGuaAIulTB/xMj+rIl30FAywl6S98WvntGNR6Ft6Z7+o0VtiqLUBYoyHsqsqrrL6C/OtG7TN5pQfVF36xBf1uYtmzLkbFD9NG4g0BKa68g6+soIyfYFHwKPOAz6/dF+SndXPP4=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(376002)(396003)(136003)(366004)(39860400002)(5660300002)(86362001)(8936002)(186003)(2616005)(64756008)(36756003)(66446008)(66946007)(6486002)(2906002)(6506007)(66556008)(6916009)(8676002)(66476007)(316002)(83380400001)(478600001)(71200400001)(44832011)(4326008)(91956017)(15650500001)(6512007)(76116006)(54906003)(26005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?egpNJsYqPJWuSTGtGN3bvdgHKNZHEgTJklVWc8fRfmDy96lNXDbAGdivn?=
	=?iso-8859-15?Q?lmXGWREagPpqmrRHEJcQVPvwjjetmrj8+1TA9jRbBtl+9cW36mU0rhM4C?=
	=?iso-8859-15?Q?9GhnzD82iAWoIq9e723B67Ni3ymAsaiMJ/vNfDTMozT9ZdT1CI95YgagT?=
	=?iso-8859-15?Q?OD03OuoA88XqmJrp6YsWJt65RUAhDOlxpCnJ44+YCRQscpz+X7eZ27jG8?=
	=?iso-8859-15?Q?zmgP0FJ3YgunNLM06TEKXJAASnWh8j1COUu7j1TdPFP2wT9HbHrJTDCE4?=
	=?iso-8859-15?Q?msk6iMl40W6O44bdJG9iSe+hvRdlM1pcMaMPtADDAmOxbXSAXzZAakrgB?=
	=?iso-8859-15?Q?i5/1V4SbLO7sLtG8qE3KneucIbey5761z+e+XjxkJjdCRMTsDKGlJJCfb?=
	=?iso-8859-15?Q?KknMxz0fz9GGw/IV0kJ6GoazB4t0lJogfAmEuK75XlI8LQgAvCghVWyZM?=
	=?iso-8859-15?Q?8X3EyIvhohCtW+1W3aG8eF6ZZgn16BNHLlOSfPGyANzGQk1/uNGXL9PQY?=
	=?iso-8859-15?Q?66TCPozPVotmRoY0mFWaT2NSQP29KI4Wfp/p9nqfT0LCWmy2U1IbroSbv?=
	=?iso-8859-15?Q?JbCdx4CwbNSSWD4mAXQTtmqVf3wnNRobfBXVLZYwgWXqM61VgUKRI7uZo?=
	=?iso-8859-15?Q?GqNnVgRHzkfJRO8tU43eqNVNJsNxRNO7rB724Duc0H1GIXLHVOqhATZmY?=
	=?iso-8859-15?Q?J8ycLMHLAMOEwlk/NkDRZ8Ef3bxd7n2lHdhYcdlb/jz4dK3QtuwTxPmgO?=
	=?iso-8859-15?Q?pTBOyyf2JqnrM8oE4l+HUzDmYma2hDrvUntQgPHjj4Lampw3KTkaGd1q0?=
	=?iso-8859-15?Q?AajEZqSMeW4g9jTjh3nicPQ78XfePFJCet1d64dJ8VlbrIRN/F+HnDjKF?=
	=?iso-8859-15?Q?4Yp8iPuOxBOFOuamN6KZBHD6UCHfojMGlXaGN5u8IyqncsmSpYUa9STlA?=
	=?iso-8859-15?Q?nTjdWUgItY2uoo8ATBl3hKovE/eKJwXWngGHvomC+eK0ZlSfASkIIL40t?=
	=?iso-8859-15?Q?q9NUwHjCWWwahLn0GUNeIOOXqofAksPfmfNJnp56ieY5SkiWWa4+w3cNh?=
	=?iso-8859-15?Q?o7qJjUCAKzPMEy4ZbO4jXBOcNnBr02cyeoDP5ByIz0lntPoa0sliUb6rI?=
	=?iso-8859-15?Q?wORkwURuL/iktO0aXyPvEqEHP/4hGLt4lGOWOZjsNqHYUo9chSrvh8XSj?=
	=?iso-8859-15?Q?2eWALvN2AaxZ42BUEp6R0f6wBY2bZG9ds4+SJn6MH0G6V6+Qei3SrzA7g?=
	=?iso-8859-15?Q?3WboxAK7YAr3iStIq/v7ELMlUsy63CT0p90VH7Kb4PHEoSxnbGOcSjqgx?=
	=?iso-8859-15?Q?rxv3dRexvTMT8KOstX9MrXLgLGlA+no7zHZk+u7ofOeEqCas1LYVHN4RI?=
	=?iso-8859-15?Q?09dKpHe2l/bTdBJvXP30qwOifbzLQi0Zg?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e034b3af-9a14-4baf-3824-08d8e53a4ea9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 09:36:26.2562 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3k8KsOFUKaf9/qJLvJk8J6org8tDFeAQwvhA20YziQfZqBep/Olxj8L6qzQFi2eIxVK1SU6hMt3oRFTfugXEqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2358
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12C9aZDW014578
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"wucy11@chinatelecom.cn" <wucy11@chinatelecom.cn>
Subject: Re: [dm-devel] [PATCH v2 3/3] multipathd: add recheck_wwid option
 to verify the path wwid
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
Content-ID: <3C20BEF7C552054C8551FFC582935F02@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-03-11 at 15:33 -0600, Benjamin Marzinski wrote:
> On Thu, Mar 11, 2021 at 08:30:51PM +0000, Martin Wilck wrote:
> > On Wed, 2021-02-24 at 00:33 -0600, Benjamin Marzinski wrote:
> > > There are cases where the wwid of a path changes due to LUN
> > > remapping
> > > without triggering uevent for the changed path. Multipathd has no
> > > method
> > > for trying to catch these cases, and corruption has resulted
> > > because
> > > of
> > > it.
> > >=20
> > > In order to have a better chance at catching these cases,
> > > multipath
> > > now
> > > has a recheck_wwid option. If this is set to "yes", when a failed
> > > path
> > > has become active again, multipathd will recheck its wwid. If
> > > multipathd
> > > notices that a path's wwid has changed, it will remove and re-add
> > > the
> > > path, just like the existing wwid checking code for change events
> > > does.
> > > In cases where the no uevent occurs, both the udev database entry
> > > and
> > > sysfs will have the old wwid, so the only way to get a current
> > > wwid
> > > is
> > > to ask the device directly. Currently multipath only has code to
> > > directly get the wwid for scsi devices, so this option only
> > > effects
> > > scsi
> > > devices, and they must be configured to be able to use the
> > > uid_fallback
> > > methods. To make sure both the sysfs and udev database values are
> > > updated, multipathd triggers a both a rescan of the device and a
> > > udev
> > > add event.
> > >=20
> > > Co-developed-by: Chongyun Wu <wucy11@chinatelecom.cn>
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > Two minor remarks below, but:
> >=20
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
> >=20
> > > =A0
> > > +static void
> > > +rescan_path(struct udev_device *parent)
> > > +{
> > > +=A0=A0=A0=A0=A0=A0=A0while(parent) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const char *subsys =3D
> > > udev_device_get_subsystem(parent);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (subsys && !strncmp(=
subsys, "scsi", 4))
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0break;
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0parent =3D udev_device_=
get_parent(parent);
> > > +=A0=A0=A0=A0=A0=A0=A0}
> >=20
> > You could have used udev_device_get_parent_with_subsystem_devtype()
> > here.=20
>=20
> fair enough.
> =A0
> > > +=A0=A0=A0=A0=A0=A0=A0if (parent)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sysfs_attr_set_value(pa=
rent, "rescan", "1",
> > > strlen("1"));
> > > +}
> > > +
> > > +void
> > > +handle_path_wwid_change(struct path *pp, struct vectors *vecs)
> > > +{
> > > +=A0=A0=A0=A0=A0=A0=A0struct udev_device *udd;
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0if (!pp || !pp->udev)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0udd =3D udev_device_ref(pp->udev);
> > > +=A0=A0=A0=A0=A0=A0=A0if (ev_remove_path(pp, vecs, 1) !=3D 0 && pp->m=
pp) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dmstate =3D PSTATE_=
FAILED;
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_fail_path(pp->mpp->a=
lias, pp->dev_t);
> > > +=A0=A0=A0=A0=A0=A0=A0}
> > > +=A0=A0=A0=A0=A0=A0=A0rescan_path(udd);
> > > +=A0=A0=A0=A0=A0=A0=A0sysfs_attr_set_value(udd, "uevent", "add",
> > > strlen("add"));
> > > +=A0=A0=A0=A0=A0=A0=A0trigger_partitions_udev_change(udd, "add",
> > > strlen("add"));
> >=20
> > Why do you need to do this for the partitions?
>=20
> When I tested this before, it didn't appear that an add event ever
> got
> retrigger for any existing partitions. But since the device got
> remapped, the udev information about those partitions most also be
> wrong. The idea was to get them to be using better data. Admittedly,
> this isn't really necessary for kpartx. It just seems like since
> multipath noticed it, it should try to clean it up.=A0 But actually,
> there
> might not even be partitions on the device anymore, so perhaps it's
> best
> to just leave them alone.

It seems to me that we're "papering over" a kernel deficiency here. IMO
multipathd isn't responsible for partititions on path devices. Doing so
may come as a surprise for other actors in the system (mind you how
much confusion udev's "watch" functionality for block devices has
wrought in various areas, even though it's a good idea in general).
OTOH, nobody uses these partitions; we even have "del-part-nodes.rules"
to make them disappear altogether.

My understanding was that when the kernel revalidates a gendisk (as it
should after a "rescan"), it would also revalidate the partitions and
add/remove them as appropriate. I haven't digged through the details,
but if these uevents don't occur, the rescan may have been ineffective
or incomplete?

>From past experience with rescan-scsi-bus.sh, just a "rescan" may
actually not always be sufficient. rescan-scsi-bus.sh removed devices
before rescanning them in "--forcerescan" mode:

(https://github.com/hreinecke/sg3_utils/blob/d82f040c69689305ca1d318d3dc0e1=
e42ab6ffa3/scripts/rescan-scsi-bus.sh#L1237)

The delete/rescan combination basically adds a new device, which should
provide us with every uevent we need.

That's of course highly dangerous (although not quite as dangerous as
combining different disks in a multipath map), not sure if we should
automate it.

> I can respin this using
> udev_device_get_parent_with_subsystem_devtype(),
> and removing the udev triggers on the partitions, if you want.

I already committed this to "queue". I thought that you'd been waiting
long enough for my review, and these were nitpicks, but now I'm not so
sure any more. Given the considerations above, it'd perhaps really be
better not to trigger partition uevents. Please think about it, and
submit a fixup if you agree. I'll squash it. If we don't need that any
more, we can revert the part that exports
trigger_partitions_udev_change() in libmultipath.version. In that case
I may have to force-push to "queue". Still learning proper branch
maintenance :-/

Thanks,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

