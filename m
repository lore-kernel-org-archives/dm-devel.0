Return-Path: <SRS0=eE7R=JJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A184C433ED
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 00:25:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 90CA66120F
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 00:25:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90CA66120F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-q_C2x491O9WPXUnESJD41g-1; Sun, 11 Apr 2021 20:25:27 -0400
X-MC-Unique: q_C2x491O9WPXUnESJD41g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C567107ACC7;
	Mon, 12 Apr 2021 00:25:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A3FF5D6D5;
	Mon, 12 Apr 2021 00:25:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CF01F1806D0F;
	Mon, 12 Apr 2021 00:25:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13C0P8lv012900 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 11 Apr 2021 20:25:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 43A161111C83; Mon, 12 Apr 2021 00:25:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DCFD1111C80
	for <dm-devel@redhat.com>; Mon, 12 Apr 2021 00:25:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45F2F101A52C
	for <dm-devel@redhat.com>; Mon, 12 Apr 2021 00:25:05 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-244-0XaBNLsHP1KylXDsKBYY8w-1; Sun, 11 Apr 2021 20:25:00 -0400
X-MC-Unique: 0XaBNLsHP1KylXDsKBYY8w-1
IronPort-SDR: MoB0AcKdAkU1M9NU1RhB1BrRSxuYQpkuD0xqLCdDmAaHOBp4oHwjD83yvp8HiFrAlugug2NPJm
	QIXtD0T7/d/6Hp8DD7TIpOfe88oA5CJMTTn8oc1i/8vpRg4L5EKXjlqabrKl38Nf60tSuNlRr2
	ym6TJOjWUFOABZwJ1u9fgXF+L4xgSV5b4BR04EoS8KQJbeJrjmntRQ6Q3ohhVTfaskZJNGE9Ch
	LWxcFNAtjercruMhQZaU8ocKKqMDcWgP+TmHyu1eyqhaVue3DWzEiuZDnLprBu/l8Gznhuh8HY
	UvI=
X-IronPort-AV: E=Sophos;i="5.82,214,1613404800"; d="scan'208";a="165273425"
Received: from mail-mw2nam10lp2105.outbound.protection.outlook.com (HELO
	NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.105])
	by ob1.hgst.iphmx.com with ESMTP; 12 Apr 2021 08:24:58 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by BL0PR04MB6546.namprd04.prod.outlook.com (2603:10b6:208:1c2::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21;
	Mon, 12 Apr 2021 00:24:56 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78%3]) with mapi id 15.20.4020.022;
	Mon, 12 Apr 2021 00:24:56 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Selva Jove <selvajove@gmail.com>
Thread-Topic: [RFC PATCH v5 2/4] block: add simple copy support
Thread-Index: AQHXByxWhY0q9dGq/EW9B8B+rRJ+Hw==
Date: Mon, 12 Apr 2021 00:24:56 +0000
Message-ID: <BL0PR04MB6514B34000467FABFD6BF385E7709@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210219124517.79359-1-selvakuma.s1@samsung.com>
	<CGME20210219124603epcas5p33add0f2c1781b2a4d71bf30c9e1ac647@epcas5p3.samsung.com>
	<20210219124517.79359-3-selvakuma.s1@samsung.com>
	<BL0PR04MB6514EA91680D33A5890ECE16E7839@BL0PR04MB6514.namprd04.prod.outlook.com>
	<CAHqX9vb6GgaU9QdTQaq3=dGuoNCuWorLrGCF8gC5LEdFBESFcA@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:1134:9421:2151:4ee3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb7d7f6b-48de-4f67-4e77-08d8fd496655
