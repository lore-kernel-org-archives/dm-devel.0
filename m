Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25ECFC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 757EF64DCE
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 757EF64DCE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-qe7c08BTOdq1LObHDnZBcQ-1; Thu, 28 Jan 2021 03:39:22 -0500
X-MC-Unique: qe7c08BTOdq1LObHDnZBcQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4550F100C663;
	Thu, 28 Jan 2021 08:39:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 24C0F5D9F4;
	Thu, 28 Jan 2021 08:39:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EC3F41809CA8;
	Thu, 28 Jan 2021 08:39:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7PL5x008400 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:25:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E5A0C2166B2C; Thu, 28 Jan 2021 07:25:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDFAC2166B2A
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:25:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4B65185A794
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:25:18 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-177-vfl-YEqiPb2GHt35-QH7Uw-1; Thu, 28 Jan 2021 02:25:15 -0500
X-MC-Unique: vfl-YEqiPb2GHt35-QH7Uw-1
IronPort-SDR: 1XO4jceGpXsh5IubGHdLerxe4aeG9SxsSlvvinyZ7xz57Mp/Yn2xXzprrhv/lGRMw7sD89FT+6
	0aDVxAiCPzDc65NGiWOiKo5gxtNSPZKz5mlSA/25VzwvVnfoogtEwKBkNuupemZT6VWxmBVgoz
	1kutj7VUKXVePpFPNy7xf0zdg+eN3kJwPBnQ3H0UcYQsyPV+WI7edJnh+Tc18j4bolIOp7HUx9
	V4l3St9H+gnv0HQImdqL8myuAw+VCjktcivp9mOSzOLzABQ8HsgpcL3yN2K451BrUxmzcCQRu1
	NX8=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="158518130"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:25:10 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by BL0PR04MB4852.namprd04.prod.outlook.com (2603:10b6:208:59::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15;
	Thu, 28 Jan 2021 07:25:08 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017;
	Thu, 28 Jan 2021 07:25:08 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com"
	<drbd-dev@tron.linbit.com>, "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org"
	<target-devel@vger.kernel.org>, "linux-fscrypt@vger.kernel.org"
	<linux-fscrypt@vger.kernel.org>, "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>, "linux-nilfs@vger.kernel.org"
	<linux-nilfs@vger.kernel.org>, "ocfs2-devel@oss.oracle.com"
	<ocfs2-devel@oss.oracle.com>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Thread-Topic: [RFC PATCH 28/34] zonefs: use bio_new
Thread-Index: AQHW9UVkomvF2vpeIk+EkJoBWTZvag==
Date: Thu, 28 Jan 2021 07:25:08 +0000
Message-ID: <BL0PR04MB651467E7A7C6EA542A435DC6E7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-29-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 571a2e12-0985-48c6-3f9d-08d8c35dd761
x-ms-traffictypediagnostic: BL0PR04MB4852:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB48526F818C0FABCE58FE358FE7BA9@BL0PR04MB4852.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3631
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 32W9x/cXloQ/0z7DAt7qSsx7G7lrDFeZKKnz06uUAgqmQA0gT3PPCEyknGB3ASTcaW8hMZsSv7e4qBntNlXUHbZ8XUAGPoKPUEg8L3NUMI7uFcJfpKllkC7jh907tv13wKROCFhzy3qIjUrr1qvxVNJbHg4AnaAu7Hd0n9BSJd6ltHb+lx6Kt1Bn0OufCV7+r+cTwGKhQjCwuKOs+4ysKSQ8sW8+mt0qxyYFn2M/rNCmGKkhY8zImLX2a4W554RAzTEia6eb4MM87+6pBC8w1Q2HNfvRcd39MixEiA1EUbkbySsl2l7XWBYBO5mzIk9WQ9arSlUleijKB3OzhzhTK6LyklxSc45/PlQXclMCdkFEDXw4Ertp1VGxUdGU8cRWvDhZS9EfEEXCIfXImgIiA9tufLH1CjNO2bVvXzP6PLtxkgtk9qCm5MMg8XrWcy13k6zxpm3w4mC4P9lE98bhvznAFUhPPMQYCtcaqGBVD8wVrEEVpyd7b42fgd6EvLNMLYC9H3silifIWz/Rg5TpNU9zXgVikI9bgP+aoGCiEFisN+if7JaPfhP5VriRPmet
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(186003)(66476007)(83380400001)(53546011)(5660300002)(66446008)(316002)(8676002)(71200400001)(66556008)(91956017)(86362001)(64756008)(6506007)(2906002)(66946007)(52536014)(7366002)(7406005)(9686003)(33656002)(110136005)(7416002)(55016002)(54906003)(4326008)(76116006)(7696005)(921005)(8936002)(478600001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KUYSxjXYfQyNkYu8LxobzslWgbRrh1Hl0zsXUUsbHOAiFNIp1CHkc7Nx0P0Z?=
	=?us-ascii?Q?86/TnX/TPZp6t3X6c/g7GjztYvohIOlICO4H8k7mNeR7y+CZ3BtbwC7PEo6W?=
	=?us-ascii?Q?HqJHIyObHou2BiSclkZegmCnVRenHuoXxGl5D73K00V1VymVtpakkO57xYsU?=
	=?us-ascii?Q?Ck0cY+BcGGROkuC2MoyqtVOpp/iltPkRzE6GJ9wDOX1598WYiKIvr2y+YmQ+?=
	=?us-ascii?Q?wQwbQRUTninVVh6zv6CkTTAfZTBHB090EUDht5aK+Fo6z/eRCqrS4IlOCGFq?=
	=?us-ascii?Q?498LbIthUnE3rks5RvI2V2xbSQzfsFQhY5vova5SXPsbG/TiZr8HjDcdE2oW?=
	=?us-ascii?Q?8BGJ9GFuH2UrnBhdHujwELLdv6L1T/WlR5cJq/tiDhld5tUhYHzFjjWvNE6c?=
	=?us-ascii?Q?I+VXBTmaxLP14RoKqfP5otrWi3wLf4bycUl7pkHG2CaWA7+0Ez531fX8rOvT?=
	=?us-ascii?Q?cwBmQi02GfJo21WpVkvrl8s38CKqH8j5qJewOxErbbHe0iDj02o7T820Cxzj?=
	=?us-ascii?Q?xCnk763l4wH0f6+ovzE1ZlF3iE7LNGxHlBwqoKcf39VHXx7/AAy1GrT22ApX?=
	=?us-ascii?Q?MgPXcNJ0iSVZtFkZFzM73MhFM1bOuiOO7NGIY/4aAWcEdzhZflqdsD+WsBkL?=
	=?us-ascii?Q?yp43gtW33O9bJEtWIvPn6iuK2yQ3bsRg283jdRUh6QLEtjciruqLGthtvhIy?=
	=?us-ascii?Q?s+Qcu4k/NE4d2HrVekBg/BxoUQUacAxI3FQJlsyVGEJY20k7Q9k0OMh9tvCp?=
	=?us-ascii?Q?qtaZtRNzfpvdZXte5TfUlQMxq5WV2WBBQqcSz1ND4HWP/deex/dHdrNwRKlk?=
	=?us-ascii?Q?djYJIdTki4xpkR5Xk97EgRFyZ8k35H0GsnLJuHCvt6gVnkwWsZ+ztFnhpOd/?=
	=?us-ascii?Q?Y0xM6YlGj/6zQRgzmDTOlwzdb/zAxqF+vxvcQn6Fv/iysP57q5ld+v5t6054?=
	=?us-ascii?Q?LtNzFHBIocUBaYhhkclP8GsmoPTepXiqTfUXqM+B+fDDX1DL9mTRkt9y9Qak?=
	=?us-ascii?Q?Nh8TG/F+F4jszRp6q+6wcfEuAiihnLxXxfrviLvmh8gYVfagv93E5lxVVktd?=
	=?us-ascii?Q?hXXp0Bqmg9I+K4jbZwyXDH49F3B4s9kYdbA1Xhg2QrjeOTNP7nU4t9UFW+4p?=
	=?us-ascii?Q?Jw/JubtNhiONkVlxC0ibXm51hfwOkfGG6g=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 571a2e12-0985-48c6-3f9d-08d8c35dd761
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 07:25:08.3693 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p2LVRo+jq8H43Yomo5AbZnE8GRpz0qPYcTtqFQS+Wx0lj+olf9/bMCZK+x9/8XOA2sWiiRbuHCzb/zC8+GMypw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4852
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10S7PL5x008400
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 28 Jan 2021 03:38:54 -0500
Cc: "shaggy@kernel.org" <shaggy@kernel.org>,
	"sergey.senozhatsky.work@gmail.com" <sergey.senozhatsky.work@gmail.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>, "tiwai@suse.de" <tiwai@suse.de>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"gustavoars@kernel.org" <gustavoars@kernel.org>,
	"joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>,
	"pavel@ucw.cz" <pavel@ucw.cz>,
	"alex.shi@linux.alibaba.com" <alex.shi@linux.alibaba.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"mark@fasheh.com" <mark@fasheh.com>, "osandov@fb.com" <osandov@fb.com>,
	"ebiggers@kernel.org" <ebiggers@kernel.org>,
	"ngupta@vflare.org" <ngupta@vflare.org>,
	"len.brown@intel.com" <len.brown@intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"jefflexu@linux.alibaba.com" <jefflexu@linux.alibaba.com>,
	"jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "jth@kernel.org" <jth@kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"rjw@rjwysocki.net" <rjw@rjwysocki.net>,
	"philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
	"minchan@kernel.org" <minchan@kernel.org>, "tj@kernel.org" <tj@kernel.org>,
	"lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
	"roger.pau@citrix.com" <roger.pau@citrix.com>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>,
	"jlbec@evilplan.org" <jlbec@evilplan.org>
Subject: Re: [dm-devel] [RFC PATCH 28/34] zonefs: use bio_new
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/01/28 16:15, Chaitanya Kulkarni wrote:
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>  fs/zonefs/super.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index ab68e27bb322..620d67965a22 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -661,6 +661,7 @@ static const struct iomap_dio_ops zonefs_write_dio_ops = {
>  
>  static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
>  {
> +	unsigned int op = REQ_OP_ZONE_APPEND | REQ_SYNC | REQ_IDLE;

I do not see the point of adding this variable since it is used only for the
bio_new() call. Pass the op value directly.

>  	struct inode *inode = file_inode(iocb->ki_filp);
>  	struct zonefs_inode_info *zi = ZONEFS_I(inode);
>  	struct block_device *bdev = inode->i_sb->s_bdev;
> @@ -678,15 +679,12 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
>  	if (!nr_pages)
>  		return 0;
>  
> -	bio = bio_alloc(GFP_NOFS, nr_pages);
> +	bio = bio_new(bdev, zi->i_zsector, op, 0, GFP_NOFS, nr_pages);
>  	if (!bio)
>  		return -ENOMEM;
>  
> -	bio_set_dev(bio, bdev);
> -	bio->bi_iter.bi_sector = zi->i_zsector;
>  	bio->bi_write_hint = iocb->ki_hint;
>  	bio->bi_ioprio = iocb->ki_ioprio;
> -	bio->bi_opf = REQ_OP_ZONE_APPEND | REQ_SYNC | REQ_IDLE;
>  	if (iocb->ki_flags & IOCB_DSYNC)
>  		bio->bi_opf |= REQ_FUA;
>  
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

