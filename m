Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A63CCA479
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656939885;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=jB6IsKj7OFqmrJNfez6cgeBZ9xj8uuwGLyCnO4+OJx4=;
	b=JLjv4AN/xsBpZFwmcWb9KXrP2bqGTnpEis090+WOiYKzlBfnVd7SF1GI1Ba4NXwHifSRvX
	JioOR6w6eRzKHKiTVJ5M8HQPWA942HB4/pgmgVqd1AIHy9XM1Mzh67F+ZjzDkTuCWceU26
	XHi5O5vhRnTwpNWRFb6AsbxVY8ZhfZQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-cUIq_yfwMDSljWsvOzboJA-1; Mon, 04 Jul 2022 09:04:44 -0400
X-MC-Unique: cUIq_yfwMDSljWsvOzboJA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2067B2999B44;
	Mon,  4 Jul 2022 13:04:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0BFB2400EA89;
	Mon,  4 Jul 2022 13:04:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D6898194704A;
	Mon,  4 Jul 2022 13:04:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E66A919466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:04:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B75A94010D2A; Mon,  4 Jul 2022 13:04:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B23704010FA6
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:04:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83D848339A4
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:04:40 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-FYoDP0DQMkeKdrl6KgSyMw-1; Mon, 04 Jul 2022 09:04:38 -0400
X-MC-Unique: FYoDP0DQMkeKdrl6KgSyMw-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="205480790"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO
 NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:04:37 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN7PR04MB5249.namprd04.prod.outlook.com (2603:10b6:408:3d::22)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:04:35 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:04:35 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [PATCH 01/17] block: remove a superflous ifdef in blkdev.h
Thread-Index: AQHYj6PpBGDuTXPD8UWi1k2YGkh+6g==
Date: Mon, 4 Jul 2022 13:04:35 +0000
Message-ID: <PH0PR04MB741615DC0E795F0B6B5010C89BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-2-hch@lst.de>
 <PH0PR04MB741671715E7F16D5335002509BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20220704130153.GA23752@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90120368-38f2-429e-577b-08da5dbdbe9e
