Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92240C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 09:32:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-VjhdD7xPNEuUMn5xqudyXA-1; Fri, 20 May 2022 05:31:55 -0400
X-MC-Unique: VjhdD7xPNEuUMn5xqudyXA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74BFD1C05AB3;
	Fri, 20 May 2022 09:31:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 613EC492C3B;
	Fri, 20 May 2022 09:31:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1A928194705A;
	Fri, 20 May 2022 09:31:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 724351947058
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 May 2022 09:31:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 400BE7774; Fri, 20 May 2022 09:31:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A4B37AD5
 for <dm-devel@redhat.com>; Fri, 20 May 2022 09:31:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A681101A52C
 for <dm-devel@redhat.com>; Fri, 20 May 2022 09:31:52 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-dcQRlsgrM6CMrvsU7AVNKg-1; Fri, 20 May 2022 05:31:50 -0400
X-MC-Unique: dcQRlsgrM6CMrvsU7AVNKg-1
X-IronPort-AV: E=Sophos;i="5.91,238,1647273600"; d="scan'208";a="305116041"
Received: from mail-dm3nam07lp2047.outbound.protection.outlook.com (HELO
 NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.47])
 by ob1.hgst.iphmx.com with ESMTP; 20 May 2022 17:30:44 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB4394.namprd04.prod.outlook.com (2603:10b6:5:9d::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 09:30:43 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81de:9644:6159:cb38]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81de:9644:6159:cb38%4]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 09:30:43 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier.gonz@samsung.com>, Hannes
 Reinecke <hare@suse.de>
Thread-Topic: [dm-devel] [PATCH v4 00/13] support non power of 2 zoned devices
Thread-Index: AQHYaUWgb63nSgvmhECLq0/sZ1bDBw==
Date: Fri, 20 May 2022 09:30:43 +0000
Message-ID: <PH0PR04MB741634259FDCF264BF1CA7259BD39@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <CGME20220516165418eucas1p2be592d9cd4b35f6b71d39ccbe87f3fef@eucas1p2.samsung.com>
 <20220516165416.171196-1-p.raghav@samsung.com>
 <20220517081048.GA13947@lst.de> <YoPAnj9ufkt5nh1G@mit.edu>
 <7f9cb19b-621b-75ea-7273-2d2769237851@opensource.wdc.com>
 <20220519031237.sw45lvzrydrm7fpb@garbanzo>
 <69f06f90-d31b-620b-9009-188d1d641562@opensource.wdc.com>
 <PH0PR04MB74166C87F694B150A5AE0F009BD09@PH0PR04MB7416.namprd04.prod.outlook.com>
 <4a8f0e1b-0acb-1ed4-8d7a-c9ba93fcfd02@opensource.wdc.com>
 <16f3f9ee-7db7-2173-840c-534f67bcaf04@suse.de>
 <20220520062720.wxdcp5lkscesppch@mpHalley-2.localdomain>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b134f74e-d0b9-44cd-2321-08da3a436995
