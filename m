Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B51DC433ED
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 06:34:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CB9E461186
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 06:34:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB9E461186
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-vIGVEke_NfG_aKgzHijJmQ-1; Thu, 20 May 2021 02:34:17 -0400
X-MC-Unique: vIGVEke_NfG_aKgzHijJmQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E88C31009446;
	Thu, 20 May 2021 06:34:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B8EA46;
	Thu, 20 May 2021 06:34:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 247171800BB8;
	Thu, 20 May 2021 06:34:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K6QVsm017578 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 02:26:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2553D10F034; Thu, 20 May 2021 06:26:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D09210F031
	for <dm-devel@redhat.com>; Thu, 20 May 2021 06:26:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67479800182
	for <dm-devel@redhat.com>; Thu, 20 May 2021 06:26:24 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-311-eEJrGvI6OQCmzZ5TrZZQBw-1; Thu, 20 May 2021 02:26:22 -0400
X-MC-Unique: eEJrGvI6OQCmzZ5TrZZQBw-1
IronPort-SDR: 1Rktxno8og90cmWXgF3EeG5HOHQwq3T9dcPen6iLa9tDQQdwgSNAWF4hoaqNuljauvZJY8D9mx
	VxBlTlevbhVn1Dl9QK12BMDnAOozxIi/1KpwVAjK50uax3jgmNmS6gAbNOxyGuv5d8YU+f8uKZ
	AYgrgTEl94diBK+M2jORewJJbA2sKWA3WWpSh9v4FQQek1Zb3sa9wunGBOEEwezevDC6Kxnm39
	PL9EqAGFBGjbyAMYsJksPDdIndQtzy/0rr3In+H+eNraQvwAYh7samwKxoSIkTlrynf0DvncNP
	pMc=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="280054094"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
	by ob1.hgst.iphmx.com with ESMTP; 20 May 2021 14:25:17 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB6622.namprd04.prod.outlook.com (2603:10b6:5:20e::7) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25;
	Thu, 20 May 2021 06:25:16 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.033;
	Thu, 20 May 2021 06:25:16 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Hannes Reinecke <hare@suse.de>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH v2 10/11] dm: introduce zone append emulation
Thread-Index: AQHXTS/HzFxr6ld09EaK3LHUbCl8CQ==
Date: Thu, 20 May 2021 06:25:16 +0000
Message-ID: <DM6PR04MB7081B70FFD57914608B0349AE72A9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210520042228.974083-1-damien.lemoal@wdc.com>
	<20210520042228.974083-11-damien.lemoal@wdc.com>
	<68203e46-01bc-011c-ab8e-9c94ca60adce@suse.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:d5e8:c272:2ab7:c99a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd9889b5-e5be-407a-d858-08d91b58087f
