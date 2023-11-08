Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2086.outbound.protection.outlook.com [40.107.20.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A9832C66
	for <dm-devel@lists.linux.dev>; Wed,  8 Nov 2023 17:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZPKROpW/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zd3P3vHk/j7DfQODeJxWbN+2eiRoPW4Dv9BMRDwfqS4+UNxFcUwXHpUx0D8TgRxqCmoRwX5AiFvWBSpNMFd0MWXJCzenSQPwHQima1Cm6jRDUzl/oD3+1rmHENW95xTT7osffToVH/BOMBnk5QE2lByzc3KtKkpRkIame17xtX7ITQUBT8nQ2ugnM512vigs0Yql4fXvngGDzZZoK9vOCNVlpf2G8bhsa9AC2+VOQKMBecBShh6K90iXmuk4eB6AM9tAwCskcicPQJWzHhgL3PbQl0it+ve9LCFhNXmIkerkB2v5mX4/b4GgX8C/+fajp/nmtGcEvFXYUORoBe5Ujg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQr6GKBVGGoR558PmNa63mQHhSgZzXNIgetV+Qq9aTg=;
 b=RLIo42o1LiPsxx/Ntk/kL6yblWyGcExBj8JiZJzsFI7D6B9yx4HhhK0rMTV5UZihsGAA5Jmpw5Ac6DA7vFHhJ4Gj7OSZ7vzkw5jE0AnkDjIbXSHWprrt3omBnwR/CJomDrbonFgqzqCBVFZExSrs2g9dsjmvvM8I9FP8Px5nECowhevtHUT32EffEWLc7/LvaXl1Wjr+Qb4r4mk5H6J+1iPFFR/32MA3O77tGD20e+5d8bjJArNW9QnZxKX5pimMVYHR+1b4ayEKZ92ahbXaVTe+ygTf8UqJYomD/cYedPGMRN+5y0AADqCj+bs0zIOiSwm/Y0aob04JWLOkV1I9SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQr6GKBVGGoR558PmNa63mQHhSgZzXNIgetV+Qq9aTg=;
 b=ZPKROpW/l2SymSasAt/LmMcjqh7+klWZyterV6nK+RzqOrPsG1bkz/0pzZfNw4ybwEw0qlYkxJVAFsEIS7EQ1px27Lt/0RBV0gCAQPCa5J9d55Pl8p0abKOMvDW/l0oUmNvK7dfVSF8sCRdtTwwNTTEpU9XD7yo9DQ8be2h692n5ikNtAPP43qiYl2fH5mbudLvtXH6OyDVnWqC1fD8TSlNDLLIWqN3KNg6LqdCCq1HO3U/IdBtek/tBIYXEDhKnR3cKYCFg3BOSMreJ7F2xbFb1oHAJ3pvELhfZUs2+N9RY0iYZAPWyT8AHIydPmSYM3usdOxQzXITOl4zhxuN2UQ==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by PAXPR04MB9492.eurprd04.prod.outlook.com (2603:10a6:102:2bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.10; Wed, 8 Nov
 2023 17:44:31 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77%4]) with mapi id 15.20.6977.017; Wed, 8 Nov 2023
 17:44:31 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 2/7] libmutipath: Retain device size if sysfs_get_size
 fails.
Thread-Topic: [PATCH 2/7] libmutipath: Retain device size if sysfs_get_size
 fails.
Thread-Index: AQHaDdoNWZ9CWMrOM0O9ngN75iA5orBwur8A
Date: Wed, 8 Nov 2023 17:44:31 +0000
Message-ID: <5d6482c9b9e96542286d7ce65f01633315707d00.camel@suse.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
	 <20231102221507.105371-3-bmarzins@redhat.com>
