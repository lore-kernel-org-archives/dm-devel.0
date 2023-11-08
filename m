Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF1732C75
	for <dm-devel@lists.linux.dev>; Wed,  8 Nov 2023 17:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DSFN2MiU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJRjGJjQeDQ7PoCzRSX/nRDK/vGhdF4MQVt9QPeOE5oiwBWPS0/mlGS71tsiu2Ha2avemTx+6O47OzkmALMi1hUfIxyiyagd4LHWSpIBI5hIpUFledTVj5lq2FqPbTSIv0I9tT5NBwWW3W5wfxEYN2F6N2JhHZz6Fl9h49jiyoBqjGPs9Led+kV94GywlXdhPkgsDYWSnzf9iOGBHBfVi3+WpuKBaXoTXS+KlScYa3EpiNx0mc4pFF6SRzfGYdWAuKFpw1NUJPu/sAwJ1sLk/BZ718bvgpXGrFPID/CQXFmwK2Ukm1GzAlvCfrYKxAzM/CnccrGn9Ay4qHSXAxGHCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Gkye4pBbDKDx+70L8sIe6pSuf8/BI7hAjxQaNoPKS4=;
 b=e5bq5OLBu6pRTwUp0nXfOVfAHiWpvFO5XHwosDJG6607NaVJepDnVZOJOjH6l7n2wngzdMan5Mkew9f2r61JWO60985y+PBgqfnp+d2a3yoy+od46p4QdS2bBWAgFz9UbETDIODCFuUxV99gTPDIHTXLWM+IBBQyT+LX+yka6mQ3JR7MbEljigvxnKskbrJmf4yMaMWL7wxbxeIWcgZS8c+6fpFCe1ugdwo/UQ124SP7N0T5zzymVxdhxhDT0oWd47A8eCX15T/YHIrC9LvbqwX3mGCOchTIxm3+n8u/vmtmBkwk1yz5B+endYMdUCuwPHod1lGkNjiFzlhvmCq77Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Gkye4pBbDKDx+70L8sIe6pSuf8/BI7hAjxQaNoPKS4=;
 b=DSFN2MiUNCGvYuSkAzJPnlruYq/vT1aSDOrSDYntpo+yn/bzh04kCrG5XHHbQkx02np+xJaSi+NAtc/lXHg+rCuXYpQT8xWqOihrvGAy3VGoGBkfwHFX1w2Y0wNmJIlNGnIOjXiFhl745NLJxyYS77gZlzd082QjQTlLfGdLhU+6eA1bgEwYBZjNQPi6k4x/tsztzgBRCZJcpNSYP1zOo72Jhs+7R6LH+qzRWxknrBaOW4zYoWcOBerWVLUxWDNRIGem/He2byNvp1VNL9P0/MQGUuC/T10GNGGHerXNmkrpazvQe2ZMdT7bSC8lTw+pE5qzL/DDsxyaHak6O4Q4fQ==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by AM9PR04MB8180.eurprd04.prod.outlook.com (2603:10a6:20b:3e2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Wed, 8 Nov
 2023 17:58:22 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77%4]) with mapi id 15.20.6977.017; Wed, 8 Nov 2023
 17:58:22 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 4/7] multipathd: move post-reloading commands into
 resize_map()
Thread-Topic: [PATCH 4/7] multipathd: move post-reloading commands into
 resize_map()
Thread-Index: AQHaDdoMI/+CucGeC0qXCqbPv0E2qbBwvp2A
Date: Wed, 8 Nov 2023 17:58:22 +0000
Message-ID: <4104cfcbff93136cc58781211b40b140c09ee724.camel@suse.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
	 <20231102221507.105371-5-bmarzins@redhat.com>
