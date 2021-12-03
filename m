Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 659E7C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  3 Dec 2021 08:01:31 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-ozZ2727pMPqwbphyMdz1EQ-1; Fri, 03 Dec 2021 03:01:26 -0500
X-MC-Unique: ozZ2727pMPqwbphyMdz1EQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 815B110144E0;
	Fri,  3 Dec 2021 08:01:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FA9019D9F;
	Fri,  3 Dec 2021 08:01:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 50B094BB7C;
	Fri,  3 Dec 2021 08:01:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B381IIb024614 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 3 Dec 2021 03:01:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A023BC202CD; Fri,  3 Dec 2021 08:01:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A9D9C202C9
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 08:01:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80748811E80
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 08:01:18 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-27--OHbyn3YOAaI3f8rDXnWvA-1; Fri, 03 Dec 2021 03:01:17 -0500
X-MC-Unique: -OHbyn3YOAaI3f8rDXnWvA-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2054.outbound.protection.outlook.com [104.47.14.54]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-8-NolFetiuPLmADUUkZg_ubg-1; Fri, 03 Dec 2021 09:01:14 +0100
X-MC-Unique: NolFetiuPLmADUUkZg_ubg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB6156.eurprd04.prod.outlook.com (2603:10a6:10:cd::13) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23;
	Fri, 3 Dec 2021 08:01:13 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%5]) with mapi id 15.20.4734.028;
	Fri, 3 Dec 2021 08:01:11 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/3] libmultipath: keep existing dm_info if you fail to
	get a new one
Thread-Index: AQHX5+Xqpvh6l62WUkukubzMVUKKvqwgaBEA
Date: Fri, 3 Dec 2021 08:01:11 +0000
Message-ID: <156c11a293ba2f59487dbeb7bdd959f49bf6de7d.camel@suse.com>
References: <1638495252-15739-1-git-send-email-bmarzins@redhat.com>
	<1638495252-15739-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1638495252-15739-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5f37e5b-fd76-410c-d6bb-08d9b6331206
