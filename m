Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38BDAC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 17:59:06 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-CyFXc-41MT67nQKgtwQN1A-1; Tue, 18 Jan 2022 12:59:01 -0500
X-MC-Unique: CyFXc-41MT67nQKgtwQN1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A04A1083F62;
	Tue, 18 Jan 2022 17:58:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AEFBE38E1E;
	Tue, 18 Jan 2022 17:58:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ABF424BB7C;
	Tue, 18 Jan 2022 17:58:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20IH0jdv005061 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 Jan 2022 12:00:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3890EC202C6; Tue, 18 Jan 2022 17:00:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32C7EC07F5D
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 17:00:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1985E85A5A8
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 17:00:45 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-118-o0oD5rjNNPmwJ3vQZYkASw-1; Tue, 18 Jan 2022 12:00:42 -0500
X-MC-Unique: o0oD5rjNNPmwJ3vQZYkASw-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2050.outbound.protection.outlook.com [104.47.13.50]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-37-6kzCzpVQNCyWEFWBVomCpg-1; Tue, 18 Jan 2022 18:00:40 +0100
X-MC-Unique: 6kzCzpVQNCyWEFWBVomCpg-1
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
	by VI1PR0402MB3343.eurprd04.prod.outlook.com (2603:10a6:803:8::28)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12;
	Tue, 18 Jan 2022 17:00:38 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
	([fe80::2108:82b9:81f9:80ae]) by
	VE1PR04MB6560.eurprd04.prod.outlook.com
	([fe80::2108:82b9:81f9:80ae%6]) with mapi id 15.20.4888.014;
	Tue, 18 Jan 2022 17:00:38 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 0/3] Misc Multipath fixes
