Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A0CFC433ED
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 07:07:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 620DD61279
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 07:07:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 620DD61279
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-ZZniyGk5Nf6vHfD5fM9P3Q-1; Thu, 20 May 2021 03:07:30 -0400
X-MC-Unique: ZZniyGk5Nf6vHfD5fM9P3Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFDB2107ACCD;
	Thu, 20 May 2021 07:07:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 133D069102;
	Thu, 20 May 2021 07:07:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 64BD855353;
	Thu, 20 May 2021 07:07:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K6vN30021237 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 02:57:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 93CCD10F036; Thu, 20 May 2021 06:57:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C96110F034
	for <dm-devel@redhat.com>; Thu, 20 May 2021 06:57:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4F97185A79C
	for <dm-devel@redhat.com>; Thu, 20 May 2021 06:57:19 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-542-XRNLYEfGP-SfMYHeA8Js9Q-1; Thu, 20 May 2021 02:57:15 -0400
X-MC-Unique: XRNLYEfGP-SfMYHeA8Js9Q-1
IronPort-SDR: EOqP2ITmTr3dYklgrBhocwz4ph9m0MVkmeB1fFz5DSSRGBDKAwMyiXJAyZmFp4E76I3t7Yqug9
	K90vT2IWi7x1ncWKCJHDdSnFkrs3uCHX8KvPMcAdQZHHz2+uAz0cGMPwPTTyXctbuZHfLSJeq5
	wzNGvnP9dNSxlX0lmfJQcsNFnYG62sepQu4K3fcmPwU0BXiOa7dh0pTlcm/05XcRx1TjJIneBs
	Kq3F7xaRSNytnL1gv6u2NdkzLSMMOf0EKueVdMo6I01SLyq4z7DmplIKf0Mo6gTO7sFKdfoFr1
	Aa8=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="168811000"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO
	NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
	by ob1.hgst.iphmx.com with ESMTP; 20 May 2021 14:57:13 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB5884.namprd04.prod.outlook.com (2603:10b6:5:163::13) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Thu, 20 May 2021 06:57:12 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.033;
	Thu, 20 May 2021 06:57:12 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Hannes Reinecke <hare@suse.de>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH v2 10/11] dm: introduce zone append emulation
Thread-Index: AQHXTS/HzFxr6ld09EaK3LHUbCl8CQ==
Date: Thu, 20 May 2021 06:57:12 +0000
Message-ID: <DM6PR04MB7081B0CE6B5CCAA7B11CB434E72A9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210520042228.974083-1-damien.lemoal@wdc.com>
	<20210520042228.974083-11-damien.lemoal@wdc.com>
	<68203e46-01bc-011c-ab8e-9c94ca60adce@suse.de>
	<DM6PR04MB7081B70FFD57914608B0349AE72A9@DM6PR04MB7081.namprd04.prod.outlook.com>
	<be8be72c-0272-2969-ec46-ebb01db9d2ca@suse.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:d5e8:c272:2ab7:c99a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7450ac4-26d8-4f55-bcfc-08d91b5c7ede
