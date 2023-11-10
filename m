Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2048.outbound.protection.outlook.com [40.107.22.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45608179A7
	for <dm-devel@lists.linux.dev>; Fri, 10 Nov 2023 12:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="c7pzaP2i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTaUONMmgpBJMmdpfzKG7P16x7AujzAueJsEL53zfuwQM6fqbuBFtiZbId8JUY20rpT8DPEWyF+C+P1A+l1Gc/L8zUsFgWjSBi9PsCMQgYPu0+w1N4aUJ3WSjQc+O08EurtIJ0Wt6CxACmqEjKQhOyl+be6sEGBFkj/0Q3r3byV6UsFrvRu5KtiuEGZXaQwY2l8uISl/ve8dVGDC3vlHzJXAwDOAJ2ZTQ2h792wc9/EcHasj+i7AFko+RMrZiEzfLCH6/kZ5m8y4RpIeBP4orXZ+iHutPHl54nTTKYEffbKd3DGAbykaed4r9tpQh2f47hCAPjqALkgchOGb3zQSTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBof2lphWpY+fQ4t1056j070cvSadKJoqG6UZqfNkOk=;
 b=AhbDFbxe7RdVNAIu9HSLvuNwLNeryt/L6gu/zxkXYUNAFF4xRDjiXjWb/lQk8MzfW3/MTu+2BIKmaoeIf/TTUvHwuKz7v45mfJpW5kYqBSBVlqjUjsRHS00z+MATwX5HtCB/SItDMVimo17FGrU4CpXUNr/XLcnkuZey+PJUx9O2+BjF7Oo5Sgv8F6rvAFgJpFz4elMomP/4f6JeQRv9UQQnvXPitJnhXvIYNux980pDRPJmXdn2GB5FoKhmG4AcCZgQs/LfhvKlCZXKe/sfwM1vZFLxmIyg0Rk86KE7JtOGint4dcC6IRkT/3Q4mPMEHX7U9M69ZSPMXraCSrggvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBof2lphWpY+fQ4t1056j070cvSadKJoqG6UZqfNkOk=;
 b=c7pzaP2i3ghoxm3TRGrtKpap+ssNhmYcXDad49AmxNVaIHslZd61j+2eM/V0ahwblLlsWuNcs/ZZlNxzGMhOleR21XoVg+4l9rPZ1TqSe//yVbLw499CPAkPjPDD/DqrK/jRi3aywdYTams4icwI9DRAXVe49O2CgAK0/VPFfXGRPuvuS15w8w0zhSMxO0d1qf1t12rlJzn9K4qvMlLXN4WEotfu2cFHG/c3u2SLlIDxk8NUO5PKUOq8bDaoJj0eaHjdycFl4FsAEHm/EG/ALXakT7rZrEmLGrytKpm3hAIJVTChkMhGtkPVf5MqyCgAV9JfBhM9Iw2BkPTb6e1jlw==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by PA4PR04MB9664.eurprd04.prod.outlook.com (2603:10a6:102:262::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.8; Fri, 10 Nov
 2023 12:01:36 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77%5]) with mapi id 15.20.7002.010; Fri, 10 Nov 2023
 12:01:36 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 6/6] multipathd: Add auto_resize config option
Thread-Topic: [PATCH v2 6/6] multipathd: Add auto_resize config option
Thread-Index: AQHaE2bzRKDiBGlyLUm49uVp2vxPYbBzdH+A
Date: Fri, 10 Nov 2023 12:01:36 +0000
Message-ID: <ac739bebd1f24cb9458742ec459c3121b090e165.camel@suse.com>
References: <20231109234616.100125-1-bmarzins@redhat.com>
	 <20231109234616.100125-7-bmarzins@redhat.com>
