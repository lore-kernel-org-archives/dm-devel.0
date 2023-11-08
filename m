Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2067.outbound.protection.outlook.com [40.107.21.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0126C19474
	for <dm-devel@lists.linux.dev>; Wed,  8 Nov 2023 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="nyVGVhdJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARasbIQ0RMy9wsNWsSL2A9P0XBIIf0+L1ty9jCU58/UmnbQaPRNXBR1u08a72CDj0aYd+JvewdCgvbBLngqcmfkVE6RncrhpBUkNiUlCLrePLgon5sfy409fK9yOnTI7A4AnM09I255fH2NN4KrVUWOGejrFyqLKHmPjuaiVQoOjuwrd1J7uWqx478lsHOcJSOZYXwrU+xsJZdZAEzSDHxObn/A8JL73m8kLLMHRO0CBop5eI3/lof0ELLEBo+iCtu1PC52QQ0mClvzNO4A6mXOsnVXm7+7aDnyYGT8Fald3MUk/qaXb2oxpyshVR5YbWHsYo/XcXflKX15KWuxPTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKBOtwFo7rIbsEGcmLT/w8lfbMuajcOJU6MsB9Id1rA=;
 b=SxvAoyfiVjKZPhY5fUVVnsPHn2rxRWHtNx1tKdWkZk8An69wtlR51fpZXUvAR66Mmk6iqBq1IYq54oue7wR1Ep+Wt57pljYKdt1sM8TReR20GDvASH97+NKiMCZVE5MImu3oJtJ+DaVwdWWqUvetlMONRN/4d67kPjxed+UQgisC8qhGrZ2ASGMFpbYZmQ3hcwaWks5cJm4+3G9urTuXbOqYehcaZlP2Jd4EyQJ0mqtD3/q2Ats9yJG4Amm+Hp2cU7Gf4a2N6Z/N26Fj2soN9ogYrRH5rEDdTk2I7PvWF+J+wegZ8rKVsKZeton2ykKUxe2g6HGfZCmmC0ZX2LbXgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKBOtwFo7rIbsEGcmLT/w8lfbMuajcOJU6MsB9Id1rA=;
 b=nyVGVhdJrOUAedlBg0FHOolrVrVEuWw5jNGFEX8WLSXU1tvDDFF7uezFNm2s2bT2dV0PhKAMuGVrs53+FhEy6YMAPzY0j0O2rLvzBTPgHhRmw5H54OQBo9Q+b0OkwJ9FTl238oDAC6D1JAO5jGnJ78O+BkOkj44YPTdAsY0Xr1RnNKB+TS+AcyqlFjIbODOSQm8PIqHT197RW8fhVlMTr7vMt8eaDq0Y/06uwk1vz8/m4OJkVRKEc0RJAr1PEVS7qwJSFjDty6D65FiPjoqbB/Z8IiQbMDa5IPj1RLmHMtzUAfQhIzAT+EVHstjO2qR5x20ofTlptcLH0qN+0P9QLw==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by AM9PR04MB8180.eurprd04.prod.outlook.com (2603:10a6:20b:3e2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Wed, 8 Nov
 2023 17:56:43 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77%4]) with mapi id 15.20.6977.017; Wed, 8 Nov 2023
 17:56:42 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 3/7] multipathd: check and update all paths when in
 cli_resize
Thread-Topic: [PATCH 3/7] multipathd: check and update all paths when in
 cli_resize
Thread-Index: AQHaDdoNBNfMjGMwbky3Jzohwo26w7BwviaA
Date: Wed, 8 Nov 2023 17:56:42 +0000
Message-ID: <e679c9cc5fba535167551e54cf37347b215d44c3.camel@suse.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
	 <20231102221507.105371-4-bmarzins@redhat.com>