x-ms-traffictypediagnostic: BL0PR04MB6546:
x-microsoft-antispam-prvs: <BL0PR04MB6546F1721CC6CB32123BED96E7709@BL0PR04MB6546.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:923
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: E1EnMG0d2IPKRSfPon7FvRAiK+E4Ted8XbRe1NZP4wgBjWnnfoxy63tFuIAnYl42I73Ncx6pFt21qjyVGgWyeBj7kn5MnmMJ7Xk3KNMebEZaYwjL0JrlHJEuUVmOOXclXiZmW7TktUnZa1uLppxdUChzSJ+14C9nydKBztjAooDdeiCpjai9UlyuyQlxTlL9P02oc1X/r1BwOAjdEXMLFdIkzlUJKSjTmTDSFGEGUndssjZZ3RkycdCvZ6JAqDUiNRFFdgV+XWfHaBXSFMSTk8awypxiwp2F7/4Fn9wv34t++NQY6HJcgZGARRjuBhCbpudLDBk/7w2N9YsO0lfNeGwL0Q/8SjWRhSVTLRXIHgC9h1JqPuh3R9kHpAciwh32zvZvi1Ko90eBmm5+R/1XZztSnyZaxe20fjFPN+XfXQTaJ4rBFfeIDGzmdpctPs1npC8KFnurKbmy1Pvd0a/O03SDypF8afKNUUAyhoCCHojIzyGwicsCTiojlkDtkaN7iVRj9IvZ4skyyULX7LCtXq14+xKdMLGWLe83z7LH9SDUd8FVrELr+MQX2mwmcd0xOfJ61YNockXGGaYN18inYibr3z92bpLHAVSw8oDdwOXUt1C8ydXHwqjY/4/JijjJEfJwxIwli+HrUMAc7DYCnM31Mtet0937cyStRJdx59maxyv2d3LlG66iR1wZ/OQD
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(966005)(66446008)(76116006)(52536014)(66556008)(5660300002)(91956017)(64756008)(66476007)(66946007)(53546011)(8936002)(316002)(186003)(71200400001)(7416002)(8676002)(6506007)(83380400001)(54906003)(38100700002)(86362001)(4326008)(55016002)(2906002)(9686003)(7696005)(33656002)(478600001)(6916009);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cg5e4KiF9MF0naCX6i/ThYaTi/PMz9Nq4Qp+fUbtzlypI3Q8u+PAL/NnlsFX?=
	=?us-ascii?Q?+X0dJ/9bWGNMkRQ6dyN7/wSlrR0sMjNDHcFDo7oeGu+RB6WaS9BgocUKA1V3?=
	=?us-ascii?Q?2OkA8ROEcyqfOEWh4qziV7m01RMmRhnJa+pBBspl1Y8oZ4YLBkDdaEK2ucEL?=
	=?us-ascii?Q?PDvZ2f2u73hSZ9csAIPLOV4BPuu/wC9PH+Kg/+L2P+8B2RsRqNT3oFmdL5QH?=
	=?us-ascii?Q?0x/S3kCNAK+H9uW8nAIkJHhq5jhlQaFu6uwVoY3ckP9QwtnMA0SBlQYPqOjJ?=
	=?us-ascii?Q?Oin/EIphZQAmSNJ/1sFfZBqGR8vQX9zVI8wnVVfx3OZESuDo7W2ZCnU7gL8y?=
	=?us-ascii?Q?sDd11UhW9WXF0E4bu4s0NGJFJyXl6x7Vo729LGC071+5NICm5nA5cyBb4oWN?=
	=?us-ascii?Q?5nPFKjHme25f1OuDQ407cGLWCOLwt8t6zREFHg2f8qIjbDOMFe9dfFSNgaBQ?=
	=?us-ascii?Q?lVkLrbamKiZo9FI8cMhMYTgMx4uqgiXz2qWw3fSEBWoQAYzx466F15Wops5t?=
	=?us-ascii?Q?5pkf5ixjfKiBJlSdlY6ifEuExNYFQ05qyn+g+q1QOwK1othIcf6N/sXuQ/kc?=
	=?us-ascii?Q?xuz0pzrsiHX0/LBgth9hW2oACTDPOr7ouZ0MSL+ihDPFI8xqCqWySEuCyplt?=
	=?us-ascii?Q?KoXsRotdZ8teK9uoH/Assx/2ojVPxSpn89qXxKDfc6mI3f6bLqiTf7sUpwTQ?=
	=?us-ascii?Q?oL3hdnGXjoJIWXEvNdeY0y60N5VKgaw1TYORhBhWoUsqCLFd1g51QjwY5bHu?=
	=?us-ascii?Q?0rXeVr0+9yymxh6hoYw20CCgwFd11+xWWULzb7F1OakJEAQNfe+jI/TzkWmp?=
	=?us-ascii?Q?c2tZB0Nyh6rYYrHxfu8TH+muU4qxEmXs3w1l06v0gJYMTFi3Qd25Nu9CfSUQ?=
	=?us-ascii?Q?KrjqyKbk/Hdk2BuHXHBzjUQbiGWubM2KH2MFtAWk8J+bDFh2ac+6OdAjTQPB?=
	=?us-ascii?Q?cJ5JafZs6pIOpb3MtrK2aORhk+F3+Yql8iFcCiuE8GcHy8wma4/RssF+jLXw?=
	=?us-ascii?Q?O6vgxfm1DrGoW8tBIaRdMnOuqIg5h8NOLIfhyVgfwRqwxMWzaJBoPYZuLqmH?=
	=?us-ascii?Q?67QOadByky1KerItYCpUJkAOcAdlbC2RPxQk0sclVdyuNmo9S561ga6ba5IU?=
	=?us-ascii?Q?1jvhuQYvbPnqK21G+TNM0kU6pBWhwzIVTQwKK5vrN024PBntK6Bo8T/u1Bul?=
	=?us-ascii?Q?NvEpoqKAzVxWr0R4NUL8l8cY7QpB/9FKKJOkYGRkSGYrwBGEzUj0nNibNaao?=
	=?us-ascii?Q?ml0ODX55izkND40PqK0ZuQfz33t4YSvJRvSqJqyXx4oe59yQ6xEejXUNR0Lx?=
	=?us-ascii?Q?8DPIfT2X5QQRZo+QX80ak+9lTe6u2lSB5Pd6DosJ4Sbqxa3jnzW7QJ7dzGr7?=
	=?us-ascii?Q?DjtTrox0wZ1xUanWqY4weJalD/6urHNVCLdzvt6cQ5TPFfiMYA=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb7d7f6b-48de-4f67-4e77-08d8fd496655
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 00:24:56.3345 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oa66vKcD59q7C168B7+dNoSz1+UahsJaSgObpMgDTUTxV5ujbzS1mgHyik5e5dfQG1h8C8SEIdr2M52qsMObRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB6546
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13C0P8lv012900
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "kch@kernel.org" <kch@kernel.org>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"joshiiitr@gmail.com" <joshiiitr@gmail.com>, "hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH v5 2/4] block: add simple copy support
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/04/07 20:33, Selva Jove wrote:
> Initially I started moving the dm-kcopyd interface to the block layer
> as a generic interface.
> Once I dig deeper in dm-kcopyd code, I figured that dm-kcopyd is
> tightly coupled with dm_io()
> 
> To move dm-kcopyd to block layer, it would also require dm_io code to
> be moved to block layer.
> It would cause havoc in dm layer, as it is the backbone of the
> dm-layer and needs complete
> rewriting of dm-layer. Do you see any other way of doing this without
> having to move dm_io code
> or to have redundant code ?