Thread-Index: AQHYDBtlIu5yzVN8n066r6ZS6j6XU6xpAZ2A
Date: Tue, 18 Jan 2022 17:00:38 +0000
Message-ID: <5abcaa5a82c3882bae2d79eb048756fa5f37ebb8.camel@suse.com>
References: <1642476453-5974-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1642476453-5974-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30793b60-e532-439e-5e58-08d9daa40d55
x-ms-traffictypediagnostic: VI1PR0402MB3343:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB334361184DE181C847F9F0D3FC589@VI1PR0402MB3343.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: GcB+fGB33yC9LUW8jnPH9VY8KUUJtCCkbpzU6eiEMxcD+B4zoYslEa9z1dPUHlsKosOzCW7lknkRbJotULTutH02B6DoX4Ur+ygltjWeLp0YQKn0xdsITPvBEPqUc/KrapgaJkbFlW1uScH5fxzQpB3o1qq6oHDon6w0pG5VwZ1clSGFSynnO9DRrDsZ7979m31csTpl2BRSdGRtU3p5dtmvd0hzMK/U3b3i43ws6Kf6WJZDqi7E6LdWZLn+ommGUnJ9XUdH03URJTQMxW5gDkmuMcyosmE0FhbfyxweOpaa4mLqPlzvqJq8Te2/5xkmBF4B45InsUz3jwafx+1/H1oY0tFYCnqPupN1gKlX+oTEN/f/y0Ufc8ZrnyJpWU9P1sqkisnOfNW76aHz5+fG1t87nQNd87FeTBf3SdJuOCQnm8itqQMOz1CEUiBrNknwyTlv/6mv9u+o8e+AUJaqoyqQI0SGaSExyXzNy9elaPiTrn9qrueBPVxCAtjPtftInBXERiGmXXHIE1eBWzXgGSi3RTdkQfz1vv0OmAKdSVVSvSUuUk8R5dffEGsa+penUoB1MkmSlGMD5acst+KruIoSS65jcKV08JWBLy7zfestMFL7cdV/UUUw4BkMN02WcDHe0ctCoEylgyh7wZMoU6jJ2DNI89NyFfJt0GubxneYgWV8T3leh3DLiyEN1V0xsppYoT+uJvAmRMTTYeU6/w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:VE1PR04MB6560.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(91956017)(6512007)(122000001)(76116006)(44832011)(66476007)(66556008)(86362001)(66446008)(66946007)(316002)(26005)(6486002)(110136005)(186003)(36756003)(8676002)(38100700002)(6506007)(2616005)(8936002)(71200400001)(64756008)(508600001)(83380400001)(4326008)(38070700005)(5660300002)(2906002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?sAOEhdPul+8isO9A599LN5c7X7kKSk9FTT5HzKM/6BDkN/Ui1jGoNGTz9?=
	=?iso-8859-15?Q?Frs/Av/HVN5/Fy4QFnUnTZ/vk6zoM+C0PkvwUGtG6HuXiZ7/1J+7fkQHq?=
	=?iso-8859-15?Q?hbcaN/G6SN+8K4f3xAJLLAP8o12MyunpwcBJkGFl/nJwLUvMlhauNgxCS?=
	=?iso-8859-15?Q?dsnDsuervj7KcxIwCE14356ML4xZKygbtLfbXaDpy2vcM4FJmzZTyTumT?=
	=?iso-8859-15?Q?JR+jbHC67w8vtnz3npKS+e6ZIS3d3nH7CINs14OHQ9WF9/8fiGsbXXlFa?=
	=?iso-8859-15?Q?Ftl/Rs6jPuEAU+JzszCa4TBupJZxvbpU0s3nWBdAuK1QrADwI8N4MphNu?=
	=?iso-8859-15?Q?KAamybILPqgRK6XDJ16kpfu1Syhob59hHpLiGpjWlYLDqjGQk9b984Y8i?=
	=?iso-8859-15?Q?pvr4s7cGbkqW1mPB5M9aJLPwsZ+iQtwb2fuOOAGNnC/gvPC0VH0y6ttDR?=
	=?iso-8859-15?Q?AnNYZ/RwXFi95ol6e8OpEhaNElncVdzJ0pOPvJTqr655vb0bVlGX+/0Qw?=
	=?iso-8859-15?Q?gKH8xMDdS3wK/oJCgfyUUiLHneBHc4APv6O+jqCh1FgzhADeulsamZqwY?=
	=?iso-8859-15?Q?vAsKwGSDxQwRqVKaJcy4/1a0JlDwzCQTjBqLKxPW+zHj5STnFEAawbqOE?=
	=?iso-8859-15?Q?t9epyqPNGjX/5zxe4hjc6yT4d2lZu0gHZt8xCSga0ljXpY58fLSPUoKfO?=
	=?iso-8859-15?Q?8pAUTccdumF7oWdsn4eUT22mWF20yh+zn3JS2RzwHjUyxWwvLijDd9qqg?=
	=?iso-8859-15?Q?HBRVAVkZodvd8eeqJwaMWaXwTc3PHA6CW29yUMv4DPZ7aPf24CxExYNfO?=
	=?iso-8859-15?Q?DH2j0NBcJg/rEVfU4hOIYjDivYFUINoXc+TNQzv4I5mxnC1UhK9LBpNoq?=
	=?iso-8859-15?Q?kKHGmxEl4/XiGTqzfUw/p6zVKNMOZKzA267pGUGLLXPAWILQqZvB9TIWh?=
	=?iso-8859-15?Q?o/hQX5Mk4HXHgReG85ycVV3hs3/h3TgVVLYZ+A/z+XXSn+P6eMX88omBo?=
	=?iso-8859-15?Q?bsqLWQ0eQ3CwwyOA9D7Q54G0u8LY0N4Ege1Nlp0GHQNJEWrrP7oxRSo6f?=
	=?iso-8859-15?Q?n1JZNNDkds2ac9907QqkQKjOklXZvyiKsDgvyXrvNBhwFHOvwq2SJAnuH?=
	=?iso-8859-15?Q?/yG5/B0lQHrMZCEOSmJk7sOoGwKBPtwv8qAHmtGb/d70+dAFl2kDldibU?=
	=?iso-8859-15?Q?0pMv3YH1GiozHFIi29SzgqJQ7bdoQBY1TIK3qgmO/LvsXojKz7vu6+Pq3?=
	=?iso-8859-15?Q?mEY9JyGFr5Bql3CJt00mLJTHqJplA1Eibr3ys9YuDDleZafBr8x1w7xGp?=
	=?iso-8859-15?Q?bko+TPBt3bLEeVf9ARwTPfsthVzH+kAC5HxefpxeduxtC9ul2Wrb1BriA?=
	=?iso-8859-15?Q?0osASzwtwp8WrDuY8is8bTUJgGMuX9qPKNIzomQZ2yFvmJJIlUEHDKw2a?=
	=?iso-8859-15?Q?euuaF1KuKp8KzNetew9pZVd+nM9ABAPvigDNuLTxOn6llb8z7sOBGzXOM?=
	=?iso-8859-15?Q?2KuLaUcq6Lw00SV2d7RdOCXOKBHHjHZRVbxqSQu/oClWIv5oSZ3EnqIU+?=
	=?iso-8859-15?Q?mMX8fw/2WB/4suexsRO5/HykpGDhbMXQRFBJSQtuJlTk/BPlRsN/E6fNQ?=
	=?iso-8859-15?Q?Fg6XLso88et5xMRlPHlGz4e3CZVrJ3mj/ttLBpNoMMilu6GH9+iq3FMPp?=
	=?iso-8859-15?Q?C4KjXx005DFFeRiuYsBmmzNQrTgqB1BxHIQANVPFImdusRs=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30793b60-e532-439e-5e58-08d9daa40d55
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 17:00:38.0807 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IbYuS5duNuXwj74OtMIPZ6+KwoxPbuY0HHR6gfhQLQMTlh0JrChqv8wGW08mHz1LdtBzrcpd3xjO5fpf/oBlLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3343
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20IH0jdv005061
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] Misc Multipath fixes
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <95F961A43B45FD498DF07C224E6DB439@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-01-17 at 21:27 -0600, Benjamin Marzinski wrote:
> This patchset fixes two issues. First is that disassemble_status()
> was failing for the historical-service-time path selector, because it
> uses pathgroup status arguments, which were not handled correctly.
> Second is an issue with multipath not claiming paths that are added
> to
> multipath devices in a window right after the WWID has been added to
> the WWIDs file, if multipath is using a find_multipaths setting that
> relies on the wwid being in the WWIDs file (all settings but greedy
> or smart).
>=20
> Benjamin Marzinski (3):
> =A0 libmultipath: fix disassemble status for historical-service-time PS
> =A0 libmultipath: make helper function to trigger path uevents
> =A0 multipathd: trigger udev change on path addition
>=20
> =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 79 +++++++++++++=
+++-------------
> --
> =A0libmultipath/configure.h=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/dmparser.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 14 +++++-
> =A0libmultipath/libmultipath.version |=A0 1 +
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=
 2 +
> =A05 files changed, 58 insertions(+), 39 deletions(-)
>=20

For the set:

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

