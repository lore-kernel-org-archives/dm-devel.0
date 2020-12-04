Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D0CC4361A
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 11:26:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7145122581
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 11:26:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7145122581
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-9bRbhXmqO6ujElbmB4ddsw-1; Fri, 04 Dec 2020 06:26:35 -0500
X-MC-Unique: 9bRbhXmqO6ujElbmB4ddsw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A0C310054FF;
	Fri,  4 Dec 2020 11:26:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F5D160C6B;
	Fri,  4 Dec 2020 11:26:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 731FE4E58E;
	Fri,  4 Dec 2020 11:26:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B4BQRYx004868 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Dec 2020 06:26:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 126B220296B6; Fri,  4 Dec 2020 11:26:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C76E20296B5
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 11:26:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB844103B802
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 11:26:24 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-494-dF2ZrrGJN2uOBHbaXt4Syg-1; Fri, 04 Dec 2020 06:26:20 -0500
X-MC-Unique: dF2ZrrGJN2uOBHbaXt4Syg-1
IronPort-SDR: 8jaZBTanwCqy4mEbB/a3zGKcpVqfVH5bx6iG7Wq8QNK38OkBXLE7PCqQH2q3cT5HdQ8wDbUBNU
	KYm5fgTABi/muPEBYSpuEy4JdcSlcctHDNTV5gvcoj+codlgCJWN6TbODBcU7N768yUXrZY363
	IlgCEcK+J1Okid47UdncuWv157VXUU0Qj5YSaZbEw759vwsVNGXq/DxqWCG8DGiKnjCzdrEQGy
	olZRLhHFJ6UDPaE9X9Hv+e9qm/xCYixUZs7wbeZGghhNcUXfi5hDm/J7R1TFkyhSej136qe2NN
	dko=
X-IronPort-AV: E=Sophos;i="5.78,392,1599494400"; d="scan'208";a="264579782"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO
	NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
	by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2020 19:25:15 +0800
Received: from CH2PR04MB6522.namprd04.prod.outlook.com (2603:10b6:610:34::19)
	by CH2PR04MB6773.namprd04.prod.outlook.com (2603:10b6:610:95::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17;
	Fri, 4 Dec 2020 11:25:12 +0000
Received: from CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a]) by
	CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a%7]) with mapi id 15.20.3589.022;
	Fri, 4 Dec 2020 11:25:12 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: SelvaKumar S <selvakuma.s1@samsung.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>
