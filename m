Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 044C2C43334
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656941248;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=Ux+K6umPDU112hUR9Zb5az2BD6Vh7ruqLfx9o2Cx9xo5I/DJnPjh8fvNeXa0eVeov7+Zo5
	/3XQqQdtCK0XqnQNF3pFY7ROPhuyEBB8nw3CREM9o2h11mlfkIdCGI5I7L035Hoztu6uCP
	/YvxrjbbFCbvMWtXFjKp2/vcHn+B5PA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-1m2BNn73MCWTVtAENTNBng-1; Mon, 04 Jul 2022 09:27:24 -0400
X-MC-Unique: 1m2BNn73MCWTVtAENTNBng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA03885A582;
	Mon,  4 Jul 2022 13:27:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D8A1A2026D07;
	Mon,  4 Jul 2022 13:27:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 94F441947041;
	Mon,  4 Jul 2022 13:27:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 55F631947041
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:27:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 21D9B416362; Mon,  4 Jul 2022 13:27:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C9EC40334D
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:27:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04F513C11735
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:27:21 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-s6-36KW9MQmO-Q48G7TjTw-1; Mon, 04 Jul 2022 09:27:19 -0400
X-MC-Unique: s6-36KW9MQmO-Q48G7TjTw-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="309091353"
Received: from mail-sn1anam02lp2048.outbound.protection.outlook.com (HELO
 NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.48])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:27:17 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:27:15 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:27:15 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 13/17] block: replace blkdev_nr_zones with bdev_nr_zones