In-Reply-To: <20231102221507.105371-4-bmarzins@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|AM9PR04MB8180:EE_
x-ms-office365-filtering-correlation-id: 8dee107c-7aa2-47b2-8a70-08dbe084110f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 X2IjUmyBrzRSXlKjBv3Tc1l3fgKFRqUoabOExwQTbQF/7VPlm0dldWuchwDj6Sc0WxWX6I06scgxodRU98V9d+xugE+613E0Uzne8fWDAVFb071eNZrDcLGzA/X9SimFm66r2bjvyHBjCvYNx4DFMD0V65TM9sfQDc4fMER26El7OidSJ82OgvjASfZ1E5dUc8vb1vcpvzBQPXeUznNXps1aK35K4oAJaraTUyyVsnEgDvOdzPDSLXDssojUAIhf4DANN6EvhjLS74goqf3fEbKEHH6/SRbEL0bDQLkdyMZbO5LAmjATF0vRwUDNMdJCxdmzUBZ41Kv60SVDs8Mb4IxE7NqFkNSPr5ca0YffGrHooy8GeXJ2JNH4luKpMNIBaZKgXTncRbXFX33WBok25jsfrfLE9VrZz+FdPrp02dJFVoClHe8BQiy9a/21w3S1w/eCOC95UmI3POag2cLzd8yNOolF7Xm3WPVxCSSasUE7uk//mbKfv/WGyCWaNizDVDm02ItsGYAUxoBw89x9FforUh8OIpTLp5wm+xODUArajKKG+1Ypi0abhoEUI3pZLWacqOwr9wU1ubuTQFQFUk/rL3B7GJ1Msg4n2+yKZBIemzhubVWrMvbo8iSzQEJs
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(136003)(366004)(396003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(2616005)(6512007)(478600001)(6486002)(71200400001)(83380400001)(26005)(2906002)(15650500001)(110136005)(44832011)(316002)(41300700001)(66556008)(5660300002)(66946007)(76116006)(66476007)(66446008)(4326008)(8936002)(64756008)(8676002)(38070700009)(38100700002)(36756003)(86362001)(122000001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?M0nLxpV9YVU7T8x3uIz+DlZjWG1wx+VyH/KzrtC3MPG2Or3JIIwGJ4J6Y?=
 =?iso-8859-15?Q?91epc+6Et1q6fwkdA4uIo4+trtxlwhd7HNyR0ErNOUNfpvJJKuPSUcrJc?=
 =?iso-8859-15?Q?LLCynZiJAf/PYd4lYbLxhceskv3zx5IXKgwEftofykFSGwpKvAsSMVj+h?=
 =?iso-8859-15?Q?d+CHZQ10TEH2rXjYCjESUkplH/DshAFljPce7z9PddKOt2JvDEI9bvUG8?=
 =?iso-8859-15?Q?Uu4as6ruSMUTdSpr4IWZ5eaXiUrw83/beC4EQmvPlxKNF54WDAJkjqn5V?=
 =?iso-8859-15?Q?Tg+2p+IX9gRwCEzCesgtyw/tsPBRfPA57OAcH1LscowUkH2sQDa9b6Usl?=
 =?iso-8859-15?Q?vrUw+t7udwSV9JkzIVP8Q4bfcK/5Ne2C+u5zmiRq8LBY0CwSf4WLX4KdO?=
 =?iso-8859-15?Q?uXT60eBQ1gZ8cxortCT6Y3gdJIXfO7HxuCEpXsW+nEiR2NB6PDQjCpF14?=
 =?iso-8859-15?Q?9VHiISr9K83k3MV6SV9cDTfmD1ABHfoyxSCwZqfGZMDUHe5W7SBen+maJ?=
 =?iso-8859-15?Q?HyqwamR4UPN8ngmDWQBSsIqTXc9/wosKxlBCdc3aL0dXAJjnEE9h9DVQV?=
 =?iso-8859-15?Q?3TFJ7JeWR1Y/9FaEZuychoDltqqrsSj3Z05aaM34n0nURMeIYTaoIEKVb?=
 =?iso-8859-15?Q?x2802X5H6iy/BPiZbugcpFOJEeD9C0dTtY0oMY4H7SnN+xUFr7+og7PcT?=
 =?iso-8859-15?Q?4jB/3ssZ23y7RgTkUwe60AwkwCScfdwpDVt8MiWZolIuypyLZEtWnHerf?=
 =?iso-8859-15?Q?tvt1nVi2WN+fIN0++vjE/levPuPpW5DjU2oayt3kE0vukf0Or6zqztwF0?=
 =?iso-8859-15?Q?ZOa4qnvBIPTH4Wbgt8UagJ3+0A0YxHDAyQAN/FHxZIGGurxzUtB1GOUBM?=
 =?iso-8859-15?Q?NETWQ5LffScJoUUvibFidM7PpBKGo20JNGeegFppHTHnHwVJp1G5LEHTI?=
 =?iso-8859-15?Q?GrffZk8oAsdT+CNLOiEYhI2qVy/PD4LcAEd6F/N1r6WUsWIckmNWtGUWR?=
 =?iso-8859-15?Q?KIg7ZAqcBfAgNqk/tPGUT36T/kkUiGb+SpSAlUdxz7EARyOswTOEzKQ+5?=
 =?iso-8859-15?Q?TFjTzDrXUxEi4xsUh1shWq9XdNK4wiRjIYC3yrYcvdE6aB1W0UeC/Y4Pt?=
 =?iso-8859-15?Q?HaEMKy+ilBkLVLVX6Y4sgTqqf8k8NxIXEAQPQVZdYAKSQblT0a6d+X4H6?=
 =?iso-8859-15?Q?olrpix6nJzxX52xUy97f5rmjYm2wMdQAnQyVl8FeBzGSjxod94EPnTB/8?=
 =?iso-8859-15?Q?R+lPP7xIMTZVUcLEZhKKp5MzCDRAdZr01HyFy7eL7HkYCk/Z33+ngYZdc?=
 =?iso-8859-15?Q?mu0db7B5tOfTnyO3pfN3rwCIEdZQy+IzanrRxS/UYdqEaYK7+hSEQyas9?=
 =?iso-8859-15?Q?hqG/qvWKMVRzviFffgio4UWHgi5vciTwxWt1qg0ouEoQowFb/mq1dBPeD?=
 =?iso-8859-15?Q?pj0v/8ajBKEsRt04ouLHHfOAurMnHIrgb1gVoOnno4JziDdLkfT0BAuQx?=
 =?iso-8859-15?Q?YlfopBKIdWlpDFSodXrhjw6VM2b8/GnDBnvzcpblHEYDJnvf7JBuzjTAd?=
 =?iso-8859-15?Q?AUelfqou848eHHLQAMp68nB/FlhuMZ/HVi4J22hQzlecLb95khIUpzKZa?=
 =?iso-8859-15?Q?e00rl3vQQnOkbngr8EZn/+GU1EFFWnE2q6CXncKjaHDquohtbms/QI2jq?=
 =?iso-8859-15?Q?A0xbKOGZFGzZ8z/YdKjoIL1nUQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <2C2281062270B542AA01CF0DD4F5F9B4@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dee107c-7aa2-47b2-8a70-08dbe084110f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2023 17:56:42.9193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cHF3m6WtSFjwVna02JPd6UpIjTkaiNOxnZd47HUF/ISDP2L+LC/0eVRYxyc0794psQyx4kZ965M2oA9Qyl5R6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8180

On Thu, 2023-11-02 at 18:15 -0400, Benjamin Marzinski wrote:
> When resizing a multipath device, make sure that all the paths have
> been updated to the new size first.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0multipathd/cli_handlers.c | 30 +++++++++++++++++-------------
> =A01 file changed, 17 insertions(+), 13 deletions(-)
>=20
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index c9addfbb..ffea193d 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -845,9 +845,11 @@ cli_resize(void *v, struct strbuf *reply, void
> *data)
> =A0	char * mapname =3D get_keyparam(v, KEY_MAP);
> =A0	struct multipath *mpp;
> =A0	int minor;
> -	unsigned long long size;
> +	unsigned long long size =3D 0;
> =A0	struct pathgroup *pgp;
> =A0	struct path *pp;
> +	unsigned int i, j;
> +	bool mismatch =3D false;
> =A0
> =A0	mapname =3D convert_dev(mapname, 0);
> =A0	condlog(2, "%s: resize map (operator)", mapname);
> @@ -867,21 +869,23 @@ cli_resize(void *v, struct strbuf *reply, void
> *data)
> =A0		return 1;
> =A0	}
> =A0
> -	pgp =3D VECTOR_SLOT(mpp->pg, 0);
> -
> -	if (!pgp){
> -		condlog(0, "%s: couldn't get path group. cannot
> resize",
> -			mapname);
> -		return 1;
> +	vector_foreach_slot(mpp->pg, pgp, i) {
> +		vector_foreach_slot (pgp->paths, pp, j) {
> +			if (sysfs_get_size(pp, &pp->size) !=3D 0)
> +				continue;
> +			if (!size)
> +				size =3D pp->size;

In the previous patch, you assume that if sysfs_get_size() fails, the
size is unchanged. The "continue" doesn't make much sense to me: you
should make the same assumption here, i.e. set size =3D pp->size even in
the failure case. Otherwise you might miss a size mismatch.

Altenatively, you could error out immediately if sysfs_get_size() fails
for any path.

Martin


> +			else if (pp->size !=3D size)
> +				mismatch =3D true;
> +		}
> =A0	}
> -	pp =3D VECTOR_SLOT(pgp->paths, 0);
> -
> -	if (!pp){
> -		condlog(0, "%s: couldn't get path. cannot resize",
> mapname);
> +	if (!size) {
> +		condlog(0, "%s: couldn't get size from sysfs. cannot
> resize",
> +			mapname);
> =A0		return 1;
> =A0	}
> -	if (!pp->udev || sysfs_get_size(pp, &size)) {
> -		condlog(0, "%s: couldn't get size for sysfs. cannot
> resize",
> +	if (mismatch) {
> +		condlog(0, "%s: path size not consistent. cannot
> resize",
> =A0			mapname);
> =A0		return 1;
> =A0	}

