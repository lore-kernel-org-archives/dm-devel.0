Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8145C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 19:24:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2D30B22228
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 19:24:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D30B22228
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-SfAe0HJUPVOhiPSnHD0bSg-1; Tue, 26 Jan 2021 14:24:43 -0500
X-MC-Unique: SfAe0HJUPVOhiPSnHD0bSg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31F66107ACF5;
	Tue, 26 Jan 2021 19:24:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0994363746;
	Tue, 26 Jan 2021 19:24:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B0AD8CF53;
	Tue, 26 Jan 2021 19:24:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10QJFCdO015239 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 14:15:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 49E1E2026D48; Tue, 26 Jan 2021 19:15:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 415392026D76
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 19:15:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B164C101A566
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 19:15:09 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-475-MsP061zSPhGkvJYE2m6eBA-1; Tue, 26 Jan 2021 14:15:07 -0500
X-MC-Unique: MsP061zSPhGkvJYE2m6eBA-1
IronPort-SDR: 9F2eAYyHkgpATgkwLy1uhYiWsWZ5LUuQnRgygSejEf4CRXwtTGSIB+/CXjZ+orLDwIb2vr4hz8
	JWLrr9ZTteiUk4tXxaXO6ez5X4SQZqIRVo56fAxonHw4cBna5z1++vvKDZ8uaVB86eBC7ww5Mq
	5zz2samSRkv59suuw3mqY6j/cwogoIKOScSh+7+WLbAhywqZKASd2+LuCqNCUIBrhh2xyqtigO
	nezlYVMAxxnHYeMq7i/fxkvk2fmTgcalMTqHvEnWauWTZN/pLxuCv+MzlAMzO5Nvu8fy8Vmg1X
	yHw=