In-Reply-To: <20231102221507.105371-5-bmarzins@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|AM9PR04MB8180:EE_
x-ms-office365-filtering-correlation-id: 21065e31-3fff-4f48-6818-08dbe0844c9e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 duw2G6kJ2ypZB7421fcxsiFPqztIocV4wd0EyDOdNMuqyQCPoENadyysZBKk6fhq2tthe7WvC/VXTSjc5JZznXeOc1CwLs12pfws2yzw9eUdlS6NoZ5wFrwEN2zHiC3lYk5ceXDkAmr3DUeeOdb2cNCIuvdUrcA0EPylDhH/gKqDLWgZ+fZkbNK4+5r+QBltN35s7GS8r4sNElXQ1Ddp5VxPjnnzsh7HtryhDm5FArmQKzN12vRUJZ4SCiU31Q4LUJSRQe8f025LJkDcG10XLquvH2fHjzF8LhaMHWX/V7DnUu74d/nY/auEHjSd8Ayqkd3yB9aD8jej8I4zLAdQbTvCrxy8N06YCBQc7nyCvkG6yrTmgvb29QioD4+gbzE8E0QK9nTx4VbMW27LmhZBTXMcp8cKMVDML5adxRFB0GuK5PFN858WogP88nDMary2S3cG1ZyucZqqpojp2muCPYhegkTjavKHhCyB+2D505RwmOrD/hLO6WQBryzdRBRARrxgQ8VzcdLkwkxJHvzVeiaoU53ARnN7SvQEe924VSCVHQ6wdQ1rdL1+AIiY23f2xDyJK7aFHrI5eVIAT3b9wYsdhHHgsX62a5tj3h08e8KgboocQYRIOrTmcsaPAtfo
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(136003)(366004)(396003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(2616005)(6512007)(478600001)(6486002)(71200400001)(26005)(2906002)(4744005)(110136005)(44832011)(316002)(41300700001)(66556008)(5660300002)(66946007)(76116006)(66476007)(66446008)(4326008)(8936002)(64756008)(8676002)(38070700009)(38100700002)(36756003)(86362001)(122000001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?pjo8EG/py1lOIbiRMBwsRlPtfSKiFwFbzlkwAGNMdOmbsxPBpztxMr+7g?=
 =?iso-8859-15?Q?Y5bGSgvnLrH5HnCkaBY6CfGuLO9lqiAMEGwdTpzSIATI+sOpoGhprIE0z?=
 =?iso-8859-15?Q?+hbgV+nd00IoOj9DGBJ8SwV82Znq/+KAvaT7+ny0p+6tMDyvaYnMFRoi3?=
 =?iso-8859-15?Q?UL2+vi0OtPGPVweMjNL9ufEMYE/gLyCnI5zzfkMLC2ZSUg3SUF6sRFNyi?=
 =?iso-8859-15?Q?yPWaLbQ9KQPXm02Vqcoubo85WtY7pTgpCsW5wQ9ezY5lVYh8tzYY5xgf/?=
 =?iso-8859-15?Q?Df+Qr3kSdpaH2iKDBiV6X9A/yMalfWR5J+kNMxXClxQYqa95vhVLjioQa?=
 =?iso-8859-15?Q?Cavy8Evyk2SEI6+VX1jZfwNTCWPIwHS0O6X/sf7xPDnC4LqYnK8LCIpIq?=
 =?iso-8859-15?Q?dNNhXIQp7OE1Be30Lj7E95k06h96P0I+3AI6g2TCO5XR8svyK54IxCbye?=
 =?iso-8859-15?Q?3ed5bCgadGVMZZQGtIOYKjoIf9txZijENj7S9PIQaFrtNQwRN+YATS9iz?=
 =?iso-8859-15?Q?3mJCRn16u0mwlE9UyQIEeiSSKtfpMDXiYDgCz2Dq3dIH8Tj3i9cR5Sb9G?=
 =?iso-8859-15?Q?1vjQBt0tX4E3YKyV2YB80OJFVkHCuR8bqE5w31hiITtkoUfXjmULcGp9+?=
 =?iso-8859-15?Q?Cbj6o2+IjNG1lge5vDtmz/p4JE54hKKgro2L2SXyimfD6Nz44pZ/VQrnN?=
 =?iso-8859-15?Q?4DAAkJgM/XHgIFsOqrpQ1FYiM/w07EyjbzP7lIr7tYfBCo2meS8Y2br/s?=
 =?iso-8859-15?Q?dxTeV7+UmbQT423SEj2v4bemPNXwk2TuxHtr8jcwi79sXl+5qagjYYTjd?=
 =?iso-8859-15?Q?5q2O7Epf6hpsUYAso0K9Ud6FwPhl958+MoGHnybFRa7OVV7AvF8zRKl5z?=
 =?iso-8859-15?Q?Rj8x2DMlHGb2aG9PgGlri9GQYJrVzEJwG3kGR97+cwDVuDgdZ8N3Uedkv?=
 =?iso-8859-15?Q?hufcWoKNFV91VfYC7MfhhV+vvYT4iH7P36R1QjE/z5bEepEFG0UlTuBBW?=
 =?iso-8859-15?Q?vPAG8lpDZTRID/I8msdxw2a/uB6fgZ3S4XLoa/tjWOKWsZnTUrXKh2BSs?=
 =?iso-8859-15?Q?+sO1678GMY1NI8x7WA+4jDJIKjBof5IH6C1gq1d7MI4bjZSqfSbN140e5?=
 =?iso-8859-15?Q?GPpW8hJ8U1Hf/KaATPX4hVcvQeOHTk1r9Y9AS6/03ASBjlnd1le2d+2T1?=
 =?iso-8859-15?Q?NJWSu9aNfdxI0KqlmUzPGihPCBMQnXJ9MYUfmJ5EF17bOB2WIV2j4YEeI?=
 =?iso-8859-15?Q?Lv7Dl77ZhyDrspgaxCREsCmKqQMwdEGZvzlEr02P0cGd3WR4JyU3RCMMT?=
 =?iso-8859-15?Q?H30lfstNeYVCWCCeVL/t9IUel6m76hvGQJLz7X74EBZRtvMVzE/CJ4A0m?=
 =?iso-8859-15?Q?NGpeNE4B0Fh/9YgMwrYNILMrXB12aTbq82f43Q4pTwvBGxZJtDLmt5K2p?=
 =?iso-8859-15?Q?mFOXrzvGbzEU46IVisIOz9pEcXCdAAG3i7C1gN3CDHslPPloEt1fw57od?=
 =?iso-8859-15?Q?ymjfxo1TFVtmNFyjuAtR/xK/3PuaneyBMFFT7pB0vsxOcrO5BhQqbv8Lv?=
 =?iso-8859-15?Q?g38elgPGVx7M+FdVQJ0NxKRzYd/m3ajxzXrpa9FnRvGy2ghYRgZ+OR8yD?=
 =?iso-8859-15?Q?b02vW6YgZEjfi+g+vSlqXAKmbYuFQDVANyBCQJgG8QKlT2VxJjoZnjPrG?=
 =?iso-8859-15?Q?T6I1+6Yszu3E6PtSCVDPyAkMLA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <0699E36D2340AF41B0492A8C856E7D16@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 21065e31-3fff-4f48-6818-08dbe0844c9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2023 17:58:22.8282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z4zfaI4w7iDnjSzy0KyZzXuJpteAOhajLZN38o2QI/m2ZpAQsy35HtmCUabY/VTlqIUeK21i4Mil7/co8Ecy7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8180

On Thu, 2023-11-02 at 18:15 -0400, Benjamin Marzinski wrote:
> In preparation for reusing resize_map() in other code, move all code
> necessary to resize the map to the resize_map() function. Also track
> if
> map was removed in the function.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