x-ms-traffictypediagnostic: DBBPR04MB6156:
x-microsoft-antispam-prvs: <DBBPR04MB61568B4B6FEA6B544442EC05FC6A9@DBBPR04MB6156.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: lckZ0bliJuGZH0EHQ5c/TtOI+WU3jZCybcW7DxqbJaTnb7WEDHno0Cvl2Mq1FqCWY5LijDa7XRvHNBk8lHFYLAetY1K/+10/x3TavGnYeWW01bjBLq+h0PlRLOukKc1kZEGUgrPJ3EHxAEf0jijkZHGjGen8m4G8ZYsIZv5prT9dlWmjUESJVsNwfsqbaSz5lAVPq7dqQSlt7YApkBmqJsRgy5xTvyyHvnBZvmJY4WVqS4xSa6GwEprWpA9iQRT/oWIFC5e/PzmiTH+HwrnEENrYtSmXCa7V4XwyXlI55kSJVP6LyvlCR8i0V2OHp1KL2erXlThCr/pm89xIavyfF5sSLljxTrhklVCkB4LVfW9cUu7gikyIrHb/NNe4BKkUbuGsckY3kxDQr4WF7IORJn3frM6HpLBaJfNk+kIyd9g0+mmsvKB5mF1Sguob2bRd1fkEfpx9/yTdSZmquGUFMVoXD3V11vFJHRUynvneO/XQT2UJTVg2GY3dR6ueH6IeewR7vW7ENu7UsISJ8b0cxSepZVy22c4KsPc1+VOBVPlB2C/90iPFxJaUCytsa8V7cvXBQ/RU3OcPRioNFTLYlQvrrnl3QQ5UL/H43M5MG8qU+eShlqW8rNgtGgW+DTy+L2hGSXc3+7uhqaYJCJ/JQewXHgU+e6LKv/QiWCHm1yM34bO0PirwkOYGL3OvZLKL7xHDSKJmgr9U/TC5bFIZUZPHcpstBJke1xYfgS4B3eqnSVyXp6WrFfucKBTHDLg7yMFbYMtS0h7Wu3yk/r62vyua61KTo3x8mpxq8Q2ZIKo=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(4326008)(2906002)(5660300002)(91956017)(36756003)(44832011)(71200400001)(186003)(316002)(76116006)(86362001)(38070700005)(64756008)(6486002)(66446008)(66476007)(66946007)(66556008)(8936002)(8676002)(4744005)(110136005)(2616005)(6512007)(26005)(38100700002)(508600001)(6506007)(122000001)(83380400001)(141363001)(183983002)(141353001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?1FaY5oUnRdt3m6EgsJtXBCFf+XarKRBcs2zAaE4RikF8BpMNtXm9pEGSb?=
	=?iso-8859-15?Q?jvAH2nnNBJ+gsgAK+NKzE98LX5vVKTlrzgwdD9Y1IUtb407KCRvmOHK4u?=
	=?iso-8859-15?Q?8fAtFo0kPOKjLpObc7QJ4KeIIlwgwutbniyikLuov3z8ZaMrHO3ibyElE?=
	=?iso-8859-15?Q?B95XHwsXGxqgwokunmw/70HMC+O7ff4JKluVo1MV+KwpWadTs9r8Xn1XK?=
	=?iso-8859-15?Q?HryV4lY3Rp0MVZgLxHtdnVO/Ns8ripIdYtRtxyTl3g7l8lmhj4hxG3lo7?=
	=?iso-8859-15?Q?j7QwT2HKDucf4BA9hvb3vqh8pvaaNshJZcFJIdk6tC01YAkGSFdIeg2VL?=
	=?iso-8859-15?Q?Y0oTNxdQdqYtmJuIbUcSXNj6RDFSLU3nvSnRSOlbWFaEP2cGPuj25cQr+?=
	=?iso-8859-15?Q?UdHVzFV+pMvX4OvG1QRtfS8IKTWlujpgaO1ImL/Cx/VdmdFtT3v/Z5Eh0?=
	=?iso-8859-15?Q?ahoTJBBf6muWh0Nhw0XqQyhJP4by+Ki4dVqnw5kbgMEfc0SDv/4otmJT1?=
	=?iso-8859-15?Q?ZQRtS0kRxJjIZhCzgrFQWMwVXC9CyGZoNRf2lH86mK7Oz8DtIKj9qrhjS?=
	=?iso-8859-15?Q?KdCopA5fcCt+Izv2ZEQKpMiTtGNABMjNMrfqER/tVwyTGAJrAl4aUOm/A?=
	=?iso-8859-15?Q?/eb6s9CzJeMCbC19dGT+gY5xUjTlUYJK8Zhx4RGL1rnMPfeR7cQ+oUsMF?=
	=?iso-8859-15?Q?pIYhmRWJWM2e6WKDmcLStA9fSYKcafgK6nsH0Fv8E9krdRdw2iartdNL5?=
	=?iso-8859-15?Q?4g7rztOPt5+Q6YjT5l5HHHvtnGghvQ6fIzrVKu7A05YiRamYXniUe57NL?=
	=?iso-8859-15?Q?ynOJDjTPLP4ovjNlhM3E2ua40wSX0v/CVyKvotDw6XIyZGZj6Dsb4d/7Z?=
	=?iso-8859-15?Q?dPKNllIZf/mjjWeChPSMQUiD0nH5L5FTVaiqW4m/a49I4k9B/5jBJTDeg?=
	=?iso-8859-15?Q?eUAZmE2EtNtKmCP872tP2plhCuTO5k5PrGfbes7dPmceynPGObSOEQReQ?=
	=?iso-8859-15?Q?g7abn0PteXZTle/QG6njM3SAVO3m/Xme0jrXF+LZDzftWKNcX+ZqPpZT1?=
	=?iso-8859-15?Q?DD/u4dGlrV14W/FSD9rgaA1UKgFlJTSoO+dGV50C6Ow4IvUm/0GJZ3fN+?=
	=?iso-8859-15?Q?347O2375AkDNxc87yr9ue7hmotGCi+iKDXYU0PWDqTkOrXD/rd/cn5HbF?=
	=?iso-8859-15?Q?kzQG7WfUleAlLbam3cbI4TS5Gojle+r1hJIGJj/sZOmwT9z9r3wm7hj4W?=
	=?iso-8859-15?Q?rY71MUbL9Sa5feufZ9YgyQxifKu7X6BipGDaZbZEVscx+vxXpneRbypz6?=
	=?iso-8859-15?Q?PgjclFckYx053s0LggNLHY4ZfDzUZOUzMC6Aa//Dno3Nvjh/5VVf/JkSM?=
	=?iso-8859-15?Q?1cbJe/UrTLqDW4V4y2UwZLU5fWM82m/7aeayzFJqo/1fLdIjwRDQm5Puk?=
	=?iso-8859-15?Q?MBIm5xopE/9Zw/4uoCbHXuMLCXiIpkuiqDy5wwzouHW8YUqKyLdVLsEH9?=
	=?iso-8859-15?Q?hBivx5RWFHXgiAQvyugwoj6GEt98Ak9Jg8u9IHCKUcDd1MDYwgGhF46JB?=
	=?iso-8859-15?Q?7qKX2LzymMt+pztmTlylvFAeyxFCybm8dZ4ms05SlrZt4HnzPWPjT+hfj?=
	=?iso-8859-15?Q?mMM2qhWwewtjkpuKSZt5ZSNI4nDpfD4KcG+wCfWdS6+p3lmTHpYj6RrLa?=
	=?iso-8859-15?Q?BMvbOLUz2/ALyjg5qbPX8D4Yq15qwSC9JHJVAvF4uIjskp0=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5f37e5b-fd76-410c-d6bb-08d9b6331206
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2021 08:01:11.1261 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C1h+9v972oqr3f1+xO5/vw+PkA//M70vSFKmxTf2jt0PHC5nR4OY19VGSakRwVKOiBgQszu5T/gj23kIVPGb/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6156
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B381IIb024614
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/3] libmultipath: keep existing dm_info if
 you fail to get a new one
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
Content-ID: <BDC91182D62B9A4FAC7DDC9495AEC61F@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2021-12-02 at 19:34 -0600, Benjamin Marzinski wrote:
> There are reasons that dm_get_info() can fail other than the
> multipath
> device not existing. If there is an existing dm_info structure and
> the
> call fails, don't free it.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

This is ok, but I think it'd be better to simply embed the dmi struct
in struct multipath and thus avoid having allocate and free it
separately. Either that, or just use a struct dm_info on stack  in
dm_get_info() and just copy the properties we actually look at, i.e.
read_only, major, minor, suspended, to respective fields in struct
multipath. I'd prefer embedding the complete dmi, as it's not that
large and contains other interesting fields, too (for example, we might
be able to leverage the event_nr field to avoid duplicate work between
uevent and dmevent handlers).

We would need to be able to figure out if the dmi is valid, but that's
rather easy, we could simply set major = minor = 0.

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