Thread-Topic: [RFC PATCH v2 0/2] add simple copy support
Thread-Index: AQHWyiztcinYLb1afkCNvyh+SmI/oQ==
Date: Fri, 4 Dec 2020 11:25:12 +0000
Message-ID: <CH2PR04MB6522F1188557C829285ED5E8E7F10@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:5458:21bf:70ee:2847]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 365128f2-0c71-4214-0ced-08d8984743f0
x-ms-traffictypediagnostic: CH2PR04MB6773:
x-microsoft-antispam-prvs: <CH2PR04MB67733E8C5C03A26F94B188CAE7F10@CH2PR04MB6773.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: +i/280XiUrz7Lug2VI/UQ+rhTgH1eLdX9qrNyq1fcLfhCZggU92eS0kB6ASkXtijmebkc3PNPPnE+sIg0dtcCCYiq2MKn9kwKSgUH2Uee6vTMjScMWvP2lyalQjCepP5Rok4+nN1ucC3h8LqCLkwFklV0YFGgXvQRPecREAH359iJcxi35MdE8HkVS0+nkE1oFBX9T/6WJAxjsbNrU7lBPxC0JGwYw0DOVOD1nPkIQ3ImEZls2yrNBKmWKgJx0HsQvyGAWeVPrruHeP4QswAvMp8HoJ36/GR7nmM0DqMORXtIeFdBoW0rvQqTZB/nDL4g5j1henZGBdsoBCyXdkUnRnMi6UUxxp6nXqDDFo36k9y//MQSC7q9VIUXMs+PNC8kzwipMW7Rah/bnrajR440XBcb1jn2b2UXcvKICjqiA8ej6LEzzwKSvi+eRgDMoGuivJ2mout2R3onzjYtMzmpFx4XRnAF/flD+gBK0AYGks=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CH2PR04MB6522.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(110136005)(2906002)(8676002)(6506007)(5660300002)(53546011)(33656002)(478600001)(86362001)(66446008)(52536014)(64756008)(7696005)(71200400001)(966005)(66556008)(76116006)(66946007)(91956017)(4326008)(83380400001)(66476007)(316002)(186003)(7416002)(55016002)(8936002)(54906003)(9686003)(43620500001)(15398625002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?92oygtK7aS1igR7/5a/PDTPjAOGjsxYnwK4lz63sUia+HVGkJKDPgLjoKpTC?=
	=?us-ascii?Q?QO4JRkvSoiGxMlQcLIK9ym0x49gBki3hOpTADA56lSDhmGByu0fc1jag5tcv?=
	=?us-ascii?Q?BcFQd627ZxQPcIr9kMBkCk/vId217knnM4aftMJDrbnBFfAKtnMlMdFlPbyy?=
	=?us-ascii?Q?I9DxhQ4BQCROiRnRjqlr5iNXdTKwOAybqfMgkLywEOV+WFY8RMH3XTJltRUg?=
	=?us-ascii?Q?3hRsq96zY6uRoxQ/VxvB8+umlKVhZHOtYYvqHutwol2u0ow25XeicMUqo8sc?=
	=?us-ascii?Q?qm1R0Jcp8a0Ved4Fb6dx7WwbyA8uUf6Pdc2eMjikLC5N1qvZQT9EeE5mvhCE?=
	=?us-ascii?Q?XEPj6fqUDDROb8ca+eVnnMtDeCpxOme43zW+j6uKpblYcv34Z51OZAzwhP1f?=
	=?us-ascii?Q?2Kn2YUIZ/3V6i2DZOLITA6iXIk3YOpSQVVDOqLT+hgPtH8cAYV63rsxS708w?=
	=?us-ascii?Q?Irg/Fnq40ojNUDYMrNdO4W1m2P/tfrciCJcWEZ5VxXysfAxMO/RslBei42iv?=
	=?us-ascii?Q?wGOX5qJSO/gJiKPZ49ID4uvlAF7j5Sfjox6G9+cbB5T9jLH9ghEpriYH2qEh?=
	=?us-ascii?Q?yRj6mKgDuIC+soJ5zWvqJvQMT5bTg7vaO0kALYhvQmNJDsk8Y+mnYVQXOj6C?=
	=?us-ascii?Q?qLXY1RSi8N4wqMjCT506twF0saiJ9TFhU0wUr6IDqSOJOzLjzTE3ElglPVAl?=
	=?us-ascii?Q?HJBPcKjPfqz4iq9510Ibb8ykQxldKtInr2M+SBAq2INlZgV1rxVgZj5Pxuyp?=
	=?us-ascii?Q?ya9S3wqQt14hIaelj1V1y+MhCbnFNzh35bcJiCUArato/kyiZmHGjXtGjMTU?=
	=?us-ascii?Q?wYL5ivbeG5MrWL9XmqRZF5b4sm7ZF870eLlLDoPFOvCbGBo1eLWce7utEcSu?=
	=?us-ascii?Q?3CFt/Jivk/Y2U92zc3WAPz90yYjWX2ik/OBgZKLfRkqDuDRj+ket32iqcWv9?=
	=?us-ascii?Q?ZTh/DbJHyofohEUuJFqnDftHHVBjuKj4rh5x4X2rY166GoKJTP8l9NACA66o?=
	=?us-ascii?Q?4BFiHPbxtxRsUqMitxUc+umreS80gSv9yZ/UGoLrcX5XPfK6S3doq3ipoAEJ?=
	=?us-ascii?Q?8QvN5Wuk?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6522.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 365128f2-0c71-4214-0ced-08d8984743f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 11:25:12.1655 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JyxWB2Oe3jjtYFH1Ut9EdnYdm1bmjcp5idVZeopuDqXjNy6AFjBfCcQHpLXzjjG5f4LmVEqa0MI+YVUXAQCUrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6773
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B4BQRYx004868
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH v2 0/2] add simple copy support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2020/12/04 20:02, SelvaKumar S wrote:
> This patchset tries to add support for TP4065a ("Simple Copy Command"),
> v2020.05.04 ("Ratified")
> 
> The Specification can be found in following link.
> https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs-1.zip
> 
> This is an RFC. Looking forward for any feedbacks or other alternate
> designs for plumbing simple copy to IO stack.
> 
> Simple copy command is a copy offloading operation and is  used to copy
> multiple contiguous ranges (source_ranges) of LBA's to a single destination
> LBA within the device reducing traffic between host and device.
> 
> This implementation accepts destination, no of sources and arrays of
> source ranges from application and attach it as payload to the bio and
> submits to the device.
> 
> Following limits are added to queue limits and are exposed in sysfs
> to userspace
> 	- *max_copy_sectors* limits the sum of all source_range length
> 	- *max_copy_nr_ranges* limits the number of source ranges
> 	- *max_copy_range_sectors* limit the maximum number of sectors
> 		that can constitute a single source range.

Same comment as before. I think this is a good start, but for this to be really
useful to users and kernel components alike, this really needs copy emulation
for drives that do not have a native copy feature, similarly to what write zeros
handling for instance: if the drive does not have a copy command (simple copy
for NVMe or XCOPY for scsi), then the block layer should issue read/write
commands to seamlessly execute the copy. Otherwise, this will only serve a small
niche for users and will not be optimal for FS and DM drivers that could be
simplified with a generic block layer copy functionality.

This is my 10 cents though, others may differ about this.

> 
> Changes from v1:
> 
> 1. Fix memory leak in __blkdev_issue_copy
> 2. Unmark blk_check_copy inline
> 3. Fix line break in blk_check_copy_eod
> 4. Remove p checks and made code more readable
> 5. Don't use bio_set_op_attrs and remove op and set
>    bi_opf directly
> 6. Use struct_size to calculate total_size
> 7. Fix partition remap of copy destination
> 8. Remove mcl,mssrl,msrc from nvme_ns
> 9. Initialize copy queue limits to 0 in nvme_config_copy
> 10. Remove return in QUEUE_FLAG_COPY check
> 11. Remove unused OCFS
> 
> SelvaKumar S (2):
>   block: add simple copy support
>   nvme: add simple copy support
> 
>  block/blk-core.c          |  94 ++++++++++++++++++++++++++---
>  block/blk-lib.c           | 123 ++++++++++++++++++++++++++++++++++++++
>  block/blk-merge.c         |   2 +
>  block/blk-settings.c      |  11 ++++
>  block/blk-sysfs.c         |  23 +++++++
>  block/blk-zoned.c         |   1 +
>  block/bounce.c            |   1 +
>  block/ioctl.c             |  43 +++++++++++++
>  drivers/nvme/host/core.c  |  87 +++++++++++++++++++++++++++
>  include/linux/bio.h       |   1 +
>  include/linux/blk_types.h |  15 +++++
>  include/linux/blkdev.h    |  15 +++++
>  include/linux/nvme.h      |  43 ++++++++++++-
>  include/uapi/linux/fs.h   |  13 ++++
>  14 files changed, 461 insertions(+), 11 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

