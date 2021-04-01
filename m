Return-Path: <SRS0=Hv8r=I6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA162C433ED
	for <dm-devel@archiver.kernel.org>; Thu,  1 Apr 2021 10:20:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7A5D0610A5
	for <dm-devel@archiver.kernel.org>; Thu,  1 Apr 2021 10:20:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A5D0610A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555--hbsymbSNNmcuz_EnLqLyg-1; Thu, 01 Apr 2021 06:20:23 -0400
X-MC-Unique: -hbsymbSNNmcuz_EnLqLyg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B5A81084D6B;
	Thu,  1 Apr 2021 10:20:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DD886A8FD;
	Thu,  1 Apr 2021 10:20:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A08DC4A7CA;
	Thu,  1 Apr 2021 10:20:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 131AGh0q001331 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 1 Apr 2021 06:16:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 808562026D6B; Thu,  1 Apr 2021 10:16:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 794882026D6A
	for <dm-devel@redhat.com>; Thu,  1 Apr 2021 10:16:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 663D7805C1D
	for <dm-devel@redhat.com>; Thu,  1 Apr 2021 10:16:37 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-535-SgJ26fkaNOGpM_EihNxAPg-1;
	Thu, 01 Apr 2021 06:16:35 -0400
X-MC-Unique: SgJ26fkaNOGpM_EihNxAPg-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2051.outbound.protection.outlook.com [104.47.1.51])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-1-pkp6O590McCoEQE38K3YZw-1; Thu, 01 Apr 2021 12:16:32 +0200
X-MC-Unique: pkp6O590McCoEQE38K3YZw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4745.eurprd04.prod.outlook.com (2603:10a6:10:23::28) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33;
	Thu, 1 Apr 2021 10:16:30 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.3999.029;
	Thu, 1 Apr 2021 10:16:30 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "erwin@erwinvanlonden.net" <erwin@erwinvanlonden.net>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>,
	"bblock@linux.ibm.com" <bblock@linux.ibm.com>,
	"hare@suse.de" <hare@suse.de>
Thread-Topic: [dm-devel] dm-multipath - IO queue dispatch based on FPIN
	Congestion/Latency notifications.
Thread-Index: AQHXH8ZRsvMl6pS9x02jEI+NQfbmHaqU4l6AgAFApYCAB5ulQoAAKk8AgAAORwCAAQw7AIAAfSOA
Date: Thu, 1 Apr 2021 10:16:30 +0000
Message-ID: <93f19c1bb5731394225f71936e1cc44509020152.camel@suse.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
	<2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
	<8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
	<4fff162d56dd8eebaa7d13be9d6ff580cacbe15f.camel@suse.com>
	<30cb8c2e97ea8303ee1dfef8a4c34599@mail.gmail.com>
	<7b5ce0567f03bc3d394481642a97a3d499fe3976.camel@erwinvanlonden.net>
