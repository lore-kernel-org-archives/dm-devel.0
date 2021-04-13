Return-Path: <SRS0=RJDn=JK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C56BC43460
	for <dm-devel@archiver.kernel.org>; Tue, 13 Apr 2021 00:36:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 282F1613AB
	for <dm-devel@archiver.kernel.org>; Tue, 13 Apr 2021 00:36:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 282F1613AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-BkoJIONpOv-eAQ45-7FGSQ-1; Mon, 12 Apr 2021 20:36:24 -0400
X-MC-Unique: BkoJIONpOv-eAQ45-7FGSQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0F2E800D53;
	Tue, 13 Apr 2021 00:36:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CC6A17F77;
	Tue, 13 Apr 2021 00:36:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 913149987;
	Tue, 13 Apr 2021 00:36:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13D0a7Ii025409 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 12 Apr 2021 20:36:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AD7062155C84; Tue, 13 Apr 2021 00:36:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5FAC2155C99
	for <dm-devel@redhat.com>; Tue, 13 Apr 2021 00:36:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8B8C811E7A
	for <dm-devel@redhat.com>; Tue, 13 Apr 2021 00:36:04 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-361-lGdiee0TOom0O1heCVHMRA-1; Mon, 12 Apr 2021 20:36:00 -0400
X-MC-Unique: lGdiee0TOom0O1heCVHMRA-1
IronPort-SDR: GDIp98SwfKumKXNxqq5OzwBzt/FJxQpR05kNgoXfdxDjq+vS8KYsFSCP+9js0DRU209HOjX4y7
	tgIS1d2xVQGuA6zekO9HqAdqEvp32pWP5jMOa9aBCCYyvXdRh6+mrZeGv9PzhpGegMb0n4vHol
	ulhrppYhtiQ2i4KIBXtJfWN/kV+H0XYcJGszMaZn9UivRSOkGCV2i1Gmj0F19zfjtXcJxuXRaR
	m9LCajiTIAZm8s5zmxp6JIlYIuuLMMVAJTsMwpudoVnptsUPNy9uwYoV4m16Z5PfCagzuzO3ao
	q8s=
X-IronPort-AV: E=Sophos;i="5.82,216,1613404800"; d="scan'208";a="268792245"
Received: from mail-dm3nam07lp2047.outbound.protection.outlook.com (HELO
	NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.47])
	by ob1.hgst.iphmx.com with ESMTP; 13 Apr 2021 08:31:48 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB6416.namprd04.prod.outlook.com (2603:10b6:208:1a3::8)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18;
	Tue, 13 Apr 2021 00:32:14 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78%3]) with mapi id 15.20.4020.022;
	Tue, 13 Apr 2021 00:32:14 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Selva Jove <selvajove@gmail.com>
Thread-Topic: [RFC PATCH v5 2/4] block: add simple copy support
Thread-Index: AQHXByxWhY0q9dGq/EW9B8B+rRJ+Hw==
Date: Tue, 13 Apr 2021 00:32:14 +0000
Message-ID: <BL0PR04MB65146169A9C7527280C15D4AE74F9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210219124517.79359-1-selvakuma.s1@samsung.com>
	<CGME20210219124603epcas5p33add0f2c1781b2a4d71bf30c9e1ac647@epcas5p3.samsung.com>
	<20210219124517.79359-3-selvakuma.s1@samsung.com>
	<BL0PR04MB6514EA91680D33A5890ECE16E7839@BL0PR04MB6514.namprd04.prod.outlook.com>
	<CAHqX9vb6GgaU9QdTQaq3=dGuoNCuWorLrGCF8gC5LEdFBESFcA@mail.gmail.com>
	<BL0PR04MB6514B34000467FABFD6BF385E7709@BL0PR04MB6514.namprd04.prod.outlook.com>
	<CAHqX9vYvtOaVL4LG0gAGCMz+a8uha8czH==Dgg3eG+TWA+xeVQ@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:1134:9421:2151:4ee3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86b8edd7-995f-47f7-1b22-08d8fe1395e7
