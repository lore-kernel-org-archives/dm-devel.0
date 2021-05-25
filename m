Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56352C2B9F8
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 06:17:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B26E7613F5
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 06:17:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B26E7613F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-5IawIYC5MsaKTfiWndOZyQ-1; Tue, 25 May 2021 02:17:11 -0400
X-MC-Unique: 5IawIYC5MsaKTfiWndOZyQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C305F1007476;
	Tue, 25 May 2021 06:17:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9403C10023AC;
	Tue, 25 May 2021 06:17:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 117ED1801029;
	Tue, 25 May 2021 06:17:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14P6H4x9012603 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 02:17:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E8CBC2076364; Tue, 25 May 2021 06:17:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E35E9200BA92
	for <dm-devel@redhat.com>; Tue, 25 May 2021 06:17:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB64680D0E2
	for <dm-devel@redhat.com>; Tue, 25 May 2021 06:17:00 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-393-dCBjhst-MjuDxGITKc8n2Q-1; Tue, 25 May 2021 02:16:58 -0400
X-MC-Unique: dCBjhst-MjuDxGITKc8n2Q-1
IronPort-SDR: zE8nL6paKzQEyhUR4L/al16TXp8a9PKF23vpvdvhStPzS2o/WA9IHEjwG6L4s6WT4RnjjOU2aI
	Dtkdg5jpyjSPaOiOnTvaaX7VSDzvJ5ukz0pM+8Lrzzhb1zAa/DEWFYorfs7qLYhrayu4QN9kWE
	AX04TE8Q+hzoRk2Yrj/kYwJGotaBEG6c/hRAFa6iztmH/NwkDyir1v2+Way9QMZYBxDhSR2eHB
	jXYuWAigmq9swmEQgqOsVvdQrZJ0lsT9ES4my8f5wrpVw0zH2LJH3pzIWC9NAp8iFGEetncNwW
	4Wo=
X-IronPort-AV: E=Sophos;i="5.82,327,1613404800"; d="scan'208";a="280621378"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO
	NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
	by ob1.hgst.iphmx.com with ESMTP; 25 May 2021 14:15:53 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (52.135.233.89) by
	SJ0PR04MB7456.namprd04.prod.outlook.com (20.181.254.203) with Microsoft
	SMTP
	Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4150.27; Tue, 25 May 2021 06:15:53 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4150.027;
	Tue, 25 May 2021 06:15:53 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH v4 01/11] block: improve handling of all zones reset
	operation
Thread-Index: AQHXUQ1F6jb1VNqY+kaEwGILkKYOng==
Date: Tue, 25 May 2021 06:15:53 +0000
Message-ID: <BYAPR04MB496571E36CF14B9647FDD21186259@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210525022539.119661-1-damien.lemoal@wdc.com>
	<20210525022539.119661-2-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.175.137.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0e4a19a-96b7-4c37-0681-08d91f448ce8