In-Reply-To: <20231102221507.105371-3-bmarzins@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|PAXPR04MB9492:EE_
x-ms-office365-filtering-correlation-id: 33a8bff8-1c89-4a9c-0e7e-08dbe0825d17
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 LHV+p8PWbi/uzoJ2R4zDv1G4QNBWTKGaWd+m+JKzfb6OkcnJwFHUDOTs7PjsWqy3rvxldgvMcF/VWZbngoNiDVvv1AR3ysrspvb9OJ9y8ITlMim5VRSRToSlOEilf++s3H+Z5Zz1HU40yrhlj39EV68Rphzq8IXHoqMUHYXp+rpcWIN7vLjGIXM4WoCSadYDm4f0wN6HDWcVVIF0aukpNfWbd03ZrP4jRLuJABYWxoVfSEuHtTd75xcKIJY3S7mOy9vEn9R2THRaUoS1GOvoPODombD5TaF70p4xTVJasuo3OyNH8Ptl/c9OfGq/cEPSX9Dcz7trx1+KfijRAx2aGHU1KFFIFg1vx9aXdBeXM+hz1MgdwhnlfFQHexURLjKpqExG468fTn5pCgw2aaa3ym/gwbFh29HdpCiyTA9/xpi21EquMNTd3YW5HU9NVNh11EqvB01LFSrfzmbaESmKc6YrIPKSNZiLVHd+Apbbv1XcMgP6ysT8S3DbhREjKY83IqxO6g9p8v4fmgUh9CPX5kxuOQbffZkGXN1LCuvOO520F5jhejpre39EsE1JomGx6j6XBSoXaPCYfz+aB+E9HVVhY4HAz7Df8DC4TsXkQh4PHokbZf1zc99D3g2Ibm4I
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(136003)(396003)(366004)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(2616005)(4744005)(6512007)(86362001)(36756003)(71200400001)(38070700009)(26005)(6506007)(83380400001)(38100700002)(122000001)(478600001)(6486002)(2906002)(5660300002)(66946007)(66476007)(110136005)(4326008)(76116006)(64756008)(316002)(66556008)(8936002)(41300700001)(44832011)(8676002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?BrbHetNOFA7agCiHFNqnHavwQ0MA/fsidLZJEdWs+okvu+fclhfybTTFZ?=
 =?iso-8859-15?Q?sblMrYL7r3j0Nz1/j/6ZcRa0wdkdPmpxiSDQ2DDjcgsAhIQd3DCO0F6Xa?=
 =?iso-8859-15?Q?DS+RcPKt7+jyTK7MNa9UHdVUfrsRcyHwnAjhPkjUb40ZKfpxW5kml4wDY?=
 =?iso-8859-15?Q?L2fxMPkPNbZO6vdwYHtwkq/3MxOi+SWsKgP79sQN9r2QBEW4yYYBL0d11?=
 =?iso-8859-15?Q?0SneuQSPesLw+TzkDQuVqjheODlOv1Yctge8LfNNENPk3dgByoRQxHONf?=
 =?iso-8859-15?Q?adkp3vWOdJmxiip/6GOcseco0XFzRJmWILNMoZlzZix8rHXhYOO8wHRsE?=
 =?iso-8859-15?Q?xcz9CdQj1Bm3gXDT5Pk/fET73tgRA1EQuxW5ub9SJgJkhXJt7DhV2wsvV?=
 =?iso-8859-15?Q?5zrynIingErWPi6DAXUl6vgkhi/5ioTq6nl5uacX6DideMXy/P8Enu+3T?=
 =?iso-8859-15?Q?TciemmMtvcglvu8qJoPippaDU607K+7koQPU90V3fwOCmWqEwiMmnpUHw?=
 =?iso-8859-15?Q?cDTG++f7M8DD++eWAXxcW5eSOVV8YcMykIiWWsQk8/PUcvhxeQl7OTC+r?=
 =?iso-8859-15?Q?3OpDCApPXZxa87XNyoZdYKxGq2+O9ODd96RV7EOrw5C8/NgRpL8GdvIfp?=
 =?iso-8859-15?Q?6K3t5mmPYVyCqz+dC+1nsYR6Suozj+XOe6peaa4izqtmm9ksnoHhJYnNJ?=
 =?iso-8859-15?Q?eeEy4QcqdJ9XoXjdTR/OKEY+uAHm7pZC2Hx6OFsrAoqpFpX6solF1ELkT?=
 =?iso-8859-15?Q?rTKSrmG1Zz616MFsgyAnXKxD+V5EQHM/PmwxI5SPstbWdht79n5hX/EFn?=
 =?iso-8859-15?Q?VM0EAfnbKAYY2/VSgSjBGsiH+NRY45AA5IJ3J6DMqeCrj8x+srHQ7HihO?=
 =?iso-8859-15?Q?HG/vI0fZeJYq6MklQ2MFDr3hxDTzI75KyDI4fCnPQaHGbznObHgIOLEOJ?=
 =?iso-8859-15?Q?C4AKfSRhgAUN5nBMWTwc0TZg0ZM1XsGAknPXtTvPdltS4UNYh924lpHql?=
 =?iso-8859-15?Q?8I3/ffrNoGIr1fW4IblMK44eMBQQrclu2p5R/BCC3Rh49Qjpl4p0ztMFE?=
 =?iso-8859-15?Q?f4170e98avOglrXsX0v6UnM6m+LbW8/dKj1Gke4A6rN/im3vBkZsqUViv?=
 =?iso-8859-15?Q?14NZQbuBX5zCTD1kHvG6LXNGYjWMv9l4GRxyB1Wx4KS/tKxvf8ezraQ26?=
 =?iso-8859-15?Q?Tzzx97m9IBJHsrSr3nw6vRIuFjVsImENUwzXYrzrI4XLcCOq/8JawghL0?=
 =?iso-8859-15?Q?O77wmLJDcNHVIKwXHbMIIa3Do7rfdgIVFZKkvaNjQDZfZYE7rQLJkpI5P?=
 =?iso-8859-15?Q?ciivtbhS9qIKUhDBlv5FeUtjljm4vEaJLurD9xIq+r9Z6MHvFV0gKkpeI?=
 =?iso-8859-15?Q?c30WJ94cRSybeUCBX8T6TjC+NMAdLTVp/R7gwNTb1hbcXgZllkzN9DDqE?=
 =?iso-8859-15?Q?NIH6T9nuSsFdCRyjla/wBpmV0lAt5LxzUg4LGijczRky9FkPkhSOoKMgF?=
 =?iso-8859-15?Q?STBhLg8yoHUosY6Z8H1s/khRwbuA50QU4gRWAfN9Kps6iKT2zMRz+1aIc?=
 =?iso-8859-15?Q?gA9LrvlLdrx4Qt4K1oJIJWSRxi4LMy3aCxzb7AmDLirYuXcw23fEZP1Gy?=
 =?iso-8859-15?Q?3u6g7IAoLb3Y6WzwXHlP7xYqkrDsQgfuL4jdQrZW2KBkDHwKufbSfCkDq?=
 =?iso-8859-15?Q?II35XorQV2/aWX0Q8ohpqgeVig=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <7917EC0544FDF041AB8BF32AB684749C@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a8bff8-1c89-4a9c-0e7e-08dbe0825d17
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2023 17:44:31.4984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iqXaB6DNnLzhBG0IqUQn4E0qPk1iTUY9q+fYgAvUBUAtn5YuEcQh5kqrc7hMOY1en9wdVbDtJxEcleFbKpJR1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9492

On Thu, 2023-11-02 at 18:15 -0400, Benjamin Marzinski wrote:
> When paths are allocated their size is initialized to 0. If they've
> already set a size, and a future call to sysfs_get_size() fails
> during
> the parsing, assume that the size hasn't changed, instead of setting
> it
> to 0. All other failures in sysfs_get_size() already retain the
> existing
> size.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmultipath/sysfs.c | 1 -
> =A01 file changed, 1 deletion(-)
>=20
> diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
> index c45296af..ad3d6612 100644
> --- a/libmultipath/sysfs.c
> +++ b/libmultipath/sysfs.c
> @@ -175,7 +175,6 @@ sysfs_get_size (struct path *pp, unsigned long
> long * size)
> =A0
> =A0	if (r !=3D 1) {
> =A0		condlog(3, "%s: Cannot parse size attribute", pp-
> >dev);
> -		*size =3D 0;
> =A0		return 1;
> =A0	}
> =A0