x-ms-traffictypediagnostic: DM6PR04MB6622:
x-microsoft-antispam-prvs: <DM6PR04MB66229A62007958503B87AC95E72A9@DM6PR04MB6622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: +tAdES7IZGfXyjDY9ceH8FB1lExk/c4YxiT+5RPpd5ZjCTKC6djgEZP4Q0jehejImovsQ0rDQ4xVsT41BJgJ/RRQJmm13eALJ6/mGeBKoS1eOstL49ThlslWGTvIDdbSrAqK9DPGMAh+rgXhr5tVSctMLKArks9ioIhjZZsL87dbKQ4tOjIN4XvO4JvFv1lsOcH212jgfsivM0RP9uCPdCGxhcVrnyKi33QDIHucDAOhe6Ldbq+vO7BFoVYtGl/Y419TPTNT8h//tv+QL53WPEk28olBoj2tj+G/zS5ZkVPu+QU7XOPTGXd7sOFUrRCEYZpfjjhHu9dIdkYaMf3lYW15tDnYr9CPp0kJHywjHtDKDS32eVXy1DrWCGoJ/hyCpaFcIGFcSIDuXgTXj3/1+RGA26DBGvn/KRyIHVj6oTUNi+j2OMRiRISmGs5XOM/ngM4lmoayScMpdk+xCJKNm3+2ImB8vCq6sOenYmChZ4c5pnKKzslXJTuKwur260t3ETvxwZpSvZdXnbL5e+T9cXzE21zw75eRg+BhJSRf1TsXH5QfqJRgPcMxBl3cB3yMQHpm38oE2yaOFsKvJg47n8Z5Mn/nQE87MknwM0BrgkA=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(53546011)(6506007)(8936002)(122000001)(38100700002)(66476007)(66556008)(64756008)(478600001)(66446008)(8676002)(186003)(83380400001)(5660300002)(2906002)(7696005)(76116006)(66946007)(33656002)(110136005)(91956017)(86362001)(316002)(71200400001)(9686003)(52536014)(55016002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?BBhDpS2ALrl5v3r+7HcypraSTJjqLkleHCQeFAtK7zc5JTzWOmFBakv7451x?=
	=?us-ascii?Q?vtaQm2As4/+h+I3FJ8PWbBvxlWGcDLT9vV5dxwbnd1E1kafFlVNctpuj7m/b?=
	=?us-ascii?Q?FNkbfTY7KXVAMQerh+upENTmK07Lucoi/3fDXT1aKT+MHzHlLyurnokjwdSr?=
	=?us-ascii?Q?/eTkFg2Ar/Ton9J+e+fGsKk4dArQbSAYo1WcuaYefz2Ful4MhWEC7Z4V7wmq?=
	=?us-ascii?Q?/vDVOraUYQWyrkO2+Jo0N7QYExQwJ1zOyhlQbdJLasxH1zmeSO9vhI5aWYUG?=
	=?us-ascii?Q?BKf0u+RQiJN+l0P350I0nYpd0YvpAIRKawgNYEYMeAy2WzfWZr5Al1GPXT56?=
	=?us-ascii?Q?tbUhqg2l52qrxJkMrqYmcQNcBd0O625DMTUfKNSnCczuK87tAYKLd6pluGpA?=
	=?us-ascii?Q?3At89lPAl7QmO+WWXoV3HL5DhxS49/AajkrAbymXa3NY7iQSBNDGIOsY3HAY?=
	=?us-ascii?Q?9OFALJ9qCZAz+AWug6hXVDiUD2I0uMJs5jGQq63rjRpxae71L8OholHQKEqf?=
	=?us-ascii?Q?do2dIAPKjXKXLpUvfEvBuD6Gii/D+5cxHtDDqgbyNOLE9vbtMjJwh7+wt8yP?=
	=?us-ascii?Q?CXNcxgPJTSh7QlEqK7orehiDR7OA7q2fZWmiFjwtYHxqB1Jv7ZUBchOtrRjS?=
	=?us-ascii?Q?SWqgTkdFPDxIgibatz5DQ9hq4BJwjJS+n2U1vxwEQcRICMu66USBGjXlktSN?=
	=?us-ascii?Q?KfPtiyuCJW8MsF0eT0iOm7DF4M0hspg73Aryu/SDjj0T4d2yTDH/29dJ9vti?=
	=?us-ascii?Q?s70UVvjAP90e/m1VIXGC1zQBvf1olHEy6JdPOV/DSoTLV1U5qtmhQbDmKymv?=
	=?us-ascii?Q?I7Y5MZfEWYSRCXTi6eiaR7CFxYtTHAEMdlOAyZp2yGKvrntQlEIfR30WXpB+?=
	=?us-ascii?Q?pK7ptT3LPfrk2rjmL6aPDw4FHw9/Q+r7o+uzirRjQB0GHuIdnepnjlxsIJFg?=
	=?us-ascii?Q?CbDw+v8rVX9LVXlY58Te5G0KfA2sUg8dkxLcTN7o3w8USrdLs1Jd7o0Pubf7?=
	=?us-ascii?Q?2M0JyPbm4Nu5I/5q97AKzfoXr1WhpfsBxPKweUnw5+zsVDPD0jurXz7Wyy09?=
	=?us-ascii?Q?XrH35c0jNSIzXyXY+pkhafmMw4iN9kmbgdfMIQMGAOWqBgNYXw/IlCz37YXb?=
	=?us-ascii?Q?NdKCENRMcLg1aWYoP3g7D2PSVoOycf0FG6mI/kRVoGlgbF4jPG6gBO9Sdl/A?=
	=?us-ascii?Q?eVAXXq2yIRi5b+dik5vaNa9EVT8f+cF6Vq1w7z4k+rguPn69GKxePhLx3wOK?=
	=?us-ascii?Q?M0i44Dvl0KyFqXiT6X6x2mEbmSRO/FF4lH/M/w0Aqc9m2kfIsnjTtJNKj6bJ?=
	=?us-ascii?Q?8QBKtzvah4nySPUPY/mTcnoSpjCmKsFgj2DW675tMWhSy1TECZ3glpI2tve8?=
	=?us-ascii?Q?2UAYz+dFFqXuQrPv5UTS2rjTeq0t+RAF234FCRMN4uqOJuQ6Aw=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9889b5-e5be-407a-d858-08d91b58087f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 06:25:16.1775 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4J/XWjIiod9Z98o5EIWmood+/g8m5mKW29D0MGu5gdsnOt/F+PomYImZZC/DzRrL0TTZTcjk0oi+T+Q0wa4PHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6622
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14K6QVsm017578
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/05/20 15:10, Hannes Reinecke wrote:
[...]
>> +/*
>> + * First phase of BIO mapping for targets with zone append emulation:
>> + * check all BIO that change a zone writer pointer and change zone
>> + * append operations into regular write operations.
>> + */
>> +static bool dm_zone_map_bio_begin(struct mapped_device *md,
>> +				  struct bio *orig_bio, struct bio *clone)
>> +{
>> +	sector_t zone_sectors = blk_queue_zone_sectors(md->queue);
>> +	unsigned int zno = bio_zone_no(orig_bio);
>> +	unsigned long flags;
>> +	bool good_io = false;
>> +
>> +	spin_lock_irqsave(&md->zwp_offset_lock, flags);
>> +
>> +	/*
>> +	 * If the target zone is in an error state, recover by inspecting the
>> +	 * zone to get its current write pointer position. Note that since the
>> +	 * target zone is already locked, a BIO issuing context should never
>> +	 * see the zone write in the DM_ZONE_UPDATING_WP_OFST state.
>> +	 */
>> +	if (md->zwp_offset[zno] == DM_ZONE_INVALID_WP_OFST) {
>> +		unsigned int wp_offset;
>> +		int ret;
>> +
>> +		md->zwp_offset[zno] = DM_ZONE_UPDATING_WP_OFST;
>> +
>> +		spin_unlock_irqrestore(&md->zwp_offset_lock, flags);
>> +		ret = dm_update_zone_wp_offset(md, zno, &wp_offset);
>> +		spin_lock_irqsave(&md->zwp_offset_lock, flags);
>> +
>> +		if (ret) {
>> +			md->zwp_offset[zno] = DM_ZONE_INVALID_WP_OFST;
>> +			goto out;
>> +		}
>> +		md->zwp_offset[zno] = wp_offset;
>> +	} else if (md->zwp_offset[zno] == DM_ZONE_UPDATING_WP_OFST) {
>> +		DMWARN_LIMIT("Invalid DM_ZONE_UPDATING_WP_OFST state");
>> +		goto out;
>> +	}
>> +
>> +	switch (bio_op(orig_bio)) {
>> +	case REQ_OP_WRITE_ZEROES:
>> +	case REQ_OP_WRITE_SAME:
>> +	case REQ_OP_WRITE:
>> +		break;
>> +	case REQ_OP_ZONE_RESET:
>> +	case REQ_OP_ZONE_FINISH:
>> +		goto good;
>> +	case REQ_OP_ZONE_APPEND:
>> +		/*
>> +		 * Change zone append operations into a non-mergeable regular
>> +		 * writes directed at the current write pointer position of the
>> +		 * target zone.
>> +		 */
>> +		clone->bi_opf = REQ_OP_WRITE | REQ_NOMERGE |
>> +			(orig_bio->bi_opf & (~REQ_OP_MASK));
>> +		clone->bi_iter.bi_sector =
>> +			orig_bio->bi_iter.bi_sector + md->zwp_offset[zno];
>> +		break;
>> +	default:
>> +		DMWARN_LIMIT("Invalid BIO operation");
>> +		goto out;
>> +	}
>> +
>> +	/* Cannot write to a full zone */
>> +	if (md->zwp_offset[zno] >= zone_sectors)
>> +		goto out;
>> +
>> +	/* Writes must be aligned to the zone write pointer */
>> +	if ((clone->bi_iter.bi_sector & (zone_sectors - 1)) != md->zwp_offset[zno])
>> +		goto out;
>> +
>> +good:
>> +	good_io = true;
>> +
>> +out:
>> +	spin_unlock_irqrestore(&md->zwp_offset_lock, flags);
> 
> I'm not happy with the spinlock. Can't the same effect be achieved with 
> some clever READ_ONCE()/WRITE_ONCE/cmpexch magic?
> Especially as you have a separate 'zone lock' mechanism ...

hmmm... Let me see. Given that what the bio completion is relatively simple, it
may be possible. With more coffee, I amy be able to come up with something clever.

> 
>> +
>> +	return good_io;
>> +}
>> +
>> +/*
>> + * Second phase of BIO mapping for targets with zone append emulation:
>> + * update the zone write pointer offset array to account for the additional
>> + * data written to a zone. Note that at this point, the remapped clone BIO
>> + * may already have completed, so we do not touch it.
>> + */
>> +static blk_status_t dm_zone_map_bio_end(struct mapped_device *md,
>> +					struct bio *orig_bio,
>> +					unsigned int nr_sectors)
>> +{
>> +	unsigned int zno = bio_zone_no(orig_bio);
>> +	blk_status_t sts = BLK_STS_OK;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&md->zwp_offset_lock, flags);
>> +
>> +	/* Update the zone wp offset */
>> +	switch (bio_op(orig_bio)) {
>> +	case REQ_OP_ZONE_RESET:
>> +		md->zwp_offset[zno] = 0;
>> +		break;
>> +	case REQ_OP_ZONE_FINISH:
>> +		md->zwp_offset[zno] = blk_queue_zone_sectors(md->queue);
>> +		break;
>> +	case REQ_OP_WRITE_ZEROES:
>> +	case REQ_OP_WRITE_SAME:
>> +	case REQ_OP_WRITE:
>> +		md->zwp_offset[zno] += nr_sectors;
>> +		break;
>> +	case REQ_OP_ZONE_APPEND:
>> +		/*
>> +		 * Check that the target did not truncate the write operation
>> +		 * emulating a zone append.
>> +		 */
>> +		if (nr_sectors != bio_sectors(orig_bio)) {
>> +			DMWARN_LIMIT("Truncated write for zone append");
>> +			sts = BLK_STS_IOERR;
>> +			break;
>> +		}
>> +		md->zwp_offset[zno] += nr_sectors;
>> +		break;
>> +	default:
>> +		DMWARN_LIMIT("Invalid BIO operation");
>> +		sts = BLK_STS_IOERR;
>> +		break;
>> +	}
>> +
>> +	spin_unlock_irqrestore(&md->zwp_offset_lock, flags);
> 
> You don't need the spinlock here; using WRITE_ONCE() should be sufficient.

