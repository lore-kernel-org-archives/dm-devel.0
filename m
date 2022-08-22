Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F74C28D13
	for <dm-devel@archiver.kernel.org>; Mon, 22 Aug 2022 18:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661191981;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2jrCv9+RtKkzfajEGC6Vop0J83vII5IAan3tqdZmmMQ=;
	b=SZCwYNWQcBIZcM0RksaDiUUhbKv2zaSYT+h1/b1R2ozSfEaChH6Mrc4nMxfz5Dq/RtmySM
	sUSTUGz4GKdWLxOtu72mGVubO43QE76N7hNjnGLKNfCzJ0xp6AahLSHDtahx7zUEkMCelF
	au0uE5T/hyIJvtR/coICt7aXk4/JGbU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-r4qoOvIvNoOx5emQ6foCgA-1; Mon, 22 Aug 2022 14:12:58 -0400
X-MC-Unique: r4qoOvIvNoOx5emQ6foCgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55FB485A585;
	Mon, 22 Aug 2022 18:12:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4201F40C141D;
	Mon, 22 Aug 2022 18:12:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 31DEB1946A47;
	Mon, 22 Aug 2022 18:12:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 72CCF1946A40
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 Aug 2022 18:12:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 44280492CA4; Mon, 22 Aug 2022 18:12:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FC29492C3B
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 18:12:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FAAF85A586
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 18:12:54 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2056.outbound.protection.outlook.com [40.107.20.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-s9Hmslg0OvWZCHjPNRu0gw-1; Mon, 22 Aug 2022 14:12:51 -0400
X-MC-Unique: s9Hmslg0OvWZCHjPNRu0gw-1
Received: from AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13)
 by AM6PR0402MB3782.eurprd04.prod.outlook.com (2603:10a6:209:1a::25)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Mon, 22 Aug
 2022 18:12:48 +0000
Received: from AM8PR04MB8036.eurprd04.prod.outlook.com
 ([fe80::650e:243b:14d5:4593]) by AM8PR04MB8036.eurprd04.prod.outlook.com
 ([fe80::650e:243b:14d5:4593%9]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 18:12:48 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V2 0/6] allowing path checking to be interrupted.