Right. Missed that. So reusing dm-kcopyd and making it a common interface will
take some more efforts. OK, then. For the first round of commits, let's forget
about this. But I still think that your emulation could be a lot better than a
loop doing blocking writes after blocking reads.

[...]
>>> +int blkdev_issue_copy(struct block_device *src_bdev, int nr_srcs,
>>> +             struct range_entry *src_rlist, struct block_device *dest_bdev,
>>> +             sector_t dest, gfp_t gfp_mask, int flags)
>>> +{
>>> +     struct request_queue *q = bdev_get_queue(src_bdev);
>>> +     struct request_queue *dest_q = bdev_get_queue(dest_bdev);
>>> +     struct blk_copy_payload *payload;
>>> +     sector_t bs_mask, copy_size;
>>> +     int ret;
>>> +
>>> +     ret = blk_prepare_payload(src_bdev, nr_srcs, src_rlist, gfp_mask,
>>> +                     &payload, &copy_size);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     bs_mask = (bdev_logical_block_size(dest_bdev) >> 9) - 1;
>>> +     if (dest & bs_mask) {
>>> +             return -EINVAL;
>>> +             goto out;
>>> +     }
>>> +
>>> +     if (q == dest_q && q->limits.copy_offload) {
>>> +             ret = blk_copy_offload(src_bdev, payload, dest, gfp_mask);
>>> +             if (ret)
>>> +                     goto out;
>>> +     } else if (flags & BLKDEV_COPY_NOEMULATION) {
>>
>> Why ? whoever calls blkdev_issue_copy() wants a copy to be done. Why would that
>> user say "Fail on me if the device does not support copy" ??? This is a weird
>> interface in my opinion.
>>
> 
> BLKDEV_COPY_NOEMULATION flag was introduced to allow blkdev_issue_copy() callers
> to use their native copying method instead of the emulated copy that I
> added. This way we
> ensure that dm uses the hw-assisted copy and if that is not present,
> it falls back to existing
> copy method.
> 
> The other users who don't have their native emulation can use this
> emulated-copy implementation.

I do not understand. Emulation or not should be entirely driven by the device
reporting support for simple copy (or not). It does not matter which component
is issuing the simple copy call: an FS to a real device, and FS to a DM device
or a DM target driver. If the underlying device reported support for simple
copy, use that. Otherwise, emulate with read/write. What am I missing here ?

[...]
>>> @@ -565,6 +569,12 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>>>       if (b->chunk_sectors)
>>>               t->chunk_sectors = gcd(t->chunk_sectors, b->chunk_sectors);
>>>
>>> +     /* simple copy not supported in stacked devices */
>>> +     t->copy_offload = 0;
>>> +     t->max_copy_sectors = 0;
>>> +     t->max_copy_range_sectors = 0;
>>> +     t->max_copy_nr_ranges = 0;
>>
>> You do not need this. Limits not explicitely initialized are 0 already.
>> But I do not see why you can't support copy on stacked devices. That should be
>> feasible taking the min() for each of the above limit.
>>
> 
> Disabling stacked device support was feedback from v2.
> 
> https://patchwork.kernel.org/project/linux-block/patch/20201204094659.12732-2-selvakuma.s1@samsung.com/

Right. But the initialization to 0 is still not needed. The fields are already
initialized to 0.


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