If other references to zwp_offset use READ_ONCE(), no ?

[...]
>> +void dm_zone_endio(struct dm_io *io, struct bio *clone)
>> +{
>> +	struct mapped_device *md = io->md;
>> +	struct request_queue *q = md->queue;
>> +	struct bio *orig_bio = io->orig_bio;
>> +	unsigned long flags;
>> +	unsigned int zno;
>> +
>> +	/*
>> +	 * For targets that do not emulate zone append, we only need to
>> +	 * handle native zone-append bios.
>> +	 */
>> +	if (!dm_emulate_zone_append(md)) {
>> +		/*
>> +		 * Get the offset within the zone of the written sector
>> +		 * and add that to the original bio sector position.
>> +		 */
>> +		if (clone->bi_status == BLK_STS_OK &&
>> +		    bio_op(clone) == REQ_OP_ZONE_APPEND) {
>> +			sector_t mask = (sector_t)blk_queue_zone_sectors(q) - 1;
>> +
>> +			orig_bio->bi_iter.bi_sector +=
>> +				clone->bi_iter.bi_sector & mask;
>> +		}
>> +
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * For targets that do emulate zone append, if the clone BIO does not
>> +	 * own the target zone write lock, we have nothing to do.
>> +	 */
>> +	if (!bio_flagged(clone, BIO_ZONE_WRITE_LOCKED))
>> +		return;
>> +
>> +	zno = bio_zone_no(orig_bio);
>> +
>> +	spin_lock_irqsave(&md->zwp_offset_lock, flags);
>> +	if (clone->bi_status != BLK_STS_OK) {
>> +		/*
>> +		 * BIOs that modify a zone write pointer may leave the zone
>> +		 * in an unknown state in case of failure (e.g. the write
>> +		 * pointer was only partially advanced). In this case, set
>> +		 * the target zone write pointer as invalid unless it is
>> +		 * already being updated.
>> +		 */
>> +		if (md->zwp_offset[zno] != DM_ZONE_UPDATING_WP_OFST)
>> +			md->zwp_offset[zno] = DM_ZONE_INVALID_WP_OFST;
>> +	} else if (bio_op(orig_bio) == REQ_OP_ZONE_APPEND) {
>> +		/*
>> +		 * Get the written sector for zone append operation that were
>> +		 * emulated using regular write operations.
>> +		 */
>> +		if (WARN_ON_ONCE(md->zwp_offset[zno] < bio_sectors(orig_bio)))
>> +			md->zwp_offset[zno] = DM_ZONE_INVALID_WP_OFST;
>> +		else
>> +			orig_bio->bi_iter.bi_sector +=
>> +				md->zwp_offset[zno] - bio_sectors(orig_bio);
>> +	}
>> +	spin_unlock_irqrestore(&md->zwp_offset_lock, flags);
>> +
> 
> Similar comments to the spinlock here.

OK.

Thanks for the review.


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

