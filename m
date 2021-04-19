Return-Path: <SRS0=qgW3=JQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14C3C433ED
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 09:37:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 41CC161157
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 09:37:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41CC161157
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-4U1PpjyLPTOgxThIc0tKfg-1; Mon, 19 Apr 2021 05:37:38 -0400
X-MC-Unique: 4U1PpjyLPTOgxThIc0tKfg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73F0684B9AA;
	Mon, 19 Apr 2021 09:37:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 313871876A;
	Mon, 19 Apr 2021 09:37:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CA9041806D17;
	Mon, 19 Apr 2021 09:37:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13J9ZmBt029064 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Apr 2021 05:35:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F0E4D2182DF4; Mon, 19 Apr 2021 09:35:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9B322182DF3
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 09:35:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F822802C18
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 09:35:45 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-301-zZwpptPDMSGX8V_m1piwkA-1; Mon, 19 Apr 2021 05:35:40 -0400
X-MC-Unique: zZwpptPDMSGX8V_m1piwkA-1
IronPort-SDR: hplLCupomygUW4XTFwNVLOjXkk4yTxAxaOIh1xpcIKHDBJ6vAMJyG8+D2kRVYawTCTtaTmGE3E
	SbY/6H2Q8vCl0KdOkI0fxicthTy23/TzzsKxT+sQhUH53BXxlpKRWx6L58/6EKJpVVFtK5gsxG
	AF/6lgA6AP4sbwIJEygtYxNJQLU84iiP7I6lS5uzHaC/Fwh/D+wC9XKhLmwsXWEZbYSwfKrCvA
	+5Rs8n7Q91H/hp+lNuTJUEL1VnPqRVbRqglMt/vX0qcT1hcI2CNzm2YW07qXaD0uscFXJcddYe
	MJU=
X-IronPort-AV: E=Sophos;i="5.82,233,1613404800"; d="scan'208";a="165974672"
Received: from mail-dm6nam12lp2175.outbound.protection.outlook.com (HELO
	NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.175])
	by ob1.hgst.iphmx.com with ESMTP; 19 Apr 2021 17:35:39 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (52.135.46.87) by
	MN2PR04MB7039.namprd04.prod.outlook.com (10.186.147.137) with Microsoft
	SMTP
	Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4042.18; Mon, 19 Apr 2021 09:35:37 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78%3]) with mapi id 15.20.4042.024;
	Mon, 19 Apr 2021 09:35:37 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: "hch@infradead.org" <hch@infradead.org>, "dsterba@suse.cz"
	<dsterba@suse.cz>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik
	<josef@toxicpanda.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Naohiro Aota
	<Naohiro.Aota@wdc.com>
Thread-Topic: [PATCH 3/4] btrfs: zoned: fail mount if the device does not
	support zone append
Thread-Index: AQHXMm1j7e+Wo1nHt0KL4N4KN5ZXHw==
Date: Mon, 19 Apr 2021 09:35:37 +0000
Message-ID: <BL0PR04MB651459AE484861FD4EA20669E7499@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210416030528.757513-1-damien.lemoal@wdc.com>
	<20210416030528.757513-4-damien.lemoal@wdc.com>
	<20210416161720.GA7604@twin.jikos.cz>
	<20210419092855.GA3223318@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:d019:11b6:a627:87d8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b539474-0490-4a3a-d5bd-08d903167d20
