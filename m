Return-Path: <SRS0=3FFM=KT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573E3C47080
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 00:30:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 945176117A
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 00:30:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 945176117A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-fxQQUADLMcuNkJRtffpPNw-1; Sun, 23 May 2021 20:30:50 -0400
X-MC-Unique: fxQQUADLMcuNkJRtffpPNw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B3B1107ACE4;
	Mon, 24 May 2021 00:30:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9ED5C51312;
	Mon, 24 May 2021 00:30:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 31A5755340;
	Mon, 24 May 2021 00:30:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14O0UZxn013657 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 23 May 2021 20:30:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A5199216FD4E; Mon, 24 May 2021 00:30:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E95C216780A
	for <dm-devel@redhat.com>; Mon, 24 May 2021 00:30:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 771A885828E
	for <dm-devel@redhat.com>; Mon, 24 May 2021 00:30:32 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-584--zcdun7GOHe3LcT6MyhrgA-1; Sun, 23 May 2021 20:30:29 -0400
X-MC-Unique: -zcdun7GOHe3LcT6MyhrgA-1
IronPort-SDR: j93Pi67IOKkdlXM0AdDfmSgSjycNgZ1N1/rkotQDbMM54HWsou1JhuVZTS1ZFUQeAG3IYhSYLJ
	UqViG8NA8bcOz8+HbV0AXlXMevWfJz6S935gcUZySYMTj/APk718vAKkzqasFmuG+dKwwilJ3B
	GRy//zzQLm5l9/cz5YSXmUJadpa4isAd3p74FZOKDkMX0GwstUEAMEDrEiJYn23hb4Fo5AAiUN
	FBq6/h3eGjh+ZVQzb6c/dqFbqknSiq9f4abqm8sgKvjBw1VoIOJU6swIaACy+oLFH+hRG0by6L
	/3s=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; d="scan'208";a="168496145"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO
	NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
	by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 08:30:27 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by SJ0PR04MB7680.namprd04.prod.outlook.com (2603:10b6:a03:324::21)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23;
	Mon, 24 May 2021 00:30:26 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4150.027;
	Mon, 24 May 2021 00:30:26 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH v3 01/11] block: improve handling of all zones reset
	operation
Thread-Index: AQHXTe2XQQmdlggDyka6lOSgElB11g==
Date: Mon, 24 May 2021 00:30:26 +0000
Message-ID: <BYAPR04MB49655F14C3C880B508D4B90886269@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210521030119.1209035-1-damien.lemoal@wdc.com>
	<20210521030119.1209035-2-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dedb1ccc-cfec-4a91-287e-08d91e4b2049