In-Reply-To: <20231109234616.100125-7-bmarzins@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|PA4PR04MB9664:EE_
x-ms-office365-filtering-correlation-id: 9203d8ab-c4bc-43c1-6407-08dbe1e4ca1e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 EeFzbtEKe/SeMmlWPaUy7RMpdNDnM+Yc8M9L9gULQ2Bm1M/XzEny5dFSTQncw2ao+vqMojgI9C3lnfN1zk/lhpP3iY4Czpvmc2OJJC+X/9EtbNprfTRTkSJXF2LawRsPEeiEo4qovKFdjQj1Aa2k/50G0r0kB2eyPg6e07H24ivqKvH5c36kS+y6e4jHkiDC0KWKow92IEknQ5WiTYtSIClkVF9TJfVnEY4QhkfwW3HP9L2Zw3OG4aybZJpBszmOyFLWPjzGdVsNbRYxsKe+bqP8EpB35ZgDsafdcipzCG/xzgofgE+qXZ2yXsEQfTF0q5igquLX/cWu1yvNUYsUGYHtrPedGXokPXG9dQsS5OANUMSE2gO3nsK2yqTzn3F1Q5cPxNaSDCdlLGyJjIXA2j3W/Yy3HdIA6UNpPP09EsgDEBUFdJPWKAYvjX7iCziwDU6Hwyo5l3Yf5tGHHD0lNCAKsbRtr1KqhFadp0EcAFF9qWqFy0PuAosPwmhn8qKi+jCtNFnk5yrthk1uPTOcw4h/NwseU2u8N+HtegJoEgCu1+LfDV1ZuvA97KMjz4mtzhcsKIdhTjK8sPng33lsqgUZOjFD+OXR+C/zkEE5ClHI81BhismWs+zeLr8bQCrd
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(136003)(376002)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(478600001)(6506007)(38070700009)(83380400001)(36756003)(38100700002)(122000001)(6512007)(2906002)(2616005)(76116006)(6486002)(110136005)(41300700001)(44832011)(5660300002)(26005)(86362001)(4744005)(64756008)(71200400001)(316002)(66946007)(8936002)(66476007)(4326008)(66556008)(66446008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?1aYcxBR966pnJFvxOvmGR7+iacLhl6b1LnpCQNcoFDCeGa4mP9HxfwLys?=
 =?iso-8859-15?Q?k9AGEW0zK1bm8j+Md7580XPUPRGyF0L5KlqOaXKz339sGNPP+ZRuOTF0W?=
 =?iso-8859-15?Q?oe8yvOrWx3WbQfSxVHHP9WrVFwztFnTFcYpV6W99+N6rle/+02Zzda9/q?=
 =?iso-8859-15?Q?8TEqTdxsSbkOFhSlEUeOeIiVuw7Gv4FdjoN+vV2TVbF4ldEQewnS9atsK?=
 =?iso-8859-15?Q?UCIveXrr6gwVzIdo8QjP3ybd27K93VgAQSvD+oKLyj08yGWNZ+Ki+WbfA?=
 =?iso-8859-15?Q?EyMF9edEnNTnUzKPNpqQ7VIRPlT9o9MVYCyYnXF5dWeed8wQ5tnB4UCeM?=
 =?iso-8859-15?Q?WtNQflUB4YJFx10NajZFh3RtweiYZx0E33hoyiKjfkbodoVBbBolZzDLQ?=
 =?iso-8859-15?Q?gElSIL20clG17GFQyJxy8smh8pv2v0gMmfH3aTBRxiDOjivqOI+n9Nhth?=
 =?iso-8859-15?Q?o8rQpc7lf8S7qI8oR9LG2/J3dL0NeTdvgOQ1pIUi+yiqiepXLuYFr5aH8?=
 =?iso-8859-15?Q?y1SWN7MwE+jhOmUVoZPOMldZis66B7oJb54MyapXS+5kE7j112id0Um0y?=
 =?iso-8859-15?Q?htFjo90/396aDBpXGUyC7sE6Lu7sRpziWwMZ+9O8+Ky9IIOetYe6Lr/K8?=
 =?iso-8859-15?Q?XGOqRQEDkUyy3LgT4e1owwIQGF0/HaB3LSkwXMap9ZdEXQyE/2bsrFYEC?=
 =?iso-8859-15?Q?wKA5AugVmbgIayQvMpG+c0oGwaz+4PnBTBWVSe4iVKly0zEu7wk7Is2bA?=
 =?iso-8859-15?Q?2GOZINm3Dtle5locgXKtjSY3w6vz2q2BX8/xl2igaFqjOaRGovdb5PdJJ?=
 =?iso-8859-15?Q?iptwNUj3WnKj5b7rSYT4pP72QGQwBUENK/s/rUFB8QPcEnsy85HWqw9R1?=
 =?iso-8859-15?Q?vGyohFj8Bu5FtPJ1dIISAxhV//AsWosjnREsOqXZZRWXKogMLwBPjIvF8?=
 =?iso-8859-15?Q?sITyZ8arF6fTI1lQi5XzIt/Z2G4FT1M9GFDGFunKDZPjLPDJr9Z18Fpug?=
 =?iso-8859-15?Q?fdnHCW/n4jjbIB45bLdZ2gVeudjuLy6VNpsnCVIpu/m1J6OkrciyhOaXe?=
 =?iso-8859-15?Q?G5ksdEOQ7AondM82dXnPJkXnvl2kg9yZ4Y7k7nWmuUWIP9e8uAQbtA0or?=
 =?iso-8859-15?Q?sKkJSl/D4+30qlDEGF6ML6tGTdnXuAQQdmXFbk/E8sqdHdia7Gb9ZIuUL?=
 =?iso-8859-15?Q?b8XvvMP+B6JX22pWBGiAptcPcVTOB8c4vhZ3NNpC3KB+jFnWEP/PgVEY/?=
 =?iso-8859-15?Q?tPoOeTRPlE43wFQVKSJO3Sz4Q7L5IHH2HigCqIwmhcZoUUeR04SMAkxiq?=
 =?iso-8859-15?Q?fQljqf30sDx7vQQpq/QbYBGTAWaCRjDzKZkuU/JrN8ZjyM64O25Qf2UEo?=
 =?iso-8859-15?Q?2D4hgiwH1KCmEgdwtJQn6iCeMhwzAyQhbBCHExcB2mhJ+yR+9ZAQFtZKP?=
 =?iso-8859-15?Q?WQZLsBC3ASKukuUFrjl5IQjh7sV5IcsyQiCsLvcSoZ7mpLBGujKNx/piF?=
 =?iso-8859-15?Q?JJhUAJDXRvXPceRI1sMKNx9P6eRWEV5eYP4GwOCy4WfB/Plg85VNSz9X+?=
 =?iso-8859-15?Q?QRS4hthLNZ1WBUKE2EbSNtQP/B0egMqx7JD02rP3IRdJurzr0bYI64Qne?=
 =?iso-8859-15?Q?Jqk1gUVQd3V089L/Ak6FEJorIQQ4gTTe7FPznXj4msF+aT01APeIV5dWb?=
 =?iso-8859-15?Q?XM9PYBVJWt6DhAkleZI85yup3g=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <4D79DA27E74FC445B2229465FD94B0F1@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9203d8ab-c4bc-43c1-6407-08dbe1e4ca1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2023 12:01:36.2828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MUf8R6zfXrFLrsf6FyVRogFPFV+UPsdMVCxXLU+KlzgW4hlg1tx0rV2MkdNmIdWWdK1riFujC/DhiSZbhEdrlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9664

On Thu, 2023-11-09 at 18:46 -0500, Benjamin Marzinski wrote:
> This option gives multipathd the ability to automatically resize a
> device when it detects that all of the path devices have changed. By
> default it is set to never, and multipathd will continue to work like
> it
> always has, where a users must manually resize a multipath device.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>