x-ms-traffictypediagnostic: MN2PR04MB6416:
x-microsoft-antispam-prvs: <MN2PR04MB6416FDF25A008AFDAEDBE0AAE74F9@MN2PR04MB6416.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:357
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: IKohhaa6OzN/n+8G8XH8XUFePW2IUGfrEm92pjNN93Y5q/ASyJi+C/EocbwYzY7MODjX2qM5Om0Rka9iPgARfb3+I9gb83r0l4F2QNv10VT1ERIvWfIAGFihzl91wFlunJPaOPwgYfV6Jm7SQ4QhYGO7qIJwk3rsVVCwhB99RgjRz/BFY29mc3+zNNoeUSvVlfDVHFTa5rahEMilHjif82NqpmZaJMfXkNOurpQC0S0nOy7tqm+8GPEvHzGt9P4r09WS1BHbZSAyNQ7EpgX8NAMMNgDA1VxYzVHeuwSIUf+wkvJrpYIH5jrmKPRXRH/blFUoFhK8hs79dz0cC7CSp7dacp2cWRcWuXMtAWMhnLuuLbK+dEwSvhzrbxBZNdoquCdYG7XIFUZfwLq+HQXSpu7gQkUEA9eYUwP6b5+TY1miDGUsFEYP1SF5yLGXVlncxe66+y65xrdcalBubaP4MtRlBLMg0XnlsfiqqKNVNDRylTrAnzlNQBQvB1VfRjTTsaU4CPs7T88YLyGcFdVEok1qR0Fbj6EW0KiK7henLVrzvqXCisK5demaYVjVRSHelyqOv298jV7w3j4mxUcxWgLB1v/EEPzhs73J8/MebtM=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(55016002)(478600001)(5660300002)(38100700002)(9686003)(86362001)(66556008)(316002)(66946007)(6916009)(53546011)(66476007)(4326008)(76116006)(8936002)(64756008)(66446008)(71200400001)(33656002)(83380400001)(2906002)(7696005)(54906003)(186003)(52536014)(6506007)(8676002)(91956017)(7416002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?U77AZYKlIQq2UxIhbeODYn+c5wvBWysPzwE75cSgUqPOlD+R+MgkAafdGUUz?=
	=?us-ascii?Q?mk7gUaT0b8x8NT0Gc1K9f27YihuI3r7e3uKYzPx/FxXt8RzspGKZPwFm4a5q?=
	=?us-ascii?Q?ll8+dkvMm2qzTUyHExdhU0l+I0FDf8jCxB8uZIMtKxlugHffsDZaCHyQaLtz?=
	=?us-ascii?Q?xkHcqGCWUZ/XzZH18gAgf0vRlggEoms90ifsa1Ati+fB1ALRGwbThbpKaIXG?=
	=?us-ascii?Q?H0QT7mWXDLclVdU6Cv5XUtL5GW44UN9hSBuMlHtWOEZkN2m7E6P3XE2+zlS/?=
	=?us-ascii?Q?kGbjVxFqhgZ0r4pqy7dNlCoz/HkR+dMrj9wzr4u2YrhuX7qsT8lDBoP5BCAv?=
	=?us-ascii?Q?KxDRW3lfTucudjFOJ8naRWKC5CiwA/mqbyRgLRoWoJDBpsk0SgiHBYG4dSao?=
	=?us-ascii?Q?Q+U5H7k/SEAzAqebf/uXP+Xosi4rQ1A+RT9JKjDIhDOkw0JA6MbJp2Vwyiym?=
	=?us-ascii?Q?3sH7tZagk9vHeIZP1xJN0vT5p5xHJwuMlhijP0QaKEWD0JkZ9sQs0PpZ+n4K?=
	=?us-ascii?Q?ic1+/ta1ueKUK7nGOKNS8VKS2zflhyOACqH9UK2rSka66S2SWT9/UTVgYOGD?=
	=?us-ascii?Q?6VbN1R3hDUh6uiOV6+sXh+C3y5ppb/kJBAA9YYDsm97F4yqVQIGzTHw2QdVm?=
	=?us-ascii?Q?mtt1GMLupxXikwiDcNwvZ9gGoGD69vHSH66n6vV9wBMhDIyoyYs7Zp70pu3g?=
	=?us-ascii?Q?sblRjUgvZcn4VV1wiIpXWSH9TfM6X2QFgQQeYuAxPejHYaWXH2dcvOn/+DwF?=
	=?us-ascii?Q?kWGYMLZvvF38C4zT56oLGcGGhc/FYesHwJ/V+W8gXglwUyxOg8T2Eq5n0tL5?=
	=?us-ascii?Q?Inv19l3m7gFrZBTGR0enKiYkCk43HLQJBYerMaIMypzI8ivGaxqi9YR0Nakb?=
	=?us-ascii?Q?5YFm41RML3d/GL9bTZnilYfBEHGREpUxb+g5mM0GvnjtRbOSQfiyrbHe/QrP?=
	=?us-ascii?Q?uDRjIFcPW0qFJHF6Y97R8gN3F+3r3/yALItB7K9StfvdhBeoxBV/rUlrnT+k?=
	=?us-ascii?Q?+eExMUcEmKMdmz9pcNkL3wBmlDKMXvNDAbnuT9Bx9UT+8Vg5KT62m7HR/3Ps?=
	=?us-ascii?Q?6Nwc/4oRoWMHcMA43XPsnum9x4RScwwtOPmozlsN8fIG9UhzcEfGhYcjDmgu?=
	=?us-ascii?Q?KClpoTWFB41jzNHmNjVTIb3/KoRuEG2/dzmoPeuPhsEe2MP+bAMf+GWP4Mec?=
	=?us-ascii?Q?OU80NvCYPXpJoYb85HTmt1/yy8RQSWd9ACeVPYrsvunyF/pQj3Uvw+7FyUq7?=
	=?us-ascii?Q?GdT1J1cGoLI/UkJM2AhGdi1bZ+c8LNHT8jk5tL9jSPHK/kyFGVCil/prfrBG?=
	=?us-ascii?Q?G6UwBZKKzA8Wsvxr7JVYmPpSKNGB/ofOfrnz+eRdMAhLM0EaoophF10fb9N8?=
	=?us-ascii?Q?FDd7FWKFfmUshgSVmyY3z0UDO9/EQRQuEo04VYi1Va+gPOa73Q=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86b8edd7-995f-47f7-1b22-08d8fe1395e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 00:32:14.4505 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q45jY7heLab0BUCytM6USTe3hTqEd8yxrYCHY9+xsAtRp+etxiabX4DsjXyIq4Dk4FtwiNDlMFa8ed9fxwucjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6416
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13D0a7Ii025409
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/04/12 23:35, Selva Jove wrote:
> On Mon, Apr 12, 2021 at 5:55 AM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>>
>> On 2021/04/07 20:33, Selva Jove wrote:
>>> Initially I started moving the dm-kcopyd interface to the block layer
>>> as a generic interface.
>>> Once I dig deeper in dm-kcopyd code, I figured that dm-kcopyd is
>>> tightly coupled with dm_io()
>>>
>>> To move dm-kcopyd to block layer, it would also require dm_io code to
>>> be moved to block layer.
>>> It would cause havoc in dm layer, as it is the backbone of the
>>> dm-layer and needs complete
>>> rewriting of dm-layer. Do you see any other way of doing this without
>>> having to move dm_io code
>>> or to have redundant code ?
>>
>> Right. Missed that. So reusing dm-kcopyd and making it a common interface will
>> take some more efforts. OK, then. For the first round of commits, let's forget
>> about this. But I still think that your emulation could be a lot better than a
>> loop doing blocking writes after blocking reads.
>>
> 
> Current implementation issues read asynchronously and once all the reads are
> completed, then the write is issued as whole to reduce the IO traffic
> in the queue.
> I agree that things can be better. Will explore another approach of
> sending writes
> immediately once reads are completed and with  plugging to increase the chances
> of merging.
> 
>> [...]
>>>>> +int blkdev_issue_copy(struct block_device *src_bdev, int nr_srcs,
>>>>> +             struct range_entry *src_rlist, struct block_device *dest_bdev,
>>>>> +             sector_t dest, gfp_t gfp_mask, int flags)
>>>>> +{
>>>>> +     struct request_queue *q = bdev_get_queue(src_bdev);
>>>>> +     struct request_queue *dest_q = bdev_get_queue(dest_bdev);
>>>>> +     struct blk_copy_payload *payload;
>>>>> +     sector_t bs_mask, copy_size;
>>>>> +     int ret;
>>>>> +
>>>>> +     ret = blk_prepare_payload(src_bdev, nr_srcs, src_rlist, gfp_mask,
>>>>> +                     &payload, &copy_size);
>>>>> +     if (ret)
>>>>> +             return ret;
>>>>> +
>>>>> +     bs_mask = (bdev_logical_block_size(dest_bdev) >> 9) - 1;
>>>>> +     if (dest & bs_mask) {
>>>>> +             return -EINVAL;
>>>>> +             goto out;
>>>>> +     }
>>>>> +
>>>>> +     if (q == dest_q && q->limits.copy_offload) {
>>>>> +             ret = blk_copy_offload(src_bdev, payload, dest, gfp_mask);
>>>>> +             if (ret)
>>>>> +                     goto out;
>>>>> +     } else if (flags & BLKDEV_COPY_NOEMULATION) {
>>>>
>>>> Why ? whoever calls blkdev_issue_copy() wants a copy to be done. Why would that
>>>> user say "Fail on me if the device does not support copy" ??? This is a weird
>>>> interface in my opinion.
>>>>
>>>
>>> BLKDEV_COPY_NOEMULATION flag was introduced to allow blkdev_issue_copy() callers
>>> to use their native copying method instead of the emulated copy that I
>>> added. This way we
>>> ensure that dm uses the hw-assisted copy and if that is not present,
>>> it falls back to existing
>>> copy method.
>>>
>>> The other users who don't have their native emulation can use this
>>> emulated-copy implementation.
>>
>> I do not understand. Emulation or not should be entirely driven by the device
>> reporting support for simple copy (or not). It does not matter which component
>> is issuing the simple copy call: an FS to a real device, and FS to a DM device
>> or a DM target driver. If the underlying device reported support for simple
>> copy, use that. Otherwise, emulate with read/write. What am I missing here ?
>>
> 
> blkdev_issue_copy() api will generally complete the copy-operation,
> either by using
> offloaded-copy or by using emulated-copy. The caller of the api is not
> required to
> figure the type of support. However, it can opt out of emulated-copy
> by specifying
> the flag BLKDEV_NOEMULATION. This is helpful for the case when the
> caller already
> has got a sophisticated emulation (e.g. dm-kcopyd users).

This does not make any sense to me. If the user has already another mean of
doing copies, then that user will not call blkdev_issue_copy(). So I really do
not understand what the "opting out of emulated copy" would be useful for. That
user can check the simple copy support glag in the device request queue and act
accordingly: use its own block copy code when simple copy is not supported or
use blkdev_issue_copy() when the device has simple copy. Adding that
BLKDEV_COPY_NOEMULATION does not serve any purpose at all.



-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

