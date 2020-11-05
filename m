Return-Path: <SRS0=33od=EL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A61C00A89
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 11:54:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EC7F520786
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 11:54:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC7F520786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-kByONbefN3SxXUBX9J3pVg-1; Thu, 05 Nov 2020 06:54:03 -0500
X-MC-Unique: kByONbefN3SxXUBX9J3pVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1110D5F9FB;
	Thu,  5 Nov 2020 11:53:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C94021972B;
	Thu,  5 Nov 2020 11:53:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2BD9C183D021;
	Thu,  5 Nov 2020 11:53:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A5BruwF005634 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Nov 2020 06:53:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5931D2156708; Thu,  5 Nov 2020 11:53:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 52F01215670A
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 11:53:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0660E1021F7F
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 11:53:54 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [51.163.158.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-534-OQXCfmRrOaSHfnWbuyTtQw-1;
	Thu, 05 Nov 2020 06:53:47 -0500
X-MC-Unique: OQXCfmRrOaSHfnWbuyTtQw-1
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur03lp2057.outbound.protection.outlook.com [104.47.8.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-13--AE2gQ9kN9WpvlMDgSwESQ-1; Thu, 05 Nov 2020 12:53:44 +0100
X-MC-Unique: -AE2gQ9kN9WpvlMDgSwESQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB3PR0402MB3897.eurprd04.prod.outlook.com (2603:10a6:8:12::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27;
	Thu, 5 Nov 2020 11:53:42 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2%4]) with mapi id 15.20.3499.032;
	Thu, 5 Nov 2020 11:53:42 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH 5/5] libmultipath: don't dlclose tur checker
	DSO
Thread-Index: AQHWqYGhMjFC8lt10kOGjZ1zvJEYX6mwsJ0AgASH7oCAA2sxgIAADVoAgAAIBQCAAAzPgIAAu66A
Date: Thu, 5 Nov 2020 11:53:42 +0000
Message-ID: <7f4e67e0f46fb97ee2099d1651a7d41643d4d7d6.camel@suse.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-6-git-send-email-bmarzins@redhat.com>
	<095833a0bcbc5f1bb792555b43ebf526553d0c99.camel@suse.com>
	<20201102182711.GP3384@octiron.msp.redhat.com>
	<589710d08d286f358a97044834550b7f9db47e67.camel@suse.com>
	<20201104232724.GE3384@octiron.msp.redhat.com>
	<ce13eccf5ea69648ae6c814a330201bf521a9212.camel@suse.com>
	<20201105004157.GF3384@octiron.msp.redhat.com>
In-Reply-To: <20201105004157.GF3384@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [88.73.133.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84488078-9102-4107-b5d9-08d881817143
x-ms-traffictypediagnostic: DB3PR0402MB3897:
x-microsoft-antispam-prvs: <DB3PR0402MB38975BBE4CD73832324C72A3FCEE0@DB3PR0402MB3897.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: vwb3gxS13fEp9X62YbDnTKJgK26KoQUu/XLrLvaAcs3a0ywsUpdpg7cKfe2C2cno7S1MFb3PS7dH07Cq76F8Wjq1XuJqfb7YcFMKUy3PUpGRZWzvOA+sx87ROZvv5ZNxBDcHEQROSG99WRAydw3MDNPEbAA9+1C8AESjb2mSHUWlXbD+hheEsXhYu4cC/lpCq6o112Al2aEzF5kC8Q0SkcwmD3w/I4h22ak1eOalIq5cKkwYz3vDfeQD3S+a8u+Gj3q2EmHyUZLYOqGbz2/xR+0jTUKXcc38PCfaA/jlUjuOrhPpUdPvpcvzmEfVcI5dqnt9D+V13F6w8AZpEbOFqQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(396003)(366004)(39860400002)(136003)(376002)(8936002)(186003)(6506007)(86362001)(5660300002)(6512007)(6486002)(450100002)(44832011)(76116006)(91956017)(8676002)(66946007)(36756003)(478600001)(6916009)(2906002)(66446008)(2616005)(4326008)(71200400001)(316002)(4744005)(64756008)(66556008)(26005)(66476007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: IfNbswZgneIBz3vIWQw2dClrKvmL1eGEI5HKarSt2j8ck669dDxHNHBMTusHNx3KS89+zKruYD/i6XAxuV0qwFBOdaUDDVP5mSqNwl9SnkhCtD0KW9wchvEfcwjNyDfyH84RNU5eeDXkprbvIABsJOiExst6wwEGPdUcmvL9Isu/ej9sgNYhlG5b/vnVAEMFsLH4GcMf6B7GJukkE515Q0MshcsoJnPl4HpOJlv2a1WvM+Vjj2DwPXROw+W5oawk2NgPhv9zZJ+C9oExEgBZi9OWjuCL0/rxqcXzeP6UnkynrJhsPnlkqnVYkPhTvh7o+7mWfPoe0lplFfWTrQsTepxyUtSik5FqHKcAdE+QBshvsir7ATL2tHUOp8KLCEiGYFZknSBv+1nwBJ1q2eOZzy6nzWnSqJuOuDzppipzgOPfXDOphmufCy350zbZq8iPw1/gCpancAVN2BPDOje1bPgiW9hZFEgziWfhlPq3dJT7Ax1UxbgBMee4w1+POsl/fcSJr3nRlfHMABs3EzoI0oRJLxFPlebhKnUBD6Q5MwHkerxZD441uXH0peZ/fRusUGBmyHG6v2VOgMi+tjdOZjbIQLepPmTsEpWGeENkGaythUXYHBkbEwqWnbUMkM8Q06xmZ8/1q6eN43+lFIXfJg==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84488078-9102-4107-b5d9-08d881817143
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2020 11:53:42.2992 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EFcHdtYLighflkax/QqwnfyeqdzhQkFePtSLzZSqbIhkD41d8X4DUsP+DLTFWEBdJB+vDcCzppjV9M0ohEU9Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3897
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A5BruwF005634
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/5] libmultipath: don't dlclose tur checker
 DSO
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <4044547B195568478E620AD3D74176D6@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-11-04 at 18:41 -0600, Benjamin Marzinski wrote:
> On Wed, Nov 04, 2020 at 11:56:07PM +0000, Martin Wilck wrote:
> >=20
> > I guess the key is that the thread's entry point must also be in
> > libmultipath (i.e. outside the DSO). In pseudo-code:
> >=20
> > entrypoint() {
> >    refcount++;
> >    pthread_cleanup_push(refcount--);
> >    tur_thread(ct);
> >    pthread_cleanup_pop(1);
> > }
> >=20
> > This way the thread can't be in DSO code any more when refcount
> > goes to
> > zero.
>=20
> Oh! I didn't think of solving it that way, but it makes sense. So,
> were
> you planning on posting a patch?

I just did ("libmultipath: prevent DSO unloading with astray checker
threads"). Please have a look and possibly test it using the setup
that failed for you before.

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

