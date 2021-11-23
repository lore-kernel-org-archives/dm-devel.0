Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D5A2C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 11:40:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-CgfV5RJSPm6SKHznftS57g-1; Tue, 23 Nov 2021 06:40:32 -0500
X-MC-Unique: CgfV5RJSPm6SKHznftS57g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C12828799EB;
	Tue, 23 Nov 2021 11:40:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 888FA19730;
	Tue, 23 Nov 2021 11:40:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A22044EA37;
	Tue, 23 Nov 2021 11:40:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANBeOaA017769 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 06:40:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 57FC52026D69; Tue, 23 Nov 2021 11:40:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 51D282026D67
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 11:40:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C0CD181E06A
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 11:40:19 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-447-ysU0k-INPr-6OemH6o73xQ-1; Tue, 23 Nov 2021 06:40:17 -0500
X-MC-Unique: ysU0k-INPr-6OemH6o73xQ-1
X-IronPort-AV: E=Sophos;i="5.87,257,1631548800"; d="scan'208";a="290347587"
Received: from mail-bn8nam08lp2041.outbound.protection.outlook.com (HELO
	NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.41])
	by ob1.hgst.iphmx.com with ESMTP; 23 Nov 2021 19:39:13 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7269.namprd04.prod.outlook.com (2603:10b6:510:1c::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22;
	Tue, 23 Nov 2021 11:39:11 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::3418:fa40:16a4:6e0c]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::3418:fa40:16a4:6e0c%4]) with mapi id 15.20.4713.026;
	Tue, 23 Nov 2021 11:39:11 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, "hch@infradead.org" <hch@infradead.org>
Thread-Topic: Any bio_clone_slow() implementation which doesn't share
	bi_io_vec?
Thread-Index: AQHX4DWb7uOWhTA3AU6HTXic8besFg==
Date: Tue, 23 Nov 2021 11:39:11 +0000
Message-ID: <PH0PR04MB74169757F9CF740289B790C49B609@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <5d8351f1-1b09-bff0-02f2-a417c1669607@gmx.com>
	<YZybvlheyLGAadFF@infradead.org>
	<79d38fc2-cd2f-2980-2c4e-408078ce6079@gmx.com>
	<YZyiuFxAeKE/WMrR@infradead.org>
	<cca20bcb-1674-f99d-d504-b7fc928e227a@gmx.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9238427-5fe0-4d6a-3ee4-08d9ae75de75
