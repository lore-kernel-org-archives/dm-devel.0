Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2067.outbound.protection.outlook.com [40.107.22.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246AA32C87
	for <dm-devel@lists.linux.dev>; Wed,  8 Nov 2023 18:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="2edCWGku"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wh9F4BMRN1coJION/fpcyued6rBk+hFPnInHwDTG01cA+AG5pz76fQVaIZ+MtG6dQXz8kKSq9VeTBxfbLdwoHB8R6m41uNc0cg0WF0P1evLJPD7oHRWc7pD64NaLP/9KhKmxWcnqMJ3oMuGJS6D2axLj+kyyeYEDJUtFBSuF6wKZJmocctBeuDZGdkXkq1LcBKcYc3HO0vxlypYr84zBFgu1rfbf0ftaMvsBqZRdePqeGUwOmFRkwE1yLCd1N/lZukCdlsjGxPr+52KuJCUYAB+CDY/y9RV2qBKLuXOT1Lppi7/2qarV74f5lL83ABw8/OZAEyuKsnsVajO8xbvnNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NWD0nF1BdrirUG+ms6Ex9RsuTx00RcnabCJArIfjOwQ=;
 b=oMShdBTLhopqbbXJ4bKCP3XlqG1OVyQHojb+8RNZfDzFFz/YwJwf6XUZITtfJxVQa/ZRHxchRbN7aZemZGwF0yea55uk52Lm7PQUH7sfLPAwpqI61zPshXuJ2AQ81eZ9KtUsMEc/EC8WzuujA8Q2MGhU5YuZhDyOIBpGembOJx3yIeYjBsw0gpXI8zcBeVcHR2Xoa/SBOPWpoq+p/YN9C3hKf6P8QMCEYiAicIp4AUxuNHabSTj3Z+z3vBpllTywauHMv2swrSPuw8x5Cwgzd0wlzjvUptYQ4M4YJb9vqiLUzvVawi27X4rd1Us6La3GdzRp3EpHacZ+52GpUGGz0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWD0nF1BdrirUG+ms6Ex9RsuTx00RcnabCJArIfjOwQ=;
 b=2edCWGku9QBXREjMNyr5ugs9YQuy0gQU9osvp3RXNmQIt9eyeQkIIFOfywOBzEyt+fZF1cbJHhKhn0/cJpzcdg3tbXQDTyKN5VfBpxMN0b5AWFpksPvRpOkBEU78KTRhRJ0aXSS4/VgwbedWXD5XJmX2ynGwqRZ3t6sczZdLb3HPHO2qMmEZe1KlLxd2y/WMqyrOpZBRgp7/Z+/BQXpbJBE2x29oLIsqfvAXhWUU/FK/g7vU7vCN2ATL/B/gHtYeMGh+iVLYUAS1R4OIfC/etYXg4CyCLQR5/fyT8q4TZ/AfRgMPWv77f//bx3IUGrrbmmWEILslSeSoG0Q7lcnubw==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by AM7PR04MB6887.eurprd04.prod.outlook.com (2603:10a6:20b:10a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Wed, 8 Nov
 2023 18:10:26 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77%4]) with mapi id 15.20.6977.017; Wed, 8 Nov 2023
 18:10:26 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 7/7] libmultipath.version: bump ABI version to 22.0.0
Thread-Topic: [PATCH 7/7] libmultipath.version: bump ABI version to 22.0.0
Thread-Index: AQHaDdoPrbWdyTzAl0yMb5bXckLB4bBwwf2A
Date: Wed, 8 Nov 2023 18:10:26 +0000
Message-ID: <509ad8171e44d691b19c5d1c7866986f67ebf87d.camel@suse.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
	 <20231102221507.105371-8-bmarzins@redhat.com>
