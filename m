Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2049.outbound.protection.outlook.com [40.107.22.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C19B18023
	for <dm-devel@lists.linux.dev>; Fri, 10 Nov 2023 11:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="s/9h0YYD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kaEYddO4U85kRrs7uUQzZcv2/Qiey4xiaKBrAz6Sz1rwu3li5ZBVAjuxe3Q7txEuLuk6WQFgMT2x4ApBkKrMHLZ6aCg8wy9R4HWM6XcyZECHQQ7dn8Kf7Qje5mFMKySU6vmy6M2OAySrktqCkhD/LzookHWf/k3sDhLEhUKE+dgI6orhg2yEomO8u3oLnufgYjHepdmQAfxtPN/qPm19KWTWQxgpm8KlO4yyVytlSVWZgmpcJVETKU/Q4i6WerHpjCVZVaGRy3VSyjuSiCMB0QEHum6xM/YsOjyAx4gHX5lJci32hZeAFTxxhpq5l6uQKr3IOzzBAkf4/yZLZMAGIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z4gIvNqY0MBv+cND0XLNGr1OtylXw3HfQJSqWpUYJMw=;
 b=UY+PZJk3zZY6dZrh2UJkwX50OdKT/MJAyx5OQhUUm8D1iNlgxYqS1ZpvuyatLRQ8pekLEssbbfno36vgHrx7MKtRjmgmd0prylU5tMDC8+Wm2Op6rfY+9+0Atf1TWqEzyQ36sm1Vu9UpYND1ItkD2TDyNZdn0Y8mId8jbWoRWAf8AvqSUVjLiqtm4fT3Cpeg3+CV7VPZPy62WvwFXft+QjW+2FA5Wp9Thb0jSdRG4JSLHt4gyTz1HWEN2bqb6eYJmLI5smnrpiaKYXngp4nW4Y2yTp6SG6usgo15/7lvqcSUQexKXVuUW3c4OudPGkCxmN6Tl5RSVOe1i0Dxf1PRCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4gIvNqY0MBv+cND0XLNGr1OtylXw3HfQJSqWpUYJMw=;
 b=s/9h0YYDWgUQ7rLg3+6JuudJkFYMdFKA9tBctILhxMdiDunZ3ljAG/HOIFLqGPiaH9BlyV3MvrJXCVfBTa+f+xnq297Szuw7wCmUIqKQ18esWLEEZHrz0G3tuLEBEcRSEyzdYDTzsMKSmjDPkAxBK+MNr1eNbGDSqOuGji29V/6U9N5FG2FosoWdUgk1hedWx2K094VPChDHyncL0mey/iOUxWmUwI5l6my5uACr5FQQR4YZMLoWSz+1UvDCdebAS4Us7qwy/n7svPZ8lRGCzLGSbpsTIoRaqsQkX456ke81en+zFqyGSEYaR0LM401rautpr6woFWnmSN3smaIBWQ==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by PA4PR04MB9664.eurprd04.prod.outlook.com (2603:10a6:102:262::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.8; Fri, 10 Nov
 2023 11:59:56 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77%5]) with mapi id 15.20.7002.010; Fri, 10 Nov 2023
 11:59:55 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 3/6] multipathd: check and update all paths when in
 cli_resize
Thread-Topic: [PATCH v2 3/6] multipathd: check and update all paths when in
 cli_resize
Thread-Index: AQHaE2b00GKS8/1IOUm/CQQgvyXBgLBzdAcA
Date: Fri, 10 Nov 2023 11:59:55 +0000
Message-ID: <2680ad636cdd505c2e84422149d1f90c996e074e.camel@suse.com>
References: <20231109234616.100125-1-bmarzins@redhat.com>
	 <20231109234616.100125-4-bmarzins@redhat.com>
