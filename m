Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7725AC28D13
	for <dm-devel@archiver.kernel.org>; Mon, 22 Aug 2022 18:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661191958;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=venbk4y8Kx1qe8NUfoStgSAGXEsdOPAUxEDiqOtkjko=;
	b=epqZEnB4krilO3oA3dh+v6l/B89qSDtRJoBcUG3GOIqhyJ2/nF/Iw7BtMi3KE+icQZ+1Ak
	DZXZZoy6moh7gFG3+KcjarIm5JVm+mRXzjmkw5DDFoAfeMFTk9pVOuIq3Fkjvdodw1TqJb
	ugxDPvFHV0+e9mBYILyNnGMiDVjz+Ss=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-VmSFjBFIMraReX9EonVsLQ-1; Mon, 22 Aug 2022 14:12:36 -0400
X-MC-Unique: VmSFjBFIMraReX9EonVsLQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95FAB811E87;
	Mon, 22 Aug 2022 18:12:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2D74A40CF8E8;
	Mon, 22 Aug 2022 18:12:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BE5ED1946A47;
	Mon, 22 Aug 2022 18:12:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1E9561946A5A
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 Aug 2022 18:11:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2ADB82166B29; Mon, 22 Aug 2022 18:11:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 257512166B26
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 18:11:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B82985A588
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 18:11:58 +0000 (UTC)
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr140058.outbound.protection.outlook.com [40.107.14.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-fIaobeP3NZGnXUKqEq2XkQ-1; Mon, 22 Aug 2022 14:11:54 -0400
X-MC-Unique: fIaobeP3NZGnXUKqEq2XkQ-1
Received: from AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13)
 by DB9PR04MB8347.eurprd04.prod.outlook.com (2603:10a6:10:245::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Mon, 22 Aug
 2022 18:11:52 +0000
Received: from AM8PR04MB8036.eurprd04.prod.outlook.com
 ([fe80::650e:243b:14d5:4593]) by AM8PR04MB8036.eurprd04.prod.outlook.com
 ([fe80::650e:243b:14d5:4593%9]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 18:11:52 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH V2 3/6] multipathd: Occasionally allow waiters to
 interrupt checking paths
Thread-Index: AQHYtlKnWK9fGhDK2kS+zOeJjDdcng==
Date: Mon, 22 Aug 2022 18:11:51 +0000
Message-ID: <7eb895de329e17fcf0a788844c8418ea309d62da.camel@suse.com>
References: <1660769316-5302-1-git-send-email-bmarzins@redhat.com>
 <1660769316-5302-4-git-send-email-bmarzins@redhat.com>
 <e0f0516a08bf8fe5dddf058e5b9c9fad494340ba.camel@suse.com>
 <20220822174632.GT10602@octiron.msp.redhat.com>
In-Reply-To: <20220822174632.GT10602@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2cf9401-7136-4568-7de2-08da8469c9e6
x-ms-traffictypediagnostic: DB9PR04MB8347:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: SSRxS7krKa2VM4LoMR97un3AxK+Z8eljG0tkLatdahsYBb0lkpe+fj3ExdfY0ipRoqmrimSAft5E3lPzNxTfJjSyP9yn9qmrY97fpd2aD3lSo4plt29sX5wNflF0jF6SRW8CuMxiyDCXsKWhlNgKZM8UxnW/5Dz4CTPFVNB9ZdPZs25/c3Go4s5ye1Jz37iKPeDOxkXusvCmLWdp9yiCX+BIw/9KEkNkX7kbfXllZ2zx6nH/3tHJuw++fkb9HhJFig6sMFxGvblOMYj0kdTJCbGz0Ewditt/rR+eAjr2U7pijd3FvJawqEQWRJiRLqNufWSjAFvQGdvH0b8XE8UZBA7/45s8+NBABrsXz8FJv7S2qsiUD4cyX6wpXQb3LafyfTaBcJ5Zi5SOXNWQdqMMZfRGRS4C6HH+mtmPaM0KP64KRPpHiU3+jSIziMCd02V5qKZDAVsBhTlg4vYWnavn6YMpM/74IGQRiux1fZ6lJPSGUBvLd6hkj3a/wiPE9ZQMEp4iVT3rONbE6UiAvF9Cdmg10COaBGBY2q2KzozYNkiUjIEY6k+XO0SKo7REH+tY5jrVyDdCwDWm9SsqdkwcWUycFse3a5sPfCn89J6kwIFUi0L6ZDdLDDpV4wTa9BJd+lNXOrnWN4hGaAXJxvsWqZyVbM5AztVlm3WrD8daw5J7ieDeXbalcKYYY7rf1/FXjzCifUINh16VQIeZGnb6DabAIy5ZTog0O+9ten1ct/q/dUZRHEBKJY4eay9SnN2PDZ5HlheK00VNtaOk5tlo2A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM8PR04MB8036.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(346002)(39860400002)(136003)(376002)(396003)(366004)(41300700001)(71200400001)(6506007)(6486002)(478600001)(2616005)(186003)(6512007)(8936002)(26005)(2906002)(83380400001)(5660300002)(44832011)(316002)(6916009)(54906003)(91956017)(66946007)(4326008)(8676002)(66446008)(66476007)(66556008)(64756008)(86362001)(122000001)(76116006)(36756003)(38100700002)(38070700005);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?O2r06lF//VEl9UnmWcDPVgHsLtQAj8O1WjiEeKY0FPHSlnkWUI3bFQTWY?=
 =?iso-8859-15?Q?6B9pWQUVLBlBiOmguuOwaMlmIShdQbmTd9BlQkA8khr7IRge2AAo7/IhY?=
 =?iso-8859-15?Q?2Jsg3nrfryIEHvguT9eTd4pPokgcDjokEc4X0wmQly6XSA3JxZ+7hRgjX?=
 =?iso-8859-15?Q?6m7D732TD1urU5bBq+nQg+IKuHZh0sQOSd+PI36eqXZjSgoYUGW6Azfyt?=
 =?iso-8859-15?Q?hpS9M4JZ+h/gyZroDkkMvTaarVHj3Z+JfTycPuoOGmvG4R5lu8QTlGSPS?=
 =?iso-8859-15?Q?97DBqcOcMTehzJgKQ6gFqSZ1ACEtkE4+5mi2KnCaoiPNFVzY9TU2uAkpn?=
 =?iso-8859-15?Q?A3/aN7rqBcvFW2Op2noAcCqBbYrXf62eCwXclzf7VTqreI2XkRngMowQf?=
 =?iso-8859-15?Q?bLV04+lPUQFPISgrZqamqEryRw+drzrlOImVN/2yfn3AWA3SZOOS8UooM?=
 =?iso-8859-15?Q?94SBSJmliPKsdpWShwsUlhKVBYTYfXo0gbBld8FaEkOa3mgtP2iJRLmvs?=
 =?iso-8859-15?Q?aOcoEOdLkQ3o2xmvK9kGYX4ANSwUVbI1OFCGJO8kb+Tx8Qcu1UgczK49+?=
 =?iso-8859-15?Q?sWbJAxemSuU9F0DXd+Jm91gAbjmNrlGbQIGbRMG+pzHbJwCYPsAeNpJXa?=
 =?iso-8859-15?Q?7s/EROV/us/Z6TGu/N7RbzesJL59yMBkmDnkuTL8OLvWHNPcxLSfhJrdX?=
 =?iso-8859-15?Q?0k4Rp5xyg7iwqUKgeJjPKgmjyZx1sGj4pEBVC06NrhkcDSqYpB/Z/P9HH?=
 =?iso-8859-15?Q?TSfrM39s3xP8EtgdM/t0hl030QAkRW+/eiGGBNKp3BzzonQbmUjqOWRXF?=
 =?iso-8859-15?Q?v5xjwrViKnGfDeJP29cse8nxXg6V/oMAU+pXjgTwDewKOUH/u2dEGJabQ?=
 =?iso-8859-15?Q?mo/aRqoG8N/2REEG3Md5dMW0BddJriS7JBOcxm6hancG3XHslyiZ0X/Kf?=
 =?iso-8859-15?Q?6OmE/ixooykRJLhJWiPblDsc3fvDaVy2ehXIAzwFKy8VkwpTs4PdyCv7e?=
 =?iso-8859-15?Q?kZjWCvn9xR+PWKzYVhXy4opWhEiuBMzzYXMSBPDBRdmramSV0f7hPHZDv?=
 =?iso-8859-15?Q?1Dk/JTQPowsmYvyZsheU+O4+nMeoM0QH8qPgU0nw1K0pe8+HzdVztiDe4?=
 =?iso-8859-15?Q?vWbM3NkNlsT19X6sNehVi8T+3FDj/jHa4ZGRlZ6VITrR3GQCY+KiFzMpf?=
 =?iso-8859-15?Q?1Ly+1sQVQC9QHEEbiKDA4lALFb08+CabQSi0JOxPnOzyUbXG7Od08yvC8?=
 =?iso-8859-15?Q?ldKounodv7BnROitls1x7h/Pv//OcCVVH1XshFG3UVje+QnE1evaKsJ/Q?=
 =?iso-8859-15?Q?ica7pZ/prHAgYpSIzH6Anmq4MUZHydiqbKAV/hJVcnOQEW5d+0qq1Qe1H?=
 =?iso-8859-15?Q?li4pf17PXQOgadTkypffs6+fHof0N2sv7d8TX8boH6VPKQcdJ3rD/BoIJ?=
 =?iso-8859-15?Q?n7qOVG9AfvpYruby0TnB6qBzIsLOWAOZ2pVskkt8iwcQh8Ktudyxgp+hU?=
 =?iso-8859-15?Q?hp68ECTBBbXat9LrRc7jfjBraxuBN/AbRj7Km2Eo49XR+J7NlYy3X+HKW?=
 =?iso-8859-15?Q?Q2c+sbL3u7VB7rzkkq2pFFBp+jNoOIAg1p0wtQ9OiYA/SLy3w5p4jAWkH?=
 =?iso-8859-15?Q?VU0b+Kpn9i44UgXmDZd7BYVMDIqKb01r2u2cuC5pEpIHEe17zawuIAEKm?=
 =?iso-8859-15?Q?DfU/i+a2fmYgXn1I/3Af9EIfPg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB8036.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2cf9401-7136-4568-7de2-08da8469c9e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 18:11:51.9635 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lwzm/UqiA0X4p4PX3gKZ4zr6ALH1Urjm9F97KEVgsM++CJRODXsZGsvumFq4ZqGC1A4HXReo+rw/DDmZJjq5fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8347
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH V2 3/6] multipathd: Occasionally allow
 waiters to interrupt checking paths
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "wuguanghao3@huawei.com" <wuguanghao3@huawei.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <408DB51F107EE94894D3E39465DA6F06@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-08-22 at 12:46 -0500, Benjamin Marzinski wrote:
> On Mon, Aug 22, 2022 at 04:15:01PM +0000, Martin Wilck wrote:
> >=20
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0if (i >=3D VECTOR_SIZE(vecs-
> > > >pathvec))
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i =3D VECTOR_SIZE(vecs-
> > > > pathvec) - 1;
> >=20
> > What if VECTOR_SIZE(vecs->pathvec) =3D=3D 0? Maybe you should catch
> > that in
> > the while () condition above?
>=20
> I could for clarity if you want, but the code is correct as is. If
> VECTOR_SIZE() is 0, then i will start at -1. This will cause the
> while()
> loop to immediately exit, since VECTOR_SLOT() checks for i < 0. Right
> after the while loop, i gets bumped up to start checking at the first
> device (which of course isn't there).=A0 It's the same logic as what
> happens if the while() loop searches through the entire pathvec, and
> doesn't find any checked paths.=A0 Obviously, the empty vector case
> does a
> bit of unnecessary work after finding out that the vector is empty,
> and
> I could add something like
>=20
> if (VECTOR_SIZE(vecs->pathvec) =3D=3D 0) {
> =A0=A0=A0=A0=A0=A0=A0=A0checker_state =3D CHECKER_FINISHED;
> =A0=A0=A0=A0=A0=A0=A0=A0goto unlock;
> }
>=20
> If you'd prefer.

No, it's fine. I realized that your code was correct after I'd hit
"Send" :-/

Wu Guanghaho, have you already some results to report?

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