x-ms-traffictypediagnostic: BN7PR04MB5249:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: B8lvacmMDfiC3AQzbPwh/uKYY6IrDaupFFT+yGTqBHLrzLrTamuMp5OLjmyJZmW6EPct72pqATmILhjmEu2PyVH/f29WMqLpqkK0cXxWWzAP5mZyATHWQkbVCE1TCPTE6GL/j7Qvx1LVG5voPiax0BmuOMZpGZFnbdBsUWpKlfkb2GLBbfyzX0/fMbws0Izf85qiBfbXbnxKvkI6GSeXY0C2ZZKj3snvqtOIEVsFuYUM/UQOSo+RM2Kt/3uk+ArO/DGnR5m+5SpWFZdsHa9xSEEnk3Z7I+eXdzt7P+ZS6MrAYvWmVIHtF75nC1s6+I+EUZTXdrRVkgEAquRSL/9UbjOB571WP3TefgbqoyVrpOpbyovnoCiG/OPyTXb0xXOJPIsGVG53QF4CFi72U7+x8DeU5Siw7QWo4C6Jxr1ya8VX2Iy3auXHmEtgb+16IboILkTiXptCUjkNAQ8OFhRkmTpxgEWxF7p+IsAYmtjU+G60GzmH/GM2hwmzQxEH+3u5nNR2yA5LlGLbt3Twu0vVWlQjJsNDw8iN6hesM4bghQBL2HM+D153lrSvLHndPuHIknokohI6WZdrXi5c5B14g9whKqpfpRh2K7ebCFAWea/hFy9k1IFfETT1Tyx4YlEYZCzdwbO1xOHoLRKx1/Cr3SrKuwZhyY31IEHYlugO1qtavdWXsnVJXPYAZwGF0DY/kDNmMtNx5vOiqRKQ2gyvyP0dFHds+uQxDieWIpWBnxcYHOvtPBOlYFKSRRTIgxKYWxarQbTzoUqZ2iH3X6vTP3kSzUVZMmg2xpE4iwm1KxSSf3K3PRcFQvhPq+NHYcjwnOw9W4xUjl8VTi82N7nV/A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(7696005)(9686003)(53546011)(478600001)(186003)(6506007)(41300700001)(33656002)(8676002)(6916009)(91956017)(52536014)(8936002)(66446008)(66946007)(76116006)(86362001)(66556008)(66476007)(2906002)(71200400001)(38100700002)(4744005)(55016003)(122000001)(54906003)(38070700005)(64756008)(5660300002)(316002)(4326008)(82960400001)(21314003);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1V+IA58JN3eDJL1XQbH09DXDCJ0MPJMxI0JPq2yPQPDW18ecInQpqQfiq1Z1?=
 =?us-ascii?Q?QWFu1NjUcD8L/yhOk1CRaSDPRar4hObOLr628W+2BWr5u7V4D/on/DtfTIm/?=
 =?us-ascii?Q?+xmzER0YCgCNU8V5QNRGa0sr9AOGq9iX5rGj591k8VWKoabhZ6kOHcBKJ60E?=
 =?us-ascii?Q?XUZ5sqy3Jvuj6RgPsl3s+QeChZ0QQ2sEZ143YgsEKgfOxgsLJvRH0h2Qo5bT?=
 =?us-ascii?Q?bTSuP+2RoncyviMxjmuhmt8jdWjVhxwpw9ccMXsfSlJwrkYQ8pSpY10d29MN?=
 =?us-ascii?Q?v9L87SMtufAUmdaKJwWivBC9tZKV6UKNp7s2gIV8svAEqDgjVbeRpbLwkfBx?=
 =?us-ascii?Q?KJmHDUUy2fIpi5kQGbEjeyBanQc7VE/X+KQLHjXNIY+x+bkiSIQ8yflzOWpg?=
 =?us-ascii?Q?+h8zhkmsVW9BdG+8ojzl2sjawoy4b4jzr1BDWyaTwQZSdp8Q7FpWYr+PTSQw?=
 =?us-ascii?Q?Em0yYNNNQ9oMqauXPMCzNtz1QAniLebtcETK71Ais985NFOxEKg+v2dk7sZ0?=
 =?us-ascii?Q?tquQ+6HdMCrZUo9ZMFsABN2qxM82fzelSNn7lDq1OZnm7JiYFZKsr7DpemNa?=
 =?us-ascii?Q?emFOwLSPUPFwPdegT9Ia5ppWrwfb2BWJOZrBI6QfdkfxqD13Pq6UaarvpMkW?=
 =?us-ascii?Q?ds+cpFiNX/QVaCwE8BbOH8//wJ3uBOdZ/BAzmiSQQ7niIb325jQFwxtSVc6v?=
 =?us-ascii?Q?qOhJKd9pnIq/Q9R11JtE1RGG69ERqB3qWcyymqyHuV7ocKTCJZOBi7bUYQ88?=
 =?us-ascii?Q?c8Iyfm3WO7ahI0/lr3HFz3a6txSSWvvX0l4OQw0lwnwG/HGbg7wmsOmmAevV?=
 =?us-ascii?Q?7KmZjAH2T+C0uvl70toJtpC46zuWkgTL3fpgvZPdYH2ItyDawXHI2XqsGZf2?=
 =?us-ascii?Q?4yUMP1q8UeRiDHTHC49CacZPJoFAeVk2MO9N0enOOqeBhITNN64GdWbK7DRO?=
 =?us-ascii?Q?aXdalh9DveQn0g7ZxRSfp82wKXCiyDq+8imQzYMzZ1DU6ENtr66cBT+tTalP?=
 =?us-ascii?Q?NlGOIxJpzLLctWjQAMSB8+iCQye/EVSXLy91XgLouY39tqpTkcQ4SJEjoLuU?=
 =?us-ascii?Q?OTjxZu/5K70j/TsraV2GR/BlsPngk/9eIs94xvNqm2a7swryw3bsreLy6k7n?=
 =?us-ascii?Q?x8pimBw0ke1PhNcq/wJckeLIdU31VMOWOouSK6TkTJ48g0Gafdtfnlp4+YZa?=
 =?us-ascii?Q?7FnWQt5gSr+MvLcpgtkJj0jBcODZtrdS/4GZhPrQ4040TAzf3nNoIAYUg1FA?=
 =?us-ascii?Q?cj98DPpjxRLsiN1j3adsVyerBl8htV0Fj7/z+f2BkB7TT0RjJepA8wvEsw5s?=
 =?us-ascii?Q?q3MRLuRODAdwuYVwmasGTzFV+KdZSZqoCRju1r9bsIuikmwk+6eaty1A2sDL?=
 =?us-ascii?Q?f2GC7nOzjYbdQoRai3AIRODJ5xYNkEsyq6IUvl+dm/ohZPZRhC6FQF9aJ5r6?=
 =?us-ascii?Q?K6X29Qk97s2MmNpY9d2Sb+VTRaWbLiX4AdnbA6NgoC/rj5FB/4yf4+WeAy2i?=
 =?us-ascii?Q?w9ZK1nqtt9HEOMLIKYn9Fbe/Ea6g0NY8GPqEjfTPTSb3I1TKP+D0mOTZTD76?=
 =?us-ascii?Q?Hy34P8eF8nHNfTSn8zBYUYKW0VYqXL46KXh9adwfy6aY4J4LEyJ/zvj563gU?=
 =?us-ascii?Q?Rm6pWFllSk3YM7+KwAOROHu/cShdiLDASFQX19ArG7jqnFtSWrNcdYMbQooA?=
 =?us-ascii?Q?H2nFe5cSWrTSlCtbTCJBJ4i6lJk=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90120368-38f2-429e-577b-08da5dbdbe9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:04:35.4440 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +JpoccJNEbym1JfK2bjkOmJYKyaU68I9rksg0eN4CDV24OLHbzDMrFLXpkE7gxZh6qrVdzCR0T213ff5GaKIRI/H+84pWShDzMtK2SwoMM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB5249
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 01/17] block: remove a superflous ifdef in
 blkdev.h
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 04.07.22 15:02, Christoph Hellwig wrote:
> On Mon, Jul 04, 2022 at 12:58:40PM +0000, Johannes Thumshirn wrote:
>>> -#ifdef CONFIG_BLK_DEV_ZONED
>>> -
>>>  /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
>>>  const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
>>>  
>>
>> Won't this break tracing in null_blk, which uses blk_zone_cond_str()?
> 
> How could removing an ifdef and exposing a prototype unconditionally
> in a header break tracing?
> 

*facepalm* the trace code doesn't get compiled without CONFIG_BLK_DEV_ZONED.
My bad.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

