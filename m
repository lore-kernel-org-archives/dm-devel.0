Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF72ECAAA1
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 10:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662977278;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=YeLlVR1pPKNN6iVXMac1HVnjRUOgvq4qs8OrTvSvnuzECKBhWV0Zf42Nk/SoGT3ZG1l37o
	85FCnV87d5Y3YhQRBWrd4rNOkX0RW2GzL1pNJG+hH7T7YuiwjmCNlIhuqN2ypwZnpewr0b
	h/RYSgxSoJLd8CSl0Jzc5E5qBV/ZNa4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-1ZyLy-iyMGitGPPfOaV1_A-1; Mon, 12 Sep 2022 06:07:55 -0400
X-MC-Unique: 1ZyLy-iyMGitGPPfOaV1_A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 247D61C20AE0;
	Mon, 12 Sep 2022 10:07:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 11487492B04;
	Mon, 12 Sep 2022 10:07:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EA9FC1946A43;
	Mon, 12 Sep 2022 10:07:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0E0121946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 10:07:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 014F64C3701; Mon, 12 Sep 2022 10:07:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F0ADD4C3700
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:07:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D94F1801755
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:07:51 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-Iwt-ABNcMlyo3y9tqsUcQw-1; Mon, 12 Sep 2022 06:07:50 -0400
X-MC-Unique: Iwt-ABNcMlyo3y9tqsUcQw-1
X-IronPort-AV: E=Sophos;i="5.93,310,1654531200"; d="scan'208";a="315397346"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
 by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2022 18:07:47 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB4740.namprd04.prod.outlook.com (2603:10b6:208:43::31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 10:07:41 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c%8]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 10:07:41 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 08/13] dm-zoned: ensure only power of 2 zone sizes
 are allowed
Thread-Index: AQHYxoDSwsClPmmx202P29lqx30ycg==
Date: Mon, 12 Sep 2022 10:07:41 +0000
Message-ID: <PH0PR04MB7416352EFCA15255CE9AF40F9B449@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082214eucas1p1a5796db60e6972eace43c3ab6976248c@eucas1p1.samsung.com>
 <20220912082204.51189-9-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BL0PR04MB4740:EE_