Thread-Index: AQHYj6QGyUcjd7DxPUi0cXSifDek6A==
Date: Mon, 4 Jul 2022 13:27:15 +0000
Message-ID: <PH0PR04MB7416982B2090A26E7BC0F1229BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-14-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab835399-296c-45ed-928c-08da5dc0e96b
x-ms-traffictypediagnostic: SN6PR04MB4640:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ADD/ANs4Muk3djh47ivUyTe7U1XOOLWgJw1vFwQjsD97cvSvqqJnrJtDXDn2eISGafLMXU+DxxwfYWO8gbX+A8YhsG0eXALYIAYi2blqNxVb/2btoO1wfOxe2mmebJx7FI+REbVc3tAjWBlEaurmgDlJAHMWJinhJz4uBIiYQl6zSsRzz3D/6qL9imKZZFji+L7xC8WE6z9YXlN++2yeay7FOYoI8hFzkRuxhOsexWSnDaebfnQQBnuvOq3Gi0MHQHBdCjWQpnV3DkBMwSDDx8zl0jGR15kXXe0oHqTHu8Yspxd6fIGGn+gAuB+XFUwxOCFgqTLK17E50abOsS7yXda0bknDHIHC2gBVBZ9QIyVDE3xTPNRQsrGjAQpVrW0UWgb4vjhjbFXzBpvfbwSsGJ9uD9EmYGLRoVph29sLa4Gnog0LcG5deM/HpM3TPAC+MCtDa0xp7ZW81s8eQBrOH53vyJTcvhU81XwaQdTKFB0Opodimd2xb3lXlG2dJD8JYTyKjsqBaqIGp7p4CsUanU8cs/1H+6QqOVt0pD+WNNi+1B5S9VXuaWcMZo8sHeHdayx6n+jj9x2lsVorVhGQiDwGjRIASm2pyUE/AwU2sNRKh6d0H3+p5s/M69M8dXeb3eEsoOyvqYV8vTp72f5ZG3yCnShOL4Fv/P6Ps16RCj6a6JLDLyIHXLz0WHxv6yC/mTlKA1TTzod9J5ODns6fSxiVWtHr8GXcYZdiToUyVgelhYl3buc6xSkQCPfFhJna97WOcFYb79TvZGWFpLPswnhBfiSM2pnywa4xAbF9eJIo4Locx8ncfNodb+jiG7V1
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(33656002)(38070700005)(4270600006)(122000001)(2906002)(5660300002)(558084003)(186003)(82960400001)(478600001)(55016003)(19618925003)(316002)(8676002)(66556008)(66946007)(41300700001)(66446008)(110136005)(8936002)(64756008)(52536014)(76116006)(54906003)(4326008)(66476007)(71200400001)(9686003)(7696005)(38100700002)(91956017)(6506007)(86362001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HGo6zQ2y9+ODGwjAcQoe8p2xo6gD/UH8Tvybdl0SXGP0myBRcyIyTERgcCCD?=
 =?us-ascii?Q?Sk7JxBJ1WSryMaOql7acBZ0OtrDil/gdBnMZ8vySknyhKAqJ2lbhSZnZ36Cp?=
 =?us-ascii?Q?94Rm237Sz5lKpMJ+u3+MhvKEVZWFHTKw6dr4dhNkZJic8vqg0asXaMoE36Lt?=
 =?us-ascii?Q?sVUBdRUwMOs4aRd/1v4dT9eYWrUBew5xKXniCOWKHwAvmof/uXG3lRmUS5uC?=
 =?us-ascii?Q?+0ZQE5UH+faaNXvvgkfKNE510aEIPiBxxrORJr8lWZ4N85l7Vts66/vt8b4U?=
 =?us-ascii?Q?hxVHO6LpZHyBjiagDBRkZcLKw2JDUHVTsh0vc+81t7yRbIw9M03KplWHnGaI?=
 =?us-ascii?Q?ZIGjZVlAkyi2NSIt24sKtLVWUfogisr1gEn9cYsZOJ/9S3zzfQqfgVA5oaDd?=
 =?us-ascii?Q?AulVlOexoe7RiYFrydO5riNLx8Nygyk1mIiG2njAJFhbDmS2jtFxywpCGLWB?=
 =?us-ascii?Q?vzolpNKIiCMvN394AQOpIvH0hd7KcQQerTbIjjre4EtOLkSc7U3Fq99Ewgh4?=
 =?us-ascii?Q?skKg/iDrPIWBy+FNpqxWVHOAd3Af9yUiRGLLnyOjXCiOk8xuhMJmscF01iEa?=
 =?us-ascii?Q?y+nOz9tIJ0kl0aGlCLTKLklnjab06dpKkYxqZrbVLUbMcxe0M71LreQ6KC4q?=
 =?us-ascii?Q?kyhi1FRZVJxTZzDCyuOp4Gjht214sUTPMRSgn8BzD1N+pFoOocc/sEawSTWn?=
 =?us-ascii?Q?qbvD06zz9gKsB+WLisAgU6wGVElox1fwRsf3eTn3vmgnotGf+dDaKKU9gmJy?=
 =?us-ascii?Q?9mNXTH9dHlrceVY09DSQPfzziQnb3OudV7wZkLFsiN+/CSP3ZExJLXfhp7zL?=
 =?us-ascii?Q?GqYIDNdjnSFdEXjZE2UL+TOYb8VIivsiWmZBoaF/vukTeAu6mjWB4eH13V+a?=
 =?us-ascii?Q?/rF7Ua7URl9GffjjXcDruvJuwnferX8NJkYHSyppT/Cw8wh4st0qwFOQMAnB?=
 =?us-ascii?Q?VCKvkHT5/uSf+RksdFzG2nuf1xY2OwZx3dL6hGVVpT6ReckYoaQeCz0tvmBA?=
 =?us-ascii?Q?r9omWsrgFAwLiANV4v7P39wEIuORb1LhuiW9jTeAXWK7u8WI0SVpxDQnRgeK?=
 =?us-ascii?Q?Csfy3shoTarwCjkSvAVDtH4HahUfjLEKzqJwJDsivh3ker7qV2juajW2tA9w?=
 =?us-ascii?Q?b2lks/DZ2RvK+lZXCE9iy22MMDlzwvxnroAPwCSOCbEachkHpPDz47bKKZoY?=
 =?us-ascii?Q?N5Vv7pXRd6xIuSlWJwfPRBOnzMmyDTpvhE5Fv7njQXJjAIwMNtVMMjY135c4?=
 =?us-ascii?Q?AmEN3orySkq3H2Ui1Bo6o1WGeOeNORdvrY/a+aaZgCbJhRe54+fFVFUatvQp?=
 =?us-ascii?Q?Mp3f77cfK/rR2HFbRmsOGNF+KQ8RMSeDRAb62YhtAW4k0BZM5PwjkUXYC9sb?=
 =?us-ascii?Q?0kSO5S1dlPszL8nghtc6SzbHc7cZQkfJTTs0Myw7wvwmCEl2vbMbV+hjYvVH?=
 =?us-ascii?Q?iz4Y55ylbyvjOdVxoB2SR8KW7WNjFQEuOa5i1Lo6ZrymJEiOD6OXxCwerCaa?=
 =?us-ascii?Q?ajsIMQb0z05Be870IihIpcygvzBU11HXnYaQAxWhQVyoQA6KX28wuZOiUaE1?=
 =?us-ascii?Q?b1C1Jxn3s4yRqs2QRGsZ3kEBMk+GUE0gFWx6evXe3xIZh5hfyKoQ+SfK8Ui2?=
 =?us-ascii?Q?MXtV3o7V29ZKQC+tnEQp8PXmjYi9cylkMZvAgzQQG6HRgoeoy1xHM3fbxMDf?=
 =?us-ascii?Q?2aMwSp2iWHihojLSoskUtfMnYN8=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab835399-296c-45ed-928c-08da5dc0e96b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:27:15.7435 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G13NULLOWOQDujLOkE9nLLsslYON4Dbi5zvuDwnSI5MSzl4RirEGITdIBUqaJkExvM4UFMNtDgdLZHagrUySmr2NJy9Z0RLFmVWWTA5qY6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4640
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 13/17] block: replace blkdev_nr_zones with
 bdev_nr_zones
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