In-Reply-To: <20231109234616.100125-4-bmarzins@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|PA4PR04MB9664:EE_
x-ms-office365-filtering-correlation-id: fa1afded-dea9-43e9-fdfa-08dbe1e48e47
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 pAjXZUzBEF2BzYTHDGc+Kigy1A/2KvlJrFnAAnFmBSpG+CT9vyu9o0JjY14DMbPJauaMMJClAmeuCUvL492oshCq+TNEN2r1AKAGp/vKxgfWHE9pD6pczHXM8htKEdEq1oR2EBvA8XmYgwuJzDZqFMPZfV1fn3itopsdwDM17WRTUVd1rj2PRH3i03+9bk/WScji2RRSpLX7u+tCrrEsbDTYRaXna7HMr7HX9Sj6ueK0fwLpqWnZgIc34Z9U6hHgLEQW+3GNi3E1wAEoot+nhBsZX5y40y2obV0UD3ftLxCEV+vRGj98dZRA0c9Ge9+CJBKRuzz3MeG7fJAHlo8yGK5j8JMdGEEdFOTVxZGitFa5aQHlYQbvPEKNg2hGKyJb4bPpD/CwUQBZSL7GrYsaHqWz9cB3iMfNxNFvH8ZFfsYHojOr8GA159IuFzP2Aben/+4w5jlU7M5B14aNbaWF17DGkY9ZLBz67r46DshalUNt9PQVAy21UffMG9AHH0p+o0VyC4XvMZWLpsnHVb7tRsmzZwpRTlg/qW23ZeOXZbZAy2laVUEYUw6dnQT1nhDgBkSQ+avsR+0T/icTE39iS2nf/9OsFz8Mv8omORa/V5sB2rODc7pqsHc+7RawnJYa
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(136003)(376002)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(478600001)(6506007)(38070700009)(83380400001)(36756003)(558084003)(38100700002)(122000001)(6512007)(2906002)(2616005)(76116006)(6486002)(110136005)(41300700001)(44832011)(5660300002)(26005)(86362001)(64756008)(71200400001)(316002)(66946007)(8936002)(66476007)(4326008)(66556008)(66446008)(15650500001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?iMUDIb6XOmELwo/Z01oyh8dxS32OsGOmhMIDCrNIeDEE3V5A1waiVXVM1?=
 =?iso-8859-15?Q?c68plUeMNnGg+bJBC8RjrqoHjNO3IgP9OxbcPQHOXsVLuiV1hYEYfSdWq?=
 =?iso-8859-15?Q?DO0y7cgFYb1ZW9hQ4rAM2+TtR6rY4N5mZciHzDzDHuO6G5m4Cs47I32VR?=
 =?iso-8859-15?Q?2vKgmdgPFyAu2rMf1OG+qF3sBy2gOlNVyt325l3rnCOg/ZrUWcn/V+NFe?=
 =?iso-8859-15?Q?I6pwyXBsQZqqQe1Cx037jK2Z47MAwinw1ms6itbLmPDE4T8YSOi8sKISa?=
 =?iso-8859-15?Q?rGC2UtyFTB3Xbh6nOaxdPkO99t1xmy06oI/E/HLMCC22iwLryvt3w2Weh?=
 =?iso-8859-15?Q?lsjJJMWWgFcT0PIlBiF33WnHJp18hxbcaKjqG+SfXaClLfBdv2OlWV1Yz?=
 =?iso-8859-15?Q?+L/DvZDd9b331D6G5WWBCsHcK7KIWItO6veF9dER79mKZQMXpiQyGgQcE?=
 =?iso-8859-15?Q?oNFpJBBmtC1Gam0msRY1ek+4rbDggqLn2Jcp5xol51HW6wSk0RIE2450b?=
 =?iso-8859-15?Q?Nqz+1IBf6axPC1lsBceG+UgvFCCYnb2+mO77aYq8SVYPC/mF/J4zJ8XyY?=
 =?iso-8859-15?Q?6yDeP0DHpiwiHL6X83YmBnserm6KpV3GmzSMsit81gpej4w4LDOgO5fEu?=
 =?iso-8859-15?Q?WE8qYFhEyBC/9XuMK0HFs2LJcaNrrPFIfStIfLaMSSHmX9r+7fbnS8kD6?=
 =?iso-8859-15?Q?17eckthsW7yGFKidrHCbWrEC9MyJHV2bujzlqeGSjby9B+S/90bNflqdB?=
 =?iso-8859-15?Q?5E0Ax/8ouBJrgonZHSHq7z4JfcGJsZrvIZdGQw5IN7HsZdJtr1xLluRmu?=
 =?iso-8859-15?Q?a4+z53gZBDZ3owKM0tj43Fgc6ssjZpH8W0sK6aw4tCo4xx7/fA/sSUTIH?=
 =?iso-8859-15?Q?fuCUm/UKrrYD/G3RCnIWc1Q1xq/WmzoR8JIzvMblFiSWSL5PZ/dIvzynN?=
 =?iso-8859-15?Q?zDEAuzmq2ic8e6ITFWBUHL22CzIb0W8PCjyejseLfvOaU6+PXDIhaCtst?=
 =?iso-8859-15?Q?H2iN3JiLVmWcLjcdbibaZBORh5hXtGyYdbrVMRoIra8JYBcT+nzcXYfhZ?=
 =?iso-8859-15?Q?g3AcEKV61yb+w+7+j4A8Frj2lhAIjHgx8bTMR5r2/9paw72FKSUFHE4N9?=
 =?iso-8859-15?Q?xDxkDL0xZjivPKqizevE1BjgT36aV0CbBzzQTF1Ec/6VC8V7cjK0DQhAp?=
 =?iso-8859-15?Q?tvx6GI6/+gk9nifkGOta5G1bz3mOYJ4ctOlvZT+ZOD9RW2skYIDMgNB6W?=
 =?iso-8859-15?Q?xguJUCJwbYpOLB3aUlkTtYPOBl11wHz05wDhsVIelAj1xxTyLS4jxDanM?=
 =?iso-8859-15?Q?DmAnW67+bhlV5NYo7hyHMHIiwb/uqrXGBBnOv5WgMsD/hlZJttBYP2nGo?=
 =?iso-8859-15?Q?Id4Bs9t50RlBnEQ+pSInu4C3B92pPR2c2UNB721YegKU+kKmgxyVYOTE1?=
 =?iso-8859-15?Q?FmSb2VrvTXGnBaS0iR+Xqj9Ew0wgPHCKpO1F7Vns0JfqL+feZGxxOdfOG?=
 =?iso-8859-15?Q?eckX4bVcHXeu4F9BxIv0M23H/Qjf5ODxsBYcmbK1ZDsQ9wgSfM1W+03jI?=
 =?iso-8859-15?Q?TbB05bFp7jr4PC3xIhW/MEDy/CMGt7WfVxfYrMTgk96kfmq3t/qLQvQPj?=
 =?iso-8859-15?Q?1wlU/f6NnegiKfbz5H7ftg0HS953M94UNkaBmFx6n814t+OWVE7+uqNV8?=
 =?iso-8859-15?Q?G3MyAc0qWBuz4xM+dWco8/zdEg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <750A74A76EC5CE43B66057F88E5AC298@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fa1afded-dea9-43e9-fdfa-08dbe1e48e47
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2023 11:59:55.8858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o3vzJaIpgJ5D9XN1naukMoXU/ptgg1rKjXiqDTZ9Xu7b0Cp/uO8TDEJjgmjEiczASegiWC3eUN1kxYBF3l1f3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9664

On Thu, 2023-11-09 at 18:46 -0500, Benjamin Marzinski wrote:
> When resizing a multipath device, make sure that all the paths have
> been updated to the new size first.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>

