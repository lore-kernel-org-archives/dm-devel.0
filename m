Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 865B4C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 12:17:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-rxTIpVXMP6qTVMnzogJPrw-1; Wed, 27 Apr 2022 08:17:55 -0400
X-MC-Unique: rxTIpVXMP6qTVMnzogJPrw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55EC483396D;
	Wed, 27 Apr 2022 12:17:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3F2E240D2962;
	Wed, 27 Apr 2022 12:17:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F338C1947046;
	Wed, 27 Apr 2022 12:17:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DE11919452D2
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Apr 2022 23:59:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C00E1201AC66; Mon, 25 Apr 2022 23:59:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B96AF2024CC3
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 23:58:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F259A3811A29
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 23:58:52 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-BRLFTRFAMy2MP43nyqzdkA-1; Mon, 25 Apr 2022 19:58:48 -0400
X-MC-Unique: BRLFTRFAMy2MP43nyqzdkA-1
X-IronPort-AV: E=Sophos;i="5.90,289,1643644800"; d="scan'208";a="198797863"
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.173])
 by ob1.hgst.iphmx.com with ESMTP; 26 Apr 2022 07:57:40 +0800
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SN6PR04MB5039.namprd04.prod.outlook.com (2603:10b6:805:93::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.13; Mon, 25 Apr 2022 23:57:39 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2839:2ab4:7871:416e]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2839:2ab4:7871:416e%8]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 23:57:39 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Mike Snitzer <snitzer@redhat.com>
Thread-Topic: [dm-5.19 PATCH 21/21] dm: improve abnormal bio processing
Thread-Index: AQHYVkrMQV9TxXK3CUOnOpbXzKETCKz77KkAgAVnPQA=
Date: Mon, 25 Apr 2022 23:57:39 +0000
Message-ID: <20220425235738.qbzwvkihk2c345qt@shindev>
References: <20220418022733.56168-1-snitzer@kernel.org>
 <20220418022733.56168-22-snitzer@kernel.org>
 <20220421040620.zbocicrqa76n4zqm@shindev> <YmKqATrOXNpoBBQd@redhat.com>
 <YmKtGu1M2uOh29MG@redhat.com>