Thread-Index: AQHYsnrAkzfxuiza40OWfVEqVIMyra27QJwA
Date: Mon, 22 Aug 2022 18:12:48 +0000
Message-ID: <49307102bb9414b9f2b23ffd503378c6c32277db.camel@suse.com>
References: <1660769316-5302-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1660769316-5302-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3483c7a5-38cb-4138-45b2-08da8469eb9a
x-ms-traffictypediagnostic: AM6PR0402MB3782:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: SEN1DcSU1snBnfSqDx4YN53eLSgqAx7m9XmGI5i86aAfTxmnYKW+BfaeLdgMH6WUiM0b4DBR2+9Y3qsE5aeNxmbKXqLmz2X/Bfo1RVXK+ORR6PQ0nq4NXTccBk9eT4mX0iORvLvAcEM+5OfLVdi+DsCIsgHz+sSrgFZqjHkrjCMUznFxjasK3E3W4JqqdprHvNzcNs3J3FXVaHsGJyjOjk0A6MFsyJRRo2wspFYP41IfFrMJUhbmn73S1LG0Si6IvB1V9CHX4cJRf2Fu/Mcj0yTSj+U1c5RdIICGbmAUVro7zMvGkonz62xGjwfRIkpvGW5Atbd1xU0fX3JXmJVBSfQGRNeKy7XcONCdYQoSWGsDjT3FH9stMVtdVOPgl+Tx/VW7Pxpf44ewz8R9sNko3fnTKStnmiPE5pKc9+512KMaZH0ulFHLvOPDoIR1rsjE4HZqfcrEvKasuzb9ExM6naeZWWX+FEwCQa+u7fa7z6JGsitUgcCbf+cne0FeVs981UbE6DIknn8Hjdr4kPoeh15MD6kjj12Md6E+Lt0QC6YVmldlWdIA23P95e5Ux20wx6bIhRKji8dqfzvtje9kUo6qKwrrdBZdt3BrUuf1Uf0dEDKX8TInY9pcG/4/pah89nrYVhk62I+cVsBXdg9c2adnsShqDktNyeuXFo+vrDV3tRZ9LatHeL0EBZAjbdeEzUGQdUAn0Ee0klErq4jdVT1A54cQdNBpFFByZpIQUpmXVcHZHNaIdAwb7k/5eDBXJ86LT39tfQYVeWsl2azEpQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM8PR04MB8036.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(376002)(346002)(136003)(366004)(396003)(39860400002)(110136005)(8936002)(36756003)(71200400001)(54906003)(44832011)(5660300002)(41300700001)(478600001)(316002)(6486002)(8676002)(91956017)(76116006)(4326008)(66946007)(66556008)(66476007)(66446008)(64756008)(6512007)(26005)(2616005)(6506007)(2906002)(86362001)(83380400001)(38070700005)(122000001)(186003)(38100700002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?DZuYzpwV05NP328gDQE687TeewnQ0ZL9HZr2B0vTO6r4ACImKrTlI/Mlv?=
 =?iso-8859-15?Q?ODDzw6nhG9gOr2neJpmEk13a0rXMUWx/mcKk6HlD2Tw65oGZ+O+1YZOTv?=
 =?iso-8859-15?Q?AKPqcCVXU7Hln6m48PLy6JLTdU9T/6mddAbu8vo4Ffv5XbL51etkuz0pa?=
 =?iso-8859-15?Q?O+OvE9TIWySR0NZuuS1FC/GdmQJC2aDT5iyPlFTI18a5mvBOSUNQEZJtr?=
 =?iso-8859-15?Q?OklgVuQDNfOqP1MY//AHPHYoVRHIY55/Wu0IJ7C0az7+LPC6v3ql9aAsa?=
 =?iso-8859-15?Q?vIwZT76zWQi3hhlmJJQ/FJ6BQ9IdABGhi7OZRPIVknnrZIcpgOROeVpjo?=
 =?iso-8859-15?Q?Idvf6Ha15WXXntpCbCkeHuwvFUoHva26anHnyM7MqvhThHBA0HfT/XFKk?=
 =?iso-8859-15?Q?mR4+brj3LlSVUI1a69OGA4C+BGpLCAmUnUlZfdk7k96QIPLqWT9ycrATg?=
 =?iso-8859-15?Q?uIEPqnFfJWiIlqDvs/rN7ylKhVc1AULfDVPNr8+BXIf8n7USHe/99avcN?=
 =?iso-8859-15?Q?s/DnHM2HSyDsLJULeMEjbKmMIVytuku8/6nH5BZOq0OUYtrJIsKQumMYu?=
 =?iso-8859-15?Q?9lRY08WDeVWIUqQP8cmYJYSXebVLBysOi5EPWu6cky1chYEMGoD+aBPCu?=
 =?iso-8859-15?Q?C3ItFKtP1jrScUTjNEsyW99n+KA+XPUJjGLeN9cII1C/mOv4Lwl1SOilv?=
 =?iso-8859-15?Q?e/xUMKc7h4Y9JDD+Bm6IcPZbwRSYRsAnOSV6eHMFAlrhNgkYZSJCVi8la?=
 =?iso-8859-15?Q?6Oe6OaIXNqT7uRBAk88ZYFc6E8AUWVqtu52xA2GuPha37qaIJ01SVvdaQ?=
 =?iso-8859-15?Q?QrTtZceibG2YnWdfaMwSM8Zt+9BYypFBTxTCXk+HtKKlbbSoOIqVDKgCD?=
 =?iso-8859-15?Q?aXKRvuyPvsrdGgHDsIm8cKMXkoEsSazTeYUHHoyOhfzr1NjF/SJvaMX9Q?=
 =?iso-8859-15?Q?HHHdpV33EIhAANTFcsYNW/4O3KMHU5x5tIcUx/chSW2flsAz5neKhHpz3?=
 =?iso-8859-15?Q?aS6mZ1AABcgvRWIgHFCZZArnwMSDgBE99MylMqAL9M1YFjua1Qmi+ywd2?=
 =?iso-8859-15?Q?H5En6Hf97b8fxETwfriMM/VY05pxkUfbftNeSA7xKt4bhy2JbYkV/p+YI?=
 =?iso-8859-15?Q?xxDXVFpSa53ZMSeeThRGE82t2HpTPK1br123FvuQhRDWDrFHhb+e8E6ij?=
 =?iso-8859-15?Q?hN2hm+0QfuRljaHHVrMdkQsg6YJSszM5Lq116E5ts8it3UywbiC6UZyP+?=
 =?iso-8859-15?Q?ccooOxCTLwB2Jg3wGReRi5/BHL1Hqa2I+znSZrmPTxivRVuWHy1mdq2E8?=
 =?iso-8859-15?Q?4nezG0KlIlFOglTlMCrJPoknax/3kq/jVC2RBPw4pBVsbhfe1erbML/22?=
 =?iso-8859-15?Q?1KAzpvtdQ3BtHoCY9JE9vbTKqezi2NjP1LvXUYg4JSz+cSOxOGXdZ5atI?=
 =?iso-8859-15?Q?TIDuyhMhHuFzPST6hRm45/mXLbBquQ62yPoznilPxeqWaIAhvHtpLHvNg?=
 =?iso-8859-15?Q?votH/JJGhgzo1EWm8ZWG0AS6KmG9tsyIGvBL7jh+7ZJbyKuRACMDfGYuB?=
 =?iso-8859-15?Q?Bu1x7MNIXTXM1dRURuN6Q+yWRBrGUnbn/QP8HZuAXkU5RXafH4anFP9hT?=
 =?iso-8859-15?Q?EHLxmv+829Yfiaq1ZR5z207lUoCZydmYH2zxKt3uOYLT7+RSb1Gn2lt4N?=
 =?iso-8859-15?Q?L96UPehJ9QoY7gr+4oGfXp0Y6A=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB8036.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3483c7a5-38cb-4138-45b2-08da8469eb9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 18:12:48.5221 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hWmNaZD17B635i4C2lzDYeKwZoOUfHdjKkNirqeVeQLGmWN0se8ShXNvzzjEGc4ybbfdoRA4pLTddlVOcp8MSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3782
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH V2 0/6] allowing path checking to be
 interrupted.
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <1EC767B2B7FA024A8073EFEB9DE3F2D4@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-08-17 at 15:48 -0500, Benjamin Marzinski wrote:
> When there are a huge number of paths (> 10000) The amount of time
> that
> the checkerloop can hold the vecs lock for while checking the paths
> can
> get to be large enough that it starves other vecs lock users.=A0 If
> path
> checking takes long enough, it's possible that uxlsnr threads will
> never
> run. To deal with this, this patchset makes it possible to drop the
> vecs
> lock while checking the paths, and then reacquire it and continue
> with
> the next path to check.
>=20
> My choice of only checking if there are waiters every 128 paths
> checked
> and only interrupting if path checking has taken more than a second
> are
> arbitrary. I didn't want to slow down path checking in the common
> case
> where this isn't an issue, and I wanted to avoid path checking
> getting
> starved by other vecs->lock users. Having the checkerloop wait for
> 10000
> nsec was based on my own testing with a setup using 4K multipath
> devies
> with 4 paths each. This was almost always long enough for the uevent
> or
> uxlsnr client to grab the vecs lock, but I'm not sure how dependent
> this
> is on details of the system. For instance with my setup in never took
> more than 20 seconds to check the paths. and usually, a looping
> through
> all the paths took well under 10 seconds, most often under 5. I would
> only occasionally run into situations where a uxlsnr client would
> time
> out.
>=20
> V2 Changes:
> 0003: Switched to a simpler method of determining the path to
> continue
> =A0=A0=A0=A0=A0 checking at, as suggested by Martin Wilck. Also fixed a b=
ug
> when
> =A0=A0=A0=A0=A0 the previous index was larger than the current vector siz=
e.
>=20
> Benjamin Marzinski (6):
> =A0 multipathd: Use regular pthread_mutex_t for waiter_lock
> =A0 multipathd: track waiters for mutex_lock
> =A0 multipathd: Occasionally allow waiters to interrupt checking paths
> =A0 multipathd: allow uxlsnr clients to interrupt checking paths
> =A0 multipathd: fix uxlsnr timeout
> =A0 multipathd: Don't check if timespec.tv_sec is zero

For the series:

Reviewed-by: Martin Wilck <mwilck@suse.com>


>=20
> =A0libmultipath/lock.h=A0=A0=A0 |=A0 16 +++++
> =A0libmultipath/structs.h |=A0=A0 1 +
> =A0multipathd/main.c=A0=A0=A0=A0=A0 | 147 ++++++++++++++++++++++++++-----=
--------
> --
> =A0multipathd/uxlsnr.c=A0=A0=A0 |=A0 23 +++++--
> =A0multipathd/uxlsnr.h=A0=A0=A0 |=A0=A0 1 +
> =A0multipathd/waiter.c=A0=A0=A0 |=A0 14 ++--
> =A06 files changed, 136 insertions(+), 66 deletions(-)
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

