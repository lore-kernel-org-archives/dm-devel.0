Return-Path: <SRS0=IN2R=QG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50197C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 18:45:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DDBB1610E9
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 18:45:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DDBB1610E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-Bsuo1NV5P9CTOoqm4tXkbg-1; Fri, 19 Nov 2021 13:45:31 -0500
X-MC-Unique: Bsuo1NV5P9CTOoqm4tXkbg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B1E8425C8;
	Fri, 19 Nov 2021 18:45:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B809A5F4EA;
	Fri, 19 Nov 2021 18:45:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D9AF31832E80;
	Fri, 19 Nov 2021 18:45:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AJIjNco005150 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Nov 2021 13:45:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 91AF6404727C; Fri, 19 Nov 2021 18:45:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BD364047279
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 18:45:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 707E01066683
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 18:45:23 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-158-2PGG26n4P-e4JnsbNnTDAg-1; Fri, 19 Nov 2021 13:45:21 -0500
X-MC-Unique: 2PGG26n4P-e4JnsbNnTDAg-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2168.outbound.protection.outlook.com [104.47.17.168])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-29-NV5vIKpbMFqQcF9L0iy2nA-1; Fri, 19 Nov 2021 19:45:19 +0100
X-MC-Unique: NV5vIKpbMFqQcF9L0iy2nA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB5754.eurprd04.prod.outlook.com (2603:10a6:10:aa::32) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22;
	Fri, 19 Nov 2021 18:45:18 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4690.027;
	Fri, 19 Nov 2021 18:45:18 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 0/9] multipathd: remove udev settle dependency
