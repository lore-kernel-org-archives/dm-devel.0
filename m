Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6599CCA479
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656939734;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=FKYR2UlEdzubavrFBXAzib/99mHpvkF10iee64soKAs5KLXj6TK6/zqSljJadMBLUK0O3R
	P5k2LRHavr1bNoM1AJIIaB8sH1GkDmZxLwCxKZxmDoU7VWOnD8djWTUFW7MmOsU5EzRkNq
	+mcU6bQyWr+SvOAsMl5Ykck8g2at7Is=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-5iNp2L8wOHmvXch6gL_JNw-1; Mon, 04 Jul 2022 09:02:13 -0400
X-MC-Unique: 5iNp2L8wOHmvXch6gL_JNw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6AE7803524;
	Mon,  4 Jul 2022 13:02:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A40502166B26;
	Mon,  4 Jul 2022 13:02:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6CF271947041;
	Mon,  4 Jul 2022 13:02:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 52CA5194704A
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:02:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 365AB112131B; Mon,  4 Jul 2022 13:02:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 31C261121315
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:02:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1648E1019C88
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:02:10 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-e2QkS9rtPbCQ0Lt_tv9zfA-1; Mon, 04 Jul 2022 09:02:08 -0400
X-MC-Unique: e2QkS9rtPbCQ0Lt_tv9zfA-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="205480420"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO
 NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:01:04 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN7PR04MB5249.namprd04.prod.outlook.com (2603:10b6:408:3d::22)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:01:02 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:01:02 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 02/17] block: call blk_queue_free_zone_bitmaps from
 disk_release