x-ms-traffictypediagnostic: SJ0PR04MB7456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR04MB745669D9E3103C0D836AEF7C86259@SJ0PR04MB7456.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: eza9Ygdx0Sv/i7MpKlo2hp233kDPfYKw55D7tyVs8JwpowqQOERKlNlUw9ok3jGD6i9UPbMe/gPjyhIpgZ4kGUKHlHylMZW8kD1CT66hkB4OWHFm+q3ECTZClUtRrLjChcZzjwRz6CqlEZywxvV5Wsv3XpbfZOKuR/yTpiHQivtqPVlTSFoWUh9sVE3L0rzjhEW3Q8z7cM5meg0PTG1bA2j8+Fq6msS+GPCXzTfX3jLab+Bax38syBX6+GTSnr9ddXnPL7RNtx/1ouxv4FsG3vxoYKLnmolyz8V2/3kLVwvxRtDqknva1WD6dRnTb9lm4xFFTyGucEQqudACSzMUY6phLJAVKmqPFmWojxkVJSEgB1kuKeoe88B//gLyADOGY9X4gF04r1CzjRAgw2fgmLzWDNbWAAVsmlm4wKoCTvBjdz6D2wampM4FhC2a68zui0HZGFvqciI70pSgTDfVsE8JvEH5CojXImHgNcgzN0J5RUF4iYoU3dVhSPbaTQpxNqzDNTyHFA5ZUfmGqJ8oqshzYGlpcDXeekTNNaGQ95v48PaDZPUA4Aj1kZGZGHtJ/EA2e/zNmNlx53bN7Jh8zeh646ohDdFqqSSNzyb5Jk4=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(396003)(39850400004)(136003)(366004)(376002)(66476007)(76116006)(66446008)(66946007)(9686003)(8936002)(64756008)(66556008)(71200400001)(86362001)(186003)(478600001)(110136005)(7696005)(6506007)(52536014)(8676002)(5660300002)(122000001)(83380400001)(38100700002)(2906002)(55016002)(26005)(33656002)(53546011)(316002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CCi9eMi55+ucK60Xe6tQIjV7D3Bn55zr2W4J7BdyFYInd1KV7A9kPJcieabV?=
	=?us-ascii?Q?AX5GTmK4Yn4GDxCygV31UKA/h1C5zoXiR3FXK4rB87JnIPM0doTVmxNvUEfG?=
	=?us-ascii?Q?UlwR2S1/dwd4/eMr+BW82wfmNJG4NG+6/Bws8VULPrz+pYYKDYRH5r950sVI?=
	=?us-ascii?Q?HyLP759i1jfSknMdVpmPhUdtyxG2O4UdwYovC7k15tHGN2cp3HK5A8BGfGUZ?=
	=?us-ascii?Q?rS7Lfdvgki/W3YIELguqcoyvH/1/lcMxCOJTrJ2usuClE0E5F0ADE1BjO9no?=
	=?us-ascii?Q?wVa9AL58WZ+zQQ6qQwqTwdf//TPiAXdlmMmewnJUu6f4duJ2MNQb85XMzj14?=
	=?us-ascii?Q?DUvfDuLw+nbA41tez+bad/iqYRXJZZKGhKRIqkP+iRLueAM9LF+U1hkrGyqi?=
	=?us-ascii?Q?BdxQcd7g5egPVwVy8mJ1C0Qr3kTdJI0Kt5Rvb3mGDZ68ysPU4XDMIl/VPKXQ?=
	=?us-ascii?Q?DrWDWlaeinT7X/KvD5TWwJdxKNBwAePlw7+hbf5rJmF+Bd2pJUFca7gtAUjs?=
	=?us-ascii?Q?XUGLxl17VCae19NotRgNYXvGkV9xidmvRSThgjJxbmYtfnmooPgjUw7va/fk?=
	=?us-ascii?Q?u9hmHPP5p2It1cepAs63WWV9uaE7cARXiLMeegjzKoPdUcAycrAnE2xqlUSx?=
	=?us-ascii?Q?QG7uIe9+tW+ug+rKypWCJIH5lujTZVJx/mD5J6WHvDgUR9qIL6r+6P+n3RiF?=
	=?us-ascii?Q?0/3nMay9UKBsxumpLkC5zz980gEVAQYBaAdvZ6Ts2IGfTnL3QU0ttUK/lpEt?=
	=?us-ascii?Q?DDypFSGXF0/u+0/vk6tbfUqKRApCi2aNWNlLgzvTJcWeAD43euMjdYe6FysD?=
	=?us-ascii?Q?QU3o8jmshlEMs3HVaDHPBvBSUc32JQGhG1AKdDYAYTrXEJST67uU9ZhXcL4o?=
	=?us-ascii?Q?f4k3f/Vuo9T3lJ1W498kDPeKZPCq9L5YNOEe2RUfT/H2So47ZGYVUCkY3uZa?=
	=?us-ascii?Q?dn5fDLLoP67QC9u68fM4IBPDeT8bLWSMbRnLeYo/I2UMZ4i2Y+RQYMNpsT1A?=
	=?us-ascii?Q?bCfIwvVtrnxH8U+YyKYTeejXDxFehWa+GFCsreQbsGCPViGYcr9UYg0Y/I9k?=
	=?us-ascii?Q?CHXQkIreK714Y2kiiYYKRfUIpepK3FE/jA2sdEfpI2l+9z0FiiKMZwP6FRG0?=
	=?us-ascii?Q?bfw1qRkmQqCXG9FLmrTbHotO7VUausWCadz215c2INeFB3cdxLvjpFM2dGY4?=
	=?us-ascii?Q?mRDsOr00gp7EYhgZ9VtkM7xh3iQp7ZNI+jLCM11wgXJy4dVMjtW7p0ejTVb1?=
	=?us-ascii?Q?ItYHZwmB08tHS05VXyTWLL5QHk1FpH186avgHwJNY9KyQw0KFhqopa0ZZKk7?=
	=?us-ascii?Q?3jPsBoOY7WJ8duAvCPVeaCm8w52u1HPmeuUn0xken51mAg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0e4a19a-96b7-4c37-0681-08d91f448ce8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 06:15:53.0200 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cu7XPUYRsL2MX8G3JpLimFKVNjIz55bYjJARvXcwwiGVGrneWOp3GmR+8Vd35nTT3sIjMczIegLzdwHfAo20dbxJuySzn+5sKQEpRqSWl9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7456
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14P6H4x9012603
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v4 01/11] block: improve handling of all
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/24/21 7:25 PM, Damien Le Moal wrote:
> SCSI, ZNS and null_blk zoned devices support resetting all zones using
> a single command (REQ_OP_ZONE_RESET_ALL), as indicated using the device
> request queue flag QUEUE_FLAG_ZONE_RESETALL. This flag is not set for
> device mapper targets creating zoned devices. In this case, a user
> request for resetting all zones of a device is processed in
> blkdev_zone_mgmt() by issuing a REQ_OP_ZONE_RESET operation for each
> zone of the device. This leads to different behaviors of the
> BLKRESETZONE ioctl() depending on the target device support for the
> reset all operation. E.g.
>
> blkzone reset /dev/sdX
>
> will reset all zones of a SCSI device using a single command that will
> ignore conventional, read-only or offline zones.
>
> But a dm-linear device including conventional, read-only or offline
> zones cannot be reset in the same manner as some of the single zone
> reset operations issued by blkdev_zone_mgmt() will fail. E.g.:
>
> blkzone reset /dev/dm-Y
> blkzone: /dev/dm-0: BLKRESETZONE ioctl failed: Remote I/O error
>
> To simplify applications and tools development, unify the behavior of
> the all-zone reset operation by modifying blkdev_zone_mgmt() to not
> issue a zone reset operation for conventional, read-only and offline
> zones, thus mimicking what an actual reset-all device command does on a
> device supporting REQ_OP_ZONE_RESET_ALL. This emulation is done using
> the new function blkdev_zone_reset_all_emulated(). The zones needing a
> reset are identified using a bitmap that is initialized using a zone
> report. Since empty zones do not need a reset, also ignore these zones.
> The function blkdev_zone_reset_all() is introduced for block devices
> natively supporting reset all operations. blkdev_zone_mgmt() is modified
> to call either function to execute an all zone reset request.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> [hch: split into multiple functions]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Apart from nit mentioned earlier, looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