x-ms-traffictypediagnostic: PH0PR04MB7269:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <PH0PR04MB7269A31A836B201A0FAB4FA49B609@PH0PR04MB7269.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: vb+bLAFUQVz46qAhkrPg22QNuXGL7vm9JIwRKOgKuevmJSLLFEJ1UzSxc/jF39EXzZb38sLMuUahLW741L42u1uqp2v2kWP2dULr6fGKb3LHq6CJNRTcGP7XUM4BtarCT61RE4BdalvWunWDke5os1jDmErtb0KQRZPdsgnRQKnuiyZOjvIeJrEhnsruBjIVlv2RtaYzXahK/0ZfjtUJaIO8aTKkEE6i2W4sxN2pkINW+EJs3gu8KpM682KB7CGVPMb4vp3cV1LrMN5o4lIrrLDQ10d5NdCPi6/JHeM8+6MU+ytTWW0CBZuGNWfTPG5dxEhcqhI6LTaFGkQPc8YbZmBo19OF/PGXTvjw6SMqK/v0Cc1JqLqPebJvStYtnBbpjMx39BfPleeGLqok7fxHAFSPHFMeinUhotfNTSl8zXgYa7eRaCqzWkXAM05QxELg8wKcmQnexuLyMlLrlYn8yJ/GUjwixQtBFvUt8L7lY8u2eXEoCzzkhYk13OQLDuvXFhokg8Niq+LXwKe8kNRZZKq8huZ337mR9H3tI+wY3ll0eiYqIcXNEV8BrufPJOu/p/xXnEczYl2KYgwYUyJt6taFVWjImNcpUj8Ps2XShFtpNZzAg/GAjsh4D4YpOKyVEUcJ3TCzYdBLharMlpu6dlnWQASbDKCRue1s7feJYRCHT5H9XTjv0frtXvaaUblpFk8+Qhvndczodn+UryHPxQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(55016003)(26005)(53546011)(86362001)(6506007)(52536014)(38100700002)(38070700005)(2906002)(186003)(122000001)(5660300002)(4326008)(83380400001)(82960400001)(508600001)(54906003)(8676002)(316002)(9686003)(110136005)(76116006)(91956017)(7696005)(33656002)(64756008)(66446008)(66946007)(66556008)(71200400001)(66476007)(8936002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?85jhfB7nnSNHPVW7+ZRdyK78XP3SEumdGjMHRSKDrxOZ2i0rYcbJUayGoYMu?=
	=?us-ascii?Q?4LYWLgEwrcCx1b4qqxt1xihrkKJZ2RoMeO3qSzghi5VA5Lav/3p/xLbAp9Tn?=
	=?us-ascii?Q?stTgh2LVWk5JEfuDDtsWQcdce36sULusXQIW3ReCRvtITN5dp3W1nyW0AvIp?=
	=?us-ascii?Q?gyFRnWA9xi6DR6O58+AaIL1X5y69HPqc40PgPO0oiE0eaWz4GEB2KpUTmUTc?=
	=?us-ascii?Q?yspC/PEndpjRtrqRFMgXmLbqmSkT6iwIviu1U8NOwx5WXXuw012Zhl9NPpkd?=
	=?us-ascii?Q?+NvGa75iUb36TERO6OCkWgL/w/WzoIE1eTH+t8xSoJ1CBXuDutbNN0O7hPvV?=
	=?us-ascii?Q?tO02pKTn9LkuUZc0xxSR65EXHoEnop+FYTjii2MyspqnVXYSvrHifaBrV1Zq?=
	=?us-ascii?Q?0gTtxbFTNQsieEQK7OGy3o/kDbuVbYhvvnNYYbrG7ETQnws43ZcRtxT2SLCH?=
	=?us-ascii?Q?ups76JQiiIoGdbRa5eOhtSAhgCkcS6srR5dGDjf+cXME08yUL2StJhLer4OR?=
	=?us-ascii?Q?Gnw4QkyYSxgBM4X5BWrf0VpLTKbT2aWowDIL8FRdYcZX/jUjCrtPAfo4or1d?=
	=?us-ascii?Q?CA/PXWLfJcVmX4HHh3+dUJ2ON/vEq++EjlJa7OlgHIG3HpVOiBLaFk7lMIaN?=
	=?us-ascii?Q?4CqkOgZouZ0wPcDFpjAq/AI1FGmBezudYoegU7xm7l9hRjR8SNUFzkS3lk9H?=
	=?us-ascii?Q?oG6tCzGMgVtuvL/a387+HP1LVKIbZqC53cMH34YSQ1gONk72BWPfQcdZxcRL?=
	=?us-ascii?Q?wyPeOOov3C3D4R9n3jeofpOmdn1LL6OdpWlsmz8AYHlksAVuWjfn336ad95M?=
	=?us-ascii?Q?Re7t5yfcR5iv4bZ02KwrdF3KWahgjEbK7dBkUkmBp3QMrOs30IA1oJDEN0cI?=
	=?us-ascii?Q?VXsF/7nvmP8FNT8W1p/boO59kwqUISj56/XOLbCaBjmE0lhh1TN42nlDpnrt?=
	=?us-ascii?Q?+Ib4Kmlch2M3V5DU+MJTL7sk2AnXxGQ8+u555e1QqepBjkDyF1su9C4F2llP?=
	=?us-ascii?Q?R4Y20SKQikFXz4Nq2gKZKU5n98aZQb1gytYICzoiiESq4Ix2uRIubWsnELab?=
	=?us-ascii?Q?GZylsKVdNY3YAz/ud8DQbXumj0YDeMnPP6lg5utpAo02hooDfaUHVBwaNJlU?=
	=?us-ascii?Q?BBE6HaW5rl+lSuHkADHCbtvWiXc/JlvBD9yMRuXSDvWgm7QQj6LV6jRCiZkv?=
	=?us-ascii?Q?9r3tr/6BRcDLxxwbkFPDrBeGCNnm/JA65tN/RnppnqIrtLXpYlFb7cFoNPZM?=
	=?us-ascii?Q?o36GMnTiVvjGiOdAt+b9CiUERNq+4jPjOHZUmLWOeZQr2Tdfa7vgsXX4M9gn?=
	=?us-ascii?Q?9TQTqj61hsRSaFDnOjHYMaQujq+ifQjLqcODm1Vw1XPua6UL8IlJqNJfBPnt?=
	=?us-ascii?Q?+kVRu2ev8Ph5DMnlK3j96UJVorFvVgcrCT4paRFBLTS1Y3NGlJnJCy8w8OIf?=
	=?us-ascii?Q?xhkJA8ZIVppHQ2V7cEXLwbNY74phdYIt0MaWhFKFr+yZc3BOlXDZ8zemdauv?=
	=?us-ascii?Q?QPG+fySgYvXhknfcKaKevZLekRrrceyEJu2qMXkivfz9v45I7KNmuKqmlAcX?=
	=?us-ascii?Q?RQ9iyFF3GZrczZA46RRKOfSRkVFz0xfZ0sLKQpcRiCTdg/nS4Co49CKNDdWK?=
	=?us-ascii?Q?w7DsWkoYck0QAHfnYQpMD0AD9Tr18GITn2ruTjk5eDbYKyTU1OzEPrKRR8Sc?=
	=?us-ascii?Q?4yDOYUV0MsEOgBUkNtn6HYIU56M=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9238427-5fe0-4d6a-3ee4-08d9ae75de75
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 11:39:11.4276 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DEAvvAbabcGd45NM8ISwvxKT+gPxQrVVGt/EvQARxCvbGHB9hy8DjknJJ05hyQcKAZQyWN/q/lCEVyr1RMKCb2h8uIo6lyDtf0YadW/AeGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7269
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ANBeOaA017769
X-loop: dm-devel@redhat.com
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] Any bio_clone_slow() implementation which doesn't
 share bi_io_vec?
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