Thread-Index: AQHYj6PwWc2YB0PqMEi8xHAfr13CWA==
Date: Mon, 4 Jul 2022 13:01:02 +0000
Message-ID: <PH0PR04MB74168EDAA4A303F4513DA3049BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-3-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e763dd36-641f-43da-ec6c-08da5dbd3fbd
x-ms-traffictypediagnostic: BN7PR04MB5249:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: g28chmxErwZut5e3YErPzA6IhcD5TTrd4XT7m3FyUk7i6nB7Mhui2rnNYdKvTe2o/dEKeQ9X7e08Egb6jkAg4wlq9ukqCxnpCv7SUiZYm13lyw8VrZcQ3p2hR/UKU0GBg93xWk8rdvTLyrzQPHPsQd+9bTLFIjWQDjiHSDp99PWmhX4ybJetD/Pcv6YVg/HAfbyG2NUdFOhIStHGdpLwNAB4zPvt6Ghu+AWe1417yYC1Nvj5MapGfFHgbBGLD3Jngg3jdj6ZEj2/fIfLwgKmGPcl+onO0Km8NF7b9cnoDxBuSLTt6UPaeR6c3/y7VAhUAHRKuPnsoCbOT0dNKP2qfug2ueQiBNwvdn0qZELXfPjbaMMCOM166EGjFNt4bcuVESwpIR4hL/LtgszmeoBhxkALFXllzygFMvm8LGyIIGTUq6cqe2pb78YwTaTS9mKNAKVqALRzFK+7ctk5v72BZQAof7iZV4Bql0hlgVfmwOlo4ONBi/VKOuMy9t0AQ2r1x3+77ctQJ1vTPEu6LdKWj9j7jm34AOMB1c/BB8aCB3QPwRvZN8cPMynfsMScCCFL+1pAoTU0sCb63J58d9HHj55k6BV0AIdJyLgObgYDX2kMiiHIgsBrrBY9575neqjxGYapAIeh4RDEAyEa14MTNwSt1NEPYUbE/+orxIE5lc/1RlR9jBraB+tBaT39urq8XVW9NqyMhQufv63QolZhu1Ht2zL36QyQNggRaJDrgCdHvf3DNu69JFEag6uWi508zncCR1hVYeiNIIXrlY8QVHiqkFdcHCDODZL/8WBfQ+HvFFcZ+C3rzQkWzOgBEt0F
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(7696005)(9686003)(478600001)(19618925003)(186003)(6506007)(41300700001)(33656002)(8676002)(4270600006)(91956017)(52536014)(8936002)(66446008)(66946007)(76116006)(86362001)(66556008)(66476007)(2906002)(71200400001)(38100700002)(55016003)(122000001)(558084003)(54906003)(38070700005)(64756008)(5660300002)(316002)(4326008)(110136005)(82960400001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?v6MQ8mmrNOtYRkwulK9ZeMWiYDl/H4Z+174GK+DbjZACLCBjh9crbt97lfub?=
 =?us-ascii?Q?kjVpwCNymiBFSfHfM10DWjGwk4ve0hfR9UghEjb9h+SxJrknsNJmpsYWaYYe?=
 =?us-ascii?Q?g4GY4lJG3XffNfZRE4jCfOsZ9IWbvyuwugNQ3PQ4SKOR3JDuMn3teLxqOFl8?=
 =?us-ascii?Q?5EysQyEFYdk/qPnLNDwpP0Mc1E4ci6Dau0drs6ujOhQt/gOSPocsE44Mn7rq?=
 =?us-ascii?Q?RvoZFg/21UrNP24Hqe/S1ACXHfAeHBRQHxzMORi5fVJL3ypWPsA3CHQH1cPi?=
 =?us-ascii?Q?COsQuyLeIi0yyASNheqh6ZMi3soRWPpODVl3BBUHO0cWaXn2P0an6+Uq+k9S?=
 =?us-ascii?Q?c+1TAAmEYeYAPUyzc9RSzNAZ1++KS3+J9uWeHU8cSvGufuxX8EBrlxIBt+22?=
 =?us-ascii?Q?FrD0Dg5K2Hlh6DS3AflbtZ19TEGnIubz0ePbSbYmnm0j5FT4p7kCvvevVWDu?=
 =?us-ascii?Q?BZrdEjZRcjfmZBhgWA8cXvqnUlbEbDalU1YNhh3SwGsI5Gfgt0aQ7uTypT4O?=
 =?us-ascii?Q?6plQxWTrRNID3vlcP4U33XBx1u+92COhK2xaPi56yLEJlkiPKXh7LUgtBtct?=
 =?us-ascii?Q?lVccNnAbM2myh2r7zb3eW4gMOD51bhwK5gXJVedLn0btmlbRfj53rk6DscoE?=
 =?us-ascii?Q?MSaaS1y2DU+gNNiLH5hCxIXCblj0vGKrIoBn33oLCOYUuGqM7ECS63GJHsYv?=
 =?us-ascii?Q?1lesJrOHChneD45QRmYmP/IOYT16XZBdQoMptQOXXlu1C+nAWKGsxtSYgfgG?=
 =?us-ascii?Q?KWriJeu5yyRYNorwW0YDZ2CkUdxuoJ4FkxlVREjnJ0VTIFQZUz4eSdvMXLER?=
 =?us-ascii?Q?uOpx2mCAAWJKXhq0BIdk18qkrpZNivVg8FFPkf8bHTqJbpeMZB1cNpT06Eol?=
 =?us-ascii?Q?r6WU+jS3fB/BjhzbnlL9mjyXXS8BRlw/S5fRE1xNyOvxl+h+DMT96ien8kvz?=
 =?us-ascii?Q?oZRnEltDLiS158CyFbl3zx+m+HjQsSaOFY+XX14rnRcAvI5uB0FE/ETJKmd2?=
 =?us-ascii?Q?CkS4kP+Uet+NjOmiJF/Dz+iDwfTo9StKCw0KiWbjWD7cYN1vwmZJDNfYsYwV?=
 =?us-ascii?Q?8mYYRDnC1b3TlaZQ36Ci0rDWcIVovDHdXGDDCn6NzM6of66zAS/LrjQIuSnS?=
 =?us-ascii?Q?D9Xrob6lD1Eq3xxmmgU4D3WEz3ow4iSa40VQMlXX2A+iQ00d1zkmpwjH8KKM?=
 =?us-ascii?Q?QNWan9g4+kwTMYBmpwL6VxHU7RpWfYREm2q41MSA1ubenq5zbcZW9W8aRRAk?=
 =?us-ascii?Q?qBRsegDCMUhhjDn0Izp7EKjoRA574j/YRIptagSBoGwotkq0nNuJVsxISPip?=
 =?us-ascii?Q?ESbNxvi+Jr3dzwA27f2qlW0emjeveVJsE103kSqXlO+7hgTcBVtEXiHbVZQv?=
 =?us-ascii?Q?swtfHpGOjcKvKh7Lff5NWWD7TByyjMYTfESQadq9DYamA4U3z1rAVo8xfDIp?=
 =?us-ascii?Q?RN4SrjpLDIexpmL2TMNBdPq+mVJXUd8Dej+/usDqtZQMO7NaN7FZ5J9CCSlq?=
 =?us-ascii?Q?wttM9hNmHGG64g/kkMniAery3vvffugH9M9UZjZFXJmzR6PeUZ7S3WAl3j67?=
 =?us-ascii?Q?7EOSDUwCHsuhId1Yy9rlUDlu9NQZZW3vQM7LaxaUqkRi/eCG2Z3iryzIXUx0?=
 =?us-ascii?Q?W8g4hMS1IugFAOhpfM6nMGP2H5jCBcP/hda4BIV4gabyg+TI02OuOpVn0i1x?=
 =?us-ascii?Q?PGTL/q/u3spjMI5Y10sFBLoL+ZM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e763dd36-641f-43da-ec6c-08da5dbd3fbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:01:02.5477 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9HPy9mDT+F9DYCZjP/SI9DjLkSZoUgzYbFfRwCUPa+xWnK6Aw+qK+vdVhRIPRlgh0AJEcd8cV9/MCyBqE44heDdWckB5jUHFLFujpEvbK10=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB5249
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 02/17] block: call
 blk_queue_free_zone_bitmaps from disk_release
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