x-ms-office365-filtering-correlation-id: 6203619c-b409-44a7-78a4-08da94a6a10b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: WJ6irJCaqucBwMmC3RwYrmfmPb9HPsQYZMIF03WaAq28XrBBuWLRL+/MD5T0QZYfbDHTjnajWBHSNvDluwCAu2DmzCE5LhDRyWrIFwQnsEW0ddYQRc+ea7DxIXLoSkTHh4OAH/BrTehnLdb+8E4vCqL+mHYqGVYHI1GDehy2Iq/eSsRKgi405z3gI1l/M1AY9xXxvwCNAlYcxl8Evzeh9cqhfcC0Li0Fxg38EtrT6tuddvulYpy9qGNNmCMb/LKcoxuA+gjSM2acznH9Q/8w79PnPb4oFRcMnDNy1Rkpf1iYs9szvjIlZbypU0lC+/VXOVXFLwOXMrBaqKx2CQ2V1qh8bOJzQxFhHQi5VpArIKaE8RiKWNZv7hjJQRG9mAhl6f3/MrzfJpXcF13BWeDsyKWDVMwZChOde+Gt8qsfAGgK8PR544RVNUdBti97ptDPbtOa/bMCWbz4ViZEItWQ9ojBzjt4fGfjuYM4hvcZ8zdQGZDQyx3tfeAtsNZDoTpscY5Vy2xWoz7QFwm6KXSZvfxBgt/8Px7bjCk6NwXC8YCe4n8fFac98r6H9AD8U6Bks+fXmjgn+58JQ6FVXgwI2zh9llV4Ifn+xImR8UCUhB8UMfyzTA3mPECL3k0Z2pYNGNHWGs6Dueu8q3Uy4L0Gh1xidkUHyZlRpZSa7Pgz9ZBTtUo23oy53PIPWyUnZkFQzvUMxV1v2ihysZnIoNzLjtIVgbQBPBj2lkAovW2fmpjrLB76Pnz7J1q1kFieFJz1fU9COVLJmqke7dR+Bn0tSw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(33656002)(5660300002)(186003)(4270600006)(52536014)(2906002)(8936002)(19618925003)(7696005)(6506007)(9686003)(7416002)(41300700001)(54906003)(38070700005)(55016003)(64756008)(122000001)(76116006)(478600001)(91956017)(66446008)(66556008)(4326008)(110136005)(66476007)(66946007)(8676002)(558084003)(86362001)(316002)(82960400001)(71200400001)(38100700002);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?XdynJ8jQ3nvxvuFumaNidfj1tCbQ+hYkksjmcct1fOTtUUKmy9uixMGy/w?=
 =?iso-8859-1?Q?1sfM/AlD3kd4GIRfh4HmHqTHlyr3A4K6W5lyVd65tFYgjaUqlukjO4oTgh?=
 =?iso-8859-1?Q?kt4C6OEIRHabbVcsmceqeClAi4fB3lX7+K8eX0udgUJ3ZGK/R1y1PdMGkO?=
 =?iso-8859-1?Q?IKNrCdDXkwTzZhMKeDeB9rWFka0mwf2uKGfV9w9IWZHao0lRo0POL7o3du?=
 =?iso-8859-1?Q?vUhCvXnOXogZTcXdTC529c958z43vFYmZsR4AZlNPdnLWhNt45RaTFNVzS?=
 =?iso-8859-1?Q?f2owJlqdo8qStSU4GBRh3cVAxw30QUPUOih8D17oryFH9cgMWNSiSi/Dqa?=
 =?iso-8859-1?Q?gqDODJ3WoEfl0aUoUFH6r75CfKiitRVpkG7ixX2pSb6i7wvPEqrSuU7Bxa?=
 =?iso-8859-1?Q?ZHJ0ThGfE4k7LSo65tHzzr3+yyV1t7Weqi3PvT48yX82FpbJyabREuQZvm?=
 =?iso-8859-1?Q?FbjSgnTHcVZYYiEFW5OPbEqwm7TE7SEsRnJU1eEXxcckLKsJXbenzBkv1a?=
 =?iso-8859-1?Q?deWhmyXdFoCOaMIdZ8fzYCKm7KrmDWZ4TQXIKfngGGfoBz45+7rA/F/5lU?=
 =?iso-8859-1?Q?KtREOhoof3xDiYvT+TQVD/NX4JCL0jJBBfAaD3xYihiZmvMNucvI8ZzPUr?=
 =?iso-8859-1?Q?B2tpjMf5sqm0x6NjMfInUnIYvRRO82ysG0ATYxq5mKmuimxPMv3yBJIFua?=
 =?iso-8859-1?Q?3zS/+pWpSds1sKq8PD/ZNO8BmfyR/R++3AHYpFtdnAPomRDwRqkILwcsAK?=
 =?iso-8859-1?Q?ms5yT7T8Zr3huD7BzcS2g+NXCnuYxTzo7lbBeph6l170wKOloOmP0vlZJ1?=
 =?iso-8859-1?Q?hr9hV7PKPO1us7XUjpgwRwy5ErJ53SqjcWZB6ZbVmSLC0kMfXWdCc+r6Pk?=
 =?iso-8859-1?Q?GhWckDtJ7vMszdSI+XpyhkTbc7fxuBxTkhdJK1J86hqX65msA+jGgJlcf7?=
 =?iso-8859-1?Q?NDUjNPU5rFCdSspqxB/A/b1PH24UfeZCgbZh891KxhpmXAh44inM4xLNpI?=
 =?iso-8859-1?Q?SUnpjjhxF5A2w5BhB48YO4jR4i2nB8ngjX5r9FkaJEKrQhOpXTpXKTt6rp?=
 =?iso-8859-1?Q?kZOxquwyAKs2eaNZax3VowfoVj2d6ah6wizaiD8VR/i6nXTg7G4VtM5M2b?=
 =?iso-8859-1?Q?/yLefC5H4MYo5sK6MMtP5pNLAakYvqluXoFEI65Foy3in4bS0tahDeopzL?=
 =?iso-8859-1?Q?sLpYak3FqGToQauz+Tn+pD6r5rBeNJLs3olFnw0B33p70B1Es1RQoGG1Wg?=
 =?iso-8859-1?Q?NUdZut5MV9oKbXAZS2DVVz/+mUIbOem8BTYiD+2GMHE0hfHOQXs41x8/b1?=
 =?iso-8859-1?Q?7N/tzcyMxw7Ka5DSSau+SR41Hj3rwuJtJjO2aRUZ6GqoYVQxqcjZCzlqXx?=
 =?iso-8859-1?Q?YfPUGgchdHV/B7UdlxIUCOWLkCqLgAubLPx5ZA9vNGVAOOLqr9/OIvgfzP?=
 =?iso-8859-1?Q?ydWI/reFZZQFoTZWzqsPUlmt4L3wcPYijAcGeRStb7W7zK5yTYMMDkymG7?=
 =?iso-8859-1?Q?ZIkFNKU1dFa6xaEq8WwY1E+/mRuA6MvHF8lqL8tstPiJ2sMUjYL1828dic?=
 =?iso-8859-1?Q?aMtoIuQc8rjYan2LadkY4jFSmU9MDdowJ907aLJ1eH9pCUrAiqr0fSCpga?=
 =?iso-8859-1?Q?AjyBy9t/xy95au3qKeSL46qB46QlOj4LQjs8s+d5rhmBQb3hOkL3K1qIEC?=
 =?iso-8859-1?Q?0LR1RZ0Lid51nPsibccFDFS7zaW3CHdT8l3KDQcVAu3yzZk3Pluz6CkOwB?=
 =?iso-8859-1?Q?kXY97GRmP2u+eIv2lR/R/pRQk=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6203619c-b409-44a7-78a4-08da94a6a10b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 10:07:41.3243 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jV0RltIiI0nx3AHazM+0wNaZrM1aYlhqlAuhQbDKLPnL0wvVi0ZPNWyntBCZOrnrsH+y6wV5c/XRWSSrGu28NYvhmnqqwCpz6iXfaO61tKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4740
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v13 08/13] dm-zoned: ensure only power of 2
 zone sizes are allowed
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
Cc: "bvanassche@acm.org" <bvanassche@acm.org>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
 =?iso-8859-1?Q?Matias_Bj=F8rling?= <Matias.Bjorling@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