On 23/11/2021 12:09, Qu Wenruo wrote:
> 
> 
> On 2021/11/23 16:13, Christoph Hellwig wrote:
>> On Tue, Nov 23, 2021 at 04:10:35PM +0800, Qu Wenruo wrote:
>>> Without bio_chain() sounds pretty good, as we can still utilize
>>> bi_end_io and bi_private.
>>>
>>> But this also means, we're now responsible not to release the source bio
>>> since it has the real bi_io_vec.
>>
>> Just call bio_inc_remaining before submitting the cloned bio, and then
>> call bio_endio on the root bio every time a clone completes.
>>
> Yeah, that sounds pretty good for regular usage.
> 
> But there is another very tricky case involved.
> 
> For btrfs, it supports zoned device, thus we have special calls sites to
> switch between bio_add_page() and bio_add_zoned_append_page().
> 
> But zoned write can't not be split, nor there is an easy way to directly
> convert a regular bio into a bio with zoned append pages.
> 
> Currently if we go the slow path, by allocating a new bio, then add
> pages from original bio, and advance the original bio, we're able to do
> the conversion from regular bio to zoned append bio.
> 
> Any idea on this corner case?

I think we have to differentiate two cases here:
A "regular" REQ_OP_ZONE_APPEND bio and a RAID stripe REQ_OP_ZONE_APPEND
bio. The 1st one (i.e. the regular REQ_OP_ZONE_APPEND bio) can't be split
because we cannot guarantee the order the device writes the data to disk. 
For the RAID stripe bio we can split it into the two (or more) parts that
will end up on _different_ devices. All we need to do is a) ensure it 
doesn't cross the device's zone append limit and b) clamp all 
bi_iter.bi_sector down to the start of the target zone, a.k.a sticking to
the rules of REQ_OP_ZONE_APPEND.



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