X-IronPort-AV: E=Sophos;i="5.79,377,1602518400"; d="scan'208";a="158379142"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
	by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 03:15:03 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB5895.namprd04.prod.outlook.com (2603:10b6:a03:112::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16;
	Tue, 26 Jan 2021 19:15:02 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3784.016;
	Tue, 26 Jan 2021 19:15:02 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu
	<song@kernel.org>
Thread-Topic: [PATCH 05/17] block: use an on-stack bio in blkdev_issue_flush
Thread-Index: AQHW8/UAfT2lRjWk50ewoG8V7AspXA==
Date: Tue, 26 Jan 2021 19:15:02 +0000
Message-ID: <BYAPR04MB4965E6615D7173005E4C634586BC9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-6-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2600:8802:270c:4b00:b091:5edc:1473:bf45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d2ede5d2-37e8-4220-5422-08d8c22eae89
x-ms-traffictypediagnostic: BYAPR04MB5895:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5895A39F23DE21E70646371186BC9@BYAPR04MB5895.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:386
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: B8pXtJljlJUm8z0H7m1rZqP9q65K0txR3xo2jzgTdMO8IpwJK4tbl55zQ1Gz6V0LWIWP05GbRponlmrdcGoIdLdcWCip0TeXI2GrvxYQ94STZrdpBgZziAZuv+ZbEe/qhr+HwvadvtRu3pke6urep5gzdaJ35Sf3Ai21eF1qGK/h1OVy+c94aNp0jUw3o1x+MB3+BwC4HxsliyLAKcueLdH3UAn0qN+Nyi2m7UrxXbSqInuj+phQ3bhadAmrOo7uAVv9g+l8BYb4Iqv8maRA9N5w6eHAJ2jSAxqsPqNGqffVZAF5UbjjG06biyORjZQDMbrG+NplYPxU7lfxIz9/vG4Vjzbm/hce3H3c3xz2SX8tAMs30ImA5Lmg7wx9kvVNihK074egXy22CZ5ipeEPEg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(5660300002)(52536014)(71200400001)(186003)(76116006)(66476007)(66446008)(64756008)(86362001)(91956017)(66946007)(33656002)(66556008)(4326008)(7696005)(316002)(478600001)(53546011)(6506007)(2906002)(54906003)(8676002)(110136005)(8936002)(9686003)(55016002)(7416002)(558084003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TpsFeAAzWrQgdE0UidxLtnQ32uznoO0hmJsUfSNGT9zgal/lfYu47Cul/45I?=
	=?us-ascii?Q?vCKegYrsoA+ssWzargnWvnCezjOUEfrOkjkpOU9F4q8EQOqfi25ly0+P66EK?=
	=?us-ascii?Q?z691ZoVK3ZV3giHIe7HMsZIwgk7td8bdlVKCJs+/GscHRujHmDgPV7XdnCc4?=
	=?us-ascii?Q?PzWcpdaPxb9ajMoRh0KHdaLMi9lzjm22y08Pi6LlJYewNi/6pQRUS6whFx9b?=
	=?us-ascii?Q?MU4IenfDhog/hhqO7BVZuRtk1aiLG6hbkfBpkSye1bnJcfCMdZRjB2ofuer4?=
	=?us-ascii?Q?BCJRTGzKJ6cIaQZGCaBF94Rxx/SS1rQjatli38YGli1rD0taC4ayYwiJHhDf?=
	=?us-ascii?Q?X4viWkWObid1joxl4DvBCQ0ziE5WaFY0PcSP+2i2UNkTe4s5b/So1svc/QzD?=
	=?us-ascii?Q?WusDcqUFrSsv9Y+vXuOrNUNzdArSSa0xvwN96Uh6PAf0UBclFRScJ7uTKHEl?=
	=?us-ascii?Q?NMtexDZvpdTpBcrBtKCx04MREzn/gCnPX17GFeOfAT628X19IqRYYzqKUdBG?=
	=?us-ascii?Q?aVTYbR9l2y8KdGjdUbncClWBHnrSJCWXdYJ4QAdp08g2AhwKrLr2yMOEfug3?=
	=?us-ascii?Q?AvKftmgKlbW0bLjlwg0XfU0UDYWXNPhS0A8H6HU0TkX4uQvJrAW9Wp/y0svT?=
	=?us-ascii?Q?Q4pZ2gu42pobxJUGMOnhX6LkQpOd9KiGpGUqgxAdNbyfgtsd+6xQ1Xh/ASXX?=
	=?us-ascii?Q?iuaComdzh/88YH2h7eJ5KwgiGK1Oxpf7IDPLmvzq+st7p8XKGLdJHvLgdK29?=
	=?us-ascii?Q?LbKsOVYgVMO34HxFqXCY8LQU8iIBy2CCNdnQa7/snnD6RsH3JlYI487QmKtD?=
	=?us-ascii?Q?XMgShcqBpF9Ui7CwzR7FOaDDdRQyyLiqIxwBXYEH3HqpUYqJgCWxzjzLUN+b?=
	=?us-ascii?Q?uZQos8Xj91geXaSufUiMTSS2heocGw1gC8C3xWLR7HdJVFosNPZ6QdFt3vmv?=
	=?us-ascii?Q?EJNMPCYYJMHffsvv98uY9xUYvDTE31rhZkdvwUiqgjkjkGpPG1NVliyLIQar?=
	=?us-ascii?Q?F0WA5ETH8QbRmG8YkQxp8elUDMLVA1zESuBfOqt9h8aNvRMrWmn07dlQL8m/?=
	=?us-ascii?Q?RUTkjvVliKeMPXBkCtaoQzxX2OsmbmQ6eHLXMKsfIU11NkXvOaq5jxi8cK83?=
	=?us-ascii?Q?SLsZNmtHnYiU9UgrbQWOehctY6lEFOP9Kg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2ede5d2-37e8-4220-5422-08d8c22eae89
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 19:15:02.4505 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dxvRsepTtCj9PG3nalZYrQcf9Sqpza4sLAKGGnrIYBqSvvucUqdPzSs2+gXn3BnHpPHMzNSlB4ofzI99FgiaBWc2+sjVTxALlgSeM8N0fa4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5895
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10QJFCdO015239
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, David Sterba <dsterba@suse.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>,
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
	Ryusuke, Chao Yu <chao@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	"drbd-dev@lists.linbit.com" <drbd-dev@tron.linbit.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Konishi <konishi.ryusuke@gmail.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Damien Le Moal <Damien.LeMoal@wdc.com>, Philipp,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Reisner <philipp.reisner@linbit.com>,
	"linux-f2fs-devel@lists.sourceforge.net"
	<linux-f2fs-devel@lists.sourceforge.net>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 05/17] block: use an on-stack bio in
	blkdev_issue_flush
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/26/21 7:07 AM, Christoph Hellwig wrote:
> There is no point in allocating memory for a synchronous flush.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

True, looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