In-Reply-To: <YmKtGu1M2uOh29MG@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9d89aa1-184c-4178-e7b7-08da27176136
x-ms-traffictypediagnostic: SN6PR04MB5039:EE_
x-microsoft-antispam-prvs: <SN6PR04MB5039165E76339D36047508EAEDF89@SN6PR04MB5039.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: WLTXA1ks1VQ3Tbs2CQxTTmSwnvhCIVP/cMHnbUoF8ZM/r7wqOKIs6iu5PB6/jiepD0Fd68Y5pin1vS4IZxuYWup14P7LbQ2t9iXa4V+cBL0QmKApnWsDeodLTm9lgkyo5/2w49fn7s7mmfpEkDIrBFOS19eOirJ5l0JwR0/wvmv5iUXPqCAGYA8nHSN/vEXFR4qlUvuB1JWP/xA8qzEO/ydJdYn+yX0x/s8M2XiEAdkSxlvn6bYjQC0QM/Yu6OYUGBtNGJEvT3IbjfLFr48VXWp7BeA7Mf5W1WxUhg5oQP1Ut3YJcwGoCifGPKtiwXBfgRCRVl/wA87jsvrldXhaBbTnRKsPDl2ngMQeYgVzQlWHiNjAuK1/5k0j9VQpCHJU5WuZ+qKj+3eYetrlszzxIws8AOCUDPwZO9qn6RYF9wJWizoFfKvZBZKw+EMJVhuYGwYmAAynq1Qd9p8Q2W2PRUDVkZW1/egheXVgiRpmNBhSgHQAb7Yx09gqopsZcnVSP9s1BKCAR4gIYyjh7fuFGH5ABggefyFFvl9qddSwfEoh4B7rsFpr4FwC4lOmgv1b5AmUla4TXzQgJhincZsHKzN1oOiQvsp9dDpK3EImujSJ4x53yODdiswBubxmLAas/xeWTyJ8mLLeqhdPV4b0RW0MCLNWazZgkwnwkqHHD7VFqmmxdB0JEep4kg67KmtWDTMkMU0DXvPCKxNQ5PzVtQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM8PR04MB8037.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(7916004)(366004)(6916009)(5660300002)(1076003)(86362001)(33716001)(8936002)(66946007)(66446008)(76116006)(64756008)(66556008)(66476007)(44832011)(4744005)(8676002)(82960400001)(54906003)(316002)(26005)(186003)(91956017)(4326008)(122000001)(2906002)(38100700002)(6512007)(6506007)(9686003)(508600001)(6486002)(71200400001)(38070700005);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qy8wUaT9YvMTsTH7sqvyXNUd+xVz7k6se1oM9SOaAaMIp9VU1i1XU/zBVjNh?=
 =?us-ascii?Q?Ecp+8bK1KEQXVGULyvKFIXaNiJRxkWBIK3gVZ+t/su43aoG4DTFr48ky54pC?=
 =?us-ascii?Q?K1ZL9K008qkYYLnqqHfBu+BD7DOzWiBXIDAmhFfzOkCrtwzKy+PK5SfAzrJO?=
 =?us-ascii?Q?F9HxkxHZYYiy7SuwVdwFnSVmk5t3plG2eZ/d1dh+dy3Bq2Oaer2XMBpMoHDY?=
 =?us-ascii?Q?6zMkfKhaiuhFa5gdL4GmVgbFNt+iEDsifR0ZZwSa+s2sWXoGcQSOAa0iR9LH?=
 =?us-ascii?Q?jpa2NhxLKG4oNQiw0frVf5B7JlrQU80TKbAj2ndToNQr/5RQ38xhayqc7PyR?=
 =?us-ascii?Q?euNbWDc/jYGpbBg6HGI3yIwiWwx/4jO0mYcf4gXH48zwOUhh0sQ/zk75NSZH?=
 =?us-ascii?Q?QBP0g9HZ1Jpu/fK3ayY1y8yrQ8O9MXMovK+6gXtp2peJV47iKMVk8pe/NQlS?=
 =?us-ascii?Q?5XhXHmCBzpNigrszSoI6lf3Ujso/npjN/3AZA+VZGQWP0Pc4saY9C81O8qgS?=
 =?us-ascii?Q?0hGgeOAR+NNy8Da1xVNyn+90OsRZTV6drFRd14rCxVBsKkMSoKpeTKJFJKIs?=
 =?us-ascii?Q?6mujuWAu6jiu7pRuAe9TJT1msSFnb4hLt2SiVlc3eOCv6aYdm0eDqbr86Rn2?=
 =?us-ascii?Q?SAVKUpFGAIq1jOMoGbsZYseeMzhRtOC5O4lZae+6i8TKe0zPAte/jFwhdSrR?=
 =?us-ascii?Q?x/9PC6c1ozJl1Fjf7c3+KYyLtjMsxa1PWxem4qdwoObyCXMWO1oh8+AnWAaR?=
 =?us-ascii?Q?/u55xgpMFMqxzCjtA9pTKX6797Yi2ZO6DygK4x1pNuDl+yCOW0UWHr9fGDBC?=
 =?us-ascii?Q?XJpaU3s92D6po0stBkTA9Q10ZLcs2EvzLPWXOp2GIg54PfsbiTz/GDJYnAcJ?=
 =?us-ascii?Q?n6wxlrNM7ulQeF6NQHjVR2dbWcY38IHbG+WX5P35c3jc7AmpQe0x2o6mW2Xq?=
 =?us-ascii?Q?sydrlcB9qTs+G6D7AWpQ8d03JmSkhfjnLxl+mLhvbgjaIGdyxxkBeYJM+yuv?=
 =?us-ascii?Q?TusurCzc0ICyqGy1Sx76MZvfvpqyeBbzJ8XZYKeBa0izxIh5bxkVs7qzl7jA?=
 =?us-ascii?Q?e1USvxUppqgg0mSe6HHyqFE/gRKuLf5x5S1p3nXD6pvNvUJVnU4m7l7Pk9Xs?=
 =?us-ascii?Q?c7AOd1q2/GdnAyL94ZtwWJ6ExUn1vQccNJ8U78aParkjqhwdrBZ1U97iusrC?=
 =?us-ascii?Q?0ImImjj06dHEjIaDnCzuAyYgoHvvoVqW8x3P1QK1o0AknWkxdpQckQGt2n0a?=
 =?us-ascii?Q?n3JyacOr4y+FUC/z49BulCe6AXUbbnz+lgfnPZcXmpTrnosGwabXpw0J1zZM?=
 =?us-ascii?Q?DouSLNczOestdKtA2MNtOs6TutfGxH+NhR3bpPH5ZTW2ROXNAYljAHxE2HKo?=
 =?us-ascii?Q?Yq0t4gfF30QhAhLxOoqPXvSScj74JTEpbcMvnRcQNcUaML5XJXmtBFOYilyV?=
 =?us-ascii?Q?yt4NLttd/Lg+V65U9OilYf6fuUn/6OZN9RspYjrY8mQm5lyKvMIYuySDi0S7?=
 =?us-ascii?Q?evWvM9416199/fiKj1Qm6hAnvN+6oNhwXaf+LjYbauN2DCip/Sj6qrmXi+z6?=
 =?us-ascii?Q?5EPtlSqNs34jt96gc0Gm1nHJWYH0tbjkHN0g4EdO+NU5knjZ662s4OfHmUU9?=
 =?us-ascii?Q?4r+y4tUgwVb3T/w/VOJt+eVNqEdrW78WE08MCenfprZ53tnmant5O/DbmWwd?=
 =?us-ascii?Q?tls9zVl9Fk+XXLMbXwTe5JMSNjJf99ZSJdHtfi2EMCkGHHds7azgsjz305tS?=
 =?us-ascii?Q?8vuumQYVtBwu5qyLhCTooZLBZ5zWJ0R3pYKBg1BXNSA54+/lZfwt?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d89aa1-184c-4178-e7b7-08da27176136
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2022 23:57:39.4440 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dPiqTQmZ3CGF6r/BUr263Td0PlvdM2HPTHPZjlx1rdVORx4X0BIgLoq1lFKZmPhuCfsbyO6Lxinat4HAJIUKlOyTpCPyQlHBJ3+bMUK9JO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5039
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Wed, 27 Apr 2022 12:14:17 +0000
Subject: Re: [dm-devel] [dm-5.19 PATCH 21/21] dm: improve abnormal bio
 processing
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
 Mike Snitzer <snitzer@kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <1C26E026529103418CE6EE3FBA0992CA@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Apr 22, 2022 / 09:26, Mike Snitzer wrote:
> On Fri, Apr 22 2022 at  9:13P -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:

[...]

> > Thanks for your report, I'll sort it out but your patch doesn't seem right.
> > 
> > init_clone_info() will reset ci.is_abnormal_io so the bio won't be
> > processed properly.

Right, I missed that point.

> FYI, I will be pushing a rebased commit with the following patch folded in:
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 7e3b5bdcf520..9650ba2075b8 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c

[...]

I tested the dm-5.19 branch at git hash e7ea9556985f including the fix above,
and observed it passed all of my test sets. Thanks!

-- 
Best Regards,
Shin'ichiro Kawasaki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