Thread-Index: AQHX2/kcqYz9XADO80u4JTNgHS2rlawLMz6A
Date: Fri, 19 Nov 2021 18:45:18 +0000
Message-ID: <af93151d05bbbf4e3334c25f410e9606f8012b4e.camel@suse.com>
References: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b8d2b5a-d659-44db-4313-08d9ab8cbbdf
x-ms-traffictypediagnostic: DB8PR04MB5754:
x-microsoft-antispam-prvs: <DB8PR04MB5754413C30D3925968C9B706FC9C9@DB8PR04MB5754.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3B0g0S908D0NAJ66tLpAdH8Dy0rzUj4hdFKY9lXN/33M0Mz1DheWERHlxLqME1rkWGtsaD688GAf3FMO3YjTyrnPFOcByHoivFYAS3DPPCf/WMm4zdeRWx3GKKP/mRteb7Xfta9ltS8GNasFZl+Z4TpTpIqmdNNqY2wlpg//2GsTYCVTGjaWbyWs/irh1yfmI3BVcf/aJ201j7GN8y2KQAdYkQM+WHYQAHUj93YT3kguexWSv4Bi9v6F0YiDk9VgMZzMg+5KVncCUkGBEgZwSMDf7TK/49/fia0e7zL/S8C5Gdb6f075dSB5VqqiUESYfpJEGRkFm54SMKgpOSwshHJUgzu6rjmE9GZLXKs3nEt87nq4CnD9ymCVzer+LUhIHs2tDQ1mFDxpkenqErZmx/jy3rSKfsFe+VbdZFyi+CxzjB8tY7MPLWodT44uz4JShHnt3zx6v23K+lvdhOeYS0D/wVknLugTljnCEH2MzlwnoX3+SkteQn8Gj/C5ORDVAzIIOtIN29dYmrQ/DdH50MUU+jjWIVDJ9VfldxxJg7Wbzfr5b+DdyncbkGG1h5xA1idUm868UKl0fUAq9yQspVaQdHZbEsmr2lvYebMWPUG1qsnIx6YmYLyLJPuT2czd5QF3JtFVoDkc2xsNkUgnbS1CjoaodP+m8RSybeIUrHyqgf78IqiKfsadtq/dK+NYVwSVPj005lhyldgn0EY7OA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(110136005)(66476007)(86362001)(83380400001)(64756008)(8936002)(66446008)(66556008)(316002)(66946007)(6486002)(186003)(91956017)(44832011)(4001150100001)(38100700002)(2616005)(36756003)(4326008)(508600001)(2906002)(122000001)(38070700005)(6506007)(8676002)(5660300002)(6512007)(76116006)(26005)(71200400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?264Php9PQc3DV0YcuR3AgKN+a+a2UhkHXMdEzPPtbb+tWuF6ftzAURWPa?=
	=?iso-8859-15?Q?4jMw1r6UbzNdr6GXjZ975Grzku6y5skbUlm26WYFd6dwl8b4QKbGZAqls?=
	=?iso-8859-15?Q?eFnUArFraJN4XssclNAzw9waBT68UDsgHwGILZ8lXWOB0X4h4Ux+c2jVm?=
	=?iso-8859-15?Q?9QgIpFhNY2XAINJOu9jH4SjDglIqHsCILgGCOl8qTwZ5Coc3a9ZKIBwAo?=
	=?iso-8859-15?Q?z1qp8nEpbDzpGve8G2eTs4vp/C6GaqG/hyhhF2zQEQFkFLW4sQe+5u/Qp?=
	=?iso-8859-15?Q?e/rilAiUYzLIQqyam6MiUClaKQSWbn72Ng5xdfnotSXen0r5jG9ZglS/n?=
	=?iso-8859-15?Q?KQHNgO1z7ycLmXN0uRsViuVmNDXHvahysn61zk1kGZbnSlavfbyCwL3Y3?=
	=?iso-8859-15?Q?rn0aewhkKwpMVK8u9xj6ksiWB3buoqNRZa4wgKt4Dyk3aBoAuauK3FAqK?=
	=?iso-8859-15?Q?rtxyZ5QXLWOFQ51JkPigg4btf733FMq8Snl97airuIL+3uSVd76Oha74d?=
	=?iso-8859-15?Q?GGATC3L82c+VQJj9Jg3o4kUDKh/GYPZH5i042avDbewcyIZ1Xa5Wwu7Fr?=
	=?iso-8859-15?Q?03I5VaPC2reTiOESAmqgFTLgIox7hylS+VIguFOlPu1RdAYGgE9UI3+lk?=
	=?iso-8859-15?Q?4ZnWMD/N1lDYf6DC9ZdRhOnX7aNGgWsX5PUsZvZUUtG/w7xVe7jgtLdFC?=
	=?iso-8859-15?Q?oSy8zQVrLI1RWPCCk/w30r5niVopY+35kjEezKx1zd6t3CcWjG86SbPnt?=
	=?iso-8859-15?Q?/Ru5YFb7zU6krorkLpQ48UMk6+h60heoDcApHSIH27ndILRg8XPyqQPpV?=
	=?iso-8859-15?Q?2YMqvAxIKDbER/DVweWwQZD8N74eohtklbM4qcJWGtIaK+IHDwIob8yHM?=
	=?iso-8859-15?Q?Kt4o7Lwmhr0SEsbsybJuWBqsfYTmuLGxI8hbjYqbPGXVXMD2cNS9KHuT8?=
	=?iso-8859-15?Q?be6wVBie6gUbu96Izscovd7VUJLmu+SZaUGEeaDiZCXROXtfGYYgefCsq?=
	=?iso-8859-15?Q?9g0uNQ0Gf9jyqKJhbdqOOsFRucQdt5o1IR2+JmKl5uyqfSKPbPyL2Y1eB?=
	=?iso-8859-15?Q?+occ0pJaWE/DG5D//UvqrN/v5xoLt1pk6Kg+6Z0PQirSJ+QPu8NPDJlpq?=
	=?iso-8859-15?Q?W3+/L3OgAAE2YLK+C/ACGcEsgdk1uCDX/g/KgF1HJgCUPKWTVeuj8rHxY?=
	=?iso-8859-15?Q?G8Ka7xC47vsfA8j9UQa0MoV8SRrNZGpbRKhnMYpnfiKbaDTPNb0t8TAYQ?=
	=?iso-8859-15?Q?zB2Z3W9Do/rS8DdupWqwPR4KjyEQdL+Lpaz4/RuhDY4YOW+btBtDmg+B0?=
	=?iso-8859-15?Q?YvzbeUzjz5w9CxA9qrDbTKT1TD+Pvz9/YGO0fIB4uwSibXjKztAl5oSVs?=
	=?iso-8859-15?Q?5QQjLSACEc1Q9oIpFQBG0GvS49BwdtmILpkCyrB529Wxggir+xTAqGNJt?=
	=?iso-8859-15?Q?Wm/xdornJbCr5OleQzLz6ZtQo33yK7B7djN0wVGxXGbC4h2/IX0gRG9pg?=
	=?iso-8859-15?Q?ILGr/N3fM7b+fOVD0WV0+ie5/+WWA9TY6qBl2hkWAL0OVpAJP75vygw6A?=
	=?iso-8859-15?Q?OpyWxXTt2W3uTIUjzlnv6Brp6t2qzneDD30y/sF+hNeo+ACiThcanP3eN?=
	=?iso-8859-15?Q?4IyfcAQWufe2JIaOI235nHLDUIpogF5dECoJ2ZsHHu064g5L0C9uoFTWK?=
	=?iso-8859-15?Q?KgdNdvK9bzGAf2+3sKi4qQ9n4fivKDDqC5FHZoHUOS1NdSA=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b8d2b5a-d659-44db-4313-08d9ab8cbbdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2021 18:45:18.4308 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e/SebDsTV0nHmJKo/6qVjul0qJA7Ko/wBjIcGBV3grKo9dn+fZO/+SOy2xDK4/AjXfEqqgSMUSzEbNyBIUVmmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5754
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AJIjNco005150
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 0/9] multipathd: remove udev settle
	dependency
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
Content-ID: <1784BAFF213F0F4FB5063C3D327D674D@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-11-17 at 15:21 -0600, Benjamin Marzinski wrote:
> So, it turns out that commit 4ef67017 "libmultipath: add
> update_pathvec_from_dm()" already does most of the hard work of
> making
> multipath handle the uninitialized paths that exist during boot,
> after
> the switch root, but before the all the coldplug uevents have been
> processed. The only problem is that this code leaves the paths in a
> partially initialized state, which doesn't completely get corrected
> until a reconfigure happens.
>=20
> This patchset makes multipath track these partially initailized
> paths,
> and makes sure that they get fully initialized, or removed, as
> necessary.
>=20
> The first patch is a tangentially related bug I found when trying
> (unsuccessfully) to recreate multipathd's problem with dropping
> uninitialized paths. Multipathd was not removing completely missing
> paths from maps that it found while starting up. The solution I chose
> was just to make sure that a full reload will happen on these maps,
> even
> if a weak reconfigure was requested. However, this means that
> multipath
> still completely ignores these missing paths. A side effect of this
> is
> that "multipath -l" does not show these paths, even though they exist
> as
> part of the multipath table. The full reloads are necessary, to take
> care of issues that update_pathvec_from_dm() can run into, but we
> might
> also want to think about marking these missing paths as INIT_REMOVED,
> instead of not adding them at all. This would make "multipath -l"
> still
> show them, until they actually get removed from the table.
>=20
> Patch 0005 makes sure to fully initialize the paths when their
> coldplug
> event occurs, but if the path is already fully initialized in udev,
> but
> multipathd finds out about it from update_pathvec_from_dm(),
> multipath
> doesn't do anything to finish initializing the path and moving it to
> INIT_OK, besides waiting for a uevent or a reconfigure. Patch 0006
> handles this by triggering a uevent if the path has been in partial
> for more than 3 minutes.
>=20
> I've tested these patches both by rebooting with necessary and
> unnecessary multipath devices in the initramfs and multipathd.service
> set to make multipathd start up at various points after the switch
> root,
> and by manually sending remove uevents to unintialize some paths, and
> then starting multipathd to test specific combinations of path
> states.
> But more testing is always welcome.
>=20
> Notes on v2:
>=20
> After playing around with the initialization states a bit, I decided
> that cleaning them up is a bigger task than I want to do in this
> patchset. This set just concentrates on cleaning up our handling of
> paths that get added in update_pathvec_from_dm() to allow us to
> drop the systemd-udev-settle dependency.
>=20
> Changes from v1, base on suggestions by Martin Wilck.
>=20
> 0005: Made cli_add_path() verify the wwid can be gotten, and hasn't
> changed, before attempting to finish initalizing the path. Also don't
> intialize a path that relies on udev if the udev device isn't
> initalized.
>=20
> 0006: New patch. If a patch is in INIT_PARTIAL for over 3 minutes,
> trigger a uevent on it.=A0 This is kind of a long waiting period, but I
> want to avoid firing off another uevent in cases where the problem is
> that udev is in the middle of a uevent storm, and the expected event
> is delayed.
>=20
> 0009: Repost of Martin's new init state wildcard patch
>=20
> Benjamin Marzinski (8):
> =A0 multipathd: remove missing paths on startup
> =A0 libmultipath: skip unneeded steps to get path name
> =A0 libmultipath: don't use fallback wwid in update_pathvec_from_dm
> =A0 libmultipath: always set INIT_REMOVED in set_path_removed
> =A0 multipathd: fully initialize paths added by update_pathvec_from_dm
> =A0 multipathd: retrigger uevent for partial paths
> =A0 multipathd: remove INIT_PARTIAL paths that aren't in a multipath
> =A0=A0=A0 device
> =A0 multipathd: Remove dependency on systemd-udev-settle.service
>=20
> Martin Wilck (1):
> =A0 libmultipath: add path wildcard "%I" for init state
>=20
> =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 +
> =A0libmultipath/devmapper.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 +
> =A0libmultipath/discovery.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 7 +--
> =A0libmultipath/discovery.h=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 +
> =A0libmultipath/libmultipath.version |=A0 2 +-
> =A0libmultipath/print.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 21 +++++=
++++
> =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 9 ++++
> =A0libmultipath/structs_vec.c=A0=A0=A0=A0=A0=A0=A0 | 41 ++++++++++-------=
-
> =A0multipathd/cli_handlers.c=A0=A0=A0=A0=A0=A0=A0=A0 | 35 ++++++++++++++-
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 71
> +++++++++++++++++++++++++++++--
> =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=
 1 +
> =A0multipathd/multipathd.service=A0=A0=A0=A0 |=A0 3 +-
> =A012 files changed, 167 insertions(+), 29 deletions(-)
>=20

For the series:

Reviewed-by: Martin Wilck <mwilck@suse.com>
(You may have noticed by the tags in my re-sent series yesterday).

I still have to give it some more testing, but it's looking good so
far.

As these patches are based on top of my series, I'll apply this (and
the "reconfigure all" series) to the "queue" branch when that series is
finalized.

Regards
Martin






--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