x-ms-traffictypediagnostic: DM6PR04MB5884:
x-microsoft-antispam-prvs: <DM6PR04MB5884AF59A5AD6D71CD97E606E72A9@DM6PR04MB5884.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: BfUrxYcYq9Dij/3TG0JywGwCVq9s1LTeZNa0X31US0TlI6BpGye+LABdw5OHsLW93Vz9FLjd236bmoVG8GwJu0skbnGmPG1Q+a2GTTPxv9l7OgliHKRgq0nLUlHkWaVikpfSebH7C59oDe0uS5/kZmAiox3kkVEmfRMJmINHwvBSu07LAqdmRLxG4Tqmf+lKmBQa1afy3VqY3mL0Aa8fL7LjDhawtzEH1jEWnl7oUEk5kucKSuk+dh0XHSh3LrwZVNS9gFi/l5udend0IIcmJR3WxzfAap/hd4urvxMcyUecDmBdIrZNJw89xvIA/X9YI5cEI2L2ozUVrGBTG7LAcHPkPlLT7Zm0I7mVQKYbtS6Eq9BZ7TnkowPGv2dNFfmW4P2WOeB3OuYuPjs0lABz2XW2sFR2vYg3rlULYerpCksEc6qlPDIPsE1bimcJnR9eh0rOD68KLZwSJALLGx1mjnNtwU5iy7Kr5NwFZ0FKRG9hXpSa5k6pyEK2pc1Oj7qTYPZOWylEc1PSXE8V3txXHzmAiq02qTGCkY/wAxim3EQn2nasWh3zvmYFjRmn9sa2zfNeOOIG04Cj5Ws9HcIQD+2udmdaKMtj9T7RpSwaLZI=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(5660300002)(2906002)(110136005)(316002)(91956017)(86362001)(83380400001)(33656002)(53546011)(6506007)(71200400001)(38100700002)(9686003)(7696005)(52536014)(122000001)(66476007)(186003)(76116006)(8936002)(55016002)(66946007)(8676002)(66446008)(64756008)(66556008)(478600001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bMTHETSK5XdRreWHNCxtUxQ/EiJTe1aNg2uzZW0o5OmezWyVPkXoZ8VpBJwX?=
	=?us-ascii?Q?lHEpiAg7DTzQgvV0jaK5aM+wzDknrK5Pe9i5FVXx0JeR/om0ogyZ1IRtqHde?=
	=?us-ascii?Q?uDbuiFP2XXFqeOTAQJy1Yxjueq5iJEgZDaoS6y7R35/egQYTZeM3ct+aD4Vj?=
	=?us-ascii?Q?7p9iF5Z81bdkqp8VJOhXavyJ4r/LsZ2uTqvucW1OBuCwPdT0D3fbYbcZlxqf?=
	=?us-ascii?Q?RRkadQyesLgC1S/OpVWTHiAMv9IkanQeWqWhl5GBb3LRFpghrWtmba5kQHkq?=
	=?us-ascii?Q?jYh7xRGzs0fhischZSY0V58ObQFNoGd/OoTczFLeHwnEK8c5c38encY0h0NP?=
	=?us-ascii?Q?G5GE3a/A8YECuDcJOuyet52lpl3686J7Bcup9NRTgGTD6HsPNDeJG+n2th4i?=
	=?us-ascii?Q?vbGZ8n7SboL+bOMT1cSLqgbGHq7Yfyk//SIRQnhULZjEuA+P02fgU2eBM16G?=
	=?us-ascii?Q?tN+d3e8JSdBaZMQJhlmSt5Sbg9qi54wx8muq3f18o69j0FpKOMoesc9Kccrk?=
	=?us-ascii?Q?TAnpFTDL6MOSAbWGxzFXl3LwcHI6z2cbF5YqhLSAzTaLTht5xZ283T3e8aod?=
	=?us-ascii?Q?I6SQGfKweAqt05XJP120C3L2Ege3R3fZ4GrZBJcO78nEwC1Qpg7bkpstl+AH?=
	=?us-ascii?Q?bp4FH/X3RyUHaauMr2p1hpf9gkUUGkInm0DLzPqB89t2sfe+cior9BMBbF3L?=
	=?us-ascii?Q?FJM5Z0yXt42umC4vDqcPTw+zN+Tle3jxw+dB9eR+/h4Hi23SQjf53P/kDg1y?=
	=?us-ascii?Q?aEoiZVAmoya9TwlcQu3LiAYuhqSR69t7dDYZfDSqiM5shVVaZzq4oGy+y9NO?=
	=?us-ascii?Q?RcyiNq7Qo8yqFtXNAGUbR//6ALMDJziEcxFL4Uw7ek+5w1WoUZzzhcmfvHsR?=
	=?us-ascii?Q?m69CbEy7kWkIJPLYNMoyYlPCNTlzd32Ojb2dAT3n9OKBP6bhZuBDXJwL/0kg?=
	=?us-ascii?Q?2ft8WdBdnZlAEiy+KilbwAx9x92CFCvSSWQKat2zl1D0iYEnSfIbz4hlsVHw?=
	=?us-ascii?Q?5wjsqGTVAaFhwDDWcq5HyrYwKZDg3yacQeWlSX+DiRc9HRC+TfResCNIZQcY?=
	=?us-ascii?Q?08jJof7jPp2vQXSHz8e7IJSlZ5quoBhLu+3Jpzz6l23VM6g5VVGbjWsS6QOj?=
	=?us-ascii?Q?7TPWGagqPvmwncxwcHTECqNzr9wQsAl4//QJMZlJIegk4HpFBYOL9MNw4B+d?=
	=?us-ascii?Q?DsHeL3afzK51o4PwqoT97pzKxJdd4dbI7sBn+a+svNsFwHwmoTFIaQMcgTdo?=
	=?us-ascii?Q?X9HJ7ntcylWspyYJP6yo/iczj92onoaO7PMWQwgn22Hl/LO012ajavdIxc2l?=
	=?us-ascii?Q?qpRyqEEJvgnvRapaE1mEYl32+EpkafzZ7UoyhoiJCxVs+nDBZw5zOFMDAdSc?=
	=?us-ascii?Q?z4xYE1ZRhXjic2+hj3JUqp5UToOO4P/zLCDvPBh+XCHxoIjhSQ=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7450ac4-26d8-4f55-bcfc-08d91b5c7ede
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 06:57:12.8013 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T5acpR1qHVXw3vBdf47MHeVY/DQDEPPRLOx+zpS/dyQN40CUbhEp9fBJAeCRPLTVHB2ervVOk6z0phwSkcI/tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5884
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14K6vN30021237
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 10/11] dm: introduce zone append emulation
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/05/20 15:47, Hannes Reinecke wrote:
> On 5/20/21 8:25 AM, Damien Le Moal wrote:
>> On 2021/05/20 15:10, Hannes Reinecke wrote:
>> [...]
>>>> +/*
>>>> + * First phase of BIO mapping for targets with zone append emulation:
>>>> + * check all BIO that change a zone writer pointer and change zone
>>>> + * append operations into regular write operations.
>>>> + */
>>>> +static bool dm_zone_map_bio_begin(struct mapped_device *md,
>>>> +				  struct bio *orig_bio, struct bio *clone)
>>>> +{
>>>> +	sector_t zone_sectors = blk_queue_zone_sectors(md->queue);
>>>> +	unsigned int zno = bio_zone_no(orig_bio);
>>>> +	unsigned long flags;
>>>> +	bool good_io = false;
>>>> +
>>>> +	spin_lock_irqsave(&md->zwp_offset_lock, flags);
>>>> +
>>>> +	/*
>>>> +	 * If the target zone is in an error state, recover by inspecting the
>>>> +	 * zone to get its current write pointer position. Note that since the
>>>> +	 * target zone is already locked, a BIO issuing context should never
>>>> +	 * see the zone write in the DM_ZONE_UPDATING_WP_OFST state.
>>>> +	 */
>>>> +	if (md->zwp_offset[zno] == DM_ZONE_INVALID_WP_OFST) {
>>>> +		unsigned int wp_offset;
>>>> +		int ret;
>>>> +
>>>> +		md->zwp_offset[zno] = DM_ZONE_UPDATING_WP_OFST;
>>>> +
>>>> +		spin_unlock_irqrestore(&md->zwp_offset_lock, flags);
>>>> +		ret = dm_update_zone_wp_offset(md, zno, &wp_offset);
>>>> +		spin_lock_irqsave(&md->zwp_offset_lock, flags);
>>>> +
>>>> +		if (ret) {
>>>> +			md->zwp_offset[zno] = DM_ZONE_INVALID_WP_OFST;
>>>> +			goto out;
>>>> +		}
>>>> +		md->zwp_offset[zno] = wp_offset;
>>>> +	} else if (md->zwp_offset[zno] == DM_ZONE_UPDATING_WP_OFST) {
>>>> +		DMWARN_LIMIT("Invalid DM_ZONE_UPDATING_WP_OFST state");
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	switch (bio_op(orig_bio)) {
>>>> +	case REQ_OP_WRITE_ZEROES:
>>>> +	case REQ_OP_WRITE_SAME:
>>>> +	case REQ_OP_WRITE:
>>>> +		break;
>>>> +	case REQ_OP_ZONE_RESET:
>>>> +	case REQ_OP_ZONE_FINISH:
>>>> +		goto good;
>>>> +	case REQ_OP_ZONE_APPEND:
>>>> +		/*
>>>> +		 * Change zone append operations into a non-mergeable regular
>>>> +		 * writes directed at the current write pointer position of the
>>>> +		 * target zone.
>>>> +		 */
>>>> +		clone->bi_opf = REQ_OP_WRITE | REQ_NOMERGE |
>>>> +			(orig_bio->bi_opf & (~REQ_OP_MASK));
>>>> +		clone->bi_iter.bi_sector =
>>>> +			orig_bio->bi_iter.bi_sector + md->zwp_offset[zno];
>>>> +		break;
>>>> +	default:
>>>> +		DMWARN_LIMIT("Invalid BIO operation");
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	/* Cannot write to a full zone */
>>>> +	if (md->zwp_offset[zno] >= zone_sectors)
>>>> +		goto out;
>>>> +
>>>> +	/* Writes must be aligned to the zone write pointer */
>>>> +	if ((clone->bi_iter.bi_sector & (zone_sectors - 1)) != md->zwp_offset[zno])
>>>> +		goto out;
>>>> +
>>>> +good:
>>>> +	good_io = true;
>>>> +
>>>> +out:
>>>> +	spin_unlock_irqrestore(&md->zwp_offset_lock, flags);
>>>
>>> I'm not happy with the spinlock. Can't the same effect be achieved with
>>> some clever READ_ONCE()/WRITE_ONCE/cmpexch magic?
>>> Especially as you have a separate 'zone lock' mechanism ...
>>
>> hmmm... Let me see. Given that what the bio completion is relatively simple, it
>> may be possible. With more coffee, I amy be able to come up with something clever.
>>
> More coffee is always a good idea :-)
> I would look at killing the intermediate state UPDATING_WP_OFST and only 
> update the pointer on endio (or if it failed).
> That way we would need to update the pointer only once if we have a 
> final state, and don't need to do the double update you are doing now.

Good point. That should work. Definitely more coffee needed :)

> 
>>>
>>>> +
>>>> +	return good_io;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Second phase of BIO mapping for targets with zone append emulation:
>>>> + * update the zone write pointer offset array to account for the additional
>>>> + * data written to a zone. Note that at this point, the remapped clone BIO
>>>> + * may already have completed, so we do not touch it.
>>>> + */
>>>> +static blk_status_t dm_zone_map_bio_end(struct mapped_device *md,
>>>> +					struct bio *orig_bio,
>>>> +					unsigned int nr_sectors)
>>>> +{
>>>> +	unsigned int zno = bio_zone_no(orig_bio);
>>>> +	blk_status_t sts = BLK_STS_OK;
>>>> +	unsigned long flags;
>>>> +
>>>> +	spin_lock_irqsave(&md->zwp_offset_lock, flags);
>>>> +
>>>> +	/* Update the zone wp offset */
>>>> +	switch (bio_op(orig_bio)) {
>>>> +	case REQ_OP_ZONE_RESET:
>>>> +		md->zwp_offset[zno] = 0;
>>>> +		break;
>>>> +	case REQ_OP_ZONE_FINISH:
>>>> +		md->zwp_offset[zno] = blk_queue_zone_sectors(md->queue);
>>>> +		break;
>>>> +	case REQ_OP_WRITE_ZEROES:
>>>> +	case REQ_OP_WRITE_SAME:
>>>> +	case REQ_OP_WRITE:
>>>> +		md->zwp_offset[zno] += nr_sectors;
>>>> +		break;
>>>> +	case REQ_OP_ZONE_APPEND:
>>>> +		/*
>>>> +		 * Check that the target did not truncate the write operation
>>>> +		 * emulating a zone append.
>>>> +		 */
>>>> +		if (nr_sectors != bio_sectors(orig_bio)) {
>>>> +			DMWARN_LIMIT("Truncated write for zone append");
>>>> +			sts = BLK_STS_IOERR;
>>>> +			break;
>>>> +		}
>>>> +		md->zwp_offset[zno] += nr_sectors;
>>>> +		break;
>>>> +	default:
>>>> +		DMWARN_LIMIT("Invalid BIO operation");
>>>> +		sts = BLK_STS_IOERR;
>>>> +		break;
>>>> +	}
>>>> +
>>>> +	spin_unlock_irqrestore(&md->zwp_offset_lock, flags);
>>>
>>> You don't need the spinlock here; using WRITE_ONCE() should be sufficient.
>>
>> If other references to zwp_offset use READ_ONCE(), no ?
>>
> Why, but of course.
> If you touch one you have to touch all :-)
> 
> Cheers,
> 
> Hannes
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