In-Reply-To: <7b5ce0567f03bc3d394481642a97a3d499fe3976.camel@erwinvanlonden.net>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 112788f1-c991-46b8-6f33-08d8f4f737e8
x-ms-traffictypediagnostic: DB7PR04MB4745:
x-microsoft-antispam-prvs: <DB7PR04MB47459E8061233C09A6BD8916FC7B9@DB7PR04MB4745.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3/meeZsioHkNhhslyWPOO82d+e9JU/POKeLd8sdEvMjKQwfuLldaLpVqOAVVMUkkdU1+M1h1k/gglIG+MyxhKnNwnqH/T0a+r/pE6unO87yJecHUzrmKafkplB8YKvmy3jyHaJlJwd4Jx7s9PbCtmKTDcldtZKQV8L5Iwn8OMERw/Q1ePmFEvXPlVIVsne9DACZPlSILVxqQ1N4DIdEXS5cdlhAeW6gC7Uq7WziLDRA94+EMKqaMejED/wUgTmiRDbDsweWTu5eNZ+cEP3mIgyQB+1Sn8u4B/jMgzbMtKqhHFt6sRiV3McmA1IiSrwLmYExvb6/TbJbyUcsoE8X9cWzFNfGod//Q7iTfP7dPueVgh4RaO6EZLoWaoZPSzU2Oj7gwVkw/0a6hNoMOIhF7A1MP4lSI73QPnlt61ruR+ZrNSsHvQ7i4vJBdSfSnb4C07JoXmlNjMUfnUXD5XQIWiRjbQjgpCYLxCNw6rxwN05/eiAjoG4FlBuqy6VXbM9/7ARrM0nRTT0iBzJOCQJV719J0VVEGrjKe2fwleI8ZqHLSOelav4K8VjOojIho5am5NsHnOU392hgaQ4vz+BK7sgeKw36pJtVhPtq9WXa1eafcxhHfnIM3fHt9BCZc7XMwI4uW9J2PX8ztcPMKMAWgEEyeimlmk3lSLOJlH91C9YB0cXsKxlzj4EE7FFfrQKZ0vYTD7FErszZrhTj6xSoFILBz13fDcqmDLVm9oB76uhcHgzABRAeQDToEgNnuOSON
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(396003)(39860400002)(136003)(346002)(366004)(8676002)(6486002)(66446008)(66556008)(64756008)(83380400001)(66476007)(86362001)(76116006)(36756003)(66574015)(110136005)(15650500001)(4326008)(8936002)(316002)(66946007)(186003)(6506007)(44832011)(26005)(478600001)(71200400001)(54906003)(2616005)(38100700001)(966005)(5660300002)(2906002)(6512007)(91956017);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?FBI5RvOXUdWFco59hEcSMVxekHUJt72M4Gf0oAmN25ky1XZlzPlvql16C?=
	=?iso-8859-15?Q?ZCaqJWm5Z9XNQjbPuMsCKFoGcY9vwDzI2YBpOmxbwhZleX9WJvtcckkAI?=
	=?iso-8859-15?Q?ul+fTjCfDbHnsf0D6/DSFaDb2dBWqE9S6tdhUWf55Zv6ewJORTWFjTWK0?=
	=?iso-8859-15?Q?XoHkc55TNLVkFGy5vIFKXFQlV4QYEYIntxW6qILAOMzGUT/uWWp3syW1s?=
	=?iso-8859-15?Q?kca5Y3kfLCj92orbJe7zJJL8Pd1oNdWxJLfJs+bojsia3np7kxnWjWSvY?=
	=?iso-8859-15?Q?mRD2xtJU7UL4Dk4cwEu5YJ3dEjUwBnIf0l6JoQllmi9a6IeN2PSNuTNd8?=
	=?iso-8859-15?Q?yp4ndhvICouREW4q0VNDgnP6zv5jy6fhsuWFwb2ZNDJsXHbyqz2m8P5Ox?=
	=?iso-8859-15?Q?v8fMf6ENthqne7XuKs6nC+sAZswaWFhsJKqj9SXjzUZKzIysjreXrbD3c?=
	=?iso-8859-15?Q?/bZWZP+dyCgf4agEJCdLr/FW1GJxX5Oik+yBytrEyOHkETy1HilS8gn2s?=
	=?iso-8859-15?Q?DVLJa8WSwnRKdf3omvRKYTzeRoCut7Sji4KjEm2W+yes+Pq0Hxn9AngD1?=
	=?iso-8859-15?Q?sVdORUbAcXgVyKtoScYHJa32edESI3yKJXAeJHXW64pgIZnrlRdJly/h1?=
	=?iso-8859-15?Q?doFFjfRmm2zBErz13ktzinZjVF0L7NIBA2dh3YgH0uHYwKoy9gwMjcBEY?=
	=?iso-8859-15?Q?1j0mgNFPba6KLEHQut3bUrd4A+4woPBlSag2moxB/BKMonyxxV8Tab7q6?=
	=?iso-8859-15?Q?+J9FB5t9ERyrO3gmW9eGvZ6IXSH8RFUEWqYNtTlbnLMUrF30GEVZl/kpT?=
	=?iso-8859-15?Q?K2N8xdHvK60N98Dv5IsjRhLb2j4AEOYy6PuTp2Co3mCtu17m0FYGZ7gvf?=
	=?iso-8859-15?Q?RoIFftnpGXnfmihOaT81+IrrtASzKwgmAYOAc24YM79rH/qx7eQLMHzhY?=
	=?iso-8859-15?Q?MUBczR1anPRg+fPTCq27AIhMXKI6JrRdB3qdA8BSleAyoOgHMvbVomg+6?=
	=?iso-8859-15?Q?axRlSA27hA14I6NJ/ZF4nZF0GsM+A3F9bA1GqQQu4pzFpOvbQiFFfUPnT?=
	=?iso-8859-15?Q?XKXGXum6WW/fU/YPVCjlo9BKKGYqZWLt6FI2J9ZbARPMfjNXDD4BtmYHg?=
	=?iso-8859-15?Q?AcR12HOHkURP4ljp5IrpzM332oAqq87QruxZoot5CQ85O0Yqj+Mh0kK/e?=
	=?iso-8859-15?Q?3vGeAcj7zPjkHjQckKXx5OAJQcM4CKUDRVuFtoozBWC+GeFHtiGH+uno3?=
	=?iso-8859-15?Q?pF1c2ijha/3P9cjAX1gDPW5smPBEtMH221fPkgyxOzt7OguVD7WmeN3Gt?=
	=?iso-8859-15?Q?+fT5JBeN9zum97AoM3f2qRe4E1KCKN3CTRAdfshMxG5Z1kwC4sEcodUUD?=
	=?iso-8859-15?Q?RkqRGTKnU59IRDZgk8HVz7zhgifNbvETN?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 112788f1-c991-46b8-6f33-08d8f4f737e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2021 10:16:30.4154 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sJr1exUwIAX6Kpa7M0ivgNizjGo4/sbUNn7lf7TJhsS8MACifAM4rJspj4RzKdir1gWdpYNHeVlCdhXz109dCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4745
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 131AGh0q001331
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 01 Apr 2021 06:19:54 -0400
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] dm-multipath - IO queue dispatch based on FPIN
 Congestion/Latency notifications.
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <DF39DCA72160064BB4AE1F122D9C0C91@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-04-01 at 12:48 +1000, Erwin van Londen wrote:
> >=20
> > Benjamin has added a marginal_path group(multipath marginal
> > pathgroups) in
> > the dm-multipath.
> > https://patchwork.kernel.org/project/dm-devel/cover/1564763622-31752-1-=
git
> > -send-email-bmarzins@redhat.com/
> >=20
> > One of the intention of the Benjamin's patch (support for maginal
> > path) is
> > to support for the FPIN events we receive from fabric.
> > On receiving the fpin-li our intention was to=A0 place all the paths
> > that
> > are affected into the marginal path group.
> I think this should all be done in kernel space as we're talking sub-
> millisecond timings here when it comes to fpins and the reaction time
> expected. I may be wrong but I'll leave that up to you.

Sub-ms latency is impossible with this setup  (kernel -> broadcom FC
daemon -> multipathd -> kernel). It's only suitable for "fatal" FPINs
that would suggest taking a path offline on the time scale of minutes.
I suppose that would work well for LN FPINs, but not for the other
types.

> >=20
> > On receiving the congestion notifications our intention is to
> > slowdown the
> > work load gradually from the host until it stops receiving the
> > congestion
> > notifications.
> > We need to validate the same how we can achieve the same of
> > decreasing the
> > workloads with the help of dm-multipath.
> Would it be possible to piggyback on the service time path selector
> in this when it pertains latency? =A0

Not on service-time itself, but someone could write a new path selector
algorithm. IMO we'd still have the problem that this would be seen as a
layering violation. In the long run dm-mpath may need to add transport-
specific callbacks. But for a proof-of-concept, a selector algorithm
with layering violations would be ok, I believe.

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

