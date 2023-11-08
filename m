Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2086.outbound.protection.outlook.com [40.107.6.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEDA321B7
	for <dm-devel@lists.linux.dev>; Wed,  8 Nov 2023 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Lc5Vmje5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDE4zLWjmr0UIJbOvXkU+OZNSPYU/GmpyLzRAljrks6Ru1/Fdt2lqz5bo3ovXha7PrZGsMSj5NUSo47Apnw2sXY+BjkQyyqhVMNuThMpWGH8m0YvL5oED1Nx9Ah017ZYwRXvdQ/OC2lFlN+fTg1xDNOTwMkCMxMs3FcQLDlR9WEyqxUyjV0pJAew7uobP9dIdRmE5zw2V8Raa69547AK27B1q9nh68XJiE4LV3S2eeoCmpqDAqMqLkc7f49CmKoULHbYYmV6uTPm2ueJFM3PXJOtIiwH9bymiPPD1Lcug+LAq+PVWhklC/NvM0oUgxGRgHAbi0PshalyDLZ0ZvAUNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0sjt71GIRbWYnFftLl0YSr1nwfwFHQxnhB6Xi8a7fs=;
 b=mQqTYJuD74SYs5ufLLYNllkuIJ9i0AhrhbMTBLAXbmKwRdgIkbhaYWEgU4ccQuX13E5ccFkoFQe4+BkbXQY0mH5Q6ztNxBGvcLIgLDanYC5GsBG+4eKOXRDkki/KlkXF2EzmenkiSvOewVDN2+Eu0aIpOiK2atY9NJdOHuZcgi46vnkZQfBLna/5z6rmcS+GKm5zfF+ZfdLnOQbnPGV6t1RaDTqu1grx80UF8g2uzIszfw8ntOfJ8q0+UlqZvZ4mP7SZA/bw9oabfmHO4E8t43Oa+oMxTcw2ndU/ZNDVxlGVh1hIQiumCqZRCnMOYf4QEdoxkd4t+g64QkNPFja0sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0sjt71GIRbWYnFftLl0YSr1nwfwFHQxnhB6Xi8a7fs=;
 b=Lc5Vmje5UM15elIGjV+AklKr5ALtmwLyns65EA7i4ybF6nMuImX8fN2OoulMzKmTaQFb0DTOwuoWZskcv8zS/5yViOdjOKkUgBeMF3w/gqLbpxMGbU5Vdzm58rq1FGMgX0egbXoTKnu8fdEyo1uMrgtw07C7xMYJKoWVC4JZAClFFhYCpz5RQGzuLoFwqfPgb1RK+40PfDlyYd0VnlTs/GvVjJ6YFUxbkbBAbkfBzOHWN7tFmGW925qxMw7Nkz/Y1N+nmkc9C0lq/UJES/5WzMV6a0ovtYKXwf15p/OXudqGTj9B5ijbVBUZyOQm0DKLlVUB7ltq6dWqVfhI5R7Sog==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by GV1PR04MB9119.eurprd04.prod.outlook.com (2603:10a6:150:26::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Wed, 8 Nov
 2023 18:07:36 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77%4]) with mapi id 15.20.6977.017; Wed, 8 Nov 2023
 18:07:35 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 6/7] multipathd: Add auto_resize config option
Thread-Topic: [PATCH 6/7] multipathd: Add auto_resize config option
Thread-Index: AQHaDdoOV22Q+6UJpk2/K78kAMgs67BwwTEA
Date: Wed, 8 Nov 2023 18:07:35 +0000
Message-ID: <a79b2b7777bf811ae7410b594e7e9f37f4ab073a.camel@suse.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
	 <20231102221507.105371-7-bmarzins@redhat.com>