x-ms-traffictypediagnostic: DM6PR04MB4394:EE_
x-microsoft-antispam-prvs: <DM6PR04MB43942CBCF719ACC0460EB4759BD39@DM6PR04MB4394.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: JlNiF161A5n7G/mVoZ11PH150UdEAFRSdKYMMRKQ8LbG8x1PayXjix/HC03FkA+Xojm0/uEiaG8niTo4odvWwmbijBmt4yNtYLYv+qCpwTZ1MYo6sIeVcFis6yNv51XJ+2SIqMAs/d0xzYi7N5UZGOA0DhvJSfLbeWQfriwtNgOFTG+4Cg9tx3Fi5xrqpDFYcwQl6VmfO81nmRMMS8nBWAj2QHz1iNWZVT3LCh599N4Dpzdo9YhgeDFlJmoe45/VyF9NsQnvVBfgh0Kbk/l2F0V4xkJOk59W2jJl8TecDFypTzmtpWiO8OIOIPFQ8m6HU57QJ5r8mCD4gS/QQsfvOTMdSNTIfBWw+wIEtxwbLMe6adFnii0CouRzNn9W/faW9f9gLrcAfskyrQlXWnSyd5giGwh/X/Vg1iKCnCVSHJBK591fM8h/eq9p9Vwrxgj011Vg8BzrkUglOGhIFzh5K3p8d5rYO81AgY49aWrdrh2EMSa2j8eJQgAHvx2udRWx+gHiudoaToqkB5LGwVe7QN1FvYHLXib0qcDTXUfz3y6IPjAWYs9ncVSA1PPLCQGeVjq7rENjSbn/aZKRTrZxYDlAD+aNvha/88zL9O0EepPS7DuNGtU5CflcAKCmzVsWNH59JzJiIJT0GmNdqgRR7Lnz4JoKvfQAvve3mZWoKiMKdSSg/rcxZ5BJUBiN1xGmtjllVeZQTAsAVD4zoRxppBfH73KxFotUx2q6BUhSBprA8NhOpHp4zLyb4yhNqZHGGG9NKIalkEAojxQlF67VGUrAtcGOmrZ3zVsKiRG8oiI=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(66446008)(54906003)(508600001)(76116006)(4326008)(110136005)(91956017)(66946007)(64756008)(66476007)(66556008)(316002)(8676002)(38100700002)(86362001)(7696005)(82960400001)(83380400001)(52536014)(55016003)(8936002)(71200400001)(5660300002)(38070700005)(186003)(33656002)(2906002)(7416002)(966005)(6506007)(53546011)(122000001)(26005)(9686003);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?3j6a5/YpVmW1KmRYiUq7W9ORkthmPG32xtS1A5Ea4Hqjv8pAJo7tFFw7wf?=
 =?iso-8859-1?Q?QZgVwJOb9l5GcnwF/lnOKg1O/CZaB9rio0bbFYzgOdErcIih1+xRLkQ3jp?=
 =?iso-8859-1?Q?KgxZGsdOtAF2XAi6QW3ETWpX6Mbv6lnUrze0TiJGNiKfFpemsJltloq9wk?=
 =?iso-8859-1?Q?tRlQrXNb0D+vUKrw1bOMrUSF9w5RNqP7rm0ZXwoUNZHQkOhDjvBWtcqH7x?=
 =?iso-8859-1?Q?wYzRqjDI0qCXitSGUak34C+K10I72TE8EA6NmIlO6AcPBxKV87nynJCD44?=
 =?iso-8859-1?Q?nbHynPLn1mxuy+R13C0ts4aipoio9q5FEdDLbDhUxdmlHgwKaZSmFMNjn5?=
 =?iso-8859-1?Q?0eejnXjFYvaG2WGxJTm/w0O3drZSPVtrdIH25IrLsut9/jlz/10r0mYA3x?=
 =?iso-8859-1?Q?hxKAPpBU06KVAzqjk/+EA/m110hWfXKjfD45o3v7+j/2J2eQPDLQkehzKz?=
 =?iso-8859-1?Q?C5iE3krj2Xp6NKs0Tlm8lmYv4wE8a48YxAtmDCXn30Ahb/jVYCTDjHs4C/?=
 =?iso-8859-1?Q?/2OJqXp2CvPV2Bbq65QHGrdE+3Kzmuh+aNjMMIfllKy+q/BO+vSpJjnOBc?=
 =?iso-8859-1?Q?HlrYDf07vqIhS6O/UeyccgOmWKDLbjIOIKM3xwnxnhp0kjn6PYHgSUYvV3?=
 =?iso-8859-1?Q?KI8+b8AgTsAOs3x0WROtNn/MuolmX3uY6cT4loRsrdPWPnPomxssUQJwIa?=
 =?iso-8859-1?Q?LefizIaja8hgJog+6QhkHlXxwoReyI51MhHt0O8QRGJPqbUWsZC/HY0oD6?=
 =?iso-8859-1?Q?E/4d1oAdDdG5NwjzMhOuCvcgX3AuVNl2+WYpcAfN6J68lCAao48oXCKQsG?=
 =?iso-8859-1?Q?2JQ8GGsz6RpVrocpd1ad3n7+CudoTljnrvLrs2V4j/X60YJUSxgTLOeGGG?=
 =?iso-8859-1?Q?RCJSLGa+NMc+F2cd8+XRj1sWBbstqsRbh+vfIca8NJOc6uFsEbl2VfIfj8?=
 =?iso-8859-1?Q?OH635qzerE8oqf5Q1WB2kAA8u0pxFoHwLid8YpTsGGQivmXygXE4atByZY?=
 =?iso-8859-1?Q?SbsOiQGDll+s6VI6dYMxt867idgjDfIAMjGfvT/u/JLcgKhaKYU7W+Cy+e?=
 =?iso-8859-1?Q?KZhvPSNJcNvaatMrEcODT2yTfAcI0nvr4rC8Jo75FlGezzoO8+c/ItXvE3?=
 =?iso-8859-1?Q?Ris5b6O59HAbvH5lNiaODoYW36S3ZLiZnI1vdgR6OApkzi8Gcue3ZUHoKO?=
 =?iso-8859-1?Q?HGC2F0YinWLPTbPhq2cfKnlanQFqG3Q6fgkWrZsMY8pMV7sSNwhneSKocP?=
 =?iso-8859-1?Q?vTQXFrOBqPn5s+WOj1ugJXZoqNbYpCPq7QlYTShYeImLQN/9w/NtD7pCHa?=
 =?iso-8859-1?Q?XmCiqPYMlRhbYRlsJvl4zqdZEBSeypr7LsSg4NkiWrQTwdgR3kaDWarbJi?=
 =?iso-8859-1?Q?h0SS1DDXH33tbYWDuqfebYWSn7s2lZktoreHuAsGKlWdNRrJ6wpvWhaHy5?=
 =?iso-8859-1?Q?N9FiIkdps5BcTvboUCc/M3+RJtSaIuHYHcvUFaVJ/8y67Y+P1jkC3ZcUeD?=
 =?iso-8859-1?Q?GsSf3culN1mt2O/CuianDWVmw5nIpad5j4FxJNzzZTxKoKqLiEWwOh0U69?=
 =?iso-8859-1?Q?qGlUjHn3RngvLNw4rII4i5CQpM5P//1D5qJixTGAx41ld2UsgLdzi4fvnf?=
 =?iso-8859-1?Q?2DLDMPZTwuyra2zKll1RNgB4LZjcFXDcgP3EfLDA6C9Qsbv0yOsvJ3mUS9?=
 =?iso-8859-1?Q?xcnOewh6szA322/34s8mRJgOM5/PkLTG/6GM31ivbtzDQng9clV8CW1dL7?=
 =?iso-8859-1?Q?I2aN93M5y3EWqYOuJqM3PsKIVYeqCOdL32TaY76fwHTEEgN6ncd4+LExjV?=
 =?iso-8859-1?Q?r5ehhPCpAqIuT2Js4WwP3sOgqGh8r17LpXY2Uy7rG5rNN9vU5nQu?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b134f74e-d0b9-44cd-2321-08da3a436995
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 09:30:43.4791 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4w7CiJTQgmXEXiKA06jwVjZWn+lYT7y7WqRKGUswL/f26dPAdtCVcfdhjD4wRzijiTO/ovpXBDW7hJ9D9y0sT4zyCJx5yRMjcjsULPsGkxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4394
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v4 00/13] support non power of 2 zoned devices
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 Theodore Ts'o <tytso@mit.edu>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dsterba@suse.com" <dsterba@suse.com>, Luis Chamberlain <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On 20/05/2022 08:27, Javier Gonz=E1lez wrote:
> So you are suggesting adding support for !PO2 in the block layer and
> then a dm to present the device as a PO2 to the FS? This at least
> addresses the hole issue for raw zoned block devices, so it can be a
> first step.
>=20
> This said, it seems to me that the changes to the FS are not being a
> real issue. In fact, we are exposing some bugs while we generalize the
> zone size support.
>=20
> Could you point out what the challenges in btrfs are in the current
> patches, that it makes sense to add an extra dm layer?

I personally don't like the padding we need to do for the super block.

As I've pointed out to Pankaj already, I don't think it is 100% powerfail
safe as of now. It could probably be made, but that would also involve
changing non-zoned btrfs code which we try to avoid as much as we can.

As Damien already said, we still have issues with the general zoned=20
support in btrfs, just have a look at the list of open issues [1] we
have.=20

[1] https://github.com/naota/linux/issues/


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