In-Reply-To: <20231102221507.105371-8-bmarzins@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|AM7PR04MB6887:EE_
x-ms-office365-filtering-correlation-id: d32eb85d-666b-430b-9e0c-08dbe085fbf3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 E7oMMb0C4yA8JjrxwA3akIo6BgC36zGXq3SnI5A3d9mG6yfCHzCnXkgVMLS34MQxDbVKbXcgWG1yunClqv8Dd7dEyZWMuRk4Fpi0TBTawZ3yVrI6OksI1F3qqCLNDfR+ZfSynGT6LTlMY4vuU5a9te+9D6ejsJbKz8ITGX4IEMOwoidwbW27Y1TDXTStwNmOlbWvuOnk/lQ4Ivo6wSYOj+5jVKlfWnTPCnLesrdiKP14nSIqwvGxi5e8cTHb5wtTszmG7dN7eKCa3P712pAN5a8kqdi2fT6IVNBn0RcpKTEkWFOf7Xr1/+Wzx5F1NUX3bGnzEu2+cHtkS1RoFXKWBQ7qfJyHdYWzDWwkLGH7vhcU5KUloKI3akF80ujchoZOyKgGXxFpbj13Rvc8NZzMSStBJfIAWbEOQPFSgRUJT8+RU156nIeuludqqH1h89ZXJwPxVyQV3QgK70qhsabTJsgcZjF3yp++k4pdy6jh4LNZ8onQ+B+8/uG67CRztfzDU6D1ndE+tWjzHdIPsNcsSGvvGi/9oHuo7Lu66WHwUv7aHZNSa/nCSY5NLo1yPqZTWVFr/eJEJSdcNJ1u9sXiK9EjIG/Jj2r1k9jo57E4BgcLg/35/mbEu4Kqvcn/27FH
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(396003)(376002)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(478600001)(44832011)(6486002)(5660300002)(6512007)(6506007)(2906002)(83380400001)(4326008)(8676002)(8936002)(316002)(71200400001)(26005)(110136005)(76116006)(66446008)(66556008)(66476007)(64756008)(66946007)(86362001)(38100700002)(41300700001)(122000001)(2616005)(38070700009)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?qFFsD+vnxiZaDYawd/3Pg4onpiymBv3sg3bUVywtq1P65c+kvxlyfkW8Q?=
 =?iso-8859-15?Q?ByAQv1IsMJIjuSytEDxvaJ6H5xdIdKNVjroszZZmEsh8hjXV4koao/qMN?=
 =?iso-8859-15?Q?QDVNcwY9K+J2QnKyj3SKWjZsbbGGhRtRlQv2rS13aR+Vc4FFbyb+tyl5L?=
 =?iso-8859-15?Q?8Q137Gpd5OWz6WoYr1Gzcw8IvUVcGOIHeoHuMcBztxlbxRdaM6eV6km+i?=
 =?iso-8859-15?Q?9SvfIm3WcHXxZelleAgQhtPgfIhm1D31YBtm0cJShct9K1pHiHdQnDWEH?=
 =?iso-8859-15?Q?LHxY5gGd0yj0PqF1e9TtS9W6EQ68vo/RumvkhzJtJm/xyN75OdhRHEi+I?=
 =?iso-8859-15?Q?BrkTF/cllNJCee7/Myca/cIpwr265W64lwpaeDw55C+Gvj9ZpcLHN37VU?=
 =?iso-8859-15?Q?+f8KpLb5ad/Qjd/GWuAHurYJSTJyEILrUX4yQy/F7Tg81myjbRlBWC6O5?=
 =?iso-8859-15?Q?VaucjkQgPk09lXohscAxfNrQU3PRepX6wr9zoJgtMWG/Je0yIqr3qIoKw?=
 =?iso-8859-15?Q?lc5WBuiX6Dor/GCmuaKACwFJ9sAkQjY1YoDC21vhXPIkE4NSBhzno3XoF?=
 =?iso-8859-15?Q?jB0/GL4rG8E6zt57SQ4z1pZKRiVWvfRahPC7pGfK1e1CPN2kOti3pwcF9?=
 =?iso-8859-15?Q?yDdRO8awjD8lvuFnMsa18YmA+dK3Eu69gxW9nI1HbZtU6OUZlGQzm9Dqi?=
 =?iso-8859-15?Q?+BSVAAlKXXjZaviXy+hPBeVx8Fopl02q6RdHeza1twBg915Ciq9kfLtzV?=
 =?iso-8859-15?Q?iWRsDvm63029yY3ninFUfgcvox0fBqndrfNdUi7l9Udoqy/EC8SAu2lgF?=
 =?iso-8859-15?Q?IBstH9ivTZ/we+ahySiPmO1m6f+o7GqpE3fDv8dLkzjlm1x6yIzQAZxUY?=
 =?iso-8859-15?Q?l3sEvP3omA3uggYNzauV6pZSY24n5iEkt+muXpnZEg0hiTJ9JQSbuPlNF?=
 =?iso-8859-15?Q?qXYKmdDuMSFtGuocKLllOAPTkwEC/oC6CjMMaZNelu/buVvIAhK5Apx47?=
 =?iso-8859-15?Q?M4ECrjnJuA7vQniEOSAJYp6TZu1JNasHSxwjPE1Qorky0Xs5AjQnrZ3Zy?=
 =?iso-8859-15?Q?V8SbYuJaz9S6Xsc2kIFsR4+ySrwTT3G8Z3EtBz1JhK2XCvztiD453GF/L?=
 =?iso-8859-15?Q?G6L7vVmhZEZ7FhVmiWwqEX21Rp47ykfxKvJc+injTxx0+4UpmXzz36DT3?=
 =?iso-8859-15?Q?IOCW/9HBYQSJfRi/XvC2kq9YAMuVDJ0OamWsLs3hzoSSzC8HOACIHII1a?=
 =?iso-8859-15?Q?TCyYF/XCYelsaSFBBc6uVVe81G2MRkUIQglb/whs5Dkiiy0bQzGSEHmAi?=
 =?iso-8859-15?Q?DoHccHZ2PgRQ0wF40mlBOovZT5vYt+VKrB5S3NVvIwQnE11Z/v8Suo91/?=
 =?iso-8859-15?Q?tkgfEDSvmJIV+4o9kZMxj5HHBJcj9dU5C7CcurRBQ9enlb1UZmeCR+v2Q?=
 =?iso-8859-15?Q?Pu8O+aQTfZ+fIJ9KOHdXvIuWwh2lT+qKuPQM0viP3ciq7hj6SP2iNnYOb?=
 =?iso-8859-15?Q?DkESIuxKbYoGBcwtWyyoCHcZ0XJNxEVlgY6ZZj1ghygw3ZwiEqNX8ozNG?=
 =?iso-8859-15?Q?OMMSIgJ1SVA5MmzKqCeTjBDUxN2tcHl4K/3tpvWPxtyWM6R1W86PliXa9?=
 =?iso-8859-15?Q?qfcCC7EBPxFHsViyetrOBCQ87GBHXqiFpZbjT3GPtyEigv3vpMJoxni0y?=
 =?iso-8859-15?Q?EA6BtT23rw7lQ6Z2zFb+Jw456A=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <AF0C59EC51D879469DA99BA67E075B2E@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d32eb85d-666b-430b-9e0c-08dbe085fbf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2023 18:10:26.4857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gwzPvAAg/ppVX8KfvSgaSucngwOd2Enwzk6N4h5znDwKpiSLCjcsccWQjPnm8EnPhtE8xvzZuW2HqrgNPFr6nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6887

On Thu, 2023-11-02 at 18:15 -0400, Benjamin Marzinski wrote:
> Commits ("libmultipath: Add max_retries config option") and
> ("multipathd: Add auto_resize config option") changed the size and
> member offsets of multiple structs.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>



I should have bumped the ABI with my patch "libmultipath: deprecate
bindings_file, wwids_file, prkeys_file" already. If you don't mind,
just drop this, and I'll fix the ABI issues when I push to the "queue"
branch.

I'd like to create a PR to Christophe soon, basically as soon as this
series is reviewed.

Thanks,
Martin


> ---
> =A0libmultipath/libmultipath.version | 2 +-
> =A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index 8368ef7a..8ab7c802 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
> =A0	put_multipath_config;
> =A0};
> =A0
> -LIBMULTIPATH_21.0.0 {
> +LIBMULTIPATH_22.0.0 {
> =A0global:
> =A0	/* symbols referenced by multipath and multipathd */
> =A0	add_foreign;