x-ms-traffictypediagnostic: SJ0PR04MB7680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR04MB7680547C08303927465B2DF686269@SJ0PR04MB7680.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: nvUbKFgik6q50c0nIf4/9yWlS7GcDWr+q3ZDgRu+uJnGKv2tNxU8IWITY8vGB4/Z0V1fpWuPlqZR05WNfclejOKizqEnJTtLmhcQahKp+Zu7o05Y35oXvbSoFN6pgBgIuxSYUb+WF7BgBX6xNTPwUlvv/u8gqWoGUWnyJMJa+hdiwQqbjsfOgkSUl2V4she0J3x6AOEDfquDj3vIpOl+adv+BjkjLXBOj8c8FvnxnBxIBKEVB9jWTozxcdQXCJSBQMLtlZoHiCQvPhpf9mDZ1bF1VcMYX0UvDnc3F22ErJIxLke60c2ClVNrgeZfTqtf2CBG4FhB0E3FDIzhouPQ0ZIvV5caccvpfBJnWvwqxOb65tI1vmLrmUQSr5PcVCGPUrGq9MIwAmWgUlZju2QRJ8qBuFGOHI/BmrSwPuY6whVZhK5r7LEprR6yWCPpwc+eKJJMhjSaWgiacU0xYd7cN9ZRJX5/E8Y4qXilYs+o01Exx1aRbwyv6Fhu/F9Ie5WWx+B7KmjEPQxODumMt1zgh4WT6nQpU+EMmjPOk2Lsg9a6EbJfsunp6H3tZcBX9c635AV2IMq/VrrhzDJywtUu2063s6e8cubXo5ls5wGzIrM=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(122000001)(38100700002)(76116006)(55016002)(52536014)(83380400001)(8936002)(26005)(8676002)(66446008)(66476007)(64756008)(9686003)(110136005)(53546011)(478600001)(71200400001)(86362001)(5660300002)(2906002)(66946007)(7696005)(6506007)(33656002)(316002)(66556008)(186003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+W6051WwPk9dHhhDMzenmeIOZ7gvY0wGV1CL5N1t8molyBWsK07s2NmaNb1F?=
	=?us-ascii?Q?cs0kPmcBs32ZJnn3wFIYhgwMIf+LLyDpwNLnHvmxJjmloQ+PvTO9XG0x50r8?=
	=?us-ascii?Q?YDmbZe7JDg76gzSefUuMdyCt7gdje4Uu1d7CyuwaW96KZnQvTDNfX7fUu9LC?=
	=?us-ascii?Q?IwEkTReoEP596SIdM4yalFzkjREKqAoQqKYkaUhTUBBBLpogMMCK4GhYTAtK?=
	=?us-ascii?Q?RJqyd4ErT732//scSTrpXTZWQ47zb10/as40ORDAnWxnw/IFnzksfD6DIJKU?=
	=?us-ascii?Q?Yl/5yvmPmDmYEUrLddp7NtyoEgjBkKtL5RWUMTNXrTSOuMxCEjpQBa3/0Gb1?=
	=?us-ascii?Q?OCoE39BcsYSTOlel4Sr6SZgBkoIvIdYCkAwvE8LwfCrSl//Y61XlpHcuQs1S?=
	=?us-ascii?Q?457mUGiFstIhTEmFklkECWbnmVJq6Dz/+kppniNnd0vPMQybPwa3c8BgnYS5?=
	=?us-ascii?Q?7rADf9Rb691tssFqMB99QYztFDeI/jbB1Go/c4xLwLg4uzD5WS77FJNkMVBl?=
	=?us-ascii?Q?NPh24gIvjmct2CjYI7SkNJilykydyQ+FriSEOZQuYzqN+MKC+yxPZafP29L1?=
	=?us-ascii?Q?5y6cUIC+rhcfRD1/H9Xr1ak1JYUrYxhdeT6BAfFz8obZx90zhzMCrGOm8W41?=
	=?us-ascii?Q?TlYf1YL360C3uPP17viyi5U9V7VR96hUwaYxbNACgR6dmb4GviVRNYc4Vq1w?=
	=?us-ascii?Q?vntWrqPjw0cemQAlQ8r81aius+yPVSitJbG4tfGtd8aQ3V4AH/oZmKPfEI4U?=
	=?us-ascii?Q?MEH+aQqoReIHNW4FCl6NTLmuZG88jP71XLLyWTq8q/RyToODYQCpcavPtyBt?=
	=?us-ascii?Q?W/XUSfnlnrS+XACkn5tXbQR7LD10UQYY6fzoeSqdjj8rG+iv7/vwTNckWuID?=
	=?us-ascii?Q?XJr1sxbNz7g0bJbe2sPUfVWyZOxtHmoYBdSMgIIGYY5YywxubO9kc9kJMjmF?=
	=?us-ascii?Q?SrucKNHhnnfwMAbssJcx/Fszgql4qirqB6qAV7L0SrToFfZC9dXNwNp1vXAJ?=
	=?us-ascii?Q?ZsAt6xNwEFfTTktQyGPfiNSsIJ8JHFM6qLsbUSz9Z1XG9knF57gDwYJ63Hc7?=
	=?us-ascii?Q?kv6gfnhTlRwihyVXZE+relXk942N8JvhVU+S7H2mvq2rISkoTmUMRTwkNeFe?=
	=?us-ascii?Q?8sJaQZNbbTDB9MIxhvfHkb094RCyh5tHsoRIKCtEGrqTOLfID3IjKm92mDFR?=
	=?us-ascii?Q?NmlmLlA5Ms7w44nm9ERJzDJkkIQcYY7h/LmqBE58LjfJBFwCyZFmX2pwv+mU?=
	=?us-ascii?Q?p3BpJeDVerEYWCd7HwmVi/k2tH3bY1k5dSZIN5ikxm90XbLazHeK0tIzPn5i?=
	=?us-ascii?Q?SZ7tHHcWPRZny2ToGUBHX7HI?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dedb1ccc-cfec-4a91-287e-08d91e4b2049
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2021 00:30:26.0892 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lI2VBMHOHaQCTcIwj3HIWggefu4+KTx7o3WePhQPxQVD1KX0LsuvvwVekYIUADQW6uYD1tLHCaJCzfnHrt4RLd9QT/WoNO3UNxggJGLC9mE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7680
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14O0UZxn013657
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 01/11] block: improve handling of all
 zones reset operation
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/20/21 20:01, Damien Le Moal wrote:
> +static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
> +					  gfp_t gfp_mask)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +	sector_t capacity = get_capacity(bdev->bd_disk);
> +	sector_t zone_sectors = blk_queue_zone_sectors(q);
> +	unsigned long *need_reset;
> +	struct bio *bio = NULL;
> +	sector_t sector;
> +	int ret;
> +
> +	need_reset = blk_alloc_zone_bitmap(q->node, q->nr_zones);
> +	if (!need_reset)
> +		return -ENOMEM;
> +
> +	ret = bdev->bd_disk->fops->report_zones(bdev->bd_disk, 0,
> +				q->nr_zones, blk_zone_need_reset_cb,
> +				need_reset);
> +	if (ret < 0)
> +		goto out_free_need_reset;
> +
> +	ret = 0;
> +	while (sector < capacity) {

Garbage value of sector variable used in above comparison ?
If so consider initializing at the time of declaration.

> +		if (!test_bit(blk_queue_zone_no(q, sector), need_reset)) {
> +			sector += zone_sectors;
> +			continue;
> +		}
> +		bio = blk_next_bio(bio, 0, gfp_mask);
> +		bio_set_dev(bio, bdev);
> +		bio->bi_opf = REQ_OP_ZONE_RESET | REQ_SYNC;
> +		bio->bi_iter.bi_sector = sector;
> +		sector += zone_sectors;
> +
> +		/* This may take a while, so be nice to others */
> +		cond_resched();
> +	}
> +
> +	if (bio) {
> +		ret = submit_bio_wait(bio);
> +		bio_put(bio);
> +	}
> +
> +out_free_need_reset:
> +	kfree(need_reset);
> +	return ret;
> +}




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