In-Reply-To: <20231102221507.105371-7-bmarzins@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|GV1PR04MB9119:EE_
x-ms-office365-filtering-correlation-id: 6150eced-c751-45c6-313c-08dbe0859639
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 6J5gZl4MjC2YV4GCm/T9p51Bbni/0ykluvTjupjGOHJEogfbEOdop6yoR6AtXiEMd1J6+V4+xImatRS36tWVj7qvnHO920x98A4GL6b1fQkvWVfVsN9xX0hKiKW2Ma/mGwIBstsdeij1Wl9scjuxOnjMcEH8GqlWtlWz54slcQTxFGbcKZdDAIOPQ1/YbE6nU9S/YVQrWxk2LodJqsnsU8IsNn86ZDmnLywnSCNLg5uwlxJehCX8RwBpXXZmjv/BCROuZllEve+zXZYubn6DK/TgbiiNuCT9UXGDZ9S1cyX+9KzuEUlvuu4jgubrDJuELg/DQN9PnMSA4OlCOgsN3vXoUcq/rUnn66vQ7IVSd7eX0/eJFSOd6u8orvcnPVqFK9+SEAM2hX0SfyJo3tNXdgicSzwnuM8WF+msuq30DCRWNbUHcHiR7W9PBpYr1twzKbt3OisnfqMXj/atUeHVmt9gGCmxeItKexrlMUcIIPLE3xyjsusRooFrU13NsnpQJ2cIiLvSbII0OXVqCq6parSIzPZuWUcnjcI/noMr/8k3e3hWCnryLWp7XhzOdSmuGaCJb0hya9TR5AI2qiQv8slVS3dPrQa1dnWr4XoDnebDLYIbylPDP4SEq6QXRvK5
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(39860400002)(366004)(346002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(44832011)(41300700001)(6512007)(2906002)(5660300002)(38100700002)(86362001)(36756003)(64756008)(4326008)(66446008)(8676002)(122000001)(76116006)(66556008)(66946007)(66476007)(110136005)(83380400001)(316002)(2616005)(8936002)(38070700009)(71200400001)(6506007)(26005)(6486002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?6lX4wWmO9S2GhNVWJ1YTT3ve1hX5UB9uepU1Zl3/JmviCu3brApx2KYTK?=
 =?iso-8859-15?Q?hvyLpXZjLl1Hrl97gz+2TQIYrF2q1LKVd2OGJwoCskk3zGWrnlnhw7co6?=
 =?iso-8859-15?Q?b2b9HwRtaayJ8+aY9gRhYAvynJwITDN5CLXLW6ss4CapBBb3TM+5ClBI9?=
 =?iso-8859-15?Q?dTemOxF35AKbAJMzWbXbUZoJKWx9yLSvS++Ci4JRvNEDcVhnsqnSM75EX?=
 =?iso-8859-15?Q?0bhHje8/FZ4hvL+2sRPMNuHpKcWirIr0nELDDRiqXyvTXUMQwYXmYhGqg?=
 =?iso-8859-15?Q?BM/qq0mS1ng1PGyMLTkTrfDDu2P9PpqC+xa+MBTZ6tvNjdPEQPrn8JHpb?=
 =?iso-8859-15?Q?HX8xXZQfaIs2WD+WGpweCdWD13uoTNRrkKKjVDERpA36HpwUb8fZUWtOW?=
 =?iso-8859-15?Q?yRbhX6AQUrVbm9R0ZvdZRiBtDDAE9LpHX2Dw6aUvF7aFZC6HfbFQlt9R3?=
 =?iso-8859-15?Q?4+TTd6lIkGZeI3CwzM3ZJnPvG79hRfLGmzXgdjchwCLIUAmj5sdTTQe5Z?=
 =?iso-8859-15?Q?h5fHyqurBN8aTIGAiNO9cT6RGeB6WROc5TGzqdXR6lYsTblfauE/Rss7O?=
 =?iso-8859-15?Q?WmPzxCSZ56EsFduy/NIgHvYn35Mb2G8V70v+t4L6+JkU8zGeFEpD/tl8k?=
 =?iso-8859-15?Q?9eK7sUX9dgsxKtjVzZi4GMdjQFFRSPUhE7QGyYV+TcbsTJ0MRlm+4Jhpw?=
 =?iso-8859-15?Q?ZnmzvEYpC/j6jxMTcCv9ItBrJUufn4DnIu6kgbDvh0tEmGyBuVmRrXvxQ?=
 =?iso-8859-15?Q?pg7SI/beTuo4Dw0VvAjZLBJByW1TsOz3ORmY5Z395Warh56wuCRx66GEJ?=
 =?iso-8859-15?Q?S0Q0gWkKe9yqHoF+uiOjdULFJfzUuT0MH4dxo85LVut4j0A35z1ZU0liQ?=
 =?iso-8859-15?Q?M2IbJKX8juc8I4CxqkzIYllXUX+hZBfwTxsSEegrGWd/M6HzNjHw8wDs8?=
 =?iso-8859-15?Q?NayquFuo00rGK176cn5yLUFculLJgEkF5vgVBgEzSLGgmvTF1irMRNpvo?=
 =?iso-8859-15?Q?tc9qK/R+C2i5b2iI3QNx7XteJvI6XdXdFkXhs++1CMptqxlKICatH+B3H?=
 =?iso-8859-15?Q?5fWUunsUBAd+qpnbCWNykJFS9SHAVDIt5diWLuTi/DZXWi5PSeVFgVNRf?=
 =?iso-8859-15?Q?fiejVuKd8hWlOw1CiwTyWSo74doHt7j/UH9NTNaBi+F58tpShqqA/x17b?=
 =?iso-8859-15?Q?2fK7k+ll7jc5hrm9Cm8Zhkm2SNkN1KnJ5N6spIhEUIBFT2ewmIbIo1wgb?=
 =?iso-8859-15?Q?1pxmNAzRU9w5/sgOPmOelLqo1UaQjlkR25Ofn66dwSp/qNECfXmXHnXzC?=
 =?iso-8859-15?Q?kSSIBURh4D6KSIrxyE4yQlcTNT6iGlcphmf1ZU02j8rFk4mqUtH0oQV8x?=
 =?iso-8859-15?Q?EeLVuB2HFcJUP24z3JEThVltchqqyB+j3DNaK8WDPVKIodJq883pncYbN?=
 =?iso-8859-15?Q?iqwRWVCdFHkhpF9pkFxAjcOdtGvYFIw0IpF5+oWcOF1gVtzG8w+88V8wl?=
 =?iso-8859-15?Q?hF47btBrIr2NVpkhgooVvFLwxvvxEg+rNXD7zWRGPThq3K3sYmSfLQmUs?=
 =?iso-8859-15?Q?13IvfVpNU0utxkEeEcIE5siVtPV/7kGZ6tUKm4VXYdssM6Y0omPspOipD?=
 =?iso-8859-15?Q?XnDKz2uc6wJTec3yXQws1dBIWTelDNtarxsFbPT/8QU8RjpALrnGrsiQ4?=
 =?iso-8859-15?Q?01rZ2KRHIWT2RfEpualkxax0BQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <D7BC5A666895A040B926264A615F07D4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6324.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6150eced-c751-45c6-313c-08dbe0859639
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2023 18:07:35.8092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mGmVjM8U7rNX4x1Vl4Rd9wJD60xkfsgPjSheQyBbtllgMruCh1vur21HTLGGV9Ms2+sXxIXPgTjn3apNLfUiLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9119

On Thu, 2023-11-02 at 18:15 -0400, Benjamin Marzinski wrote:
> This option gives multipathd the ability to automatically resize a
> device when it detects that all of the path devices have changed. By
> default it is set to never, and multipathd will continue to work like
> it
> always has, where a users must manually resize a multipath device.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/config.c=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 ++
> =A0libmultipath/config.h=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 3 +++
> =A0libmultipath/configure.c=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/defaults.h=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 48
> +++++++++++++++++++++++++++++++++++
> =A0libmultipath/dict.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/hwtable.c=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0 | 17 +++++++++++++
> =A0libmultipath/propsel.h=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0 |=A0 8 ++++++
> =A0multipath/multipath.conf.5.in | 16 ++++++++++++
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 24 +++++++++++=
++++++-
> =A012 files changed, 122 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 9d90f512..e6024955 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -464,6 +464,7 @@ merge_hwe (struct hwentry * dst, struct hwentry *
> src)
> =A0	merge_num(ghost_delay);
> =A0	merge_num(all_tg_pt);
> =A0	merge_num(recheck_wwid);
> +	merge_num(auto_resize);

Why make this a hardware-specific option? Isn't it sufficient to just
set this in the defaults section? I can hardly imagine users wanting
auto-resize for one array and not for another.

Other than that, looks good to me (one nit below).

Martin


> diff --git a/multipath/multipath.conf.5.in
> b/multipath/multipath.conf.5.in
> index 41f3927e..c90383cf 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -1333,6 +1333,22 @@ The default is: \fBno\fR
> =A0.
> =A0.
> =A0.TP
> +.B auto_resize
> +Controls when multipathd will automatically resize a multipath
> device.=A0 If set
> +to \fInever\fR, multipath devices must always be manually resized by
> either
> +running \fBmultipathd resize map <name>\fR or \fRmultipath -r
> <name>\fR.=A0 If

I suggest not mentioning "multipath -r" here.

> +set to \fIgrow_only\fR, when multipathd detects that all of a
> multipath
> +device's paths have increased in size, it will automatically grow
> the multipath
> +device to the new size. If set to \fIgrow_shrink\fR, multipathd will
> also
> +automatically shrink the device once it detects all of its paths
> have decreased
> +in size.
> +.RS
> +.TP
> +The default is: \fBnever\fR
> +.RE
> +.
> +.
> +.TP
> =A0.B enable_foreign
> =A0Enables or disables foreign libraries (see section
> =A0.I FOREIGN MULTIPATH SUPPORT
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 3b4c5b09..ac733491 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1633,7 +1633,6 @@ uev_update_path (struct uevent *uev, struct
> vectors * vecs)
> =A0		ro =3D uevent_get_disk_ro(uev);
> =A0		if (needs_ro_update(mpp, ro)) {
> =A0			condlog(2, "%s: update path write_protect to
> '%d' (uevent)", uev->kernel, ro);
> -
> =A0			if (mpp->wait_for_udev)
> =A0				mpp->wait_for_udev =3D 2;
> =A0			else {
> @@ -1648,6 +1647,29 @@ uev_update_path (struct uevent *uev, struct
> vectors * vecs)
> =A0				}
> =A0			}
> =A0		}
> +		if (mpp->auto_resize !=3D AUTO_RESIZE_NEVER &&
> +		=A0=A0=A0 !mpp->wait_for_udev) {
> +			struct pathgroup *pgp;
> +			struct path *pp2;
> +			unsigned int i, j;
> +			unsigned long long orig_size =3D mpp->size;
> +
> +			if (!pp->size || pp->size =3D=3D mpp->size ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 (pp->size < mpp->size &&

There's a whitespace issue here (space indentation).

> +			=A0=A0=A0=A0 mpp->auto_resize =3D=3D
> AUTO_RESIZE_GROW_ONLY))
> +				goto out;
> +
> +			vector_foreach_slot(mpp->pg, pgp, i)
> +				vector_foreach_slot (pgp->paths,
> pp2, j)
> +					if (pp2->size && pp2->size
> !=3D pp->size)
> +						goto out;
> +			retval =3D resize_map(mpp, pp->size, vecs);
> +			if (retval =3D=3D 2)
> +				condlog(2, "%s: map removed during
> resize", pp->dev);
> +			else if (retval =3D=3D 0)
> +				condlog(2, "%s: resized map from
> %llu to %llu",
> +					mpp->alias, orig_size, pp-
> >size);
> +		}
> =A0	}
> =A0out:
> =A0	lock_cleanup_pop(vecs->lock);