x-ms-traffictypediagnostic: MN2PR04MB7039:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB703970456CCF5EC78D38EFCAE7499@MN2PR04MB7039.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: RvnMZB6zkIDWqR3vM7k6GER72fv5eyeHwoTWklKHOwa3NoxPNVKWRoc+H0dDr93XpKNYBEwTQplEVfBWnWKjRBcJueg+JjGqO+Y/7yZgPAPlUj26xr+hIYIiUdiMEEtrtvqbdgJ7RY5EGSE9Tvd0euEWyh5DNCtqo1TqwllxgbkK5BdwKEKKSU0eGEeS3NH2mJLjDJAjs5iUb9t+zGppIz6lM1AmT4mPVvNO+9fTHtmgzgDOJbIxRkL93ClBDreovnivOKtLpRdduupBGaZHX55nLAkIH7UA+yGUt6/qvNlOSk9pH9IL3JM3CaE+OrNSl4kQFXruycduQeB5d1kYPsmeqwU6NNySDT80oHir/0M/rO/KDfz1B6LVeOGtNbYcwk4txuzGdfFHxdwM71oyyouLTLvT9iQDpYOqmfnGTL8P06WSafzXdoVySCTyP+zZlp8g+TVrT+FSfgJTUKwZBY8C5ZpSdO0wGUbHDAGy1lEn/HnlB+frnzqgl7okCEVrVMzUwXKofS+ULEvoEH574LZyLHBct7vY2vIEUyZGnONH9unQ2UOa8IbugAs9NPgDS+ahj399+QBX88Z0ycCd5lHbB4pk6Nfo1VqnIFaFtQnLBPl9QbRePYq26f90+AjphdBtvwz7QYtS65neSB4O1w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(6636002)(76116006)(86362001)(91956017)(55016002)(33656002)(66556008)(9686003)(8936002)(66946007)(186003)(316002)(478600001)(110136005)(8676002)(66446008)(2906002)(66476007)(64756008)(71200400001)(921005)(5660300002)(38100700002)(122000001)(6506007)(7696005)(52536014)(53546011)(83380400001)(7416002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6EsK1XpSP/s9Xf0QvzFihInUqZOFsscYGSIegwkk9kxKSTjp9ShaUepGtY3W?=
	=?us-ascii?Q?flVfiSbyih6PDa7mF1X5C2ceV7LXE/T1XGxg59C/l/mfV/dd2WYUKhSif9t2?=
	=?us-ascii?Q?k5nF70AC+MmFq8mw0MJds9XqZnUsH99BSbJ1n4Y5JiRoN438p4sMRVb2DicK?=
	=?us-ascii?Q?ke8xi8kkVmhee+VzYo9Z02TO7hT6TlCv1G+mYi2V9mnoKdedHx2rnZh4jX4G?=
	=?us-ascii?Q?fFodD29TVXgtHDwEfvmwqKGi5ZEhFJeIr3lr3D49WzzM0y7myFIri8IjuqwD?=
	=?us-ascii?Q?KH8YGVZT0SBdO+dLVlrI7ShGy7N/xfuzoEg3lqrkWReSd0p2rQQw/EWEEelr?=
	=?us-ascii?Q?rW2uf8L2ecP99+S1prkWIDRHAs4HEnfemYz/f4cTAbuosOnzT4/45JvzVvNX?=
	=?us-ascii?Q?O7Hois6GrWYzFphaMYB4o9XVlbfjsH50T/v3w1IN8Bi58ptwGRSlnUI7EeL5?=
	=?us-ascii?Q?m7521W82zINAErzt6sP9ikwyhR66HmsEUY2ICHvIeVtmkf6vGwMscHGYzNjj?=
	=?us-ascii?Q?R8JHoIt+lJPNpTjM7NrgJywkJ/lVHI4z4zgOqPmrnXbb8dZs+I9/njJwJvcj?=
	=?us-ascii?Q?De/O7DH5xc7xm3evjLmT66P5S9/kXZiVyYZtKkj2M7CuBLNIXMK+nlVLKA7l?=
	=?us-ascii?Q?z4WW89R0ARv3r7Gb44PkHiQ1xJBYJBO2ZehVBDBKJkBqmqUhRpde8RXWDi7g?=
	=?us-ascii?Q?D8N4ltf3PlSGOdTGXNPpDkBeYfMU63OtcXK+R9rHTGEDuY3bCPuwCwVX9fMe?=
	=?us-ascii?Q?c6/2DfiMhm0TdWAZvUTAY8tQje4lfhP0gI/BOu//4StFOT0h+CDqQiYPYMuO?=
	=?us-ascii?Q?gMJX0WalRgl+LC3rK9TI6Y/WP4DWjr7l1awendABzWKwOtluCgmZjEOEca6n?=
	=?us-ascii?Q?mQftdQ8yryb0hNvrkTyq0Sd8CzjONjhU/i7Z3EmZ1v6almlZQe+iwZ6eOt2p?=
	=?us-ascii?Q?wt9ntpGmnBYCGJGQxh7C5ucsX1382Xw/MY53ltOLplG8ycwL4V9nK6owUTTZ?=
	=?us-ascii?Q?MdkjIymtJC+wI318fyGTMTuyXbiVMCZwMhVw7/7UHcqMI1V714GWdWbaoyMB?=
	=?us-ascii?Q?ie3xfmXy7ldFvg5Cr0fuA9B/qog2tD7D1EIhzLtv6bbFdz0N9ro/xtfVlL0U?=
	=?us-ascii?Q?UO99jqbAxsHmibnINUdswBBYoO09jaaiMQskTBvy3zJwREPlYPJKcOZniKTr?=
	=?us-ascii?Q?RVyV9NJvMvTICh73AV6HyOQ6hhicecup73jPG5P6yWzEpIgzo+HiCyCZPiqG?=
	=?us-ascii?Q?dqxf1TqOM4sm+lxsbvdMEXee+w7kxQFPiMdsGdVpR2X30qfi9axTVy5NqU0O?=
	=?us-ascii?Q?m3vrnuyKgKQo1ijmPHyls1uEnF2ty9pSLp4JQEWIBdhymHAX5V3+ABIUUUHD?=
	=?us-ascii?Q?3bbfK7EJ9tUWxTTUripDdME7KylLjsaANqZXDvPL66DifrqBNw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b539474-0490-4a3a-d5bd-08d903167d20
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2021 09:35:37.2396 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X5JPWFb4AFdDQmXWyS6K+qq8CYaeYTtmRHrm9VLi7mmkVvFXlEzeDe5gL9XMzmlL6bl3kcF6OTCQLI4SiPu89Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7039
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13J9ZmBt029064
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 3/4] btrfs: zoned: fail mount if the device
 does not support zone append
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

On 2021/04/19 18:29, Christoph Hellwig wrote:
> On Fri, Apr 16, 2021 at 06:17:21PM +0200, David Sterba wrote:
>> On Fri, Apr 16, 2021 at 12:05:27PM +0900, Damien Le Moal wrote:
>>> From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>>>
>>> For zoned btrfs, zone append is mandatory to write to a sequential write
>>> only zone, otherwise parallel writes to the same zone could result in
>>> unaligned write errors.
>>>
>>> If a zoned block device does not support zone append (e.g. a dm-crypt
>>> zoned device using a non-NULL IV cypher), fail to mount.
>>>
>>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>>
>> Added to misc-next, thanks. I'll queue it for 5.13, it's not an urgent
>> fix for 5.12 release but i'll tag it as stable so it'll apear in 5.12.x
>> later.
> 
> Please don't.  Zone append is a strict requirement for zoned devices,
> no need to add cargo cult code like this everywhere.

This is only to avoid someone from running zoned-btrfs on top of dm-crypt.
Without this patch, mount will be OK and file data writes will also actually be
OK. But all reads will miserably fail... I would rather have this patch in than
deal with the "bug reports" about btrfs failing to read files. No ?

Note that like you, I dislike having to add such code. But it was my oversight
when I worked on getting dm-crypt to work on zoned drives. Zone append was
overlooked at that time... My bad, really.


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

